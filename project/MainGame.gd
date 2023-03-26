extends Node2D

onready var Snake = get_node("Snake")
onready var Enemy = get_node("Enemy")
onready var ScoreLabel = $HUD/HBoxContainer/Score

var score = 0

func _ready():
	# if you erase this, you can spawn enemies by pressing 'space'
	set_process(false)
	
	score = 0
	Snake.connect("increment_score", self, "_on_Snake_increment_score")

func _get_Snake_Position() -> Vector2:
	return Snake.Body.position

################### Functions for enemy bullets ###################

func _is_Bullet_on_Snake(bullet_pos : Vector2) -> bool:
	return Geometry.is_point_in_polygon( bullet_pos, Snake.HitBox.polygon )

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
	return Geometry.is_point_in_polygon( bullet_pos, Snake.S_Area.polygon )

###################################################################

func _on_Snake_increment_score(score):	
	ScoreLabel.text = str(int(ScoreLabel.text) + score)

# Debug
func _process(_delta):
	if Input.is_action_pressed("ui_accept"):
		Enemy._spawn_Enemy("Larva", Vector2(30,30))
	
	pass
