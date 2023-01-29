-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

-- Note: diggers go in group 3 and have an execute_dig method.

local damage_hp = clonetron.config.damage_hp
local damage_hp_half = damage_hp/2

local digger_nodebox = {
	{-0.5, -0.5, 0, 0.5, 0.5, 0.4375}, -- Block
	{-0.4375, -0.3125, 0.4375, 0.4375, 0.3125, 0.5}, -- Cutter1
	{-0.3125, -0.4375, 0.4375, 0.3125, 0.4375, 0.5}, -- Cutter2
	{-0.5, -0.125, -0.125, 0.5, 0.125, 0}, -- BackFrame1
	{-0.125, -0.5, -0.125, 0.125, 0.5, 0}, -- BackFrame2
	{-0.25, -0.25, -0.5, 0.25, 0.25, 0}, -- Drive
}

local dual_digger_nodebox = {
	{-0.5, -0.4375, 0, 0.5, 0.5, 0.4375}, -- Block
	{-0.4375, -0.3125, 0.4375, 0.4375, 0.3125, 0.5}, -- Cutter1
	{-0.3125, -0.4375, 0.4375, 0.3125, 0.4375, 0.5}, -- Cutter2
	{-0.5, 0, -0.125, 0.5, 0.125, 0}, -- BackFrame1
	{-0.25, 0, -0.5, 0.25, 0.25, 0}, -- Drive
	{-0.25, 0.25, -0.25, 0.25, 0.5, 0}, -- Upper_Drive
	{-0.5, -0.4375, -0.5, 0.5, 0, 0.4375}, -- Lower_Block
	{-0.3125, -0.5, -0.4375, 0.3125, -0.4375, 0.4375}, -- Lower_Cutter_1
	{-0.4375, -0.5, -0.3125, 0.4375, -0.4375, 0.3125}, -- Lower_Cutter_2
}

local modpath_doc = minetest.get_modpath("doc")

local intermittent_formspec_string = mcl_vars.gui_bg ..
	mcl_vars.gui_bg_img ..
	mcl_vars.gui_slots ..
	"field[0.5,0.8;1,0.1;period;" .. S("Periodicity") .. ";${period}]" ..
	"tooltip[period;" .. S("Digger will dig once every n steps.\nThese steps are globally aligned, all diggers with\nthe same period and offset will dig on the same location.") .. "]" ..
	"field[1.5,0.8;1,0.1;offset;" .. S("Offset") .. ";${offset}]" ..
	"tooltip[offset;" .. S("Offsets the start of periodicity counting by this amount.\nFor example, a digger with period 2 and offset 0 digs\nevery even-numbered block and one with period 2 and\noffset 1 digs every odd-numbered block.") .. "]" ..
	"button_exit[2.2,0.5;1,0.1;set;" .. S("Save &\nShow") .. "]" ..
	"tooltip[set;" .. S("Saves settings") .. "]"

if modpath_doc then
	intermittent_formspec_string = "size[4.5,1]" .. intermittent_formspec_string ..
		"button_exit[3.2,0.5;1,0.1;help;" .. S("Help") .. "]" ..
		"tooltip[help;" .. S("Show documentation about this block") .. "]"
	else
		intermittent_formspec_string = "size[3.5,1]" .. intermittent_formspec_string
	end

local intermittent_formspec = function(pos, meta)
	return intermittent_formspec_string
		:gsub("${period}", meta:get_int("period"), 1)
		:gsub("${offset}", meta:get_int("offset"), 1)
	end

local intermittent_on_construct = function(pos)
    local meta = minetest.get_meta(pos)
	meta:set_int("period", 1) 
	meta:set_int("offset", 0) 
end

local intermittent_on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
	local item_def = itemstack:get_definition()
	if item_def.type == "node" and minetest.get_item_group(itemstack:get_name(), "clonetron") > 0 then
		local returnstack, success = minetest.item_place_node(itemstack, clicker, pointed_thing)
		if success and item_def.sounds and item_def.sounds.place and item_def.sounds.place.name then
			minetest.sound_play(item_def.sounds.place, {pos = pos})
		end
		return returnstack, success
	end
	local meta = minetest.get_meta(pos)	
	minetest.show_formspec(clicker:get_player_name(),
		"clonetron:intermittent_digger"..minetest.pos_to_string(pos),
		intermittent_formspec(pos, meta))
