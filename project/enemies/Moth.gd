extends Node2D

onready var MainGame = get_node("../..")
onready var Snake = get_node("../../Snake")
onready var Enemy_Bullet = get_node("../../Enemy_Bullet")

var HP
var max_HP
var movement_speed
var velocity : Vector2

var is_pattern_on : bool = false
var is_going_toward_player : bool = false

func _ready():
	HP = 50
	max_HP = 50
	movement_speed = 2
	velocity = Vector2()

func _moth_Shooting():
	for y_axis in range(-1,2):
		for x_axis in range(-1,2):
			if(y_axis == 0 and x_axis == 0):
				continue
			Enemy_Bullet._spawn_Bullet("Moth_Bullet", self.position, 10, 40, Vector2(x_axis,y_axis))

func _moth_Movement(delta):
	var vector_delta : Vector2 = Vector2()
	var speed_multiplicity : int = 1
	
	if(is_pattern_on):	
		if(is_going_toward_player):
			if(Snake.isInArea):
				is_going_toward_player = false
				pass

			vector_delta = MainGame._get_Snake_Position() - self.position
		else:
			vector_delta = Vector2( - (velocity.x)/2, 0)
			speed_multiplicity = 2
		
		velocity = velocity + (vector_delta - Vector2(0,150)).normalized() * movement_speed * speed_multiplicity

		if(velocity.length() > 300):
				velocity = velocity.normalized() * 300
		
		#Moth gets closer to the player (radius < 40)
		if(vector_delta.length() < 250):
			if(is_going_toward_player):
				_moth_Shooting()
				is_going_toward_player = false
		
		if(not is_going_toward_player):
			if(self.position.y < 40):
				is_pattern_on = false
	else:
		velocity = velocity/1.05
		if(velocity.length() < 10): velocity = Vector2()
	
	self.position = self.position + velocity * delta

	if(HP > max_HP):
		HP = max_HP

	if(self.position.x < 480):
		self.position.x = 480
	elif(self.position.x > 1440):
		self.position.x = 1440

var pattern_timer : float = 0

func _moth_Pattern(delta):
	pattern_timer = pattern_timer + delta
	if(pattern_timer > 4):
		pattern_timer = 0
		
		if(not is_pattern_on):
			is_pattern_on = true
			is_going_toward_player = true

func _process(delta):
	_moth_Movement(delta)
	
	#shooting
	_moth_Pattern(delta)
	
	#die
	if(HP <= 0):
		self.queue_free()
