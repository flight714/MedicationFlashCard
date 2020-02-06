extends ItemList

func _ready():
	pass
	
func _unhandled_input(event):
	add_item("Hello world")
