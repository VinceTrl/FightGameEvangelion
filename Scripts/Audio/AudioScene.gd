class_name AudioScene
extends AudioStreamPlayer3D

func StartAudio(audioStream:AudioStream):
	stream = audioStream
	play()

func _on_finished() -> void:
	queue_free()
