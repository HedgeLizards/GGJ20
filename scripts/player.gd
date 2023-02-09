extends KinematicBody2D

signal stone_gathered

const MAX_HEALTH = 150.0

var interactions = []
var in_tower = false
var zoom_in_fix = false
var regenerating = false
var stones = 0 setget set_stones
var stone_rotation = 0
var reloading = false
var footstep_count = 0
var cooldown_frames = 0
var monsters_near = 0 setget set_monsters_near
var music_fading = 0

onready var health = MAX_HEALTH setget set_health
onready var ballista = $'/root/Game/Tower/Ballista'

func _ready():
	$Light2D.energy = min(position.length() / 800, 1)
	
	$Start.play()

func add_interaction(object):
	interactions.push_front(object)
	
	$'/root/Game/HUD/Label'.text = object.message

func remove_interaction(object):
	interactions.erase(object)
	
	if interactions.empty():
		$'/root/Game/HUD/Label'.text = ''
	else:
		$'/root/Game/HUD/Label'.text = interactions.front().message

func _unhandled_key_input(event):
	if event.is_action_pressed('ui_accept') && event.pressed && !event.echo:
		if !interactions.empty():
			interactions.front().interact(self)

func set_stones(new_value):
	stones = new_value
	
	emit_signal('stone_gathered', stones)
	
	remove_interaction(null)

func _physics_process(delta):
	if in_tower:
		if zoom_in_fix:
			$Light2D.enabled = true
			$CollisionShape2D.disabled = false
			
			visible = true
			in_tower = false
			zoom_in_fix = false
		elif !interactions.empty():
			var animated_sprite = ballista.get_node('AnimatedSprite')
			var sprite = ballista.get_node('Sprite')
			var fixed_mouse_position = get_global_mouse_position() - $Camera2D.shake_offset
			
			match round((ballista.position + sprite.position).angle_to_point(fixed_mouse_position / 0.6) / (0.25 * PI) + 3):
				0.0:
					animated_sprite.animation = 'side_down'
					animated_sprite.flip_h = false
					sprite.rotation_degrees = 120
				1.0:
					animated_sprite.animation = 'down'
					animated_sprite.flip_h = false
					sprite.rotation_degrees = 180
				2.0:
					animated_sprite.animation = 'side_down'
					animated_sprite.flip_h = true
					sprite.rotation_degrees = 240
				3.0:
					animated_sprite.animation = 'side'
					animated_sprite.flip_h = true
					sprite.rotation_degrees = 270
				4.0:
					animated_sprite.animation = 'side_up'
					animated_sprite.flip_h = true
					sprite.rotation_degrees = 300
				5.0:
					animated_sprite.animation = 'up'
					animated_sprite.flip_h = false
					sprite.rotation_degrees = 0
				6.0:
					animated_sprite.animation = 'side_up'
					animated_sprite.flip_h = false
					sprite.rotation_degrees = 60
				7.0, -1.0:
					animated_sprite.animation = 'side'
					animated_sprite.flip_h = false
					sprite.rotation_degrees = 90
			
			if !reloading && Input.is_action_pressed('ui_select'):
				ballista.get_node('Tween').interpolate_property(sprite, 'modulate', Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.9, Tween.TRANS_LINEAR, 0)
				ballista.get_node('Tween').start()
				
				ballista.get_node('Firing%d' % (randi() % 2)).play()
				
				var bolt = preload('res://scenes/bolt.tscn').instance()
				
				bolt.position = (ballista.position + sprite.position) * 0.6
				bolt.rotation = (fixed_mouse_position - bolt.position).angle()
				
				$'/root/Game'.add_child(bolt)
				
				$Camera2D.shake(15)
				
				reloading = true
	else:
		var velocity = Vector2(0, 0)
		
		if Input.is_action_pressed('ui_left'):
			velocity.x -= 1
		
		if Input.is_action_pressed('ui_right'):
			velocity.x += 1
		
		if Input.is_action_pressed('ui_up'):
			velocity.y -= 1
		
		if Input.is_action_pressed('ui_down'):
			velocity.y += 1
		
		if velocity == Vector2.ZERO || $'/root/Game/Tower'.health == 0:
			footstep_count = 0
			
			$AnimatedSprite.play('idle_%s' % $AnimatedSprite.animation.split('_')[1])
		else:
			if velocity.x == -1:
				$AnimatedSprite.play('walk_side')
				$AnimatedSprite.flip_h = true
			elif velocity.x == 1:
				$AnimatedSprite.play('walk_side')
				$AnimatedSprite.flip_h = false
			elif velocity.y == -1:
				$AnimatedSprite.play('walk_up')
			elif velocity.y == 1:
				$AnimatedSprite.play('walk_down')
			
			move_and_slide(velocity.normalized() * 500)
			
			$Light2D.energy = min(position.length() / 800, 1)
			
			z_index = (position.y - 40) / 100
			
			if footstep_count == 0:
				get_node('Footstep%d' % (randi() % 4)).play()
			
			footstep_count = (footstep_count + 1) % 36
		
		$Light2D.position.y = 110 + [0, 1, 2, 1, 0, -1][$AnimatedSprite.frame] * 5
		
		if stones > 0:
			stone_rotation = fmod(stone_rotation + delta, 2 * PI)
			
			$Interface.update()
	
	if regenerating:
		self.health += 1
		
		if health >= MAX_HEALTH:
			regenerating = false
	
	if cooldown_frames > 0:
		cooldown_frames -= 1
	
	$'/root/Game/Music/Low1'.volume_db = pow(lerp(min(position.length() / 3000, 1), 1, music_fading), 10) * -60
	$'/root/Game/Music/Low2'.volume_db = -60 + pow(lerp(min(max((position.length() - 1000) / 2000, 0), 1), 0, music_fading), 0.1) * 75
	
	$'/root/Game/Music/High1'.volume_db = -60 + pow(music_fading, 0.1) * 55

