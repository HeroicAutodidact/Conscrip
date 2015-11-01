var ADDNODES, FINISHLINE, MULTISELECT, NOTOOL, STARTLINE, addNode, arcs, canvasScale, clamp, clearAndFill, clicking, currentEdgeStart, dCanvas, dCtx, deleteNode, deselect, displayCurrentEdge, displayEdge, displayGrid, displayHoverCircle, displayNode, displaySelectionCircle, downx, downy, dragging, drawGrid, edges, getCJSString, getConnectedEdges, gridSize, handleMouseDown, handleMouseMove, handleMouseUp, hoverNode, init, makingPath, mx, my, nodeUnderMouse, nodes, redraw, resultStringDisplay, selectedNodes, stringRep, toolMode, update,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

nodes = [];

selectedNodes = [];

edges = [];

currentEdgeStart = void 0;

arcs = [];


/*Mouse state info */

clicking = false;

dragging = false;

hoverNode = void 0;

mx = my = void 0;


/*Keeps track of mouse coordinates when mouse was clicked down */

downx = downy = void 0;

dCanvas = void 0;

dCtx = void 0;

resultStringDisplay = void 0;

canvasScale = 1;

gridSize = 20;

displayGrid = true;

deselect = function() {
  return selectedNodes = [];
};

addNode = function(x, y) {
  nodes.push([x, y]);
  redraw();
};


/*Displaying */

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

deleteNode = function(nodeToDelete) {
  nodes = nodes.filter(function(n) {
    return n !== nodeToDelete;
  });
  return edges = edges.filter(function(e) {
    return indexOf.call(e, nodeToDelete) < 0;
  });
};

displayHoverCircle = function(n) {
  var rad;
  rad = 8;
  dCtx.beginPath();
  dCtx.arc(n[0], n[1], rad, 0, 2 * Math.PI);
  dCtx.lineWidth = 2;
  dCtx.strokeStyle = "#888888";
  return dCtx.stroke();
};

displaySelectionCircle = function(n) {
  var rad;
  rad = 5;
  dCtx.beginPath();
  dCtx.arc(n[0], n[1], rad, 0, 2 * Math.PI);
  dCtx.strokeStyle = "#888888";
  dCtx.lineWidth = 3;
  return dCtx.stroke();
};


/*Displaying edges */

displayCurrentEdge = function() {
  dCtx.beginPath();
  dCtx.moveTo(currentEdgeStart[0], currentEdgeStart[1]);
  dCtx.lineTo(mx, my);
  dCtx.strokeStyle = "#888888";
  dCtx.lineWidth = 2;
  return dCtx.stroke();
};

displayEdge = function(e) {
  dCtx.beginPath();
  dCtx.moveTo(e[0][0], e[0][1]);
  dCtx.lineTo(e[1][0], e[1][1]);
  dCtx.strokeStyle = "#888888";
  dCtx.lineWidth = 3;
  return dCtx.stroke();
};


/*Clicking and moving */

toolMode = NOTOOL = 0;

ADDNODES = 1;

MULTISELECT = 2;

STARTLINE = 3;

FINISHLINE = 4;


/*Modifies the behavior of STARTLINE PRELINE and FINISHLINE if true */

makingPath = false;

handleMouseDown = function(x, y) {
  var newPathNode, ref;
  switch (toolMode) {
    case ADDNODES:
      deselect();
      addNode(x, y);
      if (makingPath) {
        toolMode = FINISHLINE;
        return currentEdgeStart = nodeUnderMouse();
      }
      break;
    case NOTOOL:
      if (!(selectedNodes.length > 1 && (ref = nodeUnderMouse(), indexOf.call(selectedNodes, ref) >= 0))) {
        if (nodeUnderMouse() != null) {
          return selectedNodes = [nodeUnderMouse()];
        }
      }
      break;
    case MULTISELECT:
      if (nodeUnderMouse()) {
        return selectedNodes.push(nodeUnderMouse());
      }
      break;
    case STARTLINE:
      if (nodeUnderMouse()) {
        currentEdgeStart = nodeUnderMouse();
        return toolMode = FINISHLINE;
      }
      break;
    case FINISHLINE:
      if (nodeUnderMouse()) {
        edges.push([currentEdgeStart, nodeUnderMouse()]);

        /*Get rid of any nodes selected */
        deselect();
        if (makingPath) {
          return currentEdgeStart = nodeUnderMouse();
        } else {
          currentEdgeStart = void 0;
          return toolMode = NOTOOL;
        }
      } else if (makingPath) {
        newPathNode = [mx, my];
        edges.push([currentEdgeStart, newPathNode]);
        console.log(edges);
        currentEdgeStart = newPathNode;
        return nodes.push(newPathNode);
      }
  }
};

handleMouseUp = function(x, y) {

  /*To differentiate between tapping and dragging behavior */
  switch (toolMode) {
    case NOTOOL:
      if (!dragging && selectedNodes.length > 1) {
        if (nodeUnderMouse()) {
          selectedNodes = [nodeUnderMouse()];
        } else {
          selectedNodes = [];
        }
      }
  }
  return redraw();
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
  var dx, dy, i, len, n;
  dx = x - mx;
  dy = y - my;
  mx = x;
  my = y;
  if (clicking && (!dx || !dy)) {
    dragging = true;
  }
  hoverNode = nodeUnderMouse();
  if (clicking && toolMode === NOTOOL) {
    for (i = 0, len = selectedNodes.length; i < len; i++) {
      n = selectedNodes[i];
      n[0] += dx;
      n[1] += dy;
    }
  }
  return redraw();
};