end

local use_texture_alpha = minetest.features.use_texture_alpha_string_modes and "opaque" or nil

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname:sub(1, 27) == "clonetron:intermittent_digger" then
		local pos = minetest.string_to_pos(formname:sub(28, -1))
	    local meta = minetest.get_meta(pos)
		local period = tonumber(fields.period)
		local offset = tonumber(fields.offset)
		if  period and period > 0 then
			meta:set_int("period", math.floor(period))
		end
		if offset then
			meta:set_int("offset", math.floor(offset))
		end
		if fields.help and minetest.get_modpath("doc") then --check for mod in case someone disabled it after this digger was built
			local node_name = minetest.get_node(pos).name
			minetest.after(0.5, doc.show_entry, player:get_player_name(), "nodes", node_name, true)
		end
		if fields.set then
			clonetron.show_offset_markers(pos, offset, period)
		end
		return true
	end
end)


-- Digs out nodes that are "in front" of the digger head.
minetest.register_node("clonetron:digger", {
	description = S("clonetron Digger Head"),
	_doc_items_longdesc = clonetron.doc.digger_longdesc,
    _doc_items_usagehelp = clonetron.doc.digger_usagehelp,
	groups = {cracky = 3,  oddly_breakable_by_hand=3, clonetron = 3},
	drop = "clonetron:digger",
	sounds = clonetron.metal_sounds,
	paramtype = "light",
	paramtype2= "facedir",
	is_ground_content = false,	
	drawtype="nodebox",
	node_box = {
		type = "fixed",
		fixed = digger_nodebox,
	},
	
	-- Aims in the +Z direction by default
	tiles = {
		"clonetron_plate.png^[transformR90",
		"clonetron_plate.png^[transformR270",
		"clonetron_plate.png",
		"clonetron_plate.png^[transformR180",
		{
			name = "clonetron_digger_yb.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.0,
			},
		},
		"clonetron_plate.png^clonetron_motor.png",
	},

	-- returns fuel_cost, item_produced
	execute_dig = function(pos, protected_nodes, nodes_dug, controlling_coordinate, lateral_dig, player)
		local facing = minetest.get_node(pos).param2
		local digpos = clonetron.find_new_pos(pos, facing)

		if protected_nodes:get(digpos.x, digpos.y, digpos.z) then
			return 0
		end
		
		return clonetron.mark_diggable(digpos, nodes_dug, player)
	end,
	
	damage_creatures = function(player, pos, controlling_coordinate, items_dropped)
		local facing = minetest.get_node(pos).param2
		clonetron.damage_creatures(player, pos, clonetron.find_new_pos(pos, facing), damage_hp, items_dropped)
	end,
})

