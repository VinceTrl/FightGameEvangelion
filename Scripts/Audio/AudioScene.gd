class_name AudioScene
extends AudioStreamPlayer3D

func StartAudio(audioStream:AudioStream, volume:float = -10.0):
	stream = audioStream
	volume_db = volume
	play()

func _on_finished() -> void:
	queue_free()
