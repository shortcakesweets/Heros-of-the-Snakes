extends Node2D

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0

onready var target_nodes = get_parent().get_tree().get_nodes_in_group("movable")

# call this for screenshake!
func start(amplitude = 8, duration = 0.2, frequency = 15):
	print("Hello screenshcakke")
	self.amplitude = amplitude
	
	$Duration.wait_time = duration
	$Frequency.wait_time = 1 / float(frequency)
	$Duration.start()
	$Frequency.start()
	
	_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)
	
	for target in target_nodes:
		$ShakeTween.interpolate_property(target, "position", target.position, rand, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()

func _reset():
	for target in target_nodes:
		$ShakeTween.interpolate_property(target, "position", target.position, Vector2.ZERO, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()

func _on_Frequency_timeout():
	_new_shake()

func _on_Duration_timeout():
	_reset()
	$Frequency.stop()
