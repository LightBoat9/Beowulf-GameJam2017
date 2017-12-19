extends KinematicBody2D

onready var SpearSprite = get_node("Sprite")

var velocity = Vector2()
var GRAVITY = 1

var is_dead = false

var dir = sign(velocity.x)

func _ready():
	if (dir == 0): dir = -1
	set_process(true)
	
func _process(delta):
	velocity.y += GRAVITY
	SpearSprite.set_rot(-atan2(velocity.y, velocity.x))
	move(velocity)
	outside_view()

func outside_view():
	var p = get_pos()
	var s = get_viewport_rect().size
	if (p.x > s.x || p.x < 0 || p.y > s.y):
		queue_free()