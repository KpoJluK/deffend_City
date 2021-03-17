///////////////// created by KpoJLuK ////////////////////
///////////////// https://github.com/KpoJluK/deffend_sity /////////////////////////////
/*

[
	[1943.007,2312.045,0],	// массив координатов где будет центр здания

	WEST,	// сторона ботов можнт быть: EAST, WEST, independent

	["B_medic_F", // массив класс наймов ботов которые будут патрулировать зону
"B_Soldier_SL_F",
"B_soldier_AT_F",
"B_soldier_AA_F",
"B_soldier_M_F"],

	["B_MRAP_01_hmg_F",	// массив класс неймов легких машин которые будут патрулировать зону
"B_MRAP_01_gmg_F"],

	["B_MBT_01_cannon_F", // массив тяжолой техники кторая будет патрулировать зону
"B_MBT_01_TUSK_F",
"B_APC_Wheeled_01_cannon_F",
"B_APC_Tracked_01_CRV_F"],

	["B_APC_Tracked_01_AA_F"	// массив самоходных зенитныйх установок кторая будет патрулировать зону
	],

	["B_Heli_Attack_01_dynamicLoadout_F", // массив вертолетов кторая будет патрулировать зону
"B_Heli_Transport_01_F"],

	["B_HMG_01_high_F",	// массив статичного вооружения кторая будет размещена в зоне
"B_GMG_01_high_F",
"B_Mortar_01_F"],

	300, // радиус (от центра) размещения статичных орудий(м)

	3, // количество статичных орудий

	2,	// количество легких машин которые будут патрулировать зону

	2,	// количество тяжолой техники которая будует патрулировать зону

	2,	// количество самоходных зенитныйх установок которые будут патрулировать зону

	1,	//	количество вертолетов которые будут патрулировать зону

	4,	// количество групп ботов которые будет охранять зону

	4,	//	количество ботов в группах которые будут охранять зону

	30,	// шанс появления бота в здании(на крыше) в % от 0 до 100

	2000, // радиус активации игроком

	300,	// радиус патрулирования ботов

	500,	// радиус размещения легких машин которые будут патрулировать зону(чем больше машин тем больше зону лучше сделать)

	600,	// радиус патрулирования всех машин и легких танков

	1000,	// радиус патрулирования вертолетов

	true	// удалять ли зону после активации если в зоне активации не осталось игроков

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

_arry_group_bot = []; // общий масив который будет содержать все юниты которые будут созданы


																		// создаю группы патруля



while {_count_patrul_bot_grup > 0} do
{

	private _group = createGroup [_side_bot, true];


// создаю юниты внутри групп
		local_count_bot_in_grup = _count_bot_in_grup;

		while {local_count_bot_in_grup > 0} do
		{
			_unit = _group createUnit [selectRandom _arry_class_name_bot, _pos_spawn, [], 0, "FORM"];

			sleep 0.5;

			_arry_group_bot pushBack _unit; // добавляю юнит в массив что бы потом все вместе удалить
			
			local_count_bot_in_grup = local_count_bot_in_grup - 1;

		};

	[_group, _pos_spawn, _radius_patroul_bot] call bis_fnc_taskPatrol;

	_count_patrul_bot_grup = _count_patrul_bot_grup - 1;

	sleep 1;

};


																	// создаю статику

while {_count_stacika > 0} do 
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
[getPos (_static_weapon select 0), 0, _objectsArray, 0] call BIS_fnc_objectsMapper; // воссоздаю композицыю обьектов

	_arry_group_bot pushBack (_static_weapon select 0);
	_arry_group_bot pushBack (_static_weapon select 1);

	_count_stacika = _count_stacika - 1;

	sleep 0.5;
};


																	// Создаю машины


while { _count_vehicle_track > 0} do
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
	_count_vehicle_track = _count_vehicle_track - 1;
};


																	// Создаю бронетехнику


while {_count_vehicle > 0} do
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
	_count_vehicle = _count_vehicle - 1;
};



																	// Создаю зенитки

while {_count_vehicle_pvo > 0} do
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
	_count_vehicle_pvo = _count_vehicle_pvo - 1;
};




																	// Создаю вертолет


while {_count_vehicle_heli > 0} do
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
	_count_vehicle_heli = _count_vehicle_heli - 1;
};


																		// создаю группы внутри зданий(на крышах)

// создаю группу

private _group_bot_in_bilding = createGroup [_side_bot, true];

// поиск всех обьектов с класнеймом "дом"
private _arry_bilding_from_bot = nearestObjects [_pos_spawn, ["house"], _radius_patroul_bot];

// подсчет сколько найдено значений
private _count_bliding = count _arry_bilding_from_bot - 1;

// если в здании есть позицыя посадить туда бота
while {_count_bliding > 0} do
{
	_select_bilding_from_bot = [_arry_bilding_from_bot select _count_bliding, -1] call BIS_fnc_buildingPositions; // поиск позицый в заднии
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
