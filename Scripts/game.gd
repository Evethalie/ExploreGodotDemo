extends Node

# Sent every time the coin count changes.
signal coins_changed(amount: int)

var coins: int = 0


func add_coin() -> void:
	coins += 1
	coins_changed.emit(coins)


func reset_coins() -> void:
	coins = 0
	coins_changed.emit(coins)
