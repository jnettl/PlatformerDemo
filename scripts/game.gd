class_name Game
extends Node

enum Difficulty {
	EASY,
	NORMAL,
	HARD,
	NIGHTMARE,
}

const SAVE_PATH = "user://saves/"
const SAVE_NAME = "save{0}.tres"
const MAX_SAVES = 3
const STRIP_RES = false

const Level = preload("res://scripts/level.gd")
const Menu = preload("res://scripts/menu.gd")

@onready var level := $Level as Level
@onready var menu := $Menu as Menu


#region Static Methods

static func create_save_file(slot: int) -> Error:
	var dir: DirAccess = DirAccess.open(SAVE_PATH)
	var save_state: SaveState
	var err: Error
	for filename in DirAccess.get_files_at(SAVE_PATH):
		if filename.begins_with(SAVE_NAME.format([slot - 1])) and not filename.ends_with(".bak"):
			print("Overwriting {0} and creating backup...".format([filename]))
			err = dir.rename(filename, filename + ".bak")
			assert(err == OK, "failed backup of {0}: Error {1}.".format([filename, err]))
	save_state = SaveState.new().init(slot)
	save_state.name = "New Game"
	save_state.scene = load(Level.NEW_GAME)
	err = ResourceSaver.save(save_state, SAVE_PATH + SAVE_NAME.format([slot - 1]), ResourceSaver.FLAG_COMPRESS)
	assert(err == OK, "failed to create file {0}: Error {1}.".format([SAVE_PATH + SAVE_NAME.format([slot - 1]), err]))
	return err


static func save_to_file(_data: Dictionary) -> Error:
	# TODO: Save SaveState and SaveData
	return OK


static func get_save(slot: int) -> SaveState:
	var save_state: SaveState
	for filename in DirAccess.get_files_at(SAVE_PATH):
		# TODO: Implement .res stripping
		if filename == SAVE_NAME.format([slot - 1]):
			save_state = ResourceLoader.load(SAVE_PATH + filename) as SaveState
			assert(save_state, "failed to load {0}.".format([filename]))
			assert(save_state.slot == slot,
					"{0} occupies slot {1}.".format([save_state.name, save_state.slot]))
			break
	# TODO: Asserts and save validation
	# I imagine the SaveState will reference any dependent files
	return save_state


static func get_save_list() -> Array[SaveState]:
	# NOTE: ResourceLoader type hints fail for binary classes. #GH-90769
	# The fix may also resolve loading resources with custom file extensions
	# In this case, we use STRIP_RES to dynamically rename the file at load time
	var saves: Array[SaveState] = []
	for i in range(MAX_SAVES):
		var dir: DirAccess = DirAccess.open(SAVE_PATH)
		var err: Error
		var save_state: SaveState
		var filename: String = SAVE_PATH + SAVE_NAME.format([i])
		if STRIP_RES:
			assert(not ResourceLoader.exists(filename + ".res"),
					"{0} conflicts with file {1}.".format([filename, filename + ".res"]))
			if ResourceLoader.exists(filename + ".res"):
				print("Overwriting {0} and creating backup...".format([filename]))
				err = dir.rename(filename + ".res", filename + ".bak")
				assert(err == OK, "failed backup of {0}: {1}.".format([filename, err]))
			err = dir.rename(filename, filename + ".res")
			assert(err == OK, "failed to rename file {0}: Error {1}.".format([filename, err]))
			filename += ".res"
		if ResourceLoader.exists(filename):
			save_state = ResourceLoader.load(filename) as SaveState
			assert(save_state, "failed to load {0}.".format([filename]))
			assert(save_state.slot == i + 1, "{0} occupies slot {1}.".format([save_state.name, save_state.slot]))
			saves.append(save_state)
		if STRIP_RES:
			err = dir.rename(filename, filename.rstrip(".res"))
			assert(err == OK, "failed to rename file {0}: Error {1}.".format([filename, err]))
	return saves

#endregion


func _ready() -> void:
	menu.exit.connect(_on_exit_game)
	menu.new_save.connect(create_save_file)
	menu.load_save.connect(func(slot: int) -> void:
			level.load_save(get_save(slot)))
	level.load_finished.connect(func() -> void:
			menu.background.hide()
			menu.change_current_menu(menu.State.NONE))


func _on_exit_game(soft: bool) -> void:
	level.save_and_close()
	if not soft:
		get_tree().quit()
