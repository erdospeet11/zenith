extends Ability
class_name DashAbility

## Dash Ability - allows the player to dash in the input direction
## Press the dash key (Shift by default) to dash

@export var dash_speed: float = 15.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 1.0
@export var can_dash_in_air: bool = true

var is_dashing: bool = false
var can_dash: bool = true
var dash_timer: float = 0.0
var cooldown_timer: float = 0.0
var dash_direction: Vector3 = Vector3.ZERO

func initialize() -> void:
	print("DashAbility initialized")

func ability_physics_process(delta: float) -> void:
	# Handle dash timer
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			cooldown_timer = dash_cooldown
	
	# Handle cooldown timer (only when not dashing)
	elif not can_dash:
		cooldown_timer -= delta
		if cooldown_timer <= 0:
			can_dash = true
	
	# Apply dash velocity
	if is_dashing:
		player.velocity.x = dash_direction.x * dash_speed
		player.velocity.z = dash_direction.z * dash_speed

func ability_input(event: InputEvent) -> void:
	# Check for dash input (using Shift key)
	if event.is_action_pressed("dash") and can_dash:
		# Check if we can dash (on floor or air dash allowed)
		if player.is_on_floor() or can_dash_in_air:
			_perform_dash()

func _perform_dash() -> void:
	# Get current input direction
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	
	# If no input, dash forward in the direction the player is facing
	if input_dir.length() == 0:
		dash_direction = -player.transform.basis.z
	else:
		dash_direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Start dash
	is_dashing = true
	can_dash = false
	dash_timer = dash_duration
	
	print("Dashing in direction: ", dash_direction)
