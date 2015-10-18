var ADDNODES, MULTISELECT, NOTOOL, addNode, arcs, canvasScale, clearAndFill, dCanvas, dCtx, deselect, displayGrid, displayHoverCircle, displayNode, displaySelectionCircle, doneDragging, dragging, edges, gridSize, handleClick, handleMouseMove, hoverNode, init, mx, my, nodeUnderMouse, nodes, redraw, selectedNodes, toolMode, update, updateDrag;

nodes = [];

selectedNodes = [];

edges = [];

arcs = [];

dragging = false;

hoverNode = void 0;

mx = my = void 0;

dCanvas = void 0;

dCtx = void 0;

canvasScale = 1;

gridSize = void 0;

displayGrid = false;

deselect = function() {
  return selectedNodes = [];
};

addNode = function(x, y) {
  nodes.push([x, y]);
  redraw();
};

clearAndFill = function() {
  dCtx.fillStyle = '#EEEEEE';
  return dCtx.fillRect(0, 0, dCanvas.height, dCanvas.width);
};

displayNode = function(node) {
  var rad;
  rad = 4;
  dCtx.beginPath();
  dCtx.arc(node[0], node[1], rad, 0, 2 * Math.PI);
  dCtx.fillStyle = "#888888";
  return dCtx.fill();
};

toolMode = NOTOOL = 0;

ADDNODES = 1;

MULTISELECT = 2;

handleClick = function(x, y) {
  if (toolMode === ADDNODES) {
    addNode(x, y);
  }
  if (toolMode === NOTOOL) {
    if (nodeUnderMouse()) {
      selectedNodes = [nodeUnderMouse()];
    }
  }
  if (toolMode === MULTISELECT) {
    console.log("in Multiselect");
    if (nodeUnderMouse()) {
      console.log("triggered");
      selectedNodes.push(nodeUnderMouse());
      return console.log("" + selectedNodes);
    }
  }
};

nodeUnderMouse = function() {
  var i, len, n;
  for (i = 0, len = nodes.length; i < len; i++) {
    n = nodes[i];
    if (Math.abs(n[0] - mx) < 5 && Math.abs(n[1] - my) < 5) {
      return n;
    }
  }
  return void 0;
};

handleMouseMove = function(x, y) {
  mx = x;
  my = y;
  hoverNode = nodeUnderMouse();
  return redraw();
};

displayHoverCircle = function(n) {
  var rad;
  rad = 6;
  dCtx.beginPath();
  dCtx.arc(n[0], n[1], rad, 0, 2 * Math.PI);
  dCtx.fillStyle = "#888888";
  return dCtx.stroke();
};

displaySelectionCircle = function(n) {
  var rad;
  rad = 6;
  dCtx.beginPath();
  dCtx.arc(n[0], n[1], rad, 0, 2 * Math.PI);
  dCtx.fillStyle = "#888888";
  dCtx.stroke();
  rad = 4;
  dCtx.beginPath();
  dCtx.arc(n[0], n[1], rad, 0, 2 * Math.PI);
  dCtx.fillStyle = "#888888";
  return dCtx.stroke();
};

updateDrag = function() {};

doneDragging = function() {};

init = function() {
  dCanvas = document.getElementById('theCanvas');
  dCtx = dCanvas.getContext('2d');
  return clearAndFill();
};

update = function() {};

redraw = function() {
  var i, j, len, len1, n, results;
  clearAndFill();
  for (i = 0, len = nodes.length; i < len; i++) {
    n = nodes[i];
    displayNode(n);
  }
  if (hoverNode) {
    displayHoverCircle(hoverNode);
  }
  results = [];
  for (j = 0, len1 = selectedNodes.length; j < len1; j++) {
    n = selectedNodes[j];
    results.push(displaySelectionCircle(n));
  }
  return results;
};

$(document).click(function(e) {
  var h, w;
  h = dCanvas.height;
  w = dCanvas.width;
  if (!(mx > w || mx < 0 || my > h || my < 0)) {
    return handleClick(mx, my);
  }
});

$(document).mousemove(function(e) {
  var h, w, x, y;
  h = dCanvas.height;
  w = dCanvas.width;
  x = e.pageX - $(dCanvas).offset().left;
  y = e.pageY - $(dCanvas).offset().top;
  if (!(x > w || x < 0 || y > h || y < 0)) {
    return handleMouseMove(x, y);
  }
});

$(document).keydown(function(key) {
  switch (parseInt(key.which, 10)) {
    case 27:
      toolMode = NOTOOL;
      selectedNodes = [];
      break;
    case 190:
      toolMode = ADDNODES;
      break;
    case 16:
      toolMode = MULTISELECT;
      break;
    default:
      console.log("I'm pressing key: " + key.which);
  }
  return redraw();
});

$(document).keyup(function(key) {
  switch (parseInt(key.which, 10)) {
    case 16:
      if (toolMode === MULTISELECT) {
        return toolMode = NOTOOL;
      }
  }
});

$(document).ready(function() {
  return init();
});