-- Digs out nodes that are "in front" of the digger head.
minetest.register_node("clonetron:intermittent_digger", {
	description = S("clonetron Intermittent Digger Head"),
	_doc_items_longdesc = clonetron.doc.intermittent_digger_longdesc,
    _doc_items_usagehelp = clonetron.doc.intermittent_digger_usagehelp,
	_clonetron_formspec = intermittent_formspec,
	groups = {cracky = 3,  oddly_breakable_by_hand=3, clonetron = 3},
	drop = "clonetron:intermittent_digger",
	sounds = clonetron.metal_sounds,
	paramtype = "light",
	paramtype2= "facedir",
	is_ground_content = false,	
	drawtype="nodebox",
	node_box = {
		type = "fixed",
		fixed = digger_nodebox,
	},
	
	-- Aims in the +Z direction by default
	tiles = {
		"clonetron_plate.png^[transformR90",
		"clonetron_plate.png^[transformR270",
		"clonetron_plate.png",
		"clonetron_plate.png^[transformR180",
		{
			name = "clonetron_digger_yb.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.0,
			},
		},
		"clonetron_plate.png^clonetron_intermittent.png^clonetron_motor.png",
	},
	
	on_construct = intermittent_on_construct,
	
	on_rightclick = intermittent_on_rightclick,

	-- returns fuel_cost, item_produced (a table or nil)
	execute_dig = function(pos, protected_nodes, nodes_dug, controlling_coordinate, lateral_dig, player)
		if lateral_dig == true then
			return 0
		end

		local facing = minetest.get_node(pos).param2
		local digpos = clonetron.find_new_pos(pos, facing)

		if protected_nodes:get(digpos.x, digpos.y, digpos.z) then
			return 0
		end
		
		local meta = minetest.get_meta(pos)
		if (digpos[controlling_coordinate] + meta:get_int("offset")) % meta:get_int("period") ~= 0 then
			return 0
		end
		
		return clonetron.mark_diggable(digpos, nodes_dug, player)
	end,
	
	damage_creatures = function(player, pos, controlling_coordinate, items_dropped)
		local facing = minetest.get_node(pos).param2
		local targetpos = clonetron.find_new_pos(pos, facing)
		local meta = minetest.get_meta(pos)
		if (targetpos[controlling_coordinate] + meta:get_int("offset")) % meta:get_int("period") == 0 then
			clonetron.damage_creatures(player, pos, targetpos, damage_hp, items_dropped)
		end
	end
})

-- A special-purpose digger to deal with stuff like sand and gravel in the ceiling. It always digs (no periodicity or offset), but it only digs falling_block nodes
minetest.register_node("clonetron:soft_digger", {
	description = S("clonetron Soft Material Digger Head"),
	_doc_items_longdesc = clonetron.doc.soft_digger_longdesc,
    _doc_items_usagehelp = clonetron.doc.soft_digger_usagehelp,
	groups = {cracky = 3,  oddly_breakable_by_hand=3, clonetron = 3},
	drop = "clonetron:soft_digger",
	sounds = clonetron.metal_sounds,
	use_texture_alpha = use_texture_alpha,
	paramtype = "light",
	paramtype2= "facedir",
	is_ground_content = false,
	drawtype="nodebox",
	node_box = {
		type = "fixed",
		fixed = digger_nodebox,
	},
	
	-- Aims in the +Z direction by default
	tiles = {
		"clonetron_plate.png^[transformR90^[colorize:" .. clonetron.soft_digger_colorize,
		"clonetron_plate.png^[transformR270^[colorize:" .. clonetron.soft_digger_colorize,
		"clonetron_plate.png^[colorize:" .. clonetron.soft_digger_colorize,
		"clonetron_plate.png^[transformR180^[colorize:" .. clonetron.soft_digger_colorize,
		{
			name = "clonetron_digger_yb.png^[colorize:" .. clonetron.soft_digger_colorize,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.0,
			},
		},
		"clonetron_plate.png^clonetron_motor.png^[colorize:" .. clonetron.soft_digger_colorize,
	},
	
	execute_dig = function(pos, protected_nodes, nodes_dug, controlling_coordinate, lateral_dig, player)
		local facing = minetest.get_node(pos).param2
		local digpos = clonetron.find_new_pos(pos, facing)
		
		if protected_nodes:get(digpos.x, digpos.y, digpos.z) then
			return 0
		end
			
		if clonetron.is_soft_material(digpos) then
			return clonetron.mark_diggable(digpos, nodes_dug, player)
		end
		
		return 0
	end,

	damage_creatures = function(player, pos, controlling_coordinate, items_dropped)
		local facing = minetest.get_node(pos).param2
		clonetron.damage_creatures(player, pos, clonetron.find_new_pos(pos, facing), damage_hp_half, items_dropped)
	end,
})

