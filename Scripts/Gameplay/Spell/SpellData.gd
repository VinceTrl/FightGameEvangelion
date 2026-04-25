class_name SpellData

extends Resource

enum SpellTargetType{Random,Player,Target}
@export var targetType:SpellTargetType
@export var castDelay:float = 1.0
@export var lifeTime:float = 5.0
@export var spellScene:PackedScene
var loadedScene
