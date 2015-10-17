//Transformation generators

var viewportMatrix = function(nx, ny){
	//Where nx and ny are the width and height of the screen in pixels
	return trans(nx/2,0,0,0,
							 0,ny/2,0,0,
							 0, 0,1,0,
							 0, 0,0,1);
};

var ppMatrix = function(n,f){
	//Perspective matrix
	return trans(n, 0, 0, 0,
							 0, n, 0, 0,
							 0, 0, n+f, -f*n,
							 0, 0,  1, 0);
};

var orthoMatrix = function(n,f,w,h){
	//Transforms an arbitrary prism centered on the z axis to the canonical vv
	//Note that n maps to z=1 and f maps to z=-1 because the camera points in -z direction
	var t = h/2;
	var b = -h/2;
	var r = w/2;
	var l = -w/2;
	return trans(2/(r-l),  0,       0,  -(r+l)/(r-l),
							 0,       2/(t-b),  0,  -(t+b)/(t-b),
							 0,        0,       2/(n-f),  -(n+f)/(n-f),
							 0,        0,       0,     1);
};

var iCamMatrix_v = function(e, g, t){
	var w = v3.normalize(g);
	t = v3.normalize(t);
	var u = v3.normalize(v3.cross(t,w));

	return trans(u[0], t[0], w[0], e[0],
							 u[1], t[1], w[1], e[1],
							 u[2], t[2], w[2], e[2],
							 0,    0,    0,   1);
};

var camMatrix_v = function(e, g, t){
	return m4.inverse(iCamMatrix_v(e,g,t));
};

