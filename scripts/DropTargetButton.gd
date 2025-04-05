extends DropTarget

func _ready() -> void:
	super._ready()
	self.pressed.connect(on_pressed)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return super._can_drop_data(at_position, data)

func _drop_data(at_position: Vector2, data: Variant) -> void:
	super._drop_data(at_position, data)
	var child = self.get_children()[0] as BaseButton
	child.mouse_filter = Control.MOUSE_FILTER_PASS
	self.disabled = false

func on_pressed() -> void:
	for child in self.get_children():
		child.free()
	self.disabled = true
