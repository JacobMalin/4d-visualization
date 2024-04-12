shader_type spatial;
render_mode depth_prepass_alpha, cull_disabled, unshaded;

group_uniforms vertices;
uniform vec3 vertex_0;
uniform vec3 vertex_1;
uniform vec3 vertex_2;

group_uniforms plane;
uniform vec3 normal;
uniform float d;

group_uniforms other;
uniform float y_frustrum;

void fragment() {
	vec3 bary;
	vec3 point;
	float dist;
	float alpha;
	
	bary.z = UV.x;
	bary.x = UV.y - bary.z;
	bary.y = 1.0 - bary.x - bary.z;
	
	point = vertex_0 * bary.x + vertex_1 * bary.y + vertex_2 * bary.z;
	
	dist = dot(normal, point) - d;
	alpha = 1.0 - clamp(abs(dist) / y_frustrum, 0, 1);
	
	ALPHA = alpha;
	ALBEDO = vec3(0, 0, 0);
}