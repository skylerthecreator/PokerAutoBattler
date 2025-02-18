extends Area2D

var occupying = null
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_mouse_entered():
	if gm.is_dragging != null:
		gm.is_dragging.slot_ref = self

func _on_mouse_exited():
	if gm.is_dragging != null:
		gm.is_dragging.slot_ref = null
