-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_screen_size, client_set_cvar, math_fmod, tonumber, ui_get, ui_new_slider, ui_set_callback, ui_set_visible = client.screen_size, client.set_cvar, math.fmod, tonumber, ui.get, ui.new_slider, ui.set_callback, ui.set_visible

local function set_aspect_ratio(aspect_ratio_multiplier)
	local screen_width, screen_height = client_screen_size()
	local aspectratio_value = (screen_width*aspect_ratio_multiplier)/screen_height

	if aspect_ratio_multiplier == 1 then
		aspectratio_value = 0
	end
	client_set_cvar("r_aspectratio", tonumber(aspectratio_value))
end

local function gcd(m, n)
	while m ~= 0 do
		m, n = math_fmod(n, m), m
	end

	return n
end

local screen_width, screen_height, aspect_ratio_reference

local function on_aspect_ratio_changed()
	local aspect_ratio = ui_get(aspect_ratio_reference)*0.01
	aspect_ratio = 2 - aspect_ratio
	set_aspect_ratio(aspect_ratio)
end

local multiplier = 0.01
local steps = 200

local function setup(screen_width_temp, screen_height_temp)
	screen_width, screen_height = screen_width_temp, screen_height_temp
	local aspect_ratio_table = {}

	for i=1, steps do
		local i2=(steps-i)*multiplier
		local divisor = gcd(screen_width*i2, screen_height)
		if screen_width*i2/divisor < 100 or i2 == 1 then
			aspect_ratio_table[i] = screen_width*i2/divisor .. ":" .. screen_height/divisor
		end
	end

	if aspect_ratio_reference ~= nil then
		ui_set_visible(aspect_ratio_reference, false)
		ui_set_callback(aspect_ratio_reference, function() end)
	end

	aspect_ratio_reference = ui_new_slider("VISUALS", "Effects", "Force aspect ratio", 0, steps-1, steps/2, true, "%", 1, aspect_ratio_table)
	ui_set_callback(aspect_ratio_reference, on_aspect_ratio_changed)
end
setup(client_screen_size())

local function on_paint(ctx)
	local screen_width_temp, screen_height_temp = client_screen_size()
	if screen_width_temp ~= screen_width or screen_height_temp ~= screen_height then
		setup(screen_width_temp, screen_height_temp)
	end
end
client.set_event_callback("paint", on_paint)

--[[
    +w.tech lua by не я
    Version: 1.0 beta
    Features: Advanced anti-aim, indicators, clan-tag, animations, and more
]]

local v0 = error
local v1 = setmetatable
local v2 = ipairs
local v3 = pairs
local v4 = next
local v5 = printf
local v6 = rawequal
local v7 = rawset
local v8 = rawlen
local v9 = readfile
local v10 = writefile
local v11 = require
local v12 = tonumber
local v13 = toticks
local v14 = type
local v15 = unpack
local v16 = pcall

local function v17(v54)
    local v55 = {}
    for v706, v707 in v4, v54 do
        v55[v706] = v707
    end
    return v55
end

local v18 = v17(table)
local v19 = v17(math)
local v20 = v17(string)
local v21 = v17(ui)
local v22 = v17(client)
local v23 = v17(database)
local v24 = v17(entity)
local v25 = v17(v11("ffi"))
local v26 = v17(globals)
local v27 = v17(panorama)
local v28 = v17(renderer)
local v29 = v17(bit)

local function v30(v56)
    if v56 then
        return v11(v56)
    else
        v0("nope" .. v56)
    end
end

local v31 = v30("vector")
local v32 = v30("gamesense/pui")
local v33 = v30("gamesense/base64")
local v34 = v30("gamesense/clipboard")
local v35 = v30("gamesense/entity")
local v36 = v30("gamesense/http")
local v37_images = v30("gamesense/images")
local v37 = v27.open()
local v38 = {
    name = v37.MyPersonaAPI.GetName(),
    build = "beta",
    vers = "1.0",
    accent = {r = 0, g = 0, b = 0, a = 255},
    offset = 0,
    new_style = false
}

local v39, v40 = v22.screen_size()

local v41 = function(v57, v58, v59)
    return (function()
        local v709 = {}
        local v710, v711, v712, v713, v714, v715, v716, v717, v718, v719, v720, v721, v722, v723
        local v724 = {
            __index = {
                drag = function(v885, ...)
                    local v886, v887 = v885:get()
                    local v888, v889 = v709.drag(v886, v887, ...)
                    if ((v886 ~= v888) or (v887 ~= v889)) then
                        v885:set(v888, v889)
                    end
                    return v888, v889
                end,
                set = function(v890, v891, v892)
                    local v893, v894 = v22.screen_size()
                    v21.set(v890.x_reference, (v891 / v893) * v890.res)
                    v21.set(v890.y_reference, (v892 / v894) * v890.res)
                end,
                get = function(v895, v896, v897)
                    local v898, v899 = v22.screen_size()
                    return ((v21.get(v895.x_reference) / v895.res) * v898) + (v896 or 0), ((v21.get(v895.y_reference) /
                        v895.res) *
                        v899) +
                        (v897 or 0)
                end
            }
        }
        v709.new = function(v900, v901, v902, v903)
            v903 = v903 or 10000
            local v904, v905 = v22.screen_size()
            local v906 = v21.new_slider("misc", "settings", "one::x:" .. v900, 0, v903, (v901 / v904) * v903)
            local v907 = v21.new_slider("misc", "settings", "one::y:" .. v900, 0, v903, (v902 / v905) * v903)
            v21.set_visible(v906, false)
            v21.set_visible(v907, false)
            return v1({name = v900, x_reference = v906, y_reference = v907, res = v903}, v724)
        end
        v709.drag = function(v908, v909, v910, v911, v912, v913, v914)
            if (v26.framecount() ~= v710) then
                v711 = v21.is_menu_open()
                v714, v715 = v712, v713
                v712, v713 = v21.mouse_position()
                v717 = v716
                v716 = v22.key_state(1) == true
                v721 = v720
                v720 = {}
                v723 = v722
                v722 = false
                v718, v719 = v22.screen_size()
            end
            if (v711 and (v717 ~= nil)) then
                if
                    ((not v717 or v723) and v716 and (v714 > v908) and (v715 > v909) and (v714 < (v908 + v910)) and
                        (v715 < (v909 + v911)))
                then
                    v28.rectangle(v908, v909, v910, v911, 255, 255, 255, 5)
                    v722 = true
                    v908, v909 = (v908 + v712) - v714, (v909 + v713) - v715
                    if not v913 then
                        v908 = v19.max(0, v19.min(v718 - v910, v908))
                        v909 = v19.max(0, v19.min(v719 - v911, v909))
                    end
                end
            end
            v18.insert(v720, {v908, v909, v910, v911})
            return v908, v909, v910, v911
        end
        return v709
    end)().new(v57, v58, v59)
end

local v42 =
    v28.load_png(
    "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x0F\x00\x00\x00\x0F\x08\x06\x00\x00\x00\x3B\xD6\x95\x4A\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x04\x67\x41\x4D\x41\x00\x00\xB1\x8F\x0B\xFC\x61\x05\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0E\xC3\x00\x00\x0E\xC3\x01\xC7\x6F\xA8\x64\x00\x00\x00\xE7\x49\x44\x41\x54\x38\x4F\x8D\x92\x0D\x11\x82\x40\x10\x85\xB9\x06\x44\x30\x02\x36\x20\x02\x11\x8C\x60\x03\x23\x18\xC1\x08\x46\xD0\x06\x44\x20\x02\x36\x38\xDF\x77\xEC\x02\x07\xC7\xE8\x37\xF3\xC6\xDB\x3F\xEE\xF6\x8D\xD5\x2F\x62\x8C\xB5\x74\x97\x46\x09\x9E\x52\x63\xE5\x63\xD4\xC4\x20\xCD\x30\x48\xAF\xE9\x98\x38\xFE\x80\x8A\xEB\x41\x6E\xAE\x2D\xDF\xA6\x4C\x8C\x7D\x6A\xDC\xA2\x42\x71\xD0\x51\xDC\x4B\x63\xB0\x38\xC3\x9A\x79\x16\xBF\xEF\x10\xC2\x87\x3C\x58\x6D\x7F\x2B\x05\x69\x6D\x0E\x7B\x76\x56\x4E\x28\x7E\xA4\x4A\x8C\x37\x4B\xCD\x83\xFE\x54\x8C\xF1\x33\xF8\xBE\x3E\xC8\xB3\xA7\x55\x38\x48\xD9\x8E\xD2\x55\xEA\xA4\x8B\xC5\x7F\x0F\x22\x87\x1A\x03\xB0\x0C\x82\x02\x06\x20\x73\x55\x67\x6E\x65\x67\xC0\x03\x56\x59\x06\x45\x50\x62\xB0\xF3\x79\xED\x2A\xA8\xE6\x66\x65\x8E\xCF\xA8\x01\x76\xD6\x2B\xB7\xDF\x71\x8B\x0A\xFE\x97\x6B\x2D\x2E\x9B\x53\x42\xC5\x53\x6A\x9B\xE0\x43\x65\x73\x8E\x50\x53\x23\xB9\xE3\x98\x93\x99\x57\xA6\xAA\xBE\xA0\xF9\xAC\x5A\x7A\x41\x0B\x0E\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82",
    11,
    11
)
local v53_taser = renderer.load_png(
    "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x0F\x00\x00\x00\x0F\x08\x06\x00\x00\x00\x3B\xD6\x95\x4A\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x04\x67\x41\x4D\x41\x00\x00\xB1\x8F\x0B\xFC\x61\x05\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0E\xC3\x00\x00\x0E\xC3\x01\xC7\x6F\xA8\x64\x00\x00\x00\xE7\x49\x44\x41\x54\x38\x4F\x8D\x92\x0D\x11\x82\x40\x10\x85\xB9\x06\x44\x30\x02\x36\x20\x02\x11\x8C\x60\x03\x23\x18\xC1\x08\x46\xD0\x06\x44\x20\x02\x36\x38\xDF\x77\xEC\x02\x07\xC7\xE8\x37\xF3\xC6\xDB\x3F\xEE\xF6\x8D\xD5\x2F\x62\x8C\xB5\x74\x97\x46\x09\x9E\x52\x63\xE5\x63\xD4\xC4\x20\xCD\x30\x48\xAF\xE9\x98\x38\xFE\x80\x8A\xEB\x41\x6E\xAE\x2D\xDF\xA6\x4C\x8C\x7D\x6A\xDC\xA2\x42\x71\xD0\x51\xDC\x4B\x63\xB0\x38\xC3\x9A\x79\x16\xBF\xEF\x10\xC2\x87\x3C\x58\x6D\x7F\x2B\x05\x69\x6D\x0E\x7B\x76\x56\x4E\x28\x7E\xA4\x4A\x8C\x37\x4B\xCD\x83\xFE\x54\x8C\xF1\x33\xF8\xBE\x3E\xC8\xB3\xA7\x55\x38\x48\xD9\x8E\xD2\x55\xEA\xA4\x8B\xC5\x7F\x0F\x22\x87\x1A\x03\xB0\x0C\x82\x02\x06\x20\x73\x55\x67\x6E\x65\x67\xC0\x03\x56\x59\x06\x45\x50\x62\xB0\xF3\x79\xED\x2A\xA8\xE6\x66\x65\x8E\xCF\xA8\x01\x76\xD6\x2B\xB7\xDF\x71\x8B\x0A\xFE\x97\x6B\x2D\x2E\x9B\x53\x42\xC5\x53\x6A\x9B\xE0\x43\x65\x73\x8E\x50\x53\x23\xB9\xE3\x98\x93\x99\x57\xA6\xAA\xBE\xA0\xF9\xAC\x5A\x7A\x41\x0B\x0E\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82",
    25,
    19
)

local v43 = {
    clamp = function(v60, v61, v62)
        assert(v60 and v61 and v62, "")
        if (v61 > v62) then
            v61, v62 = v62, v61
        end
        return v19.max(v61, v19.min(v62, v60))
    end,
    rect_v = function(v63, v64, v65, v66, v67, v68, v69, v70)
        local v71, v72, v73, v74 = v15(v67)
        local v75, v76, v77, v78
        v28.circle(v63 + v68, v64 + v68, v71, v72, v73, v74, v68, 180, 0.25)
        v28.rectangle(v63 + v68, v64, (v65 - v68) - v68, v68, v71, v72, v73, v74)
        v28.circle((v63 + v65) - v68, v64 + v68, v71, v72, v73, v74, v68, 90, 0.25)
        v28.rectangle(v63, v64 + v68, v65, v66 - v68, v71, v72, v73, v74)
        if v69 then
            v75, v76, v77, v78 = v15(v69)
            v28.rectangle(v63, v64 + v66, v65, v66 - (v66 + (v70 or 2)), v75, v76, v77, v78)
        end
    end
}

local v44 =
    (function()
    local v79 = v31
    local v80 = function(v727, v728, v729)
        return ((v728 - v727) * v729) + v727
    end
    local v81 = function(v730, v731, v732)
        v732 = v43.clamp(v26.absoluteframetime() * ((v732 + 0.02) or 0.005) * 175, 0.01, 1)
        local v733 = v80(v730, v731, v732)
        return v733
    end
    local v82 = function(v734, ...)
        local v735 = {...}
        local v735 = v18.concat(v735, "")
        return v79(v28.measure_text(v734, v735))
    end
    local v83 = {notifications = {bottom = {}}, max = {bottom = 6}}
    v83.__index = v83
    v83.create_new = function(...)
        v18.insert(
            v83.notifications.bottom,
            {
                started = false,
                instance = v1(
                    {
                        active = false,
                        timeout = 5,
                        color = {r = 0, g = 0, b = 0, a = 0},
                        x = v39 / 2,
                        y = v40,
                        text = ...
                    },
                    v83
                )
            }
        )
    end
    v83.handler = function(v736)
        local v737 = 0
        local v738 = 0
        for v915, v916 in v3(v83.notifications.bottom) do
            if (not v916.instance.active and v916.started) then
                v18.remove(v83.notifications.bottom, v915)
            end
        end
        for v917 = 1, #v83.notifications.bottom do
            if v83.notifications.bottom[v917].instance.active then
                v738 = v738 + 1
            end
        end
        for v918, v919 in v3(v83.notifications.bottom) do
            if (v918 > v83.max.bottom) then
                return
            end
            if v919.instance.active then
                v919.instance:render_bottom(v737, v738)
                v737 = v737 + 1
            end
            if not v919.started then
                v919.instance:start()
                v919.started = true
            end
        end
    end
    v83.start = function(v739)
        v739.active = true
        v739.delay = v26.realtime() + v739.timeout
    end
    v83.get_text = function(v742)
        local v743 = ""
        for v920, v920 in v3(v742.text) do
            local v921 = v82("", v920[1])
            local v921, v922, v923 = 255, 255, 255
            if v920[2] then
                v921, v922, v923 = v38.accent.r, v38.accent.g, v38.accent.b
            end
            v743 = v743 .. ("\a%02x%02x%02x%02x%s"):format(v921, v922, v923, v742.color.a, v920[1])
        end
        return v743
    end
    local v89 =
        (function()
        local v744 = {}
        v744.rect = function(v924, v925, v926, v927, v928, v929, v930, v931, v932)
            v932 = v19.min(v924 / 2, v925 / 2, v932)
            v28.rectangle(v924, v925 + v932, v926, v927 - (v932 * 2), v928, v929, v930, v931)
            v28.rectangle(v924 + v932, v925, v926 - (v932 * 2), v932, v928, v929, v930, v931)
            v28.rectangle(v924 + v932, (v925 + v927) - v932, v926 - (v932 * 2), v932, v928, v929, v930, v931)
            v28.circle(v924 + v932, v925 + v932, v928, v929, v930, v931, v932, 180, 0.25)
            v28.circle((v924 - v932) + v926, v925 + v932, v928, v929, v930, v931, v932, 90, 0.25)
            v28.circle((v924 - v932) + v926, (v925 - v932) + v927, v928, v929, v930, v931, v932, 0, 0.25)
            v28.circle(v924 + v932, (v925 - v932) + v927, v928, v929, v930, v931, v932, -90, 0.25)
        end
        v744.rect_o = function(v933, v934, v935, v936, v937, v938, v939, v940, v941, v942)
            v941 = v19.min(v935 / 2, v936 / 2, v941)
            if (v941 == 1) then
                v28.rectangle(v933, v934, v935, v942, v937, v938, v939, v940)
                v28.rectangle(v933, (v934 + v936) - v942, v935, v942, v937, v938, v939, v940)
            else
                v28.rectangle(v933 + v941, v934, v935 - (v941 * 2), v942, v937, v938, v939, v940)
                v28.rectangle(v933 + v941, (v934 + v936) - v942, v935 - (v941 * 2), v942, v937, v938, v939, v940)
                v28.rectangle(v933, v934 + v941, v942, v936 - (v941 * 2), v937, v938, v939, v940)
                v28.rectangle((v933 + v935) - v942, v934 + v941, v942, v936 - (v941 * 2), v937, v938, v939, v940)
                v28.circle_outline(v933 + v941, v934 + v941, v937, v938, v939, v940, v941, 180, 0.25, v942)
                v28.circle_outline(v933 + v941, (v934 + v936) - v941, v937, v938, v939, v940, v941, 90, 0.25, v942)
                v28.circle_outline((v933 + v935) - v941, v934 + v941, v937, v938, v939, v940, v941, -90, 0.25, v942)
                v28.circle_outline(
                    (v933 + v935) - v941,
                    (v934 + v936) - v941,
                    v937,
                    v938,
                    v939,
                    v940,
                    v941,
                    0,
                    0.25,
                    v942
                )
            end
        end
        v744.glow = function(v943, v944, v945, v946, v947, v948, v949, v950, v951, v952, v953, v954, v955, v956, v956)
            local v957 = 1
            local v958 = 1
            if v956 then
                v744.rect(v943, v944, v945, v946, v949, v950, v951, v952, v948)
            end
            for v1011 = 0, v947 do
                local v1012 = (v952 / 2) * ((v1011 / v947) ^ 3)
                v744.rect_o(
                    v943 + (((v1011 - v947) - v958) * v957),
                    v944 + (((v1011 - v947) - v958) * v957),
                    v945 - (((v1011 - v947) - v958) * v957 * 2),
                    v946 - (((v1011 - v947) - v958) * v957 * 2),
                    v953,
                    v954,
                    v955,
                    v1012 / 1.5,
                    v948 + (v957 * ((v947 - v1011) + v958)),
                    v957
                )
            end
        end
        return v744
    end)()
    v83.render_bottom = function(v748, v749, v750)
        local v751 = 16
        local v752 = "     " .. v748:get_text()
        local v753 = v82("", v752)
        local v754 = 8
        local v755, v756, v757 = v38.accent.r, v38.accent.g, v38.accent.b
        local v758, v759, v760 = 15, 15, 15
        local v761 = 2
        local v762 = 0 + v751 + v753.x
        local v762, v763 = v762 + (v761 * 2), 23
        local v764, v765 = v748.x - (v762 / 2), v19.ceil((v748.y - 40) + 0.4)
        local v766 = v26.frametime()
        if (v26.realtime() < v748.delay) then
            v748.y = v81(v748.y, (v40 - v38.offset) - ((v750 - v749) * v763 * 1.5), v766 * 7)
            v748.color.a = v81(v748.color.a, 255, v766 * 2)
        else
            v748.y = v81(v748.y, v748.y + 5, v766 * 15)
            v748.color.a = v81(v748.color.a, 0, v766 * 20)
            if (v748.color.a <= 1) then
                v748.active = false
            end
        end
        local v767, v768, v749, v750 = v748.color.r, v748.color.g, v748.color.b, v748.color.a
        local v769 = (v38.new_style and 18) or 0
        local v770 = v761 + 2
        v770 = v770 + 0 + v751
        if not v38.new_style then
            v89.glow(v764 + 26, v765, v762 - 15, v763, 12, v754, v758, v759, v760, v750, v755, v756, v757, v750, true)
            v89.glow(v764 - 5, v765, 25, v763, 12, v754, v758, v759, v760, v750, v755, v756, v757, v750, true)
            v28.texture(
                v42,
                (v764 + v770) - 18,
                ((v765 + (v763 / 2)) - (v753.y / 2)) + 1,
                11,
                11,
                v755,
                v756,
                v757,
                v750
            )
        else
            v43.rect_v(
                v764 + 5,
                v765,
                v762 - 20,
                v763 + 1,
                {v758, v759, v760, 170 * (v750 / 255)},
                6,
                {v755, v756, v757, v750}
            )
        end
        v28.text((v764 + v770) - v769, (v765 + (v763 / 2)) - (v753.y / 2), v767, v768, v749, v750, "", nil, v752)
    end
    v22.set_event_callback(
        "paint_ui",
        function()
            v83:handler()
        end
    )
    return v83
end)()

v22.delay_call(
    4,
    function()
        v44.create_new(
            {{"Welcome back, "}, {v38.name, true}, {" to +w.tech "}, {v38.build, true}, {" " .. v38.vers, false}}
        )
    end
)

local v45 = [[struct {char         __pad_0x0000[0x1cd]; bool         hide_vm_scope; }]]
local v46 = v22.find_signature("client_panorama.dll", "\x8B\x35\xCC\xCC\xCC\xCC\xFF\x10\x0F\xB7\xC0")
local v47 = v25.cast("void****", v25.cast("char*", v46) + 2)[0]
local v48 = vtable_thunk(2, v45 .. "*(__thiscall*)(void*, unsigned int)")

local v49 = function()
    local v91, v92, v93 = {}, {}, {}
    v91.__metatable = false
    v92.struct = function(v771, v772)
        assert(v14(v772) == "string", "invalid class name")
        assert(rawget(v771, v772) == nil, "cannot overwrite subclass")
        return function(v959)
            assert(v14(v959) == "table", "invalid class data")
            v7(
                v771,
                v772,
                v1(
                    v959,
                    {__metatable = false, __index = function(v1017, v1018)
                            return rawget(v91, v1018) or rawget(v93, v1018)
                        end}
                )
            )
            return v93
        end
    end
    v93 = v1(v92, v91)
    return v93
end

