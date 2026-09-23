'use strict';

const assert = require('node:assert/strict');
const path = require('node:path');
const { test } = require('node:test');

const workspacePath = process.env.CORE_WORKSPACE || path.resolve(__dirname, '../..', 'core-v1');
const { inventoryToCsv } = require(path.join(workspacePath, 'src', 'inventory.js'));

test('inventoryToCsv quotes special fields and doubles embedded quotes', () => {
  const items = [{
    sku: 'A,100',
    name: 'Folder "Plus"',
    category: 'office\rsupplies',
    quantity: 4
  }, {
    sku: 'B-200',
    name: 'Marker',
    category: 'office\nsupplies',
    quantity: 2
  }];

  assert.equal(
    inventoryToCsv(items),
    'sku,name,category,quantity\n"A,100","Folder ""Plus""","office\rsupplies",4\nB-200,Marker,"office\nsupplies",2'
  );
});

test('inventoryToCsv keeps the header for an empty inventory without a trailing newline', () => {
  assert.equal(inventoryToCsv([]), 'sku,name,category,quantity');
});
