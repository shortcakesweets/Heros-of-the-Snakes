extends Node2D

onready var MainGame = get_node("../..")
onready var Enemy_Bullet = get_node("../../Enemy_Bullet")

var HP
var max_HP
var movement_speed
var velocity : Vector2

func _ready():
	HP = 100
	max_HP = 100
	movement_speed = 2
	velocity = Vector2()

func _butterfly_Movement(delta):
	var vector_delta : Vector2 = (MainGame._get_Snake_Position() - self.position).project(Vector2(1,0))
	velocity = velocity + vector_delta.normalized() * movement_speed
	
	if(self.position.y > 50):
		self.position.y = self.position.y - (movement_speed * delta)/4
	
	self.position = self.position + velocity * delta
	
	if(self.position.x < 480):
		self.position.x = 480
		velocity = velocity - velocity.project(Vector2(1,0))
	elif(self.position.x > 1440):
		self.position.x = 1440
		velocity = velocity - velocity.project(Vector2(1,0))

	if(HP > max_HP):
		HP = max_HP

var shoot_timer : float = 0

func _butterfly_Shooting(delta):
	shoot_timer = shoot_timer + delta
	if(shoot_timer > 3):
		shoot_timer = 0
		Enemy_Bullet._spawn_Bullet("Butterfly_Bullet", self.position, 20, 50, Vector2(0,1))

func _process(delta):
	_butterfly_Movement(delta)
	
	#shooting
	_butterfly_Shooting(delta)
	
	#die
	if(HP <= 0):
		self.queue_free()
