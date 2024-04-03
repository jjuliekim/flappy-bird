extends Area2D

## ground image is bigger than the window size to give idea of endless moving

## detect collision
signal hit

func _on_body_entered(body):
	hit.emit()
