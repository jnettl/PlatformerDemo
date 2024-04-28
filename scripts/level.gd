extends CanvasLayer

signal load_finished

enum State {
	NONE,
	LOADING,
	RUNNING,
}

var state: State = State.NONE

var current_save_slot: int


func _ready() -> void:
	load_finished.connect(_on_load_finished)


func load_save(p_save: SaveState) -> void:
	state = State.LOADING
	current_save_slot = p_save.slot
	
	# TODO: Actually load the save here
	await get_tree().create_timer(2).timeout
	
	print("Loaded " + p_save.name)
	load_finished.emit()


func save() -> Dictionary:
	# TODO: Implement propagating save system
	return {}


func save_and_close() -> void:
	if state == State.NONE:
		return
	if state == State.LOADING:
		await load_finished
	var err: Error = Game.save_to_file(save())
	assert(err == OK, "save to file failed.")
	for child in get_children():
		child.queue_free()
	hide()


func _on_load_finished() -> void:
	show()
	state = State.RUNNING