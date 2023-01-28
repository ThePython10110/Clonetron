minetest.register_entity("clonetron:marker", {
	initial_properties = {
		visual = "cube",
		visual_size = {x=1.05, y=1.05},
		textures = {"clonetron_marker_side.png","clonetron_marker_side.png","clonetron_marker.png","clonetron_marker.png","clonetron_marker_side.png","clonetron_marker_side.png"},
		collisionbox = {-0.525, -0.525, -0.525, 0.525, 0.525, 0.525},
		physical = false,
	},

	on_activate = function(self, staticdata)
		minetest.after(5.0, 
			function(self) 
				self.object:remove()
			end,
			self)
	end,
	
	on_rightclick=function(self, clicker)
		self.object:remove()
	end,
	
	on_punch = function(self, hitter)
		self.object:remove()
	end,
})

minetest.register_entity("clonetron:marker_vertical", {
	initial_properties = {
		visual = "cube",
		visual_size = {x=1.05, y=1.05},
		textures = {"clonetron_marker.png","clonetron_marker.png","clonetron_marker_side.png^[transformR90","clonetron_marker_side.png^[transformR90","clonetron_marker_side.png^[transformR90","clonetron_marker_side.png^[transformR90"},
		collisionbox = {-0.525, -0.525, -0.525, 0.525, 0.525, 0.525},
		physical = false,
	},

	on_activate = function(self, staticdata)
		minetest.after(5.0, 
			function(self) 
				self.object:remove()
			end,
			self)
	end,
	
	on_rightclick=function(self, clicker)
		self.object:remove()
	end,
	
	on_punch = function(self, hitter)
		self.object:remove()
	end,
})

minetest.register_entity("clonetron:marker_crate_good", {
	initial_properties = {
		visual = "cube",
		visual_size = {x=1.05, y=1.05},
		textures = {"clonetron_crate.png", "clonetron_crate.png", "clonetron_crate.png", "clonetron_crate.png", "clonetron_crate.png", "clonetron_crate.png"},
		collisionbox = {-0.525, -0.525, -0.525, 0.525, 0.525, 0.525},
		physical = false,
	},

	on_activate = function(self, staticdata)
		minetest.after(clonetron.config.marker_crate_good_duration, 
			function(self) 
				self.object:remove()
			end,
			self)
	end,
	
	on_rightclick=function(self, clicker)
		self.object:remove()
	end,
	
	on_punch = function(self, hitter)
		self.object:remove()
	end,
})

minetest.register_entity("clonetron:marker_crate_bad", {
	initial_properties = {
		visual = "cube",
		visual_size = {x=1.05, y=1.05},
		textures = {"clonetron_no_entry.png", "clonetron_no_entry.png", "clonetron_no_entry.png", "clonetron_no_entry.png", "clonetron_no_entry.png", "clonetron_no_entry.png"},
		collisionbox = {-0.525, -0.525, -0.525, 0.525, 0.525, 0.525},
		physical = false,
	},

	on_activate = function(self, staticdata)
		minetest.after(clonetron.config.marker_crate_bad_duration, 
			function(self) 
				self.object:remove()
			end,
			self)
	end,
	
	on_rightclick=function(self, clicker)
		self.object:remove()
	end,
	
	on_punch = function(self, hitter)
		self.object:remove()
	end,
})

minetest.register_entity("clonetron:builder_item", {

	initial_properties = {
		hp_max = 1,
		is_visible = true,
		visual = "wielditem",
		visual_size = {x=0.25, y=0.25},
		collisionbox = {0,0,0,0,0,0},
		physical = false,
		textures = {""},
		automatic_rotate = math.pi * 0.25,
	},
	
	on_activate = function(self, staticdata)
		local props = self.object:get_properties()
		if staticdata ~= nil and staticdata ~= "" then
			local pos = self.object:get_pos()
			local node = minetest.get_node(pos)
			if minetest.get_item_group(node.name, "clonetron") ~= 4 then
				-- We were reactivated without a builder node on our location, self-destruct
				self.object:remove()
				return
			end
			props.textures = {staticdata}
			self.object:set_properties(props)
		elseif clonetron.create_builder_item ~= nil then
			props.textures = {clonetron.create_builder_item}
			self.object:set_properties(props)
			clonetron.create_builder_item = nil
		else
			self.object:remove()
		end		
	end,
	
	get_staticdata = function(self)
		local props = self.object:get_properties()
		if props ~= nil and props.textures ~= nil and props.textures[1] ~= nil then
			return props.textures[1]
		end
		return ""
	end,
})
