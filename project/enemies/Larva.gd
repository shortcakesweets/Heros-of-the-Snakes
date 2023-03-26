extends Node2D

onready var MainGame = get_node("../..")
onready var Enemy_Bullet = get_node("../../Enemy_Bullet")
onready var Enemy = get_node("..")

var HP
var max_HP
var movement_speed
var collision_damage
var velocity : Vector2

func _ready():
	HP = 100
	max_HP = 100
	movement_speed = 10
	collision_damage = 50
	velocity = Vector2()

func _larva_Movement(delta):
	var vector_delta : Vector2 = MainGame._get_Snake_Position() - self.position
	velocity = vector_delta.normalized() * movement_speed
	
	self.position = self.position + velocity * delta
	self.rotation = vector_delta.angle() + PI/2

	if(self.position.x < 480):
		self.position.x = 480
	elif(self.position.x > 1440):
		self.position.x = 1440
	
	if(HP > max_HP):
		HP = max_HP

func _on_Hit():
	var larva_pos : Vector2 = self.position
	
	#On Player hit
	if(MainGame._is_Bullet_on_Snake(larva_pos)):
		Enemy_Bullet._on_Snake_Hit()
		self.queue_free()

	#On Area hit
	elif(MainGame._is_Bullet_on_Area(larva_pos)):
		Enemy_Bullet._on_Area_Hit(larva_pos, collision_damage)
		self.queue_free()

func _process(delta):
	
	_larva_Movement(delta)
	
	_on_Hit()
	############ Undone ############
	#die
	if(HP <= 0):
		self.queue_free()	
	#survive
	elif(HP < max_HP/2):
		Enemy._spawn_Enemy("Pupa", self.position, 100, 0, self.rotation)
		self.queue_free()
