extends Node

enum PlatformSpawnType {Random, Scripted}

func GetAveragePosition(nodes: Array) -> Vector3:
	var total_position := Vector3.ZERO
	var count := 0
	
	for node in nodes:
		if node is Node3D:
			total_position += node.global_transform.origin
			count += 1
	
	if count == 0:
		return Vector3.ZERO
	
	return total_position / count
	
	
func GetCustomTweenCurveValue(curve:Curve,interp:float):
	return curve.sample_baked(interp)
	
	
func GetTimeToReachTargetWithSpeed(startPosition:Vector3,targetPosition:Vector3,speed:float) -> float:
	var distance = startPosition.distance_to(targetPosition)
	return distance / speed
