class_name OneWayPlatformRaycast

extends RayCast3D

func set_mask(mask:int):
	set_collision_mask_value(mask, true)

func is_on_one_way_platform() ->bool:
	if(is_colliding()):
		var col := get_collider()
		if(col is OneWayCollision):
			return true
		else: 
			return false
	else:
		return false
		
func get_platform() -> OneWayCollision:
	if(is_colliding()):
		var col := get_collider()
		if(col is OneWayCollision):
			return col
		else: 
			return null
	else:
		return null
