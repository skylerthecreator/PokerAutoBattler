extends Node

var SUITS = ["S", "H", "C", "D"]
var VALUES = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]
var CARDS = []
var DISCARDS = []

var HAND = []
var BOARD = [null, null, null, null, null]

var BOARD_ENEMY = [null, null, null, null, null]

var drew = null
var moved = null
var is_dragging = null
var hovering = []
var rng = null

var turn_ended = false
var animation_playing = false
var input_disabled = false


var chips = 500
var chips_enemy = 500
var turn = null
var wager = 0
var wager_enemy = 0
var moves = 50
func _ready():
	var i = 0
	for S in SUITS:
		for V in VALUES:
			CARDS.append([i, V, S])
			i += 1
	#CARDS.append([52, 14, "J"])
	#CARDS.append([53, 15, "J"])
	rng = RandomNumberGenerator.new()
	
func _process(_delta):
	if !animation_playing and turn_ended:
		var cards_self = get_cards(BOARD)
		var cards_enemy = get_cards(BOARD_ENEMY)
		var winner = check_winner(cards_self, cards_enemy)
		if winner == "draw":
			turn_drew()
			#break
		elif winner == "lost":
			turn_lost()
			#break
		elif winner == "won":
			turn_won()
		else:
			if turn == 0:
				cards_self[0].attack(random_card(cards_enemy))
				turn = 1
			else:
				cards_enemy[0].attack(random_card(cards_self))
				turn = 0
func draw():
	var numb = rng.randi_range(0, len(CARDS) - 1)
	drew = CARDS[numb]
	CARDS.remove_at(numb)
func move(card):
	moves -= card.COST
	HAND.erase(card)
	moved = card
func end_turn():
	turn = 0 #rng.randi_range(0, 1)
	turn_ended = true
	input_disabled = true
	moves = 10
	
func get_cards(brd):
	var cs = []
	for c in brd:
		if c and c.curr_hp > 0:
			cs.append(c)
	return cs if !cs.is_empty() else null
func random_card(cards):
	return cards[rng.randi_range(0, len(cards) - 1)] 

func check_winner(cards_self, cards_enemy):
	if cards_self == null and cards_enemy == null:
		return "draw"
	elif cards_self == null:
		return "lost"
	elif cards_enemy == null:
		return "won"
	else:
		return "none"

func discard(c):
	if c.dropped_ref:
		c.dropped_ref.occupying = null
	else:
		HAND.erase(c)
		hovering.erase(c)
	DISCARDS.append(c.information)
	c.queue_free()

func turn_drew():
	chips += wager
	chips_enemy += wager_enemy
	reset_board()
func turn_lost():
	chips_enemy += wager
	reset_board()
func turn_won():
	chips += wager_enemy
	reset_board()
func reset_board():
	wager = 0
	wager_enemy = 0
	turn_ended = false
	input_disabled = false
	moves = 10
