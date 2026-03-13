extends Area2D

# Titik spawn awal player (set otomatis dari posisi player saat _ready)
# Atau bisa kamu set manual lewat Inspector kalau pakai @export
var spawn_point: Vector2

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		spawn_point = player.global_position
 
func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.has_method("trigger_fall"):
		body.trigger_fall(spawn_point)

func _respawn_player(player: Node2D) -> void:
	# Stop velocity dulu biar gak glitch
	if player.has_method("set") and "velocity" in player:
		player.velocity = Vector2.ZERO
	
	# Reset posisi ke spawn point
	player.global_position = spawn_point
	
	# Reset state climb/jump kalau ada
	if player.has_method("exit_ladder"):
		player.exit_ladder()
	if "jump_count" in player:
		player.jump_count = 0
	if "is_running" in player:
		player.is_running = false
