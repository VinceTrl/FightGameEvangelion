@tool
extends EditorScript

# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	pass
	#var scene = get_scene()
	#
	#if(scene is ShitpostGUI):
		#scene as ShitpostGUI
		#LoadShitpost(scene)
		#print("Call Load Shitpost functions")
		
		
func LoadShitpost(shitpostGUI:ShitpostGUI):
	shitpostGUI.shitpostImages.clear()
	for file in DirAccess.get_files_at("res://Resources/ShitpostTextures/"):
		print("SHITPOST GUI >>> FOUND FILE : " + file)
		var image = ResourceLoader.load("res://Resources/ShitpostTextures/"+file)
		if(image is ShitpostImage):
			shitpostGUI.shitpostImages.append(image)
			print("SHITPOST GUI >>> FOUND SHITPOST : " + image.name)
			
	notify_property_list_changed()
	EditorInterface.mark_scene_as_unsaved()
