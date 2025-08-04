extends "res://scripts/OBJECT_MOVEMENT.gd"


@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var fruit: CharacterBody2D = $"."

@onready var Fruit: AnimatedSprite2D = $Fruit



var sound = false

func _ready():
	super()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if !sound:
		sound = true
		Fruit.visible = false
		audio_stream_player_2d.play()
		
