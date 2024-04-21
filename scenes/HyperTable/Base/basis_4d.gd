class_name Basis4D

var x : Vector4 :
	get:
		return rows[0]
	set(_x):
		rows[0] = _x
var y : Vector4 :
	get:
		return rows[1]
	set(_y):
		rows[1] = _y
var z : Vector4 :
	get:
		return rows[2]
	set(_z):
		rows[2] = _z
var w : Vector4 :
	get:
		return rows[3]
	set(_w):
		rows[3] = _w

var rows = [
	Vector4.ZERO,
	Vector4.ZERO,
	Vector4.ZERO,
	Vector4.ZERO,
]

func _init(p_x = Vector4(1, 0, 0, 0), p_y = Vector4(0, 1, 0, 0),
		   p_z = Vector4(0, 0, 1, 0), p_w = Vector4(0, 0, 0, 1)):
	rows = [ p_x, p_y, p_z, p_w ]

static func newFromScaleAndRotation(scale, rot_1, rot_2):
	return newFromScale(scale).mul(newFromRotation(rot_1, rot_2))

static func newFromScale(scale):
	return Basis4D.new(
		Vector4(scale.x, 0, 0, 0),
		Vector4(0, scale.y, 0, 0),
		Vector4(0, 0, scale.z, 0),
		Vector4(0, 0, 0, scale.w),
	)

static func newFromRotation(rot_1, rot_2):
	# Rotation Order : zw,xw,yw,xy,yz,zx
	# Rotation matrices taken from https://scholarworks.iu.edu/dspace/bitstream/2022/8477/1/Zhang_indiana_0093A_10088.pdf
	# var Rxy = Basis4D.new(
	# 	Vector4(cos_deg(rot_1.z), -sin_deg(rot_1.z), 0, 0),
	# 	Vector4(sin_deg(rot_1.z), cos_deg(rot_1.z), 0, 0),
	# 	Vector4(0, 0, 1, 0),
	# 	Vector4(0, 0, 0, 1),
	# )
	# var Ryz = Basis4D.new(
	# 	Vector4(1, 0, 0, 0),
	# 	Vector4(0, cos_deg(rot_1.x), -sin_deg(rot_1.x), 0),
	# 	Vector4(0, sin_deg(rot_1.x), cos_deg(rot_1.x), 0),
	# 	Vector4(0, 0, 0, 1),
	# )
	# var Rzx = Basis4D.new(
	# 	Vector4(cos_deg(rot_1.y), 0, sin_deg(rot_1.y), 0),
	# 	Vector4(0, 1, 0, 0),
	# 	Vector4(-sin_deg(rot_1.y), 0, cos_deg(rot_1.y), 0),
	# 	Vector4(0, 0, 0, 1),
	# )
	# var Rzw = Basis4D.new(
	# 	Vector4(1, 0, 0, 0),
	# 	Vector4(0, 1, 0, 0),
	# 	Vector4(0, 0, cos_deg(rot_2.z), sin_deg(rot_2.z)),
	# 	Vector4(0, 0, -sin_deg(rot_2.z), cos_deg(rot_2.z)),
	# )
	# var Rxw = Basis4D.new(
	# 	Vector4(cos_deg(rot_2.x), 0, 0, sin_deg(rot_2.x)),
	# 	Vector4(0, 1, 0, 0),
	# 	Vector4(0, 0, 1, 0),
	# 	Vector4(-sin_deg(rot_2.x), 0, 0, cos_deg(rot_2.x)),
	# )
	# var Ryw = Basis4D.new(
	# 	Vector4(1, 0, 0, 0),
	# 	Vector4(0, cos_deg(rot_2.y), 0, sin_deg(rot_2.y)),
	# 	Vector4(0, 0, 1, 0),
	# 	Vector4(0, -sin_deg(rot_2.y), 0, cos_deg(rot_2.y)),
	# )

	# return Rzw.mul(Rxw).mul(Ryw).mul(Rzx).mul(Ryz).mul(Rxy)

	var sx = sin_deg(rot_2.x)
	var sy = sin_deg(rot_2.y)
	var sz = sin_deg(rot_2.z)
	var sa = sin_deg(rot_1.x)
	var sb = sin_deg(rot_1.y)
	var sg = sin_deg(rot_1.z)

	var cx = cos_deg(rot_2.x)
	var cy = cos_deg(rot_2.y)
	var cz = cos_deg(rot_2.z)
	var ca = cos_deg(rot_1.x)
	var cb = cos_deg(rot_1.y)
	var cg = cos_deg(rot_1.z)

	var sasbcxcasxsy = sa * sb * cx - ca * sx * sy
	var cacxsy = ca * cx * sy
	var sacxsy = sa * cx * sy

	var cbczsbsxsz = cb * cz - sb * sx * sz
	var cbsxszsbcz = -cb * sx * sz - sb * cz
	var sacbczsbsxszcacxsysz = sa * cbczsbsxsz - cacxsy * sz

	var sbsxczcbsz = -sb * sx * cz - cb * sz
	var sbszcbsxcz = sb * sz - cb * sx * cz
	var sasbsxczcbszcacxsycz = sa * sbsxczcbsz - cacxsy * cz

	return Basis4D.new(
		Vector4(
			sg * sasbcxcasxsy + cg * cb * cx,
			cg * sasbcxcasxsy - sg * cb * cx,
			ca * sb * cx + sa * sx * sy,
			sx * cy,
		),
		Vector4(
			sg * ca * cy,
			cg * ca * cy,
			sa * -cy,
			sy,
		),
		Vector4(
			sg * sacbczsbsxszcacxsysz + cg * cbsxszsbcz,
			cg * sacbczsbsxszcacxsysz - sg * cbsxszsbcz,
			sacxsy * sz + ca * cbczsbsxsz,
			cx * cy * sz,
		),
		Vector4(
			sg * sasbsxczcbszcacxsycz + cg * sbszcbsxcz,
			cg * sasbsxczcbszcacxsycz - sg * sbszcbsxcz,
			sacxsy * cz + ca * sbsxczcbsz,
			cx * cy * cz,
		),
	)

