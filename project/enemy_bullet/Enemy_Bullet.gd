extends Node2D

onready var MainGame = get_node("..")

signal _on_Snake_hit()
signal _on_Trail_hit(damage)
signal _on_Area_hit(hit_Vector2, damage)

var BulletArray : Array = ["res://enemy_bullet/Butterfly_Bullet.tscn","res://enemy_bullet/Moth_Bullet.tscn","res://enemy_bullet/Pinecone_Bullet.tscn"]

func _ready():
	pass

func _call_Bullet(ID : int, spawn_Vector2 : Vector2, damage : int = 100,
				  movement_speed : int = 50, forward_vector : Vector2 = Vector2(0,1)):
	
	var bullet = load(BulletArray[ID]).instance()
	add_child(bullet)
	
	bullet.position = spawn_Vector2
	bullet.damage = damage
	bullet.movement_speed = movement_speed
	bullet.forward_vector = forward_vector

func _spawn_Bullet(bullet_ID, spawn_Vector2, damage, movement_speed, forward_vector):
	if(bullet_ID == "Butterfly_Bullet"):
		_call_Bullet(0, spawn_Vector2, damage, movement_speed, forward_vector)
	elif(bullet_ID == "Moth_Bullet"):
		_call_Bullet(1, spawn_Vector2, damage, movement_speed, forward_vector)
	elif(bullet_ID == "Pinecone_Bullet"):
		_call_Bullet(2, spawn_Vector2, damage, movement_speed, forward_vector)
	else:
		print("Error: No such bulletID")

func _delete_Bullet(delete_pos, radius):
	var BulletArray = self.get_children()
	
	for bullet in BulletArray:
		if((bullet.position - delete_pos).length() < radius):
			bullet.queue_free()

func _on_Snake_Hit():
	emit_signal("_on_Snake_hit")
	
func _on_Trail_Hit(damage):
	emit_signal("_on_Trail_hit", damage)
	
func _on_Area_Hit(bullet_pos, damage):
	_make_SE(bullet_pos)
	emit_signal("_on_Area_hit", bullet_pos, damage)

func _make_SE(pos : Vector2):
	print("explosion SE")
	var sfx = load("res://enemy_bullet/SFX.tscn").instance()
	add_child(sfx)
	sfx.play_sfx_at_pos("explosion", pos)
