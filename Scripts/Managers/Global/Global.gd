extends Node

enum PlatformSpawnType {Random, Scripted, None}
enum ShitpostType{Shitpost,RDR,Gaucho,Glitch}

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
	
	
#func GetNodeInHierarchy(node: Node) -> AnimationPlayer:
	#for child in node.get_children():
		#if child is AnimationPlayer:
			#return child
		## Recherche récursive dans les enfants
		#var found = GetNodeInHierarchy(child)
		#if found:
			#return found
	#return null
	
#func GetNodeOfTypeInHierarchy[T](node: Node) -> T:
	#for child: Node in node.get_children():
		#if child is T:
			#return child as T
		#var found: T = GetNodeOfTypeInHierarchy[T](child)
		#if found:
			#return found
	#return null
	
func GetNodeOfTypeInHierarchy(node: Node, type_to_find: Variant) -> Node:
	for child: Node in node.get_children():
		if child.get_class() ==  type_to_find.get_class():
			return child
		var found = GetNodeOfTypeInHierarchy(child, type_to_find)
		if found:
			return found
	return null
