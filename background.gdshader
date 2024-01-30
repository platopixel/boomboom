shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.bool
	vec2 distortedUV = UV;
	// distortedUV.x += pow(distortedUV.y, 0.2);
	COLOR = texture(TEXTURE, distortedUV);
	// Darken the color
    float darken_factor = 0.3; // Value between 0 and 1, where 0 is black and 1 is original color
    COLOR.rgb *= darken_factor;
	// float wave = sin(UV.y * 10.0 + TIME);
	// COLOR = vec4(mix(vec3(0.0, 0.0, 1.0), vec3(1.0, 0.0, 0.0), wave), 1.0);
	// COLOR.rgb = vec3(1.0) - COLOR.rgb; // Invert colors
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