# Helper

func tdotx(p_v):
	return rows[0][0] * p_v[0] + rows[1][0] * p_v[1] + rows[2][0] * p_v[2] + rows[3][0] * p_v[3];
func tdoty(p_v):
	return rows[0][1] * p_v[0] + rows[1][1] * p_v[1] + rows[2][1] * p_v[2] + rows[3][1] * p_v[3];
func tdotz(p_v):
	return rows[0][2] * p_v[0] + rows[1][2] * p_v[1] + rows[2][2] * p_v[2] + rows[3][2] * p_v[3];
func tdotw(p_v):
	return rows[0][3] * p_v[0] + rows[1][3] * p_v[1] + rows[2][3] * p_v[2] + rows[3][3] * p_v[3];

func mul(rhs):
	return Basis4D.new(
		Vector4(rhs.tdotx(rows[0]), rhs.tdoty(rows[0]), rhs.tdotz(rows[0]), rhs.tdotw(rows[0])),
		Vector4(rhs.tdotx(rows[1]), rhs.tdoty(rows[1]), rhs.tdotz(rows[1]), rhs.tdotw(rows[1])),
		Vector4(rhs.tdotx(rows[2]), rhs.tdoty(rows[2]), rhs.tdotz(rows[2]), rhs.tdotw(rows[2])),
		Vector4(rhs.tdotx(rows[3]), rhs.tdoty(rows[3]), rhs.tdotz(rows[3]), rhs.tdotw(rows[3])),
	)

static func cos_deg(theta):
	return cos(deg_to_rad(theta))

static func sin_deg(theta):
	return sin(deg_to_rad(theta))

func xform(p_vector):
	return Vector4(x.dot(p_vector), y.dot(p_vector), z.dot(p_vector), w.dot(p_vector))
