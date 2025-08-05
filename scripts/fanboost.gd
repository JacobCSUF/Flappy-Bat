extends "res://scripts/OBJECT_MOVEMENT.gd"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var whoosh_sound_effects_1: AudioStreamPlayer = $WhooshSoundEffects1
@onready var fan_on_: AudioStreamPlayer2D = $"Fan-on-"
@onready var smoke: AnimatedSprite2D = $smoke



var autospin = false
func _ready():
	super()
	if autospin == true:
		animated_sprite_2d.play("spinning")
		fan_on_.play()


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if _body.name == 'knight':
		if MovementManager.is_spinning == true or autospin == true:
			if not fan_on_.playing:
				fan_on_.play()
			smoke.play("default")
			animated_sprite_2d.play("spinning")
			MovementManager.change_speed(250, .85, .69)
			whoosh_sound_effects_1.play()

func _on_area_2d_body_exited(_body: Node2D) -> void:
	pass
