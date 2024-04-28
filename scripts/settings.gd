extends Control

enum Language {
	ENGLISH,
}

enum WindowState {
	WINDOWED,
	MAXIMISED,
	BORDERLESS,
	FULLSCREEN,
}

const _MIN_WINDOW_SIZE := Vector2i(1280, 720)

# TODO: Save and load as resource
# Display
var resolution: Vector2i:
	set(value):
		resolution = _set_resolution(value)
var window_state: WindowState:
	set(value):
		window_state = _set_window_state(value)

# Audio
var vol_master: float = 1.0:
	set(value):
		vol_master = _set_vol_master(value)
var vol_music: float = 1.0:
	set(value):
		vol_music = _set_vol_music(value)
var vol_player: float = 1.0:
	set(value):
		vol_player = _set_vol_player(value)
var vol_world: float = 1.0:
	set(value):
		vol_world = _set_vol_world(value)

# Game
var difficulty: Game.Difficulty = Game.Difficulty.NORMAL:
	set(value):
		difficulty = _set_difficulty(value)
var language: Language = Language.ENGLISH:
	set(value):
		language = _set_language(value)


func _ready() -> void:
	get_window().set_min_size(_MIN_WINDOW_SIZE)
	resolution = get_window().get_size_with_decorations()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("toggle_fullscreen"): toggle_fullscreen()


func toggle_fullscreen() -> void:
	if window_state == WindowState.FULLSCREEN:
		# BUG: Often will result in Window.MODE_FULLSCREEN instead of Window.MODE_WINDOWED
		get_window().set_mode(Window.MODE_WINDOWED)
		get_window().reset_size()
		window_state = WindowState.WINDOWED
	else:
		get_window().set_mode(Window.MODE_EXCLUSIVE_FULLSCREEN)
		window_state = WindowState.FULLSCREEN


func get_resolutions() -> Array[Vector2i]:
	# TODO: Return array of aspect ratio aware resolutions
	return [Vector2i(_MIN_WINDOW_SIZE), Vector2i(1920, 1080)]


# TODO: Implement settings
func _set_resolution(value: Vector2i) -> Vector2i:
	return value


func _set_window_state(value: WindowState) -> WindowState:
	return value


func _set_vol_master(value: float) -> float:
	return value


func _set_vol_music(value: float) -> float:
	return value


func _set_vol_player(value: float) -> float:
	return value


func _set_vol_world(value: float) -> float:
	return value


func _set_difficulty(value: Game.Difficulty) -> Game.Difficulty:
	return value


func _set_language(value: Language) -> Language:
	return value
