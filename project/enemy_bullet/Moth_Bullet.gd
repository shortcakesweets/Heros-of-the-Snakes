extends Node2D

onready var MainGame = get_node("../..")
onready var Enemy_Bullet = get_node("..")

var damage
var movement_speed
var forward_vector
var velocity : Vector2

func _ready():
	damage = 10
	movement_speed = 40
	forward_vector = Vector2(0,1)
	velocity = Vector2()
	
func _bullet_is_in():
	if(self.position.x < 480):
		self.queue_free()
	elif(self.position.x > 1440):
		self.queue_free()
	elif(self.position.y > 1080):
		self.queue_free()
	elif(self.position.y < 0):
		self.queue_free()

func _bullet_Movement(delta):
	var vector_delta : Vector2 = forward_vector
	velocity = vector_delta.normalized() * movement_speed
	
	self.position = self.position + velocity * delta
	
#1. On line2D(SnakeLine) -> 
#2. On player(Snake) -> Hitbox set
#3. On Area -> polygon function (if in or not)

func _on_Hit():
	var bullet_pos : Vector2 = self.position
	
	#On Player hit
	if(MainGame._is_Bullet_on_Snake(bullet_pos)):
		
		print(" Moth bullet _on_Hit() ")
		
		Enemy_Bullet._on_Snake_Hit()
		self.queue_free()

	#On Playertrail hit
	elif(MainGame._is_Bullet_on_Trail(bullet_pos, bullet_pos - velocity)):
		Enemy_Bullet._on_Trail_Hit(damage)
		self.queue_free()

	#On Area hit
	elif(MainGame._is_Bullet_on_Area(bullet_pos)):
		Enemy_Bullet._on_Area_Hit(bullet_pos, damage)
		self.queue_free()

func _process(delta):
	_bullet_Movement(delta)
	
	#on hit something
	_on_Hit()
	
	_bullet_is_in()
