extends Control

@onready var button := $Button as Button

func init(save: SaveState) -> void:
	button.set_text("{0}\n{1}%".format([save.name, save.progress * 100]))
