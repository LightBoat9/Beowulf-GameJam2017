extends "res://Global/StateMachine.gd"

var Brick = load("res://Enemies/Beowulf/Brick.tscn")

var hp = 15

var dir = -1

func _ready():
	get_parent().BlinkTimer.connect("timeout", self, "blink")
	get_parent().HurtTimer.connect("timeout", self, "hurt_timeout")
	get_parent().DespawnTimer.connect("timeout", self, "flicker_timeout")
	get_parent().get_node("Sprites").connect("frame_changed", self, "frame_changed")
	set_current_state("stomp")
	
func idle_enter(): 
	get_parent().get_node("Sprites").set_animation("idle")
func idle_exit(): pass
func idle_update(): pass

func point_enter(): 
	get_parent().get_node("Sprites").set_animation("point")
func point_exit(): pass
func point_update(): pass

func stomp_enter(): 
	get_parent().get_node("Sprites").set_animation("stomp")
func stomp_exit(): spawn_bricks()
func stomp_update(): pass

func frame_changed():
	var s = get_parent().get_node("Sprites")
	if (s.get_animation() == "point"):
		if (s.get_frame() == 0):
			set_current_state("idle")
	if (s.get_animation() == "stomp"):
		if (s.get_frame() == 0):
			set_current_state("idle")
	if (s.get_animation() == "hurt"):
		if (s.get_frame() == 9):	
			get_parent().DespawnTimer.start()
			get_parent().BlinkTimer.set_wait_time(0.1)
			get_parent().BlinkTimer.start()
			s.stop()

func hurt_enter():
	if (hp > 0):
		get_parent().BlinkTimer.start()
		get_parent().HurtTimer.start()
		hp -= 1
	if (hp <= 0):
		get_parent().BlinkTimer.stop()
		get_parent().HurtTimer.stop()
		get_parent().get_node("Sprites").show()
		set_current_state("dead")
func hurt_exit(): pass
func hurt_update(): pass

func dead_enter():
	get_parent().get_node("Sprites").set_animation("hurt")
func dead_exit(): pass
func dead_update(): pass

func blink():
	var s = get_parent().get_node("Sprites")
	if (s.is_visible()):
		get_parent().get_node("Sprites").hide()
	else:
		get_parent().get_node("Sprites").show()
		
func spawn_bricks():
	for i in range(3):
		var inst = Brick.instance()
		inst.set_pos(Vector2(100 + (200 * i), 0))
		Game.add_child(inst)
		
func hurt_timeout():
	get_parent().BlinkTimer.stop()
	get_parent().get_node("Sprites").show()
	set_current_state("idle")
	
func flicker_timeout():
	get_parent().BlinkTimer.stop()
	get_parent().get_node("Sprites").show()
	get_parent().queue_free()

func knockback_update():
	pass
	
func knockback(dir):
	pass