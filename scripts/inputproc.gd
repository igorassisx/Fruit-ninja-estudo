extends Node2D


onready var limit = get_node("Limit")
onready var interval = get_node("Interval")

var pressed = false
var drag = false
var curPosition = Vector2(0, 0)
var prevPosition = Vector2(0, 0)

var gameOver = false

func _ready():
	pass 


func _input(event):
	
	event = make_input_local(event)
	if event is InputEventScreenTouch:
		if event.pressed:
			pressed(event.position)
		else:
			released()
	elif event is InputEventScreenDrag:
		drag(event.position)

func _physics_process(_delta):
	update()
	if drag and curPosition != prevPosition and prevPosition != Vector2(0, 0) and not gameOver:
		var space_state = get_world_2d().get_direct_space_state()
		var result = space_state.intersect_ray(prevPosition, curPosition)
		if not result.empty():
			result.collider.cut()

func pressed(position):
	pressed = true
	prevPosition = position
	limit.start()
	interval.start()


func released():
	pressed = false
	drag = false
	limit.stop()
	interval.stop()
	prevPosition = Vector2(0, 0)
	curPosition = Vector2(0, 0)


func drag(position):
	curPosition = position
	drag = true


func _on_Interval_timeout():
	prevPosition = curPosition


func _on_Limit_timeout():
	released()


func _draw():
	if drag and curPosition != prevPosition and prevPosition != Vector2(0, 0) and not gameOver:
		draw_line(curPosition, prevPosition, Color(1, 0 ,0), 10)
			
