extends CanvasLayer

class_name FlashCard

var screen_size = Rect2()

onready var category_dict = {
	"title_card_position" : {
		"position" :Vector2(),
		"name" : "",
		"label" : $Control/CardTitle
		},
	"Generic Name(s):" : {
		"position" : Vector2(),
		"name" : "",
		"index" : 0,
		"label" : $Control/Generic
		},
	"Brand Name(s):" : {
		"position" : Vector2(),
		"names" : [],
		"index" : 1,
		"label" : $Control/Brand
		},
	"Indication:" : {
		"position" : Vector2(),
		"text" : "",
		"index" : 2,
		"label" : $Control/Indication
		},
	"Route:" : {
		"position" : Vector2(),
		"routes" : [],
		"index" : 3,
		"label" : $Control/Route
		},
	"Action:" : {
		"position" : Vector2(),
		"text" : "",
		"index" : 4,
		"label" : $Control/Action
		},
	"Adverse Reactions:" : {
		"position" : Vector2(),
		"systems" : {},
		"index" : 5,
		"extra_rows" : 0,
		"label" : $Control/AdverseReactions
		},
	"Blackbox Warning:" : {
		"position" : Vector2(),
		"text" : "N/A",
		"index" : 6,
		"label" : $Control/BlackBoxWarnings
		},
	"Lab Effect:" : {
		"position" : Vector2(),
		"text" : "N/A",
		"index" : 7,
		"label" : $Control/LabEffects
		}
	}
var title_spacer = 50.0

func _ready():
	update_screen_rect()
# warning-ignore:return_value_discarded
	get_tree().connect("screen_resized", self, "update_screen_rect")
	
func update_screen_rect():
	screen_size = get_viewport().get_visible_rect()
	screen_size.position += Vector2(20, 20)
	screen_size.end -= Vector2(20,20)
	setup_categories()
	
func _is_inside_screen(rect : Rect2) -> bool:
	return screen_size.encloses(rect)
	
func _add_next_label_on_row():
	pass
	
func setup_categories():
	var row_modifier = category_dict["Adverse Reactions:"]["extra_rows"]
	for k in category_dict:
		if k == "title_card_position":
			category_dict[k]["position"] = (get_viewport().size * 0.5) - category_dict[k]["label"].rect_size*0.5
			category_dict[k]["label"].set_position(category_dict[k]["position"])
			category_dict[k]["label"].text = category_dict[k]["name"]
		else:
			var modifier = category_dict[k]["index"]
			if modifier > category_dict["Adverse Reactions:"]["index"]:
				modifier += row_modifier
			category_dict[k]["position"] = Vector2(screen_size.position.x, screen_size.position.y + (title_spacer*modifier))
			category_dict[k]["label"].set_position(category_dict[k]["position"])
			category_dict[k]["label"].text = k
		
	

	
