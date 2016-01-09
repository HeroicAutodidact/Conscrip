/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;
/******/
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/*!***************************************!*\
  !*** ./app/assets/coffee/main.coffee ***!
  \***************************************/
/***/ function(module, exports, __webpack_require__) {

	var drawWindow;
	
	drawWindow = __webpack_require__(/*! ./drawWindow.coffee */ 1);
	
	window.onload = function() {
	  var dwin;
	  dwin = new drawWindow;
	  dwin.attach();
	  return dwin._drawNode({
	    x: 20,
	    y: 20
	  });
	};


/***/ },
/* 1 */
/*!*********************************************!*\
  !*** ./app/assets/coffee/drawWindow.coffee ***!
  \*********************************************/
/***/ function(module, exports) {

	var drawNode, settings, sketchDisplay;
	
	sketchDisplay.defaultSettings = {
	  nodeSize: 3,
	  nodeColor: '#888888'
	};
	
	settings = sketchDisplay.settings = sketchDisplay.defaultSettings;
	
	sketchDisplay = function() {
	  this._canvas = document.createElement('canvas');
	  this._canvas.height = 500;
	  this._canvas.width = 500;
	  this._canvas.id = 'conscriptDisplay';
	  this.c = this._canvas.getContext('2d');
	  this._protocols = settings.protocols;
	};
	
	sketchDisplay.prototype.attach = function(parentElement) {
	  if (parentElement != null) {
	    parentElement.appendChild(this._canvas);
	  } else {
	    document.body.appendChild(this._canvas);
	  }
	};
	
	sketchDisplay.prototype.getProtocols = function() {
	  return Object.keys(this._protocols);
	};
	
	
	/*Some drawing methods included by default */
	
	drawNode = function(node) {
	  var radius;
	  this.c.save();
	  this.c.beginPath();
	  radius = settings.nodeSize;
	  this.c.arc(node.x, node.y, radius, 0, 2 * Math.PI);
	  this.c.strokeStyle = settings.nodeColor;
	  this.c.stroke();
	  return this.c.closePath();
	};
	
	module.exports = sketchDisplay;


/***/ }
/******/ ]);
//# sourceMappingURL=bundle.js.map