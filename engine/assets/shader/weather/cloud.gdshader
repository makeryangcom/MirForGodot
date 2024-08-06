shader_type canvas_item;
// render_mode unshaded; // 可选项

// 噪声纹理
uniform sampler2D noise_texture: repeat_enable, filter_nearest;
// 雾的密度
uniform float density: hint_range(0.0, 1.0) = 0.25;
// 雾的速度
uniform vec2 speed = vec2(0.02, 0.01);

// 在材质可见的每一个像素上调用
void fragment() {
	// 使雾缓慢移动
	vec2 uv = UV + speed * TIME;
	// 采样噪声纹理
	float noise = texture(noise_texture, uv).r;
	// 将噪声从 (0.0, 1.0) 范围转换到 (-1.0, 1.0) 范围
	// 并再次将其限制在 0.0 到 1.0 之间
	float fog = clamp(noise * 2.0 - 1.0, 0.0, 1.0);
	// 应用雾效果
	COLOR.a *= fog * density;
}