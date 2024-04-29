extends "res://scripts/menu.gd"

const SAVE_SLOT = preload("res://scenes/ui/component/save_slot.tscn")

const SaveSlot = preload("res://scenes/ui/component/save_slot.gd")

var _overwrite_save_on_load: bool = false

@onready var load_game := %LoadGame as Button
@onready var main := %Main as VBoxContainer
@onready var save_slots := %SaveSlots as HBoxContainer
@onready var back := %Back as Button


func _ready() -> void:
	var saves: Array[SaveState] = Game.get_save_list()
	load_game.set_disabled(false if len(saves) > 0 else true)
	populate_save_slots(saves)


func populate_save_slots(saves: Array[SaveState]) -> void:
	var save_state: SaveState
	var save_index: int = 0
	for i in range(Game.MAX_SAVES):
		var save_slot := SAVE_SLOT.instantiate() as SaveSlot
		save_slots.add_child(save_slot)
		
		if len(saves) > save_index and saves[save_index].slot == i + 1:
			save_state = saves[save_index]
			save_index += 1
		else:
			save_state = SaveState.new().init(i + 1)
			save_slot.button.set_disabled(true)
		
		save_slot.init(save_state)
		save_slot.button.pressed.connect(_on_load_game_selected.bind(save_state))


func set_save_overwrite(enable: bool) -> void:
	_overwrite_save_on_load = enable
	for slot: SaveSlot in save_slots.get_children():
		if not slot.button.get_text().begins_with("Empty"):
			continue
		slot.button.set_disabled(!enable)


func _on_load_game_selected(save: SaveState) -> void:
	interact.emit(State.LOADING)
	if _overwrite_save_on_load:
		new_save.emit(save.slot)
	load_save.emit(save.slot)


func _on_new_game_pressed() -> void:
	interact.emit()
	main.hide()
	back.show()
	save_slots.show()
	set_save_overwrite(true)


func _on_load_game_pressed() -> void:
	interact.emit(State.CURRENT)
	main.hide()
	save_slots.show()
	back.show()
	set_save_overwrite(false)


func _on_open_settings_pressed() -> void:
	interact.emit(State.SETTINGS)


func _on_quit_game_pressed() -> void:
	interact.emit()
	exit.emit(false)


func _on_back_pressed() -> void:
	interact.emit()
	save_slots.hide()
	back.hide()
	main.show()
