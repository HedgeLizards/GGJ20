extends TextureProgress

func progress_to(new_value):
	$Tween.remove_all()
	$Tween.interpolate_property(self, 'value', null, new_value, 0.3, Tween.TRANS_LINEAR, 0)
	$Tween.start()

func _on_Tween_tween_step(object, key, elapsed, value):
	$Label.text = '%.2f%%' % stepify(value * 100, 0.01)
