extends Control

var labels = []
var points = []
var rotations = []
var center : Vector2
var open_distance = 100

var is_menu_open = false

func _ready():
	center = get_viewport().size*0.5
	labels = get_children()
	for i in labels.size():
		var new_node = Node2D.new()
		add_child(new_node)
		points.append(new_node)
		points[i].position = center
		labels[i].rect_position = points[i].position - labels[i].rect_size*0.5
		
	var rotation_rate = deg2rad(360/labels.size())
	for i in points.size():
		rotations.append(rotation_rate*i)
		
	open_menu()
		
		
# warning-ignore:unused_argument
func _process(delta):
	for i in labels.size():
		labels[i].rect_position = points[i].position - labels[i].rect_size*0.5
		var distance_scale = (points[i].position.distance_to(center)/open_distance)
		labels[i].rect_scale = Vector2(1,1) * distance_scale

		
func open_menu():
	var open_tween = Tween.new()
	add_child(open_tween)
	for i in points.size():
		var open_point = center + (Vector2(1,0)*open_distance).rotated(rotations[i])
		open_tween.interpolate_property(points[i], "position", points[i].position, open_point, 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	open_tween.start()
	yield(open_tween, "tween_completed")
	is_menu_open = true
	open_tween.queue_free()
	
func close_menu():
	var close_tween = Tween.new()
	add_child(close_tween)
	for i in points.size():
# warning-ignore:unused_variable
		close_tween.interpolate_property(points[i], "position", points[i].position, center, 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	close_tween.start()
	yield(close_tween, "tween_completed")
	is_menu_open = false
	close_tween.queue_free()
	

	

	
