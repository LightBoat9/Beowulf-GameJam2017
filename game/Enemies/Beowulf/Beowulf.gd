extends "res://Enemies/Enemy.gd"

onready var BlinkTimer = get_node("BlinkTimer")
onready var HurtTimer = get_node("HurtTimer")
onready var DespawnTimer = get_node("DespawnTimer")
onready var Sprites = get_node("Sprites")

var StateMachine

func _ready():	
	var path = "res://Enemies/Beowulf/BeowulfStateMachine.gd"
	StateMachine = (load(path).new())
	add_child(StateMachine)
	set_pos(Vector2(725, 250))
