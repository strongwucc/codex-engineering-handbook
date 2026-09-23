'use strict';

const assert = require('node:assert/strict');
const { test } = require('node:test');
const {
  adjustStock,
  findLowStock,
  inventoryToCsv,
  listInventory
} = require('../src/inventory.js');

function sampleInventory() {
  return [
    { sku: 'A-100', name: 'Notebook', category: 'stationery', quantity: 8 },
    { sku: 'B-200', name: 'Marker', category: 'writing', quantity: 3 },
    { sku: 'C-300', name: 'Folder', category: 'stationery', quantity: 0 }
  ];
}

test('listInventory returns copies without changing input', () => {
  const items = sampleInventory();
  const result = listInventory(items);

  assert.deepEqual(result, items);
  assert.notEqual(result, items);
  assert.notEqual(result[0], items[0]);
});

test('adjustStock returns an updated copy for an integer delta', () => {
  const items = sampleInventory();
  const result = adjustStock(items, 'A-100', 2);

  assert.equal(result[0].quantity, 10);
  assert.equal(items[0].quantity, 8);
  assert.notEqual(result, items);
});

test('adjustStock rejects unknown SKUs and non-integer deltas', () => {
  const items = sampleInventory();

  assert.throws(() => adjustStock(items, 'missing', 1), /unknown SKU/i);
  assert.throws(() => adjustStock(items, 'A-100', 1.5), TypeError);
  assert.equal(items[0].quantity, 8);
});

test('findLowStock returns copies below the threshold', () => {
  const items = sampleInventory();
  const result = findLowStock(items, 5);

  assert.deepEqual(result.map((item) => item.sku), ['B-200', 'C-300']);
  assert.notEqual(result[0], items[1]);
});

test('inventoryToCsv exports a header and ordinary rows', () => {
  const items = sampleInventory().slice(0, 1);

  assert.equal(
    inventoryToCsv(items),
    'sku,name,category,quantity\nA-100,Notebook,stationery,8'
  );
});
