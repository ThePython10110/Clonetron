if not minetest.get_modpath("awards") then
	clonetron.award_item_dug = function (items, name, count) end
	clonetron.award_layout = function (layout, name) end
	clonetron.award_item_built = function(item_name, name) end
	clonetron.award_crate = function (layout, name) end
	return
end

---------------------------------------------------------------------------

-- internationalization boilerplate
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")

awards.register_trigger("clonetron_dig", {
	type = "counted_key",
	progress = "@1/@2 excavated",
	auto_description = {"Excavate 1 @2 using a clonetron.", "Excavate @1 @2 using a clonetron."},
	auto_description_total = {"Excavate @1 block using a clonetron.", "Excavate @1 blocks using a clonetron."},
	get_key = function(self, def)
		return minetest.registered_aliases[def.trigger.node] or def.trigger.node
	end,
	key_is_item = true,
})

clonetron.award_item_dug = function(items_dropped, player)
	if #items_dropped == 0 or not player then
		return
	end
	for _, item in pairs(items_dropped) do
		awards.notify_clonetron_dig(player, item)
	end
end

awards.register_trigger("clonetron_build", {
	type = "counted_key",
	progress = "@1/@2 built",
	auto_description = {"Build 1 @2 using a clonetron.", "Build @1 @2 using a clonetron."},
	auto_description_total = {"Build @1 block using a clonetron.", "Build @1 blocks using a clonetron."},
	get_key = function(self, def)
		return minetest.registered_aliases[def.trigger.node] or def.trigger.node
	end,
	key_is_item = true,
})

clonetron.award_item_built = function(item_name, player)
	if not player then
		return
	end
	awards.notify_clonetron_build(player, item_name)
end

clonetron.award_layout = function(layout, player)
	if layout == nil or not player then
		return
	end

	local name = player:get_player_name()

	if layout.water_touching then
		awards.unlock(name, "clonetron_water")
	end
	if layout.lava_touching then
		awards.unlock(name, "clonetron_lava")
	end
	if table.getn(layout.all) > 9 then
		awards.unlock(name, "clonetron_size10")
		if table.getn(layout.all) > 99 then
			awards.unlock(name, "clonetron_size100")
		end
	end
	if layout.diggers ~= nil and table.getn(layout.diggers) > 24 then
		awards.unlock(name, "clonetron_digger25")
	end
	if layout.builders ~= nil and table.getn(layout.builders) > 24 then
		awards.unlock(name, "clonetron_builder25")
	end
	
	if layout.controller.y > 100 then
		awards.unlock(name, "clonetron_height100")
		if layout.controller.y > 1000 then
			awards.unlock(name, "clonetron_height1000")
		end
	elseif layout.controller.y < -40 and layout.controller.y > -100 then
		awards.unlock(name, "clonetron_depth40")
	elseif layout.controller.y < -28900 and layout.controller.y > -28945 then
		awards.unlock(name, "clonetron_nether")
	elseif layout.controller.y < -26900 then
		awards.unlock(name, "clonetron_end")
	end
end

clonetron.award_crate = function(layout, name)
	if layout == nil or not name or name == "" then
		return
	end

	-- Note that we're testing >10 rather than >9 because this layout includes the crate node
	if table.getn(layout.all) > 10 then
		awards.unlock(name, "clonetron_crate10")
		if table.getn(layout.all) > 100 then
			awards.unlock(name, "clonetron_crate100")
		end
	end
end

awards.register_achievement("clonetron_water",{
	title = S("Deep Blue clonetron"),
	description = S("Encounter water while operating a clonetron."),
	background = "awards_bg_mining.png",
	icon = "bucket_water.png^clonetron_digger_yb_frame.png",
})

awards.register_achievement("clonetron_lava",{
	title = S("clonetrons of Fire"),
	description = S("Encounter lava while operating a clonetron."),
	background = "awards_bg_mining.png",
	icon = "bucket_lava.png^clonetron_digger_yb_frame.png",
})

awards.register_achievement("clonetron_size10",{
	title = S("Bigtron"),
	description = S("Operate a clonetron with 10 or more component blocks."),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^clonetron_crate.png",
})

