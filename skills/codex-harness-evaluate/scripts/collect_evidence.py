#!/usr/bin/env python3
import argparse
import os
import re
import sys
from pathlib import Path
from typing import Iterable, List, Sequence, Tuple


DEFAULT_FRAMEWORK_DIR = Path(
  '/Users/chuanchuan/Work/codex'
)
EXCLUDED_PARTS = {
  '.git',
  '.idea',
  '.output',
  '.turbo',
  '.vscode',
  'build',
  'coverage',
  'dist',
  'node_modules',
  'storage',
  'vendor',
}
SENSITIVE_KEY = re.compile(
  r'(?i)(api[_-]?key|authorization|credential|password|private[_-]?key|secret|token)'
)
SAFE_CONFIG_KEY = re.compile(
  r'^\s*(approval_policy|approvals_reviewer|model|model_reasoning_effort|'
  r'network_access|sandbox_mode|trust_level|web_search)\s*='
)
CONFIG_SECTION = re.compile(
  r'^\s*\[(features|hooks|permissions(?:\.[^]]+)?|projects(?:\.[^]]+)?|sandbox_workspace_write)\]\s*$'
)
TEXT_SUFFIXES = {'.json', '.md', '.toml', '.yaml', '.yml'}


def parse_args() -> argparse.Namespace:
  parser = argparse.ArgumentParser(
    description='只读收集 Codex Harness 评估证据，不执行评分。',
  )
  parser.add_argument('project', help='待评估项目目录')
  parser.add_argument(
    '--framework-dir',
    default=str(DEFAULT_FRAMEWORK_DIR),
    help='Codex Harness 工程框架目录',
  )
  parser.add_argument(
    '--skip-global',
    action='store_true',
    help='不扫描用户级 Codex 配置',
  )
  return parser.parse_args()


def fail(message: str) -> None:
  print(message, file=sys.stderr)
  raise SystemExit(2)


def read_lines(path: Path) -> List[str]:
  try:
    return path.read_text(encoding='utf-8', errors='replace').splitlines()
  except OSError:
    return []


def is_included(path: Path) -> bool:
  return not any(part in EXCLUDED_PARTS for part in path.parts)


def relative_label(path: Path, project: Path) -> str:
  try:
    return str(path.relative_to(project))
  except ValueError:
    return str(path)


def redact_config_line(line: str) -> str:
  key = line.split('=', 1)[0].strip() if '=' in line else line
  if SENSITIVE_KEY.search(key):
    return f"{key} = '<redacted>'"
  return line.strip()


def config_evidence(path: Path, project: Path) -> List[str]:
  evidence = []
  active_section = ''
  for line_number, line in enumerate(read_lines(path), start=1):
    section = CONFIG_SECTION.match(line)
    if section:
      active_section = section.group(1)
      evidence.append(
        f'{relative_label(path, project)}:{line_number} | {line.strip()}'
      )
      continue

    stripped = line.strip()
    if not stripped or stripped.startswith('#') or '=' not in stripped:
      continue

    key = stripped.split('=', 1)[0].strip()
    if SAFE_CONFIG_KEY.match(line) or active_section in {
      'features',
      'sandbox_workspace_write',
    } or SENSITIVE_KEY.search(key):
      evidence.append(
        f'{relative_label(path, project)}:{line_number} | '
        f'{redact_config_line(line)}'
      )
  return evidence


def matching_lines(
  path: Path,
  project: Path,
  patterns: Sequence[re.Pattern],
  limit: int = 12,
) -> List[str]:
  evidence = []
  for line_number, line in enumerate(read_lines(path), start=1):
    if any(pattern.search(line) for pattern in patterns):
      excerpt = line.strip()
      if SENSITIVE_KEY.search(excerpt):
        excerpt = '<sensitive line redacted>'
      evidence.append(
        f'{relative_label(path, project)}:{line_number} | {excerpt[:240]}'
      )
      if len(evidence) >= limit:
        break
  return evidence


def find_files(root: Path, names: Iterable[str]) -> List[Path]:
  wanted = set(names)
  return sorted(
    path
    for path in root.rglob('*')
    if path.is_file() and path.name in wanted and is_included(path)
  )


def find_matching_paths(root: Path, patterns: Sequence[str]) -> List[Path]:
  found = []
  for pattern in patterns:
    found.extend(path for path in root.glob(pattern) if path.is_file())
  return sorted(set(found))


def path_inventory(paths: Sequence[Path], project: Path, limit: int = 40) -> List[str]:
  return [f'{relative_label(path, project)}:1' for path in paths[:limit]]


def framework_metadata(framework: Path) -> List[Tuple[str, str]]:
  standard = framework / 'docs' / 'evaluation-standard.md'
  required = [
    framework / 'docs' / 'principles.md',
    framework / 'docs' / 'maintenance.md',
    framework / 'evals' / 'holdout.md',
    framework / 'templates' / 'evaluation-report.md',
    standard,
  ]
  missing = [path for path in required if not path.is_file()]
  if missing:
    fail('知识库文件缺失：' + ', '.join(str(path) for path in missing))

  lines = read_lines(standard)
  dimensions = []
  for line in lines:
    dimension_match = re.match(r'^###\s+(\d+)\.\s*(.+)$', line)
    if dimension_match:
      dimensions.append((dimension_match.group(1), dimension_match.group(2).strip()))

  if not dimensions:
    fail(f'评估维度解析失败：{standard}')
  return dimensions


