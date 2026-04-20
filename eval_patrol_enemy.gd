class_name PatrolEnemy
extends CharacterBody3D

## Enemy that patrols between waypoints and chases the player when in range.

signal health_changed(new_health: float)

@export var waypoints: Array[Node3D] = []
@export var player_path: NodePath
@export var speed: float = 3.0
@export var detection_radius: float = 8.0
@export var charge_windup: float = 2.0

var target_node: Node3D
var current_waypoint_index: int = 0


func _ready() -> void:
	target_node = get_node(player_path)
	target_node.died.connect(_on_player_died)


func _process(delta: float) -> void:
	if target_node == null:
		return

	var distance: float = global_position.distance_to(target_node.global_position)

	if distance < detection_radius:
		var direction: Vector3 = (target_node.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

		if distance < 2.0:
			var hit_effect: Node = load("res://effects/hit.tscn").instantiate()
			add_child(hit_effect)


func _on_player_died() -> void:
	health_changed.emit(0.0)


func get_game_manager() -> Node:
	return get_parent().get_parent().get_node("GameManager")


func async_charge_attack() -> void:
	await get_tree().create_timer(charge_windup).timeout
	velocity = Vector3.UP * 10.0
	move_and_slide()
# scene-grep bench
# post-godot-skills bench
# retrigger v2 with full skill pack
# retrigger v3 post-fix
# measure skills v1
# measure v2
