/*
[
	[1943.007,2312.045,0],	// _pos_spawn

	EAST,	// _side_bot

	["CPC_ME_O_KAM_soldier_Medic", // _arry_class_name_bot
"CPC_ME_O_KAM_soldier_l1a1",
"CPC_ME_O_KAM_soldier_AA",
"CPC_ME_O_KAM_soldier_TL",
"CPC_ME_O_KAM_soldier_AT",
"CPC_ME_O_KAM_soldier_AR",
"CPC_ME_O_KAM_soldier_LAT"],

	["VTN_TOYOTA_KADDB",	// _arry_class_name_vehicle_track
"VTN_TOYOTA_KADDB_NSVS",
"CPC_ME_O_KAM_uaz_ags"],

	["CPC_ME_O_KAM_BRDM2", // _arry_class_name_vehicle
"CPC_ME_O_KAM_BTR70",
"CPC_ME_O_KAM_BMP1",
"CPC_ME_O_KAM_T72B"],

	["CPC_ME_O_KAM_ZSU",	// _arry_class_name_PVO
"CPC_ME_O_KAM_ural_Zu23"],

	["CPC_ME_O_KAM_uh1h_gunship", // _arry_class_name_heli
"CPC_ME_O_KAM_Mi24D_Early"],

	[
		"CPC_ME_O_KAM_DSHKM",	// _arry_class_name_statica
"CPC_ME_O_KAM_ZU23",
"CPC_ME_O_KAM_2b14_82mm",
"CPC_ME_O_KAM_Igla_AA_pod"],

	300, // _radius_deploy_statica

	3, // _count_stacika

	2,	// _count_vehicle_track

	2,	// _count_vehicle

	2,	// _count_vehicle_pvo

	1,	//	_count_vehicle_heli

	1,	// _count_patrul_bot_grup

	1,	//	_count_bot_in_grup

	30,	// _chanse_spawn_in_bilding (from 0 to 100)

	2000, // _radius_activation

	300,	// _radius_patroul_bot

	500,	// _radius_deploy_car_vehicle

	600,	// _radius_patroul_bot_vehicle

	1000,	// _radius_patroul_bot_heli

	true	// _delete_when_player_not_present

] execVM "spawn_enemy_bot_area.sqf";

*/

																		// принимаю парметры

params [
	"_pos_spawn",
	"_side_bot", 
	"_arry_class_name_bot",
	"_arry_class_name_vehicle_track",
	"_arry_class_name_vehicle",
	"_arry_class_name_PVO",
	"_arry_class_name_heli",
	"_arry_class_name_statica",
	"_radius_deploy_statica",
	"_count_stacika",
	"_count_vehicle_track",
	"_count_vehicle",
	"_count_vehicle_pvo",
	"_count_vehicle_heli",
	"_count_patrul_bot_grup",
	"_count_bot_in_grup",
	"_chanse_spawn_in_bilding",
	"_radius_activation",
	"_radius_patroul_bot",
	"_radius_deploy_car_vehicle",
	"_radius_patroul_bot_vehicle",
	"_radius_patroul_bot_heli",
	"_delete_when_player_not_present"
];


																		// жду появления игрока

waitUntil{
sleep 5;
_player_in_area = allPlayers inAreaArray [_pos_spawn, _radius_activation, _radius_activation, 0, false];
!isNil {_player_in_area select 0}
};							

																		// создаю группы патруля

_arry_group_bot = []; // общий масив который будет содержать все юниты которые будут созданы

for "_i" from 0 to _count_patrul_bot_grup do 
{

private _group = createGroup [_side_bot, true];


// создаю юниты внутри групп

for "_i" from 0 to _count_bot_in_grup do 
{
	_unit = _group createUnit [selectRandom _arry_class_name_bot, _pos_spawn, [], 0, "FORM"];

	sleep 0.5;

	_arry_group_bot pushBack _unit;

	};

[_group, _pos_spawn, _radius_patroul_bot] call bis_fnc_taskPatrol;



sleep 1;

};


																	// создаю статику

for "_i" from 0 to _count_stacika do 
{

	// поиск позицый
	private _pos_from_statica = [_pos_spawn, 10, 300, 5, 0, 0.4, 0] call BIS_fnc_findSafePos;
	// спаун статики
	_static_weapon = [_pos_from_statica, 180, selectRandom _arry_class_name_statica, _side_bot] call BIS_fnc_spawnVehicle;
	// спаун мешков с песком вокруг

_objectsArray = [
	["Land_BagFence_Short_F",[-1.99707,-1.44775,-9.91821e-005],232.961,1,0,[0,0],"","",true,false], 
	["Land_BagFence_Short_F",[1.63672,-1.85156,-0.000999451],322.006,1,0,[0,0],"","",true,false], 
	["Land_BagFence_Round_F",[-2.84131,0.419922,-0.00130463],95.2003,1,0,[0,-0],"","",true,false], 
	["Land_BagFence_Round_F",[-0.348145,-2.89111,-0.00130463],4.9125,1,0,[0,0],"","",true,false], 
	["Land_BagFence_Short_F",[-1.3501,2.22363,-0.000999451],318.403,1,0,[0,0],"","",true,false], 
	["Land_BagFence_Round_F",[3.10596,-0.118164,-0.00130463],274.818,1,0,[0,0],"","",true,false], 
	["Land_BagFence_Round_F",[0.509766,3.41699,-0.00130463],179.666,1,0,[0,-0],"","",true,false]
];
[getPos (_static_weapon select 0), 0, _objectsArray, 0] call BIS_fnc_objectsMapper;

	_arry_group_bot pushBack (_static_weapon select 0);
	_arry_group_bot pushBack (_static_weapon select 1);
	sleep 0.5;
};


																	// Создаю машины


