extends Node
class_name AbilityManager

## Manages all abilities attached to a player
## Provides methods to add, remove, enable, and disable abilities at runtime

var player: CharacterBody3D
var abilities: Dictionary = {}  # ability_name: Ability

func _ready() -> void:
	# Get reference to the parent player
	player = get_parent() as CharacterBody3D
	if not player:
		push_error("AbilityManager must be a child of a CharacterBody3D")
		return
	
	# Register all existing child abilities
	_register_existing_abilities()

func _register_existing_abilities() -> void:
	for child in get_children():
		if child is Ability:
			var ability_name = child.name
			abilities[ability_name] = child
			print("Registered ability: ", ability_name)

## Add an ability at runtime
func add_ability(ability: Ability, ability_name: String = "") -> void:
	if ability_name.is_empty():
		ability_name = ability.get_class()
	
	if abilities.has(ability_name):
		push_warning("Ability '%s' already exists. Removing old one." % ability_name)
		remove_ability(ability_name)
	
	ability.name = ability_name
	add_child(ability)
	abilities[ability_name] = ability
	print("Added ability: ", ability_name)

## Remove an ability at runtime
func remove_ability(ability_name: String) -> void:
	if not abilities.has(ability_name):
		push_warning("Ability '%s' not found." % ability_name)
		return
	
	var ability = abilities[ability_name]
	ability.queue_free()
	abilities.erase(ability_name)
	print("Removed ability: ", ability_name)

## Enable an ability (it will process input and physics)
func enable_ability(ability_name: String) -> void:
	if not abilities.has(ability_name):
		push_warning("Ability '%s' not found." % ability_name)
		return
	
	abilities[ability_name].set_process(true)
	abilities[ability_name].set_physics_process(true)
	abilities[ability_name].set_process_input(true)
	print("Enabled ability: ", ability_name)

## Disable an ability (it won't process anything but stays attached)
func disable_ability(ability_name: String) -> void:
	if not abilities.has(ability_name):
		push_warning("Ability '%s' not found." % ability_name)
		return
	
	abilities[ability_name].set_process(false)
	abilities[ability_name].set_physics_process(false)
	abilities[ability_name].set_process_input(false)
	print("Disabled ability: ", ability_name)

## Check if an ability exists
func has_ability(ability_name: String) -> bool:
	return abilities.has(ability_name)

## Get an ability by name
func get_ability(ability_name: String) -> Ability:
	return abilities.get(ability_name, null)

## Get all ability names
func get_ability_names() -> Array:
	return abilities.keys()
