extends Node2D

var movement_speed : float = 5

func _get_Image(load_dir, speed, z_index):
	$Sprite.texture = load(load_dir)
	movement_speed = speed
	self.z_index = z_index

func _process(delta):
	self.position.y = self.position.y + movement_speed * delta
	
	if(self.position.y > 1100):
		self.queue_free()
