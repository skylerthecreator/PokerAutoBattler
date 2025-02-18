extends Button

@onready var flippedcard = $flippedcard
@onready var AP = $flippedcard/AnimationPlayer
@onready var timer = $Timer


var drawing = false
var show_cards_left = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	flippedcard.visible = AP.is_playing()
	text = str(len(gm.CARDS)) if show_cards_left else ""
	

func _on_pressed():
	if len(gm.HAND) < 7 and !drawing and gm.moves >= 1 and !gm.turn_ended:
		drawing = true
		gm.moves -= 1
		AP.play("draw")
		timer.start()

func _on_timer_timeout():
	gm.draw()
	drawing = false


func _on_mouse_entered():
	show_cards_left = true
func _on_mouse_exited():
	show_cards_left = false
