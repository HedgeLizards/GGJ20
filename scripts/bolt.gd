extends Area2D

onready var ballista = $'/root/Game/Tower/Ballista'
onready var player = $'/root/Game/Player'

func _process(delta):
	position += Vector2(cos(rotation), sin(rotation)) * 1000 * delta

func _on_Bolt_body_entered(body):
	ballista.get_node('Hit%d' % (randi() % 3)).play()
	
	$'/root/Game/Player/Camera2D'.shake(30)
	
	if body.is_near_player:
		player.monsters_near -= 1
	
	body.set_physics_process(false)
	body.queue_free()
	
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
