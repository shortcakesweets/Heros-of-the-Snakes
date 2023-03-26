extends Node2D

onready var Snake_Laser = get_node("Snake_Laser")
onready var Enemy = get_node("../../Enemy")
onready var Snake = get_node("../../Snake")

var shoot_timer : float = 0
var amount : int
var damage : int
var interval : float
var duration : float
var start_pos : Vector2
var is_on_snake : bool
var n : int = 0

func _turn_on_Laser_effect(end_pos):
	var laser = load("res://tscn/Snake_Laser.tscn").instance()
	add_child(laser)
	
	laser._turn_on_LaserEffect(start_pos,end_pos, duration)

func _give_Damage_to_Enemy(enemy_node):
	enemy_node.HP = enemy_node.HP - damage

func _target_closest_Enemy_from() -> Node2D:
	var EnemyArray : Array = Enemy.get_children()
	
	if(EnemyArray.size() == 0):
		print("No enemy to target!")
	
	var min_length : float = 9999999
	var targeting_enemy : Node2D

	for enemy in EnemyArray:
		var temp_length : float = (enemy.position - start_pos).length()
		if(min_length > temp_length):
			min_length = temp_length
			targeting_enemy = enemy
	
	return targeting_enemy

func _ready():
	amount = 0
	damage = 5
	interval = 0.2
	duration = 0.05
	start_pos = Vector2.ZERO
	is_on_snake = true

func _shoot_Laser():
	var enemy_node = _target_closest_Enemy_from()
	if(enemy_node != null):
		_give_Damage_to_Enemy(enemy_node)
		_turn_on_Laser_effect(Vector2(enemy_node.position))
	else:
		print("No enemy to shoot!")
		n = amount

func _process(delta):
	shoot_timer = shoot_timer + delta
	if(shoot_timer > interval):
		shoot_timer = 0
		n = n + 1
		if(n > amount):
			self.queue_free()
			return
		
		if(is_on_snake):
			start_pos = Snake.Body.position
		
		_shoot_Laser()
