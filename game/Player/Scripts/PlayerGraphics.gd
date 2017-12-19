extends "res://Global/Object.gd"

var dir = 1

func update():
	if (_input_dir() != 0): 
		dir = _input_dir()
	
	Player.PlayerSprites.set_flip_h(dir == -1)
	
func _input_dir():
	return Input.is_action_pressed("key_right") - Input.is_action_pressed("key_left")
