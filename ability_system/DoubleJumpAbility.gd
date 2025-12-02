extends Ability
class_name DoubleJumpAbility

## Double Jump Ability - allows the player to jump a second time in mid-air
## Just attach this node as a child of the player to enable double jumping

@export var max_jumps: int = 1
@export var jump_force: float = 4.5

var jumps_remaining: int = max_jumps
var was_on_floor: bool = false

func initialize() -> void:
	jumps_remaining = max_jumps

func ability_physics_process(_delta: float) -> void:
	# Reset jumps when landing
	if player.is_on_floor():
		if not was_on_floor:
			jumps_remaining = max_jumps
		was_on_floor = true
	else:
		was_on_floor = false

func ability_input(event: InputEvent) -> void:
	# Handle jump input
	if event.is_action_pressed("ui_accept"):
		# If not on floor and we have jumps remaining, perform a double jump
		if not player.is_on_floor() and jumps_remaining > 0:
			player.velocity.y = jump_force
			jumps_remaining -= 1

