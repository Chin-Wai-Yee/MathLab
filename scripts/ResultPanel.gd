class_name ResultPanel
extends PanelContainer

enum SOUND_EFFECT
{
	NO,
	SUCCESS,
	ERROR
}

signal text_changed(new_text)
signal continue_pressed()

@export_category("Content")
@export var text: String:
	set(value):
		if text != value:
			text = value
			emit_signal("text_changed", value)
@export var sound_effect : SOUND_EFFECT = SOUND_EFFECT.NO
@export var success_icon : Texture2D
@export var error_icon : Texture2D

@export_category("Animation")
@export var result_panel_lift_time : float = .5

@export_category("Behavior")
@export var continue_on_countdown_end : float = 0

var countdown : ProgressBar
var icon : TextureRect
var already_pressed : bool = false

func _ready() -> void:
	self.countdown = $MarginContainer/VBoxContainer/Countdown
	self.icon = $MarginContainer/VBoxContainer/HBoxContainer/Icon
	if continue_on_countdown_end <= 0:
		self.countdown.visible = false
	else:
		self.countdown.visible = true

# Propagate signal
func _on_continue_button_pressed() -> void:
	if already_pressed:
		return
	already_pressed = true
	emit_signal("continue_pressed")

func show_success(label_text : String = "Correct, good job!") -> void:
	self.text = label_text
	self.sound_effect = SOUND_EFFECT.SUCCESS
	self.icon.texture = self.success_icon
	self.icon.visible = true
	await animate_up()

func show_error(label_text : String = "You got it wrong!") -> void:
	self.text = label_text
	self.sound_effect = SOUND_EFFECT.ERROR
	self.icon.texture = self.error_icon
	self.icon.visible = true
	await animate_up()

# Animation
func animate_up() -> void:
	var tween = self.create_tween()
	var move_length = self.size.y
	already_pressed = false

	# Animate up
	tween\
		.tween_property(self, "position:y", -move_length, result_panel_lift_time)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BACK)\
		.as_relative()\
		.from_current()
	
	if sound_effect == SOUND_EFFECT.SUCCESS:
		if $Success.is_inside_tree():
			$Success.play()
	elif sound_effect == SOUND_EFFECT.ERROR:
		if $Error.is_inside_tree():
			$Error.play()
		$Error.play()
	
	await tween.finished  # Wait for animation to complete

	if continue_on_countdown_end > 0:
		await countdown.start_countdown_await(continue_on_countdown_end)
		if not already_pressed:
			emit_signal("continue_pressed")

func animate_down() -> void:
	var tween = self.create_tween()
	var move_length = self.size.y
	# Animate down
	tween\
		.tween_property(self, "position:y", move_length, result_panel_lift_time)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_BACK)\
		.as_relative()\
		.from_current()
	await tween.finished

	if continue_on_countdown_end >= 0:
		if countdown.tween and countdown.tween.is_running:
			countdown.tween.kill()
			countdown.value = 100