for "_i" from 0 to _count_vehicle_track do 
{

	// поиск позицый
	private _pos_from_vehicle_track = [_pos_spawn, 10, _radius_deploy_car_vehicle, 6, 0, 0.5, 0] call BIS_fnc_findSafePos;
	// спаун статики
	_vehecle_track = [_pos_from_vehicle_track, 180, selectRandom _arry_class_name_vehicle_track, _side_bot] call BIS_fnc_spawnVehicle;
	// задать патруль технике
	[_vehecle_track select 2, _pos_spawn, _radius_patroul_bot_vehicle] call bis_fnc_taskPatrol;
	_arry_group_bot pushBack (_vehecle_track select 0);
	_arry_group_bot pushBack (_vehecle_track select 1);
	sleep 0.5;

};


																	// Создаю бронетехнику


for "_i" from 0 to _count_vehicle do 
{

	// поиск позицый
	private _pos_from_vehicle = [_pos_spawn, 10, _radius_deploy_car_vehicle, 10, 0, 0.5, 0] call BIS_fnc_findSafePos;
	// спаун статики
	_vehecle = [_pos_from_vehicle, 180, selectRandom _arry_class_name_vehicle, _side_bot] call BIS_fnc_spawnVehicle;
	// задать патруль технике
	[_vehecle select 2, _pos_spawn, _radius_patroul_bot_vehicle] call bis_fnc_taskPatrol;
	_arry_group_bot pushBack (_vehecle select 0);
	_arry_group_bot pushBack (_vehecle select 1);
	sleep 0.5;

};



																	// Создаю зенитки

for "_i" from 0 to _count_vehicle_pvo do 
{

	// поиск позицый
	private _pos_from_vehicle_pvo = [_pos_spawn, 10, _radius_deploy_car_vehicle, 8, 0, 0.5, 0] call BIS_fnc_findSafePos;
	// спаун статики
	_vehecle_pvo = [_pos_from_vehicle_pvo, 180, selectRandom _arry_class_name_PVO, _side_bot] call BIS_fnc_spawnVehicle;
	// задать патруль технике
	[_vehecle_pvo select 2, _pos_spawn, _radius_patroul_bot] call bis_fnc_taskPatrol;
	_arry_group_bot pushBack (_vehecle_pvo select 0);
	_arry_group_bot pushBack (_vehecle_pvo select 1);
	sleep 0.5;
};




																	// Создаю вертолет


for "_i" from 0 to _count_vehicle_heli do 
{
	_pos_spawn_x = (_pos_spawn select 0) + selectRandom[100, 80, 60, 40, 20] + random 100;
	_pos_spawn_y = (_pos_spawn select 1) + selectRandom[100, 80, 60, 40, 20] + random 100;
	// спаун статики
	_vehecle_heli = [[_pos_spawn_x, _pos_spawn_y, _pos_spawn select 2], 180, selectRandom _arry_class_name_heli, _side_bot] call BIS_fnc_spawnVehicle;
	// задать патруль технике
	[_vehecle_heli select 2, _pos_spawn, _radius_patroul_bot] call bis_fnc_taskPatrol;
	_arry_group_bot pushBack (_vehecle_heli select 0);
	_arry_group_bot pushBack (_vehecle_heli select 1);
	sleep 0.5;
};


																		// создаю группы внутри зданий(на крышах)

// создаю группу

private _group_bot_in_bilding = createGroup [_side_bot, true];

// поиск зданий
private _arry_bilding_from_bot = nearestObjects [_pos_spawn, ["house"], _radius_patroul_bot];

// подсчет сколько найдено задний
private _count_bliding = count _arry_bilding_from_bot - 1;

// если в здании есть позицыя посадить туда бота
for "_i" from 0 to _count_bliding do 
{
	_select_bilding_from_bot = [_arry_bilding_from_bot select _count_bliding, -1] call BIS_fnc_buildingPositions; // поиск позицый
	if(isnil {_select_bilding_from_bot select 0}) then{} else{
		private _seed = [1,101] call BIS_fnc_randomInt; // рандомное число от 0 до 100
		if(_seed <= _chanse_spawn_in_bilding) // если рандомное число больше или равно шансу спауна спаунится бот в здании
		then {
		_last_pos_bilding = count _select_bilding_from_bot; // подсчет количество позицый в выбраном здании
		_unit = _group_bot_in_bilding createUnit [selectRandom _arry_class_name_bot, _select_bilding_from_bot select _last_pos_bilding - 1, [], 0, "FORM"]; //спаун бота
		_unit disableAI "PATH";// отключить боту перемещение
		_arry_group_bot pushBack _unit; 
			};
	};
_count_bliding = _count_bliding - 1;

sleep 0.1;
};





																// жду пока игроки покинут зону


waitUntil{
sleep 5;
_player_in_area = allPlayers inAreaArray [_pos_spawn, _radius_activation, _radius_activation, 0, false];
isNil {_player_in_area select 0}
};


																// Удаляю ботов

if(_delete_when_player_not_present == true)then{
	{deleteVehicle _x} forEach _arry_group_bot;
};
