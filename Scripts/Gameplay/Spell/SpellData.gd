class_name SpellData

extends Resource

enum SpellTargetType{Random,Player,SpecificTarget,Camera}
@export var targetType:SpellTargetType
@export var castDelay:float = 1.0
## -1 to infinite lifetime
@export var lifeTime:float = 5.0
@export var spellScene:PackedScene
@export var spawnOnGround:bool = false
var loadedScene
