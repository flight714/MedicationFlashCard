extends Node

var flash_card_path = "res://flashcard_code/FlashCard.tscn"
var flash_card_libary = {}

var config_settings = {
	"isNightMode" : true,
	"library_folder" : "user://card_library/",
	"image_folder" : "user://image_library/"
}

var body_system_dict = {
	"CNS" : {
		"color" : "gray",
		"known_effects" : [],
		},
	"EENT" : {
		"color" : "coral",
		"known_effects" : [],
		},
	"ENDO" : {
		"color" : "darkviolet",
		"known_effects" : [],
		},
	"GI" : {
		"color" : "gold",
		"known_effects" : [],
		},
	"GU" : {
		"color" : "chartreuse",
		"known_effects" : [],
		},
	"HEME" : {
		"color" : "indianred",
		"known_effects" : [],
		},
	"MS" : {
		"color" : "lightsteelblue",
		"known_effects" : [],
		},
	"RESP" : {
		"color" : "lightblue",
		"known_effects" : [],
		},
	"SKIN" : {
		"color" : "lightsalmon",
		"known_effects" : [],
		},
	"Other" : {
		"color" : "rosybrown",
		"known_effects" : [],
		},
	"CV" : {
		"color" : "crimson",
		"known_effects" : []
		},
}

func _ready():
	var saved_settings = {}
	var user_dir = dir_contents("user://")
	if user_dir.size() > 0 and user_dir.has("user://config.json"):
		saved_settings = get_json_as_dict("user://config.json")
	else:
		save_dict_as_json(config_settings, "config.json", "user://")
	if saved_settings.size() > 0:
		for k in saved_settings.keys():
			if config_settings.has(k):
				config_settings[k] = saved_settings[k]
				
	var utility_dir = Directory.new()
	utility_dir.open("user://")
	if !utility_dir.dir_exists(config_settings["image_folder"]):
		utility_dir.make_dir(config_settings["image_folder"])
	utility_dir.open("user://")
	if !utility_dir.dir_exists(config_settings["library_folder"]):
		utility_dir.make_dir(config_settings["library_folder"])
		
	var user_library = dir_contents(config_settings["library_folder"])
	if !user_library.has("user_library"):
		save_dict_as_json(flash_card_libary, "user_library", config_settings["library_folder"])
	else:
		var loaded_cards = get_json_as_dict(config_settings["library_folder"]+"user_library")
		if loaded_cards.size() > 0:
			for k in loaded_cards:
				flash_card_libary[k] = loaded_cards[k]
				
	if utility_dir.file_exists("user://body_system_dict.json") and get_json_as_dict("user://body_system_dict.json").size() > 0:
		var loaded_body_system_dict = get_json_as_dict("user://body_system_dict.json")
		body_system_dict = loaded_body_system_dict
	else:
		save_dict_as_json(body_system_dict, "body_system_dict", "user://")
		

	
func load_all_cards_into_memory():
	pass

func load_flashcard_dict(card_name : String) -> Dictionary:
	if flash_card_libary.has(card_name):
		return flash_card_libary[card_name]
	else:
		return {}
		
func get_json_as_dict(file_path : String) -> Dictionary:
	var file = File.new()
	file.open(file_path, file.READ)
	var json = file.get_as_text()
	var json_result = JSON.parse(json).result
	file.close()
	return json_result
	
func save_dict_as_json(dict : Dictionary, file_name : String, directory_path : String):
	var dir = Directory.new()
	if dir.open(directory_path) == OK:
		var file = File.new()
		file.open(directory_path + file_name + ".json", File.WRITE)
		file.store_string(to_json(dict))
		file.close()
	
func dir_contents(path : String, filetype=null):
	var files = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				if filetype == null or file_name.ends_with(filetype):
					files.append(path + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return files
	
func add_body_system_effect(system : String, effect : String):
	if body_system_dict.has(system):
		body_system_dict[system].append(effect)
	save_dict_as_json(body_system_dict, "body_system_dict", "user://")
	
func check_body_system_color(system : String):
	if body_system_dict.has(system):
		return ColorN(body_system_dict[system]["color"])
	else:
		if is_night_mode():
			return ColorN("white")
		else:
			return ColorN("black")
			
func get_body_system_by_effect(effect : String) -> String:
	var body_system = "null"
	for k in body_system_dict:
		if effect == k:
			body_system = k
		elif body_system_dict[k]["known_effects"].has(effect):
			body_system = k
	return body_system
		
func is_night_mode() -> bool:
	return config_settings["isNightMode"] == true

func get_background_color() -> Color:
	if is_night_mode():
		return ColorN("black")
	else:
		return Color(1,1,1)
		
func switch_night_mode():
	config_settings["isNightMode"] = !config_settings["isNightMode"]
