local hutao_lib = {}

hutao_lib.entity = {}
hutao_lib.math = {}
hutao_lib.base64 = {}
hutao_lib.gradient = {}

hutao_lib.base64.chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

hutao_lib.print = function (...) 
    local text = "" 
    if type(text) == "table" then 
        for index, value in ipairs(...) do 
            text = tostring(value) .. ", " 
        end 
    else 
        text = tostring(...) 
    end 
    general.log_to_console(text) 
end

hutao_lib.contains = function (tab, val)

    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false

end

hutao_lib.combo_text = function (...)

    if not ... then return end
    local check_type = type(...) == "table" and ... or {...}

    if #check_type == 0 then return end

    local out_text = ""
    for index, value in ipairs(check_type) do
        out_text = out_text .. value .. "\0"
    end

    out_text = out_text .. "\0"

    return out_text

end

hutao_lib.fade_text = function(text, x, y, r1, g1, b1, a1, r2, g2, b2, a2)
    local output
    local count = #text-1
    local size = 0

    local rinc = (r2 - r1) / count
    local ginc = (g2 - g1) / count
    local binc = (b2 - b1) / count
    local ainc = (a2 - a1) / count

    for i=1, count+1 do
        output = renderer.draw_text(x+size,y, text:sub(i, i), r1, g1, b1, a1, font_flags.drop_shadow)
        r1 = r1 + rinc
        g1 = g1 + ginc
        b1 = b1 + binc
        a1 = a1 + ainc
        local textsize = renderer.get_text_size(text:sub(i, i))
        size = size + textsize.x
    end
    return output
end

hutao_lib.hsv_to_rgb = function(h, s, v)
    h = h / 360 
    s = s / 100 
    v = v / 100
	local r, g, b

	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)

	i = i % 6

	if i == 0 then r, g, b = v, t, p
	elseif i == 1 then r, g, b = q, v, p
	elseif i == 2 then r, g, b = p, v, t
	elseif i == 3 then r, g, b = p, q, v
	elseif i == 4 then r, g, b = t, p, v
	elseif i == 5 then r, g, b = v, p, q
	end
	return hutao_lib.color(math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), 255)
end

hutao_lib.get_eyes_pos = function (player)

    if not player or player:get_netvar_int("m_lifeState") ~= 0 then return false end
    local origin = player:get_netvar_c_vector3d("m_vecOrigin")
    if not origin then return false end
    local view_offset = player:get_netvar_c_vector3d("m_vecViewOffset")
    if not view_offset then return false end
    return hutao_lib.vector(origin.x + view_offset.x, origin.y + view_offset.y, origin.z + view_offset.z)

end

