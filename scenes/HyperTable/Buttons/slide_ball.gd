class_name SlideBall
extends XRToolsPickable

var width = 0.75

var previous_percent

func _process(_delta):
	position.y = 0
	position.z = 0

	if position.x > width/2: position.x = width/2
	if position.x < -width/2: position.x = -width/2

func get_percent():
	var percent = (position.x + width/2) / width
	percent = percent if (percent >= 0 and percent < 1) else previous_percent
	previous_percent = percent
	return percent