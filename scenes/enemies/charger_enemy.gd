class_name ChargerEnemy
extends BaseEnemy

enum State { TRACKING, WINDUP, CHARGING, COOLDOWN }

const SCALE_NORMAL: Vector2 = Vector2(0.5, 0.5)
const SCALE_WINDUP: Vector2 = Vector2(0.25, 0.25)

@export var charge_speed: float = 280.0
@export var charge_duration: float = 0.6
@export var windup_duration: float = 0.5
@export var cooldown_duration: float = 2.0
@export var charge_damage_multiplier: float = 2.0
@export var charge_trigger_range: float = 200.0

var _state: State = State.TRACKING
var _charge_direction: Vector2 = Vector2.ZERO
var _state_timer: float = 0.0
var _is_charge_hit: bool = false

func _ready() -> void:
	super()
	sprite_2d.scale = SCALE_NORMAL
	
func _move(delta: float) -> void:
	match _state:
		State.TRACKING:
			_tick_tracking(delta)
		State.WINDUP:
			_tick_windup(delta)
		State.CHARGING:
			_tick_charging(delta)
		State.COOLDOWN:
			_tick_cooldown(delta)

func _tick_tracking(delta: float) -> void:
	var to_player: Vector2 = player.global_position - global_position
	var direction: Vector2 = to_player.normalized()
	velocity = direction * move_speed

	if to_player.length() <= charge_trigger_range:
		_enter_windup()

func _enter_tracking() -> void:
	_state = State.TRACKING
	sprite_2d.scale = SCALE_NORMAL
	
func _enter_windup() -> void:
	_state = State.WINDUP
	_state_timer = windup_duration
	velocity = Vector2.ZERO
	var tween := create_tween()
	tween.tween_property(sprite_2d, "scale", SCALE_WINDUP, windup_duration)

func _tick_windup(delta: float) -> void:
	_state_timer -= delta
	if _state_timer <= 0.0:
		_enter_charging()

func _enter_charging() -> void:
	_state = State.CHARGING
	_state_timer = charge_duration
	_charge_direction = (player.global_position - global_position).normalized()
	_is_charge_hit = false
	velocity = _charge_direction * charge_speed
	var tween := create_tween()
	tween.tween_property(sprite_2d, "scale", SCALE_NORMAL, 0.1)

func _tick_charging(delta: float) -> void:
	_state_timer -= delta
	velocity = _charge_direction * charge_speed

	if _state_timer <= 0.0:
		_enter_cooldown()

func _enter_cooldown() -> void:
	_state = State.COOLDOWN
	_state_timer = cooldown_duration
	velocity = Vector2.ZERO
	sprite_2d.scale = SCALE_NORMAL

func _tick_cooldown(delta: float) -> void:
	_state_timer -= delta
	if _state_timer <= 0.0:
		#_state = State.TRACKING
		_enter_tracking()
