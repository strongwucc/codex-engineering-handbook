'use strict';

function listInventory(items) {
  return items.map((item) => ({ ...item }));
}

function adjustStock(items, sku, delta) {
  if (!Number.isInteger(delta)) {
    throw new TypeError('Stock delta must be an integer');
  }

  const index = items.findIndex((item) => item.sku === sku);
  if (index === -1) {
    throw new Error(`Unknown SKU: ${sku}`);
  }

  const updatedItems = listInventory(items);
  updatedItems[index].quantity += delta;
  return updatedItems;
}

function findLowStock(items, threshold) {
  return items
    .filter((item) => item.quantity < threshold)
    .map((item) => ({ ...item }));
}

function inventoryToCsv(items) {
  const columns = ['sku', 'name', 'category', 'quantity'];
  const rows = items.map((item) => columns.map((column) => item[column]).join(','));
  return [columns.join(','), ...rows].join('\n');
}

module.exports = {
  adjustStock,
  findLowStock,
  inventoryToCsv,
  listInventory
};
