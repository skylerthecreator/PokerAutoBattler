extends Area2D

@onready var art = $art
@onready var debug = %debug

@onready var hp = $art/hp2
@onready var atk = $art/atk
@onready var cst = $art/cst
@onready var atk_delay = $atk_delay
@onready var atk_ani = $attack_animation
@onready var qfa = $queue_free_animation
@onready var animation_end = $animation_end
@onready var cardback = $cardback



var information = null

var FRAME = null
var VALUE = null
var SUIT = null
var COST = 0

var slot_ref = null
var dropped_ref = null
var initialPos: Vector2
var draggable = false

var curr_pos: Vector2

var curr_cost = null
var curr_atk = null
var curr_hp = null

var atk_target = null
var turn_ongoing = false
var dead = false
# [FRAME, VALUE, SUIT]
func _process(_delta):
	if FRAME:
		art.frame = FRAME
		cardback.frame = 0
		cst.text = str(curr_cost)
		atk.text = str(curr_atk)
		hp.text = str(curr_hp)
	if gm.turn_ended == false:
		cardback.visible = true
		art.visible = false
	if gm.test:
		qfa.speed_scale = -1
		qfa.play("die")
	if curr_hp <= 0 and !atk_ani.is_playing() and !dead:
		qfa.speed_scale = 1
		qfa.play("die")
		dead = true

func init(info):
	information = info
	FRAME = info[0]
	VALUE = info[1]
	SUIT = info[2]
	COST = ceil(VALUE / 2.0)
	curr_atk = VALUE
	curr_hp = VALUE
	curr_cost = COST

func attack(card):
	atk_target = card
	atk_delay.start()
	animation_end.start()
	card.atk_ani.play("attack")
	atk_ani.play("attack")


func _on_mouse_entered():
	scale = Vector2(1.15, 1.15)
		
func _on_mouse_exited():
	scale = Vector2(1, 1)

func reset():
	curr_atk = VALUE
	curr_hp = VALUE
	qfa.speed_scale = -1
	qfa.play("die")
	dead = false
	
func _on_atk_delay_timeout():
	curr_hp -= atk_target.curr_atk
	atk_target.curr_hp -= curr_atk


func _on_animation_end_timeout():
	gm.animation_playing = false
