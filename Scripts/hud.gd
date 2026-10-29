extends CanvasLayer

@onready var coin_label: Label = $CoinLabel


func _ready() -> void:
	# Update the label every time the coin count changes.
	Game.coins_changed.connect(_on_coins_changed)
	# Show the current count right away.
	_on_coins_changed(Game.coins)


func _on_coins_changed(amount: int) -> void:
	coin_label.text = "Coins: %d" % amount
