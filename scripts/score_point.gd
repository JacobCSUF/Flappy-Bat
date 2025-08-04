# ScorePoint.gd
extends Area2D

signal point_scored  # Custom signal

func _on_body_entered(body: Node2D) -> void:
	if body.name == "knight":
		GameManager.taco('hi')
		emit_signal("point_scored")  # Emit signal to whoever connected
	
func _process(delta: float) -> void:
	position.x -= MovementManager .game_speed*delta
	if position.x < - 300:
		queue_free()
