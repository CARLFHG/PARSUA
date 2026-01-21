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
	if can_drag:
		if event is InputEventScreenTouch:
			if event.pressed:
				if active_drag_item != null  and active_drag_item != self:
					return
				active_drag_item = self
				#start_position = global_position
				is_dragging = true
				drag_started.emit(self)
				#create_shadow_obj()
				z_index = 10
				#size increase
			else:
				if is_dragging:
					_end_drag()
		elif event is InputEventScreenDrag and is_dragging: #these two lines for lower end devices
			global_position = event.position + drag_offset
								  
