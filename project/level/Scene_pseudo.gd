extends Node2D

signal scene_clear()

onready var MainGame = get_node("../..")

# These are the constants for easy implementation. #
const UP_LEFT = Vector2( 500, 20 )
const UP_MIDDLE = Vector2( 960, 20 )
const UP_RIGHT = Vector2( 1420, 20 )

const MID_LEFT = Vector2( 500, 250 )
const MID_MIDDLE = Vector2( 960, 250 )
const MID_RIGHT = Vector2( 1420, 250 )

const DOWN_LEFT = Vector2( 500, 480 )
const DOWN_MIDDLE = Vector2( 960, 480 )
const DOWN_RIGHT = Vector2( 1420, 480 )
####################################################

# These are functions for sequence of enemy appearances. #

func _spawn_in_line( enemy_id : String, number : int, interval : float, HP : Array, Speed : Array,
						 bias_a : Vector2 = Vector2.ZERO, bias_b : Vector2 = Vector2(0, 460) ):
	if( number <= 1 ): return
	
	var increment : Vector2 = (bias_b - bias_a) / (number-1)
	for i in range(number):
		MainGame.Enemy._spawn_Enemy(enemy_id, UP_LEFT + bias_a + increment * i, HP[i], Speed[i])
		yield(get_tree().create_timer(interval), "timeout")
		
############################################################

func _ready():
	set_process(false)

#### Implementing Guide ####
# These are the default values
const Enemy_ID = ["Larva", "Pupa", "Butterfly", "Moth", "Pine_Cone"]
const Enemy_HP = [100, 100, 100, 50, 50]
const Enemy_speed = [40, 0, 5, 3, 0]

func act():
	# Implement between here #
	
	MainGame.Enemy._spawn_Enemy("Pine_Cone", MID_MIDDLE, 100, 40)
	
	
	###########################
	
	set_process(true)

func _process(_delta):
	if(false):
		emit_signal("scene_clear")
		self.queue_free()
