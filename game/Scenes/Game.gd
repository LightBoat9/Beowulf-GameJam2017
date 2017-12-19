extends Node2D

func _ready():
	set_process_input(true)
	
func _input(event):
	if (event.is_action_pressed("key_fullscreen")):
		OS.set_window_fullscreen(not OS.is_window_fullscreen())
