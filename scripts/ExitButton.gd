extends BaseButton

func _ready() -> void:
	self.pressed.connect(_on_pressed)

func _on_pressed():
	get_tree().quit()
