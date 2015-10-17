var frag_shader;

frag_shader = "precision mediump float;\n\nvarying vec4 vColor;\nvarying vec4 fNormal;\n\nvoid main(void) {\n	vec4 nfNormal = normalize(fNormal);\n	float lumFactor = dot(nfNormal , normalize(vec4(1.0,1.0,0.0,1.0)));\n	float newX = lumFactor * vColor.x;\n	float newY = lumFactor * vColor.y;\n	float newZ = lumFactor * vColor.z;\n    // gl_FragColor = vec4(lumFactor*vColor.x,\n				//     	lumFactor*vColor.y,\n				//     	lumFactor*vColor.z,\n				//     	1.0);\n	gl_FragColor = vec4(lumFactor,lumFactor,lumFactor,1.0);\n	// gl_FragColor = vec4(fNormal);\n}";
