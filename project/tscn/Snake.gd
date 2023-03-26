extends Node2D

signal Snake_Death(death_pos)
signal increment_score(score)

var velocity : int = 120 # pixel per second
var speed : Vector2 = velocity * Vector2.UP # speed (Vector2)
var rotation_strength : int = 90 # degree per second

var HP : int = 100

var restrict_start : Vector2 = Vector2(480,0) # x coordinate (pixel) lower bound for snake
var restrict_end : Vector2 = Vector2(1440,1080)
# Restriction for y coord is 0~1080

var isInArea : bool = true

onready var Body = get_node("Body")
onready var HitBox = get_node("Body/HitBox")
onready var Trail = get_node("Trail")
onready var S_Area = get_node("S_Area")
onready var Icon = $Body/Icon

onready var MainGame = get_node("..")

func _ready():
	Icon.play("slide")
	#MainGame._update_HUD_HP(HP)
	pressed_time = 0.0
	Special_Icon.visible = false

func _input(event):
	if event.is_action_pressed("ui_accept"):
		# Special ability
		pass
		
	pass

func _process(delta):
	var wasPosition : Vector2 = Body.position
	
	################### Input handling + Snake movement #######################
	if Input.is_action_pressed("ui_right"):
		speed = speed.rotated( deg2rad(rotation_strength * delta))
		speed = speed.normalized() * velocity
	if Input.is_action_pressed("ui_left"):
		speed = speed.rotated( - deg2rad(rotation_strength * delta))
		speed = speed.normalized() * velocity
	
	Body.rotation_degrees = rad2deg(speed.angle())
	Body.position = Body.position + speed * delta
	# Fix OOB cases
	var fixed_value = fix_OOB(Body.position, speed)
	Body.position = fixed_value[0]
	speed = fixed_value[1]
	
	# Input handling for snake power attack! #################################
	
	if Input.is_action_pressed("ui_accept"):
		pressed_time = pressed_time + delta
	else:
		pressed_time = 0
	
	if ( Input.is_action_just_released("ui_accept") and Special_Icon.visible ):
		# beeeeam!
		print("beeeeam!")
		pressed_time = 0
		emit_signal("use_special_ability", Body.position)
		return
	
	if pressed_time >= 1.0 and _calc_Area( S_Area.polygon ) >= 1036800 * 0.25:
		Special_Icon.visible = true
	else :
		Special_Icon.visible = false
	
	###########################################################################
	
	################# Trail rendering + Area calculation ######################
	var wasInArea : bool = isInArea
	isInArea = Geometry.is_point_in_polygon( Body.position, S_Area.polygon )
	
	if ( wasInArea and not isInArea): # Just got outside
		add2Trail(wasPosition)
		add2Trail(Body.position)
	elif( not wasInArea and not isInArea): # still outside
		add2Trail(Body.position)
		if(check_self_intersect()): # if self intersect -> die
			HP = 0
			MainGame._update_HUD_HP(HP)
			snake_death()
			print("Died")
			return
	elif( not wasInArea and isInArea) : #Just got inside
		add2Trail(Body.position)
		# Make polygon and merge
		print("Merge!")
		var increased_area = add_Trail2Area()
		print("increased_area" + String(increased_area))
		MainGame._update_HUD_Area( _calc_Area( S_Area.polygon ) )
		emit_signal("increment_score", calc_area_score(increased_area))
	else:
		pass
	###########################################################