hutao_lib.vector = function (x, y ,z)
    return (function ()
        local vector_table = {}
        vector_table.__index = vector_table

        function vector_table.__add (a, b)

            local a_type = type(a);
            local b_type = type(b);
        
            if ((a_type == "table" or a_type == "userdata") and (b_type == "table" or b_type == "userdata")) then
                return vector_table.new(a.x + b.x, a.y + b.y, a.z + b.z);
            elseif ((a_type == "table" or a_type == "userdata") and b_type == "number") then
                return vector_table.new(a.x + b, a.y + b, a.z + b);
            elseif (a_type == "number" and (b_type == "table" or b_type == "userdata")) then
                return vector_table.new(a + b.x, a + b.y, a + b.z);
            end

        end
    
        function vector_table.__sub (a, b)
            local a_type = type(a);
            local b_type = type(b);
        
            if ((a_type == "table" or a_type == "userdata") and (b_type == "table" or b_type == "userdata")) then
                return Vector(a.x - b.x, a.y - b.y, a.z - b.z);
            elseif ((a_type == "table" or a_type == "userdata") and b_type == "number") then
                return Vector(a.x - b, a.y - b, a.z - b);
            elseif (a_type == "number" and (b_type == "table" or b_type == "userdata")) then
                return Vector(a - b.x, a - b.y, a - b.z);
            end
        end

        function vector_table.__eq (a, b)
            return a.x == b.x and a.y == b.y and a.z == b.z;
        end

        function vector_table.__unm (a)
            return vector_table.new(-a.x, -a.y, -a.z);
        end

        function vector_table.__mul (a, b)
            local a_type = type(a);
            local b_type = type(b);
        
            if ((a_type == "table" or a_type == "userdata") and (b_type == "table" or b_type == "userdata")) then
                return vector_table.new(a.x * b.x, a.y * b.y, a.z * b.z);
            elseif ((a_type == "table" or a_type == "userdata") and b_type == "number") then
                return vector_table.new(a.x * b, a.y * b, a.z * b);
            elseif (a_type == "number" and (b_type == "table" or b_type == "userdata")) then
                return vector_table.new(a * b.x, a * b.y, a * b.z);
            end
        end

        function vector_table.__div (a, b)
            local a_type = type(a);
            local b_type = type(b);
        
            if ((a_type == "table" or a_type == "userdata") and (b_type == "table" or b_type == "userdata")) then
                return vector_table.new(a.x / b.x, a.y / b.y, a.z / b.z);
            elseif ((a_type == "table" or a_type == "userdata") and b_type == "number") then
                return vector_table.new(a.x / b, a.y / b, a.z / b);
            elseif (a_type == "number" and (b_type == "table" or b_type == "userdata")) then
                return vector_table.new(a / b.x, a / b.y, a / b.z);
            end
        end

        function vector_table.__tostring (a)
            return "hutao_lib.vector_c ( x: " .. a.x .. ", y: " .. a.y .. ", z: " .. a.z .. " )";
        end

        function vector_table:clear()
            self.x = 0.0;
            self.y = 0.0;
            self.z = 0.0;
        end

        function vector_table:length2dsqr()
            return (self.x * self.x) + (self.y * self.y);
        end
        
        function vector_table:lengthsqr()
            return (self.x * self.x) + (self.y * self.y) + (self.z * self.z);
        end
        
        function vector_table:length2d()
            return math.sqrt(self:length2dsqr());
        end
        
        function vector_table:length()
            return math.sqrt(self:lengthsqr());
        end
        
        function vector_table:dot(other)
            return (self.x * other.x) + (self.y * other.y) + (self.z * other.z);
        end
        
        function vector_table:cross(other)
            return vector_table.new((self.y * other.z) - (self.z * other.y), (self.z * other.x) - (self.x * other.z), (self.x * other.y) - (self.y * other.x));
        end
        
        function vector_table:dist(other)
            return (other - self):length();
        end
        
        function vector_table:is_zero(tolerance)
            tolerance = tolerance or 0.001;
        
            if (self.x < tolerance and self.x > -tolerance and self.y < tolerance and self.y > -tolerance and self.z < tolerance and self.z > -tolerance) then
                return true;
            end
        
            return false;
        end
        
        function vector_table:normalize()
            local l = self:length();
            if (l <= 0.0) then
                return 0.0;
            end
        
            self.x = self.x / l;
            self.y = self.y / l;
            self.z = self.z / l;
        
            return l;
        end
        
        function vector_table:normalize_no_len()
            local l = self:length();
            if (l <= 0.0) then
                return;
            end
        
            self.x = self.x / l;
            self.y = self.y / l;
            self.z = self.z / l;
        end
        
        function vector_table:normalized()
            local l = self:length();
            if (l <= 0.0) then
                return vector_table.new();
            end
        
            return vector_table.new(self.x / l, self.y / l, self.z / l);
        end

        function vector_table:set(x, y, z)

            if type(x) == "userdata" then
                x = x.x
                y = x.y
                z = x.z
            else
                if (type(x) ~= "number") then
                    x = 0.0;
                end
            
                if (type(y) ~= "number") then
                    y = 0.0;
                end
            
                if (type(z) ~= "number") then
                    z = 0.0;
                end
            end

            self.x = x
            self.y = y
            self.z = z

        end

        function vector_table:get()
    
            return {
                x = self.x,
                y = self.y,
                z = self.z
            }

        end
        
        function vector_table:unpack()
            return self.x, self.y, self.z
        end

        function vector_table:to_screen()
            local vector_to_screen = renderer.get_world_to_screen(self.x, self.y, self.z)
            return vector_table.new(vector_to_screen.x, vector_to_screen.y, 0)
        end

        function vector_table.new(x, y, z)
            
            if type(x) == "userdata" then
                x = x.x
                y = x.y
                z = x.z
            else
                if (type(x) ~= "number") then
                    x = 0.0;
                end
            
                if (type(y) ~= "number") then
                    y = 0.0;
                end
            
                if (type(z) ~= "number") then
                    z = 0.0;
                end
            end

            return setmetatable({
                x = x,
                y = y,
                z = z,
            }, vector_table)

        end

        return vector_table
        
    end)().new(x, y ,z)
