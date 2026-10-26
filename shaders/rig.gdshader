shader_type canvas_item;
// Soft vertical light falloff over a fighter: brighter at the head, darker at the feet.

uniform float top = -300.0;
varying vec2 lp;

void vertex() {
	lp = VERTEX;
}

void fragment() {
	float g = clamp((lp.y - top) / -top, 0.0, 1.0);
	COLOR.rgb *= mix(1.05, 0.8, g * g);
}
