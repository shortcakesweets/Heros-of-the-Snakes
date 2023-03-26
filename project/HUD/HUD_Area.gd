extends Node2D

onready var MainGame = get_node("..")
onready var _label = get_node("Label")
onready var _bar = get_node("AreaBar")

var max_value = 1036800
var min_value = 0


func _ready():
	_bar.min_value = min_value
	_bar.max_value = max_value * 0.5
	_bar.value = max_value * 0.25

func set_snake_Area(area : float, tween_duration = 0.3):
	var percent : float
	
	_bar._animate_value(area, tween_duration)
	
	percent = (area / _bar.max_value) * 100.0
	_label.update_text(int(percent))