end

hutao_lib.color = function (color_r, color_g, color_b, color_a)

    return (function ()
        local color_function = {};
        color_function.__index = color_function;
    
        function color_function.__tostring (a)
            return "hutao_lib.color_c ( r: " .. a.r .. ", g: " .. a.g .. ", b: " .. a.b .. ", a: " .. a.a .. " )";
        end

        function color_function:get()
            return {
                r = self.r,
                g = self.g,
                b = self.b,
                a = self.a
            }
        end
    
        function color_function:unpack()
            return self.r, self.g, self.b, self.a
        end

        function color_function:to_hex()
            local r, g, b = self:unpack()

            local rgb = (r * 0x10000) + (g * 0x100) + b

            return string.format("%x", rgb)
        end
        
        function color_function:to_hsv()
            local r, g, b = self.r / 255, self.g / 255, self.b / 255
            local max, min = math.max(r, g, b), math.min(r, g, b)
            local h, s, v
            v = max
          
            local d = max - min
            if max == 0 then s = 0 else s = d / max end
          
            if max == min then
              h = 0
            else
              if max == r then
              h = (g - b) / d
              if g < b then h = h + 6 end
              elseif max == g then h = (b - r) / d + 2
              elseif max == b then h = (r - g) / d + 4
              end
              h = h / 6
            end
            return color_function.new(math.floor(h * 360), math.floor(s * 100), math.floor(v * 100), 255)
        end

        function color_function:set(color, color_2, color_3, color_4)
    
            local color_r, color_g, color_b, color_a
            if type(color) == "userdata" then
                color_r, color_g, color_b, color_a = color:r(), color:g(), color:b(), color:a()
            elseif type(color) == "table" then
                if color.r ~= nil then
                    color_r, color_g, color_b, color_a = color.r, color.g, color.b, color.a
                else
                    color_r, color_g, color_b, color_a = color[1], color[2], color[3], color[4]
                end
            elseif type(color) == "number" then
                color_r, color_g, color_b, color_a = color, color_2, color_3, color_4
            else
                return
            end
    
            self.r = color_r;
            self.g = color_g;
            self.b = color_b;
            self.a = color_a;

        end
    
        function color_function.new(color_r, color_g, color_b, color_a)

            if type(color_r) == "userdata" then
                color_r, color_g, color_b, color_a = color_r:r(), color_r:g(), color_r:b(), color_r:a()
            elseif type(color_r) == "table" then
                if color_r.r ~= nil then
                    color_r, color_g, color_b, color_a = color_r.r, color_r.g, color_r.b, color_r.a
                else
                    color_r, color_g, color_b, color_a = color_r[1], color_r[2], color_r[3], color_r[4]
                end
            elseif type(color_r) == "number" then
                color_r, color_g, color_b, color_a = color_r, color_g, color_b, color_a
            else
                return
            end

            return setmetatable({
                r = color_r,
                g = color_g,
                b = color_b,
                a = color_a,
             }, color_function)
        end

        return color_function

    end)().new(color_r, color_g, color_b, color_a)

end

