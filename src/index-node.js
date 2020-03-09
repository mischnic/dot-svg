const Module = require("../dist/index-node.js");
const wrapper = require("./wrapper.js");

module.exports = wrapper(Module);
