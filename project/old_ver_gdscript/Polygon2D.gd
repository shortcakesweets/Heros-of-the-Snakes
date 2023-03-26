extends Polygon2D

func _ready():
	pass

func add_area(new_polygon : PoolVector2Array):
	# find index of nearest start / end
	var start : Vector2 = new_polygon[0]
	var nearest_start : int
	var nearest_start_length = 999999
	
	var end : Vector2 = new_polygon[new_polygon.size() - 1]
	var nearest_end : int
	var nearest_end_length = 999999
	for i in range(self.polygon.size()) :
		var old_polygon_point = self.polygon[i]
		if(nearest_start_length > (old_polygon_point - start).length()):
			nearest_start = i
			nearest_start_length = (old_polygon_point - start).length()
		if(nearest_end_length > (old_polygon_point - end).length()):
			nearest_end = i
			nearest_end_length = (old_polygon_point - end).length()
	
	if( nearest_start < nearest_end ):
		for i in range(nearest_start, nearest_end):
			new_polygon.append(self.polygon[i])
	elif( nearest_start > nearest_end ):
		for i in range(nearest_end, nearest_start):
			new_polygon.append(self.polygon[i])
	
	var res = Geometry.merge_polygons_2d(self.polygon, new_polygon)
	
	self.polygon = res[0]
