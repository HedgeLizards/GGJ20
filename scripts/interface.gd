extends Node2D

func _draw():
	for i in range(get_parent().stones):
		var phase = get_parent().stone_rotation - i * PI / 5
		var place = Vector2(cos(phase) * 190, sin(phase) * 165 + 7) - Vector2(38, 33) / 2
		
		draw_texture(preload('res://assets/environment/stone_floaty.png'), place)
