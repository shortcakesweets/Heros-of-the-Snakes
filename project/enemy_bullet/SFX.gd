extends Node2D

func _ready():
	pass

func play_sfx_at_pos(sfx = null, pos : Vector2 = Vector2.ZERO):
	if sfx:
		get_node(sfx).position = pos
		get_node(sfx).play()
	else:
		get_node("explosion").position = pos
		get_node("explosion").play()

func _on_sfx_finished():
	self.queue_free()
