extends TextureButton

signal _new_item_requested(category)
var category : String = "null"

func _ready():
	pass

func _on_AddButton_pressed():
	emit_signal("_new_item_requested", category)
