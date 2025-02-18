extends Area2D

@onready var value = $value

var mouseover = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("click") and mouseover:
		gm.wager += int(value.text)


func _on_mouse_entered():
	scale = Vector2(1.15, 1.15)
	mouseover = true


func _on_mouse_exited():
	scale = Vector2(1.0, 1.0)
	mouseover = false
