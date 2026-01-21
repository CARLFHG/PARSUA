extends Area2D
class_name Draggableitem

signal drag_started(item)
signal drag_end(item)

var is_dragging = false
var drag_offset : Vector2 = Vector2.ZERO
var start_position : Vector2
var can_drag = true

var shadow = null

@export var item_id = ""
@export var texture = Texture

static var active_drag_item: Draggableitem = null #para hindi ma drag ung iba 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_event.connect(_on_input_event)
	start_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_input_event(viewport,event,shape_idx):
	pass
