extends "res://scripts/OBJECT_MOVEMENT.gd"

@onready var fireball_turn_on: Area2D = $"fireball turn on"
@export var fireball: PackedScene = preload("res://level2/scenes/fireball_2.tscn")
var spawn_loop_active := false  # control flag
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _ready():
	super()

func _on_fireball_turn_on_body_entered(body: Node2D) -> void:
	if body.name == "knight":
		if not spawn_loop_active:
			spawn_loop_active = true
			_start_fireball_loop()

func _on_fireball_turn_on_body_exited(body: Node2D) -> void:
	if body.name == "knight":
		spawn_loop_active = false

func _start_fireball_loop() -> void:
	await get_tree().process_frame  # delay ensures scene is fully ready
	while spawn_loop_active:
		_spawn_fireball()
		await get_tree().create_timer(0.2).timeout

func _spawn_fireball():
	var f = fireball.instantiate()
	f.global_position = sprite_2d.position  # spawn in the center of this node
	f.z_index = -1
	add_child(f)

	var anim_player = f.get_node("AnimationPlayer")
	anim_player.play("up")
