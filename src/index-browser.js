const Module = require("../dist/index-browser.js");
const wrapper = require("./wrapper.js");

module.exports = wrapper(Module);