/*CADjs string creation and display */

stringRep = "";

getConnectedEdges = function(n) {

  /*
  obviously it would be significantly more efficient to simply store
  this information in nodes and update it as we move along. Will be changed
  in further iterations
   */
  return edges.filter(function(e) {
    return indexOf.call(e, n) >= 0;
  });
};

getCJSString = function() {
  var CJSString, buildContinuity, continuities, e, examinedEdges, i, len, newContinuity;
  CJSString = "";
  continuities = [];
  examinedEdges = [];
  buildContinuity = function(cont) {
    var connectedEdges, connectedEdgesWithoutLast, nextEdge, nextNode;
    connectedEdges = getConnectedEdges(cont[cont.length - 1]);
    console.log(connectedEdges);
    if (connectedEdges.length > 2) {
      return "More than two edges are connected to a node!";
    }
    if (connectedEdges.length < 2) {
      return "Discontinuous";
    }
    connectedEdgesWithoutLast = connectedEdges.filter(function(e) {
      return indexOf.call(examinedEdges, e) < 0;
    });
    nextEdge = connectedEdgesWithoutLast[0];
    examinedEdges.push(nextEdge);
    nextNode = (nextEdge.filter(function(n) {
      return n !== cont[cont.length - 1];
    }))[0];
    if (nextNode === cont[0]) {
      console.log("215");
      return JSON.stringify(cont);
    } else {
      return buildContinuity(cont.concat([nextNode]));
    }
  };
  for (i = 0, len = edges.length; i < len; i++) {
    e = edges[i];

    /*Unless we've already looked at e... */
    if (indexOf.call(examinedEdges, e) < 0) {

      /*Establish start node */
      newContinuity = buildContinuity([e[0]]);
      if (indexOf.call(continuities, newContinuity) < 0) {
        continuities.push(newContinuity);
      }
    }
  }
  return continuities;
};

init = function() {
  dCanvas = document.getElementById('theCanvas');
  dCtx = dCanvas.getContext('2d');
  resultStringDisplay = document.getElementById('cjsstring');
  return redraw();
};

update = function() {};

drawGrid = function() {
  var results, x, y;
  x = 0;
  y = 0;
  dCtx.strokeStyle = "#FFFFFF";
  dCtx.lineWidth = 2;
  console.log("drawgrid");
  while (!(y > dCanvas.height)) {
    dCtx.beginPath();
    dCtx.moveTo(0, y);
    dCtx.lineTo(dCanvas.height, y);
    dCtx.stroke();
    y += gridSize;
  }
  results = [];
  while (!(x > dCanvas.width)) {
    dCtx.beginPath();
    dCtx.moveTo(x, 0);
    dCtx.lineTo(x, dCanvas.height);
    dCtx.stroke();
    results.push(x += gridSize);
  }
  return results;
};

redraw = function() {
  var e, i, j, k, len, len1, len2, n;
  clearAndFill();
  if (displayGrid) {
    drawGrid();
  }
  for (i = 0, len = nodes.length; i < len; i++) {
    n = nodes[i];
    displayNode(n);
  }
  if (hoverNode) {
    displayHoverCircle(hoverNode);
  }
  for (j = 0, len1 = selectedNodes.length; j < len1; j++) {
    n = selectedNodes[j];
    displaySelectionCircle(n);
  }
  if (currentEdgeStart) {
    displayCurrentEdge();
  }
  for (k = 0, len2 = edges.length; k < len2; k++) {
    e = edges[k];
    displayEdge(e);
  }

  /*Display the text CADJS string */
  return resultStringDisplay.textContent = getCJSString();
};

clamp = function(min, number, max) {
  return Math.max(min, Math.min(number, max));
};


/*
input handling
 */

$(document).mousedown(function(e) {
  var h, w;
  h = dCanvas.height;
  w = dCanvas.width;
  clicking = true;
  dragging = false;
  if (!(mx > w || mx < 0 || my > h || my < 0)) {
    return handleMouseDown(mx, my);
  }
});

$(document).mouseup(function(e) {
  var h, w;
  h = dCanvas.height;
  w = dCanvas.width;
  clicking = false;
  return handleMouseUp(clamp(0, mx, w), clamp(0, my, h));
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
  var i, j, len, len1, n;
  switch (parseInt(key.which, 10)) {
    case 27:
      toolMode = NOTOOL;
      selectedNodes = [];
      currentEdgeStart = void 0;
      break;
    case 190:
      toolMode = ADDNODES;
      makingPath = false;
      break;
    case 16:
      toolMode = MULTISELECT;
      makingPath = false;
      break;
    case 76:
      if (selectedNodes.length === 2) {
        edges.push([selectedNodes[0], selectedNodes[1]]);
        selectedNodes = [];
      } else if (selectedNodes.length === 1) {
        currentEdgeStart = selectedNodes[0];
        toolMode = FINISHLINE;
      } else {
        toolMode = STARTLINE;
      }
      makingPath = false;
      break;
    case 78:
      toolMode = ADDNODES;
      makingPath = true;
      console.log("makingPath");
      break;
    case 88:
      for (i = 0, len = selectedNodes.length; i < len; i++) {
        n = selectedNodes[i];
        deleteNode(n);
      }
      selectedNodes = [];
      break;
    case 64:
      for (j = 0, len1 = selectedNodes.length; j < len1; j++) {
        n = selectedNodes[j];
        deleteNode(n);
      }
      selectedNodes = [];
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
