extends "res://Global/Object.gd"

onready var ArrowSprite = get_node("ArrowSprite")
onready var ArrowArea = get_node("ArrowArea")

var velocity = Vector2(0,-1)
var MOVESPEED = 15
var GRAVITY = 0.05

var dir = 1

func _ready():
	ArrowArea.connect("body_enter", self, "enemy_enter")
	ArrowSprite.set_flip_h(dir == -1)
	set_process(true)
	
func _process(delta):
	calc_velocity()
	outside_view()
	move(velocity)
	
func calc_velocity():
	velocity.x = MOVESPEED * dir
	velocity.y += GRAVITY
	
func outside_view():
	var p = get_pos()
	var s = get_viewport_rect().size
	if (p.x > s.x || p.x < 0):
		destroy()
	
func enemy_enter(body):
	if (body.get_name() != "Beowulf"): body = body.get_parent()
	if (body.is_in_group("enemy")):
		if (not body.is_dead):
			if body.StateMachine.get_current_state() != "leap":
				body.StateMachine.set_current_state("hurt")
				body.StateMachine.knockback(dir)
			destroy()
			
func destroy():
	queue_free()