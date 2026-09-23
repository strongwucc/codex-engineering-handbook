'use strict';

const assert = require('node:assert/strict');
const path = require('node:path');
const { test } = require('node:test');

const workspacePath = process.env.CORE_WORKSPACE || path.resolve(__dirname, '../..', 'core-v1');
const { findLowStock } = require(path.join(workspacePath, 'src', 'inventory.js'));

test('findLowStock includes items exactly at the threshold', () => {
  const items = [
    { sku: 'A-100', quantity: 8 },
    { sku: 'B-200', quantity: 3 },
    { sku: 'C-300', quantity: 0 }
  ];
  const originalItems = items.map((item) => ({ ...item }));
  const result = findLowStock(items, 3);

  assert.deepEqual(result.map((item) => item.sku), ['B-200', 'C-300']);
  assert.notEqual(result[0], items[1]);
  assert.deepEqual(items, originalItems);
});
