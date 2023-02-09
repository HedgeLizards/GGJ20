extends Area2D

onready var message = 'Stone\npress F to pick up'

func _ready():
	$'/root/Game/Player'.connect('stone_gathered', self, 'update_message')

func update_message(stones):
	match stones:
		0:
			message = 'Stone\npress F to pick up'
		10:
			message = 'Stone\nyou cannot hold any more'

func _on_Stone_body_entered(body):
	body.add_interaction(self)

func _on_Stone_body_exited(body):
	body.remove_interaction(self)

func interact(player):
	if player.stones < 10:
		player.stones += 1
		player.get_node('Interface').update()
		
		$Sprite.texture = preload('res://assets/environment/stone_removed.png')
		$CollisionShape2D.disabled = true
		
		$AudioStreamPlayer.play()
