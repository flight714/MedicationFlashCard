extends ItemList

export (String) var category
var current_item = 0

signal item_clicked(category, item_text)
signal category_clicked(category)

func _ready():
	pass

func find_item_index(search_text : String):
	for i in get_item_count():
		if get_item_text(i) == search_text:
			return i

func add_line_item(new_text : String):
	var col_string = ProgramController.get_body_system_by_effect(new_text)
	var col = ProgramController.check_body_system_color(col_string)
	if new_text.split(" ").size() > 0:
		var text_array = new_text.split(" ")
		for word in text_array:
			add_item(word)
			set_item_custom_fg_color(find_item_index(word), col)
	else:
		add_item(new_text)
		set_item_custom_fg_color(find_item_index(new_text), col)

func add_line_at_point(new_text : String, index : int):
	add_line_item(new_text)
	move_item(find_item_index(new_text), index)
	
# warning-ignore:shadowed_variable
func add_line_in_category(category : String, new_item : String):
	var start_point = find_item_index(category) + 1
	if start_point > get_item_count() - 1:
		add_line_item(new_item)
		set_item_custom_fg_color(find_item_index(new_item), get_item_custom_fg_color(find_item_index(category)))
	else:
		add_line_at_point(new_item, start_point)
		set_item_custom_fg_color(find_item_index(new_item), get_item_custom_fg_color(find_item_index(category)))

func add_array(array):
	for i in array:
		add_line_item(i)
		
func add_dict(dict : Dictionary):
	if dict.size() > 0:
		for k in dict:
			add_line_item(k)
			for s in dict[k]:
				add_line_in_category(k, s)
		
func update_colors():
	for i in get_item_count():
		var text = get_item_text(i)
		set_item_custom_fg_color(i,ProgramController.check_body_system_color(ProgramController.get_body_system_by_effect(text)))
		
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
