extends Area2D

# The level to load next. Leave it empty to restart this level.
@export_file("*.tscn") var next_level: String = ""


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	print("Level complete! Coins: %d" % Game.coins)

	if next_level.is_empty():
		Game.reset_coins()
		get_tree().reload_current_scene.call_deferred()
	else:
		get_tree().change_scene_to_file.call_deferred(next_level)
