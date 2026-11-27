extends Node2D

@export var next_x: int = 0;
@export var next_y: int = 0;

func _ready() -> void:
	var player: Player = get_tree().get_first_node_in_group("player");
	
	if (Globals.delta_level_x < 0 and next_x > 0):
		player.position.x = position.x-12;
		player.position.y = position.y;
		player.flip_h = true;
		
	if (Globals.delta_level_x > 0 and next_x < 0):
		player.position.x = position.x+12;
		player.position.y = position.y;
		player.flip_h = false;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is Player):
		Globals.level = (Globals.level+(10*next_y)+next_x);
		Globals.delta_level_x = next_x;
		get_tree().change_scene_to_file(Globals.get_level());
