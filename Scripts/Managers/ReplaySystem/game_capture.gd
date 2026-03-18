class_name GameCapture

extends Node


@export var captureInterval:float = 0.1

@export_range(0.0,1.0,0.01) var imageQuality:float = 0.75
@export var folderName:String = "Screenshots"
@export var imageName:String = "screenshot_"

var imageIndex:int = 0
var canCapture:bool = true

var screenshotPaths:PackedStringArray
@export var screenshotMaxLength:int = 60

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CreateFolder()
	ClearFolder()
	Capture()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if(Input.is_action_just_pressed("TakeScreenshot")):
		#TakeScreenshot()
	pass
	
func Capture():
	if(!canCapture):return
	await get_tree().create_timer(captureInterval,true,false,true).timeout
	TakeScreenshot()
	Capture()
	
func TakeScreenshot():
	#await get_tree().process_frame
	var imageName := GetImageName()
	var path := GetFolderPath() + imageName

	var error = get_viewport().get_texture().get_image().save_jpg(path,imageQuality)
	
	if(!error):
		print("SCREENSHOT SAVED AT " + path)
		if(screenshotPaths.size() >= screenshotMaxLength):
			print("Removing old screen from array..." + str(screenshotPaths.size()))
			DeleteScreenshot(screenshotPaths[0])
			screenshotPaths.remove_at(0)
		screenshotPaths.append(path)
	
func DeleteScreenshot(path:String):
	if(FileAccess.file_exists(path)):
		var dir := DirAccess.open(GetFolderPath())
		dir.remove(path)
		print("DELETE FILE AT : " + path)
	
func GetImageName() -> String:
	var time := Time.get_datetime_string_from_system().replace(":","-")
	var name := "/" + imageName + time + "_" + str(imageIndex) + ".jpg"
	
	if(FileAccess.file_exists(GetFolderPath()+name)):
		while FileAccess.file_exists(GetFolderPath()+name):
			imageIndex += 1
			name = "/" + imageName + time + "_" + str(imageIndex) + ".jpg"
	
	imageIndex = 0
	return name
	
func GetFolderPath() -> String:
	return OS.get_user_data_dir() + "/" + folderName
	
func CreateFolder():
	var dir := DirAccess.open(GetFolderPath())
	if(!dir):
		DirAccess.make_dir_recursive_absolute(GetFolderPath())
		print("CREATED SCREENSHOTS FOLDER")
	pass
	
func ClearFolder():
	var dir := DirAccess.open(GetFolderPath())
	if(dir):
		print("FOLDER FOUND TO CLEAR FILE...")
		var files := dir.get_files()
		for file in files:
			dir.remove(file)
			print("DELETED FILE : " + file)