hutao_lib.menu = (function ()
    local menu_lib = {}

    menu_lib.__index = menu_lib

    function menu_lib:visible(bool)
        if not self or not self.menu_name then return end
        menu.override_visibility(self.menu_name, bool)
    end

    function menu_lib:get(value)
        
        if not self or not self.menu_type or not self.menu_name then return end

        if self.menu_type == "second_colorpicker" then
            return menu.get_colorpicker(self.menu_name)
        elseif self.menu_type == "multiselection" then
            return menu.get_multiselection_item(self.menu_name, value)
        elseif menu["get_" .. self.menu_type] ~= nil then
            return menu["get_" .. self.menu_type](self.menu_name)
        end
        
        return

    end

    function menu_lib:set(menu_value1, menu_value2, menu_value3, menu_value4)

        if not self or not self.menu_type or not self.menu_name then return end
        if self.menu_type == "separator" then return end

        if self.menu_type == "colorpicker" or self.menu_type == "second_colorpicker" then
            menu.set_colorpicker(self.menu_name, menu_value1, menu_value2, menu_value3, menu_value4)
        elseif self.menu_type == "keybind" then
            if menu_value1 then
                menu.set_keybind_button(self.menu_name, menu_value1)
            end

            if menu_value2 then
                menu.set_keybind_mode(self.menu_name, menu_value2)
            end
        elseif self.menu_type == "flex_checkbox" then
            if menu_value1 then
                menu.set_flex_checkbox_button(self.menu_name, menu_value1)
            end

            if menu_value2 then
                menu.set_flex_checkbox_mode(self.menu_name, menu_value2)
            end
        elseif self.menu_type == "multiselection" then
            menu.set_multiselection(self.menu_name, menu_value1, menu_value2)
        elseif menu["set_" .. self.menu_type] ~= nil then
            menu["set_" .. self.menu_type](self.menu_name, menu_value1)
        end
        
    end

    function menu_lib.separator(menu_name)

        if not menu_name or type(menu_name) ~= "string" then
            return
        end

        menu.add_separator(menu_name)

        return setmetatable({
            menu_type = "separator",
            menu_name = menu_name,
        },menu_lib)

    end

    function menu_lib.text(menu_name, default_value)

        if not menu_name or type(menu_name) ~= "string" then
            return
        end

        menu.add_text(menu_name)
        if default_value then
            menu.set_text(menu_name, default_value)
        end

        return setmetatable({
            menu_type = "text",
            menu_name = menu_name,
        },menu_lib)
    end

    function menu_lib.checkbox(menu_name, default_value)

        if not menu_name or type(menu_name) ~= "string" then
            return
        end

        if not default_value or type(default_value) ~= "boolean" then 
            default_value = false 
        end

        menu.add_checkbox(menu_name, default_value)

        return setmetatable({
            menu_type = "checkbox",
            menu_name = menu_name,
        },menu_lib)

    end

    function menu_lib.slider(menu_name, default_value, min_value, max_value)

        if not menu_name or type(menu_name) ~= "string" then
            return
        end

        if not default_value or type(default_value) ~= "number" then 
            default_value = 0 
        end

        if not min_value or type(min_value) ~= "number" then 
            min_value = 0 
        end

        if not max_value or type(max_value) ~= "number" then 
            max_value = 0 
        end

        menu.add_slider(menu_name, default_value, min_value, max_value)

        return setmetatable({
            menu_type = "slider",
            menu_name = menu_name,
        },menu_lib)

    end

    function menu_lib.combo(menu_name, default_value, combo_table)
        
        if not menu_name or type(menu_name) ~= "string" then
            return
        end

        if not default_value or type(default_value) ~= "number" then 
            default_value = 0 
        end

        if not combo_table or type(combo_table) ~= "table" then 
            return
        end

        menu.add_combo(menu_name, default_value, hutao_lib.combo_text(combo_table))

        return setmetatable({
            menu_type = "combo",
            menu_name = menu_name,
        },menu_lib)

    end

    function menu_lib.multiselection(menu_name, combo_table)
        
        if not menu_name or type(menu_name) ~= "string" then
            return
        end

        if not combo_table or type(combo_table) ~= "table" then 
            return
        end

        menu.add_multiselection(menu_name, hutao_lib.combo_text(combo_table))

        return setmetatable({
            menu_type = "multiselection",
            menu_name = menu_name,
        },menu_lib)

    end

    function menu_lib.second_colorpicker(menu_name, r, g, b, a, alpha_slider)
        
        if not menu_name or type(menu_name) ~= "string" then
            return
        end

        if not r or type(r) ~= "number" then r = 255 end
        if not g or type(g) ~= "number" then g = 255 end
        if not b or type(b) ~= "number" then b = 255 end
        if not a or type(a) ~= "number" then a = 255 end
        if not alpha_slider or type(alpha_slider) ~= "boolean" then alpha_slider = false end

        menu.add_second_colorpicker(menu_name, r, g, b, a, alpha_slider)

        return setmetatable({
            menu_type = "second_colorpicker",
            menu_name = menu_name,
        },menu_lib)

    end

    function menu_lib.colorpicker(menu_name, r, g, b, a, alpha_slider)
        
        if not menu_name or type(menu_name) ~= "string" then
            return
        end

        if not r or type(r) ~= "number" then r = 255 end
        if not g or type(g) ~= "number" then g = 255 end
        if not b or type(b) ~= "number" then b = 255 end
        if not a or type(a) ~= "number" then a = 255 end
        if not alpha_slider or type(alpha_slider) ~= "boolean" then alpha_slider = false end

        menu.add_colorpicker(menu_name, r, g, b, a, alpha_slider)

        return setmetatable({
            menu_type = "colorpicker",
            menu_name = menu_name,
        },menu_lib)

    end

    function menu_lib.keybind(menu_name, default_button, mode, keybind_options)
        
        if not menu_name or type(menu_name) ~= "string" then
            return
        end

        if not default_button or type(default_button) ~= "number" then default_button = 0 end
        if not mode or type(mode) ~= "number" then mode = 0 end
        if not keybind_options or type(keybind_options) ~= "number" then keybind_options = 0 end

        menu.add_keybind(menu_name, default_button, mode, keybind_options)

        return setmetatable({
            menu_type = "keybind",
            menu_name = menu_name,
        },menu_lib)

    end

    function menu_lib.flex_checkbox(menu_name, default_button, mode)
        
        if not menu_name or type(menu_name) ~= "string" then
            return
        end

        if not default_button or type(default_button) ~= "number" then default_button = 0 end
        if not mode or type(mode) ~= "number" then mode = 0 end

        menu.add_flex_checkbox(menu_name, default_button, mode)

        return setmetatable({
            menu_type = "flex_checkbox",
            menu_name = menu_name,
        },menu_lib)

    end

    return menu_lib
end)()

