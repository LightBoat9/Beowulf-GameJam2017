extends "res://Global/Object.gd"

var stage = 0; var repeat = 0
var parent
var special
var game_over = false

var OFFSET = {
	"ROLL" : 64,
	"NORM" : 128,
	"JUMP" : 256
}

enum ENEMY {MANMOTH, SPEARFISCHER, BEOWULF}
enum SIDE {LEFT, RIGHT}

func _ready():
	parent = get_parent()
	set_process_input(true)
	
func _input(event):
	if event.is_action_pressed("ui_restart") and game_over:
		Game.get_node("End").hide()
		Game.get_node("Reset").hide()
		game_over = false
		get_parent().act = 0
		stage = 0
		get_parent().end_act()

func spawn_current(act):
	print("act " + str(act))
	if act == 1:
		return spawn_act1()
	elif act == 2:
		return spawn_act2()
	elif act == 3: 
		return spawn_act3()

func on_playerDead():
	stage = 0
	
	if special != null && special.get_ref(): 
		special.get_ref().StateMachine.set_current_state("leave")
		
func spawn_act3():
	print(stage)
	if (stage == 0):
		var inst = parent.Beowulf.instance()
		parent.Game.call_deferred("add_child", inst)
		special = weakref(inst)
		stage += 1
		return 1.5
	elif (stage == 1):
		if special.get_ref() and special.get_ref().StateMachine.get_current_state() != "dead":
			special.get_ref().StateMachine.set_current_state("point")
		else:
			stage = 7
			return 1
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 2, OFFSET["ROLL"])
		stage += 1
		return 2
	elif (stage == 2):
		if special.get_ref() and special.get_ref().StateMachine.get_current_state() != "dead":
			special.get_ref().StateMachine.set_current_state("point")
		else:
			stage = 7
			return 1
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 3, OFFSET["ROLL"])
		stage += 1
		return 2
	elif (stage == 3):
		if special.get_ref() and special.get_ref().StateMachine.get_current_state() != "dead":
			special.get_ref().StateMachine.set_current_state("stomp")
		else:
			stage = 7
			return 1
		stage += 1
		return 2
	elif (stage == 4):
		if special.get_ref() and special.get_ref().StateMachine.get_current_state() != "dead":
			special.get_ref().StateMachine.set_current_state("point")
		else:
			stage = 7
			return 1
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 4, OFFSET["ROLL"])
		stage += 1
		return 2
	elif (stage == 5):
		if special.get_ref() and special.get_ref().StateMachine.get_current_state() != "dead":
			special.get_ref().StateMachine.set_current_state("stomp")
		else:
			stage = 7
			return 1
		stage += 1
		return 1.5
	elif (stage == 6):
		if special.get_ref() and special.get_ref().StateMachine.get_current_state() != "dead":
			special.get_ref().StateMachine.set_current_state("point")
		else:
			stage = 7
			return 1
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 3, OFFSET["ROLL"])
		stage = 1
		return 2
	elif (stage == 7):
		print("Game Complete")
		Game.get_node("End").show()
		Game.get_node("Reset").show()
		game_over = true
		return 0.5
		
func spawn_act2():
	print(stage)
	if (stage == 0):
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 1, OFFSET["NORM"])
		special = weakref(parent.spawn_enemy(ENEMY.SPEARFISCHER, SIDE.RIGHT, 1 , OFFSET["JUMP"]))
		stage+=1
		return 3
	elif(stage == 1):
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 1, OFFSET["NORM"])
		if !special.get_ref(): stage+=1
		return 3
	elif (stage == 2):
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 2, OFFSET["ROLL"])
		special = weakref(parent.spawn_enemy(ENEMY.SPEARFISCHER, SIDE.RIGHT, 1 , OFFSET["JUMP"]))
		stage+=1
		return 3
	elif(stage == 3):
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 2, OFFSET["ROLL"])
		if !special.get_ref(): stage+=1
		return 3
	elif (stage == 4):
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 3, OFFSET["ROLL"])
		special = weakref(parent.spawn_enemy(ENEMY.SPEARFISCHER, SIDE.RIGHT, 1 , OFFSET["JUMP"]))
		stage+=1
		return 4
	elif(stage == 5):
		print(special)
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 3, OFFSET["ROLL"])
		if !special.get_ref(): stage+=1
		return 4
	elif(stage == 6):
		parent.end_act()
		stage=0
		return 0.5

func spawn_act1():
	print(stage)
	if (stage == 0): # Shoot easy, No repeat
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 1, OFFSET["NORM"])
		stage += 1
		repeat = 1
		return 3
	elif (stage == 1): # Shoot medium, Repeats once
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 2, OFFSET["JUMP"])
		if (repeat > 0): repeat -= 1
		else: 
			stage +=1
			repeat = 2
		return 3
	elif (stage == 2): # Shoot hard, Repeats twice
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 3, OFFSET["ROLL"])
		if (repeat > 0): repeat -= 1
		else:
			stage += 1
			return 1.5
		return 3
	elif (stage == 3): # P1 : Shoot hard, No repeat
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 3, OFFSET["ROLL"])
		stage += 1
		return 5
	elif (stage == 4): ## P2 : Roll easy, No repeat
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 2, OFFSET["ROLL"])
		stage += 1
		return 1
	elif (stage == 5): # P1: Shoot hard, No repeat
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 3, OFFSET["ROLL"])
		stage += 1
		return 5
	elif (stage == 6): ## P2: Roll medium, No repeat
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 3, OFFSET["ROLL"])
		stage += 1
		return 1
	elif (stage == 7): # P1: Shoot hard, No repeat
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 3, OFFSET["ROLL"])
		stage += 1
		return 5
	elif (stage == 8): ## P2: Roll hard, No repeat
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 4, OFFSET["ROLL"])
		stage += 1
		return 1
	elif (stage == 9): # P1: Shoot hard, No repeat
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 3, OFFSET["ROLL"])
		stage += 1
		return 1.5
	elif (stage == 10): ## P2: Roll hard, No repeat
		parent.spawn_enemy(ENEMY.MANMOTH, SIDE.RIGHT, 4, OFFSET["ROLL"])
		stage += 1
	elif(stage == 11):
		parent.end_act()
		stage = 0
		return 1
