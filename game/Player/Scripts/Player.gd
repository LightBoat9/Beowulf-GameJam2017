extends "res://Global/Object.gd"

onready var PlayerSprites = get_node("PlayerSprites") 
onready var PlayerMask = get_node("PlayerMask") 
onready var PlayerArea = get_node("PlayerArea")
onready var HurtTimer = get_node("HurtTimer")
onready var InvinTimer = get_node("InvinTimer")
onready var BlinkTimer = get_node("BlinkTimer") 
onready var RollTimer = get_node("RollTimer")
onready var ShootTimer = get_node("ShootTimer")
onready var HUD = get_node("HUD")

var PlayerGraphics = load("res://Player/Scripts/PlayerGraphics.gd").new() 
var PlayerMovement = load("res://Player/Scripts/PlayerMovement.gd").new() 
var PlayerStateMachine = load("res://Player/Scripts/PlayerStateMachine.gd").new() 

func _ready():
	add_child(PlayerGraphics)
	add_child(PlayerMovement)
	add_child(PlayerStateMachine)