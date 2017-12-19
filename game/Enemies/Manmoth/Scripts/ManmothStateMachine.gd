extends "res://Global/StateMachine.gd"

var MOVESPEED = 6
var dir = 1

var velocity = Vector2()

var on_ground = false

var GRAVITY = 0.4
var MAXGRAVITY = 10

var KNOCKUP = 3
var KNOCKBACK = 1

onready var SPRITE_HEIGHT = get_parent().ManmothHitbox.get_texture().get_height()
onready var FLOOR_HEIGHT = 70
onready var ROOF_HEIGHT = 0
onready var screen_top = 0 - ROOF_HEIGHT + SPRITE_HEIGHT/2
onready var screen_bot = get_viewport_rect().size.y - SPRITE_HEIGHT/2 - FLOOR_HEIGHT

func _ready():
	get_parent().HurtTimer.connect("timeout", self, "hurt_timeout")
	set_current_state("walk")
	
func walk_enter(): pass
func walk_exit(): pass
func walk_update():
	velocity.x = MOVESPEED * dir
	if (!on_ground): velocity.y += GRAVITY
	velocity.y = min(velocity.y, MAXGRAVITY)
	get_parent().move(velocity)
	stop_outside_room()
	
func hurt_enter(): 
	get_parent().ManmothSprites.set_animation("hurt")
	get_parent().is_dead = true
	get_parent().HurtTimer.start()
func hurt_exit(): pass
func hurt_update():
	knockback_update()
	stop_outside_room()
	
func hurt_timeout():
	get_parent().death()
	
func knockback_update():
	if (on_ground):
		velocity.x = 0
	else: 
		velocity.y += GRAVITY
	velocity.y = min(velocity.y, MAXGRAVITY)
	get_parent().move(velocity)
	stop_outside_room()	
	
func knockback(dir):
	velocity.x = KNOCKBACK * dir
	velocity.y = -KNOCKUP
	on_ground = false
	
func stop_outside_room():
	var pos = get_parent().get_pos()
	pos.y = clamp(pos.y + velocity.y, screen_top, screen_bot)
	on_ground = pos.y == screen_bot
	if (on_ground): velocity.y = 0
	get_parent().set_pos(pos)