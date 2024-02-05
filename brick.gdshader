shader_type canvas_item;

uniform vec4 flashColor : source_color;
uniform vec4 brickColor : source_color;
uniform float flashState : hint_range(0,1) = 0.0;

void fragment() {
	// vec4 pixelColor = texture(TEXTURE, UV);
	// COLOR = vec4(1.0, 1.0, 1.0, flashState);
	// vec4 baseBrickColor = vec4(1.0, 0.0, 1.0, 1.0);
	COLOR = mix(brickColor, flashColor, flashState);
	// COLOR.a *= flashState;
}

