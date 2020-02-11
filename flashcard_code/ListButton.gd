extends Button

signal send_button_info(text)

func _ready():
	pass

func _on_Button_pressed():
	emit_signal("send_button_info", text)
