class_name SaveState
extends Resource

@export var name: String = "Empty"
@export var created_time: float = -1
@export var updated_time: float = -1
@export_range(0, 1) var progress: float = 0.0
@export_range(1, Game.MAX_SAVES) var slot: int
@export var scene: PackedScene


static func validate(save_state: SaveState) -> Error:
	# TODO: Validate save data
	save_state = save_state
	return OK


# NOTE: ResourceLoader can't provide constructor arguments
func init(p_slot: int) -> SaveState:
	slot = p_slot
	created_time = Time.get_unix_time_from_system()
	return self
