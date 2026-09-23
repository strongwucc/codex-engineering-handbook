'use strict';

const assert = require('node:assert/strict');
const path = require('node:path');
const { test } = require('node:test');

const workspacePath = process.env.CORE_WORKSPACE || path.resolve(__dirname, '../..', 'core-v1');
const { adjustStock } = require(path.join(workspacePath, 'src', 'inventory.js'));

test('adjustStock rejects a negative resulting quantity without mutating input', () => {
  const items = [{ sku: 'A-100', quantity: 0 }];

  assert.throws(() => adjustStock(items, 'A-100', -1), RangeError);
  assert.equal(items[0].quantity, 0);
});
