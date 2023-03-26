extends TextureProgress

onready var MainGame = get_node("..")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var life : int

# Called when the node enters the scene tree for the first time.
func _ready():
	min_value = 0
	max_value = 100
	life = 3

func set_snake_HP(hp: int, tween_duration = 0.3):
	$Tween.stop_all()
	$Tween.interpolate_property(self, "value", value, hp, tween_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func change_life(increment : int):
	life = life + increment
	update_life_ui()
	if( life >= 3 ):
		life = 3
	elif( life < 0 ):
		life = 0
		# permadeath

func update_life_ui():
	if( life >= 3 ):
		$Life1/PixelHeart.visible = true
		$Life2/PixelHeart.visible = true
		$Life3/PixelHeart.visible = true
	elif( life == 2 ) :
		$Life1/PixelHeart.visible = false
		$Life2/PixelHeart.visible = true
		$Life3/PixelHeart.visible = true
	elif( life == 1 ) :
		$Life1/PixelHeart.visible = false
		$Life2/PixelHeart.visible = false
		$Life3/PixelHeart.visible = true
	else:
		$Life1/PixelHeart.visible = false
		$Life2/PixelHeart.visible = false
		$Life3/PixelHeart.visible = false
	
