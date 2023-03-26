extends Node2D

onready var Snake = get_node("Snake")
onready var Enemy = get_node("Enemy")
onready var Enemy_Bullet = get_node("Enemy_Bullet")
onready var HUD_HP = get_node("HUD_HP")
onready var HUD_Area = get_node("HUD_Area")
onready var ScoreLabel = $HUD/HBoxContainer/ScoreLabel

onready var Snake_Bullet = get_node("Snake_Bullet")
onready var Snake_Special = get_node("Special_Ability")

onready var ScreenShake = get_node("ScreenShake")

onready var Level = get_node("Level")

func _ready():
	# if you erase this, you can spawn enemies by pressing 'space'
	set_process(false)
	################################################################
	
	Snake_Special.visible = false
	
	HUD_HP.set_snake_HP( Snake.HP )
	HUD_Area.set_snake_Area( Snake._calc_Area( Snake.S_Area.polygon ) )
	Snake.connect("increment_score", self, "_on_ScoreLabel_increment_score")
	
	_clear_map()
	_start_level()

func _get_Snake_Position() -> Vector2:
	return Snake.Body.position

################### Functions for enemy bullets ###################

func _is_Bullet_on_Snake(bullet_pos : Vector2) -> bool:
	return Geometry.is_point_in_polygon( bullet_pos - Snake.Body.position , Snake.HitBox.polygon )

func _is_Bullet_on_Trail(bullet_pos : Vector2, bullet_pos_prev : Vector2) -> bool:
	var num = Snake.Trail.get_point_count()
	for i in range(num-1):
		var seg_start : Vector2 = Snake.Trail.get_point_position(i)
		var seg_end : Vector2 = Snake.Trail.get_point_position(i+1)
		
		if( typeof(Geometry.segment_intersects_segment_2d(seg_start, seg_end,
			bullet_pos, bullet_pos_prev)) == TYPE_VECTOR2 ):
				return true
	
	return false

func _is_Bullet_on_Area(bullet_pos : Vector2) -> bool:
	return Geometry.is_point_in_polygon( bullet_pos , Snake.S_Area.polygon )

func _on_Enemy_Bullet__on_Snake_hit(): # Instant kill
	Snake.HP = 0
	HUD_HP.set_snake_HP( Snake.HP )
	Snake.snake_death()

func _on_Enemy_Bullet__on_Area_hit(hit_Vector2, damage):
	ScreenShake.start()
	
	Snake.set_process(false)
	
	var radius = 2 * damage
	
	var bullet_circle : PoolVector2Array = []
	
	for i in range(360):
		bullet_circle.append( hit_Vector2 + radius * Vector2.RIGHT.rotated( deg2rad(i) ) )
	
	# Check if player is in bullet_circle ( if it is, instant kill )
	if( Geometry.is_point_in_polygon( Snake.Body.position, bullet_circle ) ):
		Snake.HP = 0
		HUD_HP.set_snake_HP( Snake.HP )
		Snake.snake_death()
		return
	
	# Check if Trail's start is in bullet_circle
	if( Geometry.is_point_in_polygon( Snake.Trail.get_point_position(0) , bullet_circle ) ):
		Snake.HP = 0
		HUD_HP.set_snake_HP( Snake.HP )
		Snake.snake_death()
		return
	
	var res = Geometry.clip_polygons_2d( Snake.S_Area.polygon, bullet_circle )
	
	if( res.size() >= 1 ):
		Snake.S_Area.polygon = res[0]
	
	_update_HUD_Area( _get_snake_Area() )
	
	Snake.set_process(true)

func _on_Enemy_Bullet__on_Trail_hit(damage):
	Snake.HP = Snake.HP - damage
	if( Snake.HP <= 0 ):
		Snake.HP = 0
		Snake.snake_death()
	HUD_HP.set_snake_HP( Snake.HP )

func _on_ScoreLabel_increment_score(score):
	print("HI")
	ScoreLabel.text = str(int(ScoreLabel.text) + score) 
	
	# damage , amount
	var dmg_coeff = 0.1
	Snake_Bullet._call_Laser_Object( score * dmg_coeff , 5, 0.05, 0.05)
	var SFX = load("res://enemy_bullet/SFX.tscn").instance()
	add_child(SFX)
	SFX.play_sfx_at_pos("laserbeam", Vector2(960, 540))

###################################################################

####################### Functions for HUDs ######################

func _get_snake_HP() -> int:
	return Snake.HP

func _get_snake_Area():
	return Snake._calc_Area(Snake.S_Area.polygon)

func _update_HUD_HP(hp, tween_duration = 0.3):
	HUD_HP.set_snake_HP(hp, tween_duration)
	
func _update_HUD_Area(area, tween_duration = 0.3):
	HUD_Area.set_snake_Area(area, tween_duration)

#################################################################

################# Functions for Snake Birth/Death and special ###############

func _on_Snake_Snake_Death(death_pos):
	# HP, Area HUD update
	
	if( HUD_HP.life > 0 ):
		HUD_HP.change_life(-1)
		Enemy_Bullet._delete_Bullet(death_pos, 300)
		Snake.snake_birth(death_pos)
	else:
		print(" Snake really died... rip ")
		
	
	pass # Replace with function body.

func _on_Snake_use_special_ability(ability_pos):
	rebirth_point = ability_pos
	
	var enemies = Enemy.get_children()
	var bullets = Enemy_Bullet.get_children()
	
	for enemy in enemies:
		enemy.set_process(false)
	for bullet in bullets:
		bullet.set_process(false)
	
	Snake.set_process(false)
	
	Snake_Special.frame = 0
	Snake_Special.visible = true
	Snake_Special.connect("animation_finished", self, "_on_Special_Animation_finished")
	Snake_Special.play("slice")

var rebirth_point : Vector2

func _on_Special_Animation_finished():
	yield(get_tree().create_timer(1.0), "timeout")
	var enemies = Enemy.get_children()
	#var bullets = Enemy_Bullet.get_children()
	
	for enemy in enemies:
		enemy.set_process(true)
	
	var dmg_coeff = 0.01
	Snake_Bullet._call_Laser_Object( Snake._calc_Area( Snake.S_Area.polygon ) * dmg_coeff , 10, 0.05, 0.05)
	
	var bullets = Enemy_Bullet.get_children()
	for bullet in bullets:
		bullet.queue_free()
	
	Snake_Special.visible = false
	Snake_Special.disconnect("animation_finished", self, "_on_Special_Animation_finished")
	
	Snake.snake_birth(rebirth_point)


#################################################################

################# Functions for Level design ####################
func _clear_map():
	var enemies = Enemy.get_children()
	var bullets = Enemy_Bullet.get_children()
	
	for enemy in enemies:
		enemy.queue_free()
	for bullet in bullets:
		bullet.queue_free()

func _start_level():
	yield(get_tree().create_timer(3.0), "timeout")
	Level.play_scene_in_order()

#################################################################

# Debug
func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
		Enemy._spawn_Enemy("Larva", Vector2(30,30))
	
	pass

