shader_type canvas_item;

void fragment() {
	vec2 distortedUV = SCREEN_UV + texture(TEXTURE, UV).a * 0.1;
	vec4 screenColor = texture(SCREEN_TEXTURE, distortedUV);
	COLOR = screenColor;
	
}