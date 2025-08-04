extends "res://scripts/OBJECT_MOVEMENT.gd"
@onready var shield_guard_6963: AudioStreamPlayer2D = $"Shield-guard-6963"
@onready var bubble_pop_06_351337: AudioStreamPlayer2D = $"Bubble-pop-06-351337"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	super()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "knight":
		#bubble_pop_06_351337.play()
		GameManager.has_shield = true
		shield_guard_6963.play()
		animated_sprite_2d.play("pop")
		AnimationManager.ready_shield()
		
