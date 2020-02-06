extends CanvasLayer

class_name FlashCard

var screen_size = Rect2()

var title_alpha = 0
var categories_alpha = 1

var dynamic_label = preload("res://flashcard_code/DynamicLabel.tscn")
var add_button = preload("res://flashcard_code/AddButton.tscn")

var label_position_dict = {}

onready var category_dict = {
	"title_card_position" : {
		"position" :Vector2(),
		"name" : "New Medication",
		"extra_rows" : 0,
		"index" : 0,
		"label" : $Control/CardTitle,
		"add_button" : TextureButton
		},
	"Generic Name(s):" : {
		"position" : Vector2(),
		"name" : "",
		"index" : 0,
		"extra_rows" : 0,
		"label" : $Control/Generic
		},
	"Brand Name(s):" : {
		"position" : Vector2(),
		"names" : [],
		"index" : 1,
		"extra_rows" : 0,
		"label" : $Control/Brand,
		"add_button" : TextureButton
		},
	"Indication:" : {
		"position" : Vector2(),
		"text" : "",
		"index" : 2,
		"extra_rows" : 0,
		"label" : $Control/Indication,
		"add_button" : TextureButton
		},
	"Route:" : {
		"position" : Vector2(),
		"routes" : [],
		"index" : 3,
		"extra_rows" : 0,
		"label" : $Control/Route,
		"add_button" : TextureButton
		},
	"Action:" : {
		"position" : Vector2(),
		"text" : "",
		"index" : 4,
		"extra_rows" : 0,
		"label" : $Control/Action,
		"add_button" : TextureButton
		},
	"Adverse Reactions:" : {
		"position" : Vector2(),
		"systems" : {},
		"index" : 5,
		"extra_rows" : 0,
		"label" : $Control/AdverseReactions,
		"add_button" : TextureButton
		},
	"Blackbox Warning:" : {
		"position" : Vector2(),
		"text" : "N/A",
		"index" : 6,
		"extra_rows" : 0,
		"label" : $Control/BlackBoxWarnings,
		"add_button" : TextureButton
		},
	"Lab Effect:" : {
		"position" : Vector2(),
		"text" : "N/A",
		"index" : 7,
		"extra_rows" : 0,
		"label" : $Control/LabEffects,
		"add_button" : TextureButton
		}
	}
var title_spacer = 50.0

func _ready():
	$Background.color = ProgramController.get_background_color()
	for i in $Control.get_child_count():
		$Control.get_children()[i].modulate = ProgramController.check_body_system_color("null")
	update_screen_rect()
# warning-ignore:return_value_discarded
	get_tree().connect("screen_resized", self, "update_screen_rect")
	setup_buttons()
	
# warning-ignore:unused_argument
func _process(delta):
	category_dict["title_card_position"]["label"].modulate.a = title_alpha
	for k in category_dict:
		if k != "title_card_position":
			category_dict[k]["label"].modulate.a = categories_alpha
			
# warning-ignore:unused_argument
func _unhandled_input(event):
	#testing
	if event.is_action_pressed("ui_accept"):
		#pass
		_add_field_text_to_category("Adverse Reactions:", "This should be approached with caution")

func update_screen_rect():
	screen_size = get_viewport().get_visible_rect()
	screen_size.position += Vector2(20, 20)
	screen_size.end -= Vector2(20,20)
	setup_categories()
	
func _is_inside_screen(rect : Rect2) -> bool:
	return screen_size.encloses(rect)