hutao_lib.animation = (function ()

    -- For all easing functions:
    -- t = elapsed time
    -- b = begin
    -- c = change == ending - beginning
    -- d = duration (total time)

    local function linear(t, b, c, d)
        return c * t / d + b
    end

    local function inQuad(t, b, c, d)
        t = t / d
        return c * math.pow(t, 2) + b
    end

    local function outQuad(t, b, c, d)
        t = t / d
        return -c * t * (t - 2) + b
    end

    local function inOutQuad(t, b, c, d)
        t = t / d * 2
        if t < 1 then
            return c / 2 * math.pow(t, 2) + b
        else
            return -c / 2 * ((t - 1) * (t - 3) - 1) + b
        end
    end

    local function outInQuad(t, b, c, d)
        if t < d / 2 then
            return outQuad (t * 2, b, c / 2, d)
        else
            return inQuad((t * 2) - d, b + c / 2, c / 2, d)
        end
    end

    local function inCubic (t, b, c, d)
        t = t / d
        return c * math.pow(t, 3) + b
    end

    local function outCubic(t, b, c, d)
        t = t / d - 1
        return c * (math.pow(t, 3) + 1) + b
    end

    local function inOutCubic(t, b, c, d)
        t = t / d * 2
        if t < 1 then
            return c / 2 * t * t * t + b
        else
            t = t - 2
            return c / 2 * (t * t * t + 2) + b
        end
    end

    local function outInCubic(t, b, c, d)
        if t < d / 2 then
            return outCubic(t * 2, b, c / 2, d)
        else
            return inCubic((t * 2) - d, b + c / 2, c / 2, d)
        end
    end

    local function inQuart(t, b, c, d)
        t = t / d
        return c * math.pow(t, 4) + b
    end

    local function outQuart(t, b, c, d)
        t = t / d - 1
        return -c * (math.pow(t, 4) - 1) + b
    end

    local function inOutQuart(t, b, c, d)
        t = t / d * 2
        if t < 1 then
            return c / 2 * math.pow(t, 4) + b
        else
            t = t - 2
            return -c / 2 * (math.pow(t, 4) - 2) + b
        end
    end

    local function outInQuart(t, b, c, d)
        if t < d / 2 then
            return outQuart(t * 2, b, c / 2, d)
        else
            return inQuart((t * 2) - d, b + c / 2, c / 2, d)
        end
    end

    local function inQuint(t, b, c, d)
        t = t / d
        return c * math.pow(t, 5) + b
    end

    local function outQuint(t, b, c, d)
        t = t / d - 1
        return c * (math.pow(t, 5) + 1) + b
    end

    local function inOutQuint(t, b, c, d)
        t = t / d * 2
        if t < 1 then
            return c / 2 * math.pow(t, 5) + b
        else
            t = t - 2
            return c / 2 * (math.pow(t, 5) + 2) + b
        end
    end

    local function outInQuint(t, b, c, d)
        if t < d / 2 then
            return outQuint(t * 2, b, c / 2, d)
        else
            return inQuint((t * 2) - d, b + c / 2, c / 2, d)
        end
    end

    local function inSine(t, b, c, d)
        return -c * math.cos(t / d * (math.pi / 2)) + c + b
    end

    local function outSine(t, b, c, d)
        return c * math.sin(t / d * (math.pi / 2)) + b
    end

    local function inOutSine(t, b, c, d)
        return -c / 2 * (math.cos(math.pi * t / d) - 1) + b
    end

    local function outInSine(t, b, c, d)
        if t < d / 2 then
            return outSine(t * 2, b, c / 2, d)
        else
            return inSine((t * 2) -d, b + c / 2, c / 2, d)
        end
    end

    local function inExpo(t, b, c, d)
        if t == 0 then
            return b
        else
            return c * math.pow(2, 10 * (t / d - 1)) + b - c * 0.001
        end
    end

    local function outExpo(t, b, c, d)
        if t == d then
            return b + c
        else
            return c * 1.001 * (-math.pow(2, -10 * t / d) + 1) + b
        end
    end

    local function inOutExpo(t, b, c, d)
        if t == 0 then return b end
        if t == d then return b + c end
        t = t / d * 2
        if t < 1 then
            return c / 2 * math.pow(2, 10 * (t - 1)) + b - c * 0.0005
        else
            t = t - 1
            return c / 2 * 1.0005 * (-math.pow(2, -10 * t) + 2) + b
        end
    end

    local function outInExpo(t, b, c, d)
        if t < d / 2 then
            return outExpo(t * 2, b, c / 2, d)
        else
            return inExpo((t * 2) - d, b + c / 2, c / 2, d)
        end
    end

    local function inCirc(t, b, c, d)
        t = t / d
        return(-c * (math.sqrt(1 - math.pow(t, 2)) - 1) + b)
    end

    local function outCirc(t, b, c, d)
        t = t / d - 1
        return(c * math.sqrt(1 - math.pow(t, 2)) + b)
    end

    local function inOutCirc(t, b, c, d)
        t = t / d * 2
        if t < 1 then
            return -c / 2 * (math.sqrt(1 - t * t) - 1) + b
        else
            t = t - 2
            return c / 2 * (math.sqrt(1 - t * t) + 1) + b
        end
    end

    local function outInCirc(t, b, c, d)
        if t < d / 2 then
            return outCirc(t * 2, b, c / 2, d)
        else
            return inCirc((t * 2) - d, b + c / 2, c / 2, d)
        end
    end

    local function inElastic(t, b, c, d, a, p)
        if t == 0 then return b end

        t = t / d

        if t == 1	then return b + c end

        if not p then p = d * 0.3 end

        local s

        if not a or a < math.abs(c) then
            a = c
            s = p / 4
        else
            s = p / (2 * math.pi) * math.asin(c/a)
        end

        t = t - 1

        return -(a * math.pow(2, 10 * t) * math.sin((t * d - s) * (2 * math.pi) / p)) + b
    end

    -- a: amplitud
    -- p: period
    local function outElastic(t, b, c, d, a, p)
        if t == 0 then return b end

        t = t / d

        if t == 1 then return b + c end

        if not p then p = d * 0.3 end

        local s

        if not a or a < math.abs(c) then
            a = c
            s = p / 4
        else
            s = p / (2 * math.pi) * math.asin(c/a)
        end

        return a * math.pow(2, -10 * t) * math.sin((t * d - s) * (2 * math.pi) / p) + c + b
    end

    -- p = period
    -- a = amplitud
    local function inOutElastic(t, b, c, d, a, p)
        if t == 0 then return b end

        t = t / d * 2

        if t == 2 then return b + c end

        if not p then p = d * (0.3 * 1.5) end
        if not a then a = 0 end

        local s

        if not a or a < math.abs(c) then
            a = c
            s = p / 4
        else
            s = p / (2 * math.pi) * math.asin(c / a)
        end

        if t < 1 then
            t = t - 1
            return -0.5 * (a * math.pow(2, 10 * t) * math.sin((t * d - s) * (2 * math.pi) / p)) + b
        else
            t = t - 1
            return a * math.pow(2, -10 * t) * math.sin((t * d - s) * (2 * math.pi) / p ) * 0.5 + c + b
        end
    end

    -- a: amplitud
    -- p: period
    local function outInElastic(t, b, c, d, a, p)
        if t < d / 2 then
            return outElastic(t * 2, b, c / 2, d, a, p)
        else
            return inElastic((t * 2) - d, b + c / 2, c / 2, d, a, p)
        end
    end

    local function inBack(t, b, c, d, s)
        if not s then s = 1.70158 end
        t = t / d
        return c * t * t * ((s + 1) * t - s) + b
    end

    local function outBack(t, b, c, d, s)
        if not s then s = 1.70158 end
        t = t / d - 1
        return c * (t * t * ((s + 1) * t + s) + 1) + b
    end

    local function inOutBack(t, b, c, d, s)
        if not s then s = 1.70158 end
        s = s * 1.525
        t = t / d * 2
        if t < 1 then
            return c / 2 * (t * t * ((s + 1) * t - s)) + b
        else
            t = t - 2
            return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
        end
    end

    local function outInBack(t, b, c, d, s)
        if t < d / 2 then
            return outBack(t * 2, b, c / 2, d, s)
        else
            return inBack((t * 2) - d, b + c / 2, c / 2, d, s)
        end
    end

    local function outBounce(t, b, c, d)
        t = t / d
        if t < 1 / 2.75 then
            return c * (7.5625 * t * t) + b
        elseif t < 2 / 2.75 then
            t = t - (1.5 / 2.75)
            return c * (7.5625 * t * t + 0.75) + b
        elseif t < 2.5 / 2.75 then
            t = t - (2.25 / 2.75)
            return c * (7.5625 * t * t + 0.9375) + b
        else
            t = t - (2.625 / 2.75)
            return c * (7.5625 * t * t + 0.984375) + b
        end
    end

    local function inBounce(t, b, c, d)
        return c - outBounce(d - t, 0, c, d) + b
    end

    local function inOutBounce(t, b, c, d)
        if t < d / 2 then
            return inBounce(t * 2, 0, c, d) * 0.5 + b
        else
            return outBounce(t * 2 - d, 0, c, d) * 0.5 + c * .5 + b
        end
    end

    local function outInBounce(t, b, c, d)
        if t < d / 2 then
            return outBounce(t * 2, b, c / 2, d)
        else
            return inBounce((t * 2) - d, b + c / 2, c / 2, d)
        end
    end

    return {
        linear = linear,

        quad_in = inQuad,
        quad_out = outQuad,
        quad_in_out = inOutQuad,
        quad_out_in = outInQuad,

        cubic_in = inCubic ,
        cubic_out = outCubic,
        cubic_in_out = inOutCubic,
        cubic_out_in = outInCubic,

        quart_in = inQuart,
        quart_out = outQuart,
        quart_in_out = inOutQuart,
        quart_out_in = outInQuart,

        quint_in = inQuint,
        quint_out = outQuint,
        quint_in_out = inOutQuint,
        quint_out_in = outInQuint,

        sine_in = inSine,
        sine_out = outSine,
        sine_in_out = inOutSine,
        sine_out_in = outInSine,

        expo_in = inExpo,
        expo_out = outExpo,
        expo_in_out = inOutExpo,
        expo_out_in = outInExpo,

        circ_in = inCirc,
        circ_out = outCirc,
        circ_in_out = inOutCirc,
        circ_out_in = outInCirc,

        elastic_in = inElastic,
        elastic_out = outElastic,
        elastic_in_out = inOutElastic,
        elastic_out_in = outInElastic,

        back_in = inBack,
        back_out = outBack,
        back_in_out = inOutBack,
        back_out_in = outInBack,

        bounce_in = inBounce,
        bounce_out = outBounce,
        bounce_in_out = inOutBounce,
        bounce_out_in = outInBounce,
    }

end)()