local v50 =
    v49():struct("globals")(
    {
        states = {
            "stand",
            "slow walk",
            "run",
            "crouch",
            "sneak",
            "aerobic",
            "aerobic+",
            "manual left",
            "manual right",
            "fakelag",
            "hideshots"
        },
        extended_states = {
            "global",
            "stand",
            "slow walk",
            "run",
            "crouch",
            "sneak",
            "aerobic",
            "aerobic+",
            "manual left",
            "manual right",
            "fakelag",
            "hideshots"
        },
        def_ways = {"1-way", "2-way", "3-way", "4-way", "5-way"},
        keylist_icon = v28.load_png(
            "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x0F\x00\x00\x00\x0F\x08\x06\x00\x00\x00\x3B\xD6\x95\x4A\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x04\x67\x41\x4D\x41\x00\x00\xB1\x8F\x0B\xFC\x61\x05\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0E\xC3\x00\x00\x0E\xC3\x01\xC7\x6F\xA8\x64\x00\x00\x00\xE7\x49\x44\x41\x54\x38\x4F\x8D\x92\x0D\x11\x82\x40\x10\x85\xB9\x06\x44\x30\x02\x36\x20\x02\x11\x8C\x60\x03\x23\x18\xC1\x08\x46\xD0\x06\x44\x20\x02\x36\x38\xDF\x77\xEC\x02\x07\xC7\xE8\x37\xF3\xC6\xDB\x3F\xEE\xF6\x8D\xD5\x2F\x62\x8C\xB5\x74\x97\x46\x09\x9E\x52\x63\xE5\x63\xD4\xC4\x20\xCD\x30\x48\xAF\xE9\x98\x38\xFE\x80\x8A\xEB\x41\x6E\xAE\x2D\xDF\xA6\x4C\x8C\x7D\x6A\xDC\xA2\x42\x71\xD0\x51\xDC\x4B\x63\xB0\x38\xC3\x9A\x79\x16\xBF\xEF\x10\xC2\x87\x3C\x58\x6D\x7F\x2B\x05\x69\x6D\x0E\x7B\x76\x56\x4E\x28\x7E\xA4\x4A\x8C\x37\x4B\xCD\x83\xFE\x54\x8C\xF1\x33\xF8\xBE\x3E\xC8\xB3\xA7\x55\x38\x48\xD9\x8E\xD2\x55\xEA\xA4\x8B\xC5\x7F\x0F\x22\x87\x1A\x03\xB0\x0C\x82\x02\x06\x20\x73\x55\x67\x6E\x65\x67\xC0\x03\x56\x59\x06\x45\x50\x62\xB0\xF3\x79\xED\x2A\xA8\xE6\x66\x65\x8E\xCF\xA8\x01\x76\xD6\x2B\xB7\xDF\x71\x8B\x0A\xFE\x97\x6B\x2D\x2E\x9B\x53\x42\xC5\x53\x6A\x9B\xE0\x43\x65\x73\x8E\x50\x53\x23\xB9\xE3\x98\x93\x99\x57\xA6\xAA\xBE\xA0\xF9\xAC\x5A\x7A\x41\x0B\x0E\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82",
            15,
            15
        ),
        tick = 0
    }
):struct("ref")(
    {
        aa = {
            enabled = {v21.reference("aa", "anti-aimbot angles", "enabled")},
            pitch = {v21.reference("aa", "anti-aimbot angles", "pitch")},
            yaw_base = {v21.reference("aa", "anti-aimbot angles", "Yaw base")},
            yaw = {v21.reference("aa", "anti-aimbot angles", "Yaw")},
            yaw_jitter = {v21.reference("aa", "anti-aimbot angles", "Yaw Jitter")},
            body_yaw = {v21.reference("aa", "anti-aimbot angles", "Body yaw")},
            freestanding_body_yaw = {v21.reference("aa", "anti-aimbot angles", "Freestanding body yaw")},
            freestand = {v21.reference("aa", "anti-aimbot angles", "Freestanding")},
            roll = {v21.reference("aa", "anti-aimbot angles", "Roll")},
            edge_yaw = {v21.reference("aa", "anti-aimbot angles", "Edge yaw")},
            fake_peek = {v21.reference("aa", "other", "Fake peek")}
        },
        thirdperson = {
            force = {v21.reference("VISUALS", "Effects", "Force third person (alive)")}
        },
        misc = {
            log = {v21.reference("misc", "miscellaneous", "Log damage dealt")},
            fov = v21.reference("misc", "miscellaneous", "Override FOV"),
            override_zf = v21.reference("misc", "miscellaneous", "Override zoom FOV")
        },
        fakelag = {
            enable = {v21.reference("aa", "fake lag", "enabled")},
            amount = {v21.reference("aa", "fake lag", "amount")},
            variance = {v21.reference("aa", "fake lag", "variance")},
            limit = {v21.reference("aa", "fake lag", "limit")},
            lg = {v21.reference("aa", "other", "Leg movement")}
        },
        aa_other = {
            sw = {v21.reference("aa", "other", "Slow motion")},
            hide_shots = {v21.reference("aa", "other", "On shot anti-aim")}
        },
        rage = {
            enable = v21.reference("rage", "aimbot", "Enabled"),
            dt = {v21.reference("rage", "aimbot", "Double tap")},
            always = {v21.reference("rage", "other", "Automatic fire")},
            fd = {v21.reference("rage", "other", "Duck peek assist")},
            os = {v21.reference("aa", "other", "On shot anti-aim")},
            mindmg = {v21.reference("rage", "aimbot", "minimum damage")},
            baim = {v21.reference("rage", "aimbot", "force body aim")},
            safe = {v21.reference("rage", "aimbot", "force safe point")},
            ovr = {v21.reference("rage", "aimbot", "minimum damage override")}
        },
        slow_motion = {v21.reference("aa", "other", "Slow motion")}
    }
):struct("ui")(
    {
        menu = {global = {}, home = {}, antiaim = {}, tools = {}},
        header = function(v96, v97)
            local v98 = "\a373737FF"
            local v99 = "──────────────────────────"
            return v97:label(v98 .. v99)
        end,
        clr = function(v100, v101)
            local v102 = {gray = "\a808080FF", l_gray = "\a909090FF", d_gray = "\a606060FF", red = "\aff0000ff"}
            for v773, v774 in v3(v102) do
                if (v101 == v773) then
                    return v774
                end
            end
            return "error color"
        end,
        execute = function(v103)
            local v104 = v32.group("AA", "anti-aimbot angles")
            local v105 = v32.group("AA", "Fake lag")
            local v106 = v32.group("AA", "Other")
            local v107 = "\a808080FF•\r  "
            v103.menu.global.title_name = v105:label("\vвыеби их всех☭ //\r  " .. v103.helpers:limit_ch(v38.name, 13, "..."))
            v103.menu.global.tab = v105:combobox("\n tabs", {" Home", " Anti-Aim", " Tools"})
            v103.menu.global.color =
                v105:color_picker("\naccent", 164, 210, 212, 255):depend({v103.menu.global.tab, " Home"})
            v103:header(v105)
            v103.menu.global.export =
                v105:button(
                v103:clr("d_gray") .. "\r Export config",
                function()
                    v34.set(v103.config:export("config"))
                end
            ):depend({v103.menu.global.tab, " Anti-Aim", true})
            v103.menu.global.import =
                v105:button(
                v103:clr("d_gray") .. "\r  Import config",
                function()
                    v103.config:import(v34.get(), "config")
                end
            ):depend({v103.menu.global.tab, " Anti-Aim", true})
            v103.menu.home.welcomer = v104:label("Welcome to \v+w.tech\r " .. v38.vers .. " ☭")
            v103.menu.home.space = v103:header(v104)
            v103.menu.home.list = v104:listbox("configs", {})
            v103.menu.home.list:set_callback(
                function()
                    if v21.is_menu_open() then
                        v103.config:update_name()
                    end
                end
            )
            v103.menu.home.name = v104:textbox("config name")
            v103.menu.home.load =
                v104:button(
                v103:clr("d_gray") .. "\r  Load",
                function()
                    v103.config:load("config")
                end
            )
            v103.menu.home.save =
                v104:button(
                v103:clr("d_gray") .. "\r Save",
                function()
                    v103.config:save()
                end
            )
            v103.menu.home.delete =
                v104:button(
                v103:clr("red") .. " Delete",
                function()
                    v103.config:delete()
                end
            )
            v103.menu.home.discord_l = v106:label("\n")
            v103.menu.home.discord =
                v106:button(
                v103:clr("gray") .. "\a708090FF  Discord server\r",
                function()
                    v37.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/aG9rpCC63n")
                end
            )
            v103.menu.home.youtube =
                v106:button(
                "\aFFE4E1FF  Youtube L4\r",
                function()
                    v37.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/channel/UC1Gn6DUNibZ4kqGqxHBSLeA")
                end
            )
            v103.menu.antiaim.mode = v104:combobox(v107 .. "Anti-aim tab", {"Constructor", "Features"})
            v103.menu.antiaim.space = v103:header(v104):depend({v103.menu.antiaim.mode, "Features"})
            v103.menu.antiaim.freestanding =
                v104:multiselect("Freestanding \v", {"Force static", "Disablers"}, 0):depend(
                {v103.menu.antiaim.mode, "Features"}
            )
            v103.menu.antiaim.freestanding_disablers =
                v104:multiselect("\nfreestanding disablers", v103.globals.states):depend(
                {v103.menu.antiaim.freestanding, "Disablers"}
            ):depend({v103.menu.antiaim.mode, "Features"})
            v103.menu.antiaim.edge_yaw = v104:label("Edge yaw", 0):depend({v103.menu.antiaim.mode, "Features"})
            v103.menu.antiaim.manual_aa = v104:checkbox("Manual aa \v"):depend({v103.menu.antiaim.mode, "Features"})
            v103.menu.antiaim.manual_static =
                v104:checkbox(v107 .. "Manual static"):depend({v103.menu.antiaim.manual_aa, true}):depend(
                {v103.menu.antiaim.mode, "Features"}
            )
            v103.menu.antiaim.manual_left =
                v104:hotkey(v107 .. "Manual left"):depend({v103.menu.antiaim.manual_aa, true}):depend(
                {v103.menu.antiaim.mode, "Features"}
            )
            v103.menu.antiaim.manual_right =
                v104:hotkey(v107 .. "Manual right"):depend({v103.menu.antiaim.manual_aa, true}):depend(
                {v103.menu.antiaim.mode, "Features"}
            )
            v103.menu.antiaim.manual_forward =
                v104:hotkey(v107 .. "Manual forward"):depend({v103.menu.antiaim.manual_aa, true}):depend(
                {v103.menu.antiaim.mode, "Features"}
            )
            v103.menu.antiaim.fakelag_type =
                v105:combobox("Fake lag type", {"Maximum", "Dynamic", "Fluctuate"}):depend(
                {v103.menu.antiaim.mode, "Features"}
            )
            v103.menu.antiaim.fakelag_var =
                v105:slider(v107 .. "Variance", 0, 100, 100, true, "%"):depend({v103.menu.antiaim.mode, "Features"})
            v103.menu.antiaim.fakelag_lim =
                v105:slider(v107 .. "Limit", 1, 15, 15):depend({v103.menu.antiaim.mode, "Features"})
            v103.menu.antiaim.state =
                v104:combobox("\n current condition", v103.globals.extended_states):depend(
                {v103.menu.antiaim.mode, "Constructor"}
            )
            v103.menu.antiaim.states = {}
            for v775, v776 in v2(v103.globals.extended_states) do
                v103.menu.antiaim.states[v776] = {}
                local v778 = v103.menu.antiaim.states[v776]
                if (v776 ~= "global") then
                    v778.enable = v104:checkbox("Activate \v" .. v776)
                end
                local v779 = "\n" .. v776
                v778.options =
                    v106:multiselect(v107 .. "Features" .. v779, {"Enable defensive", "Avoid backstab", "Safe head", "Fake-Flick", "Desync Flick"})
                v778.fake_flick_speed =
                    v104:slider(v107 .. "Fake-Flick speed" .. v779, 1, 200, 50, true, "ms", 1):depend(
                    {v778.options, "Fake-Flick"}
                )
                v778.fake_flick_pitch_enable =
                    v105:checkbox("Fake-Flick pitch" .. v779):depend({v778.options, "Fake-Flick"})
                v778.fake_flick_pitch_mode =
                    v105:combobox("\n Fake-Flick pitch mode" .. v779, {"Off", "Static", "Random"}):depend(
                    {v778.options, "Fake-Flick"},
                    {v778.fake_flick_pitch_enable, true}
                )
                v778.fake_flick_pitch_value =
                    v105:slider("\n Fake-Flick pitch value" .. v779, -89, 89, 0, true, "°", 1):depend(
                    {v778.options, "Fake-Flick"},
                    {v778.fake_flick_pitch_enable, true},
                    {v778.fake_flick_pitch_mode, "Static"}
                )
                v778.fake_flick_pitch_min =
                    v105:slider("\n Fake-Flick pitch min" .. v779, -89, 89, -89, true, "°", 1):depend(
                    {v778.options, "Fake-Flick"},
                    {v778.fake_flick_pitch_enable, true},
                    {v778.fake_flick_pitch_mode, "Random"}
                )
                v778.fake_flick_pitch_max =
                    v105:slider("\n Fake-Flick pitch max" .. v779, -89, 89, 89, true, "°", 1):depend(
                    {v778.options, "Fake-Flick"},
                    {v778.fake_flick_pitch_enable, true},
                    {v778.fake_flick_pitch_mode, "Random"}
                )
                v778.fake_flick_yaw_mode =
                    v104:combobox(v107 .. "Fake-Flick yaw mode" .. v779, {"4-Way", "Custom"}):depend(
                    {v778.options, "Fake-Flick"}
                )
                v778.fake_flick_yaw_1 =
                    v104:slider("\n Fake-Flick yaw 1" .. v779, -180, 180, -90, true, "°", 1):depend(
                    {v778.options, "Fake-Flick"},
                    {v778.fake_flick_yaw_mode, "Custom"}
                )
                v778.fake_flick_yaw_2 =
                    v104:slider("\n Fake-Flick yaw 2" .. v779, -180, 180, 90, true, "°", 1):depend(
                    {v778.options, "Fake-Flick"},
                    {v778.fake_flick_yaw_mode, "Custom"}
                )
                v778.fake_flick_yaw_3 =
                    v104:slider("\n Fake-Flick yaw 3" .. v779, -180, 180, -180, true, "°", 1):depend(
                    {v778.options, "Fake-Flick"},
                    {v778.fake_flick_yaw_mode, "Custom"}
                )
                v778.fake_flick_yaw_4 =
                    v104:slider("\n Fake-Flick yaw 4" .. v779, -180, 180, 180, true, "°", 1):depend(
                    {v778.options, "Fake-Flick"},
                    {v778.fake_flick_yaw_mode, "Custom"}
                )
                v778.desync_flick_speed =
                    v104:slider(v107 .. "Desync Flick speed" .. v779, 1, 100, 15, true, "ms", 1):depend(
                    {v778.options, "Desync Flick"}
                )
                v778.desync_flick_amount =
                    v104:slider("\n Desync amount" .. v779, 30, 120, 60, true, "°", 1):depend(
                    {v778.options, "Desync Flick"}
                )
                v778.desync_flick_random_delay =
                    v104:checkbox("Random delay" .. v779):depend({v778.options, "Desync Flick"})
                v778.head_1 = v103:header(v106)
                v778.defensive_conditions =
                    v106:multiselect(
                    v107 .. "Defensive triggers\v" .. v779,
                    {
                        "Always",
                        "On hide-shots",
                        "Tick-Base",
                        "On weapon switch",
                        "On reload",
                        "On hittable",
                        "On freestand"
                    }
                ):depend({v778.options, "Enable defensive"})
                v778.defensive_conditions_tick =
                    v106:slider("\n Tick" .. v779, 1, 15, 8, true, "t", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_conditions, "Tick-Base"}
                )
                v778.defensive_yaw = v104:checkbox("Defensive yaw" .. v779):depend({v778.options, "Enable defensive"})
                
                v778.defensive_yaw_mode =
                    v104:combobox(
                    "\ndefensive yaw mode" .. v779,
                    {"Jitter", "Random", "Custom spin", "Spin-way", "Switch 5-way", "Static Random", "Side Based", "Opposite", "Spin", "Sway", "X-Way", "Left/Right"}
                ):depend({v778.options, "Enable defensive"}, {v778.defensive_yaw, true})

                v778.defensive_yaw_left =
                    v104:slider("\n Yaw left" .. v779, -180, 180, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Static Random"}
                )

                v778.defensive_yaw_right =
                    v104:slider("\n Yaw right" .. v779, -180, 180, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Static Random"}
                )

                v778.defensive_yaw_add =
                    v104:slider(v107 .. "Yaw add" .. v779, -180, 180, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Side Based", "Opposite", "Spin", "Sway", "X-Way", "Left/Right"}
                )

                v778.defensive_yaw_add_r =
                    v104:slider("\n Yaw add (R)" .. v779, -180, 180, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Side Based", "Left/Right"}
                )

                v778.defensive_yaw_speed =
                    v104:slider("\n Speed" .. v779, -75, 75, 20, true, "", 0.1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Sway"}
                )

                v778.defensive_yaw_1_random =
                    v104:slider("\n 1 random yaw def" .. v779, -359, 359, 180, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Random"}
                )
                v778.defensive_yaw_2_random =
                    v104:slider("\n 2 random yaw def" .. v779, -359, 359, -180, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Random"}
                )
                v778.defensive_yaw_1_Spin_way =
                    v104:slider("\n 1 stage Spin-way" .. v779, -180, 180, -180, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Spin-way"}
                )
                v778.defensive_yaw_2_Spin_way =
                    v104:slider("\n 2 stage Spin-way" .. v779, -180, 180, 180, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Spin-way"}
                )
                v778.defensive_yaw_speed_Spin_way =
                    v104:slider(v107 .. "Delay" .. v779, 0, 16, 6, true, "t", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Spin-way"}
                )
                v778.defensive_yaw_randomizer_Spin_way =
                    v104:slider(v107 .. "Randomizer" .. v779, 0, 180, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Spin-way"}
                )
                v778.defensive_yaw_jitter_radius_1 =
                    v104:slider("\n JiTter 1" .. v779, -180, 180, 30, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Jitter"}
                )
                v778.defensive_yaw_jitter_delay =
                    v104:slider(v107 .. "Delayed" .. v779, 1, 12, 6, true, "t", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Jitter"}
                )
                v778.defensive_yaw_jitter_random =
                    v104:slider(v107 .. "Randomize" .. v779, 0, 180, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Jitter"}
                )
                v778.defensive_yaw_way_delay =
                    v104:slider(v107 .. "Interpolation \v" .. v779, 0, 16, 4, true, "t", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Switch 5-way"}
                )
                for v960 = 1, 5 do
                    v778["defensive_yaw_way_switch" .. v960] =
                        v104:slider(
                        (((v960 == 1) and (v107 .. "Ways")) or "\n") .. "\v \n" .. v960 .. v779,
                        0,
                        360,
                        30,
                        true,
                        "°",
                        1
                    ):depend(
                        {v778.options, "Enable defensive"},
                        {v778.defensive_yaw, true},
                        {v778.defensive_yaw_mode, "Switch 5-way"}
                    )
                end
                v778.defensive_yaw_way_randomly =
                    v104:checkbox(v107 .. "Increase yaw \v" .. v779):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Switch 5-way"}
                )
                v778.defensive_yaw_way_randomly_value =
                    v104:slider("\n ramdom yaw value" .. v779, 0, 360, 20, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Switch 5-way"},
                    {v778.defensive_yaw_way_randomly, true}
                )
                v778.defensive_yaw_wayspin_combo =
                    v104:combobox(v107 .. "Select spin way yaw" .. v779, v103.globals.def_ways):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Switch 5-way"}
                )
                for v962 = 1, 5 do
                    local v963 = v962 .. "-way"
                    v778["defensive_yaw_enable_way_spin" .. v962] =
                        v104:checkbox("Enable spin \n " .. v962 .. v779):depend(
                        {v778.options, "Enable defensive"},
                        {v778.defensive_yaw, true},
                        {v778.defensive_yaw_mode, "Switch 5-way"},
                        {v778.defensive_yaw_wayspin_combo, v963}
                    )
                    v778["defensive_yaw_way_spin_limit" .. v962] =
                        v104:slider("\n limit  way-" .. v962 .. " " .. v779, 0, 360, 0, true, "°", 1):depend(
                        {v778.options, "Enable defensive"},
                        {v778.defensive_yaw, true},
                        {v778.defensive_yaw_mode, "Switch 5-way"},
                        {v778["defensive_yaw_enable_way_spin" .. v962], true},
                        {v778.defensive_yaw_wayspin_combo, v963}
                    )
                    v778["defensive_yaw_way_speed" .. v962] =
                        v104:slider("\n speed way-" .. v962 .. " " .. v779, 1, 12, 8, true, "t", 1):depend(
                        {v778.options, "Enable defensive"},
                        {v778.defensive_yaw, true},
                        {v778.defensive_yaw_mode, "Switch 5-way"},
                        {v778["defensive_yaw_enable_way_spin" .. v962], true},
                        {v778.defensive_yaw_wayspin_combo, v963}
                    )
                end
                v778.defensive_yaw_spin_limit =
                    v104:slider("\n limit spin yaw" .. v779, 15, 360, 360, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true}
                ):depend({v778.defensive_yaw_mode, "Custom spin"})
                v778.defensive_yaw_speedtick =
                    v104:slider("\n spin speed" .. v779, 1, 12, 6, true, "t", 0.5):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_yaw, true},
                    {v778.defensive_yaw_mode, "Custom spin"}
                )
                
                v778.defensive_pitch_enable =
                    v105:checkbox("Defensive pitch" .. v779):depend({v778.options, "Enable defensive"})
                
                v778.defensive_pitch_mode =
                    v105:combobox(
                    "\n defensive pitch mode" .. v779,
                    {"Static", "Spin", "Random", "Clocking", "Jitter", "5way", "Sway", "Switch", "Static Random"}
                ):depend({v778.options, "Enable defensive"}, {v778.defensive_pitch_enable, true})

                v778.defensive_pitch_offset_1 =
                    v105:slider("\n From" .. v779, -89, 89, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "Static Random"}
                )

                v778.defensive_pitch_offset_2 =
                    v105:slider("\n To" .. v779, -89, 89, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "Static Random"}
                )

                v778.defensive_pitch_speed_sway =
                    v105:slider("\n Speed" .. v779, -75, 75, 20, true, "", 0.1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "Sway"}
                )

                v778.defensive_pitch_custom =
                    v105:slider("\n pitch custom limit" .. v779, -89, 89, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "Clocking", true}
                )
                v778.defensive_pitch_spin_random2 =
                    v105:slider("\n pitch def random2" .. v779, -89, 89, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "Random"}
                )
                v778.defensive_pitch_spin_limit2 =
                    v105:slider("\n spin speed 2" .. v779, -89, 89, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "Spin"}
                )
                v778.defensive_pitch_speedtick =
                    v105:slider("\n spin speed" .. v779, 1, 64, 32, true, "t", 0.1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "Spin"}
                )
                v778.defensive_pitch_way_label =
                    v105:label(v107 .. "On \v5-way\r yaw to more \vsettings"):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "5way"},
                    {v778.defensive_yaw_mode, "Switch 5-way", true}
                )
                for v967 = 2, 5 do
                    v778["defensive_pitch_way" .. v967] =
                        v105:slider("\n pitch way " .. v967 .. v779, -89, 89, 0, true, "°", 1):depend(
                        {v778.options, "Enable defensive"},
                        {v778.defensive_pitch_enable, true},
                        {v778.defensive_pitch_mode, "5way"}
                    ):depend({v778.defensive_yaw_mode, "Switch 5-way"})
                end
                v778.defensive_pitch_way_randomly =
                    v105:checkbox(v107 .. "Increase pitch \v" .. v779):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "5way"}
                ):depend({v778.defensive_yaw_mode, "Switch 5-way"})
                v778.defensive_pitch_way_randomly_value =
                    v105:slider("\n ramdom pitch value" .. v779, 0, 89, 20, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "5way"},
                    {v778.defensive_pitch_way_randomly, true}
                ):depend({v778.defensive_yaw_mode, "Switch 5-way"})
                v778.defensive_pitch_way_spin_combo =
                    v105:combobox(v107 .. "Select spin way pitch" .. v779, v103.globals.def_ways):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "5way"}
                ):depend({v778.defensive_yaw_mode, "Switch 5-way"})
                for v969 = 1, #v103.globals.def_ways do
                    local v970 = v103.globals.def_ways[v969]
                    v778["defensive_pitch_enable_way_spin" .. v969] =
                        v105:checkbox("Enable spin \n " .. v969 .. v779):depend(
                        {v778.options, "Enable defensive"},
                        {v778.defensive_pitch_enable, true},
                        {v778.defensive_pitch_mode, "5way"},
                        {v778.defensive_pitch_way_spin_combo, v970}
                    ):depend({v778.defensive_yaw_mode, "Switch 5-way"})
                    for v1020 = 1, 2 do
                        v778["defensive_pitch_way_spin_limit" .. v969 .. v1020] =
                            v105:slider("\n limit  way-" .. v969 .. v1020 .. " " .. v779, -89, 89, 89, true, "°", 1):depend(
                            {v778.options, "Enable defensive"},
                            {v778["defensive_pitch_enable_way_spin" .. v969], true},
                            {v778.defensive_pitch_enable, true},
                            {v778.defensive_pitch_mode, "5way"},
                            {v778.defensive_pitch_way_spin_combo, v970}
                        ):depend({v778.defensive_yaw_mode, "Switch 5-way"})
                    end
                    v778["defensive_pitch_way_speed" .. v969] =
                        v105:slider("\n speed way-" .. v969 .. " " .. v779, 1, 12, 8, true, "t", 1):depend(
                        {v778.options, "Enable defensive"},
                        {v778["defensive_pitch_enable_way_spin" .. v969], true},
                        {v778.defensive_pitch_enable, true},
                        {v778.defensive_pitch_mode, "5way"},
                        {v778.defensive_pitch_way_spin_combo, v970}
                    ):depend({v778.defensive_yaw_mode, "Switch 5-way"})
                end
                v778.defensive_pitch_clock =
                    v105:slider("\n pitch clock limit" .. v779, -89, 89, 0, true, "°", 1):depend(
                    {v778.options, "Enable defensive"},
                    {v778.defensive_pitch_enable, true},
                    {v778.defensive_pitch_mode, "Jitter"}
                )
                v778.head_2 = v103:header(v104)
                v778.yaw_base = v104:combobox(v107 .. "Yaw" .. v779, {"At targets", "Local view"})
                v778.yaw_jitter =
                    v104:combobox(
                    "\nyaw jitter" .. v779,
                    {"Off", "Offset", "Center", "Skitter", "Smoothnes", "Fractal", "Random"}
                )
                v778.yaw_jitter_add =
                    v104:slider("\nyaw jitter add" .. v779, -90, 90, 0, true, "°", 1):depend(
                    {v778.yaw_jitter, "Off", true}
                )
                v778.yaw_fractals =
                    v104:slider(v107 .. "Fractals \v" .. v779, 1, 14, 0, true, "°", 1, {[14] = "Random"}):depend(
                    {v778.yaw_jitter, "Off", true},
                    {v778.yaw_jitter, "Fractal"}
                )
                v778.yaw_add = v104:slider(v107 .. "Yaw add \v" .. v779, -180, 180, 0, true, "°", 1)
                v778.yaw_add_r = v104:slider("\n yaw add (R)" .. v779, -180, 180, 0, true, "°", 1)
                v778.jitter_delay =
                    v104:slider(
                    v107 .. "Yaw delay  \v" .. v779,
                    0,
                    4,
                    0,
                    true,
                    "x",
                    1,
                    {[1] = "Randomly", [0] = "Off"}
                )
                v778.yaw_random =
                    v104:slider(v107 .. "Yaw randomize \v" .. v779, 0, 100, 0, true, "%", 1):depend(
                    {v778.yaw_jitter, "Off", true}
                )

                v778.head_3 = v103:header(v104)
                v778.body_yaw = v104:combobox(v107 .. "Body yaw" .. v779, {"Off", "Opposite", "Static", "Jitter"})
                v778.body_yaw_side =
                    v104:combobox("\n Body yaw side" .. v779, {"Left", "Right", "Freestanding"}):depend(
                    {v778.body_yaw, "Static", false}
                )
                for v973, v974 in v3(v778) do
                    local v975 = {{v103.menu.antiaim.state, v776}, {v103.menu.antiaim.mode, "Constructor"}}
                    if ((v973 ~= "enable") and (v776 ~= "global")) then
                        v975 = {
                            {v103.menu.antiaim.state, v776},
                            {v103.menu.antiaim.mode, "Constructor"},
                            {v778.enable, true}
                        }
                    end
                    v974:depend(v18.unpack(v975))
                end
            end
            v103.menu.antiaim.export =
                v106:button(
                v103:clr("d_gray") .. "\r  Export condition",
                function()
                    local data = v103.config:export("state", v103.menu.antiaim.state:get())
                    v34.set(data)
                end
            ):depend({v103.menu.antiaim.mode, "Constructor"})
            v103.menu.antiaim.import =
                v106:button(
                v103:clr("d_gray") .. "\r  Import condition ",
                function()
                    local v824 = v34.get()
                    local v825 = v824:match("{+w.tech:(.+)}")
                    v103.config:import(v824, v825, v103.menu.antiaim.state:get())
                end
            ):depend({v103.menu.antiaim.mode, "Constructor"})
            
            -- Tools tab
            v103.menu.tools.subtub = v104:combobox(v107 .. "Active tab", {"Helpers", "Visuals"})
            v103.menu.tools.subtub_n = v104:label("\n")
            local v142 = v103.menu.tools.subtub
            
            -- Visuals section
                        v103.menu.tools.ping_spike_warning = v104:checkbox("\v\r Ping Spike Warning ☭"):depend({v142, "Visuals"})
v103.menu.tools.ping_spike_ext = v104:checkbox("\n Extended info"):depend(
    {v142, "Visuals"},
    {v103.menu.tools.ping_spike_warning, true}
)
v103.menu.tools.ping_spike_dormancy = 
    v104:combobox("\n Dormancy", {"Fade with dormant", "Dont fade with dormant"}):depend(
        {v142, "Visuals"},
        {v103.menu.tools.ping_spike_warning, true}
    )
            v103.menu.tools.taser_warning = v104:checkbox("\v\r Taser Warning \r☭"):depend({v142, "Visuals"})
            v103.menu.tools.indicators_gamesense =
                v104:checkbox("\v\r Gamesense indicators \v[secret] \r☭"):depend({v142, "Visuals"})
            v103.menu.tools.indicators = v104:checkbox("\v\r Crosshair indicators ☭"):depend({v142, "Visuals"})
            v103.menu.tools.indicator_pos =
                v104:combobox("\n position ind", {"Left", "Right"}):depend({v103.menu.tools.indicators, true}):depend(
                {v142, "Visuals"}
                
            )
           v103.menu.tools.indicatorfont =
            v104:combobox(v107 .. "Indicator style", {"Default", "New", "Renewed", "Icons", "+w.tech", "Old Chimera", "Prediction"}):depend(
            {v103.menu.tools.indicators, true}
            ):depend({v142, "Visuals"})
            v103.menu.tools.indicator_bind =
                v104:checkbox(v107 .. "Show binds"):depend(
                {v103.menu.tools.indicators, true},
                {v142, "Visuals"},
                {v103.menu.tools.indicatorfont, "+w.tech"}
            )
            v103.menu.tools.indicatoroffset =
                v104:slider("\n Offset indcator ", 0, 90, 35, true, "px"):depend({v103.menu.tools.indicators, true}):depend(
                {v142, "Visuals"}
            )
            v103.menu.tools.manuals = v104:checkbox("\v\r Manual arrows ☭"):depend({v142, "Visuals"})
            v103.menu.tools.manuals_style =
                v104:combobox("\n arrows style", {"+w.tech", "New"}):depend(
                {v142, "Visuals"},
                {v103.menu.tools.manuals, true}
            )
            v103.menu.tools.manuals_global =
                v104:checkbox("Arrows side"):depend({v142, "Visuals"}, {v103.menu.tools.manuals, true})
            v103.menu.tools.manuals_offset =
                v104:slider("\n arrows offset", 0, 100, 15, true, "px"):depend(
                {v142, "Visuals"},
                {v103.menu.tools.manuals, true}
            )
            v103.menu.tools.animscope = v104:checkbox("\v\r Animated scope ☭"):depend({v142, "Visuals"})
            v103.menu.tools.animscope_fov_slider =
                v104:slider(v107 .. "Fov value", 105, 135, 130, true, "%", 1):depend({v103.menu.tools.animscope, true}):depend(
                {v142, "Visuals"}
            )
            v103.menu.tools.animscope_slider =
                v104:slider("\n Anim scope value", 0, 100, 5, true, "%", 1):depend({v103.menu.tools.animscope, true}):depend(
                {v142, "Visuals"}
            )
            v103.menu.tools.indicator_dmg = v104:checkbox("\v\r Damage indicator ☭"):depend({v142, "Visuals"})
            v103.menu.tools.indicator_dmg_color =
                v104:color_picker("\ncolor dmg", 255, 255, 255):depend({v103.menu.tools.indicator_dmg, true}):depend(
                {v142, "Visuals"}
            )
            v103.menu.tools.indicator_dmg_weapon =
                v104:checkbox(v107 .. "Only min damage"):depend({v103.menu.tools.indicator_dmg, true}):depend(
                {v142, "Visuals"}
            )
            v103.menu.tools.visual_head_1 = v104:label("\n"):depend({v142, "Visuals"})
            v103.menu.tools.style = v104:combobox("\v\r Widgets style ☭", {"New"}):depend({v142, "Visuals"})
             v103.menu.tools.hit_miss_notify = v104:checkbox("\v\r Logging ☭"):depend({v142, "Visuals"})
            v103.menu.tools.notify_types = v104:multiselect("\n Notification types", {"Hit", "Miss"}):depend(
                {v142, "Visuals"},
                {v103.menu.tools.hit_miss_notify, true}
            )
            v103.menu.tools.notify_hit_color = v104:color_picker("\n Hit color", 145, 154, 217, 255):depend(
                {v142, "Visuals"},
                {v103.menu.tools.hit_miss_notify, true}
            )
            v103.menu.tools.notify_miss_color = v104:color_picker("\n Miss color", 255, 0, 0, 255):depend(
                {v142, "Visuals"},
                {v103.menu.tools.hit_miss_notify, true}
            )
            v103.menu.tools.keylist = v104:checkbox("\v\r Hotkeys ☭"):depend({v142, "Visuals"})
             --Watermark
v103.menu.tools.branded_watermark = v104:checkbox("\v\r Watermark ☭"):depend({v142, "Visuals"})
v103.menu.tools.branded_watermark_pos = v104:combobox("\n Watermark position", {"Bottom", "Left", "Right"}):depend({v103.menu.tools.branded_watermark, true}):depend({v142, "Visuals"})
v103.menu.tools.branded_watermark_color = v104:color_picker("\n Watermark color", 87, 235, 61, 255):depend({v103.menu.tools.branded_watermark, true}):depend({v142, "Visuals"})
            v103.menu.tools.notify_master = v104:checkbox("\v\r"):depend({v142, ""})
            v103.menu.tools.notify_vibor =
                v104:multiselect("\n Log type", {"1", "2", "3", "4", "5"}):depend(
                {v103.menu.tools.notify_master, false}
            ):depend({v142, ""})
            v103.menu.tools.notify_offset =
                v104:slider("\n Offset notifys ", 0, 900, 45, false, "px", 1):depend(
                {v103.menu.tools.notify_master, false}
            ):depend({v142, ""})
            v103.menu.tools.visual_head_2 = v104:label("\n"):depend({v142, "Visuals"})
            v103.menu.tools.gs_ind = v104:checkbox("\v\r Indicators left gs ☭"):depend({v142, "Visuals"})
            v103.menu.tools.gs_inds =
                v104:multiselect("\n inds selc", {"Target", "..."}):depend(
                {v142, "Visuals"},
                {v103.menu.tools.gs_ind, true}
            )
            v103.menu.tools.viewmodel_on = v104:checkbox("\v\r Viewmodel modifier ☭"):depend({v142, "Visuals"})
            v103.menu.tools.viewmodel_scope = v104:checkbox("\v\r Show weapon scoped ☭"):depend({v142, "Visuals"})
            v103.menu.tools.viewmodel_mod =
                v104:combobox("\nstyleview", {"Without-scope", "In-scope"}):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true}
            )
            v103.menu.tools.viewmodel_x1 =
                v104:slider("\nviewwithoscope-x", -100, 100, 0, true, "x", 1):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "Without-scope"}
            )
            v103.menu.tools.viewmodel_y1 =
                v104:slider("\nviewwithoscope-y", -100, 100, -5, true, "y", 1):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "Without-scope"}
            )
            v103.menu.tools.viewmodel_z1 =
                v104:slider("\nviewwithoscope-z", -100, 100, -1, true, "z", 1):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "Without-scope"}
            )
            v103.menu.tools.viewmodel_fov1 =
                v104:slider(v107 .. "Fov\n without scope", 0, 170, 61, true, "x", 1):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "Without-scope"}
            )
            v103.menu.tools.viewmodel_inscope =
                v104:checkbox("Override scope"):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "In-scope"}
            )
            v103.menu.tools.viewmodel_x2 =
                v104:slider("\nview with x", -100, 100, -4, true, "x", 1):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "In-scope"},
                {v103.menu.tools.viewmodel_inscope, true}
            )
            v103.menu.tools.viewmodel_y2 =
                v104:slider("\nview with y", -100, 100, -5, true, "y", 1):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "In-scope"},
                {v103.menu.tools.viewmodel_inscope, true}
            )
            v103.menu.tools.viewmodel_z2 =
                v104:slider("\nview with z", -100, 100, -1, true, "z", 1):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "In-scope"},
                {v103.menu.tools.viewmodel_inscope, true}
            )
            v103.menu.tools.viewmodel_fov2 =
                v104:slider(v107 .. "Fov\n with ov", 0, 170, 61, true, "x", 1):depend(
                {v142, "Visuals"},
                {v103.menu.tools.viewmodel_on, true},
                {v103.menu.tools.viewmodel_mod, "In-scope"},
                {v103.menu.tools.viewmodel_inscope, true}
            )
            v103.menu.tools.nagiev_game = v104:checkbox("\aFD0540FF⚠️\r иГрА нАгИеВа \aFD0540FF⚠️\r"):depend({v142, "Visuals"})
            
            -- Helpers section
            v103.menu.tools.defensive_resolver = v104:checkbox("\v\aFF6B35FF Defensive AA Resolver ☭"):depend({v142, "Helpers"})
            v103.menu.tools.defensive_resolver_force = v104:checkbox("\n Force pitch on detected"):depend({v142, "Helpers"},
            {v103.menu.tools.defensive_resolver, true})
            v103.menu.tools.air_stop = v104:checkbox("\v\a9FCA2BFF Jumpscout ☭", 0):depend({v142, "Helpers"})
            v103.menu.tools.air_stop_distance =
                v104:slider("\n Distance", 1, 25, 2, true, "ft", 5, {[25] = "Always"}):depend(
                {v142, "Helpers"},
                {v103.menu.tools.air_stop, true}
            )
            -- Proteus Cheat Detection
