extends Node2D

onready var Enemy = get_node("..")
onready var MainGame = get_node("../..")

var HP
var max_HP
var movement_speed
var defense
var velocity : Vector2

func _ready():
	HP = 100
	max_HP = 100
	defense = 5
	velocity = Vector2()

#Pupa is none-movement enemy, no movement
func _pupa_Movement(delta):
	if(HP > max_HP):
		HP = max_HP

func _process(delta):
	_pupa_Movement(delta)
	
	#on hit danmak
	if(HP <= 0):
		self.queue_free()
