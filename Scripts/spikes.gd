extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)

#• body.call_deferred("die") runs the player's die() function after Godot finishes the 
#current physics step. Moving or reloading the player in the middle of a physics step causes errors.
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.call_deferred("die")
