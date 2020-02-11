extends ItemList

export (String) var category

signal item_clicked(category, item_text)
signal category_clicked(category)

func _ready():
	pass

func find_item_index(search_text : String):
	for i in get_item_count():
		if get_item_text(i) == search_text:
			return i

func add_line_item(new_text : String, color="null"):
	if new_text.split(" ").size() > 0:
		var text_array = new_text.split(" ")
		for word in text_array:
			add_item(word)
			set_item_custom_fg_color(get_item_count()-1, ProgramController.check_body_system_color(color))
	else:
		add_item(new_text)

func add_line_at_point(new_text : String, index : int):
	add_line_item(new_text)
	move_item(find_item_index(new_text), index)

func add_array(array):
	for i in array:
		add_line_item(i)
		
func add_dict(dict : Dictionary):
	if dict.size() > 0:
		for k in dict:
			if dict[k].size() > 0:
				add_line_item(k, k)
				for s in dict[k]:
					add_line_item(s, k)
		
func remove_item_by_text(text : String):
	if find_item_index(text):
		remove_item(find_item_index(text))
		
func reset_to_first():
	var title = category
	clear()
	add_item(title)

func _on_CategoryRow_item_activated(index):
	if index == 0:
		emit_signal("category_clicked", category)
	else:
		emit_signal("item_clicked", category, get_item_text(index))
