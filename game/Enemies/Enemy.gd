extends "res://Global/Object.gd"

var is_dead = false

func _ready():
	add_to_group("enemy")
	
func death():
	queue_free()
	
func set_dir(dir):
	pass