class_name DropTarget
extends Control

func _ready() -> void:
	self.mouse_entered.connect(_on_drag_entered)
	self.mouse_exited.connect(_on_drag_exited)

func _can_drop_data(position, data):
	return true

func _drop_data(position, data):
	for child in self.get_children():
		child.free()

	var new_child = data.duplicate()
	self.add_child(new_child)

func _on_drag_entered():
	self.modulate = Color(0.5, 1, 0.5)

func _on_drag_exited():
	self.modulate = Color(1, 1, 1)