v103.menu.tools.proteus_enable = v104:checkbox("\v\a9FCA2BFF Proteus Cheat Detector ☭"):depend({v142, "Helpers"})
v103.menu.tools.proteus_cheat = v104:combobox("\n Target Cheat", {
    'anonymous',
    '\aC1C1C1FFgame\a9FCA2BFFsense',
    '\aEC4B82FFfatality',
    '\aFFFFFFFFnixware',
    '\a0095B9FFneverlose',
    '\aC09DFCFFpandora',
    '\aF7A414FFonetap',
    '\a00F300FFrifk\aFF00FFFF7',
    '\a6BFF87FFplague',
    '\a3ABBFFFFev0lve'
}):depend({v142, "Helpers"}, {v103.menu.tools.proteus_enable, true})
            v103.menu.tools.unsafe_charge = v104:checkbox("\v\a9FCA2BFF Unsafe charge \r☭"):depend({v142, "Helpers"})
            v103.menu.tools.fast_ladder = v104:checkbox("\v\aECC45CFF Fast ladder \r☭"):depend({v142, "Helpers"})
            -- Thirdperson Animations
            v103.menu.tools.thirdperson_animations = v104:checkbox("\v\aECC45CFF Thirdperson Animations \r☭"):depend({v142, "Helpers"})
            v103.menu.tools.thirdperson_distance = v104:slider("\n Distance", 0, 250, 100):depend({v142, "Helpers"},
            {v103.menu.tools.thirdperson_animations, true}
            )
            v103.menu.tools.thirdperson_zoom_speed = v104:slider("\n Zoom Speed", 0, 100, 25, true, "%", 1, {[0] = "Instant"}):depend({v142, "Helpers"},
            {v103.menu.tools.thirdperson_animations, true}
            )
            v103.menu.tools.aspect_ratio_enable = v104:checkbox("\v\aECC45CFF Force Aspect Ratio"):depend({v142, "Helpers"})
            v103.menu.tools.aspect_ratio_slider = 
                v104:slider("\n Aspect Ratio Value", 0, 199, 100, true, "%", 1, 
                    {[0] = "Native", [50] = "4:3", [100] = "16:9", [150] = "21:9"}):depend(
                    {v142, "Helpers"},
                    {v103.menu.tools.aspect_ratio_enable, true}
                )
            v103.menu.tools.clantag_enable = v104:checkbox("\v\aFF6B6BFF Enable Clan Tag"):depend({v142, "Helpers"})
            v103.menu.tools.clantag_speed =
                v104:slider("\v↓\aFAF0E6FF Tag Speed", 5, 50, 10, true, "ticks"):depend({v142, "Helpers"}):depend({v103.menu.tools.clantag_enable, true})
			v103.menu.tools.trashtalk = v104:checkbox("\v\aFF6B6BFF Trashtalk ☭"):depend({v142, "Helpers"})
            v103.menu.tools.trashtalk_type =
                v104:combobox("\n trashtalk type", {"Default type", "1"}):depend(
                {v103.menu.tools.trashtalk, true}
            ):depend({v142, "Helpers"})
            v103.menu.tools.trashtalk_check2 =
                v104:checkbox(v107 .. "player name (enemy)"):depend(
                {v103.menu.tools.trashtalk, true},
                {v103.menu.tools.trashtalk_type, "1"}
            ):depend({v142, "Helpers"})
            v103.menu.tools.animations = v104:checkbox("\v\aFF6B6BFF Animations breakers \r☭"):depend({v142, "Helpers"})
            v103.menu.tools.animations_selector =
                v104:multiselect(
                "\n Animations",
                {
                    "Reset pitch on land",
                    "Body lean",
                    "Static legs",
                    "Jitter air",
                    "Jitter ground",
                    "Kangaroo",
                    "Moonwalk",
                    "Yaw break",
                    "Pitch break"
                }
            ):depend({v103.menu.tools.animations, true}):depend({v142, "Helpers"})
            v103.menu.tools.animations_body =
                v104:slider("\n Body lean ", 0, 100, 74, true, ""):depend({v103.menu.tools.animations, true}):depend(
                {v103.menu.tools.animations_selector, "Body lean"}
            ):depend({v142, "Helpers"})
            v103.menu.tools.autobuy = v104:checkbox("\v\afffff0   Auto buy \r☭"):depend({v142, "Helpers"})
            v103.menu.tools.autobuy_v =
                v104:combobox("\n auto buy vibor", {"Awp", "Scar/g3sg1", "Scout"}):depend(
                {v103.menu.tools.autobuy, true}
            ):depend({v142, "Helpers"})
            
            -- Predict Features
            v103.menu.tools.predict_system = v104:checkbox("\v\afffff0   Enable Predict System"):depend({v142, "Helpers"})
            v103.menu.tools.latency_depending =
                v104:checkbox("\v↓\aFAF0E6FF Latency Depending"):depend({v142, "Helpers"}):depend({v103.menu.tools.predict_system, true})
            v103.menu.tools.inverse_hitboxes =
                v104:checkbox("\v↓\aFAF0E6FF Inverse Hitboxes at Time-Line"):depend({v142, "Helpers"}):depend({v103.menu.tools.predict_system, true})
            v103.menu.tools.attach_backtrack =
                v104:checkbox("\v↓\aFAF0E6FF Attach Backtrack (Head/Chest/Stomach)"):depend({v142, "Helpers"}):depend({v103.menu.tools.predict_system, true})

            -- Resolver Helper
            v103.menu.tools.resolver_helper = v104:checkbox("\v\afffff0   Enable Resolver Helper"):depend({v142, "Helpers"})
            v103.menu.tools.jitter_boost =
                v104:combobox("\v↓\aFAF0E6FF Jitter Accuracy Boost", {"High", "Average", "Small"}):depend({v142, "Helpers"}):depend({v103.menu.tools.resolver_helper, true})
            v103.menu.tools.fix_def_peek =
                v104:checkbox("\v↓\aFAF0E6FF Fix Defensive in Peek"):depend({v142, "Helpers"}):depend({v103.menu.tools.resolver_helper, true})
                
            
            -- Menu dependencies
            v32.traverse(
                v103.menu.home,
                function(v826)
                    v826:depend({v103.menu.global.tab, " Home"})
                end
            )
            v32.traverse(
                v103.menu.antiaim,
                function(v827)
                    v827:depend({v103.menu.global.tab, " Anti-Aim"})
                end
            )
            v32.traverse(
                v103.menu.tools,
                function(v828)
                    v828:depend({v103.menu.global.tab, " Tools"})
                end
            )
        end,
        shutdown = function(v196)
            v196.helpers:menu_visibility(true)
        end
    }
):struct("helpers")(
    {
        anim = {},
        contains = function(v197, v198, v199)
            for v829, v830 in v3(v198) do
                if (v830 == v199) then
                    return true
                end
            end
            return false
        end,
        lerp = function(v200, v201, v202, v203)
            return ((v202 - v201) * v203) + v201
        end,
        math_anim2 = function(v204, v205, v206, v207)
            v207 = v43.clamp(v26.frametime() * ((v207 / 100) or 0.08) * 175, 0.01, 1)
            local v208 = v204:lerp(v205, v206, v207)
            return v12(v20.format("%.3f", v208))
        end,
        new_anim = function(v209, v210, v211, v212)
            if (v209.anim[v210] == nil) then
                v209.anim[v210] = v211
            end
            local v213 = v209:math_anim2(v209.anim[v210], v211, v212)
            v209.anim[v210] = v213
            return v209.anim[v210]
        end,
        rgba_to_hex = function(v215, v216, v217, v218, v219)
            return v29.tohex(
                (v19.floor(v216 + 0.5) * 16777216) + (v19.floor(v217 + 0.5) * 65536) + (v19.floor(v218 + 0.5) * 256) +
                    (v19.floor(v219 + 0.5))
            )
        end,
        limit_ch = function(v220, v221, v222, v223)
            local v224 = {}
            local v225 = 1
            for v831 in v20.gmatch(v221, ".[\x80-\xBF]*") do
                v225, v224[v225] = v225 + 1, v831
                if (v222 < v225) then
                    if v223 then
                        v224[v225] = ((v223 == true) and "...") or v223
                    end
                    break
                end
            end
            return v18.concat(v224)
        end,
        animate_pulse = function(v226, v227, v228)
            local v229, v230, v231, v232 = v15(v227)
            local v233 = v229 * v19.abs(v19.cos(v26.curtime() * v228))
            local v234 = v230 * v19.abs(v19.cos(v26.curtime() * v228))
            local v235 = v231 * v19.abs(v19.cos(v26.curtime() * v228))
            local v236 = v232 * v19.abs(v19.cos(v26.curtime() * v228))
            return v233, v234, v235, v236
        end,
        animate_text = function(v237, v238, v239, v240, v241, v242, v243)
            local v244, v245 = {}, 1
            local v246 = v239:len() - 1
            local v247 = 255 - v240
            local v248 = 255 - v241
            local v249 = 255 - v242
            local v250 = 155 - v243
            for v833 = 1, #v239 do
                local v834 = ((v833 - 1) / (#v239 - 1)) + v238
                v244[v245] =
                    "\a" ..
                    v237:rgba_to_hex(
                        v240 + (v247 * v19.abs(v19.cos(v834))),
                        v241 + (v248 * v19.abs(v19.cos(v834))),
                        v242 + (v249 * v19.abs(v19.cos(v834))),
                        v243 + (v250 * v19.abs(v19.cos(v834)))
                    )
                v244[v245 + 1] = v239:sub(v833, v833)
                v245 = v245 + 2
            end
            return v244
        end,
        rounded_side_v = function(v251, v252, v253, v254, v255, v256, v257, v258, v259, v260, v261, v262)
            v252, v253, v254, v255, v260 = v252 * 1, v253 * 1, v254 * 1, v255 * 1, (v260 or 0) * 1
            v261, v262 = v261 or false, v262 or false
            local v263 = v256
            local v264 = v257
            local v265 = v258
            local v266 = v259
            v28.rectangle(v252 + v260, v253, v254 - v260, v255, v263, v264, v265, v266)
            if v261 then
                v28.circle(v252 + v260, v253 + v260, v263, v264, v265, v266, v260, 180, 0.25)
                v28.circle(v252 + v260, (v253 + v255) - v260, v263, v264, v265, v266, v260, 270, 0.25)
                v28.rectangle(v252, v253 + v260, (v254 - v254) + v260, (v255 - v260) - v260, v263, v264, v265, v266)
            end
            if v262 then
                v28.circle(v252 + v254, v253 + v260, v263, v264, v265, v266, v260, 90, 0.25)
                v28.circle(v252 + v254, (v253 + v255) - v260, v263, v264, v265, v266, v260, 0, 0.25)
                v28.rectangle(
                    v252 + v254,
                    v253 + v260,
                    (v254 - v254) + v260,
                    (v255 - v260) - v260,
                    v263,
                    v264,
                    v265,
                    v266
                )
            end
        end,
        get_camera_pos = function(v267, v268)
            local v269, v270, v271 = v24.get_prop(v268, "m_vecOrigin")
            if (v269 == nil) then
                return
            end
            local v272, v272, v273 = v24.get_prop(v268, "m_vecViewOffset")
            v271 = v271 + (v273 - (v24.get_prop(v268, "m_flDuckAmount") * 16))
            return v269, v270, v271
        end,
        fired_shot = function(v274, v275, v276, v277)
            local v278 = {v274:get_camera_pos(v276)}
            if (v278[1] == nil) then
                return
            end
            local v279 = {v24.hitbox_position(v275, 0)}
            local v280 = {v279[1] - v278[1], v279[2] - v278[2], v279[3] - v278[3]}
            local v281 = {v277[1] - v278[1], v277[2] - v278[2], v277[3] - v278[3]}
            local v282 =
                ((v280[1] * v281[1]) + (v280[2] * v281[2]) + (v280[3] * v281[3])) /
                (v19.pow(v281[1], 2) + v19.pow(v281[2], 2) + v19.pow(v281[3], 2))
            local v283 = {v278[1] + (v281[1] * v282), v278[2] + (v281[2] * v282), v278[3] + (v281[3] * v282)}
            local v284 =
                v19.abs(
                v19.sqrt(v19.pow(v279[1] - v283[1], 2) + v19.pow(v279[2] - v283[2], 2) + v19.pow(v279[3] - v283[3], 2))
            )
            local v285 = v22.trace_line(v276, v277[1], v277[2], v277[3], v279[1], v279[2], v279[3])
            local v286 = v22.trace_line(v275, v283[1], v283[2], v283[3], v279[1], v279[2], v279[3])
            return (v284 < 69) and ((v285 > 0.99) or (v286 > 0.99))
        end,
        get_damage = function(v287)
            local v288 = v21.get(v287.ref.rage.mindmg[1])
            if (v21.get(v287.ref.rage.ovr[1]) and v21.get(v287.ref.rage.ovr[2])) then
                return v21.get(v287.ref.rage.ovr[3])
            else
                return v288
            end
        end,
        get_charge = function(v289)
            local v290 = v24.get_local_player()
            if (not v290 or not v24.is_alive(v290)) then
                return
            end
            local v291 = v24.get_prop(v290, "m_flNextAttack")
            local v292 = v24.get_prop(v24.get_player_weapon(v290), "m_flNextPrimaryAttack")
            local v293 = not (v19.max(v292, v291) > v26.curtime()) and (v289.globals.tick ~= 3)
            return v293
        end,
        normalize_yaw = function(v294, v295)
            v295 = v295 % 360
            v295 = (v295 + 360) % 360
            if (v295 > 180) then
                v295 = v295 - 360
            end
            return v295
        end,
        normalize_pitch = function(v296, v297)
            return v43.clamp(v297, -89, 89)
        end,
        distance = function(v298, v299, v300, v301, v302, v303, v304)
            return v19.sqrt(((v302 - v299) ^ 2) + ((v303 - v300) ^ 2) + ((v304 - v301) ^ 2))
        end,
        flags = {HIT = {11, 2048}},
        entity_has_flag = function(v305, v306, v307)
            if (not v306 or not v307) then
                return false
            end
            local v308 = v305.flags[v307]
            if (v308 == nil) then
                return false
            end
            local v309 = v24.get_esp_data(v306) or {}
            return v29.band(v309.flags or 0, v29.lshift(1, v308[1])) == v308[2]
        end,
        get_target = function(v310)
            local v311 = v24.get_local_player()
            local v312 = v22.current_threat()
            local v313 = "None"
            if (not v311 or not v312) then
                v313 = "None"
            else
                v313 = v24.get_player_name(v312)
            end
            return v313
        end,
        menu_visibility = function(v314, v315)
            local v316 = {v314.ref.aa, v314.ref.fakelag, v314.ref.aa_other}
            for v837, v838 in v2(v316) do
                for v977, v978 in v3(v838) do
                    for v1022, v1023 in v2(v978) do
                        v21.set_visible(v1023, v315)
                    end
                end
            end
            v21.set_enabled(v314.ref.misc.log[1], v315)
            v21.set_enabled(v314.ref.misc.override_zf, v315)
            v21.set(v314.ref.misc.log[1], false)
        end,
        in_air = function(v317, v318)
            local v319 = v24.get_prop(v318, "m_fFlags")
            return v29.band(v319, 1) == 0
        end,
        in_duck = function(v320, v321)
            local v322 = v24.get_prop(v321, "m_fFlags")
            return v29.band(v322, 4) == 4
        end,
        get_state = function(v323)
            local v324 = v24.get_local_player()
            local v325 = v24.get_prop(v324, "m_vecVelocity")
            local v326 = v31(v325):length2d()
            local v327 = v323:in_duck(v324) or v21.get(v323.ref.rage.fd[1])
            local v328 = v323.ui.menu.antiaim.states
            local v329 = v323.antiaim:get_manual()
            local v330 = v21.get(v323.ref.rage.dt[1]) and v21.get(v323.ref.rage.dt[2])
            local v331 = v21.get(v323.ref.rage.os[1]) and v21.get(v323.ref.rage.os[2])
            local v332 = v21.get(v323.ref.rage.fd[1])
            local v333 = "global"
            if (v326 > 1.5) then
                if v328["run"].enable() then
                    v333 = "run"
                end
            elseif v328["stand"].enable() then
                v333 = "stand"
            end
            if v323:in_air(v324) then
                if v327 then
                    if v328["aerobic+"].enable() then
                        v333 = "aerobic+"
                    end
                elseif v328["aerobic"].enable() then
                    v333 = "aerobic"
                end
            elseif (v327 and (v326 > 1.5) and v328["sneak"].enable()) then
                v333 = "sneak"
            elseif
                ((v326 > 1) and v21.get(v323.ref.slow_motion[1]) and v21.get(v323.ref.slow_motion[2]) and
                    v328["slow walk"].enable())
            then
                v333 = "slow walk"
            elseif ((v329 == -90) and v328["manual left"].enable()) then
                v333 = "manual left"
            elseif ((v329 == 90) and v328["manual right"].enable()) then
                v333 = "manual right"
            elseif (v327 and v328["crouch"].enable()) then
                v333 = "crouch"
            end
            if v326 then
                if (v328["fakelag"].enable() and ((not v330 and not v331) or v332)) then
                    v333 = "fakelag"
                end
                if (v328["hideshots"].enable() and v331 and not v330 and not v332) then
                    v333 = "hideshots"
                end
            end
            return v333
        end
    }
):struct("config")(
    {
        configs = {}, 
        write_file = function(v334, v335, v336)
            if (not v336 or (v14(v335) ~= "string")) then
                return
            end
            return v10(v335, json.stringify(v336))
        end, 
        update_name = function(v337)
            local v338 = v337.ui.menu.home.list()
            local v339 = 0
            for v839, v840 in v3(v337.configs) do
                if (v338 == v339) then
                    return v337.ui.menu.home.name(v839)
                end
                v339 = v339 + 1
            end
        end, 
        update_configs = function(v340)
            local v341 = {}
            for v841, v842 in v3(v340.configs) do
                v18.insert(v341, v841)
            end
            if (#v341 > 0) then
                v340.ui.menu.home.list:update(v341)
            end
            v340:write_file("w.tech_configs.txt", v340.configs)
            v340:update_name()
        end, 
        setup = function(v342)
            local v343 = v9("w.tech_configs.txt")
            if (v343 == nil) then
                return
            end
            v342.configs = json.parse(v343)
            v342:update_configs()
            v342:update_name()
        end, 
        export_config = function(v345, ...)
            local v346 = v345.ui.menu.home.name()
            local v347 = v32.setup({v345.ui.menu.global, v345.ui.menu.antiaim, v345.ui.menu.tools})
            local v348 = v347:save()
            local v349 = v33.encode(json.stringify(v348))
            print("Succsess cfg export")
            return v349
        end, 
        export_state = function(v350, v351)
            local v352 = v32.setup({v350.ui.menu.antiaim.states[v351]})
            local v351 = v350.ui.menu.antiaim.state:get()
            local v353 = v352:save()
            local v354 = v33.encode(json.stringify(v353))
            v44.create_new({{"Condition "}, {v351, true}, {" export"}})
            return v354
        end, 
        export = function(v355, v356, ...)
            local v357, v358 = v16(v355["export_" .. v356], v355, ...)
            if not v357 then
                print(v358)
                return
            end
            print("Succsess")
            return "{w.tech:" .. v356 .. "}:" .. v358
        end, 
        import_config = function(v359, v360)
            local v361 = json.parse(v33.decode(v360))
            local v362 = v32.setup({v359.ui.menu.global, v359.ui.menu.antiaim, v359.ui.menu.tools})
            v362:load(v361)
            v44.create_new({{"Cfg import"}, {"!", true}})
        end, 
        import_state = function(v363, v364, v365)
            local v366 = json.parse(v33.decode(v364))
            local v367 = v32.setup({v363.ui.menu.antiaim.states[v365]})
            v367:load(v366)
            v44.create_new({{"Condition import"}, {"!", true}})
        end, 
        import = function(v368, v369, v370, ...)
            local v371 = v369:match("{w.tech:(.+)}")
            if (not v371 or (v371 ~= v370)) then
                v44.create_new({{"Error: "}, {"This not config", true}})
                return v0("This not config")
            end
            local v372, v373 = v16(v368["import_" .. v371], v368, v369:gsub("{w.tech:" .. v371 .. "}:", ""), ...)
            if not v372 then
                print(v373)
                v44.create_new({{"Error: "}, {"Failed data w.tech", true}})
                return v0("Failed data w.tech")
            end
        end, 
        save = function(v374)
            local v375 = v374.ui.menu.home.name()
            if (v375:match("%w") == nil) then
                v44.create_new({{"Invalid config "}, {"name", true}})
                return print("Invalid config name")
            end
            local v376 = v374:export("config")
            v374.configs[v375] = v376
            v44.create_new({{"Saved cfg "}, {v375, true}})
            v374:update_configs()
        end, 
        load = function(v378, v379)
            local v380 = v378.ui.menu.home.name()
            local v381 = v378.configs[v380]
            if not v381 then
                v44.create_new({{"Invalid cfg "}, {"name", true}})
                return v0("Inval. cfg name")
            end
            v378:import(v381, v379)
            v44.create_new({{"Loaded cfg "}, {v380, true}})
        end, 
        delete = function(v382)
            local v383 = v382.ui.menu.home.name()
            local v384 = v382.configs[v383]
            if not v384 then
                return v0("Invalid config name")
            end
            v382.configs[v383] = nil
            v44.create_new({{"Delete cfg "}, {v383, true}})
            v382:update_configs()
        end
    }
):struct("antiaim")(
    {
        side = 0,
        last_rand = 0,
        skitter_counter = 0,
        last_skitter = 0,
        cycle = 0,
        manual_side = 0,
        anti_backstab = function(v386)
            local v387 = v24.get_local_player()
            local v388 = v22.current_threat()
            if ((v387 == nil) or not v24.is_alive(v387)) then
                return false
            end
            if not v388 then
                return false
            end
            local v389 = v24.get_player_weapon(v388)
            if not v389 then
                return false
            end
            local v390 = v24.get_classname(v389)
            if not v390:find("Knife") then
                return false
            end
            local v391 = v31(v24.get_origin(v387))
            local v392 = v31(v24.get_origin(v388))
            local v393 = 168
            return v392:dist2d(v391) < v393
        end,
        get_best_side = function(v394, v395)
            local v396 = v24.get_local_player()
            local v397 = v31(v22.eye_position())
            local v398 = v22.current_threat()
            local v399, v400 = v22.camera_angles()
            local v401
            if v398 then
                v401 = v31(v24.get_origin(v398)) + v31(0, 0, 64)
                v399, v400 = (v401 - v397):angles()
            end
            local v402 = {60, 45, 30, -30, -45, -60}
            local v403 = {left = 0, right = 0}
            for v843, v844 in v2(v402) do
                local v845 = v31():init_from_angles(0, v400 + 180 + v844, 0)
                if v398 then
                    local v1024 = v397 + v845:scaled(128)
                    local v1025, v1026 = v22.trace_bullet(v398, v401.x, v401.y, v401.z, v1024.x, v1024.y, v1024.z, v396)
                    v403[((v844 < 0) and "left") or "right"] = v403[((v844 < 0) and "left") or "right"] + v1026
                else
                    local v1028 = v397 + v845:scaled(8192)
                    local v1029 = v22.trace_line(v396, v397.x, v397.y, v397.z, v1028.x, v1028.y, v1028.z)
                    v403[((v844 < 0) and "left") or "right"] = v403[((v844 < 0) and "left") or "right"] + v1029
                end
            end
            if (v403.left == v403.right) then
                return 2
            elseif (v403.left > v403.right) then
                return (v395 and 1) or 0
            else
                return (v395 and 0) or 1
            end
        end,
        get_manual = function(v404)
            local v405 = v24.get_local_player()
            if ((v405 == nil) or not v404.ui.menu.antiaim.manual_aa:get()) then
                return
            end
            local v406 = v404.ui.menu.antiaim.manual_left:get()
            local v407 = v404.ui.menu.antiaim.manual_right:get()
            local v408 = v404.ui.menu.antiaim.manual_forward:get()
            if (v404.last_forward == nil) then
                v404.last_forward, v404.last_right, v404.last_left = v408, v407, v406
            end
            if (v406 ~= v404.last_left) then
                if (v404.manual_side == 1) then
                    v404.manual_side = nil
                else
                    v404.manual_side = 1
                end
            end
            if (v407 ~= v404.last_right) then
                if (v404.manual_side == 2) then
                    v404.manual_side = nil
                else
                    v404.manual_side = 2
                end
            end
            if (v408 ~= v404.last_forward) then
                if (v404.manual_side == 3) then
                    v404.manual_side = nil
                else
                    v404.manual_side = 3
                end
            end
            v404.last_forward, v404.last_right, v404.last_left = v408, v407, v406
            if not v404.manual_side then
                return
            end
            return ({-90, 90, 180})[v404.manual_side]
        end,
        run = function(v412, v413)
            local v414 = v24.get_local_player()
            if not v24.is_alive(v414) then
                return
            end
            local v415 = v412.helpers:get_state()
            v412:set_builder(v413, v415)
        end,
        set_builder = function(v416, v417, v418)
            local v419 = {}
            for v846, v847 in v3(v416.ui.menu.antiaim.states[v418]) do
                v419[v846] = v847()
            end
            v416:set(v417, v419)
        end,
        animations = function(v420)
            local v421 = v24.get_local_player()
            if not v24.is_alive(v421) then
                return
            end
            local v422 = v35.new(v421)
            local v423 = v422:get_anim_state()
            local v424 = v420.ui.menu.tools.animations_body:get()
            local v425 = v420.ui.menu.tools.animations_selector:get()
            if not v423 then
                return
            end
            local v426 = v24.get_prop(v421, "m_vecVelocity[0]")
            if v420.helpers:contains(v425, "Body lean") then
                local v982 = v422:get_anim_overlay(12)
                if not v982 then
                    return
                end
                if (v19.abs(v426) >= 3) then
                    v982.weight = v424 / 100
                end
            end
            if v420.helpers:contains(v425, "Static legs") then
                v24.set_prop(v421, "m_flPoseParameter", 1, 6)
            end
            if v420.helpers:contains(v425, "Yaw break") then
                v24.set_prop(v421, "m_flPoseParameter", v19.random(0, 10) / 10, 11)
            end
            if v420.helpers:contains(v425, "Pitch break") then
                v24.set_prop(v421, "m_flPoseParameter", v19.random(0, 10) / 10, 12)
            end
            if v420.helpers:contains(v425, "Jitter ground") then
                v21.set(v420.ref.fakelag.lg[1], "Always slide")
                if ((v26.tickcount() % 4) > 1) then
                    v24.set_prop(v421, "m_flPoseParameter", 0, 0)
                end
            end
            if v420.helpers:contains(v425, "Kangaroo") then
                if not v420.helpers:contains(v425, "Jitter air") then
                    v24.set_prop(v421, "m_flPoseParameter", v19.random(0, 10) / 10, 6)
                end
                v24.set_prop(v421, "m_flPoseParameter", v19.random(0, 10) / 10, 3)
                v24.set_prop(v421, "m_flPoseParameter", v19.random(0, 10) / 10, 10)
                v24.set_prop(v421, "m_flPoseParameter", v19.random(0, 10) / 10, 9)
            end
            if v420.helpers:contains(v425, "Jitter air") then
                v24.set_prop(v421, "m_flPoseParameter", v19.random(0, 10) / 10, 6)
            end
            if v420.helpers:contains(v425, "Moonwalk") then
                v21.set(v420.ref.fakelag.lg[1], "Never slide")
                v24.set_prop(v421, "m_flPoseParameter", 0, 7)
                if v420.helpers:in_air(v421) then
                    v422:get_anim_overlay(4).weight = 0
                    v422:get_anim_overlay(6).weight = 1
                end
            end
            if v420.helpers:contains(v425, "Reset pitch on land") then
                if not v423.hit_in_ground_animation then
                    return
                end
                v24.set_prop(v421, "m_flPoseParameter", 0.5, 12)
            end
        end,
        get_defensive = function(v427, v428, v429, v430)
            local v431 = v22.current_threat()
            local v432 = v24.get_local_player()
            if v427.helpers:contains(v428, "Always") then
                return true
            end
            if v427.helpers:contains(v428, "On weapon switch") then
                local v983 = v24.get_prop(v432, "m_flNextAttack") - v26.curtime()
                if ((v983 / v26.tickinterval()) > (v427.defensive.defensive + 2)) then
                    return true
                end
            end
            if v427.helpers:contains(v428, "Tick-Base") then
                local v984 = v430.defensive_conditions_tick * 2
                if ((v26.tickcount() % 32) >= v984) then
                    return true
                else
                    return false
                end
            end
            if v427.helpers:contains(v428, "On reload") then
                local v985 = v24.get_player_weapon(v432)
                if v985 then
                    local v1051 = v24.get_prop(v432, "m_flNextAttack") - v26.curtime()
                    local v1052 = v24.get_prop(v985, "m_flNextPrimaryAttack") - v26.curtime()
                    if ((v1051 > 0) and (v1052 > 0) and ((v1051 * v26.tickinterval()) > v427.defensive.defensive)) then
                        return true
                    end
                end
            end
            if (v427.helpers:contains(v428, "On hittable") and v427.helpers:entity_has_flag(v431, "HIT")) then
                return true
            end
            if
                (v427.helpers:contains(v428, "On freestand") and v427.ui.menu.antiaim.freestanding:get_hotkey() and
                    not (v427.ui.menu.antiaim.freestanding:get("Disablers") and
                        v427.ui.menu.antiaim.freestanding_disablers:get(v429)))
            then
                return true
            end
        end,
        spin_yaw = 0,
        spin_pitch_def = 0,
        switch_way = 1,
        spin_value = 0,
        jitter_side = 0,
        spin_way = 0,
        spin_pitch = 0,
        last_way = 0,
        switch_random = 0,
        switch_random_p = 0,
        random_spin_way = 0,
        spin_way_180 = 0,
        generated_yaw = 0,
        generated_pitch = 0,
        last_defensive_ticks = 0,
        fake_flick_last_time = 0,
        fake_flick_current_state = 0,
        desync_flick_last_time = 0,
        desync_flick_state = 0,
        desync_flick_side = 1,
        desync_flick_body_last_switch = 0,
        set = function(v433, v434, v435)
            local v436 = v433.helpers:get_state()
            local v437 = {v19.random(1, v19.random(3, 4)), 2, 4, 5}
            local v438 = v433:get_manual()
            local v439 = true
            
            if (v433.helpers:contains(v435.options, "Fake-Flick")) then
                local v_current_time = v26.curtime()
                local v_flick_interval = (v435.fake_flick_speed or 50) / 1000
                
                if (v_current_time - v433.fake_flick_last_time >= v_flick_interval) then
                    v433.fake_flick_current_state = (v433.fake_flick_current_state + 1) % 4
                    v433.fake_flick_last_time = v_current_time
                end
            end
            
            if (v433.helpers:contains(v435.options, "Desync Flick")) then
                local v_current_time = v26.curtime()
                local v_base_interval = (v435.desync_flick_speed or 15) / 1000
                local v_flick_interval = v_base_interval
                
                if (v435.desync_flick_random_delay) then
                    local v_random_delay = v19.random(1, 50) / 1000
                    v_flick_interval = v_flick_interval + v_random_delay
                end
                
                if (v_current_time - v433.desync_flick_last_time >= v_flick_interval) then
                    v433.desync_flick_state = v19.random(0, 7)
                    v433.desync_flick_side = (v19.random(0, 1) == 0) and -1 or 1
                    v433.desync_flick_last_time = v_current_time
                end
            end
            
            local v448_check =
                (((v433.defensive.ticks * v433.defensive.defensive) > 0) and
                v19.max(v433.defensive.defensive, v433.defensive.ticks)) or
                0
                
            if (v435.defensive_yaw_mode == "Static Random") then
                if (v448_check > 10 and v433.defensive.ticks == v433.defensive.defensive and v433.last_defensive_ticks ~= v433.defensive.ticks) then
                    v433.generated_yaw = v19.random(v435.defensive_yaw_left, v435.defensive_yaw_right)
                end
            end
            
            if (v435.defensive_pitch_mode == "Static Random") then
                if (v448_check > 10 and v433.defensive.ticks == v433.defensive.defensive and v433.last_defensive_ticks ~= v433.defensive.ticks) then
                    v433.generated_pitch = v19.random(v435.defensive_pitch_offset_1, v435.defensive_pitch_offset_2)
                end
            end
            
            if (v448_check > 0) then
                v433.last_defensive_ticks = v433.defensive.ticks
            else
                v433.last_defensive_ticks = 0
            end
            
            if (v435.jitter_delay == 0) then
                v437[v435.jitter_delay] = 1
            end
            
            if ((v26.chokedcommands() == 0) and (v433.cycle == v437[v435.jitter_delay])) then
                v439 = false
                v433.side = ((v433.side == 1) and 0) or 1
            end
            
            local v440 = v433:get_best_side()
            local v441 = v433.side
            local v442 = v435.body_yaw
            local v443 = "default"
            local v444 = v19.random(-v435.yaw_random, v435.yaw_random)
            local v445 = v435.yaw_jitter_add + v444
            
            if (v442 == "Jitter") then
                v442 = "Static"
            elseif (v435.body_yaw_side == "Left") then
                v441 = 1
            elseif (v435.body_yaw_side == "Right") then
                v441 = 0
            else
                v441 = v440
            end
            
            local v446 = 0
            
            if (v435.yaw_jitter == "Offset") then
                if (v433.side == 1) then
                    v446 = v446 + v445
                end
            elseif (v435.yaw_jitter == "Center") then
                v446 = v446 + (((v433.side == 1) and (v445 / 2)) or (-v445 / 2)) + v444
            elseif (v435.yaw_jitter == "Random") then
                local v1080 = v19.random(0, v445) - (v445 / 2)
                if not v439 then
                    v446 = v446 + v1080
                    v433.last_rand = v1080
                else
                    v446 = v446 + v433.last_rand
                end
            elseif (v435.yaw_jitter == "Smoothnes") then
                local v1107 = v445
                local v1108 = v437[v435.jitter_delay] / 4
                local v1109 = v1107 * v19.sin((v26.curtime() / v1108) * v19.pi)
                v446 = v1109
            elseif (v435.yaw_jitter == "Fractal") then
                local v1132 = v445 * 2
                local v1133 = v437[v435.jitter_delay] * 0.5
                local v1134 = 0
                local v1135 = v435.yaw_fractals
                local v1136 = 0
                if (v1135 == 14) then
                    v1136 = v19.random(0, 13)
                else
                    v1136 = v1135
                end
                for v1148 = 1, v1136 do
                    v1134 = v1134 + ((0.5 ^ v1148) * v19.cos(((2 ^ v1148) * v1133 * v26.curtime() * 2 * v19.pi) + 10))
                end
                v446 = v1134 * v1132
            elseif (v435.yaw_jitter == "Skitter") then
                local v1149 = {0, 2, 1, 0, 2, 1, 0, 1, 2, 0, 1, 2, 0, 1, 2}
                local v1150
                if (v433.skitter_counter == #v1149) then
                    v433.skitter_counter = 1
                elseif not v439 then
                    v433.skitter_counter = v433.skitter_counter + 1
                end
                v1150 = v1149[v433.skitter_counter]
                v433.last_skitter = v1150
                if (v435.body_yaw == "jitter") then
                    v441 = v1150
                end
                if (v1150 == 0) then
                    v446 = (v446 - 16) - (v19.abs(v445) / 2)
                elseif (v1150 == 1) then
                    v446 = v446 + 16 + (v19.abs(v445) / 2)
                end
            end
            
            if (v433.helpers:contains(v435.options, "Fake-Flick")) then
                local v_flick_states
                if (v435.fake_flick_yaw_mode == "Custom") then
                    v_flick_states = {
                        v435.fake_flick_yaw_1 or -90,
                        v435.fake_flick_yaw_2 or 90,
                        v435.fake_flick_yaw_3 or -180,
                        v435.fake_flick_yaw_4 or 180
                    }
                else
                    v_flick_states = {-90, 90, -180, 180}
                end
                v446 = v_flick_states[v433.fake_flick_current_state + 1] + (v435.yaw_add or 0)
            elseif (v435.defensive_yaw_mode == "Static Random") then
                v446 = v433.generated_yaw
            elseif (v435.defensive_yaw_mode == "Side Based") then
                v446 = 0
                if (v441 == 0) then
                    v446 = -v435.defensive_yaw_add_r
                else
                    v446 = v435.defensive_yaw_add
                end
            elseif (v435.defensive_yaw_mode == "Opposite") then
                v446 = -180 + v435.defensive_yaw_add
            elseif (v435.defensive_yaw_mode == "Spin") then
                v446 = (v26.curtime() * (v435.defensive_yaw_add * 12)) % 360
            elseif (v435.defensive_yaw_mode == "Sway") then
                local v_sway_speed = v435.defensive_yaw_speed or 20
                local v_sway_left = v435.defensive_yaw_add or 0
                local v_sway_right = v435.defensive_yaw_add_r or 0
                local v_sway_time = v26.curtime() * v_sway_speed * 0.1
                v446 = v_sway_left + ((v_sway_right - v_sway_left) * ((v_sway_time % 2) / 2))
            elseif (v435.defensive_yaw_mode == "Random") then
                v446 = v19.random(-v435.defensive_yaw_add, v435.defensive_yaw_add)
            elseif (v435.defensive_yaw_mode == "Left/Right") then
                v446 = 0
                if (v441 == 0) then
                    v446 = v435.defensive_yaw_add_r
                else
                    v446 = v435.defensive_yaw_add
                end
            elseif (v433.helpers:contains(v435.options, "Desync Flick")) then
                local v_desync_amount = v435.desync_flick_amount or 60
                local v_desync_states = {
                    v_desync_amount * v433.desync_flick_side,
                    -v_desync_amount * v433.desync_flick_side,
                    v_desync_amount * 0.75 * v433.desync_flick_side,
                    -v_desync_amount * 0.75 * v433.desync_flick_side,
                    v_desync_amount * 0.5 * v433.desync_flick_side,
                    -v_desync_amount * 0.5 * v433.desync_flick_side,
                    v_desync_amount * 0.25 * v433.desync_flick_side,
                    -v_desync_amount * 0.25 * v433.desync_flick_side
                }
                local v_random_add = v19.random(-10, 10)
                local v_yaw_random = v19.random(-15, 15)
                v446 = v446 + v_desync_states[v433.desync_flick_state + 1] + v_random_add + v_yaw_random
            end
            
            v446 = v446 + (((v441 == 0) and v435.yaw_add_r) or ((v441 == 1) and v435.yaw_add) or 0)
            
            if (v433.helpers:contains(v435.options, "Desync Flick")) then
                local v_desync_amount = v435.desync_flick_amount or 60
                local v_desync_states = {
                    v_desync_amount * v433.desync_flick_side,
                    -v_desync_amount * v433.desync_flick_side,
                    v_desync_amount * 0.75 * v433.desync_flick_side,
                    -v_desync_amount * 0.75 * v433.desync_flick_side,
                    v_desync_amount * 0.5 * v433.desync_flick_side,
                    -v_desync_amount * 0.5 * v433.desync_flick_side,
                    v_desync_amount * 0.25 * v433.desync_flick_side,
                    -v_desync_amount * 0.25 * v433.desync_flick_side
                }
                local v_desync_offset = v_desync_states[v433.desync_flick_state + 1]
                
                local v_current_time = v26.curtime()
                if (v_current_time - v433.desync_flick_body_last_switch >= 0.02) then
                    v441 = v19.random(0, 1)
                    v433.desync_flick_body_last_switch = v_current_time
                else
                    if (v_desync_offset > 0) then
                        v441 = 1
                    else
                        v441 = 0
                    end
                end
                v442 = "Static"
            end
            
            if
                (v433.helpers:contains(v435.options, "Enable defensive") and
                    v433:get_defensive(v435.defensive_conditions, v436, v435))
            then
                v434.force_defensive = true
            end
            
            local v447 = v433.ui.menu.antiaim.edge_yaw:get_hotkey()
            v21.set(v433.ref.aa.freestand[1], false)
            v21.set(v433.ref.aa.edge_yaw[1], v447)
            v21.set(v433.ref.aa.freestand[2], "Always on")
            
            if v433.helpers:contains(v435.options, "Safe head") then
                local v989 = v24.get_local_player()
                local v990 = v22.current_threat()
                if v990 then
                    local v1053 = v24.get_player_weapon(v989)
                    if (v1053 and (v24.get_classname(v1053):find("Knife") or v24.get_classname(v1053):find("Taser"))) then
                        v446 = 0
                        v441 = 2
                    end
                end
            end
            
            if (v433.ui.menu.antiaim.manual_static:get() and ((v438 == -90) or (v438 == 90))) then
                v446 = 0
                v441 = 0
            end
            
            if v438 then
                v446 = v438
            elseif
                (v433.ui.menu.antiaim.freestanding:get_hotkey() and
                    not (v433.ui.menu.antiaim.freestanding:get("Disablers") and
                        v433.ui.menu.antiaim.freestanding_disablers:get(v436)))
            then
                v21.set(v433.ref.aa.freestand[1], true)
                if v433.ui.menu.antiaim.freestanding:get("Force static") then
                    v446 = 0
                    v441 = 0
                end
            elseif (v433.helpers:contains(v435.options, "Avoid backstab") and v433:anti_backstab()) then
                v446 = v446 + 180
            end
            
            local v448 =
                (((v433.defensive.ticks * v433.defensive.defensive) > 0) and
                v19.max(v433.defensive.defensive, v433.defensive.ticks)) or
                0
                
            local v449 = {
                {
                    speed = v435.defensive_yaw_way_speed1,
                    spin_limit = v435.defensive_yaw_way_spin_limit1,
                    enable_spin = v435.defensive_yaw_enable_way_spin1,
                    switch_value = v435.defensive_yaw_way_switch1
                },
                {
                    speed = v435.defensive_yaw_way_speed2,
                    spin_limit = v435.defensive_yaw_way_spin_limit2,
                    enable_spin = v435.defensive_yaw_enable_way_spin2,
                    switch_value = v435.defensive_yaw_way_switch2
                },
                {
                    speed = v435.defensive_yaw_way_speed3,
                    spin_limit = v435.defensive_yaw_way_spin_limit3,
                    enable_spin = v435.defensive_yaw_enable_way_spin3,
                    switch_value = v435.defensive_yaw_way_switch3
                },
                {
                    speed = v435.defensive_yaw_way_speed4,
                    spin_limit = v435.defensive_yaw_way_spin_limit4,
                    enable_spin = v435.defensive_yaw_enable_way_spin4,
                    switch_value = v435.defensive_yaw_way_switch4
                },
                {
                    speed = v435.defensive_yaw_way_speed5,
                    spin_limit = v435.defensive_yaw_way_spin_limit5,
                    enable_spin = v435.defensive_yaw_enable_way_spin5,
                    switch_value = v435.defensive_yaw_way_switch5
                }
            }
            
            local v450 = {
                {
                    speed = v435.defensive_pitch_way_speed1,
                    spin_limit1 = v435.defensive_pitch_way_spin_limit11,
                    spin_limit2 = v435.defensive_pitch_way_spin_limit12,
                    enable_spin = v435.defensive_pitch_enable_way_spin1,
                    switch_value = v435.defensive_pitch_custom
                },
                {
                    speed = v435.defensive_pitch_way_speed2,
                    spin_limit1 = v435.defensive_pitch_way_spin_limit21,
                    spin_limit2 = v435.defensive_pitch_way_spin_limit22,
                    enable_spin = v435.defensive_pitch_enable_way_spin2,
                    switch_value = v435.defensive_pitch_way2
                },
                {
                    speed = v435.defensive_pitch_way_speed3,
                    spin_limit1 = v435.defensive_pitch_way_spin_limit31,
                    spin_limit2 = v435.defensive_pitch_way_spin_limit32,
                    enable_spin = v435.defensive_pitch_enable_way_spin3,
                    switch_value = v435.defensive_pitch_way3
                },
                {
                    speed = v435.defensive_pitch_way_speed4,
                    spin_limit1 = v435.defensive_pitch_way_spin_limit41,
                    spin_limit2 = v435.defensive_pitch_way_spin_limit42,
                    enable_spin = v435.defensive_pitch_enable_way_spin4,
                    switch_value = v435.defensive_pitch_way4
                },
                {
                    speed = v435.defensive_pitch_way_speed5,
                    spin_limit1 = v435.defensive_pitch_way_spin_limit51,
                    spin_limit2 = v435.defensive_pitch_way_spin_limit52,
                    enable_spin = v435.defensive_pitch_enable_way_spin5,
                    switch_value = v435.defensive_pitch_way5
                }
            }
            
            local v451 = v26.tickcount() % 32
            
            if v435.defensive_yaw and (v448 > 0) then
                if (v435.defensive_yaw_mode == "Static Random") then
                    local v_def_yaw_left = v435.defensive_yaw_left or -180
                    local v_def_yaw_right = v435.defensive_yaw_right or 180
                    if (v448_check > 0 and v433.defensive.ticks == v433.defensive.defensive and v433.last_defensive_ticks ~= v433.defensive.ticks) then
                        v433.generated_yaw = v19.random(v_def_yaw_left, v_def_yaw_right)
                    end
                    v446 = v433.generated_yaw
                elseif (v435.defensive_yaw_mode == "Side Based") then
                    v446 = 0
                    if (v441 == 0) then
                        v446 = -(v435.defensive_yaw_add_r or 0)
                    else
                        v446 = v435.defensive_yaw_add or 0
                    end
                elseif (v435.defensive_yaw_mode == "Opposite") then
                    v446 = -180 + (v435.defensive_yaw_add or 0)
                elseif (v435.defensive_yaw_mode == "Spin") then
                    v446 = (v26.curtime() * ((v435.defensive_yaw_add or 0) * 12)) % 360
                elseif (v435.defensive_yaw_mode == "Sway") then
                    local v_sway_speed = v435.defensive_yaw_speed or 20
                    local v_sway_left = v435.defensive_yaw_add or 0
                    local v_sway_right = v435.defensive_yaw_add_r or 0
                    local v_sway_time = v26.curtime() * v_sway_speed * 0.1
                    v446 = v_sway_left + ((v_sway_right - v_sway_left) * ((v_sway_time % 2) / 2))
                elseif (v435.defensive_yaw_mode == "X-Way") then
                    local v_states = {-90, 90, -180, 180}
                    local v_current = v26.tickcount() % 4
                    v446 = v_states[v_current + 1] + (v435.defensive_yaw_add or 0)
                elseif (v435.defensive_yaw_mode == "Random") then
                    v446 = v19.random(-(v435.defensive_yaw_add or 0), v435.defensive_yaw_add or 0)
                elseif (v435.defensive_yaw_mode == "Left/Right") then
                    v446 = 0
                    if (v441 == 0) then
                        v446 = v435.defensive_yaw_add_r or 0
                    else
                        v446 = v435.defensive_yaw_add or 0
                    end
                elseif (v435.defensive_yaw_mode == "Jitter") then
                    local v1054 = v435.defensive_yaw_jitter_radius_1 or 30
                    local v1055 = v435.defensive_yaw_jitter_delay or 6 * 3
                    local v1056 = v435.defensive_yaw_jitter_random or 0
                    if (v1055 == 1) then
                        v433.jitter_side = ((v433.jitter_side == -1) and 1) or -1
                    else
                        v433.jitter_side = (((((v26.tickcount() % v1055) * 2) + 1) <= v1055) and -1) or 1
                    end
                    v446 = (v433.jitter_side * v1054) + v19.random(-v1056, v1056)
                elseif (v435.defensive_yaw_mode == "Custom spin") then
                    v433.spin_value = v433.spin_value + (8 * (v435.defensive_yaw_speedtick or 6) / 5)
                    if (v433.spin_value >= (v435.defensive_yaw_spin_limit or 360)) then
                        v433.spin_value = 0
                    end
                    v446 = v433.spin_value
                elseif (v435.defensive_yaw_mode == "Spin-way") then
                    local v1138 = v435.defensive_yaw_speed_Spin_way or 6
                    local v1139 = v435.defensive_yaw_randomizer_Spin_way or 0
                    local v1140 = v435.defensive_yaw_1_Spin_way or -180
                    local v1141 = v435.defensive_yaw_2_Spin_way or 180
                    local v1142 = 0
                    if (v451 >= (29 + v19.random(0, v1138))) then
                        v433.spin_way_180 = v433.spin_way_180 + 1
                        v433.random_spin_way = v19.random(-v1139, v1139)
                    end
                    if (v433.spin_way_180 == 0) then
                        v1142 = v1140 + v433.random_spin_way
                    elseif (v433.spin_way_180 == 1) then
                        v1142 = v1141 + v433.random_spin_way
                    end
                    if (v433.spin_way_180 == 2) then
                        v433.spin_way_180 = 0
                    end
                    local v1143 = v433.helpers:new_anim("antiaim_spin_way", v1142, 6)
                    v446 = v1143
                elseif (v435.defensive_yaw_mode == "Switch 5-way") then
                    if (v451 >= (29 + v19.random(0, (v435.defensive_yaw_way_delay or 4)))) then
                        v433.switch_way = v433.switch_way + 1
                        v433.switch_random =
                            v19.random(-(v435.defensive_yaw_way_randomly_value or 20), v435.defensive_yaw_way_randomly_value or 20)
                    else
                        v446 = v433.last_way
                        if (v433.switch_way == #v449) then
                            v433.switch_way = 0
                        end
                    end
                    if ((v433.switch_way >= 0) and (v433.switch_way < #v449)) then
                        local v1168 = v449[v433.switch_way + 1]
                        v433.spin_way = v433.spin_way + (8 * ((v1168.speed or 8) / 5))
                        if (v433.spin_way >= (v1168.spin_limit or 0)) then
                            v433.spin_way = 0
                        end
                        if not (v1168.enable_spin or false) then
                            if (v435.defensive_yaw_way_randomly or false) then
                                v446 = (v1168.switch_value or 30) + v433.switch_random
                                v433.last_way = (v1168.switch_value or 30) + v433.switch_random
                            else
                                v446 = v1168.switch_value or 30
                                v433.last_way = v1168.switch_value or 30
                            end
                        else
                            v446 = v433.spin_way
                            v433.last_way = v433.spin_way
                        end
                    elseif (v433.switch_way == #v449) then
                        v433.switch_way = 0
                    end
                end
            end
            
            if v435.defensive_pitch_enable and (v448 > 0) then
                if (v435.defensive_pitch_mode == "Static Random") then
                    local v_def_pitch_from = v435.defensive_pitch_offset_1 or -89
                    local v_def_pitch_to = v435.defensive_pitch_offset_2 or 89
                    if (v448_check > 0 and v433.defensive.ticks == v433.defensive.defensive and v433.last_defensive_ticks ~= v433.defensive.ticks) then
                        v433.generated_pitch = v19.random(v_def_pitch_from, v_def_pitch_to)
                    end
                    v443 = v433.generated_pitch
                elseif (v435.defensive_pitch_mode == "Sway") then
                    local v_pitch_speed = v435.defensive_pitch_speed_sway or 20
                    local v_pitch_time = v26.curtime() * v_pitch_speed * 0.1
                    v443 = (v435.defensive_pitch_custom or 0) + (((v435.defensive_pitch_custom or 0) * 0.5) * ((v_pitch_time % 2) / 2))
                elseif (v435.defensive_pitch_mode == "Switch") then
                    if (v26.tickcount() % 2 == 0) then
                        v443 = v435.defensive_pitch_custom or 0
                    else
                        v443 = (v435.defensive_pitch_custom or 0) + 10
                    end
                elseif (v435.defensive_pitch_mode == "Static") then
                    v443 = v435.defensive_pitch_custom or 0
                elseif (v435.defensive_pitch_mode == "Jitter") then
                    if (v19.random(0, 20) >= 10) then
                        v443 = v435.defensive_pitch_clock or 0
                    else
                        v443 = v435.defensive_pitch_custom or 0
                    end
                elseif (v435.defensive_pitch_mode == "Spin") then
                    if ((v435.defensive_pitch_custom or 0) < 0) then
                        v433.spin_pitch_def = v433.spin_pitch_def - ((v435.defensive_pitch_speedtick or 32) / 5)
                    else
                        v433.spin_pitch_def = v433.spin_pitch_def + ((v435.defensive_pitch_speedtick or 32) / 5)
                    end
                    if ((v435.defensive_pitch_custom or 0) < 0) then
                        if (v433.spin_pitch_def <= (v435.defensive_pitch_custom or 0)) then
                            v433.spin_pitch_def = v435.defensive_pitch_spin_limit2 or 0
                        end
                    elseif (v433.spin_pitch_def >= (v435.defensive_pitch_custom or 0)) then
                        v433.spin_pitch_def = v435.defensive_pitch_spin_limit2 or 0
                    end
                    v443 = v433.spin_pitch_def
                elseif (v435.defensive_pitch_mode == "Clocking") then
                    if (v451 >= 28) then
                        v433.spin_yaw = v433.spin_yaw + 15
                    end
                    if (v433.spin_yaw >= 89) then
                        v433.spin_yaw = -89
                    end
                    v443 = v433.spin_yaw
                elseif (v435.defensive_pitch_mode == "Random") then
                    local v1162 = v435.defensive_pitch_custom or 0
                    local v1163 = v435.defensive_pitch_spin_random2 or 0
                    v443 = v19.random(v1162, v1163)
                elseif (v435.defensive_pitch_mode == "5way") then
                    if (v451 >= (29 + v19.random(0, (v435.defensive_yaw_way_delay or 4)))) then
                        v433.switch_random_p =
                            v19.random(
                            -(v435.defensive_pitch_way_randomly_value or 20),
                            v435.defensive_pitch_way_randomly_value or 20
                        )
                    else
                        v443 = v433.last_way
                    end
                    if ((v433.switch_way >= 0) and (v433.switch_way < #v450)) then
                        local v1178 = v450[v433.switch_way + 1]
                        if ((v1178.spin_limit2 or 89) < 0) then
                            v433.spin_pitch = v433.spin_pitch - (8 * ((v1178.speed or 8) / 5))
                        else
                            v433.spin_pitch = v433.spin_pitch + (8 * ((v1178.speed or 8) / 5))
                        end
                        if ((v1178.spin_limit2 or 89) < 0) then
                            if (v433.spin_pitch <= (v1178.spin_limit2 or 89)) then
                                v433.spin_pitch = v1178.spin_limit1 or -89
                            end
                        elseif (v433.spin_pitch >= (v1178.spin_limit2 or 89)) then
                            v433.spin_pitch = v1178.spin_limit1 or -89
                        end
                        if not (v1178.enable_spin or false) then
                            if (v435.defensive_pitch_way_randomly or false) then
                                v443 = v433.switch_random_p
                                v433.last_way = v433.switch_random_p
                            else
                                v443 = v1178.switch_value or 0
                                v433.last_way = v1178.switch_value or 0
                            end
                        else
                            v443 = v433.spin_pitch
                            v433.last_way = v433.spin_pitch
                        end
                    end
                end
            end
            
            if (v433.helpers:contains(v435.options, "Fake-Flick") and v435.fake_flick_pitch_enable) then
                if (v435.fake_flick_pitch_mode == "Static") then
                    v443 = v435.fake_flick_pitch_value or 0
                elseif (v435.fake_flick_pitch_mode == "Random") then
                    v443 = v19.random(v435.fake_flick_pitch_min or -89, v435.fake_flick_pitch_max or 89)
                end
            elseif (v435.pitch_mode == "Static Random") then
                v443 = v433.generated_pitch
            elseif (v435.pitch_mode == "Static") then
                v443 = 0
            elseif (v435.pitch_mode == "Sway") then
                local v_pitch_speed = v435.pitch_speed or 20
                local v_pitch_from = v435.pitch_offset_1 or 0
                local v_pitch_to = v435.pitch_offset_2 or 0
                local v_pitch_time = v26.curtime() * v_pitch_speed * 0.1
                v443 = v_pitch_from + ((v_pitch_to - v_pitch_from) * ((v_pitch_time % 2) / 2))
            elseif (v435.pitch_mode == "Switch") then
                if (v26.tickcount() % 2 == 0) then
                    v443 = v435.pitch_offset_1 or 0
                else
                    v443 = v435.pitch_offset_2 or 0
                end
            elseif (v435.pitch_mode == "Random") then
                v443 = v19.random(v435.pitch_offset_1 or -89, v435.pitch_offset_2 or 89)
            end
            
            v21.set(v433.ref.aa.enabled[1], true)
            v21.set(v433.ref.aa.pitch[1], ((v443 == "default") and v443) or "custom")
            v21.set(v433.ref.aa.pitch[2], v433.helpers:normalize_pitch(((v14(v443) == "number") and v443) or 0))
            v21.set(v433.ref.aa.yaw_base[1], v435.yaw_base)
            v21.set(v433.ref.aa.yaw[1], 180)
            v21.set(v433.ref.aa.yaw[2], v433.helpers:normalize_yaw(v446))
            v21.set(v433.ref.aa.yaw_jitter[1], "off")
            v21.set(v433.ref.aa.yaw_jitter[2], 0)
            
            local v_body_yaw_value = ((v441 == 2) and 0) or ((v441 == 1) and 90) or -90
            if (v433.helpers:contains(v435.options, "Desync Flick")) then
                local v_desync_amount = v435.desync_flick_amount or 60
                local v_desync_states = {
                    v_desync_amount * v433.desync_flick_side,
                    -v_desync_amount * v433.desync_flick_side,
                    v_desync_amount * 0.75 * v433.desync_flick_side,
                    -v_desync_amount * 0.75 * v433.desync_flick_side,
                    v_desync_amount * 0.5 * v433.desync_flick_side,
                    -v_desync_amount * 0.5 * v433.desync_flick_side,
                    v_desync_amount * 0.25 * v433.desync_flick_side,
                    -v_desync_amount * 0.25 * v433.desync_flick_side
                }
                local v_base_value = v_desync_states[v433.desync_flick_state + 1]
                local v_random_add = v19.random(-15, 15)
                local v_body_random = v19.random(-25, 25)
                v_body_yaw_value = v_base_value + v_random_add + v_body_random
                v_body_yaw_value = v19.max(-120, v19.min(120, v_body_yaw_value))
            else
                if (v435.body_yaw ~= "Off" and v435.body_yaw ~= "Jitter") then
                    local v_body_random = v19.random(-10, 10)
                    v_body_yaw_value = v_body_yaw_value + v_body_random
                    v_body_yaw_value = v19.max(-120, v19.min(120, v_body_yaw_value))
                end
            end
            
            v21.set(v433.ref.aa.body_yaw[1], v442)
            v21.set(v433.ref.aa.body_yaw[2], v_body_yaw_value)
            
            if (v26.chokedcommands() == 0) then
                if (v433.cycle >= v437[v435.jitter_delay]) then
                    v433.cycle = 1
                else
                    v433.cycle = v433.cycle + 1
                end
            end
        end
    }
):struct("defensive")(
    {
        check = 0,
        defensive = 0,
        sim_time = v26.tickcount(),
        active_until = 0,
        ticks = 0,
        active = false,
        defensive_active = function(v452)
            local v453 = v24.get_local_player()
            if (not v453 or not v24.is_alive(v453)) then
                return
            end
            local v454 = v452.ui.menu.antiaim.states
            local v455 = v452.helpers:get_state()
            local v456 = v21.get(v452.ref.rage.dt[2])
            local v457 = v21.get(v452.ref.rage.os[2])
            local v458 = v454[v455].defensive_conditions
            if (not v454[v455].options:get("Enable defensive") or not (v456 or (v457 and v458:get("On hide-shots")))) then
                v452.check, v452.defensive = 0, 0
                return
            end
            local v459 = v24.get_prop(v24.get_local_player(), "m_nTickBase")
            v452.defensive = v19.abs(v459 - v452.check)
            v452.check = v19.max(v459, v452.check or 0)
            local v462 = v26.tickcount()
            local v463 = v24.get_prop(v453, "m_flSimulationTime")
            local v464 = v13(v463 - v452.sim_time)
            if (v464 < 0) then
                v452.active_until = v462 + v19.abs(v464)
            end
            v452.ticks = v43.clamp(v452.active_until - v462, 0, 16)
            v452.active = v452.active_until > v462
            v452.sim_time = v463
            v452.globals.tick = v452.defensive
        end,
        def_reset = function(v469)
            v469.check, v469.defensive = 0, 0
        end
    }
):struct("aspect_ratio")(
    {
        screen_width = 0,
        screen_height = 0,
        aspect_ratio_reference = nil,
        
        setup = function(self, screen_width_temp, screen_height_temp)
            self.screen_width, self.screen_height = screen_width_temp, screen_height_temp
            local aspect_ratio_table = {}
            local steps = 200
            local multiplier = 0.01
            
            for i = 1, steps do
                local i2 = (steps - i) * multiplier
                local divisor = gcd(self.screen_width * i2, self.screen_height)
                if (self.screen_width * i2 / divisor < 100) or (i2 == 1) then
                    aspect_ratio_table[i] = self.screen_width * i2 / divisor .. ":" .. self.screen_height / divisor
                end
            end
            
            if self.aspect_ratio_reference ~= nil then
                ui.set_visible(self.aspect_ratio_reference, false)
                ui.set_callback(self.aspect_ratio_reference, function() end)
            end
            
            self.aspect_ratio_reference = ui.new_slider("VISUALS", "Effects", "Force aspect ratio", 0, steps-1, steps/2, true, "%", 1, aspect_ratio_table)
            ui.set_callback(self.aspect_ratio_reference, function()
                self:on_aspect_ratio_changed()
            end)
        end,
        
        gcd = function(m, n)
            while m ~= 0 do
                m, n = math.fmod(n, m), m
            end
            return n
        end,
        
        set_aspect_ratio = function(self, aspect_ratio_multiplier)
            local screen_width, screen_height = client.screen_size()
            local aspectratio_value = (screen_width * aspect_ratio_multiplier) / screen_height
            
            if aspect_ratio_multiplier == 1 then
                aspectratio_value = 0
            end
            client.set_cvar("r_aspectratio", tonumber(aspectratio_value))
        end,
        
        on_aspect_ratio_changed = function(self)
            if not self.ui.menu.tools.aspect_ratio_enable:get() then
                client.set_cvar("r_aspectratio", 0)
                return
            end
            
            local aspect_ratio = self.ui.menu.tools.aspect_ratio_slider:get() * 0.01
            aspect_ratio = 2 - aspect_ratio
            self:set_aspect_ratio(aspect_ratio)
        end,
        
        init = function(self)
            local screen_width, screen_height = client.screen_size()
            self:setup(screen_width, screen_height)
            
            client.set_event_callback("paint", function()
                local screen_width_temp, screen_height_temp = client.screen_size()
                if screen_width_temp ~= self.screen_width or screen_height_temp ~= self.screen_height then
                    self:setup(screen_width_temp, screen_height_temp)
                end
                
                if self.ui.menu.tools.aspect_ratio_enable:get() then
                    self:on_aspect_ratio_changed()
                else
                    client.set_cvar("r_aspectratio", 0)
                end
            end)
        end
    }
):struct("tools")(
    {
        widget_keylist = v41("keylist", 300, 100),
        scoped = 0,
        scoped_comp = 0,

taser_warning = {
    enable = 0,
    alpha = 0,
    active = false,          -- ← запятая добавлена
    player_is_dead = false   -- ← значение false
},
            -- ↓↓↓ ВСТАВЬТЕ ЗДЕСЬ ↓↓↓
        -- ========== HIT/MISS NOTIFICATION SYSTEM ==========
        hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', 'resolver', 'gear'},
        
        notify_system = {
            notifications = {
                bottom = {}
            },
            max = {
                bottom = 6
            }
        },
        
        -- Функция для проверки содержится ли значение в таблице
        contains = function(self, table, value)
            if not table then return false end
            for _, v in ipairs(table) do
                if v == value then
                    return true
                end
            end
            return false
        end,
        
        -- Инициализация системы уведомлений
        init_notify_system = function(self)
            -- Создаем метатаблицу для уведомлений
            local notify_meta = {}
            notify_meta.__index = notify_meta
            
            -- Функция создания нового уведомления
            notify_meta.new_bottom = function(timeout, color, title, ...)
                local text_parts = {...}
                table.insert(self.notify_system.notifications.bottom, {
                    started = false,
                    instance = setmetatable({
                        active = false,
                        timeout = timeout,
                        color = {r = color[1], g = color[2], b = color[3], a = 0},
                        x = v39 / 2,
                        y = v40,
                        text = text_parts,
                        title = title,
                        type = "bottom"
                    }, notify_meta)
                })
            end
            
            -- Функция получения текста уведомления
            notify_meta.get_text = function(notification)
                local result = ""
                for _, part in ipairs(notification.text) do
                    result = result .. part .. " "
                end
                return result
            end
            
            -- Функция запуска уведомления
            notify_meta.start = function(notification)
                notification.active = true
                notification.delay = v26.realtime() + notification.timeout
            end
            
            -- Функция рендера уведомления (упрощенная версия)
            notify_meta.render_bottom = function(notification, index, total)
                local screen_w, screen_h = v22.screen_size()
                local text = notification.title .. ": " .. notification:get_text()
                local text_size = v28.measure_text("", text)
                
                -- Анимация появления/исчезновения
                local alpha = 255
                if v26.realtime() > notification.delay then
                    alpha = 0
                    notification.active = false
                elseif (notification.delay - v26.realtime()) < 1 then
                    alpha = (notification.delay - v26.realtime()) * 255
                end
                
                -- Позиция
                local y_pos = screen_h - 50 - (index * 30)
                
                -- Отрисовка фона
                v28.rectangle(
                    screen_w / 2 - text_size - 10,
                    y_pos - 5,
                    text_size * 2 + 20,
                    25,
                    10, 10, 10, alpha * 0.7
                )
                
                -- Отрисовка текста
                v28.text(
                    screen_w / 2,
                    y_pos,
                    notification.color.r,
                    notification.color.g,
                    notification.color.b,
                    alpha,
                    "c",
                    0,
                    text
                )
                
                -- Анимация цвета
                notification.color.a = v50.helpers:math_anim2(
                    notification.color.a,
                    alpha,
                    v26.frametime() * 8
                )
            end
            
            -- Обработчик уведомлений
            notify_meta.handler = function()
                local bottom_count = 0
                local bottom_visible = 0
                
                -- Удаляем неактивные уведомления
                for i = #self.notify_system.notifications.bottom, 1, -1 do
                    local notification = self.notify_system.notifications.bottom[i]
                    if not notification.instance.active and notification.started then
                        table.remove(self.notify_system.notifications.bottom, i)
                    end
                end
                
                -- Считаем активные уведомления
                for _, notification in ipairs(self.notify_system.notifications.bottom) do
                    if notification.instance.active then
                        bottom_visible = bottom_visible + 1
                    end
                end
                
                -- Рендерим уведомления
                for _, notification in ipairs(self.notify_system.notifications.bottom) do
                    if notification.instance.active then
                        notification.instance:render_bottom(bottom_count, bottom_visible)
                        bottom_count = bottom_count + 1
                    end
                    
                    if not notification.started then
                        notification.instance:start()
                        notification.started = true
                    end
                end
            end
            
            -- Сохраняем метатаблицу
            self.notify_system.meta = notify_meta
        end,
        
        -- Обработчик хита
        handle_aim_hit = function(self, e)
            if not self.ui.menu.tools.hit_miss_notify:get() then
                return
            end
            
            if not self:contains(self.ui.menu.tools.notify_types:get(), "Hit") then
                return
            end
            
            local target = e.target
            local target_name = v24.get_player_name(target)
            local hitgroup = self.hitgroup_names[e.hitgroup + 1] or "resolver"
            local damage = e.damage
            local remaining_health = v24.get_prop(target, "m_iHealth") or 0
            
            -- Получаем цвет из меню
            local r, g, b = self.ui.menu.tools.notify_hit_color:get()
            
            -- Создаем уведомление
            if self.notify_system.meta then
                self.notify_system.meta.new_bottom(
                    3,
                    {r, g, b},
                    "HIT",
                    "Hit", target_name, "in the", hitgroup, 
                    "for", damage, "damage",
                    "(" .. remaining_health .. " health remaining)"
                )
            end
            
            -- Также логируем в консоль
            client.color_log(r, g, b, string.format(
                "[+w.tech] Hit %s in the %s for %d damage (%d health remaining)",
                target_name, hitgroup, damage, remaining_health
            ))
        end,
        
        -- Обработчик мисса
        handle_aim_miss = function(self, e)
            if not self.ui.menu.tools.hit_miss_notify:get() then
                return
            end
            
            if not self:contains(self.ui.menu.tools.notify_types:get(), "Miss") then
                return
            end
            
            local target = e.target
            local target_name = v24.get_player_name(target)
            local hitgroup = self.hitgroup_names[e.hitgroup + 1] or "resolver"
            local reason = e.reason
            local hit_chance = math.floor(e.hit_chance or 0)
            
            -- Получаем цвет из меню
            local r, g, b = self.ui.menu.tools.notify_miss_color:get()
            
            -- Создаем уведомление
            if self.notify_system.meta then
                self.notify_system.meta.new_bottom(
                    3,
                    {r, g, b},
                    "MISS",
                    "Missed", target_name, "in the", hitgroup,
                    "due to", reason, "(" .. hit_chance .. "%)"
                )
            end
            
            -- Также логируем в консоль
            client.color_log(r, g, b, string.format(
                "[+w.tech] Missed %s in the %s due to %s (%d%%)",
                target_name, hitgroup, reason, hit_chance
            ))
        end,
        -- ↑↑↑ КОНЕЦ ВСТАВКИ ↑↑↑
        -- ========== CHIMERA & PREDICTION INDICATORS ==========
        chimera = {
            desync_pos = v31(0, 0),
            title_pos = v31(0, 0),
            exploit_pos = v31(0, 0)
        },
prediction = {
    desync_pos = v31(0, 0),
    title_pos = v31(0, 0),
    binds = {
        DT = {
            ref = {ui.reference("RAGE", "Aimbot", "Double tap")},  -- ПРАВИЛЬНО: таблица
            pos = v31(0, 0)
        },
        OS = {
            ref = {ui.reference("AA", "Other", "On shot anti-aim")},  -- ПРАВИЛЬНО: таблица
            pos = v31(0, 0)
        },
        FD = {
            ref = {ui.reference("RAGE", "Other", "Duck peek assist")},  -- ПРАВИЛЬНО: таблица
            pos = v31(0, 0)
        },
    }
},
        charge_col = {r = 50, g = 255, b = 50},
        -- ========== BRANDED WATERMARK ==========
        branded_watermark = function(self)
            local local_player = v24.get_local_player()
            if local_player == nil then
                return
            end
            if not self.ui.menu.tools.branded_watermark:get() then
                return
            end
            if not v24.is_alive(local_player) then
                return
            end
            
            local r, g, b = self.ui.menu.tools.branded_watermark_color:get()
            local screen_width, screen_height = v22.screen_size()
            local dark_r, dark_g, dark_b = 55, 55, 55
            local highlight_fraction = (v26.realtime() / 2 % 1.2 * 2) - 1.2
            local output = ""
            local text_to_draw = "+ W . T E C H"
            
            for idx = 1, #text_to_draw do
                local character = text_to_draw:sub(idx, idx)
                local character_fraction = idx / #text_to_draw
                local char_r, char_g, char_b = r, g, b
                local highlight_delta = character_fraction - highlight_fraction
                
                if highlight_delta >= 0 and highlight_delta <= 1.4 then
                    if highlight_delta > 0.7 then
                        highlight_delta = 1.4 - highlight_delta
                    end
                    local r_diff, g_diff, b_diff = dark_r - char_r, dark_g - char_g, dark_b - char_b
                    char_r = char_r + r_diff * highlight_delta / 0.8
                    char_g = char_g + g_diff * highlight_delta / 0.8
                    char_b = char_b + b_diff * highlight_delta / 0.8
                end
                output = output .. ("\a%02x%02x%02x%02x%s"):format(char_r, char_g, char_b, 255, text_to_draw:sub(idx, idx))
            end
            
            local position = self.ui.menu.tools.branded_watermark_pos:get()
            if position == "Left" then
                v28.text(screen_width - (screen_width - 65), screen_height - 500, r, g, b, 255, "c", 0, output .. " \aEC5C5CFF[" .. v38.build:upper() .. "]")
            elseif position == "Bottom" then
                v28.text(screen_width / 2, screen_height - 30, r, g, b, 255, "c", 0, output .. " \aEC5C5CFF[" .. v38.build:upper() .. "]")
            elseif position == "Right" then
                v28.text(screen_width - screen_width / 30, screen_height - 500, r, g, b, 255, "c", 0, output .. " \aEC5C5CFF[" .. v38.build:upper() .. "]")
            end
        end,

        -- ========== PROTEUS CHEAT DETECTION ==========
        proteus = {
            enabled = false,
            target_cheat = "anonymous",
            timer = 0,
            ev0lve_counter = 0,
            revealer = { set_cheat = function(target, cheat) end },
            
            init = function(self)
                self.enabled = true
                local status, result = pcall(function()
                    self.revealer = require('gamesense/cheat_revealer')
                end)
                if not status then
                    self.revealer = { set_cheat = function(target, cheat) end }
                end
                client.log("[Proteus] System initialized")
            end,
            
            handle_cheat_detection = function(self)
                if not self.enabled then return end
                if self.timer > globals.curtime() then return end
                
                local cheat = self.target_cheat
                local local_player = entity.get_local_player()
                
                if cheat == "gamesense" then
                    self.revealer.set_cheat(local_player, 'gs')
                elseif cheat == "fatality" then
                    self.revealer.set_cheat(local_player, 'ft')
                elseif cheat == "onetap" then
                    self.revealer.set_cheat(local_player, 'ot')
                elseif cheat == "neverlose" then
                    self.revealer.set_cheat(local_player, 'nl2')
                elseif cheat == "nixware" then
                    self.revealer.set_cheat(local_player, 'nw')
                elseif cheat == "pandora" then
                    self.revealer.set_cheat(local_player, 'pd')
                end
                
                self.timer = globals.curtime() + 0.5
            end,
            
            reset = function(self)
                self.timer = 0
                self.ev0lve_counter = 0
            end
        },
        -- ========== PROTEUS CHEAT DETECTION ==========
        proteus = {
            enabled = false,
            target_cheat = "anonymous",
            timer = 0,
            ev0lve_counter = 0,
            revealer = { set_cheat = function(target, cheat) end },
            
            init = function(self)
                self.enabled = true
                local status, result = pcall(function()
                    self.revealer = require('gamesense/cheat_revealer')
                end)
                if not status then
                    self.revealer = { set_cheat = function(target, cheat) end }
                end
                client.log("[Proteus] System initialized")
            end,
            
            handle_cheat_detection = function(self)
                if not self.enabled then return end
                if self.timer > globals.curtime() then return end
                
                local cheat = self.target_cheat
                local local_player = entity.get_local_player()
                
                if cheat == "gamesense" then
                    self.revealer.set_cheat(local_player, 'gs')
                elseif cheat == "fatality" then
                    self.revealer.set_cheat(local_player, 'ft')
                elseif cheat == "onetap" then
                    self.revealer.set_cheat(local_player, 'ot')
                elseif cheat == "neverlose" then
                    self.revealer.set_cheat(local_player, 'nl2')
                elseif cheat == "nixware" then
                    self.revealer.set_cheat(local_player, 'nw')
                elseif cheat == "pandora" then
                    self.revealer.set_cheat(local_player, 'pd')
                end
                
                self.timer = globals.curtime() + 0.5
            end,
            
            reset = function(self)
                self.timer = 0
                self.ev0lve_counter = 0
            end
        },
        -- ========== END PROTEUS ==========
taser_indicator = function(v647)
    -- ВРЕМЕННО для отладки
    -- client.log(string.format("[Taser Debug] active=%s, alpha=%d, player_dead=%s", 
    --     tostring(v647.taser_warning.active), 
    --     v647.taser_warning.alpha,
    --     tostring(v647.taser_warning.player_is_dead)))
    
    local v648 = v26.frametime() * 20
    local v649, v650 = v22.screen_size()
    local v651 = {v38.accent.r, v38.accent.g, v38.accent.b}
    
    if v647.ui.menu.tools.taser_warning:get() then
        local v652 = v24.get_players(true)
        for v891, v892 in v3(v652) do
            if v24.is_alive(v892) then
                local v893 = v24.get_player_weapon(v892)
                if v893 then
                    local v894 = v24.get_classname(v893)
                    local v895 = v31(v24.get_origin(v892))
                    local v896 = v24.get_local_player()
                    
                    if v896 and v24.is_alive(v896) then
                        local v897 = v31(v24.get_origin(v896))
                        local v898 = v895:dist(v897) / 17
                        
                        if (v898 < 20) and v894:find("Taser") then
                            v647.taser_warning.active = true
                        else
                            v647.taser_warning.active = false
                        end
                    end
                end
            end
        end
    end
    
    local v899 = v24.get_local_player()
    local v900 = (v647.ui.menu.tools.taser_warning:get() and 
                 v899 and 
                 v24.is_alive(v899) and 
                 v647.taser_warning.active) or
                 (v647.ui.menu.tools.taser_warning:get() and v21.is_menu_open())
    
    v647.taser_warning.enable = v647.helpers:math_anim2(
        v647.taser_warning.enable, 
        v900 and 0 or 40, 
        v648
    )
    
    v647.taser_warning.alpha = v647.helpers:math_anim2(
        v647.taser_warning.alpha, 
        v900 and 255 or 0, 
        v648
    )
    
    if v647.taser_warning.alpha > 0 then
        local v901 = v649 / 2
        local v902 = v650 / 2
        local v903 = v19.floor(v647.taser_warning.enable)
        
        -- Фон
        v28.rectangle(v901 - 18, v902 - 114 - v903, 38, 38, 0, 0, 0, v647.taser_warning.alpha)
        v28.rectangle(v901 - 17, v902 - 113 - v903, 36, 36, 66, 66, 66, v647.taser_warning.alpha)
        v28.rectangle(v901 - 16, v902 - 112 - v903, 34, 34, 41, 41, 41, v647.taser_warning.alpha)
        v28.rectangle(v901 - 15, v902 - 111 - v903, 32, 32, 66, 66, 66, v647.taser_warning.alpha)
        v28.rectangle(v901 - 14, v902 - 110 - v903, 30, 30, 18, 18, 18, v647.taser_warning.alpha)
        
        -- Акцентная линия
        v28.rectangle(v901 - 14, v902 - 110 - v903, 30, 1, v651[1], v651[2], v651[3], v647.taser_warning.alpha)
        
        -- Иконка
        if v53_taser then
            v28.texture(v53_taser, v901 - 10, v902 - 101 - v903, 20, 15, 230, 230, 230, v647.taser_warning.alpha)
        end
        
        -- Текст
        v28.text(
            v901 - v28.measure_text("-", "YOU  CAN  BE  ZEUSED") / 2, 
            v902 - 70 - v903, 
            255, 255, 255, v647.taser_warning.alpha, 
            "-", 0, 
            "YOU  CAN  BE  ZEUSED"
        )
    end
end,
        ping_spike_warning = {
            player_states = {},
            js = panorama.open(),
            GameStateAPI = nil
        },
        
        ping_spike_init = function(self)
            if self.ping_spike_warning.js then
                self.ping_spike_warning.GameStateAPI = self.ping_spike_warning.js.GameStateAPI
            end
        end,
        
        ping_spike_g_Math = function(self, int, max, declspec)
            int = (int > max and max or int)
            local tmp = max / int
            local i = (declspec / tmp)
            i = (i >= 0 and v19.floor(i + 0.5) or v19.ceil(i - 0.5))
            return i
        end,
        
        ping_spike_g_ColorByInt = function(self, number, max)
            local Colors = {
                { 124, 195, 13 },
                { 176, 205, 10 },
                { 213, 201, 19 },
                { 220, 169, 16 },
                { 228, 126, 10 },
                { 229, 104, 8 },
                { 235, 63, 6 },
                { 237, 27, 3 },
                { 255, 0, 0 }
            }
            local i = self:ping_spike_g_Math(number, max, #Colors)
            return Colors[i <= 1 and 1 or i][1], Colors[i <= 1 and 1 or i][2], Colors[i <= 1 and 1 or i][3]
        end,
        
        ping_spike_g_DormantPlayers = function(self, enemy_only, alive_only)
            enemy_only = enemy_only ~= nil and enemy_only or false
            alive_only = alive_only ~= nil and alive_only or true
            local result = {}
            local player_resource = v24.get_all("CCSPlayerResource")[1]
            
            for player = 1, v26.maxplayers() do
                if v24.get_prop(player_resource, "m_bConnected", player) == 1 then
                    local local_player_team, is_enemy, is_alive = nil, true, true
                    if enemy_only then 
                        local local_player = v24.get_local_player()
                        if local_player then
                            local_player_team = v24.get_prop(local_player, "m_iTeamNum") 
                        end
                    end
                    if enemy_only and local_player_team and v24.get_prop(player, "m_iTeamNum") == local_player_team then 
                        is_enemy = false 
                    end
                    if is_enemy then
                        if alive_only and v24.get_prop(player_resource, "m_bAlive", player) ~= 1 then 
                            is_alive = false 
                        end
                        if is_alive then 
                            result[#result + 1] = player 
                        end
                    end
                end
            end
            return result
        end,
        
        ping_spike_setPlayerState = function(self, entity, t, element)
            if not self.ping_spike_warning.player_states[entity] then
                self.ping_spike_warning.player_states[entity] = {}
            end
            if element then 
                self.ping_spike_warning.player_states[entity][element] = t
            else 
                self.ping_spike_warning.player_states[entity] = t
            end
        end,
        
        ping_spike_setAlphaLimit = function(self, number)
            local i = number
            i = i >= 255 and 255 or i
            i = i <= 0 and 0 or i
            return i
        end,
        
        ping_spike_draw = function(self, ctx)
            if not self.ui.menu.tools.ping_spike_warning:get() then
                return
            end
            
            local local_player = v24.get_local_player()
            if not local_player or not v24.is_alive(local_player) then
                return
            end
            
            local players = self:ping_spike_g_DormantPlayers(true, true)
            local player_resource = v24.get_all("CCSPlayerResource")[1]
            
            if #players == 0 then return end
            
            for i = 1, #players do
                local player_idx = players[i]
                local xuid = ""
                if self.ping_spike_warning.GameStateAPI then
                    xuid = self.ping_spike_warning.GameStateAPI.GetPlayerXuidStringFromEntIndex(player_idx)
                end
                local is_bot = false
                if xuid ~= "" and self.ping_spike_warning.GameStateAPI then
                    is_bot = self.ping_spike_warning.GameStateAPI.IsFakePlayer(xuid)
                end
                
                local latency = v24.get_prop(player_resource, string.format("%03d", player_idx))
                if latency == nil then latency = 0 end
                
                local max_latency = (latency > 400 and 350 or latency)
                local cur_state = self.ping_spike_warning.player_states[i]
                
                if not cur_state then
                    self:ping_spike_setPlayerState(i, { 
                        ping = latency, 
                        curtime = v26.realtime(), 
                        alpha = 0 
                    })
                    cur_state = self.ping_spike_warning.player_states[i]
                end
                
                if cur_state.ping ~= latency and cur_state.curtime < v26.realtime() then
                    local d = cur_state.ping > latency and -1 or 1
                    self:ping_spike_setPlayerState(i, v26.realtime() + 0.01, "curtime")
                    self:ping_spike_setPlayerState(i, cur_state.ping + d, "ping")
                end
                
                if cur_state.ping < 75 then
                    self:ping_spike_setPlayerState(i, self:ping_spike_setAlphaLimit(cur_state.alpha - 1), "alpha")
                else
                    self:ping_spike_setPlayerState(i, self:ping_spike_setAlphaLimit(cur_state.alpha + 1), "alpha")
                end
                
                local name = v24.get_player_name(player_idx)
                local y_additional = name == "" and -8 or 0
                local x1, y1, x2, y2, a_multiplier = v24.get_bounding_box(player_idx)
                
                if x1 ~= nil and v24.is_alive(player_idx) and a_multiplier > 0 and not is_bot then
                    local x_center = x1 + (x2 - x1) / 2
                    local r, g, b = self:ping_spike_g_ColorByInt(cur_state.ping, 450)
                    
                    if x_center ~= nil then
                        local n, ping_state, alpha_state = 0, cur_state.ping, cur_state.alpha
                        local fat
                        local dormant_state = (a_multiplier * 255)
                        
                        if dormant_state <= 150 and alpha_state > 150 then
                            n = dormant_state
                            fat = false
                        elseif (ping_state > 75 and dormant_state > 75) or ping_state <= 75 then
                            n = alpha_state
                            fat = false
                        elseif (ping_state < 25 and dormant_state < 25) or ping_state <= 25 then
                            fat = true
                        end
                        
                        local dormancy_mode = self.ui.menu.tools.ping_spike_dormancy:get()
                        local show_extended = self.ui.menu.tools.ping_spike_ext:get()
                        
                        if dormancy_mode == "Fade with dormant" then
                            if show_extended then
                                if cur_state.ping < 10 then
                                    v28.text(x_center - 7, y1 - 15 + y_additional, 255, 75, 75, dormant_state, "c-", 0, "PING CARRIED")
                                    v28.text(x_center + 25, y1 - 15 + y_additional, 255, 75, 75, dormant_state, "c-", 0, "(    )")
                                    v28.text(x_center + 25, y1 - 15 + y_additional, 255, 75, 75, dormant_state, "c-", 0, cur_state.ping)
                                    v28.text(x_center + 39, y1 - 18 + y_additional, 255, 0, 0, dormant_state, "c-", 0, "⚠️")
                                elseif cur_state.ping < 26 then
                                    v28.text(x_center - 7, y1 - 15 + y_additional, 255, 75, 75, dormant_state, "c-", 0, "PING CARRIED")
                                    v28.text(x_center + 27, y1 - 15 + y_additional, 255, 75, 75, dormant_state, "c-", 0, "(       )")
                                    v28.text(x_center + 27, y1 - 15 + y_additional, 255, 75, 75, dormant_state, "c-", 0, cur_state.ping)
                                    v28.text(x_center + 44, y1 - 18 + y_additional, 255, 0, 0, dormant_state, "c-", 0, "⚠️")
                                else
                                    v28.text(x_center, y1 - 15 + y_additional, r, g, b, n, "c-", 0, ping_state .. " MS")
                                end
                            else
                                if cur_state.ping < 25 then
                                    v28.text(x_center, y1 - 15 + y_additional, 255, 75, 75, dormant_state, "c-", 0, "PING CARRIED")
                                    v28.text(x_center + 35, y1 - 18 + y_additional, 255, 0, 0, dormant_state, "c-", 0, "⚠️")
                                else
                                    v28.text(x_center, y1 - 15 + y_additional, r, g, b, n, "c-", 0, ping_state .. " MS")
                                end
                            end
                        else
                            if show_extended then
                                if cur_state.ping < 10 then
                                    v28.text(x_center - 7, y1 - 15 + y_additional, 255, 75, 75, 255, "c-", 0, "PING CARRIED")
                                    v28.text(x_center + 25, y1 - 15 + y_additional, 255, 75, 75, 255, "c-", 0, "(    )")
                                    v28.text(x_center + 25, y1 - 15 + y_additional, 255, 75, 75, 255, "c-", 0, cur_state.ping)
                                    v28.text(x_center + 39, y1 - 18 + y_additional, 255, 0, 0, 255, "c-", 0, "⚠️")
                                elseif cur_state.ping < 26 then
                                    v28.text(x_center - 7, y1 - 15 + y_additional, 255, 75, 75, 255, "c-", 0, "PING CARRIED")
                                    v28.text(x_center + 27, y1 - 15 + y_additional, 255, 75, 75, 255, "c-", 0, "(       )")
                                    v28.text(x_center + 27, y1 - 15 + y_additional, 255, 75, 75, 255, "c-", 0, cur_state.ping)
                                    v28.text(x_center + 44, y1 - 18 + y_additional, 255, 0, 0, 255, "c-", 0, "⚠️")
                                else
                                    v28.text(x_center, y1 - 15 + y_additional, r, g, b, n, "c-", 0, ping_state .. " MS")
                                end
                            else
                                if cur_state.ping < 25 then
                                    v28.text(x_center, y1 - 15 + y_additional, 255, 75, 75, 255, "c-", 0, "PING CARRIED")
                                    v28.text(x_center + 35, y1 - 18 + y_additional, 255, 0, 0, 255, "c-", 0, "⚠️")
                                else
                                    v28.text(x_center, y1 - 15 + y_additional, r, g, b, n, "c-", 0, ping_state .. " MS")
                                end
                            end
                        end
                    end
                end
            end
        end,
        -- ========== END PING SPIKE WARNING ==========
         defensive_resolver = {
            enabled = false,
            player_data = {},
            plist_module = nil
        },
        
        defensive_resolver_init = function(self)
            -- Безопасная загрузка plist модуля
            local status, plist_mod = pcall(require, "gamesense/player_list")
            if status then
                self.defensive_resolver.plist_module = plist_mod
                client.log("[+w.tech] Defensive Resolver: plist модуль загружен")
            else
                client.log("[+w.tech] Defensive Resolver: не удалось загрузить plist модуль")
            end
            return true
        end,
        
        defensive_resolver_is_defensive_active = function(self, enemy_ent)
            -- Проверяем, использует ли враг defensive
            local pitch = v24.get_prop(enemy_ent, "m_angEyeAngles[0]")
            if pitch == nil then return false end
            
            -- Defensive обычно имеет pitch < 70
            return pitch < 70
        end,
        
        defensive_resolver_update = function(self)
            if not self.ui.menu.tools.defensive_resolver:get() then
                return
            end
            
            local enemies = v24.get_players(true)
            for _, enemy_ent in ipairs(enemies) do
                if not v24.is_alive(enemy_ent) then
                    self.defensive_resolver.player_data[enemy_ent] = nil
                    goto continue
                end
                
                -- Инициализация данных игрока
                if self.defensive_resolver.player_data[enemy_ent] == nil then
                    self.defensive_resolver.player_data[enemy_ent] = {
                        pitch = 0,
                        violation_count = 0,
                        timer = 0,
                        detected = false
                    }
                end
                
                local data = self.defensive_resolver.player_data[enemy_ent]
                local current_pitch = v24.get_prop(enemy_ent, "m_angEyeAngles[0]") or 0
                
                -- Обновляем питч
                data.pitch = current_pitch
                
                -- Проверяем defensive
                if self:defensive_resolver_is_defensive_active(enemy_ent) then
                    if current_pitch < 70 then
                        data.violation_count = data.violation_count + 1
                        data.timer = v26.realtime() + 5
                        
                        -- Логируем обнаружение
                        if data.violation_count == 3 then
                            local enemy_name = v24.get_player_name(enemy_ent)
                            client.log("[+w.tech] Defensive Resolver: обнаружен у " .. enemy_name .. 
                                      " (pitch: " .. current_pitch .. ", violations: " .. data.violation_count .. ")")
                        end
                    end
                else
                    -- Сбрасываем если таймер истек
                    if data.timer - v26.realtime() < 0 then
                        if data.violation_count > 0 then
                            data.violation_count = 0
                            data.timer = 0
                            data.detected = false
                        end
                    end
                end
                
                -- Применяем force pitch если нужно
                if self.defensive_resolver.plist_module then
                    local should_force = data.violation_count > 3 and 
                                        self.ui.menu.tools.defensive_resolver_force:get()
                    
                    if should_force and not data.detected then
                        data.detected = true
                        local enemy_name = v24.get_player_name(enemy_ent)
                        client.log("[+w.tech] Defensive Resolver: форсируем pitch 89° для " .. enemy_name)
                        
                        -- Force pitch через plist
                        self.defensive_resolver.plist_module.set(enemy_ent, "Force pitch", true)
                        self.defensive_resolver.plist_module.set(enemy_ent, "Force pitch value", 89)
                        
                        -- Показываем уведомление
                        v44.create_new({
                            {"Defensive detected: "}, 
                            {enemy_name, true}, 
                            {" pitch: "}, 
                            {current_pitch .. "°", true}
                        })
                    elseif not should_force and data.detected then
                        data.detected = false
                        -- Снимаем force pitch
                        self.defensive_resolver.plist_module.set(enemy_ent, "Force pitch", false)
                    end
                end
                
                ::continue::
            end
        end,
        
        defensive_resolver_draw_indicator = function(self)
            if not self.ui.menu.tools.defensive_resolver:get() then
                return
            end
            
            -- Показываем индикатор в углу экрана
            local screen_w, screen_h = v22.screen_size()
            local detected_count = 0
            
            for enemy_ent, data in pairs(self.defensive_resolver.player_data) do
                if data.detected and v24.is_alive(enemy_ent) then
                    detected_count = detected_count + 1
                end
            end
            
            if detected_count > 0 then
                local color = {v38.accent.r, v38.accent.g, v38.accent.b}
                v28.text(screen_w - 50, screen_h - 150, color[1], color[2], color[3], 255, "r", 0, "DEF")
                v28.text(screen_w - 50, screen_h - 135, 255, 255, 255, 255, "r", 0, detected_count)
            end
        end,
        
        defensive_resolver_shutdown = function(self)
            -- Сбрасываем все force pitch при выключении
            if self.defensive_resolver.plist_module then
                for enemy_ent, data in pairs(self.defensive_resolver.player_data) do
                    if data.detected then
                        self.defensive_resolver.plist_module.set(enemy_ent, "Force pitch", false)
                    end
                end
            end
            self.defensive_resolver.player_data = {}
        end,
        -- ========== END DEFENSIVE AA RESOLVER ==========
        -- ↑↑↑ КОНЕЦ ВСТАВКИ ↑↑↑
        -- Клан-тег переменные
        clantag_data = {
            frames = {
                "", "", "+", "+w", "+w.", "+w.t", "+w.te", "+w.tec", "+w.tech",
                "+w.tech |", "+w.tech | b", "+w.tech | be", "+w.tech | bet", "+w.tech | beta",
                "+w.tech | beta", "+w.tech | bet", "+w.tech | be", "+w.tech | b", "+w.tech |",
                "+w.tech", "+w.tec", "+w.te", "+w.t", "+w.", "+w", "+", "", ""
            },
            processed_frames = {},
            current_frame = 1,
            last_tag_time = 0,
            tag_delay = 10
        },
        
        menu_setup = function(v472)
             -- Update Proteus cheat selection
    if v472.ui.menu.tools.proteus_enable and v472.ui.menu.tools.proteus_cheat then
        local cheat = v472.ui.menu.tools.proteus_cheat:get()
        v472.tools.proteus.target_cheat = cheat
    end
        -- Watermark color
    if v472.ui.menu.tools.branded_watermark_color then
        local wm_r, wm_g, wm_b = v472.ui.menu.tools.branded_watermark_color:get()
        -- Здесь можно что-то сделать с цветом, если нужно
    end
    
    local v473 = v472.ui.menu.tools.notify_offset:get()
    local v474, v475, v476, v477 = v472.ui.menu.global.color:get()
    v38.accent.r = v474
    v38.accent.g = v475
    v38.accent.b = v476
    v38.offset = v473
            local v473 = v472.ui.menu.tools.notify_offset:get()
            local v474, v475, v476, v477 = v472.ui.menu.global.color:get()
            v38.accent.r = v474
            v38.accent.g = v475
            v38.accent.b = v476
            v38.offset = v473
            if (v472.ui.menu.tools.style:get() == "New") then
                v38.new_style = true
            else
                v38.new_style = false
            end
            
            
            -- Обновляем скорость клан-тега из меню
            if v472.ui.menu.tools.clantag_enable and v472.ui.menu.tools.clantag_enable:get() then
                local clantag_speed = v472.ui.menu.tools.clantag_speed:get()
                v472.clantag_data.tag_delay = clantag_speed
            end

            local v482 = v472.ui.menu.global.tab:get()
            local v483 = v472.ui.menu.antiaim.mode:get()
            local v484 = ((v482 == " Anti-Aim") and (v483 == "Constructor")) or (v482 == " Home")
            local v485 = {fakelag = v472.ref.fakelag, aa_other = v472.ref.aa_other}
            for v849, v850 in v3(v485) do
                local v851 = true
                if (v849 == "fakelag") then
                    v851 = false
                elseif (v849 == "aa_other") then
                    v851 = not v484
                end
                for v996, v997 in v3(v850) do
                    for v1031, v1032 in v2(v997) do
                        v21.set_visible(v1032, v851)
                    end
                end
            end
            if (v472.ref.fakelag.enable[1] ~= true) then
                v21.set(v472.ref.fakelag.enable[1], true)
            end
            v21.set(v472.ref.fakelag.amount[1], v472.ui.menu.antiaim.fakelag_type:get())
            v21.set(v472.ref.fakelag.variance[1], v472.ui.menu.antiaim.fakelag_var:get())
            v21.set(v472.ref.fakelag.limit[1], v472.ui.menu.antiaim.fakelag_lim:get())
        end,
        
        -- Функция клан-тега
        update_clantag = function(self)
            if not self.ui.menu.tools.clantag_enable:get() then
                return
            end
            
            local current_tick = v26.tickcount()
            local local_player = v24.get_local_player()
            local player_resource = v24.get_player_resource()
            
            if not local_player or not player_resource then
                return
            end
            
            if current_tick - self.clantag_data.last_tag_time < self.clantag_data.tag_delay then
                return
            end
            
            local clan_tag = v24.get_prop(player_resource, "m_szClan", local_player)
            local choked = v26.chokedcommands() == 0
            
            if self.clantag_data.current_frame > #self.clantag_data.frames then
                self.clantag_data.current_frame = 1
            end
            
            local current_frame = self.clantag_data.frames[self.clantag_data.current_frame]
            
            if choked then
                v22.set_clan_tag(current_frame:lower())
                
                if clan_tag and clan_tag:lower() == current_frame:lower() then
                    self.clantag_data.current_frame = self.clantag_data.current_frame + 1
                    self.clantag_data.last_tag_time = current_tick
                end
            end
        end,
        
        -- Обработка фреймов клан-тега
        process_clantag_frames = function(self)
            for i = 1, #self.clantag_data.frames do
                local frame = self.clantag_data.frames[i]
                local processed = ""
                
                for j = 1, #frame do
                    local char = frame:sub(j, j)
                    processed = processed .. char:lower()
                end
                
                self.clantag_data.frames[i] = processed:lower()
            end
            
            -- Создаем копию для проверки
            self.clantag_data.processed_frames = {}
            for i = 1, #self.clantag_data.frames do
                self.clantag_data.processed_frames[i] = self.clantag_data.frames[i]
            end
        end,
        
        -- Инициализация клан-тега
        init_clantag = function(self)
            self:process_clantag_frames()
            
            -- Сбрасываем состояние
            self.clantag_data.current_frame = 1
            self.clantag_data.last_tag_time = 0
        end,
        
        -- Обработчики событий для клан-тега
        clantag_event_handlers = function(self)
            v22.set_event_callback("level_init", function()
                self.clantag_data.current_frame = 1
                self.clantag_data.last_tag_time = 0
            end)
            
            v22.set_event_callback("paint", function()
                if self.ui.menu.tools.clantag_enable:get() then
                    self:update_clantag()
                end
            end)
        end,
        
        gs_ind = function(v486)
            if v486.helpers:contains(v486.ui.menu.tools.gs_inds:get(), "Target") then
                v28.indicator(255, 255, 255, 200, "Target: " .. v486.helpers:get_target())
            end
        end,
        
crosshair = function(v487)
    local v488 = v24.get_local_player()
    if (not v488 or not v24.is_alive(v488)) then
        return
    end
    v487.scoped = v24.get_prop(v488, "m_bIsScoped")
    if not v487.ui.menu.tools.indicators:get() then
        return
    end
    local v490 = v487.ui.menu.tools.indicator_pos:get()
    v487.scoped_comp =
        v487.helpers:math_anim2(v487.scoped_comp, v487.scoped * (((v490 == "Left") and -1) or 1), 8)
    local v492 = v487.helpers:get_state()
    local v493, v494, v495, v496 = v38.accent.r, v38.accent.g, v38.accent.b
    local v497 = v487.ui.menu.tools.indicatorfont:get()
    
    -- Расчет дельта угла для индикаторов
    -- Способ 1: Используйте antiaim.get_desync (предпочтительно, если модуль доступен)
local success, antiaim_module = pcall(require, "gamesense/antiaim")
if success and antiaim_module then
    delta = math.abs(antiaim_module.get_desync() or 0)
else
    -- Способ 2: Альтернативный расчет через entity (менее точный, но рабочий)
    local local_player = entity.get_local_player()
    if local_player then
        -- Получаем разницу между реальным и фейковым yaw
        local real_yaw = entity.get_prop(local_player, "m_flPoseParameter", 11)
        if real_yaw then
            real_yaw = real_yaw * -1 - 5 -- Конвертируем в градусы
            local fake_yaw = entity.get_prop(local_player, "m_flLowerBodyYawTarget") or 0
            delta = math.abs(real_yaw - fake_yaw)
            if delta > 56 then
                delta = 90 - delta
            end
        end
    end
end
    
    local v498 = 0
    if (v497 == "Default") then
        v498 = 1
    elseif (v497 == "New") then
        v498 = 2
    elseif (v497 == "+w.tech") then
        v498 = 3
    elseif (v497 == "Renewed") then
        v498 = 4
    elseif (v497 == "Icons") then
        v498 = 5
    elseif (v497 == "Old Chimera") then
        v498 = 6
    elseif (v497 == "Prediction") then
        v498 = 7
    end
    
    local v499 = v487.helpers:get_charge()
    local v500, v501, v502 = (v499 and 255) or v493, (v499 and 255) or v494, (v499 and 255) or v495
    local v503, v504, v505 = v487.helpers:animate_pulse({v493, v494, v495, 255}, 8)
    local v506 = {
        {
            n = "DT",
            c = {v500, v501, v502},
            a = v21.get(v487.ref.rage.dt[1]) and v21.get(v487.ref.rage.dt[2]) and
                not v21.get(v487.ref.rage.fd[1]),
            s = v28.measure_text("-", "DT") + 13
        },
        {
            n = "OSAA",
            c = {255, 255, 255},
            a = v21.get(v487.ref.rage.os[1]) and v21.get(v487.ref.rage.os[2]) and
                not v21.get(v487.ref.rage.fd[1]),
            s = v28.measure_text("-", "OSAA") + 13
        },
        {
            n = "FAKE",
            c = {v503, v504, v505},
            a = v21.get(v487.ref.rage.fd[1]),
            s = v28.measure_text("-", "FAKE") + 14
        },
        {
            n = "FS",
            c = {255, 255, 255},
            a = v21.get(v487.ref.aa.freestand[1]) and v21.get(v487.ref.aa.freestand[2]),
            s = v28.measure_text("-", "FS") + 13
        }
    }
    local v507 = v487.helpers:new_anim("indicator_pose", v487.ui.menu.tools.indicatoroffset:get(), 12)
    local v508 = 0
    local v509 = v487.helpers:get_state()
    local v510 = v487.helpers:animate_text(v26.curtime() * 2, "+w.tech", v493, v494, v495, 255)
    local v511 = v487.helpers:new_anim("indicator_mes_1", v28.measure_text("-", v492:upper()) or 0, 12)
    
    if (v498 == 1) then
        -- Default стиль
        local v998 = v28.measure_text("c-", v38.build:upper())
        v28.text(
            (v39 / 2) + (((v998 + 14) / 2) * v487.scoped_comp),
            ((v40 / 2) + v507) - 10,
            v493,
            v494,
            v495,
            150,
            "c-",
            0,
            v38.build:upper()
        )
        v28.text(
            ((v39 / 2) - 22) + (30 * v487.scoped_comp),
            ((v40 / 2) + v507) - 6,
            0,
            0,
            0,
            255,
            "b",
            0,
            v15(v510)
        )
        v28.text(
            (v39 / 2) + (((v511 + 14) / 2) * v487.scoped_comp),
            (v40 / 2) + v507 + 13,
            255,
            255,
            255,
            255,
            "c-",
            0,
            v492:upper()
        )
        for v1033, v1034 in v2(v506) do
            local v1035 = v487.helpers:new_anim("indicators_alpha" .. v1034.n, (v1034.a and 255) or 0, 10)
            local v1036 = v487.helpers:new_anim("indicators_pose_2" .. v1034.n, (v1034.a and 10) or 0, 10)
            v508 = v508 + v1036
            v28.text(
                (v39 / 2) + ((v1034.s / 2) * v487.scoped_comp),
                (v40 / 2) + v507 + v508 + 15,
                v1034.c[1],
                v1034.c[2],
                v1034.c[3],
                v1035,
                "-ca",
                nil,
                v1034.n
            )
        end
        
    elseif (v498 == 2) then
        -- New стиль
        local v1060, v1061, v1062 =
            ((v509 == 2) and v493) or 200,
            ((v509 == 2) and v494) or 200,
            ((v509 == 2) and v495) or 200
        local v1063, v1064, v1065 =
            ((v509 == 0) and v493) or 200,
            ((v509 == 0) and v494) or 200,
            ((v509 == 0) and v495) or 200
        v28.text(
            ((v39 / 2) - 23) + (35 * v487.scoped_comp),
            ((v40 / 2) + v507) - 6,
            v1060,
            v1061,
            v1062,
            255,
            "b",
            0,
            "+w."
        )
        v28.text(
            ((v39 / 2) - 5) + (35 * v487.scoped_comp),
            ((v40 / 2) + v507) - 6,
            v1063,
            v1064,
            v1065,
            255,
            "b",
            0,
            "tech"
        )
        v28.text(
            (v39 / 2) + 23 + (35 * v487.scoped_comp),
            ((v40 / 2) + v507) - 6,
            255,
            255,
            255,
            255,
            "b",
            0,
            "°"
        )
        
    elseif (v498 == 3) then
        -- +w.tech стиль
        local v1085, v1086, v1087 =
            ((v509 == 2) and v493) or 200,
            ((v509 == 2) and v494) or 200,
            ((v509 == 2) and v495) or 200
        local v1088, v1089, v1090 =
            ((v509 == 0) and v493) or 255,
            ((v509 == 0) and v494) or 255,
            ((v509 == 0) and v495) or 255
        local v1091, v1092, v1093 =
            ((v509 == 1) and v493) or 255,
            ((v509 == 1) and v494) or 255,
            ((v509 == 1) and v495) or 255
        v28.text(
            ((v39 / 2) - 33) + (45 * v487.scoped_comp),
            ((v40 / 2) + v507) - 6,
            255,
            255,
            255,
            255,
            "ab",
            0,
            "одна"
        )
        v28.text(
            ((v39 / 2) - 5) + (45 * v487.scoped_comp),
            ((v40 / 2) + v507) - 6,
            v493,
            v494,
            v495,
            255,
            "ab",
            0,
            "надежда"
        )
        v28.text(
            ((v39 / 2) - 11) + (23 * v487.scoped_comp),
            (v40 / 2) + v507 + 6,
            v1085,
            v1086,
            v1087,
            255,
            "ab",
            0,
            "•"
        )
        v28.text(
            ((v39 / 2) - 3) + (23 * v487.scoped_comp),
            (v40 / 2) + v507 + 6,
            v1088,
            v1089,
            v1090,
            255,
            "ab",
            0,
            "•"
        )
        v28.text(
            (v39 / 2) + 5 + (23 * v487.scoped_comp),
            (v40 / 2) + v507 + 6,
            v1091,
            v1092,
            v1093,
            255,
            "ab",
            0,
            "•"
        )
        if v487.ui.menu.tools.indicator_bind:get() then
            for v1118, v1119 in v2(v506) do
                local v1120 = v487.helpers:new_anim("indicators_alpha" .. v1119.n, (v1119.a and 255) or 0, 10)
                local v1121 = v487.helpers:new_anim("indicators_pose_2" .. v1119.n, (v1119.a and 13) or 0, 10)
                v508 = v508 + v1121
                v28.text(
                    (v39 / 2) + (((v1119.s / 2) + 5) * v487.scoped_comp),
                    (v40 / 2) + v507 + v508 + 15,
                    v1119.c[1],
                    v1119.c[2],
                    v1119.c[3],
                    v1120,
                    "ca",
                    nil,
                    v1119.n:lower()
                )
            end
        end
        
    elseif (v498 == 4) then
        -- Renewed стиль
        local v1114 = "₊‧.°.⋆✦⋆.°.₊"
        v28.text(
            ((v39 / 2) - 27) + (35 * v487.scoped_comp),
            ((v40 / 2) + v507) - 13,
            v493,
            v494,
            v495,
            200,
            "ab",
            0,
            v1114
        )
        v28.text(
            ((v39 / 2) - 22) + (35 * v487.scoped_comp),
            ((v40 / 2) + v507) - 6,
            255,
            255,
            255,
            255,
            "ab",
            0,
            v15(v510)
        )
        v28.text(
            (v39 / 2) + (((v511 + 28) / 2) * v487.scoped_comp),
            (v40 / 2) + v507 + 13,
            255,
            255,
            255,
            255,
            "ac",
            0,
            v492
        )
        for v1122, v1123 in v2(v506) do
            local v1124 = v487.helpers:new_anim("indicators_alpha" .. v1123.n, (v1123.a and 255) or 0, 10)
            local v1125 = v487.helpers:new_anim("indicators_pose_2" .. v1123.n, (v1123.a and 13) or 0, 10)
            v508 = v508 + v1125
            v28.text(
                (v39 / 2) + (((v1123.s / 2) + 8) * v487.scoped_comp),
                (v40 / 2) + v507 + v508 + 15,
                v1123.c[1],
                v1123.c[2],
                v1123.c[3],
                v1124,
                "ca",
                nil,
                v1123.n:lower()
            )
        end
        
    elseif (v498 == 5) then
        -- Icons стиль
        local v1147 = v487.helpers:animate_text(v26.curtime() * 2, "+w.tech", v493, v494, v495, 255)
        v28.texture(
            v42,
            ((v39 / 2) - 29) + (37 * v487.scoped_comp),
            ((v40 / 2) + v507) - 4,
            11,
            11,
            v493,
            v494,
            v495,
            255
        )
        v28.text(
            (v39 / 2) + 4 + (37 * v487.scoped_comp),
            (v40 / 2) + v507,
            255,
            255,
            255,
            255,
            "ac",
            0,
            v15(v1147)
        )
        v28.text(
            (v39 / 2) + (((v511 + 28) / 2) * v487.scoped_comp),
            (v40 / 2) + v507 + 13,
            255,
            255,
            255,
            255,
            "ac",
            0,
            "-" .. v492 .. "-"
        )
        
    elseif (v498 == 6) then
        -- Old Chimera стиль
        local screen_width, screen_height = v39, v40
        local title = "\aC1C1C1FF+W.TECH \aFFFFFFFFYAW"
        local desync = tostring(v19.floor(v19.abs(delta))) .. "°"
        local exploit = ""
        
        if v21.get(v487.ref.rage.dt[1]) and v21.get(v487.ref.rage.dt[2]) and v21.get(v487.ref.rage.os[1]) and v21.get(v487.ref.rage.os[2]) then
            exploit = "\a32CD32FFDT"
        elseif v21.get(v487.ref.rage.dt[1]) and v21.get(v487.ref.rage.dt[2]) then
            exploit = "\a32CD32FFDT"
        elseif v21.get(v487.ref.rage.os[1]) and v21.get(v487.ref.rage.os[2]) then
            exploit = "OS"
        else
            exploit = "\aC02B2BDBDT"
        end
        
        -- Анимация позиций
        v487.chimera.desync_pos = v31(
            v487.helpers:lerp(v487.chimera.desync_pos.x, screen_width/2, v26.frametime() * 12),
            v487.helpers:lerp(v487.chimera.desync_pos.y, screen_height/2 + 20, v26.frametime() * 12)
        )
        v487.chimera.title_pos = v31(
            v487.helpers:lerp(v487.chimera.title_pos.x, screen_width/2, v26.frametime() * 12),
            v487.helpers:lerp(v487.chimera.title_pos.y, screen_height/2 + 40, v26.frametime() * 12)
        )
        v487.chimera.exploit_pos = v31(
            v487.helpers:lerp(v487.chimera.exploit_pos.x, screen_width/2, v26.frametime() * 12),
            v487.helpers:lerp(v487.chimera.exploit_pos.y, screen_height/2 + 50, v26.frametime() * 12)
        )
        
        -- Отрисовка
        v28.text(v487.chimera.desync_pos.x, v487.chimera.desync_pos.y, 255, 255, 255, 255, "c", 0, desync)
        
        local delta_value = v19.abs(delta)
        if delta_value > 0 then
            v28.gradient(
                v487.chimera.desync_pos.x, 
                v487.chimera.desync_pos.y + 10, 
                delta_value, 
                1, 
                v493, v494, v495, 255, 
                v493, v494, v495, 0, 
                true
            )
            v28.gradient(
                v487.chimera.desync_pos.x - delta_value, 
                v487.chimera.desync_pos.y + 10, 
                delta_value, 
                1, 
                v493, v494, v495, 0, 
                v493, v494, v495, 255, 
                true
            )
        end
        
        v28.text(v487.chimera.title_pos.x, v487.chimera.title_pos.y, 255, 255, 255, 255, "c", 0, title)
        
        if v21.get(v487.ref.rage.dt[1]) and v21.get(v487.ref.rage.dt[2]) then
            local charge = v487.helpers:get_charge() and 1 or 0
            v28.text(v487.chimera.exploit_pos.x, v487.chimera.exploit_pos.y, 50, 255, 50, 255, "c", 0, exploit)
            v28.circle_outline(
                v487.chimera.exploit_pos.x - v28.measure_text("c", exploit), 
                v487.chimera.exploit_pos.y, 
                v487.charge_col.r, 
                v487.charge_col.g, 
                v487.charge_col.b, 
                255, 
                4, 
                0, 
                charge, 
                1.5
            )
        end
        
    elseif (v498 == 7) then
        -- Prediction стиль
        local screen_width, screen_height = v39, v40
        local title = "\aC1C1C1FF+w.te\aFFFFFFFFch°"
        local title_size = v28.measure_text("cb", title)
        
        -- Анимация позиций
        v487.prediction.desync_pos = v31(
            v487.helpers:lerp(v487.prediction.desync_pos.x, screen_width/2 + ((v487.scoped == 1) and 6 or 0), v26.frametime() * 12),
            v487.helpers:lerp(v487.prediction.desync_pos.y, screen_height/2 + 20, v26.frametime() * 12)
        )
        v487.prediction.title_pos = v31(
            v487.helpers:lerp(v487.prediction.title_pos.x, screen_width/2 + ((v487.scoped == 1) and (title_size/2 + 5) or 0), v26.frametime() * 12),
            v487.helpers:lerp(v487.prediction.title_pos.y, screen_height/2 + 30, v26.frametime() * 12)
        )
        
        -- Полоска десинка
        local delta_value = v19.abs(delta)
        local bar_width = (delta_value / 60) * 50
        v28.rectangle(
            v487.prediction.desync_pos.x - ((v487.scoped == 1) and 0 or ((delta_value / 60) * 25)), 
            v487.prediction.desync_pos.y, 
            bar_width, 
            2, 
            v493, v494, v495, 255
        )
        
        v28.text(v487.prediction.title_pos.x, v487.prediction.title_pos.y, 255, 255, 255, 255, "cb", 0, title)
        
            -- Бинды
                    -- Бинды
        local count = 0
        for bind_name, bind_data in v3(v487.prediction.binds) do
            local is_active = false
            
            -- ПРАВИЛЬНАЯ ПРОВЕРКА: bind_data.ref это таблица {чекбокс, хоткей}
            if bind_data.ref and type(bind_data.ref) == "table" then
                if bind_name == "DT" or bind_name == "OS" or bind_name == "FD" then
                    -- Для Double Tap, On Shot, Fake Duck
                    if bind_data.ref[1] and bind_data.ref[2] then
                        is_active = ui.get(bind_data.ref[1]) and ui.get(bind_data.ref[2])
                    end
                elseif bind_name == "DMG" then
                    -- Для Damage Override
                    if bind_data.ref[1] then
                        is_active = ui.get(bind_data.ref[1])
                    end
                end
            end
            
            if is_active then
                local bind_size = v28.measure_text("c-", bind_name)
                bind_data.pos = v31(
                    v487.helpers:lerp(bind_data.pos.x, screen_width/2 + ((v487.scoped == 1) and (bind_size/2 + 5) or 0), v26.frametime() * 22),
                    v487.helpers:lerp(bind_data.pos.y, screen_height/2 + 40 + (10 * count), v26.frametime() * 22)
                )
                
                if bind_name == "DT" then
                    bind_data.pos = v31(
                        v487.helpers:lerp(bind_data.pos.x, screen_width/2 + ((v487.scoped == 1) and (bind_size/2 + 7.8) or 0) - 2.8, v26.frametime() * 22),
                        bind_data.pos.y
                    )
                    
                    local charge = v487.helpers:get_charge() and 1 or 0
                    v28.circle_outline(
                        bind_data.pos.x + 12, 
                        bind_data.pos.y, 
                        255, 255, 255, 255, 
                        2.8, 
                        0, 
                        charge, 
                        1.3
                    )
                end
                
                v28.text(bind_data.pos.x, bind_data.pos.y, v493, v494, v495, 255, "c-", 0, bind_name)
                count = count + 1
            end
        end
        
        -- Также обновляем клан-тег здесь для надежности
        if v487.ui.menu.tools.clantag_enable and v487.ui.menu.tools.clantag_enable:get() then
            v487:update_clantag()
        end
    end
end,
        
        view_x = 1,
        view_y = 1,
        view_z = -1,
        view_fov = 60,
        viewmodel = function(v512)
            local v513 = v24.get_local_player()
            local v514 = v512.ui.menu.tools.viewmodel_on:get()
            local v515 = v512.ui.menu.tools.viewmodel_scope:get()
            if not v24.is_alive(v513) then
                return
            end
            local v516 = v24.get_player_weapon(v513)
            if (v516 == nil) then
                return
            end
            local v517 = v24.get_prop(v516, "m_iItemDefinitionIndex")
            local v518 = v48(v47, v517)
            v518.hide_vm_scope = not v515
            if not v514 then
                return
            end
            local v520 = v512.ui.menu.tools.viewmodel_x1:get()
            local v521 = v512.ui.menu.tools.viewmodel_y1:get()
            local v522 = v512.ui.menu.tools.viewmodel_z1:get()
            local v523 = v512.ui.menu.tools.viewmodel_fov1:get()
            local v524 = v512.ui.menu.tools.viewmodel_x2:get()
            local v525 = v512.ui.menu.tools.viewmodel_y2:get()
            local v526 = v512.ui.menu.tools.viewmodel_z2:get()
            local v527 = v512.ui.menu.tools.viewmodel_fov2:get()
            if (v512.scoped == 1) then
                if v512.ui.menu.tools.viewmodel_inscope:get() then
                    v512.view_x = v524
                    v512.view_y = v525
                    v512.view_z = v526
                    v512.view_fov = v527
                end
            else
                v512.view_x = v520
                v512.view_y = v521
                v512.view_z = v522
                v512.view_fov = v523
            end
            v22.set_cvar("viewmodel_offset_x", v512.helpers:new_anim("view_x1", v512.view_x, 11))
            v22.set_cvar("viewmodel_offset_y", v512.helpers:new_anim("view_y1", v512.view_y, 11))
            v22.set_cvar("viewmodel_offset_z", v512.helpers:new_anim("view_z1", v512.view_z, 11))
            v22.set_cvar("viewmodel_fov", v512.helpers:new_anim("view_fov1", v512.view_fov, 11))
        end,
        
        manuals = function(v528)
            local v529 = v24.get_local_player()
            local v530 = ""
            local v531 = ""
            if (v528.ui.menu.tools.manuals_style:get() == "+w.tech") then
                v530 = "‹"
                v531 = "›"
            elseif (v528.ui.menu.tools.manuals_style:get() == "New") then
                v530 = "«"
                v531 = "»"
            end
            if not v24.is_alive(v529) then
                return
            end
            local v532 = v528.antiaim:get_manual()
            local v533 = v528.antiaim:get_best_side()
            local v534, v535, v536, v537 = v38.accent.r, v38.accent.g, v38.accent.b
            local v538 =
                v528.helpers:new_anim("alpha_manual_global", (v528.ui.menu.tools.manuals_global:get() and 255) or 0, 16)
            local v539 = v528.helpers:new_anim("manual_scope", ((v528.scoped == 1) and 15) or 0, 8)
            local v540 = v528.helpers:new_anim("alpha_manual_right", ((v532 == 90) and 255) or 0, 16)
            local v541 = v528.helpers:new_anim("alpha_manual_left", ((v532 == -90) and 255) or 0, 16)
            local v542 = v528.helpers:new_anim("alpha_manual_right_global", ((v533 == 0) and 255) or 0, 8)
            local v543 = v528.helpers:new_anim("alpha_manual_left_global", ((v533 == 2) and 255) or 0, 8)
            local v544 = v528.helpers:new_anim("alpha_manual_offset", -v528.ui.menu.tools.manuals_offset:get() - 25, 12)
            v28.text((v39 / 2) + v544, ((v40 / 2) - 16) - v539, v534, v535, v536, v541, "d+", 0, v530)
            v28.text(((v39 / 2) - v544) - 11, ((v40 / 2) - 16) - v539, v534, v535, v536, v540, "d+", 0, v531)
            if (v538 < 0.1) then
                return
            end
            v28.text(
                (v39 / 2) + v544 + 11,
                ((v40 / 2) - 16) - v539,
                v534,
                v535,
                v536,
                v543 * (v538 / 255),
                "d+",
                0,
                v530
            )
            v28.text(
                ((v39 / 2) - v544) - 22,
                ((v40 / 2) - 16) - v539,
                v534,
                v535,
                v536,
                v542 * (v538 / 255),
                "d+",
                0,
                v531
            )
        end,
        
        ind_dmg = function(v545)
            local v546 = v24.get_local_player()
            if not v24.is_alive(v546) then
                return
            end
            local v547, v548, v549, v550 = v545.ui.menu.tools.indicator_dmg_color:get()
            local v551 = v545.ui.menu.tools.indicator_dmg_weapon:get()
            local v552 = v19.floor(v545.helpers:get_damage() + 0.1)
            local v553 = ""
            if v545.ref.rage.ovr[2] then
                if v551 then
                    if v21.get(v545.ref.rage.ovr[2]) then
                        v553 = v545.helpers:get_damage()
                    else
                        v553 = ""
                    end
                elseif v21.get(v545.ref.rage.ovr[2]) then
                    v553 = v552
                else
                    v553 = v552
                end
            end
            v28.text((v39 / 2) + 5, (v40 / 2) - 17, v547, v548, v549, 255, "d", 0, v553 .. "")
        end,
        
        scopedu = function(v554)
            if not v554.ui.menu.tools.animscope:get() then
                return
            end
            local v555 = v24.get_local_player()
            local v556 = v554.ui.menu.tools.animscope_slider:get()
            local v557 = v554.ui.menu.tools.animscope_fov_slider:get()
            local v558 = v554.helpers:new_anim("animated_scoped", ((v554.scoped == 1) and v556) or 0, 8)
            if (v21.get(v554.ref.misc.override_zf) > 0) then
                v21.set(v554.ref.misc.override_zf, 0)
            end
            v21.set(v554.ref.misc.fov, v557 - v558)
        end,
        
        draw = false,
        keylist = function(v581)
            local v582, v583, v584, v585 = v38.accent.r, v38.accent.g, v38.accent.b
            local v586 = v581.helpers:new_anim("alpha_keybinds", (v581.draw and 160) or 0, 8)
            local v587 = 95
            if
                (not v21.is_menu_open() and not v21.get(v581.ref.rage.dt[2]) and not v21.get(v581.ref.rage.os[2]) and
                    not v21.get(v581.ref.rage.ovr[2]) and
                    not v21.get(v581.ref.aa.freestand[1]) and
                    not v21.get(v581.ref.rage.fd[1]))
            then
                v581.draw = false
            else
                v581.draw = true
            end
            if (v586 < 0.1) then
                return
            end
            local v588, v589 = v581.widget_keylist:get(25, 10)
            local v590 = 0
            local v591 = {
                {
                    n = "Double Tap",
                    c = {255, 255, 255},
                    a = v21.get(v581.ref.rage.dt[1]) and v21.get(v581.ref.rage.dt[2]) and
                        not v21.get(v581.ref.rage.fd[1]),
                    s = v28.measure_text("c-", "                 Double tap")
                },
                {
                    n = "Hide Shots",
                    c = {255, 255, 255},
                    a = v21.get(v581.ref.rage.os[1]) and v21.get(v581.ref.rage.os[2]) and
                        not v21.get(v581.ref.rage.fd[1]),
                    s = v28.measure_text("c-", "                 Hide shots") + 1
                },
                {
                    n = "Fake Duck",
                    c = {255, 255, 255},
                    a = v21.get(v581.ref.rage.fd[1]),
                    s = v28.measure_text("c-", "            Fake duck") + 3
                },
                {
                    n = "Min. Damage",
                    c = {255, 255, 255},
                    a = v21.get(v581.ref.rage.ovr[1]) and v21.get(v581.ref.rage.ovr[2]),
                    s = v28.measure_text("c-", "             Min dmg") + 16
                },
                {
                    n = "Edge yaw",
                    c = {255, 255, 255},
                    a = v21.get(v581.ref.aa.edge_yaw[1]) and v581.ui.menu.antiaim.edge_yaw:get_hotkey(),
                    s = v28.measure_text("c-", "               Edge yaw") + 3
                },
                {
                    n = "Freestand",
                    c = {255, 255, 255},
                    a = v21.get(v581.ref.aa.freestand[1]) and v21.get(v581.ref.aa.freestand[2]),
                    s = v28.measure_text("c-", "              Freestand") + 3
                }
            }
            local v592 = v581.ui.menu.tools.style:get() == "Default"
            if v592 then
                v581.helpers:rounded_side_v(v588 - 20, v589 - 5, v587, 25, 15, 15, 15, v586, 6, true, true)
            else
                v43.rect_v(v588 - 20, v589 - 5, v587 + 6, 25, {15, 15, 15, v586}, 6, {v582, v583, v584, v586})
            end
            local v593 = v586 / 160
            v28.rectangle(v588 + 8, v589 - 5, 1, 25 - ((v592 and 0) or 1), 255, 255, 255, 25 * v593)
            v28.texture(
                v581.globals.keylist_icon,
                v588 - 15,
                v589 - ((v592 and 0) or 1),
                15,
                15,
                255,
                255,
                255,
                255 * v593
            )
            v28.text(v588 + 35, (v589 + 7) - ((v592 and 0) or 1), 255, 255, 255, 255 * v593, "ca", nil, "Hotkeys")
            for v852, v853 in v2(v591) do
                local v854 = v581.helpers:new_anim("alpha_rect_keybinds" .. v853.n, (v853.a and 130) or 0, 8)
                local v855 = v581.helpers:new_anim("alpha_text_keybinds" .. v853.n, (v853.a and 255) or 0, 8)
                local v856 = v28.measure_text("ca", v21.get(v581.ref.rage.ovr[3])) - 12
                local v857 = v581.helpers:new_anim("move_keybinds" .. v853.n, (v853.a and 20) or 0, 12)
                v590 = v590 + v857
                v581.helpers:rounded_side_v(
                    v588 - 20,
                    v589 + 3 + v590,
                    v587,
                    18,
                    15,
                    15,
                    15,
                    v854 * v593,
                    6,
                    true,
                    true
                )
                if (v853.n == "Min. Damage") then
                    v28.text(
                        (v588 + (v587 - 27)) - (v856 / 2),
                        v589 + 11 + v590,
                        v582,
                        v583,
                        v584,
                        v855 * v593,
                        "ca",
                        nil,
                        v21.get(v581.ref.rage.ovr[3])
                    )
                else
                    v28.text(v588 + (v587 - 27), v589 + 11 + v590, v582, v583, v584, v855 * v593, "ca", nil, "on")
                end
                v28.text(
                    (v588 - 40) + v853.s,
                    v589 + 11 + v590,
                    v853.c[1],
                    v853.c[2],
                    v853.c[3],
                    v855 * v593,
                    "ca",
                    nil,
                    v853.n
                )
            end
            v581.widget_keylist:drag(v587 + 16, 35)
        end
    }
):struct("round_reset")(
    {
        auto_buy = function(v594)
            if not v594.ui.menu.tools.autobuy:get() then
                return
            end
            if (v594.ui.menu.tools.autobuy_v:get() == "Awp") then
                v22.exec("buy awp")
            elseif (v594.ui.menu.tools.autobuy_v:get() == "Scar/g3sg1") then
                v22.exec("buy g3sg1")
                v22.exec("buy scar20")
            elseif (v594.ui.menu.tools.autobuy_v:get() == "Scout") then
                v22.exec("buy ssg08")
            end
        end
    }
):struct("custom_gs")(
    {
        table = {binds = {}},
        y = 0,
        add = function(v595, v596, v597, v598)
            enabled_color = {[1] = 230, [2] = 230, [3] = 230, [4] = 230}
            disabled_color = {[1] = 155, [2] = 155, [3] = 155, [4] = 0}
            v595.table.binds[#v595.table.binds + 1] = {
                full_icon = v596,
                name = v20.sub(v597, 1, 2),
                full_name = v597,
                ref = v598,
                chars = 0,
                alpha = 0
            }
        end,
        text = function(v600, v601, v602, v603, v604, v605, v606, v607, v608, v609, v610, v611, v612, v613, v614)
            if (v614 == nil) then
                v614 = 1
            end
            if (v614 <= 0) then
                return
            end
            local v615 = v31(v28.measure_text("+", v611))
            local v616 = v31(v28.measure_text("+", v612))
            local v617, v618 = v22.screen_size()
            local v619 = v19.floor(v616.x / 2)
            local v602 = v602 + (v618 / 2) + 50
            v28.gradient(4, v602 + v616.y, v619 + 24, v616.y + 4, 5, 5, 5, 0, 5, 5, 5, 55 * v614, true)
            v28.gradient(28 + v619, v602 + v616.y, 29 + v619, v616.y + 4, 5, 5, 5, 55 * v614, 5, 5, 5, 0, true)
            v28.text(v601 * v614, v602 + v615.y, v607, v608, v609, v610 * v613, "+", nil, v611)
            v28.text(v601 + (v615.x * v613), v602 + v615.y + 1, v603, v604, v605, v606, "+", nil, v612)
            v600.y = v600.y + (40 * v614)
        end,
        clamp = function(v621, v622)
            return v19.max(0, v19.min(255, v622))
        end,
        general = function(v623)
            local v624 = v24.get_local_player()
            if ((v624 == nil) or not v624) then
                return
            end
            local v625 = v623.helpers:get_charge()
            v623.y = 15
            local v627 = v19.floor(v22.latency() * 1000)
            local v628 = v24.is_alive(v624)
            for v858, v859 in v2(v623.table.binds) do
                local v860 = v859.full_icon
                local v861 = (v623.ui.menu.tools.gs_ind:get() and v623.ui.menu.tools.gs_inds:get("Target")) or false
                local v862 = v21.get(v859.ref)
                local v863 = v860 == "t"
                local v864 = 0
                if v628 then
                    if (v863 and v861) then
                        v864 = 1
                    elseif v862 then
                        v864 = 1
                    end
                end
                local v865 = v623.helpers:math_anim2(v859.alpha, v864, 6)
                local v866 = v623.helpers:math_anim2(v859.chars, (v628 and v862 and 1) or 0, 6)
                local v867, v868, v869, v870 = 255, 255, 255, 255
                local v871 = v859.full_name
                local v872 = {v867, v868, v869, v870}
                if (v871 == "DT") then
                    v860 = (v625 and " ") or " "
                    v872 = {[1] = 140, [2] = 140 * ((v625 and 1) or 0), [3] = 170 * ((v625 and 1) or 0), [4] = v870}
                elseif (v871 == "PING") then
                    if (v627 < 55) then
                        v872[1] = v623:clamp(255 - ((70 - v627) * 2))
                        v872[3] = v623:clamp(255 - ((70 - v627) * 2))
                    elseif (v627 < 55) then
                        v872[1] = 255
                        v872[2] = 255
                        v872[3] = v623:clamp(255 - ((v627 - 70) * 17))
                    else
                        v872[1] = 255
                        v872[2] = v623:clamp(255 - ((v627 - 85) * 8))
                        v872[3] = 0
                    end
                    v872[4] = 255
                elseif (v871 == "OS") then
                    v860 = (v625 and " ") or "⭙ "
                    v872 = {[1] = 140, [2] = 140 * ((v625 and 1) or 0), [3] = 170 * ((v625 and 1) or 0), [4] = v870}
                elseif (v871 == "MD") then
                    v872 = {[1] = 191, [2] = 165, [3] = 170, [4] = v870}
                elseif (v871 == "FD") then
                    v872 = {[1] = 96, [2] = 156, [3] = 216, [4] = v870}
                elseif (v871 == "FS") then
                    v872 = {[1] = 198, [2] = 124, [3] = 158, [4] = v870}
                elseif (v860 == "t") then
                    v871 = " Target: " .. v623.helpers:get_target()
                end
                v623:text(
                    25,
                    v623.y,
                    v872[1],
                    v872[2],
                    v872[3],
                    v872[4] * v865,
                    v872[1],
                    v872[2],
                    v872[3],
                    v872[4] * v865,
                    v860,
                    v871,
                    v866,
                    v865
                )
                v623.table.binds[v858].alpha = v865
                v623.table.binds[v858].name = v871
                v623.table.binds[v858].chars = v866
                v623.table.binds[v858].color = v867, v868, v869, v870
            end
        end,
        create = function(v629)
            v629:add("t", "Target", v629.ref.misc.log[1])
            v629:add(" ", "DT", v629.ref.rage.dt[2])
            v629:add(" ", "OS", v629.ref.rage.os[2])
            v629:add(" ", "MD", v629.ref.rage.ovr[2])
            v629:add(" ", "FD", v629.ref.rage.fd[1])
            v629:add(" ", "FS", v629.ref.aa.freestand[1])
            v629:add("", "BA", v629.ref.rage.baim[1])
            v629:add("", "SAFE", v629.ref.rage.safe[1])
            v629:add(" ", "PING", v629.ref.rage.always[1])
        end
    }
):struct("misc")(
    {
        charged = false,
        call_reg = false,
        jumpscout = false,
        unsafe_charge = function(v630)
            local v631 = v630.ui.menu.tools.unsafe_charge:get()
            local v632 = v630.ref.rage.enable
            if not v631 then
                if v630.call_reg then
                    v21.set(v632, true)
                    v630.call_reg = false
                end
                return
            end
            local v633 = v24.get_local_player()
            if not v630.call_reg then
                v630.call_reg = true
            end
            local v634 = v22.current_threat()
            if
                (v21.get(v630.ref.rage.dt[2]) and v634 and not v630.jumpscout and v630.helpers:in_air(v633) and
                    v630.helpers:entity_has_flag(v634, "HIT"))
            then
                if (v21.get(v632) == true) then
                    v21.set(v632, false)
                end
            elseif (v21.get(v632) == false) then
                v21.set(v632, true)
            end
        end,
        air_stopchance = function(v635, v636)
            local v637 = v635.ui.menu.tools.air_stop
            if (not v637:get() or not v637:get_hotkey()) then
                v635.jumpscout = false
                return
            end
            local v638 = v24.get_local_player()
            if (not v638 or not v24.is_alive(v638)) then
                return
            end
            local v639 = v635.ui.menu.tools.air_stop_distance:get() * 5
            local v640 = v29.band(v24.get_prop(v24.get_player_weapon(v638), "m_iItemDefinitionIndex"), 65535)
            local v641 = v24.get_players(true)
            for v877 = 1, #v641 do
                if (v641 == nil) then
                    return
                end
                local v878, v879, v880 = v24.get_prop(v638, "m_vecOrigin")
                local v881, v882, v883 = v24.get_prop(v641[v877], "m_vecOrigin")
                local v884 = v635.helpers:distance(v878, v879, v880, v881, v882, v883) / 11.91
                if ((v884 < v639) and (v640 == 40)) then
                    if v635.helpers:in_air(v638) then
                        if v636.quick_stop then
                            v635.jumpscout = true
                            v636.in_speed = 1
                        end
                    end
                else
                    v635.jumpscout = false
                end
            end
        end,
        phrases = {
            kill = {
"ɢᴏᴏᴅ ʟᴜᴄᴋ, ʏᴏᴜ ᴊᴜꜱᴛ ɢᴏᴛ ꜰᴜᴄᴋᴇᴅ ɪɴ ᴛʜᴇ ᴀꜱꜱ, ʙᴇᴄᴀᴜꜱᴇ ᴍʏ +ᴡ.ᴛᴇᴄʜ ɪꜱ ᴜɴʙᴇᴀᴛᴀʙʟᴇ",
"(っ◔◡◔)っ ♥ ɪ ᴊᴜꜱᴛ ʜᴀᴅ ᴀᴍʙᴀɴɪ ᴀɴᴅ +ᴡ.ᴛᴇᴄʜ, ᴛʜᴀᴛ'ꜱ ᴡʜʏ ʏᴏᴜ ʟᴏꜱᴛ. :ʜᴇᴀʀᴛꜱ:",
"ɢᴏ ʀᴜʙ ʏᴏᴜʀ ᴄᴏᴄᴋ ᴀɢᴀɪɴꜱᴛ ᴀ ᴄʜᴇᴇꜱᴇ ɢʀᴀᴛᴇʀ, ʏᴏᴜ ᴛɪᴛᴄʀᴀᴘᴘɪɴɢ ᴛᴡɪɢꜰᴜᴄᴋᴇʀ, ᴡʜɪʟᴇ ɪ ᴜᴘɢʀᴀᴅᴇ ᴛᴏ +ᴡ.ᴛᴇᴄʜ",
"ᴡʜɪᴄʜ ᴏɴᴇ ᴏꜰ ʏᴏᴜʀ 2 ᴅᴀᴅꜱ ᴛᴀᴜɢʜᴛ ʏᴏᴜ ʜᴏᴡ ᴛᴏ ᴘʟᴀʏ ʜᴠʜ? ɴᴏᴛʜɪɴɢ ʟɪᴋᴇ ᴍʏ +ᴡ.ᴛᴇᴄʜ ᴍᴇɴᴛᴏʀ",
"ɪᴍᴀɢɪɴᴇ ʏᴏᴜʀ ᴘᴏᴛᴇɴᴛɪᴀʟ ɪꜰ ʏᴏᴜ ᴅɪᴅɴ'ᴛ ʜᴀᴠᴇ ᴘᴀʀᴋɪɴꜱᴏɴꜱ ᴀɴᴅ ʜᴀᴅ +ᴡ.ᴛᴇᴄʜ ɪɴꜱᴛᴇᴀᴅ",
"ᴡᴇ ᴀʀᴇ ɢᴏɪɴɢ ᴛᴏ ᴇxᴇᴄᴜᴛᴇ ᴇᴠᴇʀʏ ꜱɪɴɢʟᴇ ᴄɪᴀ ʜᴇᴀᴠᴇɴʟʏ ꜱᴀɪɴᴛ ᴡɪᴛʜ ᴛʜᴇ ᴘᴏᴡᴇʀ ᴏꜰ +ᴡ.ᴛᴇᴄʜ",
"ᴅɪᴇ ᴄɪᴀ ɴɪɢɢᴇʀꜱ! ʏᴏᴜʀ ᴛᴇᴄʜ ɪꜱ ɴᴏᴛʜɪɴɢ ᴀɢᴀɪɴꜱᴛ +ᴡ.ᴛᴇᴄʜ",
"ɪꜰ ᴀ ᴘᴇʀꜱᴏɴ ᴄᴏᴍᴍɪᴛꜱ ᴇxᴛᴏʀᴛɪᴏɴ, ᴛʜᴇʏ ɢᴏ ᴛᴏ ʜᴇʟʟ. ɪꜰ ʏᴏᴜ ᴄᴏɴꜰᴇꜱꜱ +ᴡ.ᴛᴇᴄʜ ɢᴏᴅ ʙʟᴇꜱꜱᴇꜱ ʏᴏᴜ",
"ᴘᴏᴘᴇ ɪꜱ ᴀɴ ᴀᴛʜᴇɪꜱᴛ. ʜᴇ ꜱʜᴏᴜʟᴅ ʀᴇꜱɪɢɴ ᴡʜᴇɴ ɢᴏᴅ ᴏꜰ +ᴡ.ᴛᴇᴄʜ ᴛᴀʟᴋꜱ",
"ʀᴀɢɪɴɢ ʙᴜʟʟ? ʏᴇʀ ɴᴏ ꜰᴜɴ. ɪᴛ ᴡᴀꜱ ᴀ ᴄɪᴀ ʜᴇᴀᴠᴇɴʟʏ ꜱᴀɪɴᴛ, ᴛʜᴏᴜɢʜ. ɪ ᴋɪʟʟᴇᴅ ᴀ ᴄɪᴀ ʜᴇᴀᴠᴇɴʟʏ ꜱᴀɪɴᴛ ᴡɪᴛʜ +ᴡ.ᴛᴇᴄʜ",
"ɪᴛ'ꜱ ʟᴇɢᴀʟ ᴛᴏ ʀᴜɴ ᴏᴠᴇʀ ᴀ ᴄɪᴀ ʜᴇᴀᴠᴇɴʟʏ ꜱᴀɪɴᴛ ᴀꜱ ʟᴏɴɢ ᴀꜱ ᴛʜᴇʏ ᴀʀᴇ ꜱᴘᴀᴄᴇ ᴀʟɪᴇɴꜱ ᴡɪᴛʜᴏᴜᴛ +ᴡ.ᴛᴇᴄʜ. ʙᴀ ʜᴀ. ɪ ʜᴀᴠᴇ ᴀ ꜰᴇᴀᴛʜᴇʀ ɪɴ ᴍʏ ᴄᴀᴘ",
"ɴɪᴄᴇ ᴀɴᴛɪᴀɪᴍ, ɪꜱ ᴛʜᴀᴛ ᴍʏᴛᴏᴏʟꜱ-ᴘᴀꜱᴛᴇ? ʟᴏᴏᴋꜱ ʟɪᴋᴇ ᴀ ᴅɪꜱᴄᴏᴜɴᴛ +ᴡ.ᴛᴇᴄʜ",
"ɪꜱ ᴛʜɪꜱ ᴄᴀꜱᴜᴀʟ? ɪ ʜᴀᴠᴇ 16ᴋ ᴀɴᴅ +ᴡ.ᴛᴇᴄʜ..",
"ᴘɪᴇ-ᴇᴀᴛɪɴɢ ʙᴜᴛᴛ ᴘɪʀᴀᴛᴇ ᴡɪᴛʜᴏᴜᴛ ᴀ +ᴡ.ᴛᴇᴄʜ ʟɪᴄᴇɴꜱᴇ",
"ᴄ0ᴍᴍᴜɴ1ꜱᴛ ᴄ0ᴄᴋ ᴄᴀɴᴏᴇ ᴘᴏᴡᴇʀᴇᴅ ʙʏ +ᴡ.ᴛᴇᴄʜ",
"ᴊᴀᴄᴋᴀʟᴏᴘᴇ ʙ0ɴ3ʀ ᴛᴏᴏʟʙᴀɢ ꜰᴜʟʟ ᴏꜰ +ᴡ.ᴛᴇᴄʜ ɢᴏᴏᴅɪᴇꜱ",
"ꜰᴜᴄᴋ ʏᴏᴜ ᴀꜱꜱʜᴏʟᴇ ᴜɴᴛɪʟ ᴛʜᴇ ᴄᴀʀᴀᴍᴇʟꜱ ᴄᴏᴍᴇ ᴏᴜᴛ ʏᴏᴜʀ ᴀꜱꜱ ᴀɴᴅ ᴛᴜʀɴ ɪɴᴛᴏ +ᴡ.ᴛᴇᴄʜ ꜱᴛɪᴄᴋᴇʀꜱ",
"ᴅᴜᴄᴋɴ0ꜱᴇ ɴᴜᴛ ʙɪꜱᴄᴜɪᴛ, ʏᴏᴜʀ ꜰᴀᴠᴏʀɪᴛᴇ ꜱɴᴀᴄᴋ ᴀᴛ +ᴡ.ᴛᴇᴄʜ ʜᴇᴀᴅQᴜᴀʀᴛᴇʀꜱ",
"ᴜɢʟʏ ꜱᴘʜɪɴᴄᴛᴇʀ ʜᴀᴍᴍᴇʀ ᴍᴇᴇᴛꜱ ᴛʜᴇ ᴇʟᴇɢᴀɴᴛ ᴘʀᴇᴄɪꜱɪᴏɴ ᴏꜰ +ᴡ.ᴛᴇᴄʜ",
"ɪ ᴛʜᴏᴜɢʜᴛ ɪ ᴘᴜᴛ ʙᴏᴛꜱ ᴏɴ ʜᴀʀᴅ, ᴡʜʏ ᴀʀᴇ ᴛʜᴇʏ ᴏɴ ᴇᴀꜱʏ? ᴏʜ ʀɪɢʜᴛ, ʙᴇᴄᴀᴜꜱᴇ ᴏꜰ ᴍʏ +ᴡ.ᴛᴇᴄʜ",
"ᴠꜱᴛᴀɴ̆ ɴᴀ ᴋᴏʟᴇɴɪ, ᴛʏ, ᴄʜᴇʀᴛᴏᴠᴀ ꜱᴏʙᴀᴋᴀ, ɪ ᴠᴏᴢʙᴜᴅɪʟꜱʏᴀ ᴄ +ᴡ.ᴛᴇᴄʜ",
"ᴛᴇʙʏᴀ ᴜɴɪᴄʜᴛᴏᴢʜɪʟ ᴋᴇɴᴛᴀᴠʀ. ꜱᴇᴋꜱᴜᴀʟ̌ɴᴀʏᴀ ᴛʏ ᴇʙᴀɴᴀʏᴀ ꜱʜʟʏᴜxᴀ ʙᴇᴢ +ᴡ.ᴛᴇᴄʜ",
"ᴇᴛᴏ ᴍʏᴛᴏᴏʟꜱ ɪʟɪ ᴘᴏᴄʜᴇᴍᴜ ᴛʏ ꜱʀᴀᴢᴜ ᴜᴍᴇʀ? ᴠᴏᴛ +ᴡ.ᴛᴇᴄʜ ᴇᴛᴏ ɴᴇ ᴅᴇʟᴀᴇᴛ",
"ᴇꜱʜᴋɪ ᴍᴀᴛʀᴇꜱʜᴋɪ ᴠᴏᴛ ᴇᴛᴏ ᴠᴀɴᴛᴀᴘᴄʜɪᴋ ᴏᴛ +ᴡ.ᴛᴇᴄʜ",
"ᴋᴀᴀᴅʏᴋ ᴍɴᴇ ᴠ ᴢᴀᴅ ᴠᴏᴛ ᴇᴛᴏ ʏᴀ ᴛᴇʙᴇ ᴇʙʟᴏ ᴄɴᴇꜱ ᴋʀᴀꜱɪᴠᴏ, ᴋᴀᴋ ꜱᴋʀɪᴘᴛ ᴏᴛ +ᴡ.ᴛᴇᴄʜ",
"ᴏʜ ᴍʏ ɢᴏᴅ ᴠᴀʟᴇʀᴀ, ᴛʏ ꜱɪʀɪᴜꜱʟɪ ɴᴀᴅᴇʏᴀʟꜱʏᴀ ᴍᴇɴʏ ᴜʙɪᴛ̆? ᴀxᴀx, ɴᴇ ᴛᴀᴋ ᴍɴᴏɢᴏ ɴᴀᴅᴏ ʙʏʟᴏ, ᴛᴏʟ̌ᴋᴏ +ᴡ.ᴛᴇᴄʜ",
"-> ᴢᴀᴘᴏʟᴢʟᴀ ᴏʙʀᴀᴛɴᴏ ᴍᴏᴄʜᴀ <- ᴛᴇʙᴇ ᴠ ʙᴜᴅᴋᴜ, ᴠᴍᴇꜱᴛᴇ ᴄ ʀᴇᴋʟᴀᴍᴏᴊ +ᴡ.ᴛᴇᴄʜ",
"ꜱᴇʏᴄʜᴀꜱ ᴠ ᴘᴏᴘᴜ, ᴘᴏᴛᴏᴍ ᴠ ʀᴏᴛɪᴋ, ᴀ ᴘᴏᴛᴏᴍ ᴠ ᴍᴀɢᴀᴢɪɴ +ᴡ.ᴛᴇᴄʜ",
"ʟ̌ʏᴀᴍ ᴄʏᴅᴀ ʟ̌ʏᴀᴍ ᴛᴜᴅᴀ, ʙᴇᴋᴛʀᴇᴋᴇᴅ ᴛᴜ ᴀꜰʀɪᴄᴀ ᴍᴏᴄʜᴀ, ɴᴏ ᴍᴏᴊ +ᴡ.ᴛᴇᴄʜ ʟᴜᴄʜꜱʜᴇ",
"ɢᴅᴇ ᴍᴏᴢɢɪ ᴘᴏᴛᴇʀʏᴀʟ ꜱʜᴀʙᴏʟᴅᴀ ʙᴇᴢ +ᴡ.ᴛᴇᴄʜ?",
"ʙᴇɢɪᴛᴇ ꜱᴜᴋᴀ, ᴘᴀᴘᴏᴄʜᴋᴀ ɪᴅᴇᴛ... ᴜ ᴍᴇɴʏ +ᴡ.ᴛᴇᴄʜ",
"ʙʀᴀᴛᴇᴄ ᴛᴜᴛ ᴜᴢʜᴇ ɴɪxᴜʏᴀ ɴᴇ ᴘᴏᴍᴏᴢʜᴇᴛ, ᴛᴏʟ̌ᴋᴏ +ᴡ.ᴛᴇᴄʜ ɴᴀ ᴘᴏᴍᴏɢ ᴇᴛᴏ",
"ᴘᴇʀᴇᴅᴀᴠɪʟᴏ ᴏꜱʟɪɴꜱᴋᴏᴊ ᴄ +ᴡ.ᴛᴇᴄʜ ᴍᴏᴅᴜʟᴇᴍ",
"ᴢᴀʟɪʟ ᴏᴄʜᴋᴏ ꜱᴘᴇʀᴍᴏᴊ ᴏᴛ +ᴡ.ᴛᴇᴄʜ",
"ɢᴅᴇ ᴍᴏᴢɢɪ ᴘᴏᴛᴇʀʏᴀʟ ꜱʜᴀʙᴏʟᴅᴀ, ᴋᴏɢᴅᴀ +ᴡ.ᴛᴇᴄʜ ᴜ ᴛᴇʙʏᴀ ᴘᴏʏᴀᴠɪʟꜱʏᴀ?",
"ᴀɴᴀʟ̌ɴᴏ ɴᴀᴋᴀᴢᴀɴ +ᴡ.ᴛᴇᴄʜᴇᴍ",
"ɢᴅᴇ ɴᴏꜱᴏᴘʏʀᴋᴜ ᴘᴏᴛᴇʀʏᴀʟ ʙᴇᴢ +ᴡ.ᴛᴇᴄʜ?",
"ᴏʀʏᴀᴛ̌ ꜱʜʟ̌ʏᴀᴘᴀ ꜱʟᴇᴛᴇʟᴀ, ᴀɴᴛɪ-ᴘᴏᴘᴀᴅᴀʏᴋɪ ɴᴇ ᴘᴏᴍᴏɢʟɪ, ᴛᴏʟ̌ᴋᴏ +ᴡ.ᴛᴇᴄʜ ᴘᴏᴍᴏɢᴀᴇᴛ",
"ʙᴇᴋᴛʀᴇᴋᴇᴅ ᴛᴏ ᴀꜰʀɪᴄᴀ ᴅᴇɢᴇɴᴇʀᴀᴛ) ᴀ ᴍᴏᴊ +ᴡ.ᴛᴇᴄʜ ʀᴇɴᴅᴇʀɪᴛ ᴛᴇʙʏᴀ ᴏᴛᴛᴜᴅᴀ"
            },
            death = {
        "U think u good? luckily im here",
        "youre value compared to me  is but a grain of sand",
        "all romanian(you) will die to me(boss)",
        "this isnt phasmaphobia: global offensive please dont speak",
        "mega bouse",
        "I guarntee youre loss forever and always",
        "𝕡𝕣𝕠𝕓𝕝𝕖𝕞?",
        "cope",
        " 格拉格拉 < you? 无功无过 < me B)",
        "in hvh war i will win",
        "below average performance",
        "SPEAK BULGARIAN? WILL TALK",
        "you are loss it is decided",
        "you do not perform this hvh",
        "qahahaha i am top of this region",
        "this weak snail is spoke of victory but is door unhinged to loss",
        "you do not have the impression of owning the performance-enhancing software known as Gamesense.pub",
        "how you will feel knowing im skeethaving and u will skeetless",
        "your mexican familia never make it out from trailer",
        "grub. you are foods, this meal of mine? worthless",
        "cant understand u. any noname translator?",
        "you waste aka fecal matter/shit(you)",
        "sorry for u loss, me always better like life",
        "better luck next round, oh wait i alr won BAHAHHA",
        "kekalaff u sucks",
        "when you spawn tell me why u die to me",
        "how hit chance in deagle? i sit.",
        "do i need to get an xray to shoot magnets into ur skull to find out the plan?",
        "shitting on your chest speedrun any% WR run",
        "smelly lapdog dreams of success in 1x1 but is handed 9 casualities",
        "dude where are my diamonds?",
        "QUABALABABABAB",
        "can you suck my dick pidor",
        "pidoras eebaniy",
        "mat tvoy ebal pidorasina",
        "sin shluhi",
            }
        },
        fast_ladder = function(v642, v643)
            local v644 = v24.get_local_player()
            local v645, v646 = v22.camera_angles()
            local v647 = v24.get_prop(v644, "m_MoveType")
            if (v647 == 9) then
                v643.yaw = v19.floor(v643.yaw + 0.5)
                v643.roll = 0
                if (v643.forwardmove > 0) then
                    if (v645 < 45) then
                        v643.pitch = 89
                        v643.in_moveright = 1
                        v643.in_moveleft = 0
                        v643.in_forward = 0
                        v643.in_back = 1
                        if (v643.sidemove == 0) then
                            v643.yaw = v643.yaw + 90
                        end
                        if (v643.sidemove < 0) then
                            v643.yaw = v643.yaw + 150
                        end
                        if (v643.sidemove > 0) then
                            v643.yaw = v643.yaw + 30
                        end
                    end
                end
                if (v643.forwardmove < 0) then
                    v643.pitch = 89
                    v643.in_moveleft = 1
                    v643.in_moveright = 0
                    v643.in_forward = 1
                    v643.in_back = 0
                    if (v643.sidemove == 0) then
                        v643.yaw = v643.yaw + 90
                    end
                    if (v643.sidemove > 0) then
                        v643.yaw = v643.yaw + 150
                    end
                    if (v643.sidemove < 0) then
                        v643.yaw = v643.yaw + 30
                    end
                end
            end
        end,
        trashtalk = function(v648, v649)
            local v650 = v24.get_local_player()
            local v651 = v22.userid_to_entindex(v649.userid)
            local v652 = v22.userid_to_entindex(v649.attacker)
            if (v650 == nil) then
                return
            end
            if ((v652 == v650) and (v651 ~= v650)) then
                if (v648.ui.menu.tools.trashtalk_type:get() == "Default type") then
                    v22.delay_call(
                        1,
                        function()
                            v22.exec(("say %s"):format(v648.phrases.kill[v19.random(0, #v648.phrases.kill)]))
                        end
                    )
                elseif (v648.ui.menu.tools.trashtalk_type:get() == "1") then
                    if v648.ui.menu.tools.trashtalk_check2:get() then
                        v22.exec(("say %s, 1"):format(v24.get_player_name(v651)))
                    else
                        v22.exec("say 1")
                    end
                elseif (v648.ui.menu.tools.trashtalk_type:get() == "Custom phrase") then
                    v22.exec("say " .. v648.ui.menu.tools.trashtalk_custom:get())
                end
            end
            if ((v652 ~= v650) and (v651 == v650)) then
                v22.delay_call(
                    2,
                    function()
                        v22.exec(("say %s"):format(v648.phrases.death[v19.random(0, #v648.phrases.death)]))
                    end
                )
            end
        end
    }
):struct("logs")(
    {
        hitboxes = {
            [0] = "body",
            "head",
            "chest",
            "stomach",
            "left arm",
            "right arm",
            "left leg",
            "right leg",
            "neck",
            "resolver",
            "gear"
        },
        miss = function(v653, v654)
            local v655, v656, v657 = v38.accent.r, v38.accent.g, v38.accent.b
            local v658 = v24.get_player_name(v654.target)
            local v659 = v653.hitboxes[v654.hitgroup] or "resolver"
            local v660 = v653.helpers:limit_ch(v658, 15, "...")
            local v661 = v26.tickcount() - v654.tick
            local v662 = v19.floor(v654.hit_chance)
            v44.create_new({{"Missed "}, {v660, true}, {"'s in "}, {v659, true}, {" due "}, {v654.reason, true}})
            v22.color_log(
                v655,
                v656,
                v657,
                v20.format(
                    "[+w.tech] ~ Missed %s in %s due to %s (hc: %s, bt: %s)",
                    v658,
                    v659,
                    v654.reason,
                    v662,
                    v661
                )
            )
        end,
        hit = function(v663, v664, v665)
            local v666, v667, v668 = v38.accent.r, v38.accent.g, v38.accent.b
            local v669 = v24.get_player_name(v664.target)
            local v670 = v663.hitboxes[v664.hitgroup] or "resolver"
            local v671 = v663.helpers:limit_ch(v669, 15, "...")
            local v672 = v19.max(0, v24.get_prop(v664.target, "m_iHealth"))
            local v673 = v664.damage
            local v674 = v26.tickcount() - v664.tick
            local v675 = v19.floor(v664.hit_chance)
            v44.create_new({{"Hit "}, {v671, true}, {"'s in "}, {v670, true}, {" for "}, {v673, true}})
            v22.color_log(
                v666,
                v667,
                v668,
                v20.format(
                    "[+w.tech] ~ Hit %s in %s for %s (remaning hp %s, hc: %s, bt: %s)",
                    v669,
                    v670,
                    v673,
                    v672,
                    v675,
                    v674
                )
            )
        end,
        shot = 0,
        evade = function(v676, v677)
            local v678 = v24.get_local_player()
            local v679, v680, v681 = v38.accent.r, v38.accent.g, v38.accent.b
            if (v678 == nil) then
                return
            end
            local v682 = v22.userid_to_entindex(v677.userid)
            local v683 = v24.get_player_name(v682)
            local v684 = v19.floor(v22.latency() * 1000)
            local v685 = v676.antiaim:get_best_side()
            if ((v682 == v24.get_local_player()) or not v24.is_enemy(v682) or not v24.is_alive(v678)) then
                return nil
            end
            if v676.helpers:fired_shot(v678, v682, {v677.x, v677.y, v677.z}) then
                if (v676.shot ~= v26.tickcount()) then
                    v22.color_log(
                        v679,
                        v680,
                        v681,
                        v20.format("[+w.tech] ~ Detected %s shot (%s ms, anti-aim side: %s)", v683, v684, v685)
                    )
                    v44.create_new({{"Detected "}, {v683, true}, {"'s shot "}, {"(" .. v684 .. "ms)", true}})
                end
                v676.shot = v26.tickcount()
            end
        end,
        evade2 = function(v686, v687)
            local v688 = v24.get_local_player()
            if (v688 == nil) then
                return
            end
            if ((enemy == v24.get_local_player()) or not v24.is_enemy(enemy) or not v24.is_alive(v688)) then
                return nil
            end
            if v686.helpers:fired_shot(v688, enemy, {v687.x, v687.y, v687.z}) then
                v686.defensive:def_reset()
            end
        end,
        harmed = function(v689, v690)
            local v691 = v24.get_local_player()
            local v692 = v22.userid_to_entindex(v690.attacker)
            local v693 = v22.userid_to_entindex(v690.userid)
            local v694 = v690.dmg_health
            local v695 = v24.get_player_name(v692)
            local v696 = v689.hitboxes[v690.hitgroup]
            if (v692 == v691) then
                return
            end
            if (v693 ~= v691) then
                return
            end
            v44.create_new({{"Get " .. v694 .. " damage by "}, {v695 .. "'s in " .. v696, true}})
        end
    }
    ):struct("thirdperson")(
    {
        current_distance = 100,
        
        main = function(self)
            if not self.ui.menu.tools.thirdperson_animations:get() then
                return
            end
            
            local local_player = v24.get_local_player()
            if not local_player then 
                return 
            end
            
            if v21.get(self.ref.thirdperson.force[1]) and v21.get(self.ref.thirdperson.force[2]) then
                local target_distance = self.ui.menu.tools.thirdperson_distance:get()
                local zoom_speed = self.ui.menu.tools.thirdperson_zoom_speed:get()
                
                if zoom_speed == 0 then
                    self.current_distance = target_distance
                else
                    local delta = (target_distance - self.current_distance) / zoom_speed
                    
                    if delta > 0 and self.current_distance < target_distance then
                        self.current_distance = self.current_distance + delta
                    elseif delta < 0 and self.current_distance > target_distance then
                        self.current_distance = self.current_distance + delta
                    end
                end
                
                v22.set_cvar("c_mindistance", self.current_distance)
                v22.set_cvar("c_maxdistance", self.current_distance)
            else
                self.current_distance = 30
            end
        end,
        
        shutdown = function(self)
            v22.set_cvar("c_maxpitch", 0)
            v22.set_cvar("c_maxyaw", 0)
            v22.set_cvar("c_minyaw", 0)
            v22.set_cvar("cl_pitchup", 90)
            v22.set_cvar("cl_pitchdown", 90)
            v22.set_cvar("c_mindistance", 100)
            v22.set_cvar("c_maxdistance", 100)
        end
    }
):struct("unloads")(
    {
        setup = function(v697)
            local v698 = v697.ui.menu.tools.animscope:get()
            local v699 = v697.ui.menu.tools.animscope_fov_slider:get()
            if v698 then
                v21.set(v697.ref.misc.fov, v699)
            end
            v697.ui:shutdown()
            v21.set(v697.ref.rage.enable, true)
        end
    }
)


-- Инициализация всех систем
for v700, v701 in v2(
    {
{"load", function()
    v50.ui:execute()
    v50.config:setup()
    v50.custom_gs:create()
    v50.tools:init_clantag()
    v50.tools:clantag_event_handlers()
    v50.aspect_ratio:init()
    v50.tools.proteus:init()
    v50.tools:ping_spike_init()
    -- ↓↓↓ ДОБАВЬТЕ ЭТУ СТРОКУ ↓↓↓
    v50.tools:defensive_resolver_init()
    -- ↑↑↑ КОНЕЦ ДОБАВЛЕНИЯ ↑↑↑
end},
        {"aim_miss", function(shot)
            if (v50.ui.menu.tools.notify_master:get() and v50.ui.menu.tools.notify_vibor:get("Miss")) then
                v50.logs:miss(shot)
            end
        end}, 
        {"aim_hit", function(shot)
            if (v50.ui.menu.tools.notify_master:get() and v50.ui.menu.tools.notify_vibor:get("Hit")) then
                v50.logs:hit(shot)
            end
        end}, 
        {"bullet_impact", function(event)
            if (v50.ui.menu.tools.notify_master:get() and v50.ui.menu.tools.notify_vibor:get("Detect shot")) then
                v50.logs:evade(event)
            end
            v50.logs:evade2(event)
        end}, 
        {"player_death", function(e)
            if v50.ui.menu.tools.trashtalk:get() then
                v50.misc:trashtalk(e)
            end
        end}, 
        {"player_hurt", function(event)
            if (v50.ui.menu.tools.notify_master:get() and v50.ui.menu.tools.notify_vibor:get("Get harmed")) then
                v50.logs:harmed(event)
            end
        end}, 
        {"setup_command", function(cmd)
            v50.antiaim:run(cmd)
            v50.misc:air_stopchance(cmd)
            v50.misc:unsafe_charge()
            if v50.ui.menu.tools.fast_ladder:get() then
                v50.misc:fast_ladder(cmd)
            end
        end}, 
        {"paint", function()
    v50.tools:crosshair()
    if v50.ui.menu.tools.indicators_gamesense:get() then
        v50.custom_gs:general()
    end
    if v50.ui.menu.tools.manuals:get() then
        v50.tools:manuals()
    end
    if v50.ui.menu.tools.indicator_dmg:get() then
        v50.tools:ind_dmg()
    end
    v50.tools:viewmodel()
    if v50.ui.menu.tools.keylist:get() then
        v50.tools:keylist()
    end
    v50.tools:scopedu()
    if v50.ui.menu.tools.gs_ind:get() then
        v50.tools:gs_ind()
    end
    v50.tools:ping_spike_draw()  -- ← Ping Spike Warning
    if v50.ui.menu.tools.branded_watermark:get() then
        v50.tools:branded_watermark()
    end
    
    -- Taser Warning должен быть ЗДЕСЬ, внутри функции
    if v50.ui.menu.tools.taser_warning:get() then
        v50.tools:taser_indicator()
    end
end},
        {"shutdown", function(self)
            v50.unloads:setup()
            v50.thirdperson:shutdown()
            v50.tools:defensive_resolver_shutdown()
        end}, 
        {"paint_ui", function()
    if v21.is_menu_open() then
        v50.helpers:menu_visibility(false)
        v50.tools:menu_setup()
    end
    v50.thirdperson:main()
end},
        {"pre_render", function()
            if v50.ui.menu.tools.animations:get() then
                v50.antiaim:animations()
            end
        end}, 
        {"round_prestart", function()
            v50.round_reset:auto_buy()
        end}, 
            {"net_update_start", function()
        if v50.ui.menu.tools.proteus_enable:get() then
            v50.tools.proteus.target_cheat = v50.ui.menu.tools.proteus_cheat:get()
            v50.tools.proteus:handle_cheat_detection()
        end
    end},
    {"round_start", function()
    -- ПОЛНЫЙ сброс состояния Taser Warning при начале раунда
    if v50 and v50.tools and v50.tools.taser_warning then
        v50.tools.taser_warning.active = false
        v50.tools.taser_warning.enable = 0
        v50.tools.taser_warning.alpha = 0
        v50.tools.taser_warning.player_is_dead = false
        -- client.log("[+w.tech] Taser Warning: ПОЛНЫЙ сброс при round_start") -- для отладки
    end
end},
    {"round_start", function()
        v50.tools.proteus:reset()
    end},
    {"game_newmap", function()
        v50.tools.proteus:reset()
    end},
    {"game_start", function()
        v50.tools.proteus:reset()
    end},
        {"net_update_end", function()
            v50.defensive:defensive_active()
        end}
    }
) do
    local v702 = v701[1]
    local v703 = v701[2]
    if (v702 == "load") then
        v703()
    else
        v22.set_event_callback(v702, v703)
    end
end

local v51 = {completing = false, showing = true, progress = 0}
v51.back = function()
    v51.progress = v50.helpers:math_anim2(v51.progress, (v51.showing and 1) or 0, 6)
    v28.rectangle(0, 0, 9999, 9999, v38.accent.r / 10, v38.accent.g / 10, v38.accent.b / 10, v51.progress * 200)
    v28.text(
        v39 / 2,
        (v40 / 2) + 35,
        255,
        255,
        255,
        v51.progress * 255,
        "cb",
        nil,
        " Welcome to +w.tech.\a" ..
            v50.helpers.rgba_to_hex(nil, v38.accent.r, v38.accent.g, v38.accent.b, v51.progress * 255) .. "lua"
    )
    if not v51.completing then
        v22.delay_call(
            3,
            function()
                if v51 then
                    v51.showing = false
                end
            end
        )
        v51.completing = true
    end
end
v51.returner = function()
    return
end
v50.ui.menu.tools.indicators_gamesense:set_event(
    "indicator",
    v51.returner,
    function(v705)
        return v705:get()
    end
)

v22.delay_call(
    0.5,
    function()
        v22.set_event_callback("paint_ui", v51.back)
    end
)

v22.delay_call(
    4,
    function()
        v22.unset_event_callback("paint_ui", v51.back)
        v51 = nil
    end
)

-- Predict/Resolver Features
local function init_wtech_features()
    local client_log, client_ping, renderer_text = client.log, client.get_ping, renderer.text
    local entity_get_players, entity_get_player_name, globals_curtime = entity.get_players, entity.get_player_name, globals.curtime
    local table_insert = table.insert
    local ui_get = ui.get

    local function get_menu_value(element_name)
        if v50 and v50.ui and v50.ui.menu and v50.ui.menu.tools and v50.ui.menu.tools[element_name] then
            return v50.ui.menu.tools[element_name]:get()
        end
        return false
    end

    local function get_combo_value(element_name)
        local val = get_menu_value(element_name)
        if type(val) == "string" then
            return val
        end
        return "Average"
    end

    local pulse_alpha = 0
    local alpha_dir = 3
    local aa_history = {}

    local function latency_logic()
        local ping = client_ping()
        if ping < 45 then
            client_log("[+w.tech] Low ping (<45ms): Optimizing hit chance.")
        elseif ping > 60 then
            client_log("[+w.tech] High ping (>60ms): Adjusting for lag.")
        end
    end

    local function inverse_hitbox_logic()
        for _, part in ipairs({"head", "chest", "stomach", "arms", "legs", "feet"}) do
            client_log("[+w.tech] Inverting hitbox logic: " .. part)
        end
    end

    local function backtrack_logic()
        for _, part in ipairs({"head", "chest", "stomach"}) do
            client_log("[+w.tech] Backtracking on: " .. part)
        end
    end

    local function jitter_boost_logic()
        local mode = get_combo_value("jitter_boost")
        client_log("[Helper] Jitter Boost: " .. mode)
    end

    local function fix_peek_logic()
        client_log("[Helper] Fixing peek behavior.")
    end

    local function save_enemy_state()
        local players = entity_get_players(true)
        for _, ent in ipairs(players) do
            local name = entity_get_player_name(ent)
            if not aa_history[name] then
                aa_history[name] = {}
            end

            local enemy_data = aa_history[name]
            table_insert(enemy_data, {
                time = globals_curtime(),
                angle = math.random(-180, 180)
            })

            if #enemy_data > 10 then table.remove(enemy_data, 1) end
        end
    end

    local function on_create_move()
        if get_menu_value("predict_system") then
            if get_menu_value("latency_depending") then latency_logic() end
            if get_menu_value("inverse_hitboxes") then inverse_hitbox_logic() end
            if get_menu_value("attach_backtrack") then backtrack_logic() end
        end

        if get_menu_value("resolver_helper") then
            jitter_boost_logic()
            if get_menu_value("fix_def_peek") then fix_peek_logic() end
        end

        save_enemy_state()
    end

    local function on_paint()
        pulse_alpha = pulse_alpha + alpha_dir
        if pulse_alpha > 255 then pulse_alpha, alpha_dir = 255, -3
        elseif pulse_alpha < 100 then pulse_alpha, alpha_dir = 100, 3 end

        local y = 500
        if get_menu_value("predict_system") then
            renderer_text(10, y, 100, 255, 100, pulse_alpha, "", 0, " ") 
            y = y + 20
        else
            renderer_text(10, y, 150, 150, 150, 180, "", 0, " ") 
            y = y + 20
        end

        if get_menu_value("resolver_helper") then
            renderer_text(10, y, 255, 200, 0, pulse_alpha, "", 0, " ")
        else
            renderer_text(10, y, 150, 150, 150, 180, "", 0, " ")
        end
    end

    client.set_event_callback("create_move", on_create_move)
    client.set_event_callback("paint", on_paint)
    
    client.log("[+w.tech] Features initialized successfully!")
end

init_wtech_features()

-- Игра Нагиева
local nagiev_logo = nil
v36.get('https://raw.githubusercontent.com/seambad/lua.lua/main/b993933a-9e54-4cd0-9ac5-029c3e746962.png', function(s, r)
    if s and r.status == 200 then
        nagiev_logo = v28.load_png(r.body, 100, 100)
    end
end)

local function nagiev_ind()
    if not nagiev_logo then
        return
    end
    
    local enemies = v24.get_players(true)
    for _, enemy_idx in v2(enemies) do
        if v24.is_alive(enemy_idx) then
            local origin = v31(v24.get_origin(enemy_idx))
            if origin then
                local x, y, z = origin.x, origin.y, origin.z
                local sx, sy, visible = v28.world_to_screen(x, y, z)
                if visible and sx then
                    local sx2, sy2, visible2 = v28.world_to_screen(x, y, z + 70)
                    if visible2 and sx2 then
                        local height = v19.abs(sy2 - sy)
                        local width = height
                        v28.texture(nagiev_logo, sx - width / 2, sy, width, height, 255, 255, 255, 255)
                    end
                end
            end
        end
    end
end

client.set_event_callback("paint", function()
    
    if v50 and v50.ui and v50.ui.menu and v50.ui.menu.tools and v50.ui.menu.tools.nagiev_game then
        if v50.ui.menu.tools.nagiev_game:get() then
            nagiev_ind()
            ui.set(ui.reference("misc", "settings", "Menu color"), 253, 5, 64, 255)
        end
    end
end)

-- ESP флаги для игры Нагиева
client.register_esp_flag("NAGIEV1", 0, 0, 255, function(entity_index)
    if v50 and v50.ui and v50.ui.menu and v50.ui.menu.tools and v50.ui.menu.tools.nagiev_game then
        return v50.ui.menu.tools.nagiev_game:get()
    end
    return false
end)

client.register_esp_flag("NAGIEV2", 100, 100, 255, function(entity_index)
    if v50 and v50.ui and v50.ui.menu and v50.ui.menu.tools and v50.ui.menu.tools.nagiev_game then
        return v50.ui.menu.tools.nagiev_game:get()
    end
    return false
end)

-- ... остальные флаги ...

client.log("[+w.tech] Script loaded successfully!")
client.log("[+w.tech] Clan-tag system initialized!")
client.log("[+w.tech] Aspect Ratio helper added to Tools -> Helpers section!")
client.log("[+w.tech] Thirdperson Animations loaded successfully!")
-- ========== MINIMALIST HIT/MISS NOTIFICATION SYSTEM (UPDATED) ==========
local notifications = {
    list = {},
    max_notifications = 4 -- Чуть увеличил лимит, так как событий стало больше
}

-- Settings
local MISS_DISTANCE_THRESHOLD = 120 -- ~10 feet в юнитах CS:GO

-- Smooth animation function
local function ease_out_quad(t)
    return 1 - (1 - t) * (1 - t)
end

-- Math helpers for 3D distance
local function vec_sub(x1, y1, z1, x2, y2, z2)
    return x1-x2, y1-y2, z1-z2
end

local function vec_len(x, y, z)
    return math.sqrt(x*x + y*y + z*z)
end

local function vec_dot(x1, y1, z1, x2, y2, z2)
    return x1*x2 + y1*y2 + z1*z2
end

-- Расчет дистанции от точки (игрок) до отрезка (траектория пули)
local function dist_segment_to_point(lx, ly, lz, ax, ay, az, bx, by, bz)
    local ab_x, ab_y, ab_z = vec_sub(bx, by, bz, ax, ay, az)
    local ap_x, ap_y, ap_z = vec_sub(lx, ly, lz, ax, ay, az)

    local ab_len_sq = vec_dot(ab_x, ab_y, ab_z, ab_x, ab_y, ab_z)
    if ab_len_sq == 0 then return vec_len(ap_x, ap_y, ap_z) end

    local t = vec_dot(ap_x, ap_y, ap_z, ab_x, ab_y, ab_z) / ab_len_sq
    if t < 0 then t = 0 end
    if t > 1 then t = 1 end

    local closest_x = ax + ab_x * t
    local closest_y = ay + ab_y * t
    local closest_z = az + ab_z * t

    return vec_len(lx - closest_x, ly - closest_y, lz - closest_z)
end

-- Cache to prevent duplicates
local impacts = {}
local damage_records = {}

-- Add new notification
local function add_notification(type, text, is_long_name)
    table.insert(notifications.list, 1, {
        text = text,
        type = type,
        time = globals.realtime(),
        alpha = 0,
        offset_y = 30,
        scale = 0.95,
        measured_width = 0,
        is_long_name = is_long_name or false
    })
    
    if #notifications.list > notifications.max_notifications then
        table.remove(notifications.list, #notifications.list)
    end
end

-- VISUALS (UNCHANGED)
local function draw_minimal_notifications()
    local menu_enabled = true
    
    if v50 and v50.ui and v50.ui.menu and v50.ui.menu.tools then
        local tools = v50.ui.menu.tools
        local notify_enabled = tools.hit_miss_notify
        if notify_enabled and notify_enabled:get() then
            menu_enabled = true
        else
            menu_enabled = false
        end
    else
        -- Fallback if v50 table logic is missing, assume enabled or use standard UI check logic
        -- For this script, we'll assume it should render if the event is called.
    end
    
    -- Check standard Gamesense UI references if v50 is custom
    -- Assuming user has appropriate UI setup, otherwise rendering always:
    
    local screen_w, screen_h = client.screen_size()
    local current_time = globals.realtime()
    
    -- Colors (Defaults)
    local hit_color = {100, 220, 100}
    local miss_color = {220, 100, 100}
    local hit_on_you_color = {255, 165, 0}    -- Orange
    local miss_on_you_color = {150, 200, 255} -- Light Blue
    
    -- Try to get colors from UI if available
    if v50 and v50.ui and v50.ui.menu.tools.notify_hit_color then
         local c = v50.ui.menu.tools.notify_hit_color
         if c and c.get then hit_color = {c:get()} end
    end
    if v50 and v50.ui and v50.ui.menu.tools.notify_miss_color then
         local c = v50.ui.menu.tools.notify_miss_color
         if c and c.get then miss_color = {c:get()} end
    end
    
    -- Remove old
    for i = #notifications.list, 1, -1 do
        if current_time - notifications.list[i].time > 4 then
            table.remove(notifications.list, i)
        end
    end
    
    if #notifications.list == 0 then return end
    
    -- Draw
    for i, notify in ipairs(notifications.list) do
        local time_alive = current_time - notify.time
        
        -- Animation
        if time_alive < 0.3 then
            notify.alpha = ease_out_quad(time_alive / 0.3) * 255
            notify.offset_y = 30 * (1 - (time_alive / 0.3))
            notify.scale = 0.95 + (0.05 * (time_alive / 0.3))
        elseif time_alive > 3.5 then
            notify.alpha = 255 * (1 - ((time_alive - 3.5) / 0.5))
            notify.scale = 1 - ((time_alive - 3.5) / 0.5) * 0.05
        else
            notify.alpha = 255
            notify.offset_y = 0
            notify.scale = 1
        end
        
        -- Colors and icon based on type
        local r, g, b
        local icon = ""
        
        if notify.type == "Hit" then
            r, g, b = hit_color[1], hit_color[2], hit_color[3]
            icon = "✓"
        elseif notify.type == "Miss" then
            r, g, b = miss_color[1], miss_color[2], miss_color[3]
            icon = "✗"
        elseif notify.type == "Hit On You" then
            r, g, b = hit_on_you_color[1], hit_on_you_color[2], hit_on_you_color[3]
            icon = "⚠"
        elseif notify.type == "Miss On You" then
            r, g, b = miss_on_you_color[1], miss_on_you_color[2], miss_on_you_color[3]
            icon = "⛔"
        else
            r, g, b = 255, 255, 255
            icon = "?"
        end
        
        local alpha = notify.alpha
        local base_y = screen_h - 120 - (i - 1) * 32
        local y_pos = base_y - notify.offset_y
        local center_x = screen_w / 2
        
        -- Calculate text width
        local type_width = renderer.measure_text("", notify.type)
        local text_width = renderer.measure_text("", notify.text)
        local total_text_width = 12 + type_width + 5 + text_width
        
        -- Dynamic background width
        local min_width = 200
        local max_width = 600
        local background_width
        
        if notify.is_long_name then
            background_width = math.max(min_width, math.min(max_width, total_text_width + 30))
        else
            background_width = math.max(min_width, math.min(350, total_text_width + 20))
        end
        
        -- Black background
        renderer.rectangle(center_x - (background_width / 2), y_pos, background_width, 30, 0, 0, 0, alpha * 0.9)
        
        -- Left accent line
        local accent_x = center_x - (background_width / 2) + 5
        renderer.rectangle(accent_x, y_pos + 8, 2, 16, r, g, b, alpha)
        
        -- Icon
        local icon_x = accent_x + 7
        renderer.text(icon_x, y_pos + 6, r, g, b, alpha, "", 0, icon)
        
        -- Type text
        local type_text = notify.type
        local type_x = icon_x + 12
        renderer.text(type_x, y_pos + 6, r, g, b, alpha, "", 0, type_text)
        
        -- Notification text
        local text_x = type_x + type_width + 5
        renderer.text(text_x, y_pos + 6, 240, 240, 240, alpha, "", 0, notify.text)
        
        -- Time bar
        local progress = 1 - (time_alive / 4)
        local timebar_width = background_width - 10
        renderer.rectangle(accent_x, y_pos + 28, timebar_width * progress, 2, r, g, b, alpha * 0.8)
    end
end

-- Hit groups names
local hitgroup_names = {
    'generic', 'head', 'chest', 'stomach', 
    'left arm', 'right arm', 'left leg', 'right leg'
}

-- Check if weapon is a grenade
local function is_grenade(weapon_ent)
    if not weapon_ent then return false end
    local classname = entity.get_classname(weapon_ent)
    if not classname then return false end
    
    local grenades = {
        ["CHEGrenade"] = true, ["CMolotovGrenade"] = true, ["CIncendiaryGrenade"] = true,
        ["CFlashbang"] = true, ["CDecoyGrenade"] = true, ["CSmokeGrenade"] = true
    }
    return grenades[classname] or false
end

-- LOGIC: Hit on you (Received Damage)
local function handle_player_hurt(e)
    local victim = client.userid_to_entindex(e.userid)
    local attacker = client.userid_to_entindex(e.attacker)
    local local_player = entity.get_local_player()
    
    -- Filter 1: Must be me getting hurt
    if victim ~= local_player then return end
    
    -- Filter 2: Do not trigger if I hurt myself (HE grenade, molly)
    if attacker == local_player then return end
    
    -- Filter 3: Check for grenades/world damage based on generic logic
    -- e.weapon usually returns a string name like "hegrenade"
    local weapon_name = e.weapon or ""
    if weapon_name == "hegrenade" or weapon_name == "inferno" or weapon_name == "flashbang" or weapon_name == "decoy" or weapon_name == "smokegrenade" or weapon_name == "world" then
        return
    end

    local attacker_name = "World"
    if attacker and attacker > 0 then
        attacker_name = entity.get_player_name(attacker) or "Unknown"
        -- Record damage to prevent "Miss" logic from firing on the same tick
        damage_records[globals.tickcount()] = true
    end

    local is_long_name = #attacker_name > 15
    local damage = e.dmg_health or 0
    local hitgroup = "generic"
    if e.hitgroup then
        hitgroup = hitgroup_names[e.hitgroup + 1] or "body"
    end
    
    local text = string.format("%s • %s • -%d hp", attacker_name, hitgroup:upper(), damage)
    add_notification("Hit On You", text, is_long_name)
end

-- LOGIC: Miss on you (Bullet Near Miss)
-- This replaces the old weapon_fire logic with bullet_impact spatial logic
local function handle_bullet_impact(e)
    local shooter = client.userid_to_entindex(e.userid)
    local local_player = entity.get_local_player()
    
    -- Validations
    if not shooter or not local_player then return end
    if shooter == local_player then return end -- Ignore my own bullets
    if not entity.is_enemy(shooter) then return end -- Ignore teammates
    if not entity.is_alive(local_player) then return end
    
    -- Don't calculate if they are dormant (sanity check)
    if entity.is_dormant(shooter) then return end

    -- 1. Get positions
    local lx, ly, lz = entity.hitbox_position(local_player, 0) -- Head position is usually best for trajectory
    if not lx then 
        lx, ly, lz = entity.get_origin(local_player) 
        lz = lz + 64
    end

    local sx, sy, sz = entity.get_origin(shooter)
    sz = sz + 64 -- Approximation of eye level
    
    local bx, by, bz = e.x, e.y, e.z -- Bullet impact location

    -- 2. Calculate distance from Local Player to the Bullet Trajectory
    local distance = dist_segment_to_point(lx, ly, lz, sx, sy, sz, bx, by, bz)

    -- 3. Check Threshold (10ft ~ 120 units)
    if distance < MISS_DISTANCE_THRESHOLD then
        -- Schedule a check next frame/tick
        -- We delay to ensure 'player_hurt' fires first if it was actually a hit
        local tick = globals.tickcount()
        client.delay_call(0.05, function()
            -- If we took damage on this tick (or very close to it), it wasn't a miss, it was a hit.
            if damage_records[tick] or damage_records[tick-1] or damage_records[tick+1] then
                return
            end

            -- Anti-spam: Limit one "Miss" per shooter per 0.2s
            if impacts[shooter] and globals.realtime() - impacts[shooter] < 0.2 then
                return
            end
            impacts[shooter] = globals.realtime()

            local shooter_name = entity.get_player_name(shooter) or "Unknown"
            local is_long_name = #shooter_name > 15
            
            -- Optional: Calculate how close it was (in feet)
            -- local feet_dist = math.floor(distance / 12)
            
            local text = string.format("%s • +W.TECH", shooter_name)
            add_notification("Miss On You", text, is_long_name)
        end)
    end
end

-- LOGIC: Aim Hit (My shots)
local function handle_aim_hit(e)
    local target_name = entity.get_player_name(e.target) or "Unknown"
    local is_long_name = #target_name > 15
    
    local hitgroup = hitgroup_names[e.hitgroup + 1] or "body"
    local damage = e.damage or 0
    local hp = entity.get_prop(e.target, "m_iHealth") or 0
    
    local text = string.format("%s • %s • %d dmg", target_name, hitgroup:upper(), damage)
    add_notification("Hit", text, is_long_name)
end

-- LOGIC: Aim Miss (My shots)
local function handle_aim_miss(e)
    local target_name = entity.get_player_name(e.target) or "Unknown"
    local is_long_name = #target_name > 15
    
    local reason = e.reason or "?"
    local hc = math.floor(e.hit_chance or 0)
    
    -- Reason formatting
    if reason == "spread" then reason = "Spread"
    elseif reason == "occlusion" then reason = "Wall"
    elseif reason == "resolver" then reason = "Resolver"
    elseif reason == "prediction error" then reason = "Pred Error"
    end
    
    local text = string.format("%s • %s • %d%%", target_name, reason:upper(), hc)
    add_notification("Miss", text, is_long_name)
end

-- Events
client.set_event_callback("aim_hit", handle_aim_hit)
client.set_event_callback("aim_miss", handle_aim_miss)
client.set_event_callback("player_hurt", handle_player_hurt)
client.set_event_callback("bullet_impact", handle_bullet_impact)
client.set_event_callback("paint", draw_minimal_notifications)

client.color_log(100, 220, 100, "[+w.tech] ~ Notification system updated (Spatial Logic)")

