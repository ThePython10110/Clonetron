-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

minetest.register_craftitem("clonetron:clonetron_core", {
	description = S("clonetron Core"),
	inventory_image = "clonetron_core.png",
	_doc_items_longdesc = clonetron.doc.core_longdesc,
    _doc_items_usagehelp = clonetron.doc.core_usagehelp,
})

minetest.register_craft({
	output = "clonetron:clonetron_core",
	recipe = {
			{"","mcl_core:iron_ingot",""},
			{"mcl_core:iron_ingot","mesecons:redstone","mcl_core:iron_ingot"},
			{"","mcl_core:iron_ingot",""}
			}
})

minetest.register_craft({
	output = "clonetron:controller",
	recipe = {
			{"","mesecons_torch:redstoneblock",""},
			{"mesecons_torch:redstoneblock","clonetron:clonetron_core","mesecons_torch:redstoneblock"},
			{"","mesecons_torch:redstoneblock",""}
			}
})

minetest.register_craft({
	output = "clonetron:auto_controller",
	recipe = {
			{"mesecons_torch:redstoneblock","mesecons_torch:redstoneblock","mesecons_torch:redstoneblock"},
			{"mesecons_torch:redstoneblock","clonetron:clonetron_core","mesecons_torch:redstoneblock"},
			{"mesecons_torch:redstoneblock","mesecons_torch:redstoneblock","mesecons_torch:redstoneblock"}
			}
})

minetest.register_craft({
	output = "clonetron:builder",
	recipe = {
			{"","mesecons:redstone",""},
			{"mesecons:redstone","clonetron:clonetron_core","mesecons:redstone"},
			{"","mesecons:redstone",""}
			}
})

minetest.register_craft({
	output = "clonetron:light",
	recipe = {
			{"","mcl_torches:torch",""},
			{"","clonetron:clonetron_core",""},
			{"","",""}
			}
})

minetest.register_craft({
	output = "clonetron:digger",
	recipe = {
			{"","mcl_core:diamond",""},
			{"mcl_core:diamond","clonetron:clonetron_core","mcl_core:diamond"},
			{"","mcl_core:diamond",""}
			}
})

minetest.register_craft({
	output = "clonetron:soft_digger",
	recipe = {
			{"","mcl_core:iron_ingot",""},
			{"mcl_core:iron_ingot","clonetron:clonetron_core","mcl_core:iron_ingot"},
			{"","mcl_core:iron_ingot",""}
			}
})

minetest.register_craft({
	output = "clonetron:inventory",
	recipe = {
			{"","mcl_chests:chest",""},
			{"","clonetron:clonetron_core",""},
			{"","",""}
			}
})

minetest.register_craft({
	output = "clonetron:fuelstore",
	recipe = {
			{"","mcl_furnaces:furnace",""},
			{"","clonetron:clonetron_core",""},
			{"","",""}
			}
})

if minetest.get_modpath("technic") then
	-- no need for this recipe if technic is not installed, avoid cluttering crafting guides
	minetest.register_craft({
		output = "clonetron:battery_holder",
		recipe = {
				{"","mcl_chests:chest",""},
				{"","clonetron:clonetron_core",""},
				{"","mcl_core:iron_ingot",""}
				}
	})
	
	minetest.register_craft({
		output = "clonetron:power_connector",
		recipe = {
				{"","technic:hv_cable",""},
				{"technic:hv_cable","clonetron:clonetron_core","technic:hv_cable"},
				{"","technic:hv_cable",""}
				}
	})
end

minetest.register_craft({
	output = "clonetron:combined_storage",
	recipe = {
			{"","mcl_furnaces:furnace",""},
			{"","clonetron:clonetron_core",""},
			{"","mcl_chests:chest",""}
			}
})

minetest.register_craft({
	output = "clonetron:pusher",
	recipe = {
			{"","mcl_core:coal_lump",""},
			{"mcl_core:coal_lump","clonetron:clonetron_core","mcl_core:coal_lump"},
			{"","mcl_core:coal_lump",""}
			}
})

minetest.register_craft({
	output = "clonetron:axle",
	recipe = {
			{"mcl_core:coal_lump","mcl_core:coal_lump","mcl_core:coal_lump"},
			{"mcl_core:coal_lump","clonetron:clonetron_core","mcl_core:coal_lump"},
			{"mcl_core:coal_lump","mcl_core:coal_lump","mcl_core:coal_lump"}
			}
})

minetest.register_craft({
	output = "clonetron:empty_crate",
	recipe = {
			{"","mcl_chests:chest",""},
			{"","clonetron:clonetron_core",""},
			{"","mesecons_torch:redstoneblock",""}
			}
})

