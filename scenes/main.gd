extends Node

@onready var opening_sound = $AudioStreamPlayer
@onready var bg_music = $BackgroundMusic

func _ready() -> void:
	opening_sound.play()
	bg_music.play()
