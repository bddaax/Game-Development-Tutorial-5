extends CharacterBody2D

@export var gravity = 200.0
@export var walk_speed = 200
@export var crouch_speed = 80 
@export var jump_speed = -150 
@export var dash_speed = 800       
@export var dash_duration = 0.25   

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

var has_reached_peak_frame = false

var is_dashing = false
var dash_timer = 0.0
var dash_direction = 1 
var facing_direction = 1 

var normal_col_size = Vector2.ZERO
var normal_col_pos = Vector2.ZERO

func _ready() -> void:
	normal_col_size = collision_shape.shape.size
	normal_col_pos = collision_shape.position

func _physics_process(delta: float) -> void:
	var is_squatting = Input.is_action_pressed("ui_down") or (animated_sprite.animation == "Turun" and animated_sprite.is_playing())

	if is_squatting:
		collision_shape.shape.size.y = normal_col_size.y * 0.5
		collision_shape.position.y = normal_col_pos.y + (normal_col_size.y * 0.25)
	else:
		collision_shape.shape.size.y = normal_col_size.y
		collision_shape.position.y = normal_col_pos.y

	if Input.is_action_just_pressed("dash") and not is_squatting and not is_dashing:
		dash_direction = facing_direction
		is_dashing = true
		dash_timer = dash_duration

	if is_dashing:
		dash_timer -= delta
		velocity.y = 0 
		velocity.x = dash_direction * dash_speed
		animated_sprite.flip_h = (dash_direction == -1)

		if dash_timer <= 0:
			is_dashing = false
			
	else:
		velocity.y += delta * gravity

		if is_on_floor():
			has_reached_peak_frame = false

		if Input.is_action_just_pressed('ui_up') and not is_squatting:
			velocity.y = jump_speed
			has_reached_peak_frame = false 

		var current_speed = crouch_speed if is_squatting else walk_speed
		
		if Input.is_action_pressed("ui_left"):
			velocity.x = -current_speed
			animated_sprite.flip_h = true
			facing_direction = -1 
		elif Input.is_action_pressed("ui_right"):
			velocity.x = current_speed
			animated_sprite.flip_h = false
			facing_direction = 1 
		else:
			velocity.x = 0

	if is_dashing:
		animated_sprite.play("Dash") 
	else:
		if is_on_floor():
			if Input.is_action_pressed("ui_down"):
				if animated_sprite.animation != "Turun" or Input.is_action_just_pressed("ui_down"):
					animated_sprite.play("Turun")
				elif not animated_sprite.is_playing() and animated_sprite.frame < 2:
					animated_sprite.play("Turun")
			elif Input.is_action_just_released("ui_down"):
				animated_sprite.play_backwards("Turun")
			elif animated_sprite.animation == "Turun" and animated_sprite.is_playing():
				pass
			else:
				if velocity.x != 0:
					animated_sprite.play("Jalan")
				else:
					animated_sprite.animation = "Jalan"
					animated_sprite.stop()
		else:
			animated_sprite.play("Lompat")
			if animated_sprite.animation == "Lompat":
				if animated_sprite.frame >= 4:
					has_reached_peak_frame = true
				if has_reached_peak_frame and animated_sprite.frame < 3:
					animated_sprite.frame = 3

	move_and_slide()
