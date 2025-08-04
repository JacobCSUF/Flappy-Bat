shader_type canvas_item;

uniform float flash_intensity = 0.1; // How strong the flash is
uniform float flash_interval = 1.0;  // How often it flashes (in seconds)
uniform float flash_duration = 0.2;  // How long each flash lasts (in seconds)

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    float time_in_cycle = mod(TIME, flash_interval);
    float flash = smoothstep(0.0, flash_duration, flash_duration - abs(time_in_cycle - flash_duration / 2.0));

    tex.rgb += flash * flash_intensity;
    COLOR = tex;
}
