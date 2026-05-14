return {
	['testburger'] = {
		label = 'Test Burger',
		weight = 220,
		degrade = 60,
		dropmodel = 'prop_food_bs_bag_01', --- Custom drop model for this item (optional)
		client = {
			image = 'burger_chicken.png',
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			export = 'ox_inventory_examples.testburger'
		},
		server = {
			export = 'ox_inventory_examples.testburger',
			test = 'what an amazingly delicious burger, amirite?'
		},
		buttons = {
			{
				label = 'Lick it',
				action = function(slot)
					print('You licked the burger')
				end
			},
			{
				label = 'Squeeze it',
				action = function(slot)
					print('You squeezed the burger :(')
				end
			},
			{
				label = 'What do you call a vegan burger?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('A misteak.')
				end
			},
			{
				label = 'What do frogs like to eat with their hamburgers?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('French flies.')
				end
			},
			{
				label = 'Why were the burger and fries running?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('Because they\'re fast food.')
				end
			}
		},
		consume = 0.3
	},

	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		allowArmed = true,
		client = {
			image = 'bandage.webp',
		}
	},

	['combatbandage'] = {
		label = 'Combat Bandage',
		weight = 500,
		allowArmed = true,
		rarity = 'max',
		client = {
			image = 'bandage.webp',
		}
	},

	['ifaks'] = {
		label = 'Ifaks',
		weight = 115,
		allowArmed = true,
		client = {
			image = 'ifaks.png',
			--anim = { dict = 'amb@world_human_clipboard@male@idle_a', clip = 'idle_c', flag = 49 },
			--prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			--disable = {combat = true },
			--usetime = 2500,
		}
	},

	['painkillers'] = {
		label = 'Painkillers',
		weight = 115,
		allowArmed = true,
		client = {
			image = 'painkillers.png',
			--anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			--prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			--disable = {combat = true },
			--usetime = 2500,
		}
	},

	['repairkit'] = {
		label = 'Repair Kit',
		weight = 115,
		client = {
			image = 'repairkit.png',
			event = 'qb-vehiclefailure:client:RepairVehicle'
		}
	},

	['black_money'] = {
		label = 'Dirty Money',
	},

	['cashroll'] = {
		label = 'Cash Roll',
		weight = 1,
		description = 'Hmm money?'
	},

	['burger'] = {
		label = 'Burger',
		weight = 220,
		dropmodel = 'prop_food_bs_bag_01', --- Custom drop model
		client = {
			image = 'burger.webp',
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'You ate a delicious burger'
		},
	},

	['sprunk'] = {
		label = 'Sprunk',
		weight = 350,
		dropmodel = 'prop_ld_can_01', --- Custom drop model (will show the can on ground)
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_can_01`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'You quenched your thirst with a sprunk'
		}
	},

	['frappuccino'] = {
		label = 'Frappuccino',
		weight = 150,
		dropmodel = 'prop_food_bs_bag_01', --- Custom drop model
		client = {
			image = 'frappuccino.png',
			status = {thirst = 200000},
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
		},
	},

	['parachute'] = {
		label = 'Parachute',
		weight = 5000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},

	['diving_gear'] = {
		label = 'Diving Gear',
		weight = 5000,
		stack = false,
	},

	['hazmatkitbag'] = {
		label = 'Hazmat Kit Bag',
		weight = 3000,
		rarity = 'unique',
		stack = false,
		durability = 3000,
		consume = 0.01
	},

	['gasmask'] = {
		label = 'Gas Mask',
		weight = 1500,
		rarity = 'rare',
		stack = false,
		durability = 100,
	},

	['hazmatkit'] = {
		label = 'Hazmat Kit',
		weight = 1500,
		rarity = 'rare',
		stack = false,
		durability = 100,
		consume = 0.01
	},

	['bluehazmatkit'] = {
		label = 'Blue Hazmat Kit',
		weight = 1500,
		rarity = 'rare',
		stack = false,
		durability = 100,
		
	},

	['ramadhazmatkit'] = {
		label = 'Ramad Hazmat Kit',
		weight = 1500,
		rarity = 'rare',
		stack = false,
		durability = 100,
	},

	['moneypaper'] = {
    label = 'Money Paper',
    weight = 1000,
    stack = true,
    close = false,
    description = 'Paper used for printing currency.'
	},

	['moneyspray'] = {
		label = 'Spray',
		weight = 100,
		stack = true,
		close = false,
		description = 'A specialized spray used in the money making process.'
	},

	['dataflash'] = {
		label = 'Data Flash',
		weight = 1,
		stack = true,
		close = true,
	},

	['speaker'] = {
		label = 'Speaker',
		weight = 0,
		description = 'Speaker.',
		consume = 0,
		server = {
			export = 'rahe-speakers.speaker'
		}
	},

	['bmx'] = {
		label = 'BMX',
		weight = 5000,
		stack = false,
		close = true,
		description = 'A portable BMX bike',
		client = {
			event = 'bmx:client:use'
		}
	},

	['codelock'] = {
		label = 'Code Lock',
		weight = 1000,
		stack = false,
		description = 'A portable Code Lock',
	},

	['thermite'] = {
		label = 'Thermite',
		weight = 1000,
		stack = false,
		description = 'Thermite',
	},

	['warehousec4'] = {
		label = 'C4',
		weight = 1000,
		stack = false,
		--description = 'Thermite',
	},

	['bottlecaps'] = {
		label = 'Bottle Caps',
		weight = 1,
		description = 'Bottle Caps',
		rarity = 'legendary',
		client = {
			image = 'bottlecaps.webp',
		}
	},

	["notebook"] = {
		label = "Notebook",
		weight = 200,
		buttons = {
			{
				label = "Duplicate",
				action = function(slot)
					TriggerServerEvent("prp-notebook:server:duplicateNotebook", slot)
				end
			}
		},
	},

	-- Spike strips
	["spikesbox"] = {
		label = "Spike Strip Box",
		weight = 2000,
		stack = false
	},
	["spikebox_pilot"] = {
		label = "Spike Strip Remote",
		weight = 200,
		stack = false
	},
	-- GPS trackers
	["placeable_gps"] = {
		label = "GPS Tracker",
		weight = 100,
		stack = false
	},
	["shootable_gps"] = {
		label = "GPS Tracker (Shootable)",
		weight = 50,
		stack = true,
	},

	["security_camera"] = {
    label = "Security Camera",
    weight = 0,
    stack = false
	},
	["motion_sensor"] = {
		label = "Motion Sensor",
		weight = 0,
		stack = false
	},
	["privacy_tool"] = {
		label = "Device Pry Tool",
		weight = 0,
		stack = false
	},

	-- Mail items
	['envelope'] = {
		label = 'Envelope',
		weight = 10,
	},
	['catalog_envelope'] = {
		label = 'Catalog Envelope',
		weight = 20,
	},
	['letter'] = {
		label = 'Letter',
		weight = 5,
	},

	-- Porch Pirate packages
	['pp_small_1'] = {
		label = 'Small Package',
		weight = 500,
		stack = false,
	},
	['pp_small_2'] = {
		label = 'Small Package',
		weight = 500,
		stack = false,
	},
	['pp_small_3'] = {
		label = 'Small Package',
		weight = 500,
		stack = false,
	},
	['pp_medium_1'] = {
		label = 'Medium Package',
		weight = 1000,
		stack = false,
	},
	['pp_large_1'] = {
		label = 'Large Package',
		weight = 2000,
		stack = false,
	},

-- Base Building Items
['model_door_wood'] = {
    label = 'Wood Door',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_door_wood.png' }
},

['model_door_metal'] = {
    label = 'Metal Door',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_door_metal.png' }
},

['model_door_stone'] = {
    label = 'Stone Door',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_door_stone.png' }
},

['model_window_wood'] = {
    label = 'Wood Window',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_window_wood.png' }
},

['model_window_metal'] = {
    label = 'Metal Window',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_window_metal.png' }
},

['model_window_stone'] = {
    label = 'Stone Window',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_window_stone.png' }
},

['model_windowway_wood'] = {
    label = 'Wood Window Frame',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_windowway_wood.png' }
},

['model_windowway_metal'] = {
    label = 'Metal Window Frame',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_windowway_metal.png' }
},

['model_windowway_stone'] = {
    label = 'Stone Window Frame',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_windowway_stone.png' }
},

['model_wall_wood'] = {
    label = 'Wood Wall',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_wall_wood.png' }
},

['model_wall_metal'] = {
    label = 'Metal Wall',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_wall_metal.png' }
},

['model_wall_stone'] = {
    label = 'Stone Wall',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_wall_stone.png' }
},

['model_doorway_wood'] = {
    label = 'Wood Door Frame',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_doorway_wood.png' }
},

['model_doorway_metal'] = {
    label = 'Metal Door Frame',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_doorway_metal.png' }
},

['model_doorway_stone'] = {
    label = 'Stone Door Frame',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_doorway_stone.png' }
},

['model_gateway_wood'] = {
    label = 'Wood Gate Frame',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_gateway_wood.png' }
},

['model_gateway_metal'] = {
    label = 'Metal Gate Frame',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_gateway_metal.png' }
},

['model_gateway_stone'] = {
    label = 'Stone Gate Frame',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_gateway_stone.png' }
},

['model_base_wood'] = {
    label = 'Wood Foundation',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_base_wood.png' }
},

['model_base_metal'] = {
    label = 'Metal Foundation',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_base_metal.png' }
},

['model_base_stone'] = {
    label = 'Stone Foundation',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_base_stone.png' }
},

['model_ceiling_wood'] = {
    label = 'Wood Ceiling',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_ceiling_wood.png' }
},

['model_ceiling_metal'] = {
    label = 'Metal Ceiling',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_ceiling_metal.png' }
},

['model_ceiling_stone'] = {
    label = 'Stone Ceiling',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_ceiling_stone.png' }
},

['model_pillar_wood'] = {
    label = 'Wood Pillar',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_pillar_wood.png' }
},

['model_pillar_metal'] = {
    label = 'Metal Pillar',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_pillar_metal.png' }
},

['model_pillar_stone'] = {
    label = 'Stone Pillar',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_pillar_stone.png' }
},

['model_gate_wood'] = {
    label = 'Wood Gate',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_gate_wood.png' }
},

['model_gate_metal'] = {
    label = 'Metal Gate',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_gate_metal.png' }
},

['model_gate_stone'] = {
    label = 'Stone Gate',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_gate_stone.png' }
},

-- Triangle & Roof Variants
['model_base_metal_triangle'] = {
    label = 'Metal Triangle Foundation',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_base_metal_triangle.png' }
},

['model_base_wood_triangle'] = {
    label = 'Wood Triangle Foundation',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_base_wood_triangle.png' }
},

['model_base_stone_triangle'] = {
    label = 'Stone Triangle Foundation',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_base_stone_triangle.png' }
},

['model_ceiling_metal_triangle'] = {
    label = 'Metal Triangle Ceiling',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_ceiling_metal_triangle.png' }
},

['model_ceiling_wood_triangle'] = {
    label = 'Wood Triangle Ceiling',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_ceiling_wood_triangle.png' }
},

['model_ceiling_stone_triangle'] = {
    label = 'Stone Triangle Ceiling',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_ceiling_stone_triangle.png' }
},

['model_wall_metal_roof'] = {
    label = 'Metal Roof',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_wall_metal_roof.png' }
},

['model_wall_wood_roof'] = {
    label = 'Wood Roof',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_wall_wood_roof.png' }
},

['model_wall_stone_roof'] = {
    label = 'Stone Roof',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_wall_stone_roof.png' }
},

-- Stairs & Ladders
['model_stairs_wood'] = {
    label = 'Wood Stairs',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_stairs_wood.png' }
},

['model_stairs_metal'] = {
    label = 'Metal Stairs',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_stairs_metal.png' }
},

['model_stairs_stone'] = {
    label = 'Stone Stairs',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_stairs_stone.png' }
},

['model_ceilingladder_wood_triangle'] = {
    label = 'Wood Triangle Ceiling Ladder',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_ceilingladder_wood_triangle.png' }
},

['model_ceilingladder_metal_triangle'] = {
    label = 'Metal Triangle Ceiling Ladder',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_ceilingladder_metal_triangle.png' }
},

['model_ceilingladder_stone_triangle'] = {
    label = 'Stone Triangle Ceiling Ladder',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'model_ceilingladder_stone_triangle.png' }
},

-- Furniture & Props
['bkr_prop_biker_campbed_01'] = {
    label = 'Bed',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'bkr_prop_biker_campbed_01.png' }
},

['v_tre_sofa_mess_b_s'] = {
    label = 'Sofa',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'v_tre_sofa_mess_b_s.png' }
},

['prop_tool_bench02_ld'] = {
    label = 'Crafting Table',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'prop_tool_bench02_ld.png' }
},

['gr_prop_gr_bench_02a'] = {
    label = 'Weapons Table',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'gr_prop_gr_bench_02a.png' }
},

['prop_generator_01a'] = {
    label = 'Generator',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'prop_generator_01a.png' }
},

['prop_box_wood01a'] = {
    label = 'Wood Storage',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'prop_box_wood01a.png' }
},

['wood'] = {
    label = 'Wood',
    weight = 200,
    stack = true,
    close = true,
    description = 'Used for base building',
    client = { image = 'wood.png' }
},

['gr_prop_gr_hobo_stove_01'] = {
    label = 'CampFire',
    weight = 200,
    stack = true,
    close = true,
    description = 'Campfire for cooking food',
    client = { image = 'prop_hobo_stove.png' }
},



	['garbage'] = {
		label = 'Garbage',
	},

	['paperbag'] = {
		label = 'Paper Bag',
		weight = 1,
		stack = false,
		close = false,
		consume = 0
	},

	['identification'] = {
		label = 'Governament ID ',
		client = {
			image = 'govid.webp'
		}
	},

	['id_card'] = {
		label = 'ID CARD',
		client = {
			image = 'id_card.png'
		}
	},

	['driver_license'] = {
		label = 'Driver License',
		client = {
			image = 'driver_license.png'
		}
	},

	['panties'] = {
		label = 'Knickers',
		weight = 10,
		consume = 0,
		client = {
			status = { thirst = -100000, stress = -25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
			usetime = 2500,
		}
	},

	['lockpick'] = {
		label = 'Lockpick',
		weight = 160,
		rarity = 'uncommon',
		client = {
			image = 'lockpick.webp'
		}
	},

	['breaker'] = {
		label = 'Breaker',
		weight = 1000,
		rarity = 'uncommon',
		client = {
			image = 'breaker.png'
		}
	},

	['phone'] = {
		label = 'Phone',
		weight = 190,
		stack = false,
		consume = 0,
		client = {
			image = 'phone.png',
			add = function(total)
				if total > 0 then
					pcall(function() return exports.npwd:setPhoneDisabled(false) end)
				end
			end,

			remove = function(total)
				if total < 1 then
					pcall(function() return exports.npwd:setPhoneDisabled(true) end)
				end
			end
		}
	},

	['money'] = {
		label = 'Money',
	},

	['mustard'] = {
		label = 'Mustard',
		weight = 500,
		client = {
			status = { hunger = 25000, thirst = 25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'You.. drank mustard'
		}
	},

	['water'] = {
		label = 'Water',
		weight = 500,
		client = {
			image = 'water.webp',
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'You drank some refreshing water'
		}
	},

	['radio'] = {
		label = 'Radio',
		weight = 1000,
		stack = false,
		allowArmed = true,
		--rarity = 'unique',
	},
	
	['armour'] = {
		label = 'Bulletproof Vest',
		weight = 2000,
		rarity = 'uncommon',
		stack = false,
		value = 60,
		client = {
			image = 'armor.webp',
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 3500
		}
	},

	['body_armor'] = {
		label = 'Body Armor',
		weight = 2000,
		rarity = 'uncommon',
		stack = false,
	},

	['broken_body_armor'] = {
    label = 'Broken Body Armor',
    weight = 3000,
    stack = false,
    description = 'A vest with no remaining integrity. Can be repaired or recycled.'
	},

	['military_body_armor'] = {
		label = 'Military Body Armor',
		weight = 5000,
		rarity = 'rare',
		stack = false,
		description = 'Heavy-duty tactical vest used by specialized units.'
	},


	['broken_armor_plate'] = {
		label = 'Broken Armor Plate',
		weight = 1000,
		stack = true,
		close = true,
		description = 'A ceramic plate that has been shattered by gunfire.',
		client = {
			image = 'armor_plate.png',
		}
	},

	['armor_plate'] = {
		label = 'Armor Plate',
		weight = 1500,
		stack = true,
		close = true,
		rarity = 'uncommon',
		description = 'Adds 20% to an equipped armor vest. Max 3 plates.'
	},	

	['improved_armor_plate'] = {
		label = 'Improved Armor Plate',
		weight = 2000,
		stack = true,
		close = true,
		rarity = 'rare',
		description = 'A high-grade reinforced plate providing superior protection.',
		client = {
			image = 'armor_plate.png',
		}
	},

	['clothing'] = {
		label = 'Donut',
		consume = 0,
		rarity = 'legendary',
		value = 100,
		client = {
			image = 'donut.png'
		}
	},
	
	['mastercard'] = {
		label = 'Fleeca Card',
		stack = false,
		weight = 10,
		rarity = 'uncommon',
		client = {
			image = 'card_bank.png'
		}
	},
	['military_card'] = {
		label = 'Military Card',
		stack = false,
		weight = 500,
		rarity = 'epic',
		client = {
			image = 'military_card.png'
		}
	},
	['backpack'] = {
		label = 'Regular Backpack',
		stack = false,
		weight = 1000,
		rarity = 'epic',
		client = {
			image = 'backpack.webp'
		},
	},
	
	['scrapmetal'] = {
		label = 'Scrap Metal',
		weight = 80,
	},

	['plastic'] = {
		label = 'Plastic',
		weight = 80,
	},

	['rope'] = {
	label = 'Rope',
	weight = 80,
	client = {
		image = 'rope.webp'
	}
	},

	['binoculars'] = {
	label = 'Binoculars',
	weight = 80,
	rarity = 'epic',
	client = {
		image = 'binoculars.webp'
	}
	},

	['simcard'] = {
	label = 'simcard',
	rarity = 'unique',
	weight = 1,
	client = {
		image = 'simcard.webp'
	}
	},

	['bighousekey'] = {
	label = 'Big House Key',
	rarity = 'legendary',
	weight = 1,
	client = {
		image = 'key1.png'
	}
	},

	['keycard1'] = {
	label = 'Key Card',
	rarity = 'legendary',
	weight = 1,
	client = {
		image = 'keycard1.png'
	}
	},

	['stolentv'] = {
		label = 'Television',
		weight = 5000,
		stack = false,
		unique = true,
		close = true,
		description = 'Some fancy Art',
		client = {
			image = 'television.png'
		}
	},

	['stolenpc'] = {
		label = 'Computer',
		weight = 5000,
		stack = false,
		unique = true,
		close = true,
		description = 'Flat Screen TV',
		client = {
			image = 'computerequipment.png'
		}
	},

	['stolenmicro'] = {
		label = 'Microwave',
		weight = 5000,
		stack = false,
		unique = true,
		close = true,
		description = 'Music Equipment',
		client = {
			image = 'microwave.png'
		}
	},

	['stolenart'] = {
		label = 'Table',
		weight = 5000,
		stack = false,
		unique = true,
		close = true,
		description = 'Computer Equipment',
		client = {
			image = 'np_american-gothic.png'
		}
	},

	['stolencoffee'] = {
		label = 'Coffee Machine',
		weight = 5000,
		stack = false,
		unique = true,
		close = true,
		description = 'Heats things up',
		client = {
			image = 'coffeemachine.png'
		}
	},

	['stolenlaptop'] = {
		label = 'Old Laptop',
		weight = 5000,
		stack = false,
		unique = true,
		close = true,
		description = 'Heats things up',
		client = {
			image = 'px_laptop.png'
		}
	},

	['stolenscope'] = {
		label = 'Telescope',
		weight = 5000,
		stack = false,
		unique = true,
		close = true,
		description = 'Heats things up',
		client = {
			image = 'telescope.png'
		}
	},

	['stolensafe'] = {
		label = 'Safe',
		weight = 10000,
		stack = false,
		unique = true,
		close = true,
		description = 'Heats things up',
		client = {
			image = 'safeee.png'
		}
	},

	["alive_chicken"] = {
		label = "Living chicken",
		weight = 1,
		stack = true,
		close = true,
	},

	["blowpipe"] = {
		label = "Blowtorch",
		weight = 2,
		stack = true,
		close = true,
	},

	["bobby_pin"] = {
		label = "Bobby Pin",
		weight = 1,
		stack = true,
		close = true,
	},

	["bread"] = {
		label = "Bread",
		weight = 1,
		stack = true,
		close = true,
	},

	["burncream"] = {
		label = "Burn Cream",
		weight = 1,
		stack = true,
		close = true,
	},

	["cannabis"] = {
		label = "Cannabis",
		weight = 3,
		stack = true,
		close = true,
	},

	["carokit"] = {
		label = "Body Kit",
		weight = 3,
		stack = true,
		close = true,
	},

	["carotool"] = {
		label = "Tools",
		weight = 2,
		stack = true,
		close = true,
	},

	["clothe"] = {
		label = "Cloth",
		weight = 1,
		stack = true,
		close = true,
	},

	["copper"] = {
		label = "Copper",
		weight = 1,
		stack = true,
		close = true,
	},

	["cutted_wood"] = {
		label = "Cut wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["defib"] = {
		label = "Defibrillator",
		weight = 1,
		stack = true,
		close = true,
	},

	["diamond"] = {
		label = "Diamond",
		weight = 1,
		stack = true,
		close = true,
	},

	["essence"] = {
		label = "Gas",
		weight = 1,
		stack = true,
		close = true,
	},

	["fabric"] = {
		label = "Fabric",
		weight = 1,
		stack = true,
		close = true,
	},

	["fish"] = {
		label = "Fish",
		weight = 1,
		stack = true,
		close = true,
	},

	["fixkit"] = {
		label = "Repair Kit",
		weight = 3,
		stack = true,
		close = true,
	},

	["fixtool"] = {
		label = "Repair Tools",
		weight = 2,
		stack = true,
		close = true,
	},

	["gazbottle"] = {
		label = "Gas Bottle",
		weight = 2,
		stack = true,
		close = true,
	},

	["gold"] = {
		label = "Gold",
		weight = 1,
		stack = true,
		close = true,
	},

	["handcuffs"] = {
		label = "Hand Cuffs",
		weight = 1,
		stack = true,
		close = true,
	},

	["icepack"] = {
		label = "Ice Pack",
		weight = 1,
		stack = true,
		close = true,
	},

	["iron"] = {
		label = "Iron",
		weight = 1,
		stack = true,
		close = true,
	},

	["marijuana"] = {
		label = "Marijuana",
		weight = 2,
		stack = true,
		close = true,
	},

	["medbag"] = {
		label = "Medical Bag",
		weight = 1,
		stack = true,
		close = true,
	},

	["medikit"] = {
		label = "Medkit",
		weight = 1,
		stack = true,
		close = true,
	},

	["morphine15"] = {
		label = "Morphine 15MG",
		weight = 1,
		stack = true,
		close = true,
	},

	["morphine30"] = {
		label = "Morphine 30MG",
		weight = 1,
		stack = true,
		close = true,
	},

	["packaged_chicken"] = {
		label = "Chicken fillet",
		weight = 1,
		stack = true,
		close = true,
	},

	["packaged_plank"] = {
		label = "Packaged wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["perc10"] = {
		label = "Percocet 10MG",
		weight = 1,
		stack = true,
		close = true,
	},

	["perc30"] = {
		label = "Percocet 30MG",
		weight = 1,
		stack = true,
		close = true,
	},

	["perc5"] = {
		label = "Percocet 5MG",
		weight = 1,
		stack = true,
		close = true,
	},

	["petrol"] = {
		label = "Oil",
		weight = 1,
		stack = true,
		close = true,
	},

	["petrol_raffin"] = {
		label = "Processed oil",
		weight = 1,
		stack = true,
		close = true,
	},

	["sedative"] = {
		label = "Sedative",
		weight = 1,
		stack = true,
		close = true,
	},

	["slaughtered_chicken"] = {
		label = "Slaughtered chicken",
		weight = 1,
		stack = true,
		close = true,
	},

	["stone"] = {
		label = "Stone",
		weight = 1,
		stack = true,
		close = true,
	},

	["suturekit"] = {
		label = "Suture Kit",
		weight = 1,
		stack = true,
		close = true,
	},

	["tracking_bracelet"] = {
		label = "Tracking Bracelet",
		weight = 1,
		stack = true,
		close = true,
	},

	["tweezers"] = {
		label = "Tweezers",
		weight = 1,
		stack = true,
		close = true,
	},

	["vic10"] = {
		label = "Vicodin 10MG",
		weight = 1,
		stack = true,
		close = true,
	},

	["vic5"] = {
		label = "Vicodin 5MG",
		weight = 1,
		stack = true,
		close = true,
	},

	["washed_stone"] = {
		label = "Washed stone",
		weight = 1,
		stack = true,
		close = true,
	},

	["wood"] = {
		label = "Wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["wool"] = {
		label = "Wool",
		weight = 1,
		stack = true,
		close = true,
	},


	['bpceramicpistol'] = {
		label = 'Ceramic Pistol Blueprint',
		weight = 1000,
		stack = false,
		client = {
			image = 'bpceramicpistol.png',
		}
	},

	['bpnavyrevolver'] = {
		label = 'bpnavyrevolver',
		weight = 500,
		stack = false,
		client = {
			image = 'bpnavyrevolver.png',
		}
	},

	["jerrycan01"] = {
		label = "Fuel Can",
		weight = 1000,
		stack = false,
	},

	["megaphone"] = {
		label = "Megaphone",
		weight = 100,
		stack = false,
	},

	['warehouse_entry'] = {
		label = 'Warehouse Entry',
		weight = 10,
		stack = false,
		client = {
			image = 'military_card.png'
		}
	},
	['warehouse_fuse'] = {
		label = 'Warehouse Fuse',
		weight = 50,
		client = {
			image = 'fuse.png'
		}
	},
}