extends Control

onready var viewport = get_viewport()

func _ready():
	randomize()
	
	viewport.connect('size_changed', self, 'update')

func _draw():
	var window_size = viewport.get_visible_rect().size / 0.4
	
	draw_rect(Rect2(-window_size / 2, window_size), Color.black)

func _on_Start_pressed():
	get_tree().change_scene_to(preload('res://scenes/game.tscn'))

func _on_Exit_pressed():
	get_tree().quit()

func _unhandled_key_input(event):
	if event.pressed && !event.echo:
		match event.scancode:
			KEY_ENTER:
				_on_Start_pressed()
			KEY_ESCAPE:
				_on_Exit_pressed()
