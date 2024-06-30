extends AudioStreamPlayer

enum Sound {
	MENU_CLICK
}

const SOUND_DB = {
	Sound.MENU_CLICK: preload("res://assets/audio/ui/click1.ogg"),
}


func _ready() -> void:
	pass


func play_sound(sound: Sound) -> void:
	stream = SOUND_DB[sound]
	play()
