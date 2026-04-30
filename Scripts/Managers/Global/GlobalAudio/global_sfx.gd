extends Node

const AUDIO_SCENE = preload("uid://dc6bk6rmi44gx")

@export var sounds:Array[SoundData]

func EmitSound(stream:AudioStream,volume:float = -10.0,position:Vector3 = Vector3.ZERO):
	var audio = AUDIO_SCENE.instantiate()
	add_child(audio)
	audio.global_position = position
	audio.StartAudio(stream,volume)
	
func EmitSoundFromName(soundName:String,volume:float = -10.0,position:Vector3 = Vector3.ZERO):
	var stream := GetStreamFromName(soundName)
	if(stream):
		EmitSound(stream,volume,position)

func GetStreamFromName(soundName:String) -> AudioStream:
	for sound in sounds:
		if(sound.name == soundName):
			return sound.stream
	return null
