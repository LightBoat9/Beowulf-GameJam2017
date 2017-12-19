extends KinematicBody2D

var velocity = Vector2()
var GRAVITY = 0.5

var is_dead = false

var dir = -1

func _ready():
	set_process(true)
	
func _process(delta):
	velocity.y += GRAVITY
	move(velocity)
	outside_view()

func outside_view():
	var p = get_pos()
	var s = get_viewport_rect().size
	if (p.x > s.x || p.x < 0 || p.y > s.y):
		queue_free()