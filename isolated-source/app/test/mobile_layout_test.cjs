const vm = require('node:vm');
const fs = require('node:fs');
const assert = require('node:assert/strict');
const code = fs.readFileSync('app/web_shell/mobile-layout.js', 'utf8');
function run({screenWidth, touch = 1, viewport = {content: 'width=device-width, initial-scale=1'}}) {
  const events = {}, style = {};
  const window = {screen: {width: screenWidth}, innerWidth: 980,
    addEventListener: (name, fn) => events[name] = fn};
  const document = {
    querySelector: selector => selector === 'meta[name="viewport"]' ? viewport : {style},
    createElement: () => ({}), head: {appendChild: value => viewport = value}
  };
  vm.runInNewContext(code, {window, navigator: {maxTouchPoints: touch}, document});
  return {window, document, events, style, viewport: () => viewport};
}
const phone = run({screenWidth: 412});
assert.equal(phone.viewport().content, 'width=412, initial-scale=1, viewport-fit=cover');
assert.deepEqual(phone.style, {});
assert.deepEqual(Object.keys(phone.events).sort(), ['pageshow', 'resize']);
phone.window.screen.width = 600;
phone.events.resize();
assert.equal(phone.viewport().content, 'width=600, initial-scale=1, viewport-fit=cover');
phone.viewport().content = 'width=980';
phone.window.christmasMobileViewport();
assert.match(phone.viewport().content, /width=600/);
const missing = run({screenWidth: 360, viewport: null});
assert.equal(missing.viewport().name, 'viewport');
assert.match(missing.viewport().content, /width=360/);
const desktop = run({screenWidth: 1440, touch: 0});
assert.equal(desktop.viewport().content, 'width=device-width, initial-scale=1');
assert.doesNotMatch(code, /preventDefault|stopPropagation|\.style|\.zoom|transform/);
const bootstrap = fs.readFileSync('app/web_shell/flutter_bootstrap.js', 'utf8');
assert.match(bootstrap, /initializeEngine[\s\S]*christmasMobileViewport\?\.\(\);[\s\S]*runApp/);
console.log('PASS: phone viewport, resize, engine reassertion, missing meta, desktop unchanged, no scaling or touch/scroll interception.');
