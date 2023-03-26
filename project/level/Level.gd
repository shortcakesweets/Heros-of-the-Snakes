extends Node

onready var MainGame = get_node("..")
onready var Enemy = MainGame.Enemy
onready var Enemy_Bullet = MainGame.Enemy_Bullet

var scene_order : Array = []
var scene_index : int = 0

func _ready():
	get_Scene_children()
	scene_index = 0

# MainGame._clear_map() will clear all enemies and bullets.

func get_Scene_children():
	scene_order = self.get_children()
	scene_order.remove( scene_order.size() - 1 )

func play_scene_in_order():
	scene_order[scene_index].act()

func _on_scene_clear():
	scene_index = scene_index + 1
	
	if( scene_index > scene_order.size() - 1 ):
		# emit_signal("game end")
		print("game end")
		flytext("CLEAR!")
		return
	
	scene_order[scene_index].act()

func flytext(text : String):
	$CanvasLayer/FlyText/Label.text = text
	$CanvasLayer/FlyTextAnimator.queue("flytextin")
	$CanvasLayer/FlyTextAnimator.queue("flytextout")
