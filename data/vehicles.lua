return {
	-- 0 = vehicle has no storage
	-- 1 = vehicle has no trunk storage
	-- 2 = vehicle has no glovebox storage
	-- 3 = vehicle trunk is in hood/front

	Storage = {
		[`wchair`] = 0,
		[`sled`] = 0,
	},

	-- glovebox = { slots, maxWeight }

	glovebox = {
		[0] = {4, 50000},		-- Compact
		[1] = {4, 50000},		-- Sedan
		[2] = {4, 50000},		-- SUV
		[3] = {4, 50000},		-- Coupe
		[4] = {4, 50000},		-- Muscle
		[5] = {4, 50000},		-- Sports Classic
		[6] = {4, 50000},		-- Sports
		[7] = {2, 50000},		-- Super
		[8] = {0, 5000},		-- Motorcycle
		[9] = {4, 50000},		-- Offroad
		[10] = {4, 50000},		-- Industrial
		[11] = {4, 50000},		-- Utility
		[12] = {4, 50000},		-- Van
		[13] = {0, 5000},		-- Bike
		[14] = {4, 50000},		-- Boat
		[15] = {4, 50000},		-- Helicopter
		[16] = {4, 50000},		-- Plane
		[17] = {4, 50000},		-- Service
		[18] = {4, 50000},		-- Emergency
		[19] = {4, 50000},		-- Military
		[20] = {4, 50000},		-- Commercial
		[21] = {4, 50000},		-- Train

		models = {
			[`verus`] = {1, 5000},
			[`airtug`] = {1, 5000},
			[`caddy`] = {1, 5000},
			[`caddy2`] = {1, 5000},
			[`caddy3`] = {1, 5000},
			[`docktug`] = {1, 5000},
			[`forklift`] = {1, 5000},
			[`ripley`] = {1, 5000},
			[`tractor`] = {1, 5000},
			[`tractor2`] = {1, 5000},
			[`blazer`] = {1, 5000},
			[`blazer2`] = {1, 5000},
			[`blazer3`] = {1, 5000},
			[`blazer4`] = {1, 5000},
			[`blazer5`] = {1, 5000},
			[`outlaw`] = {1, 5000},

			[`guardian`] = {5, 50000},

			[`onx_polsand`] = {4, 50000},
			[`onx_polsandh`] = {4, 50000},
			[`onx_polsandsc`] = {4, 50000},
			[`onx_polsandxl`] = {4, 50000},
			[`onx_polbison`] = {4, 50000},
			[`onx_polbison2`] = {4, 50000},
			[`onx_polbison3`] = {4, 50000},
			[`onx_polbison4`] = {4, 50000},
			[`onx_polsandk`] = {4, 50000},
			[`onx_polsandk2`] = {4, 50000},
			[`onx_polsandk3`] = {4, 50000},
			[`onx_polsandk4`] = {4, 50000},
			[`onx_polsandk5`] = {4, 50000},
			[`onx_polsandk6`] = {4, 50000},

			[`gbpolterrorizer`] = {8, 500000},
		},
	},

	-- trunk = { slots, maxWeight }

	trunk = {
		[0] = {16, 110000},		-- Compact
		[1] = {20, 300000},		-- Sedan
		[2] = {28, 500000},		-- SUV
		[3] = {16, 110000},		-- Coupe
		[4] = {20, 200000},		-- Muscle
		[5] = {20, 200000},		-- Sports Classic
		[6] = {20, 200000},		-- Sports
		[7] = {8, 60000},		-- Super
		[8] = {4, 20000},		-- Motorcycle
		[9] = {28, 500000},		-- Offroad
		[10] = {36, 1200000},	-- Industrial
		[11] = {32, 500000},	-- Utility
		[12] = {36, 800000},	-- Van
		[13] = {1, 5000},		-- Bike
		[14] = {24, 400000},	-- Boat
		[15] = {16, 200000},	-- Helicopter
		[16] = {24, 300000},	-- Plane
		[17] = {36, 600000},	-- Service
		[18] = {20, 300000},	-- Emergency
		[19] = {36, 200000},	-- Military
		[20] = {36, 1200000},	-- Commercial
		[21] = {100, 1000000},	-- Train

		models = {
			[`taxi`] = {20, 300000},
			[`moonbeam`] = {36, 500000},
			[`flatbed`] = {20, 300000},
			[`rubble`] = {20, 300000},
			[`mixer`] = {20, 300000},
			[`mixer2`] = {20, 300000},
			[`tiptruck`] = {20, 300000},
			[`tiptruck2`] = {20, 300000},
			[`mule`] = {20, 300000},
			[`mule2`] = {20, 300000},
			[`hauler`] = {20, 300000},
			[`packer`] = {20, 300000},
			[`phantom`] = {20, 300000},
			[`biff`] = {20, 300000},

			[`trash`] = {20, 100000},
			[`stockade`] = {20, 50000},

			[`verus`] = {4, 20000},
			[`airtug`] = {4, 20000},
			[`caddy`] = {4, 20000},
			[`caddy2`] = {4, 20000},
			[`caddy3`] = {4, 20000},
			[`docktug`] = {4, 20000},
			[`forklift`] = {4, 20000},
			[`ripley`] = {4, 20000},
			[`tractor`] = {4, 20000},
			[`tractor2`] = {4, 20000},
			[`blazer`] = {4, 20000},
			[`blazer2`] = {4, 20000},
			[`blazer3`] = {4, 20000},
			[`blazer4`] = {4, 20000},
			[`blazer5`] = {4, 20000},
			[`outlaw`] = {4, 20000},

			[`guardian`] = {28, 500000},

			[`onx_polsand`] = {30, 600000},
			[`onx_polsandh`] = {30, 600000},
			[`onx_polsandsc`] = {30, 600000},
			[`onx_polsandxl`] = {30, 600000},
			[`onx_polbison`] = {30, 600000},
			[`onx_polbison2`] = {30, 600000},
			[`onx_polbison3`] = {30, 600000},
			[`onx_polbison4`] = {30, 600000},
			[`onx_polsandk`] = {30, 600000},
			[`onx_polsandk2`] = {30, 600000},
			[`onx_polsandk3`] = {30, 600000},
			[`onx_polsandk4`] = {30, 600000},
			[`onx_polsandk5`] = {30, 600000},
			[`onx_polsandk6`] = {30, 600000},

			[`gbpolterrorizer`] = {200, 10000000},
		},
	}
}