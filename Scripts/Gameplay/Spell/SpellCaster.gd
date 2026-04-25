extends Node

@export var spells:Array[SpellData]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InitSpell()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func InitSpell():
	for spell in spells:
		spell.loadedScene = load(spell.spellScene.resource_path)
	pass
	#for item in items: 	
		#item.resource = load(str(item.scenePath))
		
func CastSpell(data:SpellData):
	if(data.loadedScene):
		var scene = data.loadedScene.instantiate()
		if(scene is Spell):
			scene = scene as Spell
			add_child(scene)
			scene.CastSpell(data.lifeTime)
		else:
			push_error("INSTANTIATE WRONG CLASS IN SPELL CASTER")
