extends "res://Global/StateMachine.gd"

var Spear = load("res://Enemies/Spearfischer/Spear/Spear.tscn")

var velocity

var dir = -1

var LEAP_HEIGHT = 16
var LEAP_DIST = 112
var LEAP_SPEED =16

var GRAVITY = 1
var MAXGRAVITY = 15

var KNOCKUP = 3
var KNOCKBACK = 1

var on_ground = false
var start_pos

onready var SPRITE_HEIGHT = get_parent().HitBox.get_texture().get_height()
onready var FLOOR_HEIGHT = 70
onready var ROOF_HEIGHT = 0
onready var OFFSET = 20
onready var screen_top = 0 - ROOF_HEIGHT + SPRITE_HEIGHT/2
onready var screen_bot = get_viewport_rect().size.y - SPRITE_HEIGHT/2 - FLOOR_HEIGHT - OFFSET

func _ready():
	get_parent().Sprites.connect("frame_changed", self, "frame_changed")
	get_parent().HurtTimer.connect("timeout", self, "hurt_timeout")
	get_parent().ThrowTimer.connect("timeout", self, "throw_timeout")
	set_current_state("leap")
	start_pos = get_pos()

func leap_enter():
	velocity = get_trajectory(LEAP_DIST * dir, LEAP_HEIGHT, LEAP_SPEED)
func leap_exit(): pass
func leap_update():
	if (on_ground): set_current_state("attack")
	if (!on_ground): velocity.y += GRAVITY
	velocity.y = min(velocity.y, MAXGRAVITY)
	get_parent().move(velocity)
	stop_outside_room()

func leave_enter():
	velocity = get_trajectory(start_pos.x-get_pos().x, LEAP_HEIGHT, LEAP_SPEED)
	get_parent().move(velocity)
func leave_exit(): pass
func leave_update():
	if (on_ground): get_parent().death()
	if (!on_ground): velocity.y += GRAVITY
	velocity.y = min(velocity.y, MAXGRAVITY)
	get_parent().move(velocity)
	stop_outside_room()

func idle_enter():
	get_parent().ThrowTimer.start()
func idle_exit(): pass
func idle_update():
	if (get_parent().Sprites.get_frame() == 0):
		get_parent().Sprites.set_animation("idle")

func throw_timeout():
	set_current_state("attack")

func hurt_enter():
	get_parent().Sprites.set_animation("hurt")
	get_parent().is_dead = true
	get_parent().HurtTimer.start()
func hurt_update():
	knockback_update()
	stop_outside_room()
func hurt_exit(): pass

func attack_enter(): 
	get_parent().Sprites.set_animation("attack")
func attack_update(): pass
func attack_exit(): pass

func hurt_timeout():
	get_parent().death()

func knockback(dir):
	velocity.x = KNOCKBACK * dir
	velocity.y = -KNOCKUP
	on_ground = false
	
func knockback_update():
	if (on_ground):
		velocity.x = 0
	else: 
		velocity.y += GRAVITY
	velocity.y = min(velocity.y, MAXGRAVITY)
	get_parent().move(velocity)
	stop_outside_room()	

func stop_outside_room():
	var pos = get_parent().get_pos()
	pos.y = clamp(pos.y + velocity.y, screen_top, screen_bot)
	on_ground = pos.y == screen_bot
	if (on_ground): velocity.y = 0
	get_parent().set_pos(pos)

func get_trajectory(length, height, time):
	return Vector2(length/time, -(height/time + time/2))
	
func frame_changed():
	var a = get_parent().Sprites.get_animation()
	if (a == "attack"):
		if (get_parent().Sprites.get_frame() == 2):
			spawn_spear()
			set_current_state("idle")
			
func spawn_spear():
	var inst = Spear.instance()
	inst.set_pos(get_parent().get_pos())
	var player_dist = abs(Player.get_pos().x - get_parent().get_pos().x)
	inst.velocity = get_trajectory(player_dist * dir, 48, 48)
	Game.add_child(inst)