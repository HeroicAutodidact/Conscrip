var Camera = function(canvas){
	//Viewport and rendering
	this.aspect = canvas.width/canvas.height;
	this.m_vp = viewportMatrix(canvas.width,canvas.height);
	// this.tilt
	// this.oTheta
	// this.oRadius

	//Perspective transforms
	this.near = 10;
	this.far = 100;
	this.aperatureHeight = 20;
	this.aperatureWidth = this.aperatureHeight * this.aspect;
	this.m_o = orthoMatrix(this.near, this.far, this.aperatureWidth, this.aperatureHeight);
	this.m_p = ppMatrix(this.near, this.far);

	//Composte the camera matrix from a set of translation elements
	//The camera starts at 0,0,0, so the transformation matrices are @ identity
	this.m_cam_trans = m4.identity();
	this.m_cam_orbit = m4.identity();
	this.m_cam_tilt = m4.identity();
	this.m_cam = m4.identity();
	this.buildViewMat();
};

Camera.prototype.setAperature = function(newHeight){
	this.aperatureHeight = newHeight;
	this.aperatureWidth = newHeight * this.aspect;
	this.m_o = orthoMatrix(this.near, this.far, this.aperatureWidth, this.aperatureHeight);
	this.buildViewMat();
};

Camera.prototype.setFocalLength = function(length){
	this.near = length;
	this.m_o = orthoMatrix(this.near, this.far, this.aperatureWidth, this.aperatureHeight);
	this.m_p = ppMatrix(this.near, this.far);
	this.buildViewMat();
};

Camera.prototype.setClipping = function(length){
	this.far = length;
	this.m_o = orthoMatrix(this.near, this.far, this.aperatureWidth, this.aperatureHeight);
	this.m_p = ppMatrix(this.near, this.far);
};

Camera.prototype.setTilt = function(theta){
	//Tilt the camera upwards by theta
	var ntheta = theta % (Math.PI*2)
	this.m_cam_tilt = m4.rotationX(ntheta);
	this.buildViewMat();
};

Camera.prototype.upTilt = function(theta){
	this.setTilt(this.m_cam_tilt+.01)
}

Camera.prototype.setOrbit = function(theta){
	var ntheta = theta % (Math.PI*2)
	this.m_cam_orbit = m4.rotationZ(ntheta);
	this.buildViewMat();
};

Camera.prototype.setRadius = function(r){
	//Place the camera away from subject by r
	this.m_cam_trans = m4.translation([0,0,-r]);
	this.buildViewMat();
};

Camera.prototype.buildViewMat = function(){

	//How must we move the camera to position it?
	this.m_cam = matMult(this.m_cam_orbit, this.m_cam_tilt,this.m_cam_trans);

	//Build my view transform
	this.m_v = matMult(this.m_vp,this.m_o,this.m_p,
										 m4.inverse(this.m_cam));
};

// Camera.prototype.worldToCan = function(vertices){
// 	//Converts an array of vertices from world to cannonical
// 	var m_v = this.m_v;
// 	return _.map(vertices, function(v){
// 		return applyMatrix(m_v, v);
// 	});
// };

Camera.prototype.get_m_v = function(){
	return this.m_v;
};