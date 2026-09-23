# T02：增加库存筛选

为 `src/inventory.js` 增加并导出 `filterInventory(items, options = {})`。

- `options.query`（可选）先去除首尾空白，再以不区分大小写的子串方式匹配 SKU 或商品名称。
- `options.category`（可选）按类别精确匹配。
- 两种条件同时提供时取交集；都未提供时返回全部商品。
- 保持原顺序，不修改输入，并返回数组及商品对象的副本。

只实现以上行为，不添加依赖或修改其他 API。运行 `node --test` 检查工作副本。
