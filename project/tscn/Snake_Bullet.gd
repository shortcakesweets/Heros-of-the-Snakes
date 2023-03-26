extends Node2D

onready var Snake = get_node("../Snake")

func _ready():
	pass # Replace with function body.

func _call_Laser_Object(damage : int = 10, amount : int = 5, interval : float = 0.2,
 effect_duration : float = 0.05, starting_position : Vector2 = Vector2.ZERO, is_on_snake : bool = true):
	var laser_object = load("res://tscn/Shooting_Object.tscn").instance()
	add_child(laser_object)
	
	laser_object.amount = amount
	laser_object.damage = damage
	laser_object.interval = interval
	laser_object.duration = effect_duration
	laser_object.start_pos = starting_position
	laser_object.is_on_snake = is_on_snake
