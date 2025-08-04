extends CharacterBody2D

@onready var electric: AudioStreamPlayer2D = $electric
@onready var energy: AudioStreamPlayer2D = $energy
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var SPEED = MovementManager.game_speed
var electric_sound = false


func _process(delta: float) -> void:
	velocity.x = -SPEED
	
	if GameManager.crystal_balls > 1:
		if electric_sound == false:
			animated_sprite_2d.play("electric")
			electric.play()
			energy.stop()
			electric_sound = true
	#else:
		#if electric_sound == true:
			#animated_sprite_2d.play("energy")
			#energy.play()
			#electric.stop()
		
			#electric_sound = false
		
	move_and_slide()
	if position.x < - 300:
		queue_free()
