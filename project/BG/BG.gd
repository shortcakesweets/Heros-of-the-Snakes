extends Node2D

onready var MainGame = get_node("..")

var BG_Object = "res://BG/BG_Object.tscn"
var ImageArray : Array = ["res://assets/HoSBush_1.png","res://assets/HoSGrass_1.png"]

func _call_Object(ID : int, spawn_Vector2 : Vector2 = Vector2(0,0), speed : float = 5, z_index : int = 0):

	var object = load(BG_Object).instance()
	add_child(object)
	
	object._get_Image(ImageArray[ID], speed, z_index)

	
	object.position = spawn_Vector2
	
func _spawn_Object(object_ID, spawn_Vector2):
	if(object_ID == 0):
		_call_Object(0,spawn_Vector2,100, 100)
	elif(object_ID == 1):
		_call_Object(1,spawn_Vector2,100, 0)

var spawn_timer : float = 0
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func _process(delta):
	spawn_timer = spawn_timer + delta
	if(spawn_timer > 2):
		spawn_timer = rng.randf_range(0,2)
		var spawn_type_ID = rng.randi_range(0,1)
		var x_random = rng.randf_range(500.0, 1400.0)
		_spawn_Object(spawn_type_ID, Vector2(x_random, -10))
