extends CharacterBody2D
enum PlayerState { FLYING, BOAT}
var current_state: PlayerState = PlayerState.FLYING

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var knight: AnimatedSprite2D = $knight
@onready var minecart_hitbox: CollisionShape2D = $minecart_hitbox
@onready var minecart_hitbox_2: CollisionShape2D = $minecart_hitbox2

@onready var slope_angle: RayCast2D = $slope_angle
@onready var shield: AnimatedSprite2D = $shield
@onready var shield_impact_4_382413: AudioStreamPlayer2D = $"ShieldImpact-4-382413"
@onready var smoke: AnimatedSprite2D = $smoke


const JUMP_VELOCITY = -300.0
const GRAVITY = 1050.0
const FLY_HOLD_TIME = 0.3

var space_hold_time := 0.0
var is_flying := false
var can_fly := true




func _ready():
	MovementManager.connect("movement_changed", Callable(self, "_on_movement_changed"))
	AnimationManager.connect("bat_nervous", Callable(self, "_on_bat_nervous"))
	AnimationManager.connect("shield_ready", Callable(self, "_on_shield_ready"))
	AnimationManager.connect("break_shield", Callable(self, "_on_break_shield"))
func _physics_process(delta: float) -> void:
	if GameManager.paused:
		return
	match current_state:
		PlayerState.FLYING:
			handle_flying(delta)
		PlayerState.BOAT:
			handle_boat(delta)

	move_and_slide()

func enter_flying_mode():
	velocity.y = JUMP_VELOCITY*1.4
	MovementManager.change_game_speed_always(-100)
	minecart_hitbox.call_deferred("set", "disabled", true)
	MovementManager.fly_timer = .5
func handle_flying(delta):
	if Input.is_action_pressed("ui_accept"):
		space_hold_time += delta

		if space_hold_time >= FLY_HOLD_TIME and not is_flying and can_fly:
		
			MovementManager.change_speed(+143,.75,0)
			
			start_flying()
	else:
		# Cancel flying early if space is released while flying
		if is_flying:
			end_flying()

		# Reset flight trigger if not flying
		if not is_flying:
			space_hold_time = 0.0
			can_fly = true
			
	
	# Flying logic
	if is_flying:
		MovementManager.fly_timer -= delta
	
		velocity = Vector2.ZERO  # No movement during flying

		if MovementManager.fly_timer <= 0.0:
			end_flying()
	else:
		if MovementManager.fly_timer > .6:
			MovementManager.fly_timer -= delta
		# Normal movement/gravity
		velocity.x = 0
		if not is_on_floor():
			velocity.y += GRAVITY * delta
 
	# Jump still works anytime
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
		audio_stream_player_2d.play()

	# Animations
	if is_flying:
		knight.play("spin")
		
		
	else:
		knight.play("flapwing")
		
	

func start_flying() -> void:
	
	MovementManager.is_spinning = true
	is_flying = true
	can_fly = false
	
	audio_stream_player_2d.play()

func end_flying() -> void:
	MovementManager.is_spinning = false
	is_flying = false
	MovementManager.fly_timer = .6







var float_y_position := 0.0  # The Y-position to float at

const BOAT_GRAVITY = 950.0
const MAX_JUMP_HOLD := 0.37
const MID_JUMP_FORCE := -465.0
const HOLD_JUMP_FORCE := -175.0
const BOAT_JUMP_DELAY := 0.1

var is_jump_held := false
var jump_timer := 0.0
var is_jumping := false
var has_applied_hold_boost := false
var jump_delay_timer := 0.0
var can_jump := false



func enter_boat_mode():
	
	knight.play("minecart")
	
	if GameManager.current_level == "lavacave":
		minecart_hitbox.call_deferred("set", "disabled", false)
	if GameManager.current_level == "crystalcave":
		minecart_hitbox_2.call_deferred("set", "disabled", false)
	is_jumping = false
	
	velocity = Vector2.ZERO

	can_jump = false
	jump_delay_timer = 0.0


func handle_boat(delta):
	
	
	
	if not can_jump:
		jump_delay_timer += delta
		if jump_delay_timer >= BOAT_JUMP_DELAY:
			can_jump = true

	if is_jumping:
		jump_timer += delta
		velocity.y += BOAT_GRAVITY * delta

		if is_jump_held and not has_applied_hold_boost and jump_timer >= MAX_JUMP_HOLD:
			velocity.y += HOLD_JUMP_FORCE
			has_applied_hold_boost = true

		if is_on_floor():
			if GameManager.current_level == "crystalcave":
				AnimationManager.boat_lava_fall()
			velocity = Vector2.ZERO
			is_jumping = false
			jump_timer = 0.0
			is_jump_held = false
			has_applied_hold_boost = false
	else:
		if not is_on_floor():
			velocity.y += BOAT_GRAVITY * delta
	
		else:
			var x = slope_angle.get_collision_normal()
			var angle = x.angle() - Vector2.UP.angle()
			self.rotation = angle
			velocity = Vector2.ZERO
			jump_timer = 0.0
			has_applied_hold_boost = false

		if can_jump and Input.is_action_just_pressed("ui_accept"):
			# Play bounce animation first
			
			
			# Start jump state, and set jump_timer to delay time
			
			if GameManager.current_level == "crystalcave":
				AnimationManager.boat_lava_jump()
			is_jumping = true
			is_jump_held = true
			jump_timer = BOAT_JUMP_DELAY
			velocity.y = MID_JUMP_FORCE
			
			# Schedule jump animation to play immediately after bounce
		

	if Input.is_action_just_released("ui_accept"):
		is_jump_held = false






func _on_movement_changed(movement_type):
	match movement_type:
		"boat":
			enter_boat_mode()
			current_state = PlayerState.BOAT
		"flying":
			enter_flying_mode()
			current_state = PlayerState.FLYING

func _on_bat_nervous():
	knight.play("nervous")
	
func _on_shield_ready():
	shield.play("default")


func _on_break_shield():
	shield_impact_4_382413.play()
	smoke.play("smoke")
	shield.modulate = Color(1, 1, 1, 0.6)

	var temp_timer = Timer.new()
	add_child(temp_timer)
	temp_timer.one_shot = true
	temp_timer.wait_time = 0.5  
	temp_timer.start()
	await temp_timer.timeout
	shield.stop()
