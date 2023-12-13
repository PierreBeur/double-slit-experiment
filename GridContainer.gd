extends GridContainer


# Declare member variables.
var sValues = [100, 150, 200, 400, 800]


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# set min and max window size
	OS.min_window_size = Vector2(200, 140)
#	OS.max_window_size = Vector2(2048, 2048)
	
	var _err # connect sliders
	_err = $lSlider.connect("value_changed", self, "_on_lSlider_value_changed")
	_err = $aSlider.connect("value_changed", self, "_on_aSlider_value_changed")
	_err = $dSlider.connect("value_changed", self, "_on_dSlider_value_changed")
	_err = $fSlider.connect("value_changed", self, "_on_fSlider_value_changed")
	
	# setup a time-based seed to generator
	randomize()
	
	# set sliders
	$fSlider.set_value(100)
	_on_fSlider_value_changed($fSlider.get_value())
	_on_RandomButton_pressed()


func _on_RandomButton_pressed():
	$lSlider.set_value(rand_range(400, 700))
	$aSlider.set_value(rand_range(1, 10))
	$dSlider.set_value(rand_range($aSlider.get_value(), 20))
	_on_lSlider_value_changed($lSlider.get_value())
	_on_aSlider_value_changed($aSlider.get_value())
	_on_dSlider_value_changed($dSlider.get_value())


func _on_lSlider_value_changed(value):
#	$Value1.set_text(str(int(value))+" nm")
	$Value1.set_text("%5d nm" % int(value))

func _on_aSlider_value_changed(value):
	$Value2.set_text(str(int(value))+" µm")
	$dSlider.set_min(value)

func _on_dSlider_value_changed(value):
	$Value3.set_text(str(int(value))+" µm")

func _on_fSlider_value_changed(value):
	$Value4.set_text(str(int(value))+"  p/f")

func _on_sSlider_value_changed(value):
	$Value5.set_text(str(sValues[value])+" %")
