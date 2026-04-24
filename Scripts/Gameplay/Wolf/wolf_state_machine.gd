extends CharacterStateMachine


@onready var Idle: CharacterState = $Idle
@onready var Roam: CharacterState = $Roam
@onready var Hurt: CharacterState = $Hurt
@onready var Death: CharacterState = $Death
@onready var DashAttack: CharacterState = $DashAttack
@onready var Howl: CharacterState = $Howl
