extends StaticBody2D

onready var health = 0 setget set_health
onready var message = '%s\nrequires stone to repair' % name
onready var player = $'/root/Game/Player'

func _ready():
	player.connect('stone_gathered', self, 'update_message')

func update_message(stones):
	match stones:
		0:
			message = '%s\nrequires stones to repair' % name
		1:
			message = '%s\npress F to repair with %d stone' % [name, stones]
		_:
			message = '%s\npress F to repair with %d stones' % [name, stones]

func _on_Area2D_body_entered(body):
	body.add_interaction(self)

func _on_Area2D_body_exited(body):
	body.remove_interaction(self)

func interact(player):
	if player.stones > 0:
		get_parent().repair(player.stones)
		
		player.stones = 0
		player.get_node('Interface').update()

func set_health(new_value):
	get_parent().damage(-new_value)
