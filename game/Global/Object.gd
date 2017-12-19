extends Node2D

# Top Level
onready var Root = get_tree().get_root()
onready var Game = Root.get_child(Root.get_child_count() - 1)

# Game
onready var Player = Game.get_node("Player")