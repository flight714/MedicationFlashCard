extends CenterContainer

class_name TextEditMenu

enum EditMode {DESCRIPTION, NAME, SERIES}
var current_mode = EditMode.SERIES

var text_body = ""
var text_array = []
var current_index = 0
var category = "null"
var system = ""

signal finished_entry(category, entry)
signal finished_system_entry(entry)
signal canceled_menu()

func _ready():
	setup_menu()
	
	rect_scale = Vector2(0,0)
	var size_tween = Tween.new()
	add_child(size_tween)
	size_tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(1,1), 0.7, Tween.TRANS_SINE, Tween.EASE_OUT)
	size_tween.start()
	yield(size_tween, "tween_completed")
	size_tween.queue_free()
	$VBoxContainer/HBoxContainer/Previous.disabled = true
	$VBoxContainer/TextEdit.text = text_body
		
func setup_menu():
	if current_mode == EditMode.NAME:
		$VBoxContainer/Label.text = "Please enter a name and hit Enter"
		$VBoxContainer/HBoxContainer/Exit.disabled = true
	if current_mode == EditMode.DESCRIPTION:
		$VBoxContainer/Label.text = "Please enter a brief description and hit Enter"
		$VBoxContainer/HBoxContainer/Exit.disabled = true
	if current_mode == EditMode.SERIES:
		$VBoxContainer/Label.text = "Please enter the first item and hit Enter to continue adding items or Finish to submit"

func load_existing_array(existing_array : Array):
	text_array = existing_array

func _on_Enter_pressed():
	if current_mode == EditMode.SERIES:
		if $VBoxContainer/TextEdit.text == "":
			text_array.remove(current_index)
		else:
			clean_input()
			$VBoxContainer/Label.text = "Please enter the next item (or hit Finish)"
			if !text_array.has($VBoxContainer/TextEdit.text):
				text_array.append($VBoxContainer/TextEdit.text)
				$VBoxContainer/TextEdit.text = ""
				$VBoxContainer/HBoxContainer/Previous.disabled = false
				current_index += 1
				
	if current_mode == EditMode.DESCRIPTION or current_mode == EditMode.NAME:
		clean_input()
		text_body = $VBoxContainer/TextEdit.text
		send_result()
		end_menu()
		
# warning-ignore:unused_argument
func _process(delta):
	$VBoxContainer/HBoxContainer2/Entries.text = str(text_array)

func _unhandled_key_input(event):
	if event.is_action_released("enter_key"):
		_on_Enter_pressed()
	if event.is_action_released("ui_cancel"):
		_on_Cancel_pressed()

func _on_Exit_pressed():
	# finalize results
	send_result()
	end_menu()

func _on_Cancel_pressed():
	emit_signal("canceled_menu")
	end_menu()
	
func end_menu():
	var size_tween = Tween.new()
	add_child(size_tween)
	size_tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(0,0), 0.7, Tween.TRANS_SINE, Tween.EASE_OUT)
	size_tween.start()
	yield(size_tween, "tween_completed")
	size_tween.queue_free()
	queue_free()

func _on_Previous_pressed():
	current_index -= 1
	$VBoxContainer/TextEdit.text = text_array[current_index]
	
func send_result():
	if system.length() > 0:
		emit_signal("finished_system_entry", text_array)
		print(text_array)
	else:
		if current_mode == EditMode.SERIES:
			emit_signal("finished_entry", category, text_array)
		else:
			emit_signal("finished_entry", category, text_body)

func clean_input():
	var text = $VBoxContainer/TextEdit.text.strip_edges()
	$VBoxContainer/TextEdit.text = text