minetest.register_craft({
	output = "clonetron:empty_locked_crate",
	type = "shapeless",
	recipe = {"mcl_core:iron_ingot", "clonetron:empty_crate"},
})

minetest.register_craft({
	output = "clonetron:empty_crate",
	type = "shapeless",
	recipe = {"clonetron:empty_locked_crate"},
})

minetest.register_craft({
	output = "clonetron:duplicator",
	recipe = {
			{"mesecons_torch:redstoneblock","mesecons_torch:redstoneblock","mesecons_torch:redstoneblock"},
			{"mcl_chests:chest","clonetron:clonetron_core","mcl_chests:chest"},
			{"mesecons_torch:redstoneblock","mesecons_torch:redstoneblock","mesecons_torch:redstoneblock"}
			}
})

minetest.register_craft({
	output = "clonetron:inventory_ejector",
	recipe = {
			{"mcl_core:iron_ingot","mcl_core:iron_ingot","mcl_core:iron_ingot"},
			{"","clonetron:clonetron_core",""},
			{"","mcl_core:iron_ingot",""}
			}
})

-- Structural

minetest.register_craft({
	output = "clonetron:structure",
	recipe = {
			{"group:stick","","group:stick"},
			{"","clonetron:clonetron_core",""},
			{"group:stick","","group:stick"}
			}
})

minetest.register_craft({
	output = "clonetron:panel",
	recipe = {
			{"","",""},
			{"","clonetron:clonetron_core",""},
			{"","mcl_core:iron_ingot",""}
			}
})

minetest.register_craft({
	output = "clonetron:edge_panel",
	recipe = {
			{"","",""},
			{"","clonetron:clonetron_core","mcl_core:iron_ingot"},
			{"","mcl_core:iron_ingot",""}
			}
})

minetest.register_craft({
	output = "clonetron:corner_panel",
	recipe = {
			{"","",""},
			{"","clonetron:clonetron_core","mcl_core:iron_ingot"},
			{"","mcl_core:iron_ingot","mcl_core:iron_ingot"}
			}
})

-- For swapping digger types
minetest.register_craft({
	output = "clonetron:digger",
	recipe = {
			{"clonetron:intermittent_digger"},
			}
})
minetest.register_craft({
	output = "clonetron:intermittent_digger",
	recipe = {
			{"clonetron:digger"},
			}
})
minetest.register_craft({
	output = "clonetron:soft_digger",
	recipe = {
			{"clonetron:intermittent_soft_digger"},
			}
})
minetest.register_craft({
	output = "clonetron:intermittent_soft_digger",
	recipe = {
			{"clonetron:soft_digger"},
			}
})

minetest.register_craft({
	output = "clonetron:dual_soft_digger",
	type = "shapeless",
	recipe = {"clonetron:soft_digger", "clonetron:soft_digger"},
})
minetest.register_craft({
	output = "clonetron:dual_digger",
	type = "shapeless",
	recipe = {"clonetron:digger", "clonetron:digger"},
})
minetest.register_craft({
	output = "clonetron:soft_digger 2",
	recipe = {
			{"clonetron:dual_soft_digger"},
			}
})
minetest.register_craft({
	output = "clonetron:digger 2",
	recipe = {
			{"clonetron:dual_digger"},
			}
})

-- And some recycling reactions to get Clonetron cores out of the "cheap" parts:

minetest.register_craft({
	output = "clonetron:clonetron_core",
	recipe = {
			{"clonetron:structure"},
			}
})
minetest.register_craft({
	output = "clonetron:clonetron_core",
	recipe = {
			{"clonetron:panel"},
			}
})
minetest.register_craft({
	output = "clonetron:clonetron_core",
	recipe = {
			{"clonetron:corner_panel"},
			}
})
minetest.register_craft({
	output = "clonetron:clonetron_core",
	recipe = {
			{"clonetron:edge_panel"},
			}
})

minetest.register_craft({
	output = "clonetron:clonetron_core",
	recipe = {
			{"clonetron:inventory"},
			}
})

minetest.register_craft({
	output = "clonetron:clonetron_core",
	recipe = {
			{"clonetron:fuelstore"},
			}
})

minetest.register_craft({
	output = "clonetron:clonetron_core",
	recipe = {
			{"clonetron:combined_storage"},
			}
})

minetest.register_craft({
	output = "clonetron:clonetron_core",
	recipe = {
			{"clonetron:light"},
			}
})

minetest.register_craft({
	output = "clonetron:clonetron_core",
	recipe = {
			{"clonetron:pusher"},
			}
})

minetest.register_craft({
	output = "clonetron:clonetron_core",
	recipe = {
			{"clonetron:axle"},
			}
})