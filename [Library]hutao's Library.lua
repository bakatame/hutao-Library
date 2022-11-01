local hutao_lib = {}
hutao_lib.entity = {}
hutao_lib.math = {}
hutao_lib.base64 = {}
hutao_lib.gradient = {}

hutao_lib.print = function (...) local text = "" if type(text) == "table" then for index, value in ipairs(...) do text = tostring(value) .. ", " end else text = tostring(...) end general.log_to_console(text) end

hutao_lib.contains = function (tab, val)

    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false

end

hutao_lib.vector = function (x, y ,z)
    return (function ()
        local vector_table = {}
        vector_table.__index = vector_table

        function vector_table.__add (a, b)

            local a_type = type(a);
            local b_type = type(b);
        
            if (a_type == "table" and b_type == "table") then
                return vector_table.new(a.x + b.x, a.y + b.y, a.z + b.z);
            elseif (a_type == "table" and b_type == "number") then
                return vector_table.new(a.x + b, a.y + b, a.z + b);
            elseif (a_type == "number" and b_type == "table") then
                return vector_table.new(a + b.x, a + b.y, a + b.z);
            end

        end
    
        function vector_table.__sub (a, b)
            local a_type = type(a);
            local b_type = type(b);
        
            if (a_type == "table" and b_type == "table") then
                return Vector(a.x - b.x, a.y - b.y, a.z - b.z);
            elseif (a_type == "table" and b_type == "number") then
                return Vector(a.x - b, a.y - b, a.z - b);
            elseif (a_type == "number" and b_type == "table") then
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
        
            if (a_type == "table" and b_type == "table") then
                return Vector(a.x * b.x, a.y * b.y, a.z * b.z);
            elseif (a_type == "table" and b_type == "number") then
                return Vector(a.x * b, a.y * b, a.z * b);
            elseif (a_type == "number" and b_type == "table") then
                return Vector(a * b.x, a * b.y, a * b.z);
            end
        end

        function vector_table.__div (a, b)
            local a_type = type(a);
            local b_type = type(b);
        
            if (a_type == "table" and b_type == "table") then
                return Vector(a.x / b.x, a.y / b.y, a.z / b.z);
            elseif (a_type == "table" and b_type == "number") then
                return Vector(a.x / b, a.y / b, a.z / b);
            elseif (a_type == "number" and b_type == "table") then
                return Vector(a / b.x, a / b.y, a / b.z);
            end
        end

        function vector_table.__tostring (a)
            return "( " .. a.x .. ", " .. a.y .. ", " .. a.z .. " )";
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
        
        function vector_table:dist_to(other)
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
        
        function vector_table:vec3()
            return math.vec3(self.x, self.y, self.z);
        end

        function vector_table:set(x, y, z)

            if not z then
                z = 0
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
            return {
                x = vector_to_screen.x,
                y = vector_to_screen.y,
            }
        end

        function vector_table.new(x, y, z)
            
            if (type(x) ~= "number") then
                x = 0.0;
            end
        
            if (type(y) ~= "number") then
                y = 0.0;
            end
        
            if (type(z) ~= "number") then
                z = 0.0;
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

hutao_lib.math.clamp = function (min,max, val)
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

hutao_lib.base64.chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

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

hutao_lib.get_eyes_pos = function ()

    local local_player = engine.get_local_player()
    if not local_player and not local_player or not engine.is_ingame() and not engine.is_connected() or engine.get_local_player():get_netvar_int("m_lifeState") ~= 0 then return false end
    local origin = local_player:get_netvar_c_vector3d("m_vecOrigin")
    if not origin then return false end
    local view_offset = local_player:get_netvar_c_vector3d("m_vecViewOffset")
    if not view_offset then return false end
    return hutao_lib.vector(origin.x + view_offset.x, origin.y + view_offset.y, origin.z + view_offset.z)

end

return hutao_lib
