#!/usr/bin/env node

'use strict';

process.on('unhandledRejection', err => {
  throw err;
});

const args = process.argv.slice(2);

console.log(args)
