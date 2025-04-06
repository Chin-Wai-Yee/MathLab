class_name DropTarget
extends Button

var dragged_item : Draggable = null

func _ready() -> void:
	self.mouse_entered.connect(_on_drag_entered)
	self.mouse_exited.connect(_on_drag_exited)
	self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	clear_children()
	_on_drag_exited()
	self.disabled = true

func _can_drop_data(_position, data):
	if dragged_item:
		var child = self.get_child(0)
		if child == data:
			return false

	return data != null and data is Draggable

func _drop_data(_position, data):
	clear_children()

	var new_child = data.duplicate() as Draggable
	new_child.can_drag = false
	new_child.visible = true
	self.add_child(new_child)
	dragged_item = data
	dragged_item._on_dropped()
	
	new_child.mouse_filter = Control.MOUSE_FILTER_PASS
	self.disabled = false

func clear_children() -> void:
	var children = self.get_children()
	if children or dragged_item:
		dragged_item._on_removed()
		dragged_item = null
		for child in children:
			child.free()

func _on_drag_entered():
	self.modulate = Color(0.5, 1, 0.5)

func _on_drag_exited():
	self.modulate = Color(1, 1, 1)
