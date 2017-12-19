extends "res://Global/Object.gd" 

var acts = []
var current

var stage; var spawner; var player
var resetting;

func _ready():
	acts.append(get_node("Act1"))
	acts.append(get_node("Act2"))
	acts.append(get_node("Act3"))
	current = 0
	
	for act in acts:
		act.hide()
	acts[current].show()
	
	stage = get_node("Stage")
	spawner = Game.get_node("EnemySpawn")
	player = Game.get_node("Player")
	print(spawner)
	#reset_stage(true)

func reset_stage(gotoNext):
	print("resetting")
	stage.set_current_state("lower")
	resetting = !gotoNext
	
	if resetting && spawner != null:
		spawner.on_playerDead()
	elif spawner != null:
		spawner.act+=1

func act_next():
	acts[current].hide()
	if !resetting: current+=1
	if current>=acts.size(): current = 0
	acts[current].show()
	player.PlayerStateMachine.heal()