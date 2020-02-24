extends TextureButton

var sun_icon = preload("res://assets/sun.png")
var moon_icon = preload("res://assets/moon.png")
signal change_mode

func _ready():
	check_icon()
# warning-ignore:return_value_discarded
	connect("change_mode", ProgramController, "switch_night_mode")
	

func setup_textures(texture : Texture):
	texture_normal = texture
	texture_focused = texture
	texture_hover = texture
	texture_pressed = texture
	
func check_icon():
	if ProgramController.config_settings["isNightMode"]:
		setup_textures(moon_icon)
	else:
		setup_textures(sun_icon)


func _on_NightModeSwitch_pressed():
	emit_signal("change_mode")
	check_icon()
