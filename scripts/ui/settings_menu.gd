extends "res://scripts/menu.gd"

@onready var back := %Back as Button

@onready var resolution_option := %ResolutionOption as OptionButton
@onready var window_option := %WindowOption as OptionButton
@onready var master_slider := %MasterSlider as HSlider
@onready var music_slider := %MusicSlider as HSlider
@onready var player_slider := %PlayerSlider as HSlider
@onready var world_slider := %WorldSlider as HSlider
@onready var difficulty_option := %DifficultyOption as OptionButton
@onready var language_option := %LanguageOption as OptionButton


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	
	# TODO: Populate menus with available options
	resolution_option.add_item(str(Settings.resolution))
	window_option.add_item((Settings.WindowState.keys() as Array[String])[Settings.window_state])
	difficulty_option.add_item((Game.Difficulty.keys() as Array[String])[Settings.difficulty])
	language_option.add_item((Settings.Language.keys() as Array[String])[Settings.language])

	master_slider.set_value_no_signal(Settings.vol_master * 100)
	music_slider.set_value_no_signal(Settings.vol_music * 100)
	player_slider.set_value_no_signal(Settings.vol_player * 100)
	world_slider.set_value_no_signal(Settings.vol_world * 100)


func _on_visibility_changed() -> void:
	if visible: back.show()


## Used for nodes such as [OptionButton] where, for example,
## [signal selected] is not synonymous with [signal pressed].
func _on_generic_interaction() -> void:
	interact.emit()


func _on_back_pressed() -> void:
	interact.emit(State.MAIN)
	back.hide()


func _on_resolution_option_item_selected(index: int) -> void:
	interact.emit()
	Settings.resolution = Settings.get_resolutions()[index]


func _on_window_option_item_selected(index: int) -> void:
	interact.emit()
	Settings.window_state = index as Settings.WindowState


func _on_difficulty_option_item_selected(index: int) -> void:
	interact.emit()
	Settings.difficulty = index as Game.Difficulty


func _on_language_option_item_selected(index: int) -> void:
	interact.emit()
	Settings.language = index as Settings.Language


func _on_master_slider_drag_ended(value_changed: bool) -> void:
	interact.emit()
	if value_changed:
		Settings.vol_master = master_slider.get_value() / 100


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	interact.emit()
	if value_changed:
		Settings.vol_music = music_slider.get_value() / 100


func _on_player_slider_drag_ended(value_changed: bool) -> void:
	interact.emit()
	if value_changed:
		Settings.vol_player = player_slider.get_value() / 100


func _on_world_slider_drag_ended(value_changed: bool) -> void:
	interact.emit()
	if value_changed:
		Settings.vol_world = world_slider.get_value() / 100