func fix_OOB(curr_pos : Vector2, speed : Vector2) -> Array:
	if( curr_pos.x < restrict_start.x ): # left OOB
		curr_pos.x = restrict_start.x
		if( speed.y > 0 ): # Going down while sticking left
			speed = velocity * Vector2.DOWN
		else:
			speed = velocity * Vector2.UP
	elif( curr_pos.x > restrict_end.x ): # right OOB
		curr_pos.x = restrict_end.x
		if( speed.y > 0 ): # Going down while sticking right
			speed = velocity * Vector2.DOWN
		else:
			speed = velocity * Vector2.UP
	
	if( curr_pos.y < restrict_start.y ): # up OOB
		curr_pos.y = restrict_start.y
		if( speed.x > 0 ): # Going right while sticking up
			speed = velocity * Vector2.RIGHT
		else:
			speed = velocity * Vector2.LEFT
	elif( curr_pos.y > restrict_end.y ): # down OOB
		curr_pos.y = restrict_end.y
		if( speed.x > 0 ): # Going right while sticking down
			speed = velocity * Vector2.RIGHT
		else:
			speed = velocity * Vector2.LEFT
	
	return [curr_pos, speed]

func add2Trail(new_position : Vector2):
	Trail.add_point(new_position)

func check_self_intersect() -> bool:
	var num = Trail.get_point_count()
	if( num <= 3) : return false
	
	var target_seg_start : Vector2 = Trail.get_point_position(num-2)
	var target_seg_end : Vector2 = Trail.get_point_position(num-1)
	var seg_start : Vector2
	var seg_end : Vector2
	for i in range(num-4):
		seg_start = Trail.get_point_position(i)
		seg_end = Trail.get_point_position(i+1)
		if( typeof(Geometry.segment_intersects_segment_2d(seg_start, seg_end,
			target_seg_start, target_seg_end)) == TYPE_VECTOR2 ):
			return true
	
	return false

func add_Trail2Area() -> float:
	set_process(false) # Stop movement of snake
	
	var area_before : float = _calc_Area( S_Area.polygon )
	
	var res = Geometry.merge_polygons_2d( S_Area.polygon, Trail.points )
	S_Area.polygon = res[0]
	Trail.clear_points()
	
	var area_after : float = _calc_Area( S_Area.polygon )
	
	set_process(true)
	
	return area_after - area_before

func _calc_Area(points : PoolVector2Array) -> float:
	var res : float = 0
	
	var num = points.size()
	
	if( num <= 2 ): return 0.0
	
	points.append(points[0])
	
	for i in range(num):
		res = res + points[i].x * points[i+1].y
		res = res - points[i].y * points[i+1].x
	res = res/2
	
	return res
	
func calc_area_score(area):
	return int(area * 0.01)

####################### Snake death and birth #######################
var death_pos : Vector2
func snake_death():
	set_process(false)
	death_pos = Body.position
	
	Icon.connect("animation_finished", self, "_on_Icon_death_animation_finished")
	Icon.play("death")
	
	Trail.clear_points()
	S_Area.polygon = []
	MainGame._update_HUD_Area( _calc_Area( S_Area.polygon ) )

func _on_Icon_death_animation_finished():
	visible = false
	Icon.disconnect("animation_finished", self, "_on_Icon_death_animation_finished")
	emit_signal("Snake_Death", death_pos)

func snake_birth(pos : Vector2):
	print("Snakebirth")
	set_process(false)
	Body.position = pos
	Trail.clear_points()
	S_Area.polygon = [ pos + Vector2(36, -64), pos + Vector2(76, 0) , pos + Vector2(36, 64),
						pos + Vector2(-36, 64), pos + Vector2(-76, 0), pos + Vector2(-36, -64) ]
	# This S_Area.polygon = [...] will make a Hexagon shaped area.
	self.visible = true
	
	# Body Icon animate
	Icon.connect("animation_finished", self, "_on_Icon_birth_animation_finished")
	Icon.play("birth")
	HP = 100
	MainGame._update_HUD_HP(HP, 1)
	MainGame._update_HUD_Area( _calc_Area( S_Area.polygon ) )

func _on_Icon_birth_animation_finished():
	Icon.play("slide")
	Icon.disconnect("animation_finished", self, "_on_Icon_birth_animation_finished")
	set_process(true)

######################################################################

###################### Snake special ability #########################
var pressed_time : float = 0.0
onready var Special_Icon = get_node("Body/Special_charge")

signal use_special_ability(ability_pos)
