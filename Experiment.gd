extends TextureRect


# Declare member variables.
var size       # Screen size
var l = 600    # Wavelength (nm)
var a = 1      # Slit width (um)
var d = 4      # Slit separation (um)
var f = 800    # Photon flux (photons/frame)

var white = false # White light
var render_scale = 1.0 # Photon density
var render_scales = [1, 1.5, 2, 4, 8]

onready var img = Image.new()
onready var tex = ImageTexture.new()
onready var ColorRect = $"../ColorRect"
onready var Label = $"../../Controls/GridContainer/Value4"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set initial render resolution
	size = ColorRect.get_size()
#	size = get_size()

	# Multiply render resolution by render scale
	size *= render_scale
	
	# Limit render size to maximums
	size.x = min(size.x, 16384)
	size.y = min(size.y, 16384)
	
	# Create image
	img.create(size.x, size.y, false, Image.FORMAT_RGB8)
	
	# Fill black
	img.lock()
	img.fill(Color(0, 0, 0))
	img.unlock()
	
	# Render image
	tex.create_from_image(img)
	ColorRect.material.set_shader_param("texture", tex) # set texture
#	set_texture(tex)
#	get_texture()

	# Set up RNG with time-based seed
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	var sft = OS.get_ticks_usec() # start time of frame in usec
	var photons_drawn = 0 # reset number of photons drawn this frame
	var w = l # set wavelength to lambda
	var hue = l/360.0 - 10.0/9.0 # set hue
	
	img.lock() # lock image read access
	
	# until desired photon count is reached
	# and unless frame has taken longer than 16.667 msec
	# and photon flux is at least 1
	while photons_drawn < f \
			&& OS.get_ticks_usec() - sft < 16667 \
			&& f >= 1: 
		
		# pick random coordinate
		var pos = Vector2(randf(), randf())
		
		# if white light is enabled
		if white:
			w = rand_range(400, 700)
			hue = w/360.0 - 10.0/9.0 # set hue
		
		# calculate intensity
		var theta = PI*(pos.x - 0.5)*0.5
		theta += 0.1 * int(theta == 0) # prevent divide by zero
		var phi  = PI * d * 1000 * sin(theta) / w
		var beta = PI * a * 1000 * sin(theta) / w
		var intensity = pow(cos(phi) * sin(beta) / beta, 2)
		
		# if photon is selected
		if randf() < intensity:
			
#			img.set_pixelv((pos * size).floor()-Vector2(0.1, 0.1), Color.from_hsv(hue, 1, 1))
			img.set_pixelv((pos * size)-Vector2(0, 1), Color.from_hsv(hue, 1, 1))
#			img.set_pixel(size.x - 0.1, size.y - 0.1, Color.from_hsv(hue, 1, 1))
#			if (pos * size).y > size.y - 1:
#				print("set pixel at height "+str((pos * size).floor().y-0.1))
			photons_drawn += 1
			
	img.unlock() # unlock image read access
#	tex.create_from_image(img) # create new texture from image
	tex.set_data(img)
#	set_texture(tex) # set texture
	ColorRect.material.set_shader_param("texture", tex) # set texture
	Label.set_text(str(int(photons_drawn))+"  p/f")


func _on_Wavelength_value_changed(value):
	l = value

func _on_SlitWidth_value_changed(value):
	a = value

func _on_SlitSep_value_changed(value):
	d = value

func _on_Flux_value_changed(value):
	f = value

# toggle white light
func _on_WhiteButton_toggled(button_pressed):
	white = button_pressed


func _on_sSlider_value_changed(value):
	render_scale = render_scales[value]
	_ready()
