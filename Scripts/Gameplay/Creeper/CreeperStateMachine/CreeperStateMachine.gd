extends CharacterStateMachine

@onready var Idle: CharacterState = $Idle
@onready var Roam: CharacterState = $Roam
@onready var Chase: CharacterState = $Chase
@onready var Ignite: CharacterState = $Ignite
@onready var Explode: CharacterState = $Explode
@onready var Hurt: CharacterState = $Hurt
@onready var Death: CharacterState = $Death
#@onready var Dance: CharacterState = $Dance
