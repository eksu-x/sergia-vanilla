shader_type canvas_item;

uniform sampler2D texture2;
uniform sampler2D colortexture;
uniform vec2 scroll1 = vec2(0.01, 0.01);
uniform vec2 scroll2 = vec2(0.03, 0.03);

void fragment() {
	float textureColor1 = texture(TEXTURE, UV + scroll1 * TIME).r;
	float textureColor2 = texture(texture2, UV + scroll2 * TIME).r;
	float energy = textureColor1 * textureColor2;
	vec4 color = texture(colortexture, vec2(energy));
	COLOR = color;
}