shader_type canvas_item;

uniform sampler2D first_noise : repeat_enable;
uniform sampler2D second_noise : repeat_enable;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 scroll_first = vec2(0.05, 0.05);
uniform vec2 scroll_second = vec2(-0.05, -0.05);

uniform float distortion : hint_range(-1.0, 1.0) = -0.025;

uniform vec4 modulate : source_color;

// I understand none of this
void fragment() {
	float depth = texture(first_noise, UV + scroll_first * TIME).r * texture(second_noise, UV + scroll_second * TIME).r;
	vec4 screen_col = texture(SCREEN_TEXTURE,
		SCREEN_UV + distortion * vec2(depth));
	COLOR = screen_col * modulate;
}
