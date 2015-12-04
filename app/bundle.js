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

	var dwin;
	
	dwin = __webpack_require__(/*! ./drawWindow.coffee */ 1);
	
	document.onready = function() {
	  document.body.appendChild(document.body.createElement('p'));
	  return dwin();
	};


/***/ },
/* 1 */
/*!*********************************************!*\
  !*** ./app/assets/coffee/drawWindow.coffee ***!
  \*********************************************/
/***/ function(module, exports) {

	var drawWindow;
	
	drawWindow = function() {
	  var _canvas;
	  _canvas = document.createElement('canvas');
	  _canvas.width = 500;
	  _canvas.height = 500;
	  return document.body.appendChild(_canvas);
	};
	
	module.exports = drawWindow;


/***/ }
/******/ ]);
//# sourceMappingURL=bundle.js.map