hutao_lib.entity.get_players = function (enemies_only, skip_dormant)

    if not enemies_only then enemies_only = false end
    if not skip_dormant then skip_dormant = false end

    local players = {}
    
    for i = 1, entity_list.get_max_entities() do
        
        local entity = entity_list.get_entity(i)

        if not entity then goto skip end

        local player = entity:is_player()

        if not player or (enemies_only and not entity:is_enemy()) or (skip_dormant and entity:is_dormant()) then
            goto skip
        end
        
        players[i] = entity

        ::skip::

    end

    return players

end

hutao_lib.entity.get_class = function (class)

    local class_table = {}

    if not class then return class_table end

    for i = 1, entity_list.get_max_entities() do

        local class_entity = entity_list.get_entity(i)
        
        if not class_entity or (type(class) == "string" and class_entity:get_class_name() ~= tostring(class)) or (type(class) == "number" and class_entity:get_class_id() ~= tonumber(class)) then
            goto skip
        end

        class_table[i] = class_entity

        ::skip::

    end

    return class_table

end

hutao_lib.math.clamp = function (min, max, val)
    if val < min then return min end
    if val > max then return max end
    return val
end

hutao_lib.math.random_float = function (min, max)
    return math.random() * (max - min) + min
end

hutao_lib.math.random_int = function (min, max)
    return math.floor(math.random() * (math.floor(max) - math.ceil(min) + 1)) + math.ceil(min)