func set_monsters_near(new_value):
	if monsters_near == 0:
		$Tween.remove_all()
		$Tween.interpolate_property(self, 'music_fading', null, 1, 1, Tween.TRANS_LINEAR, 0)
		$Tween.start()
	elif new_value == 0:
		$Tween.remove_all()
		$Tween.interpolate_property(self, 'music_fading', null, 0, 5, Tween.TRANS_LINEAR, 0)
		$Tween.start()
	
	monsters_near = new_value

func leave_tower():
	zoom_in_fix = true

func set_health(new_value):
	var healthy = health / MAX_HEALTH
	
	$Light2D.scale = Vector2.ONE * (0.5 + healthy)
	
	$'/root/Game/CanvasModulate'.color[1] = max(healthy * 192 - 96, 0) / 255.0
	$'/root/Game/CanvasModulate'.color[2] = max(healthy * 192 - 96, 0) / 255.0
	
	if new_value <= 0:
		visible = false
		
		$CollisionShape2D.disabled = true
		$Camera2D.shake(150)
		
		interactions.clear()
		$'/root/Game/HUD/Label'.text = ''
		
		$'/root/Game/Music/Low1'.stop()
		$'/root/Game/Music/Low2'.stop()
		$'/root/Game/Music/High1'.stop()
		
		set_physics_process(false)
		
		$RegenerateTimer.stop()
		$DeadTimer.start()
		
		$Death.play()
	elif new_value < health:
		if cooldown_frames == 0:
			cooldown_frames = 60
			
			get_node('Hit%d' % (randi() % 2)).play()
		
		$RegenerateTimer.start()
	
	health = new_value

func _on_RegenerateTimer_timeout():
	regenerating = true

func _on_DeadTimer_timeout():
	get_tree().change_scene_to(load('res://scenes/title_screen.tscn'))

func die():
	if health > 0:
		self.health = 0
		
		$Destroyed.play()
