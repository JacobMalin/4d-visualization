class_name Basis4D

var x : Vector4 = Vector4.ZERO
var y : Vector4 = Vector4.ZERO
var z : Vector4 = Vector4.ZERO
var w : Vector4 = Vector4.ZERO

func _init(p_x = Vector4(1, 0, 0, 0), p_y = Vector4(0, 1, 0, 0),
		   p_z = Vector4(0, 0, 1, 0), p_w = Vector4(0, 0, 0, 1)):
	x = p_x
	y = p_y
	z = p_z
	w = p_w

static func newFromScaleAndRotation(scale, rot_1, rot_2):
	return newFromScale(scale).mul(newFromRotation(rot_1, rot_2))

static func newFromScale(scale):
	return Basis4D.new(
		Vector4(1, 0, 0, 0) * scale.x,
		Vector4(0, 1, 0, 0) * scale.y,
		Vector4(0, 0, 1, 0) * scale.z,
		Vector4(0, 0, 0, 1) * scale.w,
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

func mul(rhs):
	var _basis = Basis4D.new()

	for i in range(4):
		for j in range(4):
			_basis.set_cell(i, j, row(i).dot(rhs.col(j)))

	return _basis

func row(i):
	if i == 0:   return x
	elif i == 1: return y
	elif i == 2: return z
	elif i == 3: return w

func a(i, j):
	return row(i-1)[j-1]

func col(j):
	var _col = Vector4.ZERO

	for i in range(4):
		_col[i] = row(i)[j]

	return _col

func set_cell(i, j, value):
	if i == 0:   x[j] = value
	elif i == 1: y[j] = value
	elif i == 2: z[j] = value
	elif i == 3: w[j] = value

static func cos_deg(theta):
	return cos(deg_to_rad(theta))

static func sin_deg(theta):
	return sin(deg_to_rad(theta))

func xform(p_vector):
	return Vector4(x.dot(p_vector), y.dot(p_vector), z.dot(p_vector), w.dot(p_vector))