end

hutao_lib.math.round = function (number, precision)
    local mult = math.pow(10, (precision or 0))

    return math.floor(number * mult + 0.5) / mult
end

hutao_lib.base64.encode = function (source_str)
    local s64 = ""
    local str = source_str
    while #str > 0 do
        local buf = 0
        local bytes_num = 0
        for byte_cnt = 1,3 do
            buf = (buf * 256)
            if #str > 0 then
                buf = buf + string.byte(str, 1, 1)
                str = string.sub(str, 2)
                bytes_num = bytes_num + 1
            end
        end

        for group_cnt = 1, (bytes_num + 1) do
            local b64char = math.fmod(math.floor(buf / 262144), 64) + 1
            s64 = s64 .. string.sub(hutao_lib.base64.chars, b64char, b64char)
            buf = buf * 64
        end

        for fill_cnt = 1, (3 - bytes_num) do
            s64 = s64 .. "="
        end
    end

    return s64
end

hutao_lib.base64.decode = function(str64)

    local temp = {}
    for i = 1, 64 do
        temp[string.sub(hutao_lib.base64.chars, i, i)] = i
    end

    local str = ""
    temp["="] = 0
    for i = 1, #str64, 4 do
        if i > #str64 then
            break
        end

        local data = 0
        local str_count=0
        for j = 0, 3 do
            local str1 = string.sub(str64, i + j, i + j)
            if not temp[str1] then
                return
            end

            if temp[str1] < 1 then
                data = data * 64
            else
                data = data * 64 + temp[str1] - 1
                str_count = str_count + 1
            end
        end

        for j = 16, 0, - 8 do
            if str_count > 0 then
                str=str .. string.char(math.floor(data / math.pow(2, j)))
                data = math.fmod(data, math.pow(2, j))
                str_count = str_count - 1
            end
        end
    end

    local last = tonumber(string.byte(str, string.len(str), string.len(str)))
    if last == 0 then
        str = string.sub(str, 1, string.len(str) - 1)
    end

    return str

end

return hutao_lib
