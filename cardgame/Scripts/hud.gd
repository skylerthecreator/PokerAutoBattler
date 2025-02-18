extends Node2D

@onready var wager = $CanvasLayer/wager
@onready var moves = $CanvasLayer/moves

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	wager.text = "CURRENT WAGER: " + str(gm.wager)
	moves.text = "MOVES LEFT: " + str(gm.moves)


func _on_end_pressed():
	gm.end_turn()
