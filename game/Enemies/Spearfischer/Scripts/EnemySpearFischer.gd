extends "res://Enemies/Enemy.gd"

var StateMachine

onready var Sprites = get_node("Sprites")
onready var HitBox = get_node("HitBox")

onready var HurtTimer = get_node("HurtTimer")
onready var ThrowTimer = get_node("ThrowTimer")
	
func _ready():
	var path = "res://Enemies/SpearFischer/Scripts/SpearFischerStateMachine.gd"
	StateMachine = (load(path).new())
	add_child(StateMachine)
	set_process(true)
	
func _process(delta):
	outside_view()
	
func outside_view():
	var p = get_pos()
	var s = get_viewport_rect().size
	if (StateMachine.dir == 1 and p.x > s.x):
		queue_free()
	elif (StateMachine.dir == -1 and p.x < 0):
		queue_free()
	
func set_dir(value):
	StateMachine.dir = value
	get_node("Sprites").set_flip_h(value == 1)