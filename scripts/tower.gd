extends Node2D

const MAX_HEALTH = 50000.0

onready var health = MAX_HEALTH / 4
onready var player = $'/root/Game/Player'

func repair(stones):
	health = min(health + stones * 1250, MAX_HEALTH)
	
	$Health.progress_to(health / MAX_HEALTH)
	
	if health < MAX_HEALTH:
		$Repairing.play()
	else:
		$Repaired.play()
		
		for node in $'/root/Game/'.get_children():
			if 'Monster' in node.name:
				if node.is_near_player:
					player.monsters_near -= 1
				
				node.set_physics_process(false)
				node.queue_free()
		
		$'/root/Game/Timer'.start()
		$'/root/Game/Player/DeadTimer'.start()

func damage(points):
	if health == 0 || health == MAX_HEALTH:
		return
	
	health -= points
	
	$Health.progress_to(health / MAX_HEALTH)
	
	if health == 0:
		$Light2D.queue_free()
		$Destroyed.play()
		
		player.get_node('Camera2D').shake(300)
		player.get_node('Camera2D').zoom_to(Vector2(2.01, 2.01), Vector2(0, -150) - player.position, funcref(player, 'die'))

func _on_Tween_tween_completed(object, key):
	$'/root/Game/Player'.reloading = false
