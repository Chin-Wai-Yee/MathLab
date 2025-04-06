class_name Draggable
extends BaseButton

signal button_clicked
signal button_dragged

var can_drag : bool = true
var dragging : bool = false

const DRAG_THRESHOLD = 2
var press_position := Vector2.ZERO

func gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		press_position = event.position
		self.dragging = false

	elif event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		if not self.dragging and event.position.distance_to(press_position) > DRAG_THRESHOLD:
			self.dragging = true
			emit_signal("button_dragged")

func _ready() -> void:
	self.pressed.connect(
		func _on_pressed():
			# Delay check to next frame to ensure drag state is accurate
			await get_tree().process_frame
			if not dragging:
				emit_signal("button_clicked")
	)

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not can_drag:
		return null

	self.visible = false
	set_drag_preview(get_preview())
	return self

func _notification(notification_type):
	match notification_type:
		NOTIFICATION_DRAG_BEGIN:
			self.dragging = true
		NOTIFICATION_DRAG_END:
			self.dragging = false
			if can_drag:
				self.visible = true

func _on_removed() -> void:
	self.visible = true
	self.can_drag = true

func _on_dropped() -> void:
	self.visible = false
	self.can_drag = false
	self.dragging = false

func get_preview():
	var preview = self.duplicate(8) as BaseButton

	var c = Control.new()
	c.add_child(preview)
	preview.visible = true
	preview.position = -0.5 * preview.custom_minimum_size

	return c
