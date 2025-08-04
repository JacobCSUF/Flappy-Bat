extends "res://scripts/OBJECT_MOVEMENT.gd"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var lavasplash_1: AudioStreamPlayer2D = $Lavasplash1
@onready var splash_sound_effects: AudioStreamPlayer2D = $SplashSoundEffects
@onready var underwater_lava: AudioStreamPlayer2D = $"Underwater-lava"
@onready var lavaripples: AnimatedSprite2D = $minecart/lavaripples
@onready var stellar_discovery_287870: AudioStreamPlayer2D = $"Stellar-discovery-287870"
@onready var splashonjump: AnimatedSprite2D = $minecart/splashonjump

@onready var fx_tensions_are_high_a_scratching_violin_riff_245980: AudioStreamPlayer2D = $"Fx-tensions-are-high-a-scratching-violin-riff-245980"
@onready var minecart: AnimatedSprite2D = $minecart
@onready var fire_sound_efftect_21991: AudioStreamPlayer2D = $"Fire-sound-efftect-21991"

var queue_burning = false


func _ready():
	super()
	MovementManager.connect("movement_changed", Callable(self, "_on_movement_changed"))
	AnimationManager.connect("lava_jump_animation", Callable(self, "_on_lava_jump_animation"))
	AnimationManager.connect("lava_fall_animation", Callable(self, "_on_lava_fall_animation"))
	animation_player.connect("animation_finished", Callable(self,"_on_animation_finished"))
	
	AnimationManager.connect("boat_burning", Callable(self, "_on_boat_burning"))
	
var dis = false

func _process(delta):
	super._process(delta)  # Call parent logic (optional but often needed)
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "knight" and not dis:
		dis = true
		
		GameManager.is_boat = true

		MovementManager.change_game_speed_always(100)
		MovementManager.disconnect("speed_changed", Callable(self, "_on_speed_changed"))
		SPEED = 0

		# Snap knight's Y position to boat with offset
		var y_offset = -22
		body.global_position.y = self.global_position.y + y_offset

		# Snap boat's X position to knight's X position
		self.global_position.x = body.global_position.x

		# Reparent boat to knight (deferred)
		call_deferred("_reparent_to_knight", body)
		MovementManager.change_movement("boat")
		
		if GameManager.current_level == 'lavacave':
			stellar_discovery_287870.play()
			#lavaripples.visible = true
			underwater_lava.play()
			
func _reparent_to_knight(body: Node2D) -> void:
	var current_global = self.global_position
	self.get_parent().remove_child(self)
	body.add_child(self)
	self.global_position = current_global  # Restore global position exactly
	AnimationManager.is_ready = true
	if GameManager.current_level == 'lavacave':
		animation_player.play("bounce")



	
func _on_animation_finished(finished_anim):
	if GameManager.current_level == 'lavacave':
		animation_player.play("rock")



func _on_lava_jump_animation():
	if GameManager.current_level == "lavacave":
		if is_inside_tree():
			lavasplash_1.play()
			#lavaripples.visible = false
			splashonjump.play("lavasplash")
			lavasplash_1.play()
			underwater_lava.stop()
			animation_player.play("jump")
		

func _on_lava_fall_animation():
	if is_inside_tree():
		animation_player.play("fall")
		if GameManager.current_level == "lavacave":
			splash_sound_effects.play()
			underwater_lava.play()
			await get_tree().create_timer(0.06).timeout
			#lavaripples.visible = true
		if queue_burning:
			queue_burning= false
			minecart.play("burning")
			AnimationManager.nervous_bat()
			fire_sound_efftect_21991.play()
			fx_tensions_are_high_a_scratching_violin_riff_245980.play()
			stellar_discovery_287870.stop()
			
		

func _on_boat_burning():
	queue_burning = true
	
func _on_movement_changed(movement_type):
	if movement_type == "flying":
		queue_free()