awards.register_achievement("clonetron_size100",{
	title = S("Really Bigtron"),
	description = S("Operate a clonetron with 100 or more component blocks."),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^clonetron_crate.png", -- TODO: Visually distinguish this from Bigtron
})

awards.register_achievement("clonetron_builder25",{
	title = S("Buildtron"),
	description = S("Operate a clonetron with 25 or more builder modules."),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^clonetron_builder.png^clonetron_crate.png",
})

awards.register_achievement("clonetron_digger25",{
	title = S("Digging Leviathan"),
	description = S("Operate a clonetron with 25 or more digger heads."),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^clonetron_motor.png^clonetron_crate.png",
})

awards.register_achievement("clonetron_height1000",{
	title = S("clonetron In The Sky"),
	description = S("Operate a clonetron above 1000m elevation"),
	background = "awards_bg_mining.png",
	icon = "default_river_water.png^default_snow_side.png^[transformR180^clonetron_digger_yb_frame.png",
	--Wow, originally, this just put the snow texture on top of the river water texture... cool.
	--Unfortunately, doesn't work with MineClone, since it doesn't have the same kind of snow.
})

awards.register_achievement("clonetron_height100",{
	title = S("clonetron High"),
	description = S("Operate a clonetron above 100m elevation"),
	background = "awards_bg_mining.png",
	icon = "default_river_water.png^default_snow_side.png^clonetron_digger_yb_frame.png",
})

