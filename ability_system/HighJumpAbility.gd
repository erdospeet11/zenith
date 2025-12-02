extends Ability
class_name HighJumpAbility

## High Jump Ability - replaces the normal jump with a higher jump
## The player gets 1 powerful high jump instead of a normal jump

@export var high_jump_force: float = 8.0
@export var max_jumps: int = 1

var jumps_remaining: int = max_jumps
var was_on_floor: bool = false
var jump_requested: bool = false

func initialize() -> void:
	jumps_remaining = max_jumps
	print("HighJumpAbility initialized - Jump force: ", high_jump_force)

func ability_physics_process(_delta: float) -> void:
	# Reset jumps when landing
	if player.is_on_floor():
		if not was_on_floor:
			jumps_remaining = max_jumps
		was_on_floor = true
		
		# Apply high jump if requested while on floor
		if jump_requested and jumps_remaining > 0:
			player.velocity.y = high_jump_force
			jumps_remaining -= 1
			jump_requested = false
	else:
		was_on_floor = false
		# Apply high jump in air if we have jumps remaining
		if jump_requested and jumps_remaining > 0:
			player.velocity.y = high_jump_force
			jumps_remaining -= 1
			jump_requested = false

func ability_input(event: InputEvent) -> void:
	# Handle jump input
	if event.is_action_pressed("ui_accept"):
		jump_requested = true

func _physics_process(delta: float) -> void:
	# Call parent implementation
	super._physics_process(delta)
	
	# Reset jump request after it's been processed
	if not Input.is_action_pressed("ui_accept"):
		jump_requested = false