minetest.register_node("clonetron:intermittent_soft_digger", {
	description = S("clonetron Intermittent Soft Material Digger Head"),
	_doc_items_longdesc = clonetron.doc.intermittent_soft_digger_longdesc,
    _doc_items_usagehelp = clonetron.doc.intermittent_soft_digger_usagehelp,
	_clonetron_formspec = intermittent_formspec,
	groups = {cracky = 3,  oddly_breakable_by_hand=3, clonetron = 3},
	drop = "clonetron:intermittent_soft_digger",
	sounds = clonetron.metal_sounds,
	use_texture_alpha = use_texture_alpha,
	paramtype = "light",
	paramtype2= "facedir",
	is_ground_content = false,
	drawtype="nodebox",
	node_box = {
		type = "fixed",
		fixed = digger_nodebox,
	},
	
	-- Aims in the +Z direction by default
	tiles = {
		"clonetron_plate.png^[transformR90^[colorize:" .. clonetron.soft_digger_colorize,
		"clonetron_plate.png^[transformR270^[colorize:" .. clonetron.soft_digger_colorize,
		"clonetron_plate.png^[colorize:" .. clonetron.soft_digger_colorize,
		"clonetron_plate.png^[transformR180^[colorize:" .. clonetron.soft_digger_colorize,
		{
			name = "clonetron_digger_yb.png^[colorize:" .. clonetron.soft_digger_colorize,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.0,
			},
		},
		"clonetron_plate.png^clonetron_intermittent.png^clonetron_motor.png^[colorize:" .. clonetron.soft_digger_colorize,
	},
	
	on_construct = intermittent_on_construct,
	
	on_rightclick = intermittent_on_rightclick,
		
	execute_dig = function(pos, protected_nodes, nodes_dug, controlling_coordinate, lateral_dig, player)
		if lateral_dig == true then
			return 0
		end

		local facing = minetest.get_node(pos).param2
		local digpos = clonetron.find_new_pos(pos, facing)
		
		if protected_nodes:get(digpos.x, digpos.y, digpos.z) then
			return 0
		end
		
		local meta = minetest.get_meta(pos)
		if (digpos[controlling_coordinate] + meta:get_int("offset")) % meta:get_int("period") ~= 0 then
			return 0
		end
		
		if clonetron.is_soft_material(digpos) then
			return clonetron.mark_diggable(digpos, nodes_dug, player)
		end
		
		return 0
	end,

	damage_creatures = function(player, pos, controlling_coordinate, items_dropped)
		local meta = minetest.get_meta(pos)
		local facing = minetest.get_node(pos).param2
		local targetpos = clonetron.find_new_pos(pos, facing)		
		if (targetpos[controlling_coordinate] + meta:get_int("offset")) % meta:get_int("period") == 0 then
			clonetron.damage_creatures(player, pos, targetpos, damage_hp_half, items_dropped)
		end
	end,
})

-- Digs out nodes that are "in front" of the digger head and "below" the digger head (can be rotated).
minetest.register_node("clonetron:dual_digger", {
	description = S("clonetron Dual Digger Head"),
	_doc_items_longdesc = clonetron.doc.dual_digger_longdesc,
    _doc_items_usagehelp = clonetron.doc.dual_digger_usagehelp,
	groups = {cracky = 3,  oddly_breakable_by_hand=3, clonetron = 3},
	drop = "clonetron:dual_digger",
	sounds = clonetron.metal_sounds,
	paramtype = "light",
	paramtype2= "facedir",
	is_ground_content = false,	
	drawtype="nodebox",
	node_box = {
		type = "fixed",
		fixed = dual_digger_nodebox,
	},
	
	-- Aims in the +Z and -Y direction by default
	tiles = {
		"clonetron_plate.png^clonetron_motor.png",
		{
			name = "clonetron_digger_yb.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.0,
			},
		},
		"clonetron_plate.png",
		"clonetron_plate.png^[transformR180",
		{
			name = "clonetron_digger_yb.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.0,
			},
		},
		"clonetron_plate.png^clonetron_motor.png",
	},

	-- returns fuel_cost, items_produced
	execute_dig = function(pos, protected_nodes, nodes_dug, controlling_coordinate, lateral_dig, player)
		local facing = minetest.get_node(pos).param2
		local digpos = clonetron.find_new_pos(pos, facing)
		local digdown = clonetron.find_new_pos_downward(pos, facing)

		local items = {}
		local cost = 0
		
		if protected_nodes:get(digpos.x, digpos.y, digpos.z) ~= true then
			local forward_cost, forward_items = clonetron.mark_diggable(digpos, nodes_dug, player)
			if forward_items ~= nil then
				for _, item in pairs(forward_items) do
					table.insert(items, item)
				end
			end
			cost = cost + forward_cost
		end
		if protected_nodes:get(digdown.x, digdown.y, digdown.z) ~= true then
			local down_cost, down_items = clonetron.mark_diggable(digdown, nodes_dug, player)
			if down_items ~= nil then
				for _, item in pairs(down_items) do
					table.insert(items, item)
				end
			end
			cost = cost + down_cost
		end
		
		return cost, items
	end,
	
	damage_creatures = function(player, pos, controlling_coordinate, items_dropped)
		local facing = minetest.get_node(pos).param2
		clonetron.damage_creatures(player, pos, clonetron.find_new_pos(pos, facing), damage_hp, items_dropped)
		clonetron.damage_creatures(player, pos, clonetron.find_new_pos_downward(pos, facing), damage_hp, items_dropped)
	end,
})

