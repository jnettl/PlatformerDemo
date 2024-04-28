extends "res://scripts/menu.gd"


func _ready() -> void:
	pass


func _on_back_pressed() -> void:
	interact.emit()


func _on_quit_game_pressed() -> void:
	interact.emit()
	exit.emit(true)
