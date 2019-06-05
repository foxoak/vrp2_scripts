--[[
Los Santos Customs V1.1 
Credits - MythicalBro
/////License/////
Do not reupload/re release any part of this script without my permission
]]
local colors = {
{name = "Preto", colorindex = 0},{name = "Preto Carbono", colorindex = 147},
{name = "Grafite", colorindex = 1},{name = "Grafite escuro", colorindex = 11},
{name = "Aço preto", colorindex = 2},{name = "Aço escuro", colorindex = 3},
{name = "Prata", colorindex = 4},{name = "Prata azulada", colorindex = 5},
{name = "Aço Laminado", colorindex = 6},{name = "Aço escuro", colorindex = 7},
{name = "Pedra Prata", colorindex = 8},{name = "Prata da meia noite", colorindex = 9},
{name = "Prata de ferro fundido", colorindex = 10},{name = "Vermelho", colorindex = 27},
{name = "Vermelho tornado", colorindex = 28},{name = "Vermelho flash", colorindex = 29},
{name = "Vermelho lava", colorindex = 150},{name = "Vermelho 4", colorindex = 30},
{name = "Vermelho 5", colorindex = 31},{name = "Vermelho 6", colorindex = 32},
{name = "Vermelho por do sol", colorindex = 33},{name = "Vermelho 7", colorindex = 34},
{name = "Vinho", colorindex = 143},{name = "Rosa", colorindex = 35},
{name = "Rosa choque", colorindex = 135},{name = "Rosa claro", colorindex = 137},
{name = "Rosa salmão", colorindex = 136},{name = "Laranja por do sol", colorindex = 36},
{name = "Laranja", colorindex = 38},{name = "Laranja brilhoso", colorindex = 138},
{name = "Ouro", colorindex = 99},{name = "Bronze", colorindex = 90},
{name = "Amarelo", colorindex = 88},{name = "Amarelo corrida", colorindex = 89},
{name = "Amarelo orvalho", colorindex = 91},{name = "Verde escuro", colorindex = 49},
{name = "Verde corrida", colorindex = 50},{name = "Verde do mar", colorindex = 51},
{name = "Verde oliva", colorindex = 52},{name = "Verde claro", colorindex = 53},
{name = "Verde gasolina", colorindex = 54},{name = "Verde limão", colorindex = 92},
{name = "Azul meia noite", colorindex = 141},
{name = "Azul galaxia", colorindex = 61},{name = "Azul escuro", colorindex = 62},
{name = "Azul topázio", colorindex = 63},{name = "Azul", colorindex = 64},
{name = "Azul marinho", colorindex = 65},{name = "Azul do turquesa", colorindex = 66},
{name = "Azul diamante", colorindex = 67},{name = "Azul nuvem", colorindex = 68},
{name = "Azul náutico", colorindex = 69},{name = "Azul corrida", colorindex = 73},
{name = "Azul ultra", colorindex = 70},{name = "Azul claro", colorindex = 74},
{name = "Marrom chocolate", colorindex = 96},{name = "Marrom 3", colorindex = 101},
{name = "Café", colorindex = 95},{name = "Capuccino", colorindex = 94},
{name = "Orvalho", colorindex = 97},{name = "Marrom oak", colorindex = 103},
{name = "Marrom conhaque", colorindex = 104},{name = "Marrom claro", colorindex = 98},
{name = "Marmore", colorindex = 100},{name = "Marrom carvalho", colorindex = 102},
{name = "Marrom médio", colorindex = 99},{name = "Marrom areia", colorindex = 105},
{name = "Marrom ", colorindex = 106},{name = "Violetta 2", colorindex = 71},
{name = "Violetta", colorindex = 72},{name = "Roxo meia noite", colorindex = 142},
{name = "Roxo claro", colorindex = 145},{name = "Creme", colorindex = 107},
{name = "Branco gelo", colorindex = 111},{name = "Branco neve", colorindex = 112}}
local metalcolors = {
{name = "Aço escovado",colorindex = 117},
{name = "Aço preto escovado",colorindex = 118},
{name = "Alumínio escovado",colorindex = 119},
{name = "Ouro puro",colorindex = 158},
{name = "Ouro escovado",colorindex = 159}
}
local mattecolors = {
{name = "Preto", colorindex = 12},
{name = "Cinza", colorindex = 13},
{name = "Cinza claro", colorindex = 14},
{name = "Branco gelo", colorindex = 131},
{name = "Azul", colorindex = 83},
{name = "Azul escuro", colorindex = 82},
{name = "Azul meia noite", colorindex = 84},
{name = "Roxo meia noite", colorindex = 149},
{name = "Púrpura", colorindex = 148},
{name = "Vermelho", colorindex = 39},
{name = "Vermelho escuro", colorindex = 40},
{name = "Laranja", colorindex = 41},
{name = "Amarelo", colorindex = 42},
{name = "Verde limão", colorindex = 55},
{name = "Verde", colorindex = 128},
{name = "Menta ", colorindex = 151},
{name = "Verde folha", colorindex = 155},
{name = "Esmeralda", colorindex = 152},
{name = "Café", colorindex = 153},
{name = "Deserto", colorindex = 154}
}



