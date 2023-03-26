extends Node2D

onready var MainGame = get_node("../..")
onready var Enemy = get_node("..")
onready var Enemy_Bullet = get_node("../../Enemy_Bullet")

onready var Icon = get_node("Icon")

var HP
var max_HP
var movement_speed
var velocity : Vector2

var isShooted : bool = false

func _ready():
	HP = 50
	max_HP = 50
	movement_speed = 0
	velocity = Vector2()
	isShooted = false

func _pinecone_Shooting():
	if isShooted : return
	isShooted = true
	for y_axis in range(-1,2):
		for x_axis in range(-1,2):
			if(y_axis == 0 and x_axis == 0):
				continue
			Enemy_Bullet._spawn_Bullet("Pinecone_Bullet", self.position, 20, 40, Vector2(x_axis,y_axis))
	self.queue_free() 

func _pinecone_Pattern():
	if((MainGame._get_Snake_Position() - self.position).length() < 300):
		set_process(false)
		Icon.connect("animation_finished", self, "_on_Icon_explode_animation_finished")
		Icon.play("explode")
		
		#self.queue_free()

func _on_Icon_explode_animation_finished():
	_pinecone_Shooting()
	###########################################

func _pinecone_Movement(delta):
	#no movement
	if(HP > max_HP):
		HP = max_HP
	
	#var vector_delta : Vector2 = MainGame._get_Snake_Position() - self.position
	#velocity = vector_delta.normalized() * movement_speed
	
	#self.position = self.position + velocity * delta

func _process(delta):
	_pinecone_Movement(delta)
	
	_pinecone_Pattern()

	#die
	if(HP <= 0):
		_pinecone_Shooting()
		#self.queue_free()
