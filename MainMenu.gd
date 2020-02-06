extends Node2D

func _ready():
	$CanvasLayer/Background.color = ProgramController.get_background_color()
	for c in $CanvasLayer/CenterContainer/VBoxContainer.get_children():
		c.modulate = ProgramController.check_body_system_color("null")
		c.modulate.a = 0.0
	fade_in(1.5)

func _on_CreateNew_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://flashcard_code/FlashCard.tscn")

func fade_in(speed=0.7):
	var fade_tween = Tween.new()
	add_child(fade_tween)	
	for c in $CanvasLayer/CenterContainer/VBoxContainer.get_children():
		fade_tween.interpolate_property(c, "modulate", c.modulate, Color(c.modulate.r, c.modulate.b, c.modulate.b, 1.0), speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	fade_tween.start()
	yield(fade_tween, "tween_all_completed")
	fade_tween.queue_free()

func fade_out(speed=0.7):
	var fade_tween = Tween.new()
	add_child(fade_tween)
	for c in $CanvasLayer/CenterContainer/VBoxContainer.get_children():
		fade_tween.interpolate_property(c, "modulate", c.modulate, Color(c.modulate.r, c.modulate.b, c.modulate.b, 0.0), speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	fade_tween.start()
	yield(fade_tween, "tween_all_completed")
	fade_tween.queue_free()
