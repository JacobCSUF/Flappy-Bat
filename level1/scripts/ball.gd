extends "res://scripts/OBJECT_MOVEMENT.gd"
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var crystal: CharacterBody2D = $"."
@onready var collision_shape_2d: CollisionShape2D = $Sprite2D/Sprite2D/CollisionShape2D

@onready var sprite_2d: Sprite2D = $Sprite2D
signal point_scored
var sound = false

func _ready():
	super()



func _on_sprite_2d_body_entered(body: Node2D) -> void:
	if !sound:
		sound = true
		GameManager.crystal_balls += 1

		emit_signal("point_scored")
		GameManager.taco('hi')
		audio_stream_player_2d.play()
		crystal.call_deferred("remove_child", sprite_2d)
