extends Node

@onready var opening_sound = $AudioStreamPlayer

func _ready() -> void:
	opening_sound.play()
