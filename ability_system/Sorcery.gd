extends Ability
class_name Sorcery

func _init():
	name = "Sorcery"
	description = "A magical ability that allows the player to cast spells."
	icon = preload("res://assets/icons/sorcery.png")
	cooldown = 1.0
	cast_time = 0.5
	range = 10.0
	damage = 10.0
	damage_type = "Magic"