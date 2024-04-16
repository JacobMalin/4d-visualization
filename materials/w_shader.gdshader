shader_type spatial;
render_mode depth_prepass_alpha, cull_disabled, unshaded;

group_uniforms vertices;
instance uniform vec4 vertex_0;
instance uniform vec4 vertex_1;
instance uniform vec4 vertex_2;

group_uniforms transform;
instance uniform vec4 origin;
instance uniform vec4 basis_x;
instance uniform vec4 basis_y;
instance uniform vec4 basis_z;
instance uniform vec4 basis_w;

group_uniforms space;
uniform vec4 normal;
uniform float e;

group_uniforms camera;
uniform float w_frustrum;
uniform vec4 camera_pos;
uniform vec3 camera_rot_2;
uniform vec4 camera_basis_x;
uniform vec4 camera_basis_y;
uniform vec4 camera_basis_z;
uniform vec4 camera_basis_w;

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
	vec4 vertex = this_vertex - normal * dist;
	
	mat4 matrix_basis = mat4(1);
	vec4 matrix_origin = vec4(0);
	
	mat4 camera_basis = mat4(camera_basis_x, camera_basis_y, camera_basis_z, camera_basis_w);
	vec4 camera_origin = camera_pos;
	// translated
	matrix_origin -= camera_pos;
	// localed
	matrix_origin = xform(matrix_basis, camera_origin) + matrix_origin;
	matrix_basis *= camera_basis;
	// rotated_local xw
	mat4 xw_basis = mat4(
		vec4(cos(radians(camera_rot_2.x)), 0, 0, sin(radians(camera_rot_2.x))),
		vec4(0,1,0,0),
		vec4(0,0,1,0),
		vec4(-sin(radians(camera_rot_2.x)), 0, 0, cos(radians(camera_rot_2.x)))
	);
	matrix_basis = matrix_basis * xw_basis;
	// rotated_local yw
	mat4 yw_basis = mat4(
		vec4(1,0,0,0),
		vec4(0, cos(radians(camera_rot_2.y)), 0, sin(radians(camera_rot_2.y))),
		vec4(0,0,1,0),
		vec4(0, -sin(radians(camera_rot_2.y)), 0, cos(radians(camera_rot_2.y)))
	);
	matrix_basis = matrix_basis * yw_basis;
	// rotated_local zw
	mat4 zw_basis = mat4(
		vec4(1,0,0,0),
		vec4(0,1,0,0),
		vec4(0, 0, cos(radians(camera_rot_2.z)), sin(radians(camera_rot_2.z))),
		vec4(0, 0, -sin(radians(camera_rot_2.z)), cos(radians(camera_rot_2.z)))
	);
	matrix_basis = matrix_basis * zw_basis;
	// un-localed
	mat4 inverse_camera_basis = transpose(camera_basis);
	vec4 invserse_camera_origin = xform(inverse_camera_basis, -camera_origin);
	matrix_origin = xform(matrix_basis, invserse_camera_origin) + matrix_origin;
	matrix_basis *= inverse_camera_basis;
	// un-translated
	matrix_origin += camera_pos;
	// invert
	matrix_basis = transpose(matrix_basis);
	matrix_origin = xform(matrix_basis, -matrix_origin);
	
	vertex = matrix_basis * vertex + matrix_origin;
	
	vec4 inversed = mul_affine_inverse(basis, vertex);
	
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
	ALBEDO = vec3(0.0);
}