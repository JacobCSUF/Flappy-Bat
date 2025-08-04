extends CharacterBody2D


@onready var bouldernoises: AudioStreamPlayer2D = $bouldernoises






var SPEED = MovementManager.game_speed


func _process(_delta: float) -> void:
	SPEED = MovementManager.game_speed
	velocity.x = -SPEED
	
	move_and_slide()
	#if ray_cast_2d.is_colliding():
		#animation_player.play("fall_boulder")
	if position.x < - 600:
		queue_free()
