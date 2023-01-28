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
			{"mcl_core:iron_ingot","default:mese_crystal_fragment","mcl_core:iron_ingot"},
			{"","mcl_core:iron_ingot",""}
			}
})

minetest.register_craft({
	output = "clonetron:controller",
	recipe = {
			{"","default:mese_crystal",""},
			{"default:mese_crystal","clonetron:clonetron_core","default:mese_crystal"},
			{"","default:mese_crystal",""}
			}
})

minetest.register_craft({
	output = "clonetron:auto_controller",
	recipe = {
			{"default:mese_crystal","default:mese_crystal","default:mese_crystal"},
			{"default:mese_crystal","clonetron:clonetron_core","default:mese_crystal"},
			{"default:mese_crystal","default:mese_crystal","default:mese_crystal"}
			}
})

minetest.register_craft({
	output = "clonetron:builder",
	recipe = {
			{"","default:mese_crystal_fragment",""},
			{"default:mese_crystal_fragment","clonetron:clonetron_core","default:mese_crystal_fragment"},
			{"","default:mese_crystal_fragment",""}
			}
})

minetest.register_craft({
	output = "clonetron:light",
	recipe = {
			{"","default:torch",""},
			{"","clonetron:clonetron_core",""},
			{"","",""}
			}
})

minetest.register_craft({
	output = "clonetron:digger",
	recipe = {
			{"","default:diamond",""},
			{"default:diamond","clonetron:clonetron_core","default:diamond"},
			{"","default:diamond",""}
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
			{"","default:chest",""},
			{"","clonetron:clonetron_core",""},
			{"","",""}
			}
})

minetest.register_craft({
	output = "clonetron:fuelstore",
	recipe = {
			{"","default:furnace",""},
			{"","clonetron:clonetron_core",""},
			{"","",""}
			}
})

if minetest.get_modpath("technic") then
	-- no need for this recipe if technic is not installed, avoid cluttering crafting guides
	minetest.register_craft({
		output = "clonetron:battery_holder",
		recipe = {
				{"","default:chest",""},
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
			{"","default:furnace",""},
			{"","clonetron:clonetron_core",""},
			{"","default:chest",""}
			}
})

minetest.register_craft({
	output = "clonetron:pusher",
	recipe = {
			{"","default:coal_lump",""},
			{"default:coal_lump","clonetron:clonetron_core","default:coal_lump"},
			{"","default:coal_lump",""}
			}
})

minetest.register_craft({
	output = "clonetron:axle",
	recipe = {
			{"default:coal_lump","default:coal_lump","default:coal_lump"},
			{"default:coal_lump","clonetron:clonetron_core","default:coal_lump"},
			{"default:coal_lump","default:coal_lump","default:coal_lump"}
			}
})

minetest.register_craft({
	output = "clonetron:empty_crate",
	recipe = {
			{"","default:chest",""},
			{"","clonetron:clonetron_core",""},
			{"","default:mese_crystal",""}
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
			{"default:mese_crystal","default:mese_crystal","default:mese_crystal"},
			{"default:chest","clonetron:clonetron_core","default:chest"},
			{"default:mese_crystal","default:mese_crystal","default:mese_crystal"}
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

-- And some recycling reactions to get clonetron cores out of the "cheap" parts:

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