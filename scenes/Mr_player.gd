extends CharacterBody2D

# === STATS ===
@export var gravity = 600.0
@export var walk_speed = 160.0
@export var run_speed = 320.0
@export var jump_speed = -300.0
@export var max_jumps = 5
@export var climb_speed = 100.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var jump_sound = $JumpSound

# === STATE ===
var facing_direction = 1
var jump_count = 0
var is_running = false
var is_climbing = false
var is_dead = false
var is_hurt = false
var hit_cooldown = 0.0

# === DOUBLE TAP ===
var tap_timer_right = 0.0
var tap_timer_left = 0.0
var tap_cooldown = 0.3
var first_tap_right = false
var first_tap_left = false
var run_duration = 0.0
var run_max_duration = 0.8

func trigger_fall(spawn_point: Vector2) -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	animated_sprite.play("jump")
	await get_tree().create_timer(0.8).timeout
	_respawn(spawn_point)

func _respawn(spawn_point: Vector2) -> void:
	global_position = spawn_point
	velocity = Vector2.ZERO
	jump_count = 0
	is_running = false
	is_climbing = false
	is_dead = false
	is_hurt = false
	hit_cooldown = 0.0
	exit_ladder()

func take_hit(hit_direction: int) -> void:
	if is_hurt or is_dead:
		return
	is_hurt = true
	animated_sprite.play("hurt")
	velocity = Vector2(hit_direction * -450, -250)
	# Tunggu animasi hurt selesai lalu bisa gerak lagi
	await animated_sprite.animation_finished
	is_hurt = false

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if hit_cooldown > 0:
		hit_cooldown -= delta

	if is_hurt:
		velocity.y += gravity * delta
		if is_on_floor():
			velocity.y = 0
		move_and_slide()
		return

	_handle_double_tap(delta)

	if is_climbing:
		_handle_climb(delta)
	else:
		_handle_gravity(delta)
		_handle_jump()
		_handle_movement(delta)

	_update_animation()
	move_and_slide()

	if is_on_floor() and not is_climbing:
		jump_count = 0

	# Deteksi tabrakan dengan Player2
	if hit_cooldown <= 0:
		for i in get_slide_collision_count():
			var col = get_slide_collision(i)
			var collider = col.get_collider()
			if collider and collider.has_method("take_hit"):
				var dir = sign(global_position.x - collider.global_position.x)
				collider.take_hit(dir * -1)
				take_hit(dir)
				hit_cooldown = 1.0
				break

func _handle_double_tap(delta: float) -> void:
	if tap_timer_right > 0:
		tap_timer_right -= delta
	if tap_timer_left > 0:
		tap_timer_left -= delta

	if Input.is_action_just_pressed("ui_right"):
		if first_tap_right and tap_timer_right > 0:
			is_running = true
			run_duration = run_max_duration
			first_tap_right = false
		else:
			first_tap_right = true
			tap_timer_right = tap_cooldown

	if Input.is_action_just_pressed("ui_left"):
		if first_tap_left and tap_timer_left > 0:
			is_running = true
			run_duration = run_max_duration
			first_tap_left = false
		else:
			first_tap_left = true
			tap_timer_left = tap_cooldown

	if is_running:
		run_duration -= delta
		if run_duration <= 0:
			is_running = false

	if Input.is_action_just_released("ui_right") and facing_direction == 1:
		is_running = false
		first_tap_right = false
	if Input.is_action_just_released("ui_left") and facing_direction == -1:
		is_running = false
		first_tap_left = false

func _handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

func _handle_jump() -> void:
	if Input.is_action_just_pressed("ui_up") and jump_count < max_jumps:
		velocity.y = jump_speed
		jump_count += 1
		is_climbing = false
		jump_sound.play()

func _handle_movement(_delta: float) -> void:
	var speed = run_speed if is_running else walk_speed
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
		facing_direction = 1
		animated_sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		facing_direction = -1
		animated_sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
		is_running = false

func _handle_climb(_delta: float) -> void:
	velocity.x = 0
	velocity.y = 0
	if Input.is_action_pressed("ui_up"):
		velocity.y = -climb_speed
	elif Input.is_action_pressed("ui_down"):
		velocity.y = climb_speed
	if Input.is_action_pressed("ui_right"):
		velocity.x = walk_speed * 0.5
		animated_sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -walk_speed * 0.5
		animated_sprite.flip_h = true

func enter_ladder() -> void:
	is_climbing = true
	jump_count = 0

func exit_ladder() -> void:
	is_climbing = false

func _update_animation() -> void:
	if is_hurt:
		return
	if is_climbing:
		if velocity.y != 0 or velocity.x != 0:
			animated_sprite.play("climb")
		else:
			animated_sprite.stop()
		return
	if not is_on_floor():
		animated_sprite.play("jump")
		return
	if velocity.x != 0:
		animated_sprite.play("walk")
		animated_sprite.speed_scale = 2.0 if is_running else 1.0
	else:
		animated_sprite.play("stand")
		animated_sprite.speed_scale = 1.0
