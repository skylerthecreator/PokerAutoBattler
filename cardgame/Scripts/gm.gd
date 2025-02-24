extends Node

var SUITS = ["S", "H", "C", "D"]
var VALUES = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]
var CARDS = []
var DISCARDS = []

var HAND = []
var BOARD = [null, null, null, null, null]

var BOARD_ENEMY = [null, null, null, null, null]

var drew = null
var is_dragging = null
var hovering = []
var rng = null

var turn_ended = false
var animation_playing = false
var input_disabled = false
var test = false

var chips = 500
var chips_enemy = 500
var turn = null
var wager = 0
var wager_enemy = 0
var moves = 50

var cards_self = null
var cards_enemy = null
var winner = "none"
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
		for c in cards_self:
			if c.curr_hp <= 0:
				cards_self.erase(c)
		for c in cards_enemy:
			if c.curr_hp <= 0:
				cards_enemy.erase(c)

		winner = check_winner(cards_self, cards_enemy)
		if winner == "draw":
			turn_drew()
		elif winner == "lost":
			turn_lost()
		elif winner == "won":
			turn_won()
		else:
			animation_playing = true
			if turn == 0:
				var next = cards_self[0]
				var target = random_card(cards_enemy)
				#var self_hp = []
				#for c123 in cards_self:
					#self_hp.append(c123.information)
				#print(self_hp)
				next.attack(target)
				cards_self.erase(next)
				cards_self.append(next)
				turn = 1
			else:
				var next = cards_enemy[0]
				var target = random_card(cards_self)
				next.attack(target)
				cards_enemy.erase(next)
				cards_enemy.append(next)
				turn = 0

func draw():
	var numb = rng.randi_range(0, len(CARDS) - 1)
	drew = CARDS[numb]
	CARDS.remove_at(numb)
	
func add_to_hand(card):
	HAND.append(card)
func move(card):
	moves -= card.COST
	HAND.erase(card)

func end_turn():
	turn = 0 #rng.randi_range(0, 1)
	moves = 10
	cards_self = get_cards(BOARD)
	cards_enemy = get_cards(BOARD_ENEMY)
	turn_ended = true
	input_disabled = true
func get_cards(brd):
	var cs = []
	for c in brd:
		if c:
			cs.append(c)
	return cs
func random_card(cards):
	return cards[rng.randi_range(0, len(cards) - 1)] 
func check_winner(cards_self, cards_enemy):
	if len(cards_self) == 0 and len(cards_enemy) == 0:
		return "draw"
	elif len(cards_self) == 0:
		return "lost"
	elif len(cards_enemy) == 0:
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
	for c in BOARD:
		if c:
			c.reset()
	turn_ended = false
	input_disabled = false
	moves = 10
