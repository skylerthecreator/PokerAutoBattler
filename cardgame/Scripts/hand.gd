extends Area2D

@onready var card1 = $card1
@onready var card2 = $card2
@onready var card3 = $card3
@onready var card4 = $card4
@onready var card5 = $card5
@onready var card6 = $card6
@onready var card7 = $card7
@onready var card8 = $card8
@onready var card9 = $card9
@onready var card10 = $card10
@onready var card11 = $card11
@onready var card12 = $card12
@onready var card13 = $card13


const CARD = preload("res://Scenes/card.tscn")

var last_hand_size = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if gm.drew != null:
		draw()
	if len(gm.HAND) != last_hand_size:
		show_hand()
		last_hand_size = len(gm.HAND)


func draw():
	var c = CARD.instantiate()
	c.init(gm.drew)
	owner.add_child(c)
	gm.HAND.append(c)
	c.curr_pos = c.global_position
	gm.drew = null

func update_pos(hc, cp):
	hc.global_position = cp.global_position
	hc.curr_pos = cp.global_position

func show_hand():
	if len(gm.HAND) == 1:
		update_pos(gm.HAND[0], card4)
	elif len(gm.HAND) == 2:
		update_pos(gm.HAND[0], card10)
		update_pos(gm.HAND[1], card11)
	elif len(gm.HAND) == 3:
		update_pos(gm.HAND[0], card3)
		update_pos(gm.HAND[1], card4)
		update_pos(gm.HAND[2], card5)
	elif len(gm.HAND) == 4:
		update_pos(gm.HAND[0], card9)
		update_pos(gm.HAND[1], card10)
		update_pos(gm.HAND[2], card11)
		update_pos(gm.HAND[3], card12)
	elif len(gm.HAND) == 5:
		update_pos(gm.HAND[0], card2)
		update_pos(gm.HAND[1], card3)
		update_pos(gm.HAND[2], card4)
		update_pos(gm.HAND[3], card5)
		update_pos(gm.HAND[4], card6)
	elif len(gm.HAND) == 6:
		update_pos(gm.HAND[0], card8)
		update_pos(gm.HAND[1], card9)
		update_pos(gm.HAND[2], card10)
		update_pos(gm.HAND[3], card11)
		update_pos(gm.HAND[4], card12)
		update_pos(gm.HAND[5], card13)
	elif len(gm.HAND) == 7:
		update_pos(gm.HAND[0], card1)
		update_pos(gm.HAND[1], card2)
		update_pos(gm.HAND[2], card3)
		update_pos(gm.HAND[3], card4)
		update_pos(gm.HAND[4], card5)
		update_pos(gm.HAND[5], card6)
		update_pos(gm.HAND[6], card7)


func _on_mouse_entered():
	if gm.is_dragging != null:
		gm.is_dragging.slot_ref = self

func _on_mouse_exited():
	if gm.is_dragging != null:
		gm.is_dragging.slot_ref = null
