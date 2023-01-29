# Clonetron
## Digtron for MineClone!

This mod (if I ever complete it) will be a port of Digtron, but for Mineclone. I had no part in the development of Digtron, so I have no idea how hard it will be to port. I'll  just start by finding/replacing all refrences to `default` items with `mcl` items, and hopefully that will be enough. Of course, it probably won't, and I'll be chasing down errors for days, and maybe have to learn how the whole Minetest API works. But it will (probably) be finished (enough) at some (very unknown) point in the (possibly distant) future.

Anyway, here is the description for Digtron.


# Modular Tunnel Boring Machine
## aka The Almighty Clonetron


This mod contains a set of blocks that can be used to construct highly customizable and modular tunnel-boring machines, bridge-builders, road-pavers, wall-o-matics, and other such construction/destruction contraptions.

A digging machine's components must be connected to the control block via a path leading through the faces of the blocks - diagonal connections across edges and corners don't count. 

The basic block types that can be assembled into a functioning digging machine are:

* Digger heads, which excavate material in front of them when the machine is triggered
* Builder heads, which build a user-configured node in the direction they're facing
* Inventory modules, which hold material produced by the digger and provide material to the builders
* Fuel modules, which holds flammable materials to feed the beast
* Control block, used to trigger the machine and move it in a particular direction.

Diggers mine out blocks and shunt them into the Clonetron's inventory, or drop them on the ground if there isn't room in the inventory to store them.

Builder heads can be used to lay down a solid surface as the Clonetron moves, useful for situations where a tunnel-borer intersects a cavern. Builder heads can be set to construct their target block "intermittently", allowing for regularly-spaced structures to be constructed. Common uses include building support arches at regular intervals in a tunnel, adding a torch on the wall at regular intervals, laying rails with regularly-spaced powered rails interspersed, and adding stairs to vertical shafts.

The auto-controller block is able to trigger automatically for a user-selected number of cycles. A player can ride their Clonetron as it goes.

Other specialized Clonetron blocks include:

* An "axle" block that allows an assembled Clonetron to be rotated into new orientations without needing to be rebuilt block-by-block
* A crate that can store an assembled Clonetron and allow the player to transport it to a new location
* A duplicator that can create a copy of an existing Clonetron (if provided with enough spare parts)
* An item ejector to clear Clonetron's inventory of excavated materials and inject it into pipeworks tubes if that mod is installed.
* A light that can be mounted on a Clonetron to illuminate the workspace as it moves
* Structural components to make it look cool

The Clonetron mod only depends on MineClone, but includes optional support for several other mods:

```
NOTE: ALL OF THESE ARE COMPLETELY UNTESTED WITH CLONETRON (though they do work with Digtron)! Also, very few of these have MineClone versions.
I don't even know if the Hopper mod will work.
```

* [doc](https://forum.minetest.net/viewtopic.php?t=15912), an in-game documentation mod. Detailed documentation for all of the Clonetron's individual blocks are included as well as pages of general concepts and design tips.
* [pipeworks](https://forum.minetest.net/viewtopic.php?id=2155), a set of pneumatic tubes that allows inventory items to be extracted from or inserted into Clonetron inventories.
* [hopper](https://forum.minetest.net/viewtopic.php?&t=12379), a different mod for inserting into and extracting from Clonetron inventories. Note that only [the most recent version of hopper is Clonetron-capable,](https://github.com/minetest-mods/hopper) earlier versions lack a suitable API.
* [awards](https://forum.minetest.net/viewtopic.php?&t=4870), a mod that adds achievements to the game. Over thirty Clonetron-specific achievements are included.
* [technic](https://forum.minetest.net/viewtopic.php?f=11&t=2538), which adds rechargeable batteries and power cables to the game that Clonetron can use instead of fuel.
