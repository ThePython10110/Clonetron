clonetron = {}

clonetron.auto_controller_colorize = "#88000030"
clonetron.pusher_controller_colorize = "#00880030"
clonetron.soft_digger_colorize = "#88880030"

-- A global dictionary is used here so that other substitutions can be added easily by other mods, if necessary
clonetron.builder_read_item_substitutions = {
	["mcl_torches:torch_ceiling"] = "mcl_torches:torch",
	["mcl_torches:torch_wall"] = "mcl_torches:torch",
	["mcl_core:dirt_with_grass"] = "mcl_core:dirt",
	["mcl_core:dirt_with_grass_footsteps"] = "mcl_core:dirt",
	["mcl_core:dirt_with_dry_grass"] = "mcl_core:dirt",
	["mcl_core:dirt_with_rainforest_litter"] = "mcl_core:dirt",
	["mcl_core:dirt_with_snow"] = "mcl_core:dirt",
	["mcl_furnaces:furnace_active"] = "mcl_furnaces:furnace",
	["farming:soil"] = "mcl_core:dirt",
	["farming:soil_wet"] = "mcl_core:dirt",
}

-- MineClone doesn't have clonetron.get_hotbar_bg. I have no clue what it does, but I just copied it from the default mod.
function clonetron.get_hotbar_bg(x,y)
	local out = ""
	for i=0,7,1 do
		out = out .."image["..x+i..","..y..";1,1;gui_hb_bg.png]"
	end
	return out
end

-- Sometimes we want builder heads to call an item's "on_place" method, other times we
-- don't want them to. There's no way to tell which situation is best programmatically
-- so we have to rely on whitelists to be on the safe side.

--first exact matches are tested, and the value given in this global table is returned
clonetron.builder_on_place_items = {
	["mcl_torches:torch"] = true,
}

-- Then a string prefix is checked, returning this value. Useful for enabling on_placed on a mod-wide basis.
clonetron.builder_on_place_prefixes = {
	["farming:"] = true,
	["farming_plus:"] = true,
	["crops:"] = true, 
}

-- Finally, items belonging to group "clonetron_on_place" will have their on_place methods called.

local clonetron_modpath = minetest.get_modpath( "clonetron" )

dofile( clonetron_modpath .. "/class_fakeplayer.lua")

clonetron.fake_player = ClonetronFakePlayer.create({x=0,y=0,z=0}, "fake_player") -- since we only need one fake player at a time and it doesn't retain useful state, create a global one and just update it as needed.

dofile( clonetron_modpath .. "/config.lua" )
dofile( clonetron_modpath .. "/util.lua" )
dofile( clonetron_modpath .. "/doc.lua" )
dofile( clonetron_modpath .. "/awards.lua" )
dofile( clonetron_modpath .. "/class_pointset.lua" )
dofile( clonetron_modpath .. "/class_layout.lua" )
dofile( clonetron_modpath .. "/entities.lua" )
dofile( clonetron_modpath .. "/nodes/node_misc.lua" ) -- contains structure and light nodes
dofile( clonetron_modpath .. "/nodes/node_storage.lua" ) -- contains inventory and fuel storage nodes
dofile( clonetron_modpath .. "/nodes/node_diggers.lua" ) -- contains all diggers
dofile( clonetron_modpath .. "/nodes/node_builders.lua" ) -- contains all builders (there's just one currently)
dofile( clonetron_modpath .. "/nodes/node_controllers.lua" ) -- controllers
dofile( clonetron_modpath .. "/nodes/node_axle.lua" ) -- Rotation controller
dofile( clonetron_modpath .. "/nodes/node_crate.lua" ) -- Clonetron portability support
dofile( clonetron_modpath .. "/nodes/node_item_ejector.lua" ) -- ejects non-building, non-fuel items from inventories
dofile( clonetron_modpath .. "/nodes/node_duplicator.lua" ) -- constructs copies of existing Clonetrons

--Technic
dofile( clonetron_modpath .. "/nodes/node_battery_holder.lua" ) -- holds rechargeable batteries from the technic mod
dofile( clonetron_modpath .. "/nodes/node_power_connector.lua")

dofile( clonetron_modpath .. "/nodes/recipes.lua" )

dofile( clonetron_modpath .. "/upgrades.lua" ) -- various LBMs for upgrading older versions of Clonetron.

-- Clonetron group numbers:
-- 1 - generic Clonetron node, nothing special is done with these. They're just dragged along.
-- 2 - inventory-holding Clonetron, has a "main" inventory that the Clonetron can add to and take from.
-- 3 - digger head, has an "execute_dig" method in its definition
-- 4 - builder head, has a "test_build" and "execute_build" method in its definition
-- 5 - fuel-holding Clonetron, has a "fuel" invetory that the control node can draw fuel items from. Separate from general inventory, nothing gets put here automatically.
-- 6 - holds both fuel and main inventories
-- 7 - holds batteries (RE Battery from technic) to provide clean renewable power
-- 8 - connects to adjacent HV technic cable
-- 9 - connects to pipeworks, auto-ejects mined items

-- This code was added for use with FaceDeer's fork of the [catacomb] mod. Paramat's version doesn't support customized protected nodes, which causes
-- it to "eat" Clonetrons sometimes.
if minetest.get_modpath("catacomb") and catacomb ~= nil and catacomb.chamber_protected_nodes ~= nil and catacomb.passage_protected_nodes ~= nil then
	local clonetron_nodes = {
		minetest.get_content_id("clonetron:inventory"),
		minetest.get_content_id("clonetron:fuelstore"),
		minetest.get_content_id("clonetron:battery_holder"),
		minetest.get_content_id("clonetron:combined_storage"),
		minetest.get_content_id("clonetron:axle"),
		minetest.get_content_id("clonetron:builder"),
		minetest.get_content_id("clonetron:controller"),
		minetest.get_content_id("clonetron:auto_controller"),
		minetest.get_content_id("clonetron:pusher"),
		minetest.get_content_id("clonetron:loaded_crate"),
		minetest.get_content_id("clonetron:digger"),
		minetest.get_content_id("clonetron:intermittent_digger"),
		minetest.get_content_id("clonetron:soft_digger"),
		minetest.get_content_id("clonetron:intermittent_soft_digger"),
		minetest.get_content_id("clonetron:dual_digger"),
		minetest.get_content_id("clonetron:dual_soft_digger"),
		minetest.get_content_id("clonetron:structure"),
		minetest.get_content_id("clonetron:light"),
		minetest.get_content_id("clonetron:panel"),
		minetest.get_content_id("clonetron:edge_panel"),
		minetest.get_content_id("clonetron:corner_panel"),
		minetest.get_content_id("clonetron:battery_holder"),
		minetest.get_content_id("clonetron:inventory_ejector"),
		minetest.get_content_id("clonetron:power_connector"),
	}
	for _, node_id in pairs(clonetron_nodes) do
		catacomb.chamber_protected_nodes[node_id] = true
		catacomb.passage_protected_nodes[node_id] = true
	end
end