class_name Draggable
extends Control

var prefab : PackedScene

## Singular tween ref so we don't start tons of conflicting tweens
var tween : Tween

## The underlying data that this Draggable is rendering
var data : Variant

func init(data: Variant):
	self.data = data

func _get_drag_data(pos: Vector2):
	self.visible = false
	set_drag_preview(get_preview())
	return self

func _notification(notification_type):
	match notification_type:
		NOTIFICATION_DRAG_END:
			self.visible = true

func get_preview():
	var preview = self.duplicate()
	preview.visible = true
	preview.position = self.size * -0.5
	return preview
