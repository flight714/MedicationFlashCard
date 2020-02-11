extends CenterContainer

var body_system_category = []
var selected_effects = []
var system = ""

var button = preload("res://flashcard_code/ListButton.tscn")
var add_new_menu = preload("res://flashcard_code/TextEditMenu.tscn")
var is_submenu_active = false
signal report_result(result)

var background_color = Color(0,0,0)
var background_alpha = 0.0

func _ready():
	rect_scale = Vector2(0,0)
	for effect in body_system_category:
		_add_button(effect)
	for existing in selected_effects:
		_add_button(existing)
	roll_in()
	check_array_and_update_text()

# warning-ignore:unused_argument
func _unhandled_input(event):
	if is_submenu_active == false:
		if event.is_action_released("ui_cancel"):
			roll_out()
		
func _process(delta):
	$VBoxContainer/ScrollContainer/GridContainer/Selection.text = str(selected_effects)
	for button in $VBoxContainer/ScrollContainer/GridContainer.get_children():
		if button is Button:
			if selected_effects.has(button.text):
				button.modulate = ColorN("green").lightened(0.8)
			else:
				button.modulate = ColorN("white")
				

func _add_button(effect : String):
	var new_button = button.instance()
	new_button.text = effect
	$VBoxContainer/ScrollContainer/GridContainer.add_child(new_button)
	new_button.connect("send_button_info", self, "add_result")

func add_result(result : String):
	if selected_effects.has(result):
		selected_effects.remove(result)
	else:
		selected_effects.append(result)

func send_result(result : Array):
	emit_signal("report_result", result)
	roll_out()
	
func check_array_and_update_text():
	if body_system_category.size() > 1:
		$VBoxContainer/ScrollContainer/GridContainer/DynamicLabel.text = "Select an effect from the list or create a new one!"
	else:
		$VBoxContainer/ScrollContainer/GridContainer/DynamicLabel.text = "No known effects, create a new effect!"

func get_starting_info(dict_category : String, new_array : Array):
	system = dict_category
	body_system_category = ProgramController.body_system_dict[system]["known_effects"]
	selected_effects = new_array
	
func get_array_info(array_data : Array):
	for i in array_data:
		selected_effects.append(i)
	check_array_and_update_text()
	is_submenu_active = false
	
func roll_in():
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(1,1), 0.7, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	tween.queue_free()
	
func roll_out():
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(0,0), 0.7, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	tween.queue_free()
	queue_free()


func _on_AddNew_pressed():
	if !is_submenu_active:
		var new_text_menu = add_new_menu.instance()
		new_text_menu.current_mode = TextEditMenu.EditMode.SERIES
		new_text_menu.system = system
		add_child(new_text_menu)
		new_text_menu.connect("finished_system_entry", self, "get_array_info")
		new_text_menu.connect("canceled_menu", self, "_on_cancel_submenu")
		is_submenu_active = true


func _on_Submit_pressed():
	if !is_submenu_active:
		emit_signal("report_result", system, selected_effects)
		roll_out()


func _on_Cancel_pressed():
	if !is_submenu_active:
		roll_out()

func _on_cancel_submenu():
	is_submenu_active = false
