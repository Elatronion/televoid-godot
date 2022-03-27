shader_type canvas_item;
render_mode unshaded;

uniform bool enable = true;
uniform float time_when_changed = 1.0f;

void fragment() {
	float change_delta_time = TIME - time_when_changed+0.25;
	float clamp_change_delta_time = clamp(change_delta_time*9.0, 0, 1);
	COLOR = texture(TEXTURE, UV);
	
	if (enable) {
		COLOR.a = mix(COLOR.a, 0.0, clamp_change_delta_time);
	}
	else {
		COLOR.a = mix(0.0, COLOR.a, clamp_change_delta_time);
	}
}