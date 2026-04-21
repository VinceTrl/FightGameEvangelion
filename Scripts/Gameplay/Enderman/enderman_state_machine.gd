extends CharacterStateMachine

@onready var Idle: CharacterState = $Idle
@onready var Wander: CharacterState = $Wander
@onready var Chase: CharacterState = $Chase
@onready var Hurt: CharacterState = $Hurt
@onready var Steal: CharacterState = $Steal
@onready var Drop: CharacterState = $Drop
@onready var Death: CharacterState = $Death
