local state = {
	bg = nil,
	text = nil,
	last = "",
}

local bar_height = 28
local bg_order = 65534
local text_order = 65535
local bg_color = { 18, 18, 18 }
local text_style = "\\ffonts/default.ttf,14\\#f2f2f2"
local status_resource = "arcanbar.status"

local function trim_line(value)
	return (value:gsub("[\r\n]+$", ""))
end

local function read_resource_status()
	if not open_rawresource or not read_rawresource then
		return nil
	end

	if not open_rawresource(status_resource) then
		return nil
	end

	local value = read_rawresource()
	close_rawresource()

	if value and value ~= "" then
		return trim_line(value)
	end

	return nil
end

local function read_status()
	return read_resource_status() or "alpenglowed arcanbar"
end

local function remove_text()
	if state.text and valid_vid(state.text) then
		delete_image(state.text)
	end
	state.text = nil
end

local function redraw()
	local width = VRESW or 1280
	local value = read_status()

	if not state.bg or not valid_vid(state.bg) then
		state.bg = color_surface(width, bar_height, bg_color[1], bg_color[2], bg_color[3])
		move_image(state.bg, 0, 0)
		order_image(state.bg, bg_order)
		show_image(state.bg)
	else
		resize_image(state.bg, width, bar_height)
	end

	if value ~= state.last then
		remove_text()
		state.text = render_text({
			text_style .. value,
		})
		move_image(state.text, 12, 6)
		order_image(state.text, text_order)
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
	if iotbl and iotbl.translated == "ESCAPE" then
		shutdown()
	end
end
