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
var adjusted = false
var initialPos: Vector2
var draggable = false
var hovering = false
var focus = false
var temp_z = null

var curr_pos: Vector2

var curr_cost = null
var curr_atk = null
var curr_hp = null

var atk_target = null
var turn_ongoing = false
var dead = false
# [FRAME, VALUE, SUIT]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#debug.text = str(gm.hovering, hovering, focus)
	
	if FRAME:
		art.frame = FRAME
		cardback.frame = 0
		cst.text = str(curr_cost)
		atk.text = str(curr_atk)
		hp.text = str(curr_hp)
	if curr_hp <= 0 and !atk_ani.is_playing() and !dead:
		qfa.speed_scale = 1
		qfa.play("die")
		dead = true
	if len(gm.hovering) > 0:
		focus = gm.hovering[0] == self
	if focus:
		if !adjusted:
			if dropped_ref == null:
				position.y -= 20
			temp_z = z_index
			z_index = 15
			adjusted = true
		if gm.is_dragging == null:
			draggable = true
			scale = Vector2(1.15, 1.15)
	else:
		if adjusted:
			global_position = curr_pos
			z_index = temp_z
			adjusted = false
		if gm.is_dragging == null:
			draggable = false
			scale = Vector2(1, 1)
	if draggable and !gm.turn_ended:
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			gm.is_dragging = self
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position()
		elif Input.is_action_just_released("click"):
			gm.is_dragging = null
			var tween = get_tree().create_tween()
			if slot_ref and slot_ref.is_in_group("slot"):
				if slot_ref.occupying == null and dropped_ref == null:
					if gm.moves >= COST:
						adjusted = false
						slot_ref.occupying = self
						dropped_ref = slot_ref
						#global_position = slot_ref.global_position
						tween.tween_property(self, "global_position", slot_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
						curr_pos = slot_ref.global_position
						gm.move(self)
					else:
						tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
						#global_position = initialPos
				elif slot_ref.occupying == null and dropped_ref != null:
					adjusted = false
					slot_ref.occupying = self
					tween.tween_property(self, "global_position", slot_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
					#global_position = slot_ref.global_position
					curr_pos = slot_ref.global_position
					dropped_ref.occupying = null
					dropped_ref = slot_ref
				elif slot_ref.occupying != null and dropped_ref != null:
					adjusted = false
					var temp = slot_ref.occupying
					slot_ref.occupying = self
					tween.tween_property(self, "global_position", slot_ref.global_position, 0.2).set_ease(Tween.EASE_OUT)
					#global_position = slot_ref.global_position
					curr_pos = slot_ref.global_position
					dropped_ref.occupying = temp
					temp.global_position = dropped_ref.global_position
					temp.dropped_ref = dropped_ref
					dropped_ref = slot_ref
			elif slot_ref and slot_ref.is_in_group("discard"):
				gm.discard(self)
			else:
				tween.tween_property(self, "global_position", curr_pos, 0.2).set_ease(Tween.EASE_OUT)

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
	hovering = true
	gm.hovering.append(self)
	if gm.hovering[0] == self:
		focus = true
		
func _on_mouse_exited():
	hovering = false
	gm.hovering.erase(self)
	if focus:
		focus = false

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
