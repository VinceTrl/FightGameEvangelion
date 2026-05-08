class_name CameraBackground

extends Resource

@export var texture:Texture2D = preload("uid://bq324of86i0h7")
@export var scrollDirection:ScrollDirection = ScrollDirection.NONE
@export var speedScale:float = 1.0
enum ScrollDirection{RIGHT,LEFT,UP,DOWN,NONE}
