#include <flutter/runtime_effect.glsl>

uniform float uWidth;
uniform float uHeight;
uniform float uTime;
uniform float uStrength;
uniform float uDpr;

out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord().xy / vec2(uWidth, uHeight);

  float waveA = sin((uv.x * 14.0) + (uv.y * 11.0) + (uTime * 6.0));
  float waveB = cos((uv.x * 7.0) - (uv.y * 13.0) + (uTime * 9.0));
  float shimmer = (waveA + waveB) * 0.25 + 0.5;

  vec2 center = vec2(0.5, 0.5);
  float d = distance(uv, center);
  float edgeFalloff = smoothstep(0.96, 0.18, d);

  float pixelSoftness = clamp(1.0 / max(uDpr, 1.0), 0.35, 1.0);
  float alpha = edgeFalloff * (0.07 + shimmer * 0.12) * uStrength * pixelSoftness;

  vec3 tint = mix(vec3(0.80, 0.90, 1.0), vec3(1.0), shimmer * 0.6);
  fragColor = vec4(tint, alpha);
}