-- Digs out soft nodes that are "in front" of the digger head and "below" the digger head (can be rotated).
minetest.register_node("clonetron:dual_soft_digger", {
	description = S("clonetron Dual Soft Material Digger Head"),
	_doc_items_longdesc = clonetron.doc.dual_soft_digger_longdesc,
    _doc_items_usagehelp = clonetron.doc.dual_soft_digger_usagehelp,
	groups = {cracky = 3,  oddly_breakable_by_hand=3, clonetron = 3},
	drop = "clonetron:dual_soft_digger",
	sounds = clonetron.metal_sounds,
	use_texture_alpha = use_texture_alpha,
	paramtype = "light",
	paramtype2= "facedir",
	is_ground_content = false,	
	drawtype="nodebox",
	node_box = {
		type = "fixed",
		fixed = dual_digger_nodebox,
	},
	
	-- Aims in the +Z and -Y direction by default
	tiles = {
		"clonetron_plate.png^clonetron_motor.png^[colorize:" .. clonetron.soft_digger_colorize,
		{
			name = "clonetron_digger_yb.png^[colorize:" .. clonetron.soft_digger_colorize,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.0,
			},
		},
		"clonetron_plate.png^[colorize:" .. clonetron.soft_digger_colorize,
		"clonetron_plate.png^[transformR180^[colorize:" .. clonetron.soft_digger_colorize,
		{
			name = "clonetron_digger_yb.png^[colorize:" .. clonetron.soft_digger_colorize,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1.0,
			},
		},
		"clonetron_plate.png^clonetron_motor.png^[colorize:" .. clonetron.soft_digger_colorize,
	},

	-- returns fuel_cost, items_produced
	execute_dig = function(pos, protected_nodes, nodes_dug, controlling_coordinate, lateral_dig, player)
		local facing = minetest.get_node(pos).param2
		local digpos = clonetron.find_new_pos(pos, facing)
		local digdown = clonetron.find_new_pos_downward(pos, facing)

		local items = {}
		local cost = 0
		
		if protected_nodes:get(digpos.x, digpos.y, digpos.z) ~= true and clonetron.is_soft_material(digpos) then
			local forward_cost, forward_items = clonetron.mark_diggable(digpos, nodes_dug, player)
			if forward_items ~= nil then
				for _, item in pairs(forward_items) do
					table.insert(items, item)
				end
			end
			cost = cost + forward_cost
		end
		if protected_nodes:get(digdown.x, digdown.y, digdown.z) ~= true and clonetron.is_soft_material(digdown) then
			local down_cost, down_items = clonetron.mark_diggable(digdown, nodes_dug, player)
			if down_items ~= nil then
				for _, item in pairs(down_items) do
					table.insert(items, item)
				end
			end
			cost = cost + down_cost
		end
		
		return cost, items
	end,
	
	damage_creatures = function(player, pos, controlling_coordinate, items_dropped)
		local facing = minetest.get_node(pos).param2
		clonetron.damage_creatures(player, pos, clonetron.find_new_pos(pos, facing), damage_hp_half, items_dropped)
		clonetron.damage_creatures(player, pos, clonetron.find_new_pos_downward(pos, facing), damage_hp_half, items_dropped)
	end,
})
