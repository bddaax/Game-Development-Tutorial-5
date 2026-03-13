extends CharacterBody2D

@export var speed = 120.0
@export var tile_size = 70
@export var patrol_tiles = 8

@onready var animated_sprite = $AnimatedSprite2D

var start_x: float
var end_x: float
var direction = 1
var is_hurt = false
var is_standing = false

func _ready() -> void:
	start_x = global_position.x
	end_x = start_x + (tile_size * patrol_tiles)
	_do_stand()

func _do_stand() -> void:
	is_standing = true
	velocity.x = 0
	animated_sprite.play("stand")
	await get_tree().create_timer(1.0).timeout
	is_standing = false

func _physics_process(delta: float) -> void:
	if is_hurt or is_standing:
		velocity.y += 600 * delta
		if is_on_floor():
			velocity.y = 0
		move_and_slide()
		return

	velocity.y += 600 * delta
	velocity.x = speed * direction

	if is_on_floor():
		velocity.y = 0
		animated_sprite.play("walk")

	animated_sprite.flip_h = (direction == -1)

	if direction == 1 and global_position.x >= end_x:
		velocity.x = 0
		direction = -1
		_do_stand()
	elif direction == -1 and global_position.x <= start_x:
		velocity.x = 0
		direction = 1
		_do_stand()

	move_and_slide()

func take_hit(hit_direction: int) -> void:
	if is_hurt:
		return
	is_hurt = true
	is_standing = false
	var resume_direction = direction  # Simpan arah sebelum kena hit
	animated_sprite.play("hurt")
	velocity = Vector2(hit_direction * 250, -200)
	await animated_sprite.animation_finished
	# Stand sebentar lalu lanjut jalan arah yang sama
	animated_sprite.play("stand")
	await get_tree().create_timer(0.5).timeout
	direction = resume_direction
	is_hurt = false
