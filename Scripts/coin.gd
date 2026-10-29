extends Area2D

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	# Run _on_body_entered every time a body enters the coin.
	body_entered.connect(_on_body_entered)

	# Make the coin bob up and down forever.
	var tween: Tween = create_tween().set_loops()
	tween.tween_property(sprite, "position:y", -3.0, 0.6).set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "position:y", 0.0, 0.6).set_trans(Tween.TRANS_SINE)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Game.add_coin()
		queue_free()
