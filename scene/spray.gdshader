shader_type canvas_item;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    // This looks for pixels where Red, Green, and Blue are all near 0 (black)
    // and sets their alpha (transparency) to 0.
    if (color.r < 0.1 && color.g < 0.1 && color.b < 0.1) {
        color.a = 0.0;
    }
    COLOR = color;
}