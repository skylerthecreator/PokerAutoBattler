extends Node2D

@onready var wager = $CanvasLayer/wager
@onready var moves = $CanvasLayer/moves
@onready var cd = $CanvasLayer/cd
@onready var countdown = $CanvasLayer/countdown

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	wager.text = "CURRENT WAGER: " + str(gm.wager)
	moves.text = "MOVES LEFT: " + str(gm.moves)


func _on_end_pressed():
	gm.test = true
	cd.visible = true
	countdown.start()
	


func _on_timer_timeout():
	if cd.text == "3":
		cd.text = "2"
		countdown.start()
	elif cd.text == "2":
		cd.text = "1"
		countdown.start()
	elif cd.text == "1":
		cd.visible = false
		cd.text = "3"
		gm.end_turn()
