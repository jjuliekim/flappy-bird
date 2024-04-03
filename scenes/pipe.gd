extends Area2D

signal hit ## hit pipe
signal scored ## passed through pipe

func _on_body_entered(body):
	hit.emit()


func _on_score_area_body_entered(body):
	scored.emit()
