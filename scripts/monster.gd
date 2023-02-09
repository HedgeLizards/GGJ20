extends KinematicBody2D

var is_near_player = false
var is_following_player = false

onready var player = $'/root/Game/Player'

func _physics_process(delta):
	var target = Vector2.ZERO if player.in_tower else player.position + Vector2(0, 110) * 0.6
	
	if position.distance_to(target) < 650 && player.health > 0:
		if !is_near_player:
			is_near_player = true
			
			player.monsters_near += 1
	else:
		if is_near_player:
			is_near_player = false
			
			player.monsters_near -= 1
		
		target = Vector2.ZERO
	
	if target == Vector2.ZERO:
		is_following_player = false
	elif !is_following_player:
		is_following_player = true
		
		$AudioStreamPlayer.play()
	
	var direction = (target - position).angle()
	var velocity = Vector2(cos(direction), sin(direction))
	
	if abs(velocity.x) >= abs(velocity.y):
		$AnimatedSprite.flip_h = velocity.x < 0
		
		$AnimatedSprite.play('side')
	elif velocity.y < 0:
		$AnimatedSprite.play('up')
	else:
		$AnimatedSprite.play('down')
	
	move_and_slide(velocity * 250)
	
	if get_slide_count() > 0:
		var collider = get_slide_collision(0).collider
		
		if collider.has_method('set_health'):
			collider.health -= 1
	
	z_index = (position.y - 40) / 100
