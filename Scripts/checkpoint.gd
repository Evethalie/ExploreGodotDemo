extends Area2D

var activated: bool = false

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if activated:
		return
	if body.is_in_group("player"):
		activated = true
		sprite.frame = 2
		# The checkpoint is 32 pixels tall. The player's center is
		# 8 pixels above the player's feet, so 24 pixels down from
		# the top puts the player's feet on the ground.
		body.set_respawn_position(global_position + Vector2(8, 24))
