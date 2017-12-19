extends "res://Global/Object.gd"

var heart_tex = load("res://Player/HUD/healthheart.png")
var remove = false setget set_remove
var add = false

var heart_offset = 0

onready var hp = Player.PlayerStateMachine.hp

var heart_arr = []

func _ready():
	inst_hearts()
	set_process(true)
	
func _process(delta):
	if (add):
		add_hearts()
	elif (remove):
		remove_heart()
	
func inst_hearts():
	for i in range(hp):
		var inst = Sprite.new()
		inst.set_texture(heart_tex)
		inst.set_pos(Vector2(64 + (80 * i), 64))
		heart_arr.append(inst)
		add_child(inst)
		
func set_remove(value):
	remove = value
	
func remove_heart():
	hp = Player.PlayerStateMachine.hp
	heart_arr[hp].set_pos(Vector2(heart_arr[hp].get_pos().x, 
									heart_arr[hp].get_pos().y - heart_offset))
	if (heart_offset >= 16):
		remove = false
		heart_offset = 0
	else:
		heart_offset += 1
		
func add_hearts():
	if (hp < 3):
		heart_arr[hp].set_pos(Vector2(heart_arr[hp].get_pos().x, 
									heart_arr[hp].get_pos().y + heart_offset))
		if (heart_offset >= 16):
			hp += 1
			heart_offset = 0
			if (hp == 3): add = false
		else:
			heart_offset += 1