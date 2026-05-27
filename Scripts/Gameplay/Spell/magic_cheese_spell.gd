extends Spell

@export var movementTarget:Vector3 = Vector3.UP
@export var time:float = 3.5
@export var moveEaseType:Tween.EaseType = Tween.EASE_OUT
@export var moveTransType:Tween.TransitionType = Tween.TRANS_QUART

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const CHEESE_WHEEL = preload("uid://bwxsdvbnbah2u")


func StartMovement(start:Vector3,end:Vector3):
	global_position = start
	var tween = get_tree().create_tween()
	tween.set_ease(moveEaseType)
	tween.set_trans(moveTransType)
	tween.set_parallel(true)
	tween.tween_property(self,"global_position",end,time)
	await tween.finished

func CastSpell(duration:float = lifeTime,target:Node3D = null):
	super(duration,target)
	animation_player.play("Spawn")
	await animation_player.animation_finished
	StartMovement(global_position,global_position+movementTarget)
	animation_player.play("Effect")
	

func DestroySpell():
	super()
	queue_free()


func _on_hurt_box_detection_area_entered(area: Area3D) -> void:
	if(area is Hurtbox):
		if(!area.isActive): return
		if(area.owner is Spell):return
		if(area.is_in_group("NoCheeseTransformation")):return
		
		if(area.owner is PlayerCharacter):
			#change to cheese state
			var player = area.owner as PlayerCharacter
			player.ChangeState(player.States.Cheese)
			GlobalSFX.EmitSoundFromName("S_CHEESE_TRANSFORMATION",0.0,player.global_position)
			pass
		else:
			GlobalSFX.EmitSoundFromName("S_CHEESE_TRANSFORMATION",0.0,area.global_position)
			var cheese = CHEESE_WHEEL.instantiate()
			get_tree().current_scene.add_child(cheese)
			cheese.global_position = area.global_position
			area.owner.queue_free()
