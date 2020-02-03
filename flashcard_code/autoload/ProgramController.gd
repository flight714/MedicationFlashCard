extends Node

var flash_card_path = "res://flashcard_code/FlashCard.tscn"
var flash_card_libary = {}

var config_settings = {
	"isNightMode" : true,
	"library_folder" : "res://card_library/",
	"image_folder" : "res://image_library/"
}

func _ready():
	var saved_settings = get_json_as_dict("config.json")
	if saved_settings.size() > 0:
		for k in saved_settings.keys():
			if config_settings.has(k):
				config_settings[k] = saved_settings[k]
	print(config_settings)
	
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
	
