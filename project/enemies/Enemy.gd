extends Node2D

onready var MainGame = get_node("..")

var EnemyArray : Array = ["res://enemies/Larva.tscn","res://enemies/Pupa.tscn",
"res://enemies/Butterfly.tscn","res://enemies/Moth.tscn","res://enemies/PineCone.tscn"]

func _call_Enemy(enemy_Name : String, ID : int, spawn_Vector2 : Vector2 = Vector2(0,0), 
				 HP : int = 100, movement_speed : int = 10, spawn_rotation : float = 0, collision_damage : int = 0):

	var enemy = load(EnemyArray[ID]).instance()
	add_child(enemy)
	
	enemy.position = spawn_Vector2
	enemy.max_HP = HP
	enemy.movement_speed = movement_speed
	enemy.rotation = spawn_rotation
	if(collision_damage != 0):
		enemy.collision_damage = collision_damage
	
	print(enemy_Name + " is spawned at ")
	print(spawn_Vector2)

func _spawn_Enemy(enemy_ID, spawn_Vector2, HP, movement_speed, spawn_rotation : float = 0, collision_damage : int = 0):
	if(enemy_ID == "Larva"):
		_call_Enemy(enemy_ID, 0, spawn_Vector2, HP, movement_speed)
	elif(enemy_ID == "Pupa"):
		_call_Enemy(enemy_ID, 1, spawn_Vector2, HP, movement_speed, spawn_rotation, collision_damage)
	elif(enemy_ID == "Butterfly"):
		_call_Enemy(enemy_ID, 2, spawn_Vector2, HP, movement_speed)
	elif(enemy_ID == "Moth"):
		_call_Enemy(enemy_ID, 3, spawn_Vector2, HP, movement_speed)
	elif(enemy_ID == "Pine_Cone"):
		_call_Enemy(enemy_ID, 4, spawn_Vector2, HP, movement_speed)

# Called when the node enters the scene tree for the first time.
func _ready():
	MainGame.connect("_enemy_Spawn", self, "_spawn_Enemy")
	_spawn_Enemy("Pine_Cone", Vector2(500,500), 50, 0)
