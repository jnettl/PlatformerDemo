extends Control

signal interact(target: State)
signal exit(soft: bool)
signal new_save(slot: int)
signal load_save(slot: int)

enum State {
	NONE,
	CURRENT,
	BACKGROUND,
	LOADING,
	MAIN,
	PAUSE,
	SETTINGS,
}

const MainMenu = preload("res://scripts/ui/main_menu.gd")
const PauseMenu = preload("res://scripts/ui/pause_menu.gd")
const SettingsMenu = preload("res://scripts/ui/settings_menu.gd")
const LoadingMenu = preload("res://scripts/ui/loading_menu.gd")

var main_menu: MainMenu
var pause_menu: PauseMenu
var settings_menu: SettingsMenu
var loading_menu: LoadingMenu
var background: ColorRect


func _ready() -> void:
	# NOTE: Signals in subclasses still need to be connected in the super class.
	# Ideally, the emitted signal would propagate through to the super class.
	# TODO: Refactor signal propagation to avoid this weird inheritance tree.
	# These node references should really be @onreadys, and Menu a CanvasLayer.
	main_menu = $MainMenu as MainMenu
	pause_menu = $PauseMenu as PauseMenu
	settings_menu = $SettingsMenu as SettingsMenu
	loading_menu = $LoadingMenu as LoadingMenu
	background = $Background as ColorRect
	
	main_menu.interact.connect(_on_interaction)
	main_menu.exit.connect(_on_exit_game)
	pause_menu.interact.connect(_on_interaction)
	pause_menu.exit.connect(_on_exit_game)
	settings_menu.interact.connect(_on_interaction)
	
	main_menu.new_save.connect(func(slot: int) -> void:
			new_save.emit(slot))
	main_menu.load_save.connect(func(slot: int) -> void:
			load_save.emit(slot))


func change_current_menu(target: State) -> void:
	if target == State.CURRENT:
		return
	get_tree().call_group(&"menu_scene", &"hide")
	match target:
		State.MAIN: main_menu.show()
		State.PAUSE: pause_menu.show()
		State.SETTINGS: settings_menu.show()
		State.LOADING: loading_menu.show()
		State.BACKGROUND: background.show()
		State.NONE: pass
		_: assert(false, "unhandled menu target specified.")


func _on_interaction(target: State = State.CURRENT) -> void:
	Audio.play_sound(Audio.Sound.MENU_CLICK)
	change_current_menu(target)


func _on_exit_game(soft: bool) -> void:
	await Audio.finished
	exit.emit(soft)
	if soft:
		change_current_menu(State.MAIN)
