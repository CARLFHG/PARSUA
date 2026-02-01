shader_type canvas_item;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    // If the pixel is very dark (black), make it transparent
    if (length(tex_color.rgb) < 0.1) {
        discard;
    }
    COLOR = tex_color;
}