awards.register_achievement("clonetron_depth40",{
	title = S("Digging Deeper"),
	description = S("Operate a Clonetron 40m underground"),
	background = "awards_bg_mining.png",
	icon = "default_cobble.png^[colorize:#0008^clonetron_digger_yb_frame.png^awards_level5.png",
}

awards.register_achievement("clonetron_nether",{
	title = S("Interdimensional Clonetron"),
	description = S("Operate a Clonetron in the Nether"),
	background = "awards_bg_mining.png",
	icon = "mcl_nether_netherrack.png^[colorize:#0008^clonetron_digger_yb_frame.png^awards_level5.png",
}

awards.register_achievement("clonetron_end",{
	title = S("End stone lover"),
	description = S("Operate a Clonetron in the End"),
	background = "awards_bg_mining.png",
	icon = "mcl_end_end_stone.png^[colorize:#0008^clonetron_digger_yb_frame.png^awards_level5.png",
}

awards.register_achievement("clonetron_500redstone_dug",{
	title = S("Machine Master"),
	description = S("Get 500 redstone dust with a Clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^redstone_redstone_dust.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		node = "mesecons:redstone",
		target = 500,
	}
})

awards.register_achievement("clonetron_500lapis_dug",{
	title = S("Machine Master"),
	description = S("Get 500 lapis with a Clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^mcl_core_lapis.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		node = "mcl_core:lapis",
		target = 500,
	}
})

awards.register_achievement("clonetron_100diamond_dug",{
	title = S("Diamond Vs. Diamond"),
	description = S("Mine 100 diamonds with a clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^default_diamond.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		node = "mcl_core:diamond",
		target = 100,
	}
})

awards.register_achievement("clonetron_1debris_dug",{
	title = S("No-effort Netherite"),
	description = S("Find ancient debris with a Clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^mcl_nether_ancient_debris.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		node = "mcl_core:mcl_nether:ancient_debris",
		target = 1,
	}
})

awards.register_achievement("clonetron_100debris_dug",{
	title = S("Just... how?"),
	description = S("Mine 100 ancient debris with a Clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^mcl_nether_ancient_debris.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		node = "mcl_core:mcl_nether:ancient_debris",
		target = 100,
	}
})

awards.register_achievement("clonetron_1000dirt_dug",{
	title = S("Strip Mining"),
	description = S("Excavate 1000 units of dirt with a clonetron"),
	background = "awards_bg_mining.png",
	icon = "default_dirt.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		node = "mcl_core:dirt",
		target = 1000,
	}
})

awards.register_achievement("clonetron_1000_dug",{
	title = S("clonetron Miner"),
	description = S("Excavate 1000 blocks using a clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^default_tool_bronzepick.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		target = 1000,
	}
})

awards.register_achievement("clonetron_10000_dug",{
	title = S("clonetron Expert Miner"),
	description = S("Excavate 10,000 blocks using a clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^default_tool_steelpick.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		target = 10000,
	}
})

awards.register_achievement("clonetron_100000_dug",{
	title = S("clonetron Master Miner"),
	description = S("Excavate 100,000 blocks using a clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^default_tool_diamondpick.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		target = 100000,
	}
})

awards.register_achievement("clonetron_1000000_dug",{
	title = S("clonetron MEGAMINER"),
	description = S("Excavate over a million blocks using a clonetron!"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^default_tool_mesepick.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		target = 1000000,
	}
})

awards.register_achievement("clonetron_1000wood_dug",{
	title = S("Clear Cutting"),
	description = S("Chop down 1000 units of tree with a clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^default_sapling.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		node = "group:tree",
		target = 1000,
	}
})

awards.register_achievement("clonetron_10000wood_dug",{
	title = S("clonetron Deforestation"),
	description = S("Chop down 10,000 units of tree with a clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^default_sapling.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		node = "group:tree",
		target = 10000,
	}
})

awards.register_achievement("clonetron_1000grass_dug",{
	title = S("Lawnmower"),
	description = S("Harvest 1000 units of grass with a clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^default_grass_5.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		node = "group:grass",
		target = 1000,
	}
})

awards.register_achievement("clonetron_1000iron_dug",{
	title = S("Iron clonetron"),
	description = S("Excavate 1000 units of iron ore with a clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^default_steel_ingot.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		node = "mcl_raw_ores:raw_iron",
		target = 1000,
	}
})

awards.register_achievement("clonetron_1000copper_dug",{
	title = S("Copper clonetron"),
	description = S("Excavate 1000 units of copper ore with a clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^default_copper_ingot.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		node = "mcl_raw_ores:raw_copper",
		target = 1000,
	}
})

awards.register_achievement("clonetron_1000coal_dug",{
	title = S("Coal clonetron"),
	description = S("Excavate 1,000 units if coal with a clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^default_coal_lump.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		node = "mcl_core:coal_lump",
		target = 1000,
	}
})

awards.register_achievement("clonetron_10000coal_dug",{
	title = S("Bagger 288"),
	description = S("Excavate 10,000 units of coal with a clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^default_coal_block.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		node = "mcl_core:coal_lump",
		target = 10000,
	}
})

awards.register_achievement("clonetron_100gold_dug",{
	title = S("clonetron 49er"),
	description = S("Excavate 100 units of gold with a clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^default_gold_ingot.png^clonetron_digger_yb_frame.png",
	trigger = {
		type = "clonetron_dig",
		node = "mcl_raw_ores:raw_gold",
		target = 100,
	}
})

awards.register_achievement("clonetron_1000_built",{
	title = S("Constructive Digging"),
	description = S("Build 1,000 blocks with a clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^clonetron_builder.png",
	trigger = {
		type = "clonetron_build",
		target = 1000,
	}
})

awards.register_achievement("clonetron_10000_built",{
	title = S("Highly Constructive Digging"),
	description = S("Build 10,000 blocks with a clonetron"),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^clonetron_axel_side.png^[transformR90^clonetron_builder.png",
	trigger = {
		type = "clonetron_build",
		target = 10000,
	}
})

awards.register_achievement("clonetron_crate10",{
	title = S("clonetron Packrat"),
	description = S("Stored 10 or more clonetron blocks in one crate."),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^clonetron_crate.png", -- TODO: Visually distinguish this from Bigtron
})

awards.register_achievement("clonetron_crate100",{
	title = S("clonetron Hoarder"),
	description = S("Stored 100 or more clonetron blocks in one crate."),
	background = "awards_bg_mining.png",
	icon = "clonetron_plate.png^clonetron_crate.png", -- TODO: Visually distinguish this from Bigtron
})
