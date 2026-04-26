extends Node3D

@export var timeBetweenSpell_Min:float = 4.0
@export var timeBetweenSpell_Max:float = 9.0

@export var spellAnimations:Array[String] = ["MagicCast_Big_2H_01",
"MagicCast_Big_2H_02","MagicCast_Big_2H_03","MagicCast_Big_2H_04",
"MagicCast_Big_1H_01","MagicCast_Small_1H_01","MagicCast_Area_2H_01"]

@onready var spell_caster: Node3D = $SpellCaster
@onready var animation_player: AnimationPlayer = $Visual/Zelda/AnimationPlayer

signal SpellLaunched

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SpellLoop()
	pass # Replace with function body.

func SpellLoop():
	await get_tree().create_timer(randf_range(timeBetweenSpell_Min,timeBetweenSpell_Max)).timeout
	SpellAnimation()
	await SpellLaunched
	spell_caster.RandomSpell()
	SpellLoop()

func SpellAnimation():
	var anim:String = spellAnimations.pick_random()
	animation_player.play(anim)
	pass
	
func LaunchSpell():
	SpellLaunched.emit()
	pass
