class_name GameCapture

extends Node

@export var captureInterval:float = 0.1
@export_range(0.0,1.0,0.01) var imageQuality:float = 0.75
@export var screenshotMaxLength:int = 60

@export_group("References")
@export var viewport:Viewport

var folderName:String = "Screenshots"
var imageName:String = "screenshot_"
var folderPath:String

var imageIndex:int = 0
var canCapture:bool = false
var isTakingScreenshot:bool = false

var screenshotPaths:PackedStringArray


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CreateFolder()
	ClearFolder()
	folderPath = GetFolderPath()
	pass # Replace with function body.


func StartCapture():
	if(canCapture):return
	canCapture = true
	Capture()
	pass
	
func StopCapture():
	canCapture = false
	pass
	
func Capture():
	if(!canCapture):return
	await get_tree().create_timer(captureInterval,true,false,true).timeout
	if(!canCapture):return
	TakeScreenshot()
	Capture()
	
func TakeScreenshot():
	if(isTakingScreenshot):return
	isTakingScreenshot = true
	await RenderingServer.frame_post_draw
	var path := folderPath + GetImageName()

	#var error = get_viewport().get_texture().get_image().save_jpg(path,imageQuality)
	var error = viewport.get_texture().get_image().save_jpg(path,imageQuality)
	
	if(!error):
		print("SCREENSHOT SAVED AT " + path)
		if(screenshotPaths.size() >= screenshotMaxLength):
			print("Removing old screen from array..." + str(screenshotPaths.size()))
			DeleteScreenshot(screenshotPaths[0])
			screenshotPaths.remove_at(0)
		screenshotPaths.append(path)
	else:
		print("ERROR WHILE TAKING SCREENSHOT")
		
	isTakingScreenshot = false
	
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
