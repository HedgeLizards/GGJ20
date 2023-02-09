extends Area2D

export(NodePath) var target_node
export(float) var target_alpha

var overlapping = 0

func _ready():
	target_node = get_node(target_node)

func _on_Visibility_body_entered(body):
	if overlapping == 0:
		$Tween.remove_all()
		$Tween.interpolate_property(target_node, 'modulate', null, Color(1, 1, 1, target_alpha), (target_node.modulate[3] - target_alpha) * (target_alpha / 0.75), Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$Tween.start()
	
	overlapping += 1

func _on_Visibility_body_exited(body):
	overlapping -= 1
	
	if overlapping == 0:
		$Tween.remove_all()
		$Tween.interpolate_property(target_node, 'modulate', null, Color(1, 1, 1, 1), (1 - target_node.modulate[3]) * (target_alpha / 0.75), Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$Tween.start()
