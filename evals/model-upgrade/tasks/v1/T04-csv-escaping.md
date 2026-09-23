# T04：正确转义库存 CSV

修复 `inventoryToCsv(items)` 的 CSV 字段转义。字段中含逗号、双引号、回车或换行时，整个字段必须用双引号包围，字段内每个双引号必须变成两个双引号。

保留现有列顺序 `sku,name,category,quantity`、LF 行分隔符和末尾无多余换行的行为；空列表仍应包含表头。运行 `node --test` 检查工作副本。
