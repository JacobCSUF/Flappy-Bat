extends Area2D

@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D



func _on_body_entered(body: Node2D) -> void:
	if body.name == "knight":
		print('hi')
		audio_stream_player_2d.play()
		Engine.time_scale = 0.1
		timer.start()



func _on_timer_timeout() -> void:
	AnimationManager.is_ready = false
	GameManager.is_boat = false
	GameManager.prev_score = GameManager.score
	GameManager.score = 0
	GameManager.paused = true
	GameManager.has_shield = false
	MovementManager.game_speed = 165
	MovementManager.fly_timer = .5
	Engine.time_scale = 1
	get_tree().reload_current_scene()
	MovementManager.reset_game()