func _add_label_to_row(category : String, label_text : String, assigned_system_color="null"):
	var new_label = dynamic_label.instance()
	new_label.text = label_text
	new_label.modulate = ProgramController.check_body_system_color(assigned_system_color)
	new_label.modulate.a = categories_alpha
	add_child(new_label)
	var new_position : Vector2
	if !label_position_dict.has(category):
		new_position = Vector2(category_dict[category]["label"].rect_position.x, category_dict[category]["label"].rect_position.y + 8)
		new_position.x += category_dict[category]["label"].rect_size.x*1.05
		label_position_dict[category] = [new_position]
	new_label.rect_position = label_position_dict[category].back()
	if !_is_inside_screen(new_label.get_rect()):
		if category_dict[category].has("extra_rows"):
			if category_dict[category]["extra_rows"] == 0:
				category_dict[category]["extra_rows"] += 1
			else:
				category_dict[category]["extra_rows"] += 0.5
			setup_categories()
			new_label.rect_position = Vector2(category_dict[category]["label"].rect_position.x, (category_dict[category]["index"]+category_dict[category]["extra_rows"])*title_spacer)
	var next_position = new_label.rect_position + Vector2(new_label.rect_size.x+5, 0)
	category_dict[category]["add_button"].rect_position = next_position
	label_position_dict[category].append(next_position)
	update_buttons()

# warning-ignore:unused_argument
func _add_field_text_to_category(category : String, new_text : String):
# warning-ignore:unused_variable
	var text_array = new_text.split(" ")
	var system_color = ProgramController.get_body_system_by_effect(new_text)
	for word in text_array:
		_add_label_to_row(category, word, system_color)
		
# warning-ignore:unused_argument
func _add_new_item(category : String):
	pass
		
func update_categories():
	for k in category_dict:
		if category_dict[k].has("text"):
			pass
		if category_dict[k].has("route"):
			pass
		if category_dict[k].has("systems"):
			pass
	
func setup_categories():
	for k in category_dict:
		if k == "title_card_position":
			category_dict[k]["position"] = (get_viewport().size * 0.5) - category_dict[k]["label"].rect_size*1.5
			category_dict[k]["label"].set_position(category_dict[k]["position"])
			category_dict[k]["label"].text = category_dict[k]["name"]
		else:
			var modifier = category_dict[k]["index"]
			var previous_extra_rows = 0
			for j in category_dict:
				if category_dict[j]["index"] < category_dict[k]["index"]:
					previous_extra_rows += category_dict[j]["extra_rows"]
			modifier += previous_extra_rows
			category_dict[k]["position"] = Vector2(screen_size.position.x, screen_size.position.y + (title_spacer*modifier))
			category_dict[k]["label"].set_position(category_dict[k]["position"])
			category_dict[k]["label"].text = k

		#"add_button" : TextureButton
func setup_buttons():
	for k in category_dict:
		if k != "title_card_position":
			var new_add_button = add_button.instance()
			add_child(new_add_button)
			new_add_button.category = k
			new_add_button.connect("_new_item_requested", self, "_add_new_item")
			new_add_button.rect_position = category_dict[k]["position"] + Vector2(category_dict[k]["label"].rect_size.x,9)
			category_dict[k]["add_button"] = new_add_button

func update_buttons():
	for k in category_dict:
		if category_dict[k].has("add_button"):
			var button : TextureButton
			button = category_dict[k]["add_button"]
			if label_position_dict.has(k):
				button.rect_position = label_position_dict[k].back()
			else:
				button.rect_position = category_dict[k]["position"]
			
# EFFECTS
func flip_card_to_title():
	var flip_tween = Tween.new()
	add_child(flip_tween)
	flip_tween.interpolate_property(self, "title_alpha", title_alpha, 1.0, 0.7, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	flip_tween.interpolate_property(self, "categories_alpha", categories_alpha, 0.0, 0.7, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	flip_tween.start()
	yield(flip_tween, "tween_completed")
	flip_tween.queue_free()
	
func flip_card_to_categories():
	var flip_tween = Tween.new()
	add_child(flip_tween)
	flip_tween.interpolate_property(self, "title_alpha", title_alpha, 0.0, 0.7, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	flip_tween.interpolate_property(self, "categories_alpha", categories_alpha, 1.0, 0.7, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	flip_tween.start()
	yield(flip_tween, "tween_completed")
	flip_tween.queue_free()
