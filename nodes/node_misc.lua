-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

-- A do-nothing "structural" node, to ensure all clonetron nodes that are supposed to be connected to each other can be connected to each other.
minetest.register_node("clonetron:structure", {
	description = S("clonetron Structure"),
	_doc_items_longdesc = clonetron.doc.structure_longdesc,
    _doc_items_usagehelp = clonetron.doc.structure_usagehelp,
	groups = {cracky = 3,  oddly_breakable_by_hand=3, clonetron = 1},
	drop = "clonetron:structure",
	tiles = {"clonetron_plate.png"},
	drawtype = "nodebox",
	sounds = clonetron.metal_sounds,
	climbable = true,
	walkable = false,
	paramtype = "light",
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = {
			{0.3125, 0.3125, -0.5, 0.5, 0.5, 0.5},
			{0.3125, -0.5, -0.5, 0.5, -0.3125, 0.5},
			{-0.5, 0.3125, -0.5, -0.3125, 0.5, 0.5},
			{-0.5, -0.5, -0.5, -0.3125, -0.3125, 0.5},
			{-0.3125, 0.3125, 0.3125, 0.3125, 0.5, 0.5},
			{-0.3125, -0.5, 0.3125, 0.3125, -0.3125, 0.5},
			{-0.5, -0.3125, 0.3125, -0.3125, 0.3125, 0.5},
			{0.3125, -0.3125, 0.3125, 0.5, 0.3125, 0.5},
			{-0.5, -0.3125, -0.5, -0.3125, 0.3125, -0.3125},
			{0.3125, -0.3125, -0.5, 0.5, 0.3125, -0.3125},
			{-0.3125, 0.3125, -0.5, 0.3125, 0.5, -0.3125},
			{-0.3125, -0.5, -0.5, 0.3125, -0.3125, -0.3125},
		}
	},
})

-- A modest light source that will move with the clonetron, handy for working in a tunnel you aren't bothering to install permanent lights in.
minetest.register_node("clonetron:light", {
	description = S("clonetron Light"),
	_doc_items_longdesc = clonetron.doc.light_longdesc,
    _doc_items_usagehelp = clonetron.doc.light_usagehelp,
	groups = {cracky = 3,  oddly_breakable_by_hand=3, clonetron = 1},
	drop = "clonetron:light",
	tiles = {"clonetron_plate.png^clonetron_light.png"},
	drawtype = "nodebox",
	paramtype = "light",
	is_ground_content = false,
	light_source = 10,
	sounds = default.node_sound_glass_defaults(),
	paramtype2 = "wallmounted",
	node_box = {
		type = "wallmounted",
		wall_top = {-0.25, 0.3125, -0.25, 0.25, 0.5, 0.25},
		wall_bottom = {-0.25, -0.5, -0.25, 0.25, -0.3125, 0.25},
		wall_side = {-0.5, -0.25, -0.25, -0.1875, 0.25, 0.25},
	},
})

-- A simple structural panel
minetest.register_node("clonetron:panel", {
	description = S("clonetron Panel"),
	_doc_items_longdesc = clonetron.doc.panel_longdesc,
    _doc_items_usagehelp = clonetron.doc.panel_usagehelp,
	groups = {cracky = 3,  oddly_breakable_by_hand=3, clonetron = 1},
	drop = "clonetron:panel",
	tiles = {"clonetron_plate.png"},
	drawtype = "nodebox",
	paramtype = "light",
	is_ground_content = false,
	sounds = clonetron.metal_sounds,
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.375, 0.5},
	},
	collision_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
	},
})

-- A simple structural panel
minetest.register_node("clonetron:edge_panel", {
	description = S("clonetron Edge Panel"),
	_doc_items_longdesc = clonetron.doc.edge_panel_longdesc,
    _doc_items_usagehelp = clonetron.doc.edge_panel_usagehelp,
	groups = {cracky = 3,  oddly_breakable_by_hand=3, clonetron = 1},
	drop = "clonetron:edge_panel",
	tiles = {"clonetron_plate.png"},
	drawtype = "nodebox",
	paramtype = "light",
	is_ground_content = false,
	sounds = clonetron.metal_sounds,
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.5, 0.5, -0.375, 0.375}
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.4375, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.4375}
		},
	},

})

minetest.register_node("clonetron:corner_panel", {
	description = S("clonetron Corner Panel"),
	_doc_items_longdesc = clonetron.doc.corner_panel_longdesc,
    _doc_items_usagehelp = clonetron.doc.corner_panel_usagehelp,
	groups = {cracky = 3,  oddly_breakable_by_hand=3, clonetron = 1},
	drop = "clonetron:corner_panel",
	tiles = {"clonetron_plate.png"},
	drawtype = "nodebox",
	paramtype = "light",
	is_ground_content = false,
	sounds = clonetron.metal_sounds,
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.375, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.5, 0.5, -0.375, 0.375},
			{-0.5, -0.375, -0.5, -0.375, 0.5, 0.375},
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.4375, 0.5, 0.5, 0.5},
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.4375},
			{-0.5, -0.4375, -0.5, -0.4375, 0.5, 0.4375},
		},
	},
})