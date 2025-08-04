extends Area2D

@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var shield_timer: Timer = $"shield Timer"


func _on_body_entered(body: Node2D) -> void:
	if body.name == "knight":
		if MovementManager.is_spinning == true:
			var parent_node = get_parent()
			if parent_node.name == "barrel":
				set_deferred("monitoring",true)
				parent_node.play("break")
				parent_node.get_node("woodbreak").play()
				queue_free()
				return
				
		if GameManager.has_shield:
			
			AnimationManager.shield_break()
			shield_timer.start()
			return
			
		audio_stream_player_2d.play()
		Engine.time_scale = 0.1
		timer.start()

func _on_shield_timer_timeout() -> void:
	GameManager.has_shield = false


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
	
