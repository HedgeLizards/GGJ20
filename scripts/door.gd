extends Area2D

var message = 'Watch Tower\npress F to enter'

func _on_Door_body_entered(body):
	body.add_interaction(self)

func _on_Door_body_exited(body):
	body.remove_interaction(self)

func interact(player):
	if player.in_tower:
		message = 'Watch Tower\npress F to enter'
		
		player.remove_interaction(self)
		player.get_node('Camera2D').zoom_to(Vector2(1, 1), Vector2.ZERO, funcref(player, 'leave_tower'))
	else:
		message = ''
		
		player.add_interaction(self)
		player.get_node('Camera2D').zoom_to(Vector2(2, 2), Vector2(0, -150) - player.position)
		
		player.get_node('Light2D').enabled = false
		player.get_node('CollisionShape2D').disabled = true
		
		player.visible = false
		player.in_tower = true