def collect_project(project: Path) -> List[Tuple[str, List[str]]]:
  sections = []
  agent_files = find_files(project, {'AGENTS.md'})
  agent_evidence = []
  heading_pattern = re.compile(r'^#{1,4}\s+')
  for path in agent_files:
    agent_evidence.extend(matching_lines(path, project, [heading_pattern], limit=20))
  sections.append(('项目指南', agent_evidence or path_inventory(agent_files, project)))

  project_configs = find_matching_paths(
    project,
    ['.codex/config.toml', '.codex/hooks.json', '.codex/agents/*.toml'],
  )
  config_lines = []
  for path in project_configs:
    if path.suffix == '.toml':
      config_lines.extend(config_evidence(path, project))
    else:
      config_lines.extend(path_inventory([path], project))
  sections.append(('项目 Codex 配置', config_lines))

  gate_names = {
    'composer.json',
    'eslint.config.js',
    'eslint.config.mjs',
    'lefthook.yml',
    'oxlint.config.ts',
    'package.json',
    'phpstan.neon',
    'phpunit.xml',
    'pint.json',
    'vitest.config.ts',
  }
  gate_files = find_files(project, gate_names)
  gate_patterns = [
    re.compile(r'(?i)\b(arch|eslint|lint|oxlint|phpstan|pint|test|typecheck|type-check|vitest)\b'),
  ]
  gate_lines = []
  for path in gate_files[:30]:
    gate_lines.extend(matching_lines(path, project, gate_patterns, limit=8))
  sections.append(('确定性门禁', gate_lines or path_inventory(gate_files, project)))

  ci_files = find_matching_paths(
    project,
    ['.github/workflows/*.yml', '.github/workflows/*.yaml', '.workflow/*.yml', '.gitlab-ci.yml'],
  )
  ci_lines = []
  for path in ci_files:
    ci_lines.extend(matching_lines(path, project, gate_patterns, limit=20))
  sections.append(('CI/CD', ci_lines or path_inventory(ci_files, project)))

  test_files = sorted(
    path
    for path in project.rglob('*')
    if path.is_file()
    and is_included(path)
    and (
      'test' in path.name.lower()
      or 'spec' in path.name.lower()
      or 'tests' in {part.lower() for part in path.parts}
    )
    and path.suffix.lower() in TEXT_SUFFIXES.union({'.php', '.py', '.ts', '.tsx'})
  )
  sections.append(('测试样本', path_inventory(test_files, project)))

  docs = find_matching_paths(
    project,
    [
      'docs/adr/*.md',
      'docs/*CONTEXT*.md',
      'docs/**/*decision*.md',
      'scripts/entropy/*',
      '.harness-evaluations/*.md',
    ],
  )
  sections.append(('上下文与熵管理', path_inventory(docs, project)))
  return sections


def collect_global(project: Path) -> List[Tuple[str, List[str]]]:
  codex_home = Path(os.environ.get('CODEX_HOME', str(Path.home() / '.codex'))).expanduser()
  if not codex_home.is_dir():
    return [('用户级 Codex 配置', [f'{codex_home} | 不存在'])]

  config_paths = [codex_home / 'config.toml', codex_home / 'hooks.json']
  config_paths.extend(sorted(codex_home.glob('*.config.toml')))
  config_lines = []
  for path in config_paths:
    if not path.is_file():
      continue
    if path.suffix == '.toml':
      config_lines.extend(config_evidence(path, project))
    else:
      config_lines.extend(path_inventory([path], project))

  capability_paths = []
  for pattern in ('agents/*.toml', 'prompts/*.md', 'skills/*/SKILL.md'):
    capability_paths.extend(path for path in codex_home.glob(pattern) if path.is_file())
  return [
    ('用户级 Codex 配置', config_lines),
    ('用户级 Agents/Prompts/Skills', path_inventory(sorted(capability_paths), project)),
  ]


def print_section(title: str, lines: Sequence[str]) -> None:
  print(f'## {title}')
  if not lines:
    print('- 未发现机械证据')
  else:
    for line in lines[:80]:
      print(f'- {line}')
  print()


def main() -> None:
  args = parse_args()
  project = Path(args.project).expanduser().resolve()
  framework = Path(args.framework_dir).expanduser().resolve()
  if not project.is_dir():
    fail(f'项目目录不存在：{project}')
  if not framework.is_dir():
    fail(f'框架目录不存在：{framework}')

  dimensions = framework_metadata(framework)
  print('# Codex Harness 证据清单')
  print()
  print(f'- 项目：{project}')
  print(f'- 评估标准：{framework / "docs" / "evaluation-standard.md"}')
  print(f'- 维度数：{len(dimensions)}')
  print('- 模式：只读；配置敏感值已脱敏；本脚本不评分')
  print()
  print('## 动态维度')
  for identifier, title in dimensions:
    print(f'- {identifier} {title}')
  print()

  for title, lines in collect_project(project):
    print_section(title, lines)
  if not args.skip_global:
    for title, lines in collect_global(project):
      print_section(title, lines)


if __name__ == '__main__':
  main()
