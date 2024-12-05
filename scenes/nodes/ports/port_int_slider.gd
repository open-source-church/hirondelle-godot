extends HBasePort
class_name HPortIntSlider

var slider : HSlider

func get_component(_params : Dictionary) -> Control:
	slider = HSlider.new()
	slider.custom_minimum_size = Vector2(100, 0)
	slider.rounded = true
	return slider

func _on_params_changed():
	slider.min_value = params.get("min", 0)
	slider.max_value = params.get("max", 100)

func _get_value():
	return slider.value

func _set_value(val):
	slider.value = val