LSC_Config = {}
LSC_Config.prices = {}

--------Prices---------
LSC_Config.prices = {

------Window tint------
	windowtint = {
		{ name = "Insulfilm G 5", tint = 1, price = 1000},
		{ name = "Insulfilm G 20", tint = 2, price = 1000},
		{ name = "Insulfilm G 35", tint = 3, price = 1000},
		{ name = "Insulfilm G 50", tint = 4, price = 1000},
		{ name = "Insulfilm G 70", tint = 5, price = 1000},
	},

-------Respray--------
----Primary color---
	--Chrome 
	chrome = {
		colors = {
			{name = "Cromado", colorindex = 120}
		},
		price = 1000
	},
	--Classic 
	classic = {
		colors = colors,
		price = 200
	},
	--Matte 
	matte = {
		colors = mattecolors,
		price = 500
	},
	--Metallic 
	metallic = {
		colors = colors,
		price = 300
	},
	--Metals 
	metal = {
		colors = metalcolors,
		price = 300
	},

----Secondary color---
	--Chrome 
	chrome2 = {
		colors = {
			{name = "Cromado", colorindex = 120}
		},
		price = 1000
	},
	--Classic 
	classic2 = {
		colors = colors,
		price = 200
	},
	--Matte 
	matte2 = {
		colors = mattecolors,
		price = 500
	},
	--Metallic 
	metallic2 = {
		colors = colors,
		price = 300
	},
	--Metals 
	metal2 = {
		colors = metalcolors,
		price = 300
	},

------Neon layout------
	neonlayout = {
		{name = "Frontal,lateral e traseiro", price = 5000},
	},
	--Neon color
	neoncolor = {
		{ name = "Branco", neon = {255,255,255}, price = 1000},
		{ name = "Azul", neon = {0,0,255}, price = 1000},
		{ name = "Azul choque", neon = {0,150,255}, price = 1000},
		{ name = "Verde menta", neon = {50,255,155}, price = 1000},
		{ name = "Verde limão", neon = {0,255,0}, price = 1000},
		{ name = "Amarelo", neon = {255,255,0}, price = 1000},
		{ name = "Ouro", neon = {204,204,0}, price = 1000},
		{ name = "Laranja", neon = {255,128,0}, price = 1000},
		{ name = "Vermelho", neon = {255,0,0}, price = 1000},
		{ name = "Rosa", neon = {255,102,255}, price = 1000},
		{ name = "Rosa choque",neon = {255,0,255}, price = 1000},
		{ name = "Roxo", neon = {153,0,153}, price = 1000},
		{ name = "Marrom", neon = {139,69,19}, price = 1000},
	},
	
--------Plates---------
	plates = {
		{ name = "Estilo 1", plateindex = 0, price = 200},
		{ name = "Estilo 2", plateindex = 3, price = 200},
		{ name = "Estilo 3", plateindex = 4, price = 200},
		{ name = "Estilo 4", plateindex = 2, price = 300},
		{ name = "Estilo 5", plateindex = 1, price = 600},
	},
	
--------Wheels--------
----Wheel accessories----
	wheelaccessories = {
		{ name = "Pneu de fábrica", price = 1000},
		{ name = "Pneus customizado", price = 1250},
		{ name = "Pneu a prova de bala", price = 5000},
		{ name = "Fumaça branca",smokecolor = {254,254,254}, price = 3000},
		{ name = "Fumaça preta", smokecolor = {1,1,1}, price = 3000},
		{ name = "Fumaça azul", smokecolor = {0,150,255}, price = 3000},
		{ name = "Fumaça amarela", smokecolor = {255,255,50}, price = 3000},
		{ name = "Fumaça laranja", smokecolor = {255,153,51}, price = 3000},
		{ name = "Fumaça vermelha", smokecolor = {255,10,10}, price = 3000},
		{ name = "Fumaça verde", smokecolor = {10,255,10}, price = 3000},
		{ name = "Fumaça roxa", smokecolor = {153,10,153}, price = 3000},
		{ name = "Fumaça rosa", smokecolor = {255,102,178}, price = 3000},
		{ name = "Fumaça cinza",smokecolor = {128,128,128}, price = 3000},
	},

----Wheel color----
	wheelcolor = {
		colors = colors,
		price = 1000,
	},

----Front wheel (Bikes)----
	frontwheel = {
		{name = "De fábrica", wtype = 6, mod = -1, price = 1000},
		{name = "Speedway", wtype = 6, mod = 0, price = 1000},
		{name = "Streetspecial", wtype = 6, mod = 1, price = 1000},
		{name = "Racer", wtype = 6, mod = 2, price = 1000},
		{name = "Trackstar", wtype = 6, mod = 3, price = 1000},
		{name = "Overlord", wtype = 6, mod = 4, price = 1000},
		{name = "Trident", wtype = 6, mod = 5, price = 1000},
		{name = "Triplethreat", wtype = 6, mod = 6, price = 1000},
		{name = "Stilleto", wtype = 6, mod = 7, price = 1000},
		{name = "Wires", wtype = 6, mod = 8, price = 1000},
		{name = "Bobber", wtype = 6, mod = 9, price = 1000},
		{name = "Solidus", wtype = 6, mod = 10, price = 1000},
		{name = "Iceshield", wtype = 6, mod = 11, price = 1000},
		{name = "Loops", wtype = 6, mod = 12, price = 1000},
	},

----Back wheel (Bikes)-----
	backwheel = {
		{name = "De fábrica", wtype = 6, mod = -1, price = 1000},
		{name = "Speedway", wtype = 6, mod = 0, price = 1000},
		{name = "Streetspecial", wtype = 6, mod = 1, price = 1000},
		{name = "Racer", wtype = 6, mod = 2, price = 1000},
		{name = "Trackstar", wtype = 6, mod = 3, price = 1000},
		{name = "Overlord", wtype = 6, mod = 4, price = 1000},
		{name = "Trident", wtype = 6, mod = 5, price = 1000},
		{name = "Triplethreat", wtype = 6, mod = 6, price = 1000},
		{name = "Stilleto", wtype = 6, mod = 7, price = 1000},
		{name = "Wires", wtype = 6, mod = 8, price = 1000},
		{name = "Bobber", wtype = 6, mod = 9, price = 1000},
		{name = "Solidus", wtype = 6, mod = 10, price = 1000},
		{name = "Iceshield", wtype = 6, mod = 11, price = 1000},
		{name = "Loops", wtype = 6, mod = 12, price = 1000},
	},

----Sport wheels-----
	sportwheels = {
		{name = "De fábrica", wtype = 0, mod = -1, price = 1000},
		{name = "Inferno", wtype = 0, mod = 0, price = 1000},
		{name = "Deepfive", wtype = 0, mod = 1, price = 1000},
		{name = "Lozspeed", wtype = 0, mod = 2, price = 1000},
		{name = "Diamondcut", wtype = 0, mod = 3, price = 1000},
		{name = "Chrono", wtype = 0, mod = 4, price = 1000},
		{name = "Feroccirr", wtype = 0, mod = 5, price = 1000},
		{name = "Fiftynine", wtype = 0, mod = 6, price = 1000},
		{name = "Mercie", wtype = 0, mod = 7, price = 1000},
		{name = "Syntheticz", wtype = 0, mod = 8, price = 1000},
		{name = "Organictyped", wtype = 0, mod = 9, price = 1000},
		{name = "Endov1", wtype = 0, mod = 10, price = 1000},
		{name = "Duper7", wtype = 0, mod = 11, price = 1000},
		{name = "Uzer", wtype = 0, mod = 12, price = 1000},
		{name = "Groundride", wtype = 0, mod = 13, price = 1000},
		{name = "Spacer", wtype = 0, mod = 14, price = 1000},
		{name = "Venum", wtype = 0, mod = 15, price = 1000},
		{name = "Cosmo", wtype = 0, mod = 16, price = 1000},
		{name = "Dashvip", wtype = 0, mod = 17, price = 1000},
		{name = "Icekid", wtype = 0, mod = 18, price = 1000},
		{name = "Ruffeld", wtype = 0, mod = 19, price = 1000},
		{name = "Wangenmaster", wtype = 0, mod = 20, price = 1000},
		{name = "Superfive", wtype = 0, mod = 21, price = 1000},
		{name = "Endov2", wtype = 0, mod = 22, price = 1000},
		{name = "Slitsix", wtype = 0, mod = 23, price = 1000},
	},
-----Suv wheels------
	suvwheels = {
		{name = "De fábrica", wtype = 3, mod = -1, price = 1000},
		{name = "Vip", wtype = 3, mod = 0, price = 1000},
		{name = "Benefactor", wtype = 3, mod = 1, price = 1000},
		{name = "Cosmo", wtype = 3, mod = 2, price = 1000},
		{name = "Bippu", wtype = 3, mod = 3, price = 1000},
		{name = "Royalsix", wtype = 3, mod = 4, price = 1000},
		{name = "Fagorme", wtype = 3, mod = 5, price = 1000},
		{name = "Deluxe", wtype = 3, mod = 6, price = 1000},
		{name = "Icedout", wtype = 3, mod = 7, price = 1000},
		{name = "Cognscenti", wtype = 3, mod = 8, price = 1000},
		{name = "Lozspeedten", wtype = 3, mod = 9, price = 1000},
		{name = "Supernova", wtype = 3, mod = 10, price = 1000},
		{name = "Obeyrs", wtype = 3, mod = 11, price = 1000},
		{name = "Lozspeedballer", wtype = 3, mod = 12, price = 1000},
		{name = "Extra vaganzo", wtype = 3, mod = 13, price = 1000},
		{name = "Splitsix", wtype = 3, mod = 14, price = 1000},
		{name = "Empowered", wtype = 3, mod = 15, price = 1000},
		{name = "Sunrise", wtype = 3, mod = 16, price = 1000},
		{name = "Dashvip", wtype = 3, mod = 17, price = 1000},
		{name = "Cutter", wtype = 3, mod = 18, price = 1000},
	},
-----Offroad wheels-----
	offroadwheels = {
		{name = "De fábrica", wtype = 4, mod = -1, price = 1000},
		{name = "Raider", wtype = 4, mod = 0, price = 1000},
		{name = "Mudslinger", wtype = 4, modtype = 23, wtype = 4, mod = 1, price = 1000},
		{name = "Nevis", wtype = 4, mod = 2, price = 1000},
		{name = "Cairngorm", wtype = 4, mod = 3, price = 1000},
		{name = "Amazon", wtype = 4, mod = 4, price = 1000},
		{name = "Challenger", wtype = 4, mod = 5, price = 1000},
		{name = "Dunebasher", wtype = 4, mod = 6, price = 1000},
		{name = "Fivestar", wtype = 4, mod = 7, price = 1000},
		{name = "Rockcrawler", wtype = 4, mod = 8, price = 1000},
		{name = "Milspecsteelie", wtype = 4, mod = 9, price = 1000},
	},
-----Tuner wheels------
	tunerwheels = {
		{name = "De fábrica", wtype = 5, mod = -1, price = 1000},
		{name = "Cosmo", wtype = 5, mod = 0, price = 1000},
		{name = "Supermesh", wtype = 5, mod = 1, price = 1000},
		{name = "Outsider", wtype = 5, mod = 2, price = 1000},
		{name = "Rollas", wtype = 5, mod = 3, price = 1000},
		{name = "Driffmeister", wtype = 5, mod = 4, price = 1000},
		{name = "Slicer", wtype = 5, mod = 5, price = 1000},
		{name = "Elquatro", wtype = 5, mod = 6, price = 1000},
		{name = "Dubbed", wtype = 5, mod = 7, price = 1000},
		{name = "Fivestar", wtype = 5, mod = 8, price = 1000},
		{name = "Slideways", wtype = 5, mod = 9, price = 1000},
		{name = "Apex", wtype = 5, mod = 10, price = 1000},
		{name = "Stancedeg", wtype = 5, mod = 11, price = 1000},
		{name = "Countersteer", wtype = 5, mod = 12, price = 1000},
		{name = "Endov1", wtype = 5, mod = 13, price = 1000},
		{name = "Endov2dish", wtype = 5, mod = 14, price = 1000},
		{name = "Guppez", wtype = 5, mod = 15, price = 1000},
		{name = "Chokadori", wtype = 5, mod = 16, price = 1000},
		{name = "Chicane", wtype = 5, mod = 17, price = 1000},
		{name = "Saisoku", wtype = 5, mod = 18, price = 1000},
		{name = "Dishedeight", wtype = 5, mod = 19, price = 1000},
		{name = "Fujiwara", wtype = 5, mod = 20, price = 1000},
		{name = "Zokusha", wtype = 5, mod = 21, price = 1000},
		{name = "Battlevill", wtype = 5, mod = 22, price = 1000},
		{name = "Rallymaster", wtype = 5, mod = 23, price = 1000},
	},
-----Highend wheels------
	highendwheels = {
		{name = "De fábrica", wtype = 7, mod = -1, price = 1000},
		{name = "Shadow", wtype = 7, mod = 0, price = 1000},
		{name = "Hyper", wtype = 7, mod = 1, price = 1000},
		{name = "Blade", wtype = 7, mod = 2, price = 1000},
		{name = "Diamond", wtype = 7, mod = 3, price = 1000},
		{name = "Supagee", wtype = 7, mod = 4, price = 1000},
		{name = "Chromaticz", wtype = 7, mod = 5, price = 1000},
		{name = "Merciechlip", wtype = 7, mod = 6, price = 1000},
		{name = "Obeyrs", wtype = 7, mod = 7, price = 1000},
		{name = "Gtchrome", wtype = 7, mod = 8, price = 1000},
		{name = "Cheetahr", wtype = 7, mod = 9, price = 1000},
		{name = "Solar", wtype = 7, mod = 10, price = 1000},
		{name = "Splitten", wtype = 7, mod = 11, price = 1000},
		{name = "Dashvip", wtype = 7, mod = 12, price = 1000},
		{name = "Lozspeedten", wtype = 7, mod = 13, price = 1000},
		{name = "Carboninferno", wtype = 7, mod = 14, price = 1000},
		{name = "Carbonshadow", wtype = 7, mod = 15, price = 1000},
		{name = "Carbonz", wtype = 7, mod = 16, price = 1000},
		{name = "Carbonsolar", wtype = 7, mod = 17, price = 1000},
		{name = "Carboncheetahr", wtype = 7, mod = 18, price = 1000},
		{name = "Carbonsracer", wtype = 7, mod = 19, price = 1000},
	},
-----Lowrider wheels------
	lowriderwheels = {
		{name = "De fábrica", wtype = 2, mod = -1, price = 1000},
		{name = "Flare", wtype = 2, mod = 0, price = 1000},
		{name = "Wired", wtype = 2, mod = 1, price = 1000},
		{name = "Triplegolds", wtype = 2, mod = 2, price = 1000},
		{name = "Bigworm", wtype = 2, mod = 3, price = 1000},
		{name = "Sevenfives", wtype = 2, mod = 4, price = 1000},
		{name = "Splitsix", wtype = 2, mod = 5, price = 1000},
		{name = "Freshmesh", wtype = 2, mod = 6, price = 1000},
		{name = "Leadsled", wtype = 2, mod = 7, price = 1000},
		{name = "Turbine", wtype = 2, mod = 8, price = 1000},
		{name = "Superfin", wtype = 2, mod = 9, price = 1000},
		{name = "Classicrod", wtype = 2, mod = 10, price = 1000},
		{name = "Dollar", wtype = 2, mod = 11, price = 1000},
		{name = "Dukes", wtype = 2, mod = 12, price = 1000},
		{name = "Lowfive", wtype = 2, mod = 13, price = 1000},
		{name = "Gooch", wtype = 2, mod = 14, price = 1000},
	},
-----Muscle wheels-----
	musclewheels = {
		{name = "De fábrica", wtype = 1, mod = -1, price = 1000},
		{name = "Classicfive", wtype = 1, mod = 0, price = 1000},
		{name = "Dukes", wtype = 1, mod = 1, price = 1000},
		{name = "Musclefreak", wtype = 1, mod = 2, price = 1000},
		{name = "Kracka", wtype = 1, mod = 3, price = 1000},
		{name = "Azrea", wtype = 1, mod = 4, price = 1000},
		{name = "Mecha", wtype = 1, mod = 5, price = 1000},
		{name = "Blacktop", wtype = 1, mod = 6, price = 1000},
		{name = "Dragspl", wtype = 1, mod = 7, price = 1000},
		{name = "Revolver", wtype = 1, mod = 8, price = 1000},
		{name = "Classicrod", wtype = 1, mod = 9, price = 1000},
		{name = "Spooner", wtype = 1, mod = 10, price = 1000},
		{name = "Fivestar", wtype = 1, mod = 11, price = 1000},
		{name = "Oldschool", wtype = 1, mod = 12, price = 1000},
		{name = "Eljefe", wtype = 1, mod = 13, price = 1000},
		{name = "Dodman", wtype = 1, mod = 14, price = 1000},
		{name = "Sixgun", wtype = 1, mod = 15, price = 1000},
		{name = "Mercenary", wtype = 1, mod = 16, price = 1000},
	},
	
---------Trim color--------
	trim = {
		colors = colors,
		price = 1000
	},
	
----------Mods-----------
	mods = {
	
----------Liveries--------
	[48] = {
		startprice = 15000,
		increaseby = 2500
	},
	
----------Windows--------
	[46] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Tank--------
	[45] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Trim--------
	[44] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Aerials--------
	[43] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Arch cover--------
	[42] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Struts--------
	[41] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Air filter--------
	[40] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Engine block--------
	[39] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Hydraulics--------
	[38] = {
		startprice = 15000,
		increaseby = 2500
	},
	
----------Trunk--------
	[37] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Speakers--------
	[36] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Plaques--------
	[35] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Shift leavers--------
	[34] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Steeringwheel--------
	[33] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Seats--------
	[32] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Door speaker--------
	[31] = {
		startprice = 5000,
		increaseby = 1250
	},

----------Dial--------
	[30] = {
		startprice = 5000,
		increaseby = 1250
	},
----------Dashboard--------
	[29] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Ornaments--------
	[28] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Trim--------
	[27] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Vanity plates--------
	[26] = {
		startprice = 5000,
		increaseby = 1250
	},
	
----------Plate holder--------
	[25] = {
		startprice = 5000,
		increaseby = 1250
	},
	
---------Headlights---------
	[22] = {
		{name = "Farol de fábrica", mod = 0, price = 0},
		{name = "Farol Xenon ", mod = 1, price = 1625},
	},
	
----------Turbo---------
	[18] = {
		{ name = "None", mod = 0, price = 0},
		{ name = "Turbo", mod = 1, price = 15000},
	},
	
-----------Armor-------------
	[16] = {
		{name = "Blindagem 20%",modtype = 16, mod = 0, price = 2500},
		{name = "Blindagem 40%",modtype = 16, mod = 1, price = 5000},
		{name = "Blindagem 60%",modtype = 16, mod = 2, price = 7500},
		{name = "Blindagem 80%",modtype = 16, mod = 3, price = 10000},
		{name = "Blindagem 100%",modtype = 16, mod = 4, price = 12500},
	},

---------Suspension-----------
	[15] = {
		{name = "Suspensão rebaixada",mod = 0, price = 1000},
		{name = "Suspensão de rua",mod = 1, price = 2000},
		{name = "Suspensão esportida",mod = 2, price = 3500},
		{name = "Suspensão de corrida",mod = 3, price = 4000},
	},

-----------Horn----------
	[14] = {
		{name = "Buzina de caminhão", mod = 0, price = 1625},
		{name = "Buzina de policia", mod = 1, price = 4062},
		{name = "Buzina de palhaço", mod = 2, price = 6500},
		{name = "Buzina musical 1", mod = 3, price = 11375},
		{name = "Buzina musical 2", mod = 4, price = 11375},
		{name = "Buzina musical 3", mod = 5, price = 11375},
		{name = "Buzina musical 4", mod = 6, price = 11375},
		{name = "Buzina musical 5", mod = 7, price = 11375},
		{name = "Buzina triste", mod = 8, price = 11375},
		{name = "Buzina classica 1", mod = 9, price = 11375},
		{name = "Buzina classica 2", mod = 10, price = 11375},
		{name = "Buzina classica 3", mod = 11, price = 11375},
		{name = "Buzina classica 4", mod = 12, price = 11375},
		{name = "Buzina classica 5", mod = 13, price = 11375},
		{name = "Buzina classica 6", mod = 14, price = 11375},
		{name = "Buzina classica 7", mod = 15, price = 11375},
		{name = "Buzina escala em dó", mod = 16, price = 11375},
		{name = "Buzina escala em ré", mod = 17, price = 11375},
		{name = "Buzina escala em mi", mod = 18, price = 11375},
		{name = "Buzina escala em fa", mod = 19, price = 11375},
		{name = "Buzina escala em sol", mod = 20, price = 11375},
		{name = "Buzina escala em lá", mod = 21, price = 11375},
		{name = "Buzina escala em si", mod = 22, price = 11375},
		{name = "Buzina escala em dó 2", mod = 23, price = 11375},
		{name = "Buzina jazz 1", mod = 25, price = 11375},
		{name = "Buzina jazz 1", mod = 26, price = 11375},
		{name = "Buzina jazz 1", mod = 27, price = 11375},
		{name = "Buzina jazz em loop", mod = 28, price = 11375},
		{name = "Buzina Starspangban 1", mod = 29, price = 11375},
		{name = "Buzina Starspangban 2", mod = 30, price = 11375},
		{name = "Buzina Starspangban 3", mod = 31, price = 11375},
		{name = "Buzina Starspangban 4", mod = 32, price = 11375},
		{name = "Buzina loop clássico 1", mod = 33, price = 11375},
		{name = "Buzina loop clássico 1", mod = 34, price = 11375},
		{name = "Buzina loop clássico 1", mod = 35, price = 11375},
	},

----------Transmission---------
	[13] = {
		{name = "Transmissão de fábrica", mod = 0, price = 10000},
		{name = "Transmissão esportivo", mod = 1, price = 12500},
		{name = "Transmissão de corrida", mod = 2, price = 15000},
	},
	
-----------Brakes-------------
	[12] = {
		{name = "Freios de fábrica", mod = 0, price = 6500},
		{name = "Freios esportivo", mod = 1, price = 8775},
		{name = "Freios de corrida", mod = 2, price = 11375},
	},
	
------------Engine----------
	[11] = {
		{name = "Motor de fábrica", mod = 0, price = 4500},
		{name = "Motor esportivo", mod = 1, price = 8000},
		{name = "Motor de corrida", mod = 2, price = 10500},
	},
	
-------------Roof----------
	[10] = {
		startprice = 1250,
		increaseby = 400
	},
	
------------Fenders---------
	[8] = {
		startprice = 1500,
		increaseby = 400
	},
	
------------Hood----------
	[7] = {
		startprice = 1500,
		increaseby = 400
	},
	
----------Grille----------
	[6] = {
		startprice = 1250,
		increaseby = 400
	},
	
----------Roll cage----------
	[5] = {
		startprice = 1250,
		increaseby = 400
	},
	
----------Exhaust----------
	[4] = {
		startprice = 1000,
		increaseby = 400
	},
	
----------Skirts----------
	[3] = {
		startprice = 1250,
		increaseby = 400
	},
	
-----------Rear bumpers----------
	[2] = {
		startprice = 2500,
		increaseby = 500
	},
	
----------Front bumpers----------
	[1] = {
		startprice = 2500,
		increaseby = 500
	},
	
----------Spoiler----------
	[0] = {
		startprice = 2500,
		increaseby = 400
	},
	}
	
}

