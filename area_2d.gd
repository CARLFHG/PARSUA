extends Area2D
class_name Draggableitem

signal drag_started(item)
signal drag_ended(item)

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
				size_increase()
			else:
				if is_dragging:
					_end_drag()
		elif event is InputEventScreenDrag and is_dragging: #these two lines for lower end devices
			global_position = event.position + drag_offset
								  

func _end_drag(force_snap_back:= true):
	is_dragging=false
	active_drag_item = null 
	drag_ended.emit(self)
	z_index=0
	size_decrease()
	#shadow.queue_free()
	#await get_tree().process_frame
	#shadow = null
	#if force_snap_back:
		#var tween = create_tween()
		#tween.tween_property(self, "global_position", start_position, 0.15)
		
func size_increase():
	$Sprite2D.scale = Vector2(2,2)
	var sprite_rect = $Sprite2D.get_rect()
	var scaled_size = sprite_rect.size * $Sprite2D.scale
	
	#Calcula radius (half of the largest dimension + padding)
	var radius = (max(scaled_size.x, scaled_size.y) * 0.5)
		$DragDetector.shape.radius = radius

func size_decrease():
	$Sprite2D.scale = Vector2(1,1)
	var sprite_rect = $Sprite2D.get_rect()
	var scaled_size = sprite_rect.size * $Sprite2D.scale
	
	#Calculate radius (half of the largest dimension + padding)
	var radius = (max(scaled_size.x, scaled_size.y) * 0.5)
	$DragDetector.shape.radius = radius
