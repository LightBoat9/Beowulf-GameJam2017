extends "res://Global/StateMachine.gd"

var PlayerArrow = load("res://Player/Arrow/PlayerArrow.tscn")
var arrow_offset = Vector2(24, -12)

var can_roll = true
var roll_invin = false
var hit_invin = false

var can_shoot = true

var overlap_enemy = false
var last_enemy_hit = null

var hp = 3
var max_hp = 3

var environ

func _ready():
	Player.BlinkTimer.connect("timeout", self,"invin_blink")
	Player.HurtTimer.connect("timeout", self, "hurt_timout")
	Player.InvinTimer.connect("timeout", self, "invin_timeout")
	Player.RollTimer.connect("timeout", self, "roll_timeout")
	Player.ShootTimer.connect("timeout", self, "shoot_timeout")
	Player.PlayerArea.connect("body_enter", self, "enemy_body_enter")
	Player.PlayerArea.connect("body_exit", self, "enemy_body_exit")
	Player.PlayerSprites.connect("frame_changed", self, "frame_changed")
	set_current_state("idle")
	
	environ = Game.get_node("Environment")
	
func _process(delta):
	hurt_by_enemy()
	
func idle_enter(): Player.PlayerSprites.set_animation("idle")
func idle_exit(): pass
func idle_update():
	if (!Player.PlayerMovement.on_ground):
		set_current_state("jump")
	elif (can_roll and Input.is_action_pressed("key_roll")):
		set_current_state("roll")
	elif(can_shoot and Input.is_action_pressed("key_shoot")):
		set_current_state("shoot")
	elif (_is_moving()):
		set_current_state("walk")
	
	Player.PlayerMovement.update()
	Player.PlayerGraphics.update()
	
func walk_enter(): Player.PlayerSprites.set_animation("walk")
func walk_exit(): pass
func walk_update():
	if (!Player.PlayerMovement.on_ground):
		set_current_state("jump")
	elif (can_roll and Input.is_action_pressed("key_roll")):
		set_current_state("roll")
	elif(can_shoot and Input.is_action_pressed("key_shoot")):
		set_current_state("shoot")
	elif (!_is_moving()):
		set_current_state("idle")
	
	Player.PlayerMovement.update()
	Player.PlayerGraphics.update()
	
func jump_enter(): Player.PlayerSprites.set_animation("jump")
func jump_exit(): pass
func jump_update():
	if (Player.PlayerMovement.on_ground):
		set_current_state("idle")
	
	var y = Player.PlayerMovement.velocity.y
	if (y < -2):
		Player.PlayerSprites.set_frame(0)
	elif (y > 2):
		Player.PlayerSprites.set_frame(2)
	else:
		Player.PlayerSprites.set_frame(1)
		
	Player.PlayerMovement.update()
	Player.PlayerGraphics.update()
	
func roll_enter(): 
	Player.PlayerSprites.set_frame(0)
	Player.PlayerSprites.set_animation("roll")
	roll_invin = true
	can_roll = false
func roll_exit():
	Player.RollTimer.start()
	roll_invin = false
func roll_update():
	Player.PlayerMovement.roll_update()
	
func roll_timeout():
	can_roll = true
		
func shoot_enter():
	Player.PlayerSprites.set_frame(0)
	Player.PlayerSprites.set_animation("shoot")
	Player.PlayerMovement.stop_moving()
func shoot_exit(): Player.ShootTimer.start()
func shoot_update():
	Player.PlayerMovement.knockback_update()
	
func hurt_enter():
	Player.PlayerSprites.set_frame(0)
	Player.PlayerSprites.set_animation("hurt")
	Player.HurtTimer.start()
	handle_hp()
func hurt_exit(): pass
func hurt_update():
	Player.PlayerMovement.knockback_update()
	
func frame_changed():
	var a = Player.PlayerSprites.get_animation()
	if (a == "shoot"):
		if (Player.PlayerSprites.get_frame() == 0):
			set_current_state("idle")
		elif (Player.PlayerSprites.get_frame() == 1):
			can_shoot = false
			spawn_player_arrow()
	elif (a == "roll"):
		if (Player.PlayerSprites.get_frame() == 0):
			set_current_state("idle")
	
func spawn_player_arrow():
	var inst = PlayerArrow.instance()
	inst.dir = Player.PlayerGraphics.dir
	inst.set_pos(Vector2(Player.get_pos().x + 
				(arrow_offset.x * Player.PlayerGraphics.dir), 
				Player.get_pos().y + arrow_offset.y))
	Game.add_child(inst)
	
func _is_moving():
	return (Input.is_action_pressed("key_right") - 
			Input.is_action_pressed("key_left") != 0)
	
func invin_blink():
	if (hit_invin):
		var ps = Player.PlayerSprites
		if (ps.is_visible()): Player.PlayerSprites.hide()
		else: Player.PlayerSprites.show()
	else:
		Player.BlinkTimer.stop()
		Player.PlayerSprites.show()
	
func enemy_body_enter(body):
	if (body.is_in_group("enemy") && not body.get_parent().is_dead):
		overlap_enemy = true
		last_enemy_hit = body.get_parent()
	elif (body.is_in_group("projectile")):
		if (not hit_invin && not roll_invin):
			set_current_state("hurt")
			hit_invin = true
			Player.InvinTimer.start()
			Player.BlinkTimer.start()
			Player.PlayerMovement.knockback(body.dir)
		
func enemy_body_exit(body):
	if (last_enemy_hit == null):
		overlap_enemy = false
	elif (body.get_parent() == last_enemy_hit):
		overlap_enemy = false
	
func hurt_by_enemy():
	if (last_enemy_hit == null): return
	if (overlap_enemy):
		if (not hit_invin && not roll_invin):
			set_current_state("hurt")
			hit_invin = true
			Player.InvinTimer.start()
			Player.BlinkTimer.start()
			Player.PlayerMovement.knockback(last_enemy_hit.StateMachine.dir)
	
func hurt_timout():
	set_current_state("idle")
	
func invin_timeout():
	hit_invin = false
	
func shoot_timeout():
	can_shoot = true
	
func handle_hp():
	if (hp > 0): 
		hp -= 1
		Player.HUD.get_node("PlayerHearts").remove = true
	if (hp <= 0): 
		print("Player Died")
		environ.reset_stage(false)
	
func heal():
	if hp == 3: return
	hp = 3
	Player.HUD.get_node("PlayerHearts").add = true