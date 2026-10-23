import subprocess
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).with_name('collect_evidence.py')


class CollectEvidenceTest(unittest.TestCase):
  def test_reads_current_knowledge_base_evaluation_standard(self):
    with tempfile.TemporaryDirectory() as temp_dir:
      root = Path(temp_dir)
      project = root / 'project'
      framework = root / 'knowledge-base'
      project.mkdir()
      (framework / 'docs').mkdir(parents=True)
      (framework / 'evals').mkdir()
      (framework / 'templates').mkdir()
      (framework / 'docs' / 'evaluation-standard.md').write_text(
        '# Evaluation standard\n'
        '### 1. 任务与自主性\n'
        '### 2. 上下文\n'
        '### 3. 架构约束\n'
        '### 4. 熵管理\n'
        '### 5. 安全\n'
        '### 6. 测试与验证\n'
        '### 7. CI/CD\n'
        '### 8. Agent 编排\n'
        '### 9. 透明度与可复现性\n',
        encoding='utf-8',
      )
      (framework / 'docs' / 'principles.md').write_text('# Principles\n', encoding='utf-8')
      (framework / 'docs' / 'maintenance.md').write_text('# Maintenance\n', encoding='utf-8')
      (framework / 'evals' / 'holdout.md').write_text('# Holdout\n', encoding='utf-8')
      (framework / 'templates' / 'evaluation-report.md').write_text('# Report\n', encoding='utf-8')

      result = subprocess.run(
        [
          'python3',
          str(SCRIPT),
          str(project),
          '--framework-dir',
          str(framework),
          '--skip-global',
        ],
        check=False,
        capture_output=True,
        text=True,
      )

      self.assertEqual(result.returncode, 0, result.stderr)
      self.assertIn('维度数：9', result.stdout)
      self.assertIn('1 任务与自主性', result.stdout)
      self.assertIn('9 透明度与可复现性', result.stdout)

  def test_collects_framework_and_project_evidence_without_secret_values(self):
    with tempfile.TemporaryDirectory() as temp_dir:
      root = Path(temp_dir)
      project = root / 'project'
      framework = root / 'knowledge-base'
      (project / '.codex').mkdir(parents=True)
      (project / '.github' / 'workflows').mkdir(parents=True)
      (framework / 'docs').mkdir(parents=True)
      (framework / 'evals').mkdir()
      (framework / 'templates').mkdir()

      (project / 'AGENTS.md').write_text('# 项目约束\n', encoding='utf-8')
      (project / '.codex' / 'config.toml').write_text(
        "sandbox_mode = 'workspace-write'\napi_token = 'top-secret-value'\n",
        encoding='utf-8',
      )
      (project / '.github' / 'workflows' / 'ci.yml').write_text(
        'name: CI\n',
        encoding='utf-8',
      )
      (framework / 'docs' / 'evaluation-standard.md').write_text(
        '# Evaluation standard\n'
        '### 1. 任务与自主性\n'
        '### 2. 上下文\n',
        encoding='utf-8',
      )
      (framework / 'docs' / 'principles.md').write_text('# Principles\n', encoding='utf-8')
      (framework / 'docs' / 'maintenance.md').write_text('# Maintenance\n', encoding='utf-8')
      (framework / 'evals' / 'holdout.md').write_text('# Holdout\n', encoding='utf-8')
      (framework / 'templates' / 'evaluation-report.md').write_text('# Report\n', encoding='utf-8')

      result = subprocess.run(
        [
          'python3',
          str(SCRIPT),
          str(project),
          '--framework-dir',
          str(framework),
          '--skip-global',
        ],
        check=False,
        capture_output=True,
        text=True,
      )

      self.assertEqual(result.returncode, 0, result.stderr)
      self.assertIn('维度数：2', result.stdout)
      self.assertIn('1 任务与自主性', result.stdout)
      self.assertIn('2 上下文', result.stdout)
      self.assertIn('AGENTS.md:1', result.stdout)
      self.assertIn("sandbox_mode = 'workspace-write'", result.stdout)
      self.assertIn("api_token = '<redacted>'", result.stdout)
      self.assertNotIn('top-secret-value', result.stdout)

  def test_rejects_missing_project(self):
    result = subprocess.run(
      ['python3', str(SCRIPT), '/path/that/does/not/exist'],
      check=False,
      capture_output=True,
      text=True,
    )

    self.assertEqual(result.returncode, 2)
    self.assertIn('项目目录不存在', result.stderr)


if __name__ == '__main__':
  unittest.main()
