local state = {
	bg = nil,
	text = nil,
	last = "",
}

local function read_status()
	return "alpenglowed arcanbar"
end

local function remove_text()
	if state.text and valid_vid(state.text) then
		delete_image(state.text)
	end
	state.text = nil
end

local function redraw()
	local width = VRESW or 1280
	local height = 28
	local value = read_status()

	if not state.bg or not valid_vid(state.bg) then
		state.bg = color_surface(width, height, 18, 18, 18)
		move_image(state.bg, 0, 0)
		order_image(state.bg, 65534)
		show_image(state.bg)
	else
		resize_image(state.bg, width, height)
	end

	if value ~= state.last then
		remove_text()
		state.text = render_text({
			"\\ffonts/default.ttf,14\\#f2f2f2" .. value,
		})
		move_image(state.text, 12, 6)
		order_image(state.text, 65535)
		show_image(state.text)
		state.last = value
	end
end

function arcanbar()
	CLOCK = 1
	redraw()
end

function arcanbar_clock_pulse()
	redraw()
end

function arcanbar_display_state()
	redraw()
end

function arcanbar_input(iotbl)
	if iotbl.translated == "ESCAPE" then
		shutdown()
	end
end
