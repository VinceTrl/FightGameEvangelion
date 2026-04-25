extends Node3D

@export var timeBetweenSpell_Min:float = 4.0
@export var timeBetweenSpell_Max:float = 9.0

@onready var spell_caster: Node3D = $SpellCaster
@onready var animation_player: AnimationPlayer = $Visual/Zelda/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SpellLoop()
	pass # Replace with function body.

func SpellLoop():
	await get_tree().create_timer(randf_range(timeBetweenSpell_Min,timeBetweenSpell_Max)).timeout
	SpellAnimation()
	await get_tree().create_timer(1.25).timeout
	spell_caster.RandomSpell()
	SpellLoop()

func SpellAnimation():
	animation_player.play("MagicCast_Big_2H_01")
	pass
