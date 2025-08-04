# ONLY WORKS IN GODOT 4 AND UP
# though changing some stuff here and there is not that hard
@tool
extends Control

func _ready() -> void:
	if Engine.is_editor_hint():
		return  # Don't run game logic in the editor
	print(self.visible)
	if !GameManager.are_we_playing:
		self.visible = true
	



func _on_button_pressed() -> void:
	GameManager.are_we_playing = true
	
	self.visible = false
	


func _on_button_2_pressed() -> void:
	get_tree().quit()
