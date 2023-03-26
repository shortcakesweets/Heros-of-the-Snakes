extends Label

func _ready():
	pass

func update_text(percentage : int):
	text = String(percentage) + "%"
