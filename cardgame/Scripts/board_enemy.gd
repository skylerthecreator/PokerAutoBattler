extends StaticBody2D
@onready var bs1 = $board_slot
@onready var bs2 = $board_slot2
@onready var bs3 = $board_slot3
@onready var bs4 = $board_slot4
@onready var bs5 = $board_slot5

const CARD = preload("res://Scenes/card_enemy.tscn")

var SUITS = ["S", "H", "C", "D"]
var VALUES = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]
var CARDS = []
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 0
	for S in SUITS:
		for V in VALUES:
			CARDS.append([i, V, S])
			i += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if gm.test:
		fill_slot(bs1)
		fill_slot(bs2)
		fill_slot(bs3)
		fill_slot(bs4)
		fill_slot(bs5)
		gm.test = false
	gm.BOARD_ENEMY[0] = bs1.occupying
	gm.BOARD_ENEMY[1] = bs2.occupying
	gm.BOARD_ENEMY[2] = bs3.occupying
	gm.BOARD_ENEMY[3] = bs4.occupying
	gm.BOARD_ENEMY[4] = bs5.occupying

func fill_slot(slot):
	var numb = rng.randi_range(0, len(CARDS) - 1)
	var c = CARD.instantiate()
	c.init(CARDS[numb])
	owner.add_child(c)
	CARDS.remove_at(numb)
	slot.occupying = c
	c.dropped_ref = slot
	c.global_position = slot.global_position
	c.curr_pos = slot.global_position
