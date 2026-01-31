shader_type canvas_item;

// This shader removes a specific color (black) from the video
void fragment() {
    vec4 color = texture(TEXTURE, UV);

    // Check if the pixel is near black
    float threshold = 0.1; // Increase this if some grey remains
    if (color.r < threshold && color.g < threshold && color.b < threshold) {
        color.a = 0.0; // Make it transparent
    }

    COLOR = color;
}