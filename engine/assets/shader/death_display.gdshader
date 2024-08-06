shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture,filter_linear_mipmap;

void fragment() {
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    float gray = dot(screen_color.rgb, vec3(0.299, 0.587, 0.114));
    COLOR = vec4(gray, gray, gray, screen_color.a);
}
