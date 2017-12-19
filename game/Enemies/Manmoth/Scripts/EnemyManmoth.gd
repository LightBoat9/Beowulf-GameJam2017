extends "res://Enemies/Enemy.gd"

var StateMachine

onready var ManmothSprites = get_node("ManmothSprites")
onready var ManmothHitbox = get_node("ManmothHitbox")
onready var HurtTimer = get_node("HurtTimer")

func _ready():
	var path = "res://Enemies/Manmoth/Scripts/ManmothStateMachine.gd"
	StateMachine = (load(path).new())
	add_child(StateMachine)
	set_process(true)
	
func _process(delta):
	outside_view()
	
func set_dir(value):
	StateMachine.dir = value
	get_node("ManmothSprites").set_flip_h(value == 1)
	
func outside_view():
	var p = get_pos()
	var s = get_viewport_rect().size
	if (StateMachine.dir == 1 and p.x > s.x):
		queue_free()
	elif (StateMachine.dir == -1 and p.x < 0):
		queue_free()
