var m4 = twgl.m4;
var v3 = twgl.v3;

var trans = function(){
	//Converts from my matrix style to twgl's dumb column major kind
	if (arguments.length != 16) throw Error("Can't transpose, wrong length");
	return m4.transpose(arguments);
}

var applyMatrix = function(matrix,vector){
	if (matrix.length != 16) throw Error("Wrong length");
	return twgl.m4.transformPoint(matrix,vector);
};


var matMult = function(){
	//Multiplies COLUMN MAJOR matrices from right to left
	//s.t. right matrix is applied first
	var matrices = Array.prototype.slice.call(arguments);
	//matrices = matrices.reverse();
	var rMat = matrices[0]; //The matrix which will eventually be returned

	//For each of the rest of the matrices...
	for(var i=1;i<matrices.length; i++){
		var m = matrices[i];
		rMat = m4.multiply(m,rMat);
	};

	return rMat;
};

var arrEq = function(v1,v2){
	//Tests whether two arrays are equal
	// if(v1.length != v2.length) return false
	// for(var i=0;i<v1.length;i++){
	// 	if(v1[i]!=v2[i]) return false;
	// };
	// return true;
	if(v1.length != v2.length) return false
	for(var i=0;i<v1.length;i++){
		//I just want to get close, within .6 is fine
		if(Math.abs(v1[i]-v2[i])>0.6) return false;
	};
	return true;
};
