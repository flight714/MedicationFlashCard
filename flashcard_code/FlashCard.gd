extends CanvasLayer

class_name FlashCard

var title_alpha = 0
var categories_alpha = 1

var dynamic_label = preload("res://flashcard_code/DynamicLabel.tscn")
var system_menu = preload("res://flashcard_code/BodySystemSelector.tscn")
var text_menu = preload("res://flashcard_code/TextEditMenu.tscn")

onready var category_dict = {
	"title_card_position" : {
		"name" : "New Medication",
		"label" : $CardTitle,
		},
	"Generic Name(s):" : {
		"name" : "",
		"label" : $Control/VBoxContainer/GenericNames
		},
	"Brand Name(s):" : {
		"names" : [],
		"label" : $Control/VBoxContainer/BrandNames,
		},
	"Indication:" : {
		"text" : "",
		"label" : $Control/VBoxContainer/Indication,
		},
	"Route:" : {
		"routes" : [],
		"label" : $Control/VBoxContainer/Route,
		},
	"Action:" : {
		"text" : "",
		"label" : $Control/VBoxContainer/Action,
		},
	"Adverse Reactions:" : {
		"systems" : {
		},
		"label" : $Control/VBoxContainer/AdverseEffects,
		},
	"Blackbox Warning:" : {
		"text" : "N/A",
		"label" : $Control/VBoxContainer/BlackboxWarning,
		},
	"Lab Effect:" : {
		"text" : "N/A",
		"label" : $Control/VBoxContainer/LabEffect,
		}
	}

func _ready():
	$Background.color = ProgramController.get_background_color()
	for i in $Control.get_child_count():
		$Control.get_children()[i].modulate = ProgramController.check_body_system_color("null")
	update_screen_rect()
# warning-ignore:return_value_discarded
	get_tree().connect("screen_resized", self, "update_screen_rect")
	
	for box in $Control/VBoxContainer.get_children():
		box.connect("category_clicked", self, "add_new_item_to_category")
		box.connect("item_clicked", self, "change_item_in_category")
	

	
# warning-ignore:unused_argument
func _process(delta):
	category_dict["title_card_position"]["label"].modulate.a = title_alpha
	if title_alpha == 1:
		category_dict["title_card_position"]["label"].mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		category_dict["title_card_position"]["label"].mouse_filter = Control.MOUSE_FILTER_IGNORE
	for k in category_dict:
		if k != "title_card_position":
			category_dict[k]["label"].modulate.a = categories_alpha
			if categories_alpha == 1:
				category_dict[k]["label"].mouse_filter = Control.MOUSE_FILTER_STOP
			else:
				category_dict[k]["label"].mouse_filter = Control.MOUSE_FILTER_IGNORE
			
# warning-ignore:unused_argument
func _unhandled_input(event):
	#testing
	if event.is_action_pressed("ui_accept"):
		pass

func update_screen_rect():
	update_categories()
	
		
# warning-ignore:unused_argument
func _add_new_item(category : String):
	pass

func update_categories():
	$CardTitle.text = category_dict["title_card_position"]["name"]
	for k in category_dict:
		if k != "title_card_position":
			category_dict[k]["label"].category = k
			category_dict[k]["label"].reset_to_first()
	for k in category_dict:
		if category_dict[k].has("text"):
			category_dict[k]["label"].reset_to_first()
			category_dict[k]["label"].add_line_item(category_dict[k]["text"])
			
		if category_dict[k].has("routes"):
			category_dict[k]["label"].reset_to_first()
			category_dict[k]["label"].add_array(category_dict[k]["routes"])
				
		if category_dict[k].has("systems"):
			category_dict[k]["label"].reset_to_first()
			var systems = category_dict[k]["systems"]
			category_dict[k]["label"].add_dict(systems)
			
		if category_dict[k].has("names"):
			category_dict[k]["label"].reset_to_first()
			category_dict[k]["label"].add_array(category_dict[k]["names"])
			
		if category_dict[k].has("name") and k != "title_card_position":
			category_dict[k]["label"].reset_to_first()
			category_dict[k]["label"].add_line_item(category_dict[k]["name"])

func add_new_item_to_category(category : String):
	if category == "Adverse Reactions:":
		var new_menu = system_menu.instance()
		add_child(new_menu)
		new_menu.connect("selected_system", self, "select_adverse_effect")
	else:
		add_text_edit_menu(category)
		
func select_adverse_effect(category : String):
	#testing
	pass

func add_new_adverse_effect(category : String, effect : String):
	if !category_dict["Adverse Reactions:"]["systems"].has(category):
		category_dict["Adverse Reactions:"]["systems"][category] = [effect]
	else:
		category_dict["Adverse Reactions:"]["systems"][category].append(effect)
	update_categories()
	
func change_item_in_category(category: String, item_text : String):
	print(category + " " + item_text)
	
func add_text_edit_menu(category : String):
	var new_text_menu = text_menu.instance()
	new_text_menu.category = category
	if category_dict[category].has("text"):
		new_text_menu.current_mode = TextEditMenu.EditMode.DESCRIPTION
		new_text_menu.text_body = category_dict[category]["text"]
	if category_dict[category].has("name"):
		new_text_menu.current_mode = TextEditMenu.EditMode.NAME
		new_text_menu.text_body = category_dict[category]["name"]
	if category_dict[category].has("names") or category_dict[category].has("routes"):
		new_text_menu.current_mode = TextEditMenu.EditMode.SERIES
	add_child(new_text_menu)
	new_text_menu.connect("finished_entry", self, "recieve_text_menu_result")

func recieve_text_menu_result(category : String, new_item):
	if category == "title_card_position" or category == "Generic Name(s):":
		category_dict[category]["name"] = new_item
	if category == "Brand Name(s):":
		if new_item.size() > 0:
			for i in new_item:
				category_dict[category]["names"].append(i)
	if category_dict[category].has("text"):
		category_dict[category]["text"] = new_item
	if category_dict[category].has("routes"):
		if new_item.size() > 0:
			for i in new_item:
				category_dict[category]["routes"].append(i)
	
	update_categories()

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
