extends CharacterBody2D
class_name Pincher;

@export var speed: float = 30;
@export var jump_height: float = -220;
@export var knockback: Vector2 = Vector2(200, 200);

var chasing: bool = false;

var player: Player;

func movement(dt: float):
	if (not is_on_floor()):
		velocity.y += get_gravity().y * dt;
	
	if (chasing):
		var dir = global_position.direction_to(player.global_position);
		var dist = global_position.distance_to(player.global_position);
		
		if (dist > .1):
			velocity.x = dir.x*speed;
		else:
			velocity.x = 0;
			
		if (is_on_wall() and is_on_floor() and abs(player.global_position.x-global_position.x) > 30):
			velocity.y = jump_height;


func _physics_process(delta: float) -> void:
	movement(delta);
	move_and_slide();

func _on_detection_body_entered(body: Node2D) -> void:
	if (body is Player):
		player = body;
		chasing = true;

func _on_detection_body_exited(body: Node2D) -> void:
	if (body is Player):
		chasing = false;

func _on_hitbox_body_entered(body: Node2D) -> void:
	if (body is Player and not player.iframes):
		var dir = global_position.direction_to(player.global_position);
		
		player.hurt();
		player.velocity.y = -knockback.y;
		player.velocity.x = dir.x * knockback.x;
