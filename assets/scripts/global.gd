extends Node2D
class_name Globals

static var unlocked_dash: bool = false;
static var max_jumps: int = 1;

# level value structured like (y,x), y & x starting at 1
static var level: int = 11;

# difference in x value of levels between previous and current level
static var delta_level_x: int = 0;

# returns the scene corresponding to current level position
static func get_level() -> String:
	return "res://assets/scenes/levels/level_"+str(Globals.level)+".tscn";
