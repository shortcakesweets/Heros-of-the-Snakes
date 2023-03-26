extends TextureProgress

func _ready():
	pass
	
func _animate_value(target, tween_duration=0.3):
	$Tween.stop_all()
	$Tween.interpolate_property(self, 'value', value, target, tween_duration, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	#yield($Tween, 'tween_completed')
