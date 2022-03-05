shader_type canvas_item;
render_mode unshaded;

uniform bool enable = true;
uniform float time_when_changed = 1.0f;

void fragment() {
	float change_delta_time = TIME - time_when_changed;
	float clamp_change_delta_time = clamp(change_delta_time*9.0, 0, 1);
	COLOR = texture(TEXTURE, UV);
	float lumi = COLOR.r * 0.2126 + COLOR.g * 0.7152 + COLOR.b * 0.0722;
	
	if (enable) {
		COLOR.rgb = mix(COLOR.rgb, vec3(lumi), clamp_change_delta_time);
	}
	else {
		COLOR.rgb = mix(vec3(lumi), COLOR.rgb, clamp_change_delta_time);
	}
}