extends Control

@export var loading_hints: PackedStringArray

@onready var label: Label = $CenterContainer/Label


func _ready() -> void:
	visibility_changed.connect(change_text)


func change_text() -> void:
	# TODO: Load from static file or resource
	if not is_visible():
		return
	label.set_text(loading_hints[randi_range(0, len(loading_hints) - 1)])
