extends ColorRect

var background_alpha = 0.0
var background_color = ColorN("white")
export (float) var MAX_ALPHA = 0.7

signal outside_clicked()

func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func _on_ColorRect_gui_input(event):
	if event.is_action_released("ui_mouse_click"):
		emit_signal("outside_clicked")

# warning-ignore:unused_argument
func _process(delta):
	color = ProgramController.get_background_color()
	color.a = background_alpha
	rect_pivot_offset = rect_size*0.5

func fade_in(speed=0.6):
	$Tween.interpolate_property(self, "background_alpha", background_alpha, MAX_ALPHA, speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	mouse_filter = Control.MOUSE_FILTER_STOP
	
func fade_out(speed=0.6):
	$Tween.interpolate_property(self, "background_alpha", background_alpha, 0.0, speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
