extends Node

func _ready():
	for i in range(1000):
		spawn(preload('res://scenes/grass.tscn'), 0, 2)
	
	for i in range(100):
		spawn(preload('res://scenes/stone.tscn'), 1000, 3)
	
	for i in range(200):
		spawn(preload('res://scenes/tree.tscn'), 1000, 4)

func spawn(scene, min_radius, spread):
	var instance = scene.instance()
	
	var direction = randf() * 2 * PI
	var radius = 4000 - (4000 - min_radius) * pow(randf(), spread)
	
	instance.position.x = cos(direction) * radius
	instance.position.y = sin(direction) * radius
	
	add_child(instance)

func _on_Timer_timeout():
	if randi() % 5 == 0:
		spawn(preload('res://scenes/monster.tscn'), 2000, 2)

func _unhandled_key_input(event):
	if event.scancode == KEY_ESCAPE && event.pressed && !event.echo:
		get_tree().change_scene_to(load('res://scenes/title_screen.tscn'))
