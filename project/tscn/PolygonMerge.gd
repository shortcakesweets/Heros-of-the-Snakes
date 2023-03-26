extends Node2D

onready var PolygonA = get_node("PolygonA")
onready var PolygonB = get_node("PolygonB")

onready var Line = get_node("Line2D")

func _ready():
	pass

func _on_Button_pressed():
	
	print(PolygonA.polygon)
	print(PolygonB.polygon)
	print("###########")
	
	var res = Geometry.merge_polygons_2d( PolygonA.polygon, PolygonB.polygon )
	print(res)
	PolygonA.polygon = res[0]
	
	for points in res[0]:
		Line.add_point(points)
	
	#PolygonA.queue_free()
	#PolygonB.queue_free()
