extends StaticBody2D
@onready var bs1 = $board_slot
@onready var bs2 = $board_slot2
@onready var bs3 = $board_slot3
@onready var bs4 = $board_slot4
@onready var bs5 = $board_slot5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	gm.BOARD[0] = bs1.occupying
	gm.BOARD[1] = bs2.occupying
	gm.BOARD[2] = bs3.occupying
	gm.BOARD[3] = bs4.occupying
	gm.BOARD[4] = bs5.occupying
