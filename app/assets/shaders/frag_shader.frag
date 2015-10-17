precision mediump float;

varying vec4 vColor;
varying vec4 fNormal;

void main(void) {
	vec4 nfNormal = normalize(fNormal);
	float lumFactor = dot(nfNormal , normalize(vec4(1.0,1.0,0.0,1.0)));
	float newX = lumFactor * vColor.x;
	float newY = lumFactor * vColor.y;
	float newZ = lumFactor * vColor.z;
    // gl_FragColor = vec4(lumFactor*vColor.x,
				//     	lumFactor*vColor.y,
				//     	lumFactor*vColor.z,
				//     	1.0);
	gl_FragColor = vec4(lumFactor,lumFactor,lumFactor,1.0);
	// gl_FragColor = vec4(fNormal);
}