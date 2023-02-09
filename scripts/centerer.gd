extends Node2D

onready var viewport = get_viewport()
onready var game_size = Vector2(
	ProjectSettings.get_setting('display/window/size/width'),
	ProjectSettings.get_setting('display/window/size/height')
)
onready var factor = OS.window_size / game_size

func _ready():
	var border_offset = OS.get_real_window_size() * (OS.window_size / game_size) - OS.window_size

	OS.window_position = (OS.get_screen_size() - OS.window_size) / 2 - border_offset

	viewport.global_canvas_transform.x.x = factor.x
	viewport.global_canvas_transform.y.y = factor.y

	viewport.connect('size_changed', self, 'center_game')

	center_game()

func center_game():
	viewport.global_canvas_transform.origin = OS.window_size * (Vector2(0.5, 0.5) - 0.5 * factor)
