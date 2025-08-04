shader_type canvas_item;

// Declare the screen texture
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Parameters to tweak the effect
uniform float time_speed = 1.0;
uniform float intensity = 0.01;
uniform float wave_size = 30.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    float time = TIME * time_speed;

    // Create wavy pattern using sine waves
    float wave = sin((uv.y + time) * wave_size) * 0.5;
    wave += sin((uv.y * 1.3 + time * 1.2) * wave_size * 0.5) * 0.5;

    // Apply horizontal distortion based on wave
    uv.x += wave * intensity;

    // Sample distorted screen texture
    COLOR = texture(SCREEN_TEXTURE, uv);
}
