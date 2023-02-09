extends Sprite

func _ready():
	texture = load('res://assets/environment/grass_%d.png' % (randi() % 3))
