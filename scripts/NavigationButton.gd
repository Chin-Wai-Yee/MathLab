extends BaseButton

@export_file var target_scene: String = ""
@export var scene_params := {}

func _ready():
	# Connect the button press signal to the function
	self.pressed.connect(_on_pressed)

# Function that runs when the button is pressed
func _on_pressed():
	if target_scene:
		SceneData.params = scene_params
		get_tree().change_scene_to_file(target_scene)
	else:
		print("No target scene assigned!")
