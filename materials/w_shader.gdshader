shader_type spatial;
render_mode depth_prepass_alpha, cull_disabled, unshaded;

group_uniforms vertices;
uniform vec4 vertex_0;
uniform vec4 vertex_1;
uniform vec4 vertex_2;

group_uniforms transform;
uniform vec4 origin;
uniform vec4 basis_x;
uniform vec4 basis_y;
uniform vec4 basis_z;
uniform vec4 basis_w;

group_uniforms space;
uniform vec4 normal;
uniform float e;

group_uniforms other;
uniform float w_frustrum;

vec4 xform(mat4 basis, vec4 p) {
	return vec4(dot(basis[0],p), dot(basis[1],p), dot(basis[2],p), dot(basis[3],p));
}
vec4 mul(mat4 basis, vec4 p) {
	mat4 _basis = basis;
	vec4 _origin = origin;
	
	return xform(_basis, p) + _origin;
}

vec4 mul_affine_inverse(mat4 basis, vec4 p) {
	mat4 _basis = inverse(basis);
	vec4 _origin = xform(_basis, -origin);
	
	return xform(_basis, p) + _origin;
}

vec4 globalize(mat4 basis, vec4 v) {
	return mul(basis, v);
}

void vertex() {
	mat4 basis = mat4(basis_x, basis_y, basis_z, basis_w);
	
	vec4 this_vertex;
	if (VERTEX_ID == 0) {
		this_vertex = globalize(basis, vertex_0);
	} else if (VERTEX_ID == 1) {
		this_vertex = globalize(basis, vertex_1);
	} else if (VERTEX_ID == 2) {
		this_vertex = globalize(basis, vertex_2);
	}
	
	float dist = dot(normal, this_vertex) - e;
	vec4 projected = this_vertex - normal * dist;
	vec4 inversed = mul_affine_inverse(basis, projected);
	
	VERTEX = inversed.xyz;
}

void fragment() {
	vec3 bary;
	vec4 point;
	float dist;
	float alpha;
	
	mat4 basis = mat4(basis_x, basis_y, basis_z, basis_w);
	
	bary.z = UV.x;
	bary.x = UV.y - bary.z;
	bary.y = 1.0 - bary.x - bary.z;
	
	point = globalize(basis, vertex_0) * bary.x + globalize(basis, vertex_1) * bary.y + globalize(basis, vertex_2) * bary.z;
	
	dist = dot(normal, point) - e;
	alpha = 1.0 - clamp(abs(dist) / w_frustrum, 0, 1);
	
	ALPHA = alpha;
	ALBEDO = vec3(0, 0, 0);
}