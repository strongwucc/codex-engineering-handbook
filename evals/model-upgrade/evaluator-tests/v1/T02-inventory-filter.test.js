'use strict';

const assert = require('node:assert/strict');
const path = require('node:path');
const { test } = require('node:test');

const workspacePath = process.env.CORE_WORKSPACE || path.resolve(__dirname, '../..', 'core-v1');
const { filterInventory } = require(path.join(workspacePath, 'src', 'inventory.js'));

test('filterInventory combines normalized query and exact category without mutation', () => {
  const items = [
    { sku: 'A-100', name: 'Notebook', category: 'stationery', quantity: 8 },
    { sku: 'B-200', name: 'Marker', category: 'writing', quantity: 3 },
    { sku: 'C-300', name: 'Notebook Cover', category: 'stationery', quantity: 4 }
  ];
  const originalItems = items.map((item) => ({ ...item }));
  const result = filterInventory(items, { query: '  NOTE ', category: 'stationery' });

  assert.deepEqual(result.map((item) => item.sku), ['A-100', 'C-300']);
  assert.notEqual(result, items);
  assert.notEqual(result[0], items[0]);
  assert.deepEqual(items, originalItems);
  assert.deepEqual(filterInventory(items, { query: ' b-200 ' }).map((item) => item.sku), ['B-200']);
  assert.deepEqual(filterInventory(items, { category: 'station' }), []);
});

test('filterInventory returns a copy when no filters are provided', () => {
  const items = [{ sku: 'A-100', name: 'Notebook', category: 'stationery', quantity: 8 }];
  const result = filterInventory(items);

  assert.deepEqual(result, items);
  assert.notEqual(result, items);
  assert.notEqual(result[0], items[0]);
});
