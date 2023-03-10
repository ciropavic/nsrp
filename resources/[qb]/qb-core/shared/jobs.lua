QBShared = QBShared or {}
QBShared.ForceJobDefaultDutyAtLogin = true -- true: Force duty state to jobdefaultDuty | false: set duty state from database last saved
QBShared.Jobs = {
	['unemployed'] = {
		label = 'Civilian',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Freelancer',
                payment = 10
            },
        },
	},
	['police'] = {
		label = 'Law Enforcement',
        type = "leo",
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'LSPD - Academy',
                payment = 250
            },
			['1'] = {
                name = 'LSPD - Phase 3',
                payment = 500
            },
			['2'] = {
                name = 'LSPD - Officer',
                payment = 750
            },
			['3'] = {
                name = 'LSPD - Senior Officer',
                payment = 1000
            },
			['4'] = {
                name = 'LSPD - Commander',
                payment = 1250
            },
            ['5'] = {
                name = 'LSPD - Assistant Chief',
                isboss = true,
                payment = 1750
            },
            ['6'] = {
                name = 'LSPD - Chief of Police',
                isboss = true,
                payment = 2000
            },
            -- BCSO DEPT
            ['7'] = {
                name = 'BCSO - Deputy',
                payment = 1250
            },
            ['8'] = {
                name = 'BCSO - Captain',
                payment = 1500
            },
            ['9'] = {
                name = 'BCSO - Chief Deputy',
                payment = 1650
            },
            ['10'] = {
                name = 'BCSO - Undersheirff',
                isboss = true,
                payment = 1750
            },
            ['11'] = {
                name = 'BCSO - Sheriff',
                isboss = true,
                payment = 2000
            },
            -- California Highway Patrol
            ['12'] = {
                name = 'CHP - Park Ranger',
                payment = 1750
            },
            ['13'] = {
                name = 'CHP - Highway Patrol',
                payment = 1900
            },
            ['14'] = {
                name = 'CHP - Trooper',
                payment = 2250
            },
            ['15'] = {
                name = 'CHP - State Guard',
                isboss = true,
                payment = 2500
            },
            ['16'] = {
                name = 'CHP - Commissioner',
                isboss = true,
                payment = 3000
            },
        -- Undercover Agent
            ['17'] = {
                name = 'UCA - Agent',
                payment = 4000
            },
            ['18'] = {
                name = 'UCA - Military',
                payment = 4000
            },
        },
    },
	['ambulance'] = {
		label = 'EMS',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Trainee',
                payment = 400
            },
			['1'] = {
                name = 'EMT',
                payment = 600
            },
			['2'] = {
                name = 'Paramedic',
                payment = 800
            },
			['3'] = {
                name = 'Critical Care Paramedic',
                payment = 1000
            },
			['4'] = {
                name = 'HEMS - Heli',
                payment = 1100
            },
            ['5'] = {
                name = 'Special Oparations Paramrdic',
                payment = 1200
            },
-- In city leadership-->
            ['6'] = {
                name = 'Lieutenant',
                payment = 1500
            },
-- Department Heads -->
            ['7'] = {
                name = 'Superintendent',
                isboss = true,
                payment = 1800
            },
            ['8'] = {
                name = 'Chief Superintendent',
                isboss = true,
                payment = 2000
            },
            ['9'] = {
                name = 'Commissoner',
                isboss = true, 
                payment = 2500
            },
            ['10'] = {
                name = 'Director',
                isboss = true,
                payment = 3000
            }
        },
	},
	['realestate'] = {
		label = 'Real Estate',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 50
            },
			['1'] = {
                name = 'House Sales',
                payment = 75
            },
			['2'] = {
                name = 'Business Sales',
                payment = 100
            },
			['3'] = {
                name = 'Broker',
                payment = 125
            },
			['4'] = {
                name = 'Manager',
				isboss = true,
                payment = 150
            },
        },
	},
	['taxi'] = {
		label = 'Taxi',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 50
            },
			['1'] = {
                name = 'Driver',
                payment = 75
            },
			['2'] = {
                name = 'Event Driver',
                payment = 100
            },
			['3'] = {
                name = 'Sales',
                payment = 125
            },
			['4'] = {
                name = 'Manager',
				isboss = true,
                payment = 150
            },
        },
	},
     ['bus'] = {
		label = 'Bus',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Driver',
                payment = 50
            },
		},
	},
	['cardealer'] = {
		label = 'Vehicle Dealer',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 50
            },
			['1'] = {
                name = 'Showroom Sales',
                payment = 75
            },
			['2'] = {
                name = 'Business Sales',
                payment = 100
            },
			['3'] = {
                name = 'Finance',
                payment = 125
            },
			['4'] = {
                name = 'Manager',
				isboss = true,
                payment = 150
            },
        },
	},
	['mechanic'] = {
		label = 'Mechanic',
        type = "mechanic",
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Recruit',
                payment = 50
            },
			['1'] = {
                name = 'Novice',
                payment = 75
            },
			['2'] = {
                name = 'Experienced',
                payment = 100
            },
			['3'] = {
                name = 'Advanced',
                payment = 125
            },
			['4'] = {
                name = 'Manager',
				isboss = true,
                payment = 150
            },
        },
	},
	['judge'] = {
		label = 'Honorary',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Judge',
                payment = 100
            },
        },
	},
	['lawyer'] = {
		label = 'Law Firm',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Associate',
                payment = 50
            },
        },
	},
	['reporter'] = {
		label = 'Reporter',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Journalist',
                payment = 50
            },
        },
	},
	['trucker'] = {
		label = 'Trucker',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Driver',
                payment = 50
            },
        },
	},
	['tow'] = {
		label = 'Towing',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Driver',
                payment = 50
            },
        },
	},
	['garbage'] = {
		label = 'Garbage',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Collector',
                payment = 50
            },
        },
	},
	['vineyard'] = {
		label = 'Vineyard',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Picker',
                payment = 50
            },
        },
	},
	['hotdog'] = {
		label = 'Hotdog',
		defaultDuty = true,
		offDutyPay = false,
		grades = {
            ['0'] = {
                name = 'Sales',
                payment = 50
            },
        },
	},
}
