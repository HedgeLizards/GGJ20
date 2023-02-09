extends StaticBody2D

func _ready():
	var type = randi() % 3
	
	$Trunk.texture = load('res://assets/tree/trunk_%d.png' % type)
	$Foliage.texture = load('res://assets/tree/foliage_%d.png' % type)
	
	z_index = (position.y - 145) / 100
