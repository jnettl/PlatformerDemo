// Modified from https://godotshaders.com/shader/stars-shader/
shader_type canvas_item;
uniform vec4 bg_color: source_color;
uniform float big_star_density: hint_range(0, 1) = 0.1;
uniform float big_star_scale: hint_range(30, 200) = 100.0;
uniform float speed: hint_range(0.0, 4.0) = 1.0;

float rand(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	float size = big_star_scale;
	float prob = 1.0 - big_star_density;
	vec2 pos = floor(1.0 / size * FRAGCOORD.xy);
	float color = 0.0;
	float starValue = rand(pos);

	if (starValue > prob)
	{
		vec2 center = size * pos + vec2(size, size) * 0.5;
		float t = 0.9 + 0.2 * sin(TIME * speed * 4.0 + (starValue - prob) / (1.0 - prob) * 45.0);
		color = 1.0 - distance(FRAGCOORD.xy, center) / (0.5 * size);
		color = color * t / (abs(FRAGCOORD.y - center.y)) * t / (abs(FRAGCOORD.x - center.x));
	}
	if (rand(SCREEN_UV.xy / 20.0) > 0.996)
	{
		float r = rand(SCREEN_UV.xy);
		color = r * (0.85 * sin(TIME * speed * (r * 5.0) + 720.0 * r) + 0.95);
	}
	COLOR = vec4(vec3(color),1.0) + bg_color;
}