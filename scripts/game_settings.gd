extends Node

# Volume ranges typically go from 0.0 (mute) to 1.0 (full volume)
var sfx_volume: float = 1.0 : set = set_sfx_volume, get = get_sfx_volume
var bgm_volume: float = 1.0 : set = set_bgm_volume, get = get_bgm_volume

# Signals for UI or other systems to connect to
signal sfx_volume_changed(new_volume)
signal bgm_volume_changed(new_volume)

# SFX Volume Controls
func set_sfx_volume(value: float) -> void:
	sfx_volume = clamp(value, 0.0, 1.0)
	emit_signal("sfx_volume_changed", sfx_volume)
	_apply_sfx_volume()
	save_settings()

func get_sfx_volume() -> float:
	return sfx_volume

# BGM Volume Controls
func set_bgm_volume(value: float) -> void:
	bgm_volume = clamp(value, 0.0, 1.0)
	emit_signal("bgm_volume_changed", bgm_volume)
	_apply_bgm_volume()
	save_settings()

func get_bgm_volume() -> float:
	return bgm_volume

# Apply volume to audio buses
func _apply_sfx_volume():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(sfx_volume))

func _apply_bgm_volume():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), linear2db(bgm_volume))

# Utility to convert linear volume to decibels
func linear2db(value: float) -> float:
	if value <= 0.0:
		return -80.0 # Godot considers -80 dB as silence
	return 20.0 * log(value) / log(10)

var total_question: int = 10 : set = set_total_question, get = get_total_question
var number_min: int = 1 : set = set_number_min, get = get_number_min
var number_max: int = 10 : set = set_number_max, get = get_number_max

func set_total_question(value: int) -> void:
	total_question = max(1, value)
	save_settings()

func get_total_question() -> int:
	return total_question

func set_number_min(value: int) -> void:
	number_min = value
	save_settings()

func get_number_min() -> int:
	return number_min

func set_number_max(value: int) -> void:
	number_max = value
	save_settings()

func get_number_max() -> int:
	return number_max

# Settings to file
const SAVE_PATH := "user://settings.cfg"

func save_settings():
	var config = ConfigFile.new()
	
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.set_value("audio", "bgm_volume", bgm_volume)

	config.set_value("game", "total_question", total_question)
	config.set_value("game", "number_min", number_min)
	config.set_value("game", "number_max", number_max)

	var err = config.save(SAVE_PATH)
	if err != OK:
		print("Failed to save settings!")

func load_settings():
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	if err != OK:
		print("No previous settings found. Using defaults.")
		return
	
	sfx_volume = config.get_value("audio", "sfx_volume", 1.0)
	bgm_volume = config.get_value("audio", "bgm_volume", 1.0)

	total_question = config.get_value("game", "total_question", 10)
	number_min = config.get_value("game", "number_min", 1)
	number_max = config.get_value("game", "number_max", 10)

	# Reapply volume
	_apply_sfx_volume()
	_apply_bgm_volume()

func _ready() -> void:
	load_settings()
