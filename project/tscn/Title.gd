extends Node2D

onready var BG_Black = get_node("BgBlack")
var button_status = "none"

func _ready():
	button_status = "none"
	set_opaqueness(true)

func set_opaqueness(isOn : bool):
	$Tween.stop_all()
	if( isOn ):
		$Tween.interpolate_property(BG_Black, "self_modulate:a8", 255, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	else:
		$Tween.interpolate_property(BG_Black, "self_modulate:a8", 0, 255, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()

func _on_Start_Game_pressed():
	button_status = "start"
	set_opaqueness(false)

func _on_How_to_Play_pressed():
	button_status = "how"

func _on_Quit_Game_pressed():
	button_status = "quit"
	set_opaqueness(false)


func _on_Tween_tween_completed(_object, _key):
	if button_status == "none":
		return
	elif button_status == "start":
		get_tree().change_scene("res://tscn/MainGame.tscn")
	elif button_status == "quit":
		get_tree().quit()
	elif button_status == "how":
		pass
