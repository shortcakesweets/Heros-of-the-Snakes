extends Node2D

var is_casting_laser := false
var cast_point := Vector2()
var end_point := Vector2()
var timer : float = 0
var longing_time : float

# Called when the node enters the scene tree for the first time.
func _ready():
	$Line2D.points[0] = Vector2.ZERO
	$Line2D.points[1] = Vector2.ZERO
	timer = 0
	longing_time = 1

func set_is_casting(cast : bool, casting_point : Vector2, ending_point : Vector2) -> void:
	is_casting_laser = cast
	cast_point = casting_point
	end_point = ending_point
	
	$Line2D.points[0] = cast_point
	$Line2D.points[1] = end_point
	
	$CastingParticle.emitting = is_casting_laser
	$CastingParticle.global_position = cast_point
	$CastingParticle.global_rotation = (end_point - cast_point).angle()
	
	$CollisionParticle.global_position = end_point
	$CollisionParticle.global_rotation = (cast_point - end_point).angle()
	$CollisionParticle.emitting = is_casting_laser
	
	$BeamParticle.global_position = (cast_point + end_point) * 0.5
	$BeamParticle.process_material.emission_box_extents.x = (cast_point - end_point).length() * 0.5
	$BeamParticle.global_rotation = (cast_point - end_point).angle()
	$BeamParticle.emitting = is_casting_laser

func _process(delta):
	timer = timer + delta
	if(timer > longing_time):
		set_is_casting(false, cast_point, end_point)
		disappear()

func appear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 0, 8.0, 0.05)
	$Tween.start()

func disappear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 8.0, 0, 0.025)
	$Tween.start()
	
	self.queue_free()

func _turn_on_LaserEffect(casting_pos : Vector2, ending_pos : Vector2, timer_max):
	longing_time = timer_max
	
	appear()
	set_is_casting(true, casting_pos, ending_pos)

