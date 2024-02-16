shader_type canvas_item;

uniform vec4 flashColor : source_color;
uniform float flashState : hint_range(0,1) = 0.0;
uniform float maxFlashState = 1.0;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	float cappedFlashState = min(flashState, maxFlashState);
	COLOR = mix(pixelColor, flashColor, cappedFlashState);
	COLOR.a *= pixelColor.a;
}

