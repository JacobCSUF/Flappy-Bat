extends Node2D





func _on_body_entered(body: Node2D) -> void:
	
	if AnimationManager.is_ready:
		if body.is_in_group("Boat_Cart"):
			
			AnimationManager.boat_lava_fall()


func _on_body_exited(body: Node2D) -> void:
	if AnimationManager.is_ready:
		
		if body.is_in_group("Boat_Cart"):
		
			AnimationManager.boat_lava_jump()
