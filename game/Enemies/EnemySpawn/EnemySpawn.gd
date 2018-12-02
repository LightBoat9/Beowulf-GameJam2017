extends "res://Global/Object.gd"

onready var SpawnTimer = get_node("SpawnTimer")

var Manmoth = preload("res://Enemies/Manmoth/EnemyManmoth.tscn")
var SpearFischer = preload("res://Enemies/Spearfischer/SpearFischer.tscn")
var Beowulf = preload("res://Enemies/Beowulf/Beowulf.tscn")
var TimeLine = preload("res://Enemies/EnemySpawn/SpawnerTimeline.gd").new()

var OFFSET = 128

enum ENEMY {MANMOTH, SPEARFISCHER, BEOWULF}
enum SIDE {LEFT, RIGHT}

var RIGHT_SPAWN =  Vector2(800, 305)
var LEFT_SPAWN =  Vector2(0, 305)

var act = 1
var environ

func _ready():
	print("bop")
	SpawnTimer.start()
	SpawnTimer.connect("timeout", self, "spawn_timeout")
	add_child(TimeLine)
	
	environ = Game.get_node("Environment")

func on_playerDead():
	TimeLine.on_playerDead()

func end_act():
	environ.reset_stage(true)

func spawn_timeout():
	print("beep")
	var time = TimeLine.spawn_current(act)
	if time!= null: SpawnTimer.set_wait_time(time)

func spawn_enemy(type, side, num, OFFSET):
	var inst
	for i in range(num):
		if (type == ENEMY.MANMOTH):
			inst = Manmoth.instance()
		elif (type == ENEMY.SPEARFISCHER):
			inst = SpearFischer.instance()
		elif (type == ENEMY.BEOWULF):
			inst = Beowulf.instance()
		
		Game.add_child(inst)
		
		if (side == SIDE.LEFT):
			inst.set_pos(Vector2(LEFT_SPAWN.x - (OFFSET * i), LEFT_SPAWN.y))
			inst.set_dir(1)
		elif (side == SIDE.RIGHT):
			inst.set_pos(Vector2(RIGHT_SPAWN.x + (OFFSET * i), RIGHT_SPAWN.y))
			inst.set_dir(-1)
	return inst
	
func spawn_fischer():
	var inst = load("res://Enemies/Spearfischer/SpearFischer.tscn").instance()
	Game.add_child(inst)
	inst.set_pos(Vector2(RIGHT_SPAWN.x, RIGHT_SPAWN.y))
	inst.set_dir(-1)
	return inst