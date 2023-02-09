extends Camera2D

var animation
var zoom_from
var zoom_change
var pan_from
var pan_change
var pan_offset = Vector2.ZERO
var shake_offset = Vector2.ZERO
var shake_intensity
var after_zoom

func _ready():
	set_process(false)
	
func _process(delta):
	shake_offset.x = (randf() * 2 - 1) * (shake_intensity * $Timer.time_left)
	shake_offset.y = (randf() * 2 - 1) * (shake_intensity * $Timer.time_left)
	
	offset = pan_offset + shake_offset

func shake(intensity):
	set_process(true)
	
	shake_intensity = intensity
	
	$Timer.start()

func _on_Timer_timeout():
	set_process(false)
	
	shake_offset.x = 0
	shake_offset.y = 0
	
	offset = pan_offset

func zoom_to(factor, pan, callback = null):
	zoom_from = zoom
	zoom_change = factor - zoom
	
	pan_from = pan_offset
	pan_change = pan - pan_offset
	
	$Tween.remove_all()
	$Tween.interpolate_property(self, 'animation', 0, 1, zoom_change.length() / sqrt(2), Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	
	after_zoom = callback

func _on_Tween_tween_step(object, key, elapsed, value):
	zoom = zoom_from + zoom_change * animation
	
	pan_offset = pan_from + pan_change * animation
	
	offset = pan_offset + shake_offset

func _on_Tween_tween_completed(object, key):
	if after_zoom != null:
		after_zoom.call_func()
