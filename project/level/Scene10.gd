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
	
	#MainGame.Enemy._spawn_Enemy("Larva", Vector2(440, 0), 100, 40)
	#yield(get_tree().create_timer(2.0), "timeout")
	#_spawn_in_line("Moth", 5, 1.0, [50, 50, 50, 50, 50], [3,3,3,3,3])
	
	MainGame.Enemy._spawn_Enemy("Moth", UP_MIDDLE, 300, 4)
	_spawn_in_line("Moth", 3, 0.33, [50, 50, 50], [3,3,3], Vector2(0,100), Vector2(900, 100))
	
	yield(get_tree().create_timer(5.0), "timeout")
	
	_spawn_in_line("Moth", 3, 0.33, [50, 50, 50], [3,3,3], Vector2(0,200), Vector2(900, 200))
	MainGame.Enemy._spawn_Enemy("Pupa", UP_MIDDLE, 20, 0)
	
	yield(get_tree().create_timer(3.0), "timeout")
	
	_spawn_in_line("Pine_Cone", 10, 0.1, [50,50,50,50,50,50,50,50,50,50], [0,0,0,0,0,0,0,0,0,0], Vector2(0,400), Vector2(900,400))
	
	###########################
	
	set_process(true)

func is_enemy_left() -> bool:
	var enemies = MainGame.Enemy.get_children()
	return !( enemies.size() == 0 )

func _process(_delta):
	if( !is_enemy_left() ):
		emit_signal("scene_clear")
		self.queue_free()
