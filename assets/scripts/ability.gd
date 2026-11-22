extends Node2D

enum Ability {
	Dash,
	DoubleJump,
}

@export var ability: Ability;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (ability == Ability.Dash):
			Globals.unlocked_dash = true;
		elif (ability == Ability.DoubleJump):
			Globals.max_jumps = 2;
		
		queue_free();
