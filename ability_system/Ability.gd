extends Node
class_name Ability

## Base class for all abilities that can be attached to a player
## Abilities are self-contained and don't require modifications to the player script

var player: CharacterBody3D

func _ready() -> void:
	# Get reference to the parent player
	player = get_parent().get_parent() as CharacterBody3D
	if not player:
		push_error("Ability must be a child of a CharacterBody3D")
		return
	
	# Call the initialize function that abilities can override
	initialize()

## Override this in child classes to set up ability-specific behavior
func initialize() -> void:
	pass

## Override this in child classes for ability logic
func ability_physics_process(_delta: float) -> void:
	pass

## Override this in child classes for input handling
func ability_input(_event: InputEvent) -> void:
	pass

func _physics_process(delta: float) -> void:
	if player:
		ability_physics_process(delta)

func _input(event: InputEvent) -> void:
	if player:
		ability_input(event)
