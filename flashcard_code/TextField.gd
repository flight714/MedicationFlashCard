extends RichTextLabel

func _ready():
	modulate = ProgramController.check_body_system_color("null")
