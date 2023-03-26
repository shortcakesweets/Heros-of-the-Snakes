extends Line2D

func _ready():
	pass

func check_self_intersect() -> bool:
	var num = self.get_point_count()
	var count = 0
	
	if( num <= 2 ) :
		return false
	
	var a = self.get_point_position( num - 2 )
	var b = self.get_point_position( num - 1 )
	
	var j : Vector2 = self.get_point_position(0)
	for i in self.points:
		if count == num - 2:
			break
		count+=1
		
		if typeof(Geometry.segment_intersects_segment_2d(a, b, i, j)) == TYPE_VECTOR2 :
			return true
		
		j = i
	
	return false