------Model Blacklist--------
--Does'nt allow specific vehicles to be upgraded
LSC_Config.ModelBlacklist = {
	"police",
	"police2",
	"police3",
	"paliocv",
	"am",
	"blazerr",
	"fbi2",
	"sheriff2",
	"sheriff",
	"CHARGERPF",
	"sw4samu",
	"Samu",
	"Samu2",
	"policeb",
	"ur",
	"trash",
	"tiptruck2",
	"mule",
	"boxville2",
	"boxville4",
	"flatbed",
	"faggio2",
	"fordcargo",
	"firetruk",
	"lguard",
	"ambulance",
	"stockade",
	"sw4rota",
	"trailrota",
	"hwaycar5",
	"riot",
	"tigerrocam",
	"rocammoto",
	"trailft",
	"blazerft",
	"ft",
	"globocar",
	"palio",
	"spin",
	"space",
	"s10",
	"policerenault",
	"police4",
	"pbus",
	"blazerprf",
	"frontier",
	"fluence",
	"sheriff",
}

--Sets if garage will be locked if someone is inside it already
LSC_Config.lock = false

--Enable/disable old entering way
LSC_Config.oldenter = false

--Menu settings
LSC_Config.menu = {

-------Controls--------
	controls = {
		menu_up = 27,
		menu_down = 173,
		menu_left = 174,
		menu_right = 175,
		menu_select = 201,
		menu_back = 177
	},

-------Menu position-----
	--Possible positions:
	--Left
	--Right
	--Custom position, example: position = {x = 0.2, y = 0.2}
	position = "left",

-------Menu theme--------
	--Possible themes: light, darkred, bluish, greenish
	--Custom example:
	--[[theme = {
		text_color = { r = 255,g = 255, b = 255, a = 255},
		bg_color = { r = 0,g = 0, b = 0, a = 155},
		--Colors when button is selected
		stext_color = { r = 0,g = 0, b = 0, a = 255},
		sbg_color = { r = 255,g = 255, b = 0, a = 200},
	},]]
	theme = "light",
	
--------Max buttons------
	--Default: 10
	maxbuttons = 10,

-------Size---------
	--[[
	Default:
	width = 0.24
	height = 0.36
	]]
	width = 0.24,
	height = 0.36

}
