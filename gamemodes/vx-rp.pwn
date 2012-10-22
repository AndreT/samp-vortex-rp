/*
						Copyright 2010-2011 Frederick Wright

		   Licensed under the Apache License, Version 2.0 (the "License");
		   you may not use this file except in compliance with the License.
		   You may obtain a copy of the License at

		     		http://www.apache.org/licenses/LICENSE-2.0

		   Unless required by applicable law or agreed to in writing, software
		   distributed under the License is distributed on an "AS IS" BASIS,
		   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
		   See the License for the specific language governing permissions and
		   limitations under the License.

		SCRIPT:
		    Vortex Roleplay 2 Script

		AUTHOR:
			Frederick Wright [mrfrederickwright@gmail.com]
			Stefan Rosic [streetfire68@hotmail.com]

		ADDITIONAL CREDITS:
		    All other unmentioned mapping: JamesC [http://forum.sa-mp.com/member.php?u=97617]
			Gym Map: Marcel_Collins [http://forum.sa-mp.com/showthread.php?p=1537421]
			LS Mall: cessil [http://forum.sa-mp.com/member.php?u=50597]

		MISC INFO:
			gGroupType listing:
				0 - Gangs
				1 - Police
				2 - Government
				3 - Hitmen
				4 - LSFMD

				Reserved group slots
				1 - LSPD
				3 - Government
				4 - LSFMD

				Job Types
				1 - Arms Dealer
				2 - Detective
				3 - Mechanic
				4 - Fisherman
				
				Business Item Types:
				1 - Rope
				2 - Walkie Talkie
				3 - Phonebook
				4 - Mobile Phone Credit
				5 - Mobile Phone
				6 - 5% health increase (food)
				7 - 10% health increase (food)
				8 - 30% health increase (food)
				9 - Purple Dildo
				10 - Small White Vibrator
				11 - Large White Vibrator
				12 - Silver Vibrator
				13 - Flowers
				14 - Cigar(s)
				15 - Sprunk
				16 - Wine
				17 - Beer
				18 - All Skins

			Error Codes:
				01x01 - Attempted to deposit an invalid (negative) amount of money to a house safe.
				01x02 - Attempted to deposit an invalid (negative) amount of materials to a house safe.
				01x03 - Attempted to withdraw an invalid (negative) amount of money from a house safe.
				01x04 - Attempted to withdraw an invalid (negative) amount of materials from a house safe.
				01x05 - No checkpoint reason. The checkpoint handle hasn't had a string defined in getPlayerCheckpointReason()
				01x08 - Too many vehicles spawned (in danger of exceeding MAX_VEHICLES).

			Business Types:
			    0 - None
			    1 - 24/7
				2 - Clothing Store
				3 - Bar
				4 - Sex Shop
				5 - Car Dealership
				6 - Gym
				7 - Restaurant
*/

#include                <a_samp>
#include                <a_mysql>
#include                <zcmd>
#include                <foreach>
#include                <GeoIP_Plugin>
#include                <streamer>
#include                <OPSP>
#include				<a_zones>
#include                <sscanf2>

#define                 MAX_HOUSES                              (100)
#define                 MAX_BOTS                                (2)
#define                 MAX_TIMERS              				(5)
#define                 MAX_TEXTDRAWS                           (10)
#define                 MAX_JOBS                                (5)
#define                 MAX_GROUPS                              (20)
#define                 MAX_BUSINESSES                          (50)
#define                 MAX_WEAPON_HACK_WARNINGS                (3)
#define                 MAX_ASSETS                              (10)
#define					MAX_SPIKES								(10)
#define					MAX_LOGIN_ATTEMPTS						(3)
#define                 MAX_ATMS                                (25)
#define                 MAX_BUSINESS_ITEMS                      (MAX_BUSINESSES * 6)

#define 				COLOR_YELLOW 							0xFFFF00AA
#define 				COLOR_RED 								0xE60000FF
#define 				COLOR_WHITE 							0xFFFFFFAA
#define 				COLOR_LIGHT								0xAFD9FAFF
#define 				COLOR_GREY 								0xCECECEFF
#define 				COLOR_PURPLE 							0xC2A2DAAA
#define                 COLOR_LIGHTRED                          0xFF8080FF
#define 				COLOR_NICESKY 							0x00C2ECFF
#define 				COLOR_GREEN 							0x00FF00AA
#define                 COLOR_TEAL                              0x67AAB1FF
#define 				COLOR_DCHAT		 						0xFFD7004A
#define                 COLOR_CHATBUBBLE						0xFFFFFFCC
#define                 COLOR_NEWBIE							0xBED9EFFF
#define                 COLOR_RADIOCHAT                         0x8D8DFFFF
#define                 COLOR_GENANNOUNCE                   	0xA9C4E4FF
#define					COLOR_COOLBLUE							0x0064FFAA
#define 				COLOR_HOTORANGE 						0xF97804FF
#define					COLOR_SMS								0xD5EAFFFF
#define                 EMBED_GREY                          	"{CECECE}"
#define                 EMBED_LIGHTRED                          "{FF8080}"
#define                 EMBED_OOC                               "{AFD9FA}"
#define                 EMBED_WHITE                             "{FFFFFF}"

/* ----------------------------- [DIALOGS] ----------------------------- */

#define                 DIALOG_LOGIN                            (1)
#define                 DIALOG_HOUSE_ENTER                      (2)
#define 				DIALOG_CREATEGUN 						(3)
#define                 DIALOG_GROUP_ENTER                      (4)
#define                 DIALOG_LSPD                             (5)
#define                 DIALOG_LSPD_EQUIPMENT            		(6)
#define                 DIALOG_LSPD_RELEASE                		(7)
#define                 DIALOG_LSPD_CLOTHING             		(8)
#define                 DIALOG_LSPD_CLEAR              			(9)
#define					LSPD_DIALOG_EQUIPMENT1                  (10)
#define					LSPD_DIALOG_EQUIPMENT2                  (11)
#define 				DIALOG_LSPD_CLOTHING_OFFICIAL           (12)
#define 				DIALOG_LSPD_CLOTHING_CUSTOM             (13)
#define					DIALOG_HELP								(14)
#define					DIALOG_HELP2							(15)
#define                 DIALOG_GENDER_SELECTION                 (16)
#define                 DIALOG_TUTORIAL_DOB                     (17)
#define                 DIALOG_TUTORIAL                         (18)
#define                 DIALOG_REPORT                           (19)
#define                 DIALOG_TWENTYFOURSEVEN                  (20)
#define 				DIALOG_GO								(21)
#define 				DIALOG_GO1								(22)
#define 				DIALOG_GO2								(23)
#define 				DIALOG_GO3								(24)
#define 				DIALOG_GO4								(25)
#define 				DIALOG_GO5								(26)
#define 				DIALOG_GO6								(27)
#define                 DIALOG_BUSINESS_ENTER                   (28)
#define                 DIALOG_DROP                             (29)
#define 				DIALOG_ELEVATOR1 						(30)
#define 				DIALOG_ELEVATOR2 						(31)
#define 				DIALOG_ELEVATOR3 						(32)
#define 				DIALOG_ELEVATOR4 						(33)
#define					DIALOG_DROPITEM							(34)
#define                 DIALOG_BAR                              (35)
#define                 DIALOG_SEX_SHOP                         (36)
#define					DIALOG_BUYCAR							(37)
#define 				DIALOG_BUYCAR_CRAP						(38)
#define					DIALOG_BUYCAR_CLASSIC					(39)
#define					DIALOG_BUYCAR_SEDAN						(40)
#define					DIALOG_BUYCAR_SUV						(41)
#define					DIALOG_BUYCAR_BIKE						(42)
#define					DIALOG_BUYCAR_MUSCLE					(43)
#define					DIALOG_FIGHTSTYLE						(44)
#define                 DIALOG_REGISTER                         (46)
#define                 DIALOG_SELL_FISH                        (47)
#define                 DIALOG_FOOD			                    (48)
#define                 DIALOG_LICENSE_PLATE                    (49)
#define                 DIALOG_GMX                              (50)
#define                 DIALOG_PHONE_MENU                       (51)
#define                 DIALOG_MOBILE_HISTORY                   (52)
#define                 DIALOG_MOBILE_CONTACTS_MAIN             (53)
#define                 DIALOG_ATM_MENU                         (54)
#define                 DIALOG_RP_NAME_CHANGE                   (55)
#define                 DIALOG_ADMIN_PIN                        (56)
#define                 DIALOG_SET_ADMIN_PIN                    (57)
#define                 DIALOG_ATM_WITHDRAWAL                   (58)
#define                 DIALOG_QUIZ                             (59)
#define                 DIALOG_DO_TUTORIAL                      (60)
#define                 DIALOG_TUTORIAL_CHOICE                  (61)

#define                 THREAD_CHECK_BANS_LIST                  (1)
#define                 THREAD_CHECK_ACCOUNT_USERNAME           (2)
#define                 THREAD_CHECK_CREDENTIALS                (3)
#define                 THREAD_BAN_PLAYER                       (4)
#define                 THREAD_FINALIZE_BAN                     (5)
#define                 THREAD_CHECK_PLAYER_NAME_BANNED         (6)
#define                 THREAD_FINALIZE_UNBAN                   (7)
#define                 THREAD_INITIATE_VEHICLES                (8)
#define                 THREAD_INITIATE_HOUSES                  (9)
#define                 THREAD_INITIATE_JOBS                    (10)
#define                 THREAD_INITIATE_GROUPS                  (11)
#define                 THREAD_INITIATE_ASSETS                  (13)
#define                 THREAD_INITIATE_BUSINESSES              (14)
#define                 THREAD_CHECK_PLATES                     (15)
#define                 THREAD_MOBILE_HISTORY                   (16)
#define                 THREAD_MOBILE_LIST_CONTACTS             (17)
#define                 THREAD_BANK_SUSPENSION                  (18)
#define                 THREAD_CHECK_PLAYER_NAMES               (19)
#define                 THREAD_CHANGE_SPAWN                     (20)
#define                 THREAD_LOAD_ATMS                        (21)
#define                 THREAD_RANDOM		                    (22)
#define                 THREAD_TIMESTAMP_CONNECT                (23)
#define                 THREAD_LAST_CONNECTIONS                 (24)
//#define                 THREAD_LOAD_PLAYER_VEHICLES             (25)
#define                 THREAD_ADMIN_SECURITY                   (26)
#define                 THREAD_INITIATE_BUSINESS_ITEMS          (27)
#define                 THREAD_UNBAN_IP                         (28)
#define                 THREAD_CHANGE_BUSINESS_TYPE_ITEMS       (29)

#define                 GROUP_VIRTUAL_WORLD						(20000)
#define                 HOUSE_VIRTUAL_WORLD                     (10000)
#define                 BUSINESS_VIRTUAL_WORLD                  (30000)

#define 				INTERIOR_WEATHER_ID						(1) // Outdoor weather is used inside interiors too, blame San Andreas.
#define					MAX_WEATHER_POINTS						(9)

#define					GOVERNMENT_GROUP_ID						(4)

#define                 ADMIN_PIN_TIMEOUT                       (120) // In seconds. 120 seconds (2 minutes) is default.

#define                 SERVER_VERSION                          "2.0.4 (r321)"
#define                 SERVER_NAME                             "VX-RP" // Would be nice if you kept it as this, so I can see which servers are using this mode easily

#define                 SYNTAX_MESSAGE                          "Syntax: {FFFFFF}"

#define                 IRC_CHANNEL_MAIN                        "#"

#define                 IRC_SERVER                              "(server)"
#define                 IRC_PORT                                6667
#define                 IRC_BOT_PASS                            "(password)"
#define                 IRC_STAFF_CHANNEL                       "#(channel)"
#define                 IRC_STAFF_CHANNEL_PASSWORD              "(password)"

// Comment out #define NO_IRC or delete that line if you want to use IRC.
#define                 NO_IRC

// Uncomment the line below if you want to use high-level debugging - prints every single callback and some advanced functions
//#define                 DEBUG

#define 				SpeedCheck(%0,%1,%2,%3,%4) 				floatround(floatsqroot(%4?(%0*%0+%1*%1+%2*%2):(%0*%0+%1*%1) ) *%3*1.6)
#define 				strcpy(%0,%1,%2) 						strcat((%0[0] = '\0', %0), %1, %2) // strcpy(dest, source, length)
#define                 hidePlayerDialog(%0)                    ShowPlayerDialog(%0, -1, 0, " ", " ", "", "")
#define					IsPlayerAuthed(%0)						(playerVariables[%0][pStatus] == 1)

forward                 globalPlayerLoop();
forward                 restartTimer();
forward                 AFKTimer();
forward 				initiateTutorial(const playerid);
forward					ShutUp(slot);
forward                 invalidNameChange(playerid);
forward                 playerTabbedLoop();
forward                 genderSelection(const playerid);
forward                 loginCheck(playerid);

#if !defined NO_IRC
	forward IRCBotDelay();
#endif

forward					VendDrink(playerid);

forward                 antiCheat();

native					WP_Hash(buffer[], len, const str[]);

#if !defined NO_IRC
	#include <irc>
#endif

main() {
	print("main() has been called.");
}

enum systemE {
	houseCount,
	businessCount,
	vehicleCounts[3],
	reportSystem,
	OOCStatus,
}

enum assetsE {
	aAssetName[32],
	aAssetValue,
}

enum connectionE {
	szDatabaseName[32],
	szDatabaseHostname[32],
	szDatabaseUsername[32],
	szDatabasePassword[64],
}

enum jobsE {
    jJobType,
    Float: jJobPosition[3],
    jJobName[32],
    jJobPickupID,
    Text3D:jJobLabelID,
}

enum atmE {
	Float: fATMPos[3],
	Float: fATMPosRot[3],
	rObjectId,
	Text3D: rTextLabel,
}

enum businessE {
	bType,
	bOwner[MAX_PLAYER_NAME],
	bName[32],
	Float: bExteriorPos[3],
	Float: bInteriorPos[3],
	bInterior,
	bLocked,
	Float: bMiscPos[3],
	bVault,
	Text3D: bLabelID,
	bPickupID,
	bPrice,
}

enum spikeE {
	sObjID,
	Float:sPos[4],
	sDeployer[MAX_PLAYER_NAME],
}

enum vehicleE {
	vVehicleModelID,
	Float: vVehiclePosition[3],
	Float: vVehicleRotation,
	vVehicleGroup,
	vVehicleColour[2],
	vVehicleScriptID,
}

enum houseE {
	Float: hHouseExteriorPos[3],
	Float: hHouseInteriorPos[3],
	hHouseInteriorID,
	hHouseLocked,
	hHouseExteriorID,
	hHousePrice,
	hPickupID,
	Text3D:hLabelID,
	hHouseOwner[MAX_PLAYER_NAME],
	hMoney,
	hWeapons[5],
	hWardrobe[5],
	hMaterials,
}

enum groupE {
	gGroupName[64],
	gGroupType,
	Float: gGroupExteriorPos[3],
	Float: gGroupInteriorPos[3],
	gGroupHQInteriorID,
	gGroupPickupID,
	Float: gSafePos[3],
	gSafePickupID,
	Text3D: gSafeLabelID,
	Text3D: gGroupLabelID,
	gGroupHQLockStatus,
	gSafe[2], // 0-1: Money, mats. pot, cocaine out for now
	gswatInv,
	gGroupMOTD[128],
	gGroupRankName1[32], // 4d arrays aren't supported in pawn, so I'll have to continue it like this...
	gGroupRankName2[32],
	gGroupRankName3[32],
	gGroupRankName4[32],
	gGroupRankName5[32],
	gGroupRankName6[32],
}

enum businessItemsE {
	bItemBusiness,
	bItemType,
	bItemName[32],
	bItemPrice,
}

enum playervEnum {
	Float: pHealth,
	Float: pArmour,
	Float: pPos[3],
	pPassword[129],
	pStatus, // -1: not connected | 0: connected, not authed | 1: connected, authed
	pAge,
	pMoney,
	pAdminLevel,
	pInterior,
	pLevel,
	pSkinSet,
	pCarID,
	pAnticheatExemption,
	pTabbed,
	pCarWeapons[5],
	pCarLicensePlate[32],
	pCarTrunk[2], // Cash & mats
	pPhoneCredit, // Will be done in seconds.
	pWalkieTalkie, // -1 = no walkie, 0 = switched off
	pSpectating,
	pSpecSession,
	pConnectedSeconds,
	pSpamCount,
	pFishing,
	pMuted,
	pVirtualWorld,
	pFish,
	pBanned,
	pTazer,
	pEvent,
	Float: pCarPos[4],
	pReport,
	pPrisonTime,
	pPrisonID, // 3 = IN CHARACTER JAIL! (future reference)
	pHackWarnTime,
	pHelperDuty,
	pReportMessage[64],
	pPlayingHours,
	pSkin,
	pJob,
	pRope,
	pAccent[40],
	pWarning1[32],
	pWarning2[32],
	pWarning3[32],
	pPhoneNumber,
	pSkinCount,
	pSeeOOC,
	pOOCMuted,
	pNewbieTimeout,
	pTutorial,
	pWeapons[13],
	pOutstandingWeaponRemovalSlot,
	pJetpack,
	pBankMoney,
	pHackWarnings,
	pEmail[255], // because this is the max length for a valid email.
	pSeconds,
	pFightStyle,
	pInternalID,
	pJobDelay,
	pGender,
	pNewbieEnabled,
	pFirstLogin,
	pAdminDuty,
	pHelper,
	pCarColour[2],
	pMatrunTime,
	pAdminName[MAX_PLAYER_NAME],
	pNormalName[MAX_PLAYER_NAME],
	pPhoneBook,
	pCheckpoint,
	pPMStatus,
	pOnRequest,
	Text3D: pAFKLabel,
	pGroup,
	pCarModel,
	pCarMods[13],
	pCarPaintjob,
	pCarLock,
	pVIP,
	pGroupRank,
	pDropCarTimeout,
	pMaterials,
	pJobSkill[2],
	pHospitalized,
	pFreezeTime, // Seconds. Set it to -1 if you want to permafreeze.
	pFreezeType, // 0 = not frozen (obviously), 1 = tazed, 2 = cuffed, 3 = admin frozen, 4 = tied
	pDrag,
	pAnimation,
	pPhoneStatus, // togged on/off
	pPhoneCall,
	pConnectionIP[32],
	pSeeWhisper,
	pCrimes,
	pArrests,
    pWarrants,
	pBackup,
}

enum eventE {
	eEventStat,
	eEventCount,
	Float:eEventPos[3], // XYZ pos.
	Float:eArmourHP[2], // Health, armour
	eEventWeapons[5],
	eEventSkin,
	eEventInt,
	eEventVW,
}

new
	LSPDObjs[8][3], // 8 sets of doors. 0 = door1, 1 = door2, 2 = status (closed/open)
	LSPDGates[2][2]; // Boom gate, garage (1 = status, closed/open).

new tutorialSkins[73] = {
	0, 1, 2, 7, 9, 10, 11, 12, 13, 14, 15, 16, 17,
	18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
	30, 31, 32, 33,	34, 35, 36, 37, 38, 39, 40, 41,
	43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 52, 53,
	54, 55, 56, 57, 58, 59, 60, 61,	62, 63, 64,	66,
	67, 68, 69, 70, 72, 73, 75, 76, 77, 78, 79, 299
};

#if !defined NO_IRC
	new
	    scriptBots[MAX_BOTS];
#endif

new Float:JailSpawns[4][3] = {

	{ 227.46, 110.0, 999.02 },
	{ 223.15, 110.0, 999.02 },
	{ 219.25, 110.0, 999.02 },
	{ 216.39, 110.0, 999.02 }
};

new validWeatherIDs[17] = { 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15, 17, 18, 20 };

new WeaponNames[47][] = // As below
{
	"punch","brass knuckles","golf club","nitestick","knife","baseball bat","shovel","pool cue","katana","chainsaw","purple dildo","small white vibrator","large white vibrator","silver vibrator",
	"bouquet of flowers","cane","grenade","tear gas grenade","molotov cocktail","jetpack"," "," ","Colt .45","silenced Colt .45","Desert Eagle","12-gauge shotgun","sawn-off shotgun","SPAS-12",
	"Micro Uzi","MP5","AK-47","M4A1","TEC-9","rifle","sniper rifle","rocket launcher","heatseeker","flamethrower","minigun","satchel charge","detonator","spray can","fire extinguisher",
	"camera","nightvision goggles", "thermal goggles","parachute"
};

new fishNames[5][] = {
	"Carp", "Bass", "Cod", "Plaice", "Tuna"
};

new VehicleNames[212][] = // Keeping unnecessary bits out (easily calculated integers, etc) for the win
{
	"Landstalker","Bravura","Buffalo","Linerunner","Perennial","Sentinel","Dumper","Firetruck","Trashmaster","Stretch",
	"Manana","Infernus","Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi",
	"Washington","Bobcat","Mr Whoopee","BF Injection","Hunter","Premier","Enforcer","Securicar","Banshee","Predator",
	"Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie","Stallion","Rumpo","RC Bandit", "Romero",
	"Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder","Reefer","Tropic","Flatbed",
	"Yankee","Caddy","Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
	"Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler",
	"ZR-350","Walton","Regina","Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper",
	"Rancher","FBI Rancher","Virgo","Greenwood","Jetmax","Hotring Racer","Sandking","Blista Compact","Police Maverick",
	"Boxville","Benson","Mesa","RC Goblin","Hotring Racer A","Hotring Racer B","Bloodring Banger","Rancher","Super GT",
	"Elegant","Journey","Bike","Mountain Bike","Beagle","Cropduster","Stuntplane","Tanker","Road Train","Nebula","Majestic",
	"Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV-1000","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck",
	"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","Vincent",
	"Bullet","Clover","Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility",
	"Nevada","Yosemite","Windsor","Monster A","Monster B","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger",
	"Flash","Tahoma","Savanna","Bandito","Freight","Trailer","Kart","Mower","Duneride","Sweeper","Broadway",
	"Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer","Emperor","Wayfarer",
	"Euros","Hotdog","Club","Trailer","Trailer","Andromada","Dodo","RCCam","Launch","Police Car (LSPD)","Police Car (SFPD)",
	"Police Car (LVPD)","Police Ranger","Picador","S.W.A.T. Van","Alpha","Phoenix","Glendale","Sadler","Luggage Trailer A",
	"Luggage Trailer B","Stair Trailer","Boxville","Farm Plow","Utility Trailer"
};

new
	databaseConnection,
	pingTick,
	adTick,
	vehCount,
	weatherVariables[2],
	gTime[3],
	iGMXTimer,
	iTarget,
	iGMXTick,
	systemVariables[systemE],
	eventVariables[eventE],
	connectionInfo[connectionE],
	houseVariables[MAX_HOUSES][houseE],
	Text:textdrawVariables[MAX_TEXTDRAWS],
	jobVariables[MAX_JOBS][jobsE],
 	AdminSpawnedVehicles[MAX_VEHICLES],
 	assetVariables[MAX_ASSETS][assetsE],
 	szQueryOutput[256],
 	szMessage[128],
 	szSmallString[32],
 	//szSmallString2[32],
 	szMediumString[64],
 	atmVariables[MAX_ATMS][atmE],
 	result[256],
 	szServerWebsite[32],
 	szLargeString[1024],
 	szPlayerName[MAX_PLAYER_NAME],
 	businessVariables[MAX_BUSINESSES][businessE],
 	Float:PlayerPos[MAX_PLAYERS][6],
	vehicleVariables[MAX_VEHICLES][vehicleE],
	groupVariables[MAX_GROUPS][groupE],
	businessItems[MAX_BUSINESS_ITEMS][businessItemsE],
	playerVariables[MAX_PLAYERS][playervEnum],
	spikeVariables[MAX_SPIKES][spikeE],
	scriptTimers[MAX_TIMERS];

public OnGameModeInit() {
    AntiDeAMX();

    #if defined DEBUG
		mysql_debug(1);
		print("[debug] OnGameModeInit()");
	#endif

    initiateConnections();

    mysql_query("UPDATE playeraccounts SET playerStatus = '0' WHERE playerStatus = '1'");

	scriptTimers[0] = SetTimer("globalPlayerLoop", 1000, true);
	scriptTimers[1] = SetTimer("antiCheat", 1000, true);
	scriptTimers[2] = SetTimer("playerTabbedLoop", 1000, true);
	scriptTimers[3] = SetTimer("AFKTimer", 600000, true);

	initiateVehicleSpawns();
	initiateHouseSpawns();
	initiateJobs();
	initiateGroups();
	initiateAssets();
	initiateBusinesses();
	loadATMs();

	ShowPlayerMarkers(0);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	UsePlayerPedAnims();
	
	#if !defined NO_IRC
		scriptTimers[4] = SetTimer("IRCBotDelay", 5000, false); // Run a timer to delay the bots from connecting, incase of the script going crazy!!1
	#endif
	
	GetServerVarAsString("weburl", szServerWebsite, sizeof(szServerWebsite));

	SetGameModeText(SERVER_NAME" "SERVER_VERSION);

	weatherVariables[0] = validWeatherIDs[random(sizeof(validWeatherIDs))];
	SetWeather(weatherVariables[0]);

	textdrawVariables[1] = TextDrawCreate(203.000000, 377.000000, "Press ~r~RIGHT~w~ to teleport to the player.~n~Press ~r~LEFT~w~ to disregard the request.");
	TextDrawBackgroundColor(textdrawVariables[1], 255);
	TextDrawFont(textdrawVariables[1], 2);
	TextDrawLetterSize(textdrawVariables[1], 0.190000, 1.200000);
	TextDrawColor(textdrawVariables[1], -1);
	TextDrawSetOutline(textdrawVariables[1], 1);
	TextDrawSetProportional(textdrawVariables[1], 1);
	TextDrawSetShadow(textdrawVariables[1], 1);

	textdrawVariables[7] = TextDrawCreate(149.000000, 370.000000, "~n~~n~~g~You can now continue to the next step.");
	TextDrawBackgroundColor(textdrawVariables[7], 255);
	TextDrawFont(textdrawVariables[7], 2);
	TextDrawLetterSize(textdrawVariables[7], 0.290000, 1.200000);
	TextDrawColor(textdrawVariables[7], -1);
	TextDrawSetOutline(textdrawVariables[7], 0);
	TextDrawSetProportional(textdrawVariables[7], 1);
	TextDrawSetShadow(textdrawVariables[7], 1);

	textdrawVariables[8] = TextDrawCreate(149.000000, 370.000000, "~n~~n~~r~You must wait a few seconds before continuing...");
	TextDrawBackgroundColor(textdrawVariables[8], 255);
	TextDrawFont(textdrawVariables[8], 2);
	TextDrawLetterSize(textdrawVariables[8], 0.290000, 1.200000);
	TextDrawColor(textdrawVariables[8], -1);
	TextDrawSetOutline(textdrawVariables[8], 0);
	TextDrawSetProportional(textdrawVariables[8], 1);
	TextDrawSetShadow(textdrawVariables[8], 1);

	textdrawVariables[2] = TextDrawCreate(149.000000, 370.000000, "Press ~r~left~w~ and ~n~Press ~r~right~w~ arrows to change skins.~n~Press ~r~~k~~VEHICLE_ENTER_EXIT~~w~ to select that skin.");
	TextDrawBackgroundColor(textdrawVariables[2], 255);
	TextDrawFont(textdrawVariables[2], 2);
	TextDrawLetterSize(textdrawVariables[2], 0.390000, 1.200000);
	TextDrawColor(textdrawVariables[2], -1);
	TextDrawSetOutline(textdrawVariables[2], 0);
	TextDrawSetProportional(textdrawVariables[2], 1);
	TextDrawSetShadow(textdrawVariables[2], 1);

	textdrawVariables[3] = TextDrawCreate(149.000000, 370.000000, "~w~Press ~r~left~w~ to go back a step~n~press ~r~right~w~ arrow to proceed");
	TextDrawBackgroundColor(textdrawVariables[3], 255);
	TextDrawFont(textdrawVariables[3], 2);
	TextDrawLetterSize(textdrawVariables[3], 0.390000, 1.200000);
	TextDrawColor(textdrawVariables[3], -1);
	TextDrawSetOutline(textdrawVariables[3], 0);
	TextDrawSetProportional(textdrawVariables[3], 1);
	TextDrawSetShadow(textdrawVariables[3], 1);

	textdrawVariables[4] = TextDrawCreate(149.000000, 420.000000, "Press ~r~~k~~SNEAK_ABOUT~~w~ to quit the spectator tool."); // Moved it down a little, it was actually fairly obtrusive.
	TextDrawBackgroundColor(textdrawVariables[4], 255);
	TextDrawFont(textdrawVariables[4], 2);
	TextDrawLetterSize(textdrawVariables[4], 0.390000, 1.200000);
	TextDrawColor(textdrawVariables[4], -1);
	TextDrawSetOutline(textdrawVariables[4], 0);
	TextDrawSetProportional(textdrawVariables[4], 1);
	TextDrawSetShadow(textdrawVariables[4], 1);

	textdrawVariables[5] = TextDrawCreate(610.0, 420.0, "Type ~r~/stopanim~w~ to stop your animation.");
	TextDrawUseBox(textdrawVariables[5], 0);
	TextDrawFont(textdrawVariables[5], 2);
	TextDrawSetShadow(textdrawVariables[5], 0);
    TextDrawSetOutline(textdrawVariables[5], 1);
    TextDrawBackgroundColor(textdrawVariables[5], 0x000000FF);
    TextDrawColor(textdrawVariables[5], 0xFFFFFFFF);
    TextDrawAlignment(textdrawVariables[5], 3);

    CreateDynamic3DTextLabel("Materials Pickup!\n\nType /getmats as an Arms Dealer \nto collect materials!", COLOR_YELLOW, 1423.9871, -1319.2954, 13.5547, 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
	CreateDynamicPickup(1239, 23, 1423.9871, -1319.2954, 13.5547, 0, -1, -1, 50);

	/* -------------------------------------- Mapping (objects, static 3D texts, static pickups) -------------------------------------- */

	LSMall();
	GymMap();

	/* Bank */
	CreateDynamicPickup(1239, 23, 595.5443,-1250.3405,18.2836, 0, -1, -1, 50);
	CreateDynamic3DTextLabel("Bank of Los Santos\nPress ~k~~PED_DUCK~ to enter", COLOR_YELLOW, 595.5443,-1250.3405,18.2836, 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
	/* /arrest */
	CreateDynamic3DTextLabel("Los Santos Police Department\nProcessing Entrance\n\n(/arrest)", COLOR_COOLBLUE, 1528.5240,-1678.2472,5.8906, 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 15.0);

	/* Exterior LSPD gates */
	LSPDGates[0][0] = CreateDynamicObject(968, 1544.681640625, -1630.8924560547, 13.15, 0.0, 90.0, 90.0, 0, 0, _, 200.0);
	LSPDGates[1][0] = CreateDynamicObject(10184,1589.19995117,-1637.98498535,14.69999981,0.00000000,0.00000000,270.00000000, 0, 0, _, 200.0);

	/* LSPD doors */
	LSPDObjs[0][0] = CreateDynamicObject(1569,232.89999390,107.57499695,1009.21179199,0.00000000,0.00000000,90.00000000, _, 10, _, 200.0); //commander south
	LSPDObjs[0][1] = CreateDynamicObject(1569,232.89941406,110.57499695,1009.21179199,0.00000000,0.00000000,270.00000000, _, 10, _, 200.0); //commander north
	LSPDObjs[1][0] = CreateDynamicObject(1569,275.75000000,118.89941406,1003.61718750,0.00000000,0.00000000,270.00000000, _, 10, _, 200.0); // interrogation north
	LSPDObjs[1][1] = CreateDynamicObject(1569,275.75000000,115.89941406,1003.61718750,0.00000000,0.00000000,90.00000000, _, 10, _, 200.0); // interrogation south
	LSPDObjs[2][0] = CreateDynamicObject(1569,253.20410156,107.59960938,1002.22070312,0.00000000,0.00000000,90.00000000, _,10, _, 200.0); // north west lobby door
	LSPDObjs[2][1] = CreateDynamicObject(1569,253.19921875,110.59960938,1002.22070312,0.00000000,0.00000000,270.00000000, _,10, _, 200.0); // north east lobby door
	LSPDObjs[3][0] = CreateDynamicObject(1569,239.56933594,116.09960938,1002.22070312,0.00000000,0.00000000,90.00000000, _,10, _, 200.0); // south west lobby door
	LSPDObjs[3][1] = CreateDynamicObject(1569,239.56445312,119.09960938,1002.22070312,0.00000000,0.00000000,269.98901367, _,10, _, 200.0); // south east lobby door
	LSPDObjs[4][0] = CreateDynamicObject(1569,264.45019531,115.82421875,1003.62286377,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(gen_doorext15) (3)
	LSPDObjs[4][1] = CreateDynamicObject(1569,267.45214844,115.82910156,1003.62286377,0.00000000,0.00000000,179.99450684, _,10, _, 200.0); //object(gen_doorext15) (8)
	LSPDObjs[5][0] = CreateDynamicObject(1569,267.32000732,112.53222656,1003.62286377,0.00000000,0.00000000,179.99450684, _,10, _, 200.0); //object(gen_doorext15) (4)
	LSPDObjs[5][1] = CreateDynamicObject(1569,264.32000732,112.52929688,1003.62286377,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(gen_doorext15) (5)
	LSPDObjs[6][0] = CreateDynamicObject(1569,229.59960938,119.52929688,1009.22442627,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(gen_doorext15) (9)
	LSPDObjs[6][1] = CreateDynamicObject(1569,232.59960938,119.53515625,1009.22442627,0.00000000,0.00000000,179.99450684, _,10, _, 200.0); //object(gen_doorext15) (10)
	LSPDObjs[7][0] = CreateDynamicObject(1569,219.30000305,116.52999878,998.01562500,0.00000000,0.00000000,180.00000000, _,10, _, 200.0); //cell east door
	LSPDObjs[7][1] = CreateDynamicObject(1569,216.30000305,116.52929688,998.01562500,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //cell west door

	/* LSPD interior objects (1st version) */
	CreateDynamicObject(1886,240.39999390,107.69999695,1010.70001221,35.00000000,0.00000000,135.00000000, _,10, _, 200.0); //object(nt_securecam1_01) (1)
	CreateDynamicObject(2058,262.23831177,107.09999847,1006.12506104,270.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(cj_gun_docs) (1)
	CreateDynamicObject(1491,222.17500305,119.45999908,1009.21502686,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(gen_doorint01) (1)
	CreateDynamicObject(1491,258.54980469,117.67968750,1007.82000732,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(gen_doorint01) (3)
	CreateDynamicObject(1491,260.73925781,117.67968750,1007.82000732,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(gen_doorint01) (4)
	CreateDynamicObject(2612,263.50000000,112.34960938,1005.50000000,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(police_nb2) (1)
	CreateDynamicObject(3857,233.04499817,124.00000000,1013.00000000,0.00000000,0.00000000,315.00000000, _,10, _, 200.0); //object(ottosmash3) (1)
	CreateDynamicObject(3857,232.73730469,124.00000000,1013.00000000,0.00000000,0.00000000,135.00012207, _,10, _, 200.0); //object(ottosmash3) (2)
	CreateDynamicObject(1491,225.05999756,115.94999695,1002.22998047,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(gen_doorint01) (2)
	CreateDynamicObject(1491,233.11000061,119.25000000,1002.22998047,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(gen_doorint01) (5)
	CreateDynamicObject(1491,236.80957031,119.25000000,1002.22998047,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(gen_doorint01) (6)
	CreateDynamicObject(3051,275.77499390,122.65599823,1004.97937012,0.00000000,0.00000000,46.00000000, _,10, _, 200.0); //object(lift_dr) (1)
	CreateDynamicObject(3051,275.75000000,121.50000000,1004.97937012,0.00000000,0.00000000,45.00000000, _,10, _, 200.0); //object(lift_dr) (2)
	CreateDynamicObject(1485,227.89999390,125.30000305,1010.21002197,50.00000000,10.00000000,2.00000000, _,10, _, 200.0); //object(cj_ciggy) (1)
	CreateDynamicObject(1510,228.07321167,125.27845001,1010.15997314,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(dyn_ashtry) (1)
	CreateDynamicObject(2196,228.40014648,125.53178406,1010.13958740,0.00000000,0.00000000,29.77478027, _,10, _, 200.0); //object(work_lamp1) (1)
	CreateDynamicObject(2063,262.95996094,107.40136719,1004.53997803,0.00000000,0.00000000,179.99450684, _,10, _, 200.0); //object(cj_greenshelves) (1)
	CreateDynamicObject(2043,262.29138184,107.46166229,1004.09997559,0.00000000,0.00000000,294.36035156, _,10, _, 200.0); //object(ammo_box_m4) (1)
	CreateDynamicObject(353,262.79998779297,107.68000030518,1004.9,91.9,89,240, _,10, _, 200.0); //object(cj_mp5k) (2)
	CreateDynamicObject(1672,262.62597656,107.59999847,1005.37500000,0.00000000,90.00000000,0.00000000, _,10, _, 200.0); //object(gasgrenade) (1)
	CreateDynamicObject(1672,262.81585693,107.48020935,1005.41998291,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(gasgrenade) (2)
	CreateDynamicObject(14782,267.76998901,109.30000305,1004.63323975,0.00000000,0.00000000,270.00000000, _,10, _, 200.0); //object(int3int_boxing30) (2)
	CreateDynamicObject(14782,260.79980469,108.75000000,1004.63323975,0.00000000,0.00000000,90.00000000, _,10, _, 200.0); //object(int3int_boxing30) (3)
	CreateDynamicObject(2359,263.54296875,107.39648438,1005.53002930,0.00000000,0.00000000,183.89465332, _,10, _, 200.0); //object(ammo_box_c5) (1)
	CreateDynamicObject(2038,263.47906494,107.32552338,1004.51000977,270.00000000,0.00000000,29.91000366, _,10, _, 200.0); //object(ammo_box_s2) (1)
	CreateDynamicObject(356,262.60000610352,107.30000305176,1004.4799804688,96, 90, 290, _,10, _, 200.0); //object(cj_m16) (1)
	CreateDynamicObject(2690,267.92782593,108.53081512,1003.97998047,0.00000000,0.00000000,312.13256836, _,10, _, 200.0); //object(cj_fire_ext) (1)
	CreateDynamicObject(2058,262.98568726,107.09528351,1005.36926270,90.00000000,180.00549316,359.98352051, _,10, _, 200.0); //object(cj_gun_docs) (1)
	CreateDynamicObject(11631,269.81250000,118.18945312,1004.86309814,0.00000000,0.00000000,270.00000000, _,10, _, 200.0); //object(ranch_desk) (1)
	CreateDynamicObject(2356,269.14312744,117.66873169,1003.61718750,0.00000000,0.00000000,294.49548340, _,10, _, 200.0); //object(police_off_chair) (1)
	CreateDynamicObject(2094,262.86523438,110.89941406,1003.60998535,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(swank_cabinet_4) (1)
	CreateDynamicObject(1886,267.73999023,107.50000000,1007.40002441,20.00000000,0.00000000,235.00000000, _,10, _, 200.0); //object(shop_sec_cam) (1)
	CreateDynamicObject(2606,267.36914062,120.50683594,1004.59997559,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(cj_police_counter2) (1)
	CreateDynamicObject(2606,267.36914062,120.50683594,1005.04998779,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(cj_police_counter2) (2)
	CreateDynamicObject(1738,270.29000854,120.00000000,1004.27178955,0.00000000,0.00000000,269.27026367, _,10, _, 200.0); //object(cj_radiator_old) (1)
	CreateDynamicObject(2180,265.50552368,120.27999878,1003.61718750,0.00000000,0.00000000,180.54052734, _,10, _, 200.0); //object(med_office5_desk_3) (1)
	CreateDynamicObject(1788,265.60000610,120.50000000,1004.48681641,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(swank_video_1) (1)
	CreateDynamicObject(1782,265.59960938,120.50000000,1004.65002441,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(med_video_2) (1)
	CreateDynamicObject(2595,264.21002197,120.37789154,1004.77404785,0.00000000,0.00000000,314.65002441, _,10, _, 200.0); //object(cj_shop_tv_video) (1)
	CreateDynamicObject(1785,265.59960938,120.50976562,1004.84997559,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(low_video_1) (1)
	CreateDynamicObject(1840,264.81204224,120.58029938,1004.41882324,0.00000000,0.00000000,105.60998535, _,10, _, 200.0); //object(speaker_2) (1)
	CreateDynamicObject(1840,265.70001221,120.55999756,1004.96264648,0.00000000,0.00000000,75.00000000, _,10, _, 200.0); //object(speaker_2) (2)
	CreateDynamicObject(2356,265.15481567,119.43829346,1003.61718750,0.00000000,0.00000000,34.19393921, _,10, _, 200.0); //object(police_off_chair) (2)
	CreateDynamicObject(1775,238.87988281,115.59960938,1010.32000732,0.00000000,0.00000000,270.26916504, _,10, _, 200.0); //object(vendmach) (1)
	CreateDynamicObject(4100,246.51953125,119.39941406,1005.40002441,0.00000000,179.99450684,219.99023438, _,10, _, 200.0); //object(meshfence1_lan) (1)
	CreateDynamicObject(4100,253.19999695,117.80000305,1010.50000000,320.00000000,90.00000000,90.00000000, _,10, _, 200.0); //object(pol_comp_gate) (1)
	CreateDynamicObject(2101,266.74893188,120.49598694,1005.28363037,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(med_hi_fi_3) (1)
	CreateDynamicObject(1886,264.25000000,116.55000305,1007.29998779,30.00000000,0.00000000,140.00000000, _,10, _, 200.0); //object(shop_sec_cam) (2)
	CreateDynamicObject(2611,268.47473145,116.05200195,1005.25000000,0.00000000,0.00000000,180.00000000, _,10, _, 200.0); //object(police_nb1) (1)
	CreateDynamicObject(4100,232.84960938,128.50000000,1011.91998291,0.00000000,0.00000000,49.99877930, _,10, _, 200.0); //object(meshfence1_lan) (4)
	CreateDynamicObject(2595,226.24514771,120.27544403,1011.28753662,0.00000000,0.00000000,77.72994995, _,10, _, 200.0); //object(cj_shop_tv_video) (2)
	CreateDynamicObject(3934,1563.90014648,-1700.00000000,27.40211487,0.00000000,0.00000000,0.00000000, 0, 0, _, 200.0); //object(helipad01) (2)
	CreateDynamicObject(1496,1564.14257812,-1667.36914062,27.39560699,0.00000000,0.00000000,0.00000000, 0, 0, _, 200.0); //object(gen_doorshop02) (1)
	CreateDynamicObject(2953,228.27796936,125.20470428,1010.14331055,0.00000000,0.00000000,143.45983887, _,10, _, 200.0); //object(kmb_paper_code) (1)
	CreateDynamicObject(4100,239.60000610,113.19999695,1010.50000000,319.99877930,90.00000000,90.00000000, _,10, _, 200.0); //object(pol_comp_gate) (1)
	CreateDynamicObject(2054,263.76342773,112.13343811,1004.64001465,0.00000000,0.00000000,36.00000000, _,10, _, 200.0); //object(cj_capt_hat) (1)
	CreateDynamicObject(2053,264.10845947,112.14072418,1004.66998291,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(cj_jerry_hat) (1)
	CreateDynamicObject(351,262.85000610352,111.90000152588,1004.6599731445,275,90,106, _,10, _, 200.0); //object(cj_m16) (2)
	CreateDynamicObject(2040,262.57006836,112.05036163,1004.72113037,0.00000000,0.00000000,342.13513184, _,10, _, 200.0); //object(ammo_box_m1) (1)
	CreateDynamicObject(2068,264.29998779,109.19999695,1007.00000000,0.00000000,0.00000000,90.00000000, _,10, _, 200.0); //object(cj_cammo_net) (1)
	CreateDynamicObject(1516,272.90374756,118.44168854,1003.79998779,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(dyn_table_03) (1)
	CreateDynamicObject(1810,272.74725342,117.44008636,1003.61718750,0.00000000,0.00000000,183.70996094, _,10, _, 200.0); //object(cj_foldchair) (1)
	CreateDynamicObject(1810,273.19308472,119.28445435,1003.61718750,0.00000000,0.00000000,2.00000000, _,10, _, 200.0); //object(cj_foldchair) (2)
	CreateDynamicObject(2953,272.84149170,118.41313934,1004.34997559,0.00000000,0.00000000,89.00000000, _,10, _, 200.0); //object(kmb_paper_code) (2)
	CreateDynamicObject(2953,272.89001465,118.30000305,1004.34997559,0.00000000,0.00000000,13.00000000, _,10, _, 200.0); //object(kmb_paper_code) (3)
	CreateDynamicObject(2196,273.04998779,118.69999695,1004.32000732,0.00000000,0.00000000,335.00000000, _,10, _, 200.0); //object(work_lamp1) (2)
	CreateDynamicObject(1886,228.80000305,116.00000000,1002.20001221,10.00000000,0.00000000,290.00000000, _,10, _, 200.0); //object(shop_sec_cam) (3)
	CreateDynamicObject(1491,265.17999268,112.68000031,1007.82000732,0.00000000,0.00000000,270.00000000, _,10, _, 200.0); //object(gen_doorint01) (4)
	CreateDynamicObject(2954,224.00000000,107.40000153,998.70062256,0.00000000,90.00000000,89.99993896, _,10, _, 200.0); //object(kmb_ot) (1)
	CreateDynamicObject(2954,228.19999695,107.39941406,998.70062256,0.00000000,90.00000000,90.00000000, _,10, _, 200.0); //object(kmb_ot) (2)
	CreateDynamicObject(2954,220.09960938,107.39941406,998.70062256,0.00000000,90.00000000,89.99996948, _,10, _, 200.0); //object(kmb_ot) (3)
	CreateDynamicObject(2954,216.10000610,107.39941406,998.70062256,0.00000000,90.00000000,90.00000000, _,10, _, 200.0); //object(kmb_ot) (4)
	CreateDynamicObject(1235,225.47909546,121.89310455,1009.72180176,0.00000000,0.00000000,0.00000000, _,10, _, 200.0); //object(wastebin) (1)
	CreateDynamicObject(2602,226.00000000,108.50000000,998.53906250,0.00000000,0.00000000,90.00000000, _,10, _, 200.0); //object(police_cell_toilet) (1)
	CreateDynamicObject(2602,214.00000000,108.50000000,998.53906250,0.00000000,0.00000000,90.00000000, _,10, _, 200.0); //object(police_cell_toilet) (2)
	CreateDynamicObject(2602,222.09960938,108.50000000,998.53906250,0.00000000,0.00000000,90.00000000, _,10, _, 200.0); //object(police_cell_toilet) (3)
	CreateDynamicObject(2602,218.10000610,108.50000000,998.53906250,0.00000000,0.00000000,90.00000000, _,10, _, 200.0); //object(police_cell_toilet) (4)
	CreateDynamicObject(8167,218.50000000,112.50000000,999.20001221,0.00000000,0.00000000,90.00000000, _,10, _, 200.0); //object(apgate1_vegs01) (1)
	CreateDynamicObject(8167,226.34960938,112.50000000,999.20001221,0.00000000,0.00000000,90.00000000, _,10, _, 200.0); //object(apgate1_vegs01) (2)
	CreateDynamicObject(3785,215.50000000,109.90000153,1001.40997314,0.00000000,90.00000000,0.00000000, _,10, _, 200.0); //object(bulkheadlight) (1)
	CreateDynamicObject(3785,219.50000000,109.89941406,1001.40997314,0.00000000,90.00000000,0.00000000, _,10, _, 200.0); //object(bulkheadlight) (2)
	CreateDynamicObject(3785,223.50000000,109.89941406,1001.40997314,0.00000000,90.00000000,0.00000000, _,10, _, 200.0); //object(bulkheadlight) (3)
	CreateDynamicObject(3785,227.50000000,109.89941406,1001.40997314,0.00000000,90.00000000,0.00000000, _,10, _, 200.0); //object(bulkheadlight) (4)

	/* Exterior LSPD objects */
	CreateDynamicObject(3934,1563.89941406,-1650.34277344,27.40211487,0.00000000,0.00000000,0.00000000, 0, 0, _, 200.0); //object(helipad01) (2)
	CreateDynamicObject(1496,1563.84997559,-1671.13000488,51.45027542,0.00000000,0.00000000,0.00000000, 0, 0, _, 200.0); //object(gen_doorshop02) (2)
	CreateDynamicObject(982,1577.75000000,-1701.50000000,28.07836533,0.00000000,0.00000000,0.00000000, 0, 0, _, 200.0); //object(fence) (1)
	CreateDynamicObject(982,1577.75000000,-1650.30004883,28.07836533,0.00000000,0.00000000,0.00000000, 0, 0, _, 200.0); //object(fence) (3)
	CreateDynamicObject(982,1565.00000000,-1637.50000000,28.07836533,0.00000000,0.00000000,90.00000000, 0, 0, _, 200.0); //object(fence) (4)
	CreateDynamicObject(984,1549.02502441,-1637.50000000,28.03879547,0.00000000,0.00000000,90.00000000, 0, 0, _, 200.0); //object(fence2) (1)
	CreateDynamicObject(982,1565.00000000,-1714.30004883,28.07836533,0.00000000,0.00000000,90.00000000, 0, 0, _, 200.0); //object(fencet) (5)
	CreateDynamicObject(982,1577.75000000,-1675.89941406,28.07836533,0.00000000,0.00000000,0.00000000, 0, 0, _, 200.0); //object(fencest) (6)
	CreateDynamicObject(984,1549.02441406,-1714.29980469,28.03879547,0.00000000,0.00000000,90.00000000, 0, 0, _, 200.0); //object(fenceshit2) (3)
	CreateDynamicObject(983,1550.59997559,-1701.50000000,28.07836533,0.00000000,0.00000000,90.00000000, 0, 0, _, 200.0); //object(fenceshit3) (2)
	CreateDynamicObject(984,1542.59960938,-1643.89941406,28.03879547,0.00000000,0.00000000,0.00000000, 0, 0, _, 200.0); //object(fenceshit2) (6)
	CreateDynamicObject(983,1545.79980469,-1701.50000000,28.07836533,0.00000000,0.00000000,90.00000000, 0, 0, _, 200.0); //object(fenceshit3) (3)
	CreateDynamicObject(983,1550.59997559,-1650.30004883,28.07836533,0.00000000,0.00000000,90.00000000, 0, 0, _, 200.0); //object(fenceshit3) (4)
	CreateDynamicObject(983,1545.79980469,-1650.30004883,28.07836533,0.00000000,0.00000000,90.00000000, 0, 0, _, 200.0); //object(fenceshit3) (5)
	CreateDynamicObject(984,1542.59960938,-1707.89941406,28.03879547,0.00000000,0.00000000,0.00000000, 0, 0, _, 200.0); //object(fenceshit2) (7)
	CreateDynamicObject(984,1553.80004883,-1695.09997559,28.03000069,0.00000000,0.00000000,0.00000000, 0, 0, _, 200.0); //object(fenceshit2) (8)
	CreateDynamicObject(984,1553.79980469,-1656.69995117,28.03000069,0.00000000,0.00000000,0.00000000, 0, 0, _, 200.0); //object(fenceshit2) (9)
	CreateDynamicObject(983,1544.69995117,-1620.58996582,13.02000046,0.00000000,0.00000000,0.00000000); //object(fenceshit3) (1)
	CreateDynamicObject(1331,1544.54602051,-1616.99133301,13.10000038,0.00000000,0.00000000,0.00000000); //object(binnt01_la) (1)
	CreateDynamicObject(2952,1582.00000000,-1637.88598633,12.39045906,0.00000000,0.00000000,90.00000000); //object(kmb_gimpdoor) (1)
	CreateDynamicObject(983,1544.69921875,-1636.00000000,13.02000046,0.00000000,0.00000000,0.00000000); //object(fenceshit3) (6)
	CreateDynamicObject(2952,1582.00000000,-1638.30004883,12.39045906,0.00000000,0.00000000,90.00000000); //object(kmb_gimpdoor) (2)

	/* Moar crap */
	CreateDynamicObject(2842,2320.79003906,-1021.39941406,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (2)
	CreateDynamicObject(2842,2320.79003906,-1023.19921875,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (3)
	CreateDynamicObject(2842,2320.79003906,-1025.00000000,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (4)
	CreateDynamicObject(2842,2319.87500000,-1019.59997559,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (5)
	CreateDynamicObject(2842,2319.87500000,-1017.79998779,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (6)
	CreateDynamicObject(2842,2319.87500000,-1016.00000000,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (7)
	CreateDynamicObject(2842,2319.87500000,-1014.20001221,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (8)
	CreateDynamicObject(2842,2319.87500000,-1012.40002441,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (9)
	CreateDynamicObject(2842,2319.87500000,-1010.59997559,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (10)
	CreateDynamicObject(2842,2320.79003906,-1010.59960938,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (11)
	CreateDynamicObject(2842,2320.79003906,-1012.39941406,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (12)
	CreateDynamicObject(2842,2320.79003906,-1014.19921875,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (13)
	CreateDynamicObject(2842,2320.79003906,-1016.00000000,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (14)
	CreateDynamicObject(2842,2320.79003906,-1017.79980469,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (15)
	CreateDynamicObject(2842,2320.79003906,-1019.59960938,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (16)
	CreateDynamicObject(2842,2319.87500000,-1021.39941406,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (17)
	CreateDynamicObject(2842,2319.87500000,-1023.19921875,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (18)
	CreateDynamicObject(2842,2319.87500000,-1025.00000000,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_bedrug04) (19)
	CreateDynamicObject(2069,2322.39306641,-1007.62664795,1049.30004883,0.00000000,0.00000000,0.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(cj_mlight7) (1)
	CreateDynamicObject(2297,2322.41992188,-1018.77001953,1049.21997070,0.00000000,0.00000000,356.03002930, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(tv_unit_2) (1)
	CreateDynamicObject(2069,2322.28906250,-1021.15917969,1049.26501465,0.00000000,0.00000000,0.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(cj_mlight7) (2)
	CreateDynamicObject(2073,2319.97973633,-1013.20001221,1052.93005371,0.00000000,0.00000000,0.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(cj_mlight1) (1)
	CreateDynamicObject(2332,2328.48388672,-1016.84997559,1054.50000000,0.00000000,0.00000000,180.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(kev_safe) (1)
	CreateDynamicObject(2833,2325.89990234,-1010.70001221,1053.71875000,0.00000000,0.00000000,0.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_livingrug02) (1)
	CreateDynamicObject(1210,2322.50390625,-1009.73980713,1054.77001953,90.00000000,0.00000000,23.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(briefcase) (1)
	CreateDynamicObject(1742,2323.39990234,-1006.62500000,1053.70996094,0.00000000,0.00000000,0.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(med_bookshelf) (1)
	CreateDynamicObject(2894,2322.46752930,-1009.14672852,1054.67187500,0.00000000,0.00000000,89.73001099, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(kmb_rhymesbook) (1)
	CreateDynamicObject(1502,2321.91992188,-1023.88201904,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gen_doorint04) (1)
	CreateDynamicObject(1502,2317.95996094,-1013.89001465,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gen_doorint04) (2)
	CreateDynamicObject(1502,2321.91992188,-1013.88964844,1049.21093750,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gen_doorint04) (3)
	CreateDynamicObject(2069,2316.20019531,-1026.69848633,1049.25000000,0.00000000,0.00000000,0.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(cj_mlight7) (2)
	CreateDynamicObject(2267,2322.00000000,-1010.00000000,1051.36096191,0.00000000,0.00000000,90.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(frame_wood_3) (1)
	CreateDynamicObject(2813,2326.06225586,-1016.13732910,1050.25781250,0.00000000,0.00000000,308.25524902, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(gb_novels01) (1)
	CreateDynamicObject(1667,2324.96020508,-1011.50372314,1049.79870605,0.00000000,0.00000000,0.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(propwineglass1) (1)
	CreateDynamicObject(1667,2324.88867188,-1011.38964844,1049.79870605,0.00000000,0.00000000,0.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(propwineglass1) (2)
	CreateDynamicObject(1665,2324.96142578,-1011.71868896,1049.72058105,0.00000000,0.00000000,0.00000000, HOUSE_VIRTUAL_WORLD + 6, 9, _, 200.0); //object(propashtray1) (1)

	/* LSPD interior additions */
	CreateDynamicObject(1742,239.44921875,109.50000000,1009.21179199,0.00000000,0.00000000,270.26916504, _, 10, _, 200.0); //object(med_bookshelf) (1)
	CreateDynamicObject(2259,233.53700256,111.30000305,1010.52191162,0.00000000,0.00000000,90.00000000, _, 10, _, 200.0); //object(frame_clip_6) (1)
	CreateDynamicObject(1510,237.27488708,110.47866058,1010.05999756,0.00000000,0.00000000,0.00000000, _, 10, _, 200.0); //object(dyn_ashtry) (1)
	CreateDynamicObject(3044,237.19999695,110.61499786,1010.16998291,25.00000000,0.00000000,0.00000000, _, 10, _, 200.0); //object(cigar) (2)
	CreateDynamicObject(2894,237.23359680,109.39933777,1010.05700684,0.00000000,0.00000000,105.56491089, _, 10, _, 200.0); //object(kmb_rhymesbook) (1)
	CreateDynamicObject(16780,236.00000000,110.00000000,1012.85998535,0.00000000,0.00000000,0.00000000, _, 10, _, 200.0); //object(ufo_light03) (2)
	CreateDynamicObject(1744,237.30000305,113.25000000,1010.70001221,0.00000000,0.00000000,0.00000000, _, 10, _, 200.0); //object(med_shelf) (1)
	CreateDynamicObject(1235,238.86370850,112.72632599,1009.72180176,0.00000000,0.00000000,0.00000000, _, 10, _, 200.0); //object(wastebin) (1)
	CreateDynamicObject(1520,237.29576111,110.73871613,1010.05700684,0.00000000,0.00000000,0.00000000, _, 10, _, 200.0); //object(dyn_wine_bounce) (1)
	CreateDynamicObject(1742,239.44921875,108.06933594,1009.21179199,0.00000000,0.00000000,270.26916504, _, 10, _, 200.0); //object(med_bookshelf) (1)
	CreateDynamicObject(2833,238.00000000,109.40000153,1009.22998047,0.00000000,0.00000000,90.00000000, _, 10, _, 200.0); //object(gb_livingrug02) (1)
	CreateDynamicObject(2813,237.22207642,112.88127136,1011.04052734,0.00000000,0.00000000,0.00000000, _, 10, _, 200.0); //object(gb_novels01) (1)
	CreateDynamicObject(2332,239.60000610,111.50000000,1011.04998779,0.00000000,0.00000000,270.00000000, _, 10, _, 200.0); //object(kev_safe) (1)
	CreateDynamicObject(2558,238.82000732,112.00000000,1010.50000000,0.00000000,0.00000000,270.00000000, _, 10, _, 200.0); //object(curtain_1_closed) (1)
	CreateDynamicObject(2289,237.42500305,107.12000275,1011.24859619,0.00000000,0.00000000,179.99450684, _, 10, _, 200.0); //object(frame_2) (1)
	CreateDynamicObject(2267,231.40335083,128.39999390,1011.29760742,0.00000000,0.00000000,0.00000000, _, 10, _, 200.0); //object(frame_wood_3) (1)
	CreateDynamicObject(2894,229.15087891,125.28470612,1010.13958740,0.00000000,0.00000000,0.00000000, _, 10, _, 200.0); //object(kmb_rhymesbook) (2)

	/* LSPD 3D Text Labels */
	CreateDynamic3DTextLabel("Department building elevator\n(/elevator)", COLOR_YELLOW, 276.0980, 122.1232, 1004.6172, 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
	CreateDynamic3DTextLabel("Upper roof elevator\n(/elevator)", COLOR_YELLOW, 1564.6584,-1670.2607,52.4503, 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
	CreateDynamic3DTextLabel("Lower roof elevator\n(/elevator)", COLOR_YELLOW, 1564.8, -1666.2, 28.3, 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
	CreateDynamic3DTextLabel("Police garage elevator\n(/elevator)", COLOR_YELLOW, 1568.6676, -1689.9708, 6.2188, 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);

	/* -------------------------------------- END OF RAEP. -------------------------------------- */

	print("-----------------------------------------------------------------");
	print("Script: Vortex Roleplay 2 by Calgon and Brian.");
	print("Status: Loaded OnGameModeInit, running version "SERVER_VERSION);
	print("-----------------------------------------------------------------");
	
	if(strfind(SERVER_VERSION, "BETA", true) != -1) {
	    print("-----------------------------------------------------------------");
	    print("WARNING: You are running a BETA version of the script.");
	    print("WARNING: This script is not optimized (or specifically built) for public usage yet.");
	    print("-----------------------------------------------------------------");
	}
	
	return 1;
}

#if !defined NO_IRC
public IRCBotDelay() {
	scriptBots[0] = IRC_Connect(IRC_SERVER, IRC_PORT, "YOURBOTNAME", "Maurice Moss", "VXRP2SCRIPT");
	return 1;
}

public IRC_OnConnect(botid) {
    IRC_SendRaw(scriptBots[0], "PRIVMSG NickServ :IDENTIFY "IRC_BOT_PASS);
    IRC_JoinChannel(scriptBots[0], IRC_CHANNEL_MAIN);
    IRC_JoinChannel(scriptBots[0], IRC_STAFF_CHANNEL, IRC_STAFF_CHANNEL_PASSWORD);
	return 1;
}

public IRC_OnJoinChannel(botid, channel[]) {
	if(!strcmp(channel, IRC_CHANNEL_MAIN, true))
		IRC_Say(scriptBots[0], IRC_CHANNEL_MAIN, "Server started. Release: "SERVER_VERSION".");

	return 1;
}

public IRC_OnLeaveChannel(botid, channel[], message[]) {
	if(!strcmp(channel, IRC_CHANNEL_MAIN)) {
	    IRC_JoinChannel(scriptBots[0], IRC_CHANNEL_MAIN);
	} else if(!strcmp(channel, IRC_STAFF_CHANNEL)) {
	    IRC_JoinChannel(scriptBots[0], IRC_STAFF_CHANNEL, IRC_STAFF_CHANNEL_PASSWORD);
	}
	
	return 1;
}

public IRC_OnDisconnect(botid) {
	return SetTimer("IRCBotDelay", 5000, false);
}

public IRC_OnUserSay(botid, recipient[], user[], host[], message[]) {
	if(systemVariables[OOCStatus] == 0) {
	    if(!strcmp(recipient, IRC_CHANNEL_MAIN, true)) {
	  		format(szMessage, sizeof(szMessage), "(( %s says [on IRC]: %s ))", user, message);

			foreach(Player, x) {
				if(playerVariables[x][pSeeOOC] == 1) {
				    GetPlayerName(x, szPlayerName, MAX_PLAYER_NAME);
				    if(strfind(szPlayerName, message, true, 0) != -1) {
						SendClientMessage(x, COLOR_LIGHT, szMessage);
						PlayerPlaySound(x, 1057, 0, 0, 0);
					}
					else {
					    SendClientMessage(x, COLOR_LIGHT, szMessage);
					}
				}
			}
		}
		else if(!strcmp(recipient, IRC_STAFF_CHANNEL, true)) {
		    format(szMessage, sizeof(szMessage), "* Admin %s says [on IRC]: %s", user, message);
		    submitToAdmins(szMessage, COLOR_YELLOW);
		}
	}
	return 1;
}
#endif

stock loadATMs() {
	mysql_query("SELECT * FROM atms", THREAD_LOAD_ATMS);
	return 1;
}

stock unixTimeConvert(timestamp, compare = -1) 
{
    if(compare == -1)
		compare = gettime();

    new n, returnstr[32];
        Float:d = (timestamp > compare) ? (timestamp - compare) : (compare - timestamp);

	if(d < 60)
	{
		returnstr = "< 1 minute";
		return returnstr;
	}
	else if(d < 3600)
		n = floatround(floatdiv(d, 60.0), floatround_floor), returnstr = "minute";
	else if(d < 86400)
		n = floatround(floatdiv(d, 3600.0), floatround_floor), returnstr = "hour";
	else if(d < 2592000)
		n = floatround(floatdiv(d, 86400.0), floatround_floor), returnstr = "day";
	else if(d < 31536000)
		n = floatround(floatdiv(d, 2592000.0), floatround_floor), returnstr = "month";
	else
		n = floatround(floatdiv(d, 31536000.0), floatround_floor), returnstr = "year";
	
	if(n == 1)
		format(returnstr, sizeof(returnstr), "1 %s", returnstr);
    else
        format(returnstr, sizeof(returnstr), "%d %ss", n, returnstr);
	
    return returnstr;
}

public genderSelection(const playerid) {
	return ShowPlayerDialog(playerid, DIALOG_GENDER_SELECTION, DIALOG_STYLE_MSGBOX, "SERVER: Gender Selection", "What sex/gender is your character?", "Male", "Female");
}

public OnPlayerShootPlayer(Shooter,Target,Float:HealthLost,Float:ArmourLost) {
	if(playerVariables[Shooter][pTazer] == 1 && groupVariables[playerVariables[Shooter][pGroup]][gGroupType] == 1 && playerVariables[Shooter][pGroup] != 0 && GetPlayerWeapon(Shooter) == 22) {
	    if(IsPlayerInAnyVehicle(Target) || IsPlayerInAnyVehicle(Shooter))
	        return 1;

		if(groupVariables[playerVariables[Target][pGroup]][gGroupType] == 1 && playerVariables[Target][pGroup] != 0)
		    return 1;

		new
		    playerNames[2][MAX_PLAYER_NAME];

		GetPlayerName(Shooter, playerNames[0], MAX_PLAYER_NAME);
		GetPlayerName(Target, playerNames[1], MAX_PLAYER_NAME);

		TogglePlayerControllable(Target, 0);
		playerVariables[Target][pFreezeTime] = 15;
		playerVariables[Target][pFreezeType] = 1;
		GameTextForPlayer(Target, "~n~~r~ Tazed!",4000, 4);

		format(szMessage, sizeof(szMessage), "* %s fires their tazer at %s, stunning them.", playerNames[0], playerNames[1]);
		nearByMessage(Shooter, COLOR_PURPLE, szMessage);
		format(szMessage, sizeof(szMessage), "You have successfully stunned %s.", playerNames[1]);
		SendClientMessage(Shooter, COLOR_NICESKY, szMessage);
		ApplyAnimation(Target,"CRACK","crckdeth2",4.1,0,1,1,1,1,1);
	}
	return 1;
}

public playerTabbedLoop() {
	foreach(Player, x) {
	    if(playerVariables[x][pTabbed] == 0 && IsValidDynamic3DTextLabel(playerVariables[x][pAFKLabel]))
			DestroyDynamic3DTextLabel(playerVariables[x][pAFKLabel]);

	    playerVariables[x][pConnectedSeconds] += 1;

	    if(playerVariables[x][pConnectedSeconds] < gettime()-1 && playerVariables[x][pTabbed] != 1 && playerVariables[x][pConnectedSeconds] >= 5 && GetPlayerState(x) != 9 && GetPlayerState(x) != 0 && GetPlayerState(x) != 7) {
	        playerVariables[x][pTabbed] = 1;
	        playerVariables[x][pAFKLabel] = CreateDynamic3DTextLabel("Paused.", COLOR_RED, 0, 0, 0, 7.5, x, _, 1, _, _, _, 7.5);
	    }
	}
	return 1;
}

public restartTimer() {
	iGMXTick--;

	switch(iGMXTick) {
	    case 0: {
		    SendClientMessageToAll(COLOR_LIGHTRED, "AdmCmd:{FFFFFF} The server is now restarting...");

			mysql_close();
			KillTimer(iGMXTimer);

			SendRconCommand("gmx");
	    }
	    case 1: GameTextForAll("~w~The server will restart...~n~ ~r~NOW!", 1110, 5);
	    case 2: GameTextForAll("~w~The server will restart in...~n~ ~r~2~w~ seconds.", 1110, 5);
	    case 3: GameTextForAll("~w~The server will restart in...~n~ ~r~3~w~ seconds.", 1110, 5);
	    case 4: GameTextForAll("~w~The server will restart in...~n~ ~r~4~w~ seconds.", 1110, 5);
	    case 5: GameTextForAll("~w~The server will restart in...~n~ ~r~5~w~ seconds.", 1110, 5);
	}

	return 1;
}

AntiDeAMX() {
    new a[][] = {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused a
}

public OnPlayerCommandReceived(playerid, cmdtext[]) {
	#if defined DEBUG
	    printf("[debug] OnPlayerCommandReceived(%d, %s)", playerid, cmdtext);
	#endif
	
	if(GetPVarInt(playerid, "pAdminFrozen") == 1)
	    Kick(playerid);
	
	GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

	if(playerVariables[playerid][pStatus] != 1)
	    return 0;

	printf("[server] [cmd] %s (ID %d): %s", szPlayerName, playerid, cmdtext);

	if(playerVariables[playerid][pMuted] > 0) {
		SendClientMessage(playerid, COLOR_GREY, "You cannot submit any commands or text at the moment, as you have been muted.");
		return 0;
	}

	playerVariables[playerid][pSpamCount]++;

	new
		charCount[3];

	for(new i; i < strlen(cmdtext); i++) switch(cmdtext[i]) {
		case '0' .. '9': charCount[0]++;
		case '.': charCount[1]++;
		case ':': charCount[2]++;
	}

	if(charCount[0] > 8 && charCount[1] >= 3 && charCount[2] >= 1 && playerVariables[playerid][pAdminLevel] < 1) {
		format(szMessage, sizeof(szMessage),"Warning: {FFFFFF}%s may be server advertising: '%s'.", szPlayerName, cmdtext);
		submitToAdmins(szMessage, COLOR_HOTORANGE);
		return 0;
	}
	return 1;
}

public OnVehicleSpawn(vehicleid) {
	#if defined DEBUG
	    printf("[debug] OnVehicleSpawn(%d)", vehicleid);
	#endif
	
	switch(GetVehicleModel(vehicleid)) {
		case 427, 428, 432, 601, 528: SetVehicleHealth(vehicleid, 5000.0); // Enforcer, Securicar, Rhino, SWAT Tank, FBI truck - this is the armour plating dream come true.
	}
	return 1;
}

public OnVehicleDeath(vehicleid, killerid) {
	#if defined DEBUG
	    printf("[debug] OnVehicleDeath(%d, %d)", vehicleid, killerid);
	#endif
	
	return 1;
}

stock encode_lights(light1, light2, light3, light4) {
    return light1 | (light2 << 1) | (light3 << 2) | (light4 << 3);
}

stock encode_doors(bonnet, boot, driver_door, passenger_door) {
    return bonnet | (boot << 8) | (driver_door << 16) | (passenger_door << 24);
}

stock encode_panels(flp, frp, rlp, rrp, windshield, front_bumper, rear_bumper) {
    return flp | (frp << 4) | (rlp << 8) | (rrp << 12) | (windshield << 16) | (front_bumper << 20) | (rear_bumper << 24);
}

public ShutUp(slot) { // One function for eight doors. A WINRAR IS YOU!
	if(LSPDObjs[slot][2] == 1) switch(slot) {
		case 0: {
			MoveDynamicObject(LSPDObjs[0][0],232.89999390,107.57499695,1009.21179199,3.5); //commander south
			MoveDynamicObject(LSPDObjs[0][1],232.89941406,110.57499695,1009.21179199,3.5); //commander north
			LSPDObjs[0][2] = 0;
		}
		case 1: {
			MoveDynamicObject(LSPDObjs[1][0],275.75000000,118.89941406,1003.61718750,3.5); // interrogation north
			MoveDynamicObject(LSPDObjs[1][1],275.75000000,115.89941406,1003.61718750,3.5); // interrogation south
			LSPDObjs[1][2] = 0;
		}
		case 2: {
			MoveDynamicObject(LSPDObjs[2][0],253.20410156,107.59960938,1002.22070312,3.5); // north west lobby door
			MoveDynamicObject(LSPDObjs[2][1],253.19921875,110.59960938,1002.22070312,3.5); // north east lobby door
			LSPDObjs[2][2] = 0;
		}
		case 3: {
			MoveDynamicObject(LSPDObjs[3][0],239.56933594,116.09960938,1002.22070312,3.5); // south west lobby door
			MoveDynamicObject(LSPDObjs[3][1],239.56445312,119.09960938,1002.22070312,3.5); // south east lobby door
			LSPDObjs[3][2] = 0;
		}
		case 4: {
			MoveDynamicObject(LSPDObjs[4][0],264.45019531,115.82421875,1003.62286377,3.5); //object(gen_doorext15) (3)
			MoveDynamicObject(LSPDObjs[4][1],267.45214844,115.82910156,1003.62286377,3.5); //object(gen_doorext15) (8)
			LSPDObjs[4][2] = 0;
		}
		case 5: {
			MoveDynamicObject(LSPDObjs[5][0],267.32000732,112.53222656,1003.62286377,3.5); //object(gen_doorext15) (4)
			MoveDynamicObject(LSPDObjs[5][1],264.32000732,112.52929688,1003.62286377,3.5); //object(gen_doorext15) (5)
			LSPDObjs[5][2] = 0;
		}
		case 6: {
			MoveDynamicObject(LSPDObjs[6][0],229.59960938,119.52929688,1009.22442627,3.5); //object(gen_doorext15) (9)
			MoveDynamicObject(LSPDObjs[6][1],232.59960938,119.53515625,1009.22442627,3.5); //object(gen_doorext15) (10)
			LSPDObjs[6][2] = 0;
		}
		case 7: {
			MoveDynamicObject(LSPDObjs[7][0],219.30000305,116.52999878,998.01562500,3.5); //cell east door
			MoveDynamicObject(LSPDObjs[7][1],216.30000305,116.52929688,998.01562500,3.5); //cell west door
			LSPDObjs[7][2] = 0;
		}
	}
	return 1;
}
public AFKTimer() {
	foreach(Player, i) {
	    if(playerVariables[i][pAdminLevel] < 1) {
			GetPlayerPos(i, PlayerPos[i][0], PlayerPos[i][1], PlayerPos[i][2]);

			if(PlayerPos[i][0] == PlayerPos[i][3] && PlayerPos[i][1] == PlayerPos[i][4] && PlayerPos[i][2] == PlayerPos[i][5]) {
			    savePlayerData(i);
			    
	    		if(playerVariables[i][pCarModel] >= 1)
					DestroyVehicle(playerVariables[i][pCarID]);
					
			    playerVariables[i][pStatus] = 0;
				RemovePlayerFromVehicle(i);
			    SendClientMessage(i, COLOR_GREY, "You have been logged out due to inactivity.");
			    ShowPlayerDialog(i, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "SERVER: Login", "Welcome to the "SERVER_NAME" Server.\n\nPlease enter your password below!", "Login", "Cancel");
			}

			PlayerPos[i][3] = PlayerPos[i][0];
			PlayerPos[i][4] = PlayerPos[i][1];
			PlayerPos[i][5] = PlayerPos[i][2];
		}
	}

	return 1;
}

public OnGameModeExit() {
	#if defined DEBUG
	    print("[debug] OnGameModeInit()");
	#endif
	
	new
	    x;

	while(x < MAX_TIMERS) {
	    KillTimer(scriptTimers[x]);
		x++;
	}

	mysql_close(databaseConnection);

	return 1;
}

stock GetWeaponSlot(weaponid) {
	switch(weaponid) {
		case 0, 1: return 0;
		case 2 .. 9: return 1;
		case 22 .. 24: return 2;
		case 25 .. 27: return 3;
		case 28, 29, 32: return 4;
		case 30, 31: return 5;
		case 33, 34: return 6;
		case 35 .. 38: return 7;
		case 16, 17, 18, 39, 40: return 8;
		case 41 .. 43: return 9;
		case 10 .. 15: return 10;
		case 44 .. 46: return 11;
	}
	return -1;
}

stock PlayerPlaySoundEx(soundid, Float:x, Float:y, Float:z) { // Realistic sound playback
	foreach(Player, i) {
		if(IsPlayerInRangeOfPoint(i, 30.0, x, y, z))
			PlayerPlaySound(i, soundid, x, y, z);
	}

	return 1;
}

stock GetClosestPlayer(const playerid) {
    new
		Float:Distance,
		target = -1;

    foreach(Player, i) {
        if (playerid != i && playerVariables[i][pSpectating] == INVALID_PLAYER_ID && (target < 0 || Distance > GetDistanceBetweenPlayers(playerid, i))) {
            target = i;
            Distance = GetDistanceBetweenPlayers(playerid, i);
        }
    }
    return target;
}

stock GetClosestVehicle(playerid, exception = INVALID_VEHICLE_ID) {
    new
		Float:Distance,
		target = -1;

    for(new v; v < MAX_VEHICLES; v++) if(doesVehicleExist(v)) {
        if(v != exception && (target < 0 || Distance > GetDistancePlayerVeh(playerid, v))) {
            target = v;
            Distance = GetDistancePlayerVeh(playerid, v);
        }
    }
    return target;
}

stock checkVehicleSeat(vehicleid, seatid) {
	foreach(Player, x) {
	    if(GetPlayerVehicleID(x) == vehicleid && GetPlayerVehicleSeat(x) == seatid) return 1;
	}
	return 0;
}

stock IsValidSkin(skinid) {
	if(skinid < 0 || skinid > 299)
		return false;

	switch(skinid) {
		case 3, 4, 5, 6, 8, 42, 65, 74, 86, 119, 149, 208, 268, 273, 289: return false;
	}
	return true;
}

stock IsPublicSkin(skinid) {
	if(!IsValidSkin(skinid)) return false;

	switch(skinid) {
		case 274 .. 288, 265 .. 267, 71: return false;
	}
	return true;
}

public loginCheck(playerid) {
	// This function will be used to see if the query times out.
	
	// Ban check step
	if(GetPVarInt(playerid, "bcs") == 0) {
	    // If it's 0, we have a problem.
	    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "MySQL problem!", "You missed a step! Here's a list of the potential causes:\n\n- the MySQL connection details are invalid\n- the database dump wasn't imported correctly\n- an unexpected error ocurred\n\nPlease revisit the installation instructions.", "OK", "");
	}
	return 1;
}

public OnPlayerConnect(playerid) {
	#if defined DEBUG
	    printf("[debug] OnPlayerConnect(%d)", playerid);
	#endif
	
	/*
	(a) Attempts must be made to protect players from access to explicit content. If your
	server contains elements that may be considered only suitable for adults, your server
	must state this fact to the player when they first join.
	*/
	SendClientMessage(playerid, COLOR_LIGHTRED, "WARNING: This server contains explicit content which requires you to be 18+ to play here.");
	
    SetPlayerColor(playerid, COLOR_WHITE);
    resetPlayerVariables(playerid);

    GetPlayerIp(playerid, playerVariables[playerid][pConnectionIP], 16);

	// Query if the player is banned or not, then continue with other auth code after the thread goes through
    format(szMessage, sizeof(szMessage), "SELECT `banID` FROM `bans` WHERE `IPBanned` = '%s'", playerVariables[playerid][pConnectionIP]);
    mysql_query(szMessage, THREAD_CHECK_BANS_LIST, playerid);
    
    SetTimerEx("loginCheck", 2000, false, "d", playerid);

    SetPlayerMapIcon(playerid, 10, 595.5443, -1250.3405, 18.2836, 52, 0);
	syncPlayerTime(playerid);
	SetPlayerWeather(playerid, weatherVariables[0]); // Keep it all in sync (weather bugged out sometimes until we fixed it this way).

	/* Mall object removal - 0.3d */
    // Remove the original mall mesh
	RemoveBuildingForPlayer(playerid, 6130, 1117.5859, -1490.0078, 32.7188, 10.0);

	// This is the mall mesh LOD
	RemoveBuildingForPlayer(playerid, 6255, 1117.5859, -1490.0078, 32.7188, 10.0);

	// There are some trees on the outside of the mall which poke through one of the interiors
	RemoveBuildingForPlayer(playerid, 762, 1175.3594, -1420.1875, 19.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 615, 1166.3516, -1417.6953, 13.9531, 0.25);
	return 1;
}

stock getIdFromName(const szPlayerName2[]) {
	new
		szEsc[24];

	mysql_real_escape_string(szPlayerName2, szEsc);
	format(szQueryOutput, sizeof(szQueryOutput), "SELECT `playerID` FROM `playeraccounts` WHERE `playerName` = '%e'", szEsc);
	mysql_query(szQueryOutput);
	mysql_store_result();
	print(szQueryOutput);

	if(mysql_num_rows() > 1) {
	    mysql_retrieve_row();
		new iResult = mysql_fetch_int();
		mysql_free_result();
		return iResult;
	} else return -1;
}

stock SendToGroup(groupid, colour, const string[]) {
	if(groupid > 0) {
		foreach(Player, i) {
			if(playerVariables[i][pStatus] == 1 && playerVariables[i][pGroup] == groupid) {
				SendClientMessage(i, colour, string);
			}
		}
	}
	return 1;
}

stock SendToEvent(const colour, const string[]) {
	foreach(Player, i) {
		if(playerVariables[i][pEvent] >= 1) SendClientMessage(i, colour, string);
	}
	return 1;
}

stock FetchLevelFromHours(const iHours) {
	switch(iHours) {
	    case 0..24: return 1;
	    case 25..48: return 2;
	    case 49..72: return 3;
	    case 73..100: return 4;
	    case 101..175: return 5;
	    case 176..200: return 6;
	    case 201..208: return 8;
	    case 209..336: return 9;
	    case 337..480: return 10;
	}
	return 0;
}

stock SendToFrequency(const frequency, const colour, const string[]) {
	if(frequency > 0) {
		foreach(Player, i) {
			if(playerVariables[i][pStatus] == 1 && playerVariables[i][pWalkieTalkie] == frequency) {
				SendClientMessage(i, colour, string);
			}
		}
	}
	return 1;
}

stock sendDepartmentMessage(const colour, const string[]) {
	foreach(Player, i) {
	    if(playerVariables[i][pStatus] == 1 && (groupVariables[playerVariables[i][pGroup]][gGroupType] == 1 || groupVariables[playerVariables[i][pGroup]][gGroupType] == 2)) {
	        SendClientMessage(i, colour, string);
		}
	}
	return 1;
}

stock IsKeyJustDown(key, newkeys, oldkeys) {
	if((newkeys & key) && !(oldkeys & key))
		return 1;

	return 0;
}

stock IsInvalidNOSVehicle(const modelid)
{
	switch(modelid)
	{
		case 581, 523, 462, 521, 463, 522, 461, 448, 468, 586, 509, 481, 510, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 590, 569, 537, 538, 570, 449: return true;
	}
	return false;
}

stock givePlayerValidWeapon(playerid, weapon) {
	switch(weapon) {
		case 0, 1: {
	        playerVariables[playerid][pWeapons][0] = weapon;
	        GivePlayerWeapon(playerid, weapon, 99999);
	    }
	    case 2, 3, 4, 5, 6, 7, 8, 9: {
	        playerVariables[playerid][pWeapons][1] = weapon;
	        GivePlayerWeapon(playerid, weapon, 99999);
	    }
	    case 22, 23, 24: {
	        playerVariables[playerid][pWeapons][2] = weapon;
	        GivePlayerWeapon(playerid, weapon, 99999);
	    }
	    case 25, 26, 27: {
	        playerVariables[playerid][pWeapons][3] = weapon;
	        GivePlayerWeapon(playerid, weapon, 99999);
	    }
	    case 28, 29, 32: {
	        playerVariables[playerid][pWeapons][4] = weapon;
	        GivePlayerWeapon(playerid, weapon, 99999);
	    }
	    case 30, 31: {
	        playerVariables[playerid][pWeapons][5] = weapon;
	        GivePlayerWeapon(playerid, weapon, 99999);
	    }
	    case 33, 34: {
	        playerVariables[playerid][pWeapons][6] = weapon;
	        GivePlayerWeapon(playerid, weapon, 99999);
	    }
	    case 35, 36, 37, 38: {
	        playerVariables[playerid][pWeapons][7] = weapon;
	        GivePlayerWeapon(playerid, weapon, 99999);
	    }
	    case 16, 17, 18, 39: {
	        playerVariables[playerid][pWeapons][8] = weapon;
	        GivePlayerWeapon(playerid, weapon, 99999);
	    }
	    case 41, 42, 43: {
	        playerVariables[playerid][pWeapons][9] = weapon;
	        GivePlayerWeapon(playerid, weapon, 99999);
	    }
	    case 10, 11, 12, 13, 14, 15: {
	        playerVariables[playerid][pWeapons][10] = weapon;
	        GivePlayerWeapon(playerid, weapon, 99999);
	    }
	    case 44, 45, 46: {
	        playerVariables[playerid][pWeapons][11] = weapon;
	        GivePlayerWeapon(playerid, weapon, 99999);
	    }
	    case 40: {
	        playerVariables[playerid][pWeapons][12] = weapon;
	        GivePlayerWeapon(playerid, weapon, 99999);
	    }
	}
	return 1;
}

stock GymMap() {
	/*
	    --- CUSTOM MAP ---
	    
		Credits to: Marcel_Collins
		Release thread: http://forum.sa-mp.com/showthread.php?p=1537421
	*/
	
	CreateDynamicObject(1257,2242.38281250,-1725.93640137,13.82606697,0.00000000,0.00000000,90.00000000); //object(bustopm)(1)
	CreateDynamicObject(1229,2240.03955078,-1727.28039551,14.10655499,0.00000000,0.00000000,88.00000000); //object(bussign1)(1)
	CreateDynamicObject(1215,2224.59545898,-1712.75476074,13.11704731,0.00000000,0.00000000,0.00000000); //object(bollardlight)(1)
	CreateDynamicObject(1215,2236.68701172,-1725.17114258,13.11119843,0.00000000,0.00000000,0.00000000); //object(bollardlight)(3)
	CreateDynamicObject(1215,2221.71606445,-1723.97021484,13.12682343,0.00000000,0.00000000,0.00000000); //object(bollardlight)(4)
	CreateDynamicObject(1215,2225.08544922,-1726.94616699,13.12256432,0.00000000,0.00000000,0.00000000); //object(bollardlight)(5) (5)
	CreateDynamicObject(996,2230.76025391,-1727.23754883,13.29563046,0.00000000,0.00000000,0.00000000); //object(lhouse_barrier1)(1)
	CreateDynamicObject(997,2238.22485352,-1727.02954102,12.54687500,0.00000000,0.00000000,88.00000000); //object(lhouse_barrier3)(2)
	CreateDynamicObject(997,2225.60278320,-1727.18811035,12.65393353,0.00000000,0.00000000,0.00000000); //object(lhouse_barrier3)(3)
	CreateDynamicObject(997,2222.02197266,-1724.68554688,12.56250000,0.00000000,0.00000000,318.00000000); //object(lhouse_barrier3)(4)
	CreateDynamicObject(997,2221.68579102,-1719.86242676,12.53577995,0.00000000,0.00000000,266.00000000); //object(lhouse_barrier3)(5)
	CreateDynamicObject(996,2221.84472656,-1718.27014160,13.26626015,0.00000000,0.00000000,84.00000000); //object(lhouse_barrier1)(2)
	CreateDynamicObject(997,2223.02758789,-1710.96203613,12.58030415,0.00000000,0.00000000,0.00000000); //object(lhouse_barrier3)(7)
	return 1;
}

stock LSMall() {
	CreateDynamicObject(19322,1117.58000000,-1490.01000000,32.72000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(19323,1117.58000000,-1490.01000000,32.72000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(19325,1155.40000000,-1434.89000000,16.49000000,0.00000000,0.00000000,0.30000000); //
	CreateDynamicObject(19325,1155.37000000,-1445.41000000,16.31000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(19325,1155.29000000,-1452.38000000,16.31000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(19325,1157.36000000,-1468.35000000,16.31000000,0.00000000,0.00000000,18.66000000); //
	CreateDynamicObject(19325,1160.64000000,-1478.37000000,16.31000000,0.00000000,0.00000000,17.76000000); //
	CreateDynamicObject(19325,1159.84000000,-1502.06000000,16.31000000,0.00000000,0.00000000,-19.92000000); //
	CreateDynamicObject(19325,1139.28000000,-1523.71000000,16.31000000,0.00000000,0.00000000,-69.36000000); //
	CreateDynamicObject(19325,1117.06000000,-1523.43000000,16.51000000,0.00000000,0.00000000,-109.44000000); //
	CreateDynamicObject(19325,1097.18000000,-1502.43000000,16.51000000,0.00000000,0.00000000,-158.58000000); //
	CreateDynamicObject(19325,1096.47000000,-1478.29000000,16.51000000,0.00000000,0.00000000,-197.94000000); //
	CreateDynamicObject(19325,1099.70000000,-1468.27000000,16.51000000,0.00000000,0.00000000,-197.94000000); //
	CreateDynamicObject(19325,1101.81000000,-1445.45000000,16.22000000,0.00000000,0.00000000,-180.24000000); //
	CreateDynamicObject(19325,1101.76000000,-1452.47000000,16.22000000,0.00000000,0.00000000,-181.62000000); //
	CreateDynamicObject(19325,1101.77000000,-1434.88000000,16.22000000,0.00000000,0.00000000,-180.24000000); //
	CreateDynamicObject(19325,1094.31000000,-1444.92000000,23.47000000,0.00000000,0.00000000,-180.24000000); //
	CreateDynamicObject(19325,1094.37000000,-1458.37000000,23.47000000,0.00000000,0.00000000,-179.46000000); //
	CreateDynamicObject(19325,1093.01000000,-1517.44000000,23.44000000,0.00000000,0.00000000,-138.72000000); //
	CreateDynamicObject(19325,1101.08000000,-1526.64000000,23.42000000,0.00000000,0.00000000,-137.34000000); //
	CreateDynamicObject(19325,1155.12000000,-1526.38000000,23.46000000,0.00000000,0.00000000,-42.12000000); //
	CreateDynamicObject(19325,1163.09000000,-1517.25000000,23.46000000,0.00000000,0.00000000,-40.74000000); //
	CreateDynamicObject(19325,1163.04000000,-1442.06000000,23.40000000,0.00000000,0.00000000,-0.12000000); //
	CreateDynamicObject(19325,1163.09000000,-1428.47000000,23.50000000,0.00000000,0.00000000,0.54000000); //
	CreateDynamicObject(19326,1155.34000000,-1446.73000000,16.38000000,0.00000000,0.00000000,-89.82000000); //
	CreateDynamicObject(19326,1155.25000000,-1443.85000000,16.36000000,0.00000000,0.00000000,-89.82000000); //
	CreateDynamicObject(19326,1155.37000000,-1436.32000000,16.36000000,0.00000000,0.00000000,-89.82000000); //
	CreateDynamicObject(19326,1155.35000000,-1433.51000000,16.36000000,0.00000000,0.00000000,-89.70000000); //
	CreateDynamicObject(19329,1155.18000000,-1440.22000000,18.70000000,0.00000000,0.00000000,89.04000000); //
	CreateDynamicObject(19329,1161.59000000,-1431.50000000,17.93000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(19329,1160.40000000,-1448.79000000,17.96000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(2543,1168.18000000,-1436.39000000,14.79000000,0.00000000,0.00000000,0.30000000); //
	CreateDynamicObject(2535,1182.74000000,-1448.30000000,14.70000000,0.00000000,0.00000000,-90.96000000); //
	CreateDynamicObject(2543,1167.10000000,-1436.40000000,14.79000000,0.00000000,0.00000000,0.31000000); //
	CreateDynamicObject(2538,1172.31000000,-1435.32000000,14.79000000,0.00000000,0.00000000,180.34000000); //
	CreateDynamicObject(2539,1171.38000000,-1435.31000000,14.79000000,0.00000000,0.00000000,180.19000000); //
	CreateDynamicObject(2540,1169.56000000,-1435.36000000,14.79000000,0.00000000,0.00000000,180.17000000); //
	CreateDynamicObject(1984,1157.37000000,-1442.59000000,14.79000000,0.00000000,0.00000000,-450.06000000); //
	CreateDynamicObject(2012,1163.25000000,-1448.31000000,14.75000000,0.00000000,0.00000000,-179.16000000); //
	CreateDynamicObject(2012,1169.29000000,-1431.92000000,14.75000000,0.00000000,0.00000000,359.80000000); //
	CreateDynamicObject(1987,1163.13000000,-1436.34000000,14.79000000,0.00000000,0.00000000,361.06000000); //
	CreateDynamicObject(1988,1164.13000000,-1436.33000000,14.79000000,0.00000000,0.00000000,360.80000000); //
	CreateDynamicObject(2871,1164.79000000,-1443.96000000,14.79000000,0.00000000,0.00000000,177.73000000); //
	CreateDynamicObject(2871,1164.70000000,-1444.98000000,14.79000000,0.00000000,0.00000000,358.07000000); //
	CreateDynamicObject(2942,1155.52000000,-1464.68000000,15.43000000,0.00000000,0.00000000,-71.22000000); //
	CreateDynamicObject(1987,1164.12000000,-1435.32000000,14.77000000,0.00000000,0.00000000,180.96000000); //
	CreateDynamicObject(2530,1171.13000000,-1443.79000000,14.79000000,0.00000000,0.00000000,-182.16000000); //
	CreateDynamicObject(1991,1173.75000000,-1439.56000000,14.79000000,0.00000000,0.00000000,179.47000000); //
	CreateDynamicObject(1996,1169.82000000,-1439.50000000,14.79000000,0.00000000,0.00000000,179.10000000); //
	CreateDynamicObject(1996,1174.24000000,-1435.38000000,14.79000000,0.00000000,0.00000000,179.24000000); //
	CreateDynamicObject(1991,1175.23000000,-1435.39000000,14.79000000,0.00000000,0.00000000,179.57000000); //
	CreateDynamicObject(1995,1182.65000000,-1435.10000000,14.79000000,0.00000000,0.00000000,90.00000000); //
	CreateDynamicObject(1994,1182.66000000,-1438.07000000,14.79000000,0.00000000,0.00000000,90.00000000); //
	CreateDynamicObject(1993,1182.66000000,-1437.08000000,14.79000000,0.00000000,0.00000000,90.00000000); //
	CreateDynamicObject(2542,1163.78000000,-1443.92000000,14.76000000,0.00000000,0.00000000,178.77000000); //
	CreateDynamicObject(2536,1166.88000000,-1445.07000000,14.70000000,0.00000000,0.00000000,-0.42000000); //
	CreateDynamicObject(2542,1163.70000000,-1444.93000000,14.78000000,0.00000000,0.00000000,-1.74000000); //
	CreateDynamicObject(1984,1157.34000000,-1435.71000000,14.79000000,0.00000000,0.00000000,-450.06000000); //
	CreateDynamicObject(2012,1166.31000000,-1448.28000000,14.75000000,0.00000000,0.00000000,-180.12000000); //
	CreateDynamicObject(2530,1172.14000000,-1443.83000000,14.79000000,0.00000000,0.00000000,-181.38000000); //
	CreateDynamicObject(2530,1173.14000000,-1443.85000000,14.79000000,0.00000000,0.00000000,-180.96000000); //
	CreateDynamicObject(2530,1174.13000000,-1443.88000000,14.79000000,0.00000000,0.00000000,-181.50000000); //
	CreateDynamicObject(1981,1170.76000000,-1439.52000000,14.79000000,0.00000000,0.00000000,-181.74000000); //
	CreateDynamicObject(1981,1171.76000000,-1439.54000000,14.79000000,0.00000000,0.00000000,-180.80000000); //
	CreateDynamicObject(1981,1172.75000000,-1439.55000000,14.79000000,0.00000000,0.00000000,-180.84000000); //
	CreateDynamicObject(2535,1182.75000000,-1447.28000000,14.70000000,0.00000000,0.00000000,-90.78000000); //
	CreateDynamicObject(2535,1182.74000000,-1446.28000000,14.70000000,0.00000000,0.00000000,-90.78000000); //
	CreateDynamicObject(2535,1182.74000000,-1445.26000000,14.70000000,0.00000000,0.00000000,-90.00000000); //
	CreateDynamicObject(2541,1182.75000000,-1444.22000000,14.79000000,0.00000000,0.00000000,-90.06000000); //
	CreateDynamicObject(2541,1182.75000000,-1443.20000000,14.79000000,0.00000000,0.00000000,-90.06000000); //
	CreateDynamicObject(2541,1182.74000000,-1442.16000000,14.79000000,0.00000000,0.00000000,-90.06000000); //
	CreateDynamicObject(2543,1182.76000000,-1441.18000000,14.79000000,0.00000000,0.00000000,-90.84000000); //
	CreateDynamicObject(2541,1182.79000000,-1440.17000000,14.79000000,0.00000000,0.00000000,-90.06000000); //
	CreateDynamicObject(2543,1182.72000000,-1439.15000000,14.79000000,0.00000000,0.00000000,-90.84000000); //
	CreateDynamicObject(1990,1182.66000000,-1431.67000000,14.79000000,0.00000000,0.00000000,3.30000000); //
	CreateDynamicObject(1990,1181.63000000,-1431.73000000,14.79000000,0.00000000,0.00000000,3.30000000); //
	CreateDynamicObject(1990,1180.61000000,-1431.81000000,14.79000000,0.00000000,0.00000000,3.30000000); //
	CreateDynamicObject(1990,1179.61000000,-1431.83000000,14.79000000,0.00000000,0.00000000,3.30000000); //
	CreateDynamicObject(1990,1178.61000000,-1431.89000000,14.79000000,0.00000000,0.00000000,3.30000000); //
	CreateDynamicObject(1990,1177.59000000,-1431.86000000,14.79000000,0.00000000,0.00000000,3.30000000); //
	CreateDynamicObject(1993,1182.66000000,-1436.09000000,14.79000000,0.00000000,0.00000000,90.00000000); //
	CreateDynamicObject(2012,1175.50000000,-1431.82000000,14.75000000,0.00000000,0.00000000,361.17000000); //
	CreateDynamicObject(2012,1172.42000000,-1431.87000000,14.75000000,0.00000000,0.00000000,359.93000000); //
	CreateDynamicObject(2012,1160.10000000,-1448.35000000,14.75000000,0.00000000,0.00000000,-179.94000000); //
	CreateDynamicObject(2539,1170.45000000,-1435.33000000,14.79000000,0.00000000,0.00000000,181.26000000); //
	CreateDynamicObject(2545,1161.82000000,-1431.84000000,14.91000000,0.00000000,0.00000000,-90.54000000); //
	CreateDynamicObject(2545,1160.82000000,-1431.83000000,14.91000000,0.00000000,0.00000000,-90.54000000); //
	CreateDynamicObject(2545,1159.81000000,-1431.86000000,14.91000000,0.00000000,0.00000000,-90.54000000); //
	CreateDynamicObject(2545,1162.82000000,-1431.87000000,14.91000000,0.00000000,0.00000000,-90.54000000); //
	CreateDynamicObject(1988,1163.13000000,-1435.34000000,14.79000000,0.00000000,0.00000000,541.46000000); //
	CreateDynamicObject(1988,1166.07000000,-1436.32000000,14.79000000,0.00000000,0.00000000,360.80000000); //
	CreateDynamicObject(1987,1165.07000000,-1436.33000000,14.79000000,0.00000000,0.00000000,361.06000000); //
	CreateDynamicObject(1987,1166.11000000,-1435.30000000,14.77000000,0.00000000,0.00000000,180.96000000); //
	CreateDynamicObject(1988,1165.07000000,-1435.31000000,14.79000000,0.00000000,0.00000000,540.44000000); //
	CreateDynamicObject(2536,1165.79000000,-1445.07000000,14.70000000,0.00000000,0.00000000,-1.20000000); //
	CreateDynamicObject(2536,1167.83000000,-1445.07000000,14.70000000,0.00000000,0.00000000,-0.06000000); //
	CreateDynamicObject(2871,1165.79000000,-1444.00000000,14.79000000,0.00000000,0.00000000,178.27000000); //
	CreateDynamicObject(2871,1166.81000000,-1444.03000000,14.79000000,0.00000000,0.00000000,179.35000000); //
	CreateDynamicObject(2871,1167.79000000,-1444.04000000,14.79000000,0.00000000,0.00000000,179.89000000); //
	CreateDynamicObject(2543,1168.13000000,-1435.36000000,14.79000000,0.00000000,0.00000000,180.05000000); //
	CreateDynamicObject(2543,1167.10000000,-1435.37000000,14.79000000,0.00000000,0.00000000,180.35000000); //
	CreateDynamicObject(2012,1170.63000000,-1440.67000000,14.75000000,0.00000000,0.00000000,359.50000000); //
	CreateDynamicObject(2012,1173.77000000,-1440.72000000,14.75000000,0.00000000,0.00000000,359.82000000); //
	CreateDynamicObject(2012,1177.30000000,-1445.31000000,14.75000000,0.00000000,0.00000000,359.93000000); //
	CreateDynamicObject(1996,1173.36000000,-1448.30000000,14.79000000,0.00000000,0.00000000,179.10000000); //
	CreateDynamicObject(1981,1174.33000000,-1448.32000000,14.79000000,0.00000000,0.00000000,-181.74000000); //
	CreateDynamicObject(1981,1175.32000000,-1448.35000000,14.79000000,0.00000000,0.00000000,-180.84000000); //
	CreateDynamicObject(1981,1176.30000000,-1448.37000000,14.79000000,0.00000000,0.00000000,-180.84000000); //
	CreateDynamicObject(1991,1177.28000000,-1448.37000000,14.79000000,0.00000000,0.00000000,179.47000000); //
	CreateDynamicObject(1996,1178.33000000,-1448.36000000,14.79000000,0.00000000,0.00000000,179.24000000); //
	CreateDynamicObject(1991,1179.33000000,-1448.37000000,14.79000000,0.00000000,0.00000000,179.57000000); //
	CreateDynamicObject(1994,1176.82000000,-1444.16000000,14.79000000,0.00000000,0.00000000,-0.84000000); //
	CreateDynamicObject(1995,1178.81000000,-1444.20000000,14.79000000,0.00000000,0.00000000,-1.26000000); //
	CreateDynamicObject(2543,1168.89000000,-1444.06000000,14.79000000,0.00000000,0.00000000,178.97000000); //
	CreateDynamicObject(2543,1169.91000000,-1444.07000000,14.79000000,0.00000000,0.00000000,179.69000000); //
	CreateDynamicObject(2543,1169.87000000,-1445.12000000,14.79000000,0.00000000,0.00000000,-0.06000000); //
	CreateDynamicObject(2543,1168.86000000,-1445.11000000,14.79000000,0.00000000,0.00000000,0.31000000); //
	CreateDynamicObject(2538,1167.02000000,-1431.87000000,14.79000000,0.00000000,0.00000000,0.42000000); //
	CreateDynamicObject(2539,1166.03000000,-1431.89000000,14.79000000,0.00000000,0.00000000,0.70000000); //
	CreateDynamicObject(2540,1164.04000000,-1431.91000000,14.79000000,0.00000000,0.00000000,0.60000000); //
	CreateDynamicObject(2539,1165.03000000,-1431.91000000,14.79000000,0.00000000,0.00000000,1.02000000); //
	CreateDynamicObject(2538,1176.17000000,-1436.38000000,14.79000000,0.00000000,0.00000000,0.24000000); //
	CreateDynamicObject(2539,1174.22000000,-1436.37000000,14.79000000,0.00000000,0.00000000,-0.06000000); //
	CreateDynamicObject(2540,1173.22000000,-1436.36000000,14.79000000,0.00000000,0.00000000,0.18000000); //
	CreateDynamicObject(2539,1175.20000000,-1436.38000000,14.79000000,0.00000000,0.00000000,-2.06000000); //
	CreateDynamicObject(2540,1173.26000000,-1435.31000000,14.79000000,0.00000000,0.00000000,180.17000000); //
	CreateDynamicObject(1991,1175.74000000,-1439.58000000,14.79000000,0.00000000,0.00000000,179.57000000); //
	CreateDynamicObject(1996,1174.74000000,-1439.57000000,14.79000000,0.00000000,0.00000000,179.24000000); //
	CreateDynamicObject(1996,1176.17000000,-1435.37000000,14.79000000,0.00000000,0.00000000,179.24000000); //
	CreateDynamicObject(1991,1177.16000000,-1435.38000000,14.79000000,0.00000000,0.00000000,179.57000000); //
	CreateDynamicObject(2540,1169.44000000,-1436.35000000,14.79000000,0.00000000,0.00000000,0.18000000); //
	CreateDynamicObject(2539,1170.43000000,-1436.35000000,14.79000000,0.00000000,0.00000000,0.90000000); //
	CreateDynamicObject(2539,1171.34000000,-1436.33000000,14.79000000,0.00000000,0.00000000,0.58000000); //
	CreateDynamicObject(2538,1172.22000000,-1436.32000000,14.79000000,0.00000000,0.00000000,0.30000000); //
	CreateDynamicObject(2871,1163.40000000,-1440.68000000,14.79000000,0.00000000,0.00000000,360.41000000); //
	CreateDynamicObject(2536,1164.49000000,-1440.73000000,14.70000000,0.00000000,0.00000000,-1.20000000); //
	CreateDynamicObject(2536,1165.49000000,-1440.75000000,14.70000000,0.00000000,0.00000000,-0.42000000); //
	CreateDynamicObject(2536,1166.50000000,-1440.75000000,14.70000000,0.00000000,0.00000000,-0.06000000); //
	CreateDynamicObject(2543,1167.61000000,-1440.64000000,14.79000000,0.00000000,0.00000000,0.31000000); //
	CreateDynamicObject(2543,1168.62000000,-1440.64000000,14.79000000,0.00000000,0.00000000,0.30000000); //
	CreateDynamicObject(2543,1168.64000000,-1439.60000000,14.79000000,0.00000000,0.00000000,180.05000000); //
	CreateDynamicObject(2543,1167.67000000,-1439.61000000,14.79000000,0.00000000,0.00000000,180.35000000); //
	CreateDynamicObject(2871,1163.65000000,-1439.67000000,14.79000000,0.00000000,0.00000000,180.61000000); //
	CreateDynamicObject(2871,1164.68000000,-1439.67000000,14.79000000,0.00000000,0.00000000,179.77000000); //
	CreateDynamicObject(2871,1165.68000000,-1439.68000000,14.79000000,0.00000000,0.00000000,180.61000000); //
	CreateDynamicObject(2871,1166.68000000,-1439.66000000,14.79000000,0.00000000,0.00000000,180.61000000); //
	CreateDynamicObject(1990,1175.09000000,-1444.97000000,14.79000000,0.00000000,0.00000000,-2.46000000); //
	CreateDynamicObject(1990,1181.63000000,-1431.73000000,14.79000000,0.00000000,0.00000000,3.30000000); //
	CreateDynamicObject(1990,1174.07000000,-1444.94000000,14.79000000,0.00000000,0.00000000,0.48000000); //
	CreateDynamicObject(1990,1173.09000000,-1444.94000000,14.79000000,0.00000000,0.00000000,-1.20000000); //
	CreateDynamicObject(1990,1172.11000000,-1444.92000000,14.79000000,0.00000000,0.00000000,-1.14000000); //
	CreateDynamicObject(1990,1171.12000000,-1444.91000000,14.79000000,0.00000000,0.00000000,-0.72000000); //
	CreateDynamicObject(2530,1168.54000000,-1448.31000000,14.79000000,0.00000000,0.00000000,-178.98000000); //
	CreateDynamicObject(2530,1169.60000000,-1448.29000000,14.79000000,0.00000000,0.00000000,-178.98000000); //
	CreateDynamicObject(2530,1170.67000000,-1448.30000000,14.79000000,0.00000000,0.00000000,-178.98000000); //
	CreateDynamicObject(2530,1171.72000000,-1448.32000000,14.79000000,0.00000000,0.00000000,-181.50000000); //
	CreateDynamicObject(2530,1175.13000000,-1443.91000000,14.79000000,0.00000000,0.00000000,-181.50000000); //
	CreateDynamicObject(2012,1176.82000000,-1440.75000000,14.75000000,0.00000000,0.00000000,359.93000000); //
	CreateDynamicObject(1995,1177.71000000,-1439.63000000,14.79000000,0.00000000,0.00000000,0.00000000); //
	CreateDynamicObject(1994,1176.73000000,-1439.63000000,14.79000000,0.00000000,0.00000000,0.06000000); //
	CreateDynamicObject(1993,1177.83000000,-1444.15000000,14.79000000,0.00000000,0.00000000,179.46000000); //
	return 1;
}

stock firstPlayerSpawn(const playerid) {
	playerVariables[playerid][pTutorial] = 0;
	playerVariables[playerid][pFirstLogin] = 0;

	playerVariables[playerid][pInterior] = 0;
	playerVariables[playerid][pVirtualWorld] = 0;

	SetSpawnInfo(playerid, 0, playerVariables[playerid][pSkin], playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2], 0, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);

	TextDrawHideForPlayer(playerid, textdrawVariables[3]);
	return 1;
}

public initiateTutorial(const playerid) {
	// Clear the dialog if it still exists from the quiz...
    hidePlayerDialog(playerid);
    
    // Clear the variable storing the timer handle if it still exists from the quiz...
    if(GetPVarType(playerid, "tutt") != 0)
        DeletePVar(playerid, "tutt");
    
	GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

	format(szMessage, sizeof(szMessage), "Welcome to "SERVER_NAME", %s.", szPlayerName);

    SendClientMessage(playerid, COLOR_TEAL, "----------------------------------------------------------------------------");
	SendClientMessage(playerid, COLOR_YELLOW, szMessage);
	SendClientMessage(playerid, COLOR_WHITE, "Please select your style of clothing from the selection below.");

	playerVariables[playerid][pTutorial] = 1;

	playerVariables[playerid][pVirtualWorld] = playerid+50;

	SetSpawnInfo(playerid, 0, 0, 220.4862, 1822.8994, 7.5387, 268.3423, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	SetPlayerPos(playerid, 220.4862, 1822.8994, 7.5387);
	SetPlayerFacingAngle(playerid, 268.3423);
	TogglePlayerControllable(playerid, false);

	TextDrawShowForPlayer(playerid, textdrawVariables[2]);
	return 1;
}

stock GetDistanceBetweenPlayers(playerid, playerid2) {
	new
	    Float:Floats[7];

	GetPlayerPos(playerid, Floats[0], Floats[1], Floats[2]);
	GetPlayerPos(playerid2, Floats[3], Floats[4], Floats[5]);
	Floats[6] = floatsqroot((Floats[3]-Floats[0])*(Floats[3]-Floats[0])+(Floats[4]-Floats[1])*(Floats[4]-Floats[1])+(Floats[5]-Floats[2])*(Floats[5]-Floats[2]));

	return floatround(Floats[6]);
}

stock GetDistancePlayerVeh(playerid, veh) {

	new
	    Float:Floats[7];

	GetPlayerPos(playerid, Floats[0], Floats[1], Floats[2]);
	GetVehiclePos(veh, Floats[3], Floats[4], Floats[5]);
	Floats[6] = floatsqroot((Floats[3]-Floats[0])*(Floats[3]-Floats[0])+(Floats[4]-Floats[1])*(Floats[4]-Floats[1])+(Floats[5]-Floats[2])*(Floats[5]-Floats[2]));

	return floatround(Floats[6]);
}

stock IsPlayerInRangeOfVehicle(playerid, vehicleid, Float: radius) {

	new
		Float:Floats[3];

	GetVehiclePos(vehicleid, Floats[0], Floats[1], Floats[2]);
	return IsPlayerInRangeOfPoint(playerid, radius, Floats[0], Floats[1], Floats[2]);
}

stock IsPlayerInRangeOfPlayer(playerid, playerid2, Float: radius) {

	new
		Float:Floats[3];

	GetPlayerPos(playerid2, Floats[0], Floats[1], Floats[2]);
	return IsPlayerInRangeOfPoint(playerid, radius, Floats[0], Floats[1], Floats[2]);
}

stock IsVehicleInRangeOfPoint(vehicleid, Float: radius, Float:x, Float:y, Float:z) {

	new
		Float:Floats[6];

	GetVehiclePos(vehicleid, Floats[0], Floats[1], Floats[2]);
	Floats[3] = (Floats[0] -x);
	Floats[4] = (Floats[1] -y);
	Floats[5] = (Floats[2] -z);
	if (((Floats[3] < radius) && (Floats[3] > -radius)) && ((Floats[4] < radius) && (Floats[4] > -radius)) && ((Floats[5] < radius) && (Floats[5] > -radius)))
		return 1;
	return 0;
}

stock GetPlayerSpeed(playerid, get3d) // Need this for fixcar
{
	new
		Float:Floats[3];

	if(IsPlayerInAnyVehicle(playerid))
	    GetVehicleVelocity(GetPlayerVehicleID(playerid), Floats[0], Floats[1], Floats[2]);
	else
	    GetPlayerVelocity(playerid, Floats[0], Floats[1], Floats[2]);

	return SpeedCheck(Floats[0], Floats[1], Floats[2], 100.0, get3d);
}

stock givePlayerWeapons(playerid) {
	new
	    x;

	while(x < 13) {
		GivePlayerWeapon(playerid, playerVariables[playerid][pWeapons][x], 99999);
		x++;
	}

	return 1;
}

//	Credits to Westie for explode, from his strlib include.
stock explode(aExplode[][], const sSource[], const sDelimiter[] = " ", iVertices = sizeof aExplode, iLength = sizeof aExplode[])
{
	new
		iNode,
		iPointer,
		iPrevious = -1,
		iDelimiter = strlen(sDelimiter);

	while(iNode < iVertices)
	{
		iPointer = strfind(sSource, sDelimiter, false, iPointer);

		if(iPointer == -1)
		{
			strmid(aExplode[iNode], sSource, iPrevious, strlen(sSource), iLength);
			break;
		}
		else
		{
			strmid(aExplode[iNode], sSource, iPrevious, iPointer, iLength);
		}

		iPrevious = (iPointer += iDelimiter);
		++iNode;
	}

	return iPrevious;
}

stock removePlayerWeapon(playerid, weapon) {
	playerVariables[playerid][pAnticheatExemption] = 6;

	switch(weapon) {
		case 0, 1: {
		    if(playerVariables[playerid][pTabbed] >= 1) {
		        playerVariables[playerid][pOutstandingWeaponRemovalSlot] = 0;
		    }
		    else {
			    ResetPlayerWeapons(playerid);
		        playerVariables[playerid][pWeapons][0] = 0;
				givePlayerWeapons(playerid);
			}
	    }
	    case 2, 3, 4, 5, 6, 7, 8, 9: {
		    if(playerVariables[playerid][pTabbed] >= 1) {
		        playerVariables[playerid][pOutstandingWeaponRemovalSlot] = 1;
		    }
		    else {
			    ResetPlayerWeapons(playerid);
		        playerVariables[playerid][pWeapons][1] = 0;
				givePlayerWeapons(playerid);
			}
	    }
	    case 22, 23, 24: {
		    if(playerVariables[playerid][pTabbed] >= 1) {
		        playerVariables[playerid][pOutstandingWeaponRemovalSlot] = 2;
		    }
		    else {
			    ResetPlayerWeapons(playerid);
		        playerVariables[playerid][pWeapons][2] = 0;
				givePlayerWeapons(playerid);
			}
	    }
	    case 25, 26, 27: {
		    if(playerVariables[playerid][pTabbed] >= 1) {
		        playerVariables[playerid][pOutstandingWeaponRemovalSlot] = 3;
		    }
		    else {
			    ResetPlayerWeapons(playerid);
		        playerVariables[playerid][pWeapons][3] = 0;
				givePlayerWeapons(playerid);
			}
	    }
	    case 28, 29, 32: {
		    if(playerVariables[playerid][pTabbed] >= 1) {
		        playerVariables[playerid][pOutstandingWeaponRemovalSlot] = 4;
		    }
		    else {
			    ResetPlayerWeapons(playerid);
		        playerVariables[playerid][pWeapons][4] = 0;
				givePlayerWeapons(playerid);
			}
	    }
	    case 30, 31: {
		    if(playerVariables[playerid][pTabbed] >= 1) {
		        playerVariables[playerid][pOutstandingWeaponRemovalSlot] = 5;
		    }
		    else {
			    ResetPlayerWeapons(playerid);
		        playerVariables[playerid][pWeapons][5] = 0;
				givePlayerWeapons(playerid);
			}
	    }
	    case 33, 34: {
		    if(playerVariables[playerid][pTabbed] >= 1) {
		        playerVariables[playerid][pOutstandingWeaponRemovalSlot] = 6;
		    }
		    else {
			    ResetPlayerWeapons(playerid);
		        playerVariables[playerid][pWeapons][6] = 0;
				givePlayerWeapons(playerid);
			}
	    }
	    case 35, 36, 37, 38: {
		    if(playerVariables[playerid][pTabbed] >= 1) {
		        playerVariables[playerid][pOutstandingWeaponRemovalSlot] = 7;
		    }
		    else {
			    ResetPlayerWeapons(playerid);
		        playerVariables[playerid][pWeapons][7] = 0;
				givePlayerWeapons(playerid);
			}
	    }
	    case 16, 17, 18, 39: {
		    if(playerVariables[playerid][pTabbed] >= 1) {
		        playerVariables[playerid][pOutstandingWeaponRemovalSlot] = 8;
		    }
		    else {
			    ResetPlayerWeapons(playerid);
		        playerVariables[playerid][pWeapons][8] = 0;
				givePlayerWeapons(playerid);
			}
	    }
	    case 41, 42, 43: {
		    if(playerVariables[playerid][pTabbed] >= 1) {
		        playerVariables[playerid][pOutstandingWeaponRemovalSlot] = 9;
		    }
		    else {
			    ResetPlayerWeapons(playerid);
		        playerVariables[playerid][pWeapons][9] = 0;
				givePlayerWeapons(playerid);
			}
	    }
	    case 10, 11, 12, 13, 14, 15: {
		    if(playerVariables[playerid][pTabbed] >= 1) {
		        playerVariables[playerid][pOutstandingWeaponRemovalSlot] = 10;
		    }
		    else {
			    ResetPlayerWeapons(playerid);
		        playerVariables[playerid][pWeapons][10] = 0;
				givePlayerWeapons(playerid);
			}
	    }
	    case 44, 45, 46: {
		    if(playerVariables[playerid][pTabbed] >= 1) {
		        playerVariables[playerid][pOutstandingWeaponRemovalSlot] = 11;
		    }
		    else {
			    ResetPlayerWeapons(playerid);
		        playerVariables[playerid][pWeapons][11] = 0;
				givePlayerWeapons(playerid);
			}
	    }
	    case 40: {
		    if(playerVariables[playerid][pTabbed] >= 1) {
		        playerVariables[playerid][pOutstandingWeaponRemovalSlot] = 12;
		    }
		    else {
			    ResetPlayerWeapons(playerid);
		        playerVariables[playerid][pWeapons][12] = 0;
				givePlayerWeapons(playerid);
			}
	    }
	}
	return 1;
}

public antiCheat() 
{
	foreach(Player, i) 
	{
	    if(playerVariables[i][pStatus] == 1) 
		{
		    if(GetPlayerSpecialAction(i) == SPECIAL_ACTION_USEJETPACK && playerVariables[i][pJetpack] == 0 && playerVariables[i][pAdminLevel] < 1) {
		        scriptBan(i, "Hacking (Jetpack)");
		    }
			if(playerVariables[i][pAdminLevel] < 3 && playerVariables[i][pEvent] == 0 && playerVariables[i][pAnticheatExemption] == 0) {
				if(GetPlayerWeapon(i) >= 1 && GetPlayerState(i) == 1) {
					if(playerVariables[i][pWeapons][0] != 1 && GetPlayerWeapon(i) == 1) hackerTrigger(i);

					if(playerVariables[i][pWeapons][1] != 2 && GetPlayerWeapon(i) == 2) hackerTrigger(i);
					if(playerVariables[i][pWeapons][1] != 3 && GetPlayerWeapon(i) == 3) hackerTrigger(i);
					if(playerVariables[i][pWeapons][1] != 4 && GetPlayerWeapon(i) == 4) hackerTrigger(i);
					if(playerVariables[i][pWeapons][1] != 5 && GetPlayerWeapon(i) == 5) hackerTrigger(i);
					if(playerVariables[i][pWeapons][1] != 6 && GetPlayerWeapon(i) == 6) hackerTrigger(i);
					if(playerVariables[i][pWeapons][1] != 7 && GetPlayerWeapon(i) == 7) hackerTrigger(i);
					if(playerVariables[i][pWeapons][1] != 8 && GetPlayerWeapon(i) == 8) hackerTrigger(i);
					if(playerVariables[i][pWeapons][1] != 9 && GetPlayerWeapon(i) == 9) hackerTrigger(i);

					if(playerVariables[i][pWeapons][2] != 22 && GetPlayerWeapon(i) == 22) hackerTrigger(i);
					if(playerVariables[i][pWeapons][2] != 23 && GetPlayerWeapon(i) == 23) hackerTrigger(i);
					if(playerVariables[i][pWeapons][2] != 24 && GetPlayerWeapon(i) == 24) hackerTrigger(i);

					if(playerVariables[i][pWeapons][3] != 25 && GetPlayerWeapon(i) == 25) hackerTrigger(i);
					if(playerVariables[i][pWeapons][3] != 26 && GetPlayerWeapon(i) == 26) hackerTrigger(i);
					if(playerVariables[i][pWeapons][3] != 27 && GetPlayerWeapon(i) == 27) hackerTrigger(i);

					if(playerVariables[i][pWeapons][4] != 28 && GetPlayerWeapon(i) == 28) hackerTrigger(i);
					if(playerVariables[i][pWeapons][4] != 29 && GetPlayerWeapon(i) == 29) hackerTrigger(i);
					if(playerVariables[i][pWeapons][4] != 32 && GetPlayerWeapon(i) == 32) hackerTrigger(i);

					if(playerVariables[i][pWeapons][5] != 30 && GetPlayerWeapon(i) == 30) hackerTrigger(i);
					if(playerVariables[i][pWeapons][5] != 31 && GetPlayerWeapon(i) == 31) hackerTrigger(i);

					if(playerVariables[i][pWeapons][6] != 33 && GetPlayerWeapon(i) == 33) hackerTrigger(i);
					if(playerVariables[i][pWeapons][6] != 34 && GetPlayerWeapon(i) == 34) hackerTrigger(i);

					if(playerVariables[i][pWeapons][7] != 35 && GetPlayerWeapon(i) == 35) hackerTrigger(i);
					if(playerVariables[i][pWeapons][7] != 36 && GetPlayerWeapon(i) == 36) hackerTrigger(i);
					if(playerVariables[i][pWeapons][7] != 37 && GetPlayerWeapon(i) == 37) hackerTrigger(i);
					if(playerVariables[i][pWeapons][7] != 38 && GetPlayerWeapon(i) == 38) hackerTrigger(i);

					if(playerVariables[i][pWeapons][8] != 16 && GetPlayerWeapon(i) == 16) hackerTrigger(i);
					if(playerVariables[i][pWeapons][8] != 17 && GetPlayerWeapon(i) == 17) hackerTrigger(i);
					if(playerVariables[i][pWeapons][8] != 18 && GetPlayerWeapon(i) == 18) hackerTrigger(i);
					if(playerVariables[i][pWeapons][8] != 39 && GetPlayerWeapon(i) == 39) hackerTrigger(i);

					if(playerVariables[i][pWeapons][9] != 41 && GetPlayerWeapon(i) == 41) hackerTrigger(i);
					if(playerVariables[i][pWeapons][9] != 42 && GetPlayerWeapon(i) == 42) hackerTrigger(i);
					if(playerVariables[i][pWeapons][9] != 43 && GetPlayerWeapon(i) == 43) hackerTrigger(i);

					if(playerVariables[i][pWeapons][10] != 10 && GetPlayerWeapon(i) == 10) hackerTrigger(i);
					if(playerVariables[i][pWeapons][10] != 11 && GetPlayerWeapon(i) == 11) hackerTrigger(i);
					if(playerVariables[i][pWeapons][10] != 12 && GetPlayerWeapon(i) == 12) hackerTrigger(i);
					if(playerVariables[i][pWeapons][10] != 13 && GetPlayerWeapon(i) == 13) hackerTrigger(i);
					if(playerVariables[i][pWeapons][10] != 14 && GetPlayerWeapon(i) == 14) hackerTrigger(i);
					if(playerVariables[i][pWeapons][10] != 15 && GetPlayerWeapon(i) == 15) hackerTrigger(i);

					if(playerVariables[i][pWeapons][11] != 44 && GetPlayerWeapon(i) == 44) hackerTrigger(i);
					if(playerVariables[i][pWeapons][11] != 45 && GetPlayerWeapon(i) == 45) hackerTrigger(i);
					if(playerVariables[i][pWeapons][11] != 46 && GetPlayerWeapon(i) == 46) hackerTrigger(i);

					if(playerVariables[i][pWeapons][12] != 40 && GetPlayerWeapon(i) == 40) hackerTrigger(i);
				}
				else if(eventVariables[eEventStat] != 0) { // Event anticheat - check 5 event weapon slots, checks if the weapon is valid (in case of a bug).

					new
						wep = GetPlayerWeapon(i); // so we don't call getplayerweapon a million times!1

					if(eventVariables[eEventWeapons][0] != wep && eventVariables[eEventWeapons][1] != wep && eventVariables[eEventWeapons][2] != wep && eventVariables[eEventWeapons][3] != wep && eventVariables[eEventWeapons][4] != wep) { // Valid weapon check (in case someone has admin weapons)
						 if(playerVariables[i][pWeapons][GetWeaponSlot(wep)] != wep) hackerTrigger(i);
					}
				}
			}
		}
	}

	return 1;
}

stock hackerTrigger(playerid) {
	if(playerVariables[playerid][pTabbed] == 0) {
	    playerVariables[playerid][pHackWarnings]++;
	    playerVariables[playerid][pHackWarnTime] = 1;

	    printf("Hack Warning! Weapon %d (playerid: %d)", GetPlayerWeapon(playerid), playerid);

	    if(playerVariables[playerid][pHackWarnings] >= 3) {

			new
				wep = GetPlayerWeapon(playerid),
		        reason[94];

			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

			format(reason, sizeof(reason), "Warning: {FFFFFF}%s may possibly be weapon hacking (%s).", szPlayerName, WeaponNames[wep]);
			submitToAdmins(reason, COLOR_HOTORANGE);

		    if(playerVariables[playerid][pHackWarnings] >= MAX_WEAPON_HACK_WARNINGS) {
		        format(reason, sizeof(reason), "Weapon Hacking (%s).", WeaponNames[wep]);
		        scriptBan(playerid, reason);
		    }
		}
    }
	return 1;
}

stock scriptBan(playerid, reason[]) {
	new
		playerIP[32],
	    aString[240];

	GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
	GetPlayerIp(playerid, playerIP, sizeof(playerIP));

	playerVariables[playerid][pBanned] = 1;

   	format(aString, sizeof(aString), "Ban: %s has been banned, reason: %s", szPlayerName, reason);
   	SendClientMessageToAll(COLOR_LIGHTRED, aString);

    mysql_real_escape_string(aString, aString);
    adminLog(aString);

	Kick(playerid);

   	format(aString, sizeof(aString), "INSERT INTO bans (playerNameBanned, playerBannedBy, playerBanReason, IPBanned) VALUES('%s', 'System', '%s', '%s')", szPlayerName, reason, playerIP);
	mysql_query(aString);
	return 1;
}

stock IPBan(ip[], reason[], name[] = "Nobody") {
	new
	    cleanReason[64],
	    querySz[150]; // To be on the safe side.

	mysql_real_escape_string(reason, cleanReason);
	format(querySz, sizeof(querySz), "INSERT INTO Bans (playerNameBanned, playerBanReason, IPBanned) VALUES('%s', '%s', '%s')", name, reason, ip);
	mysql_query(querySz);
	return 1;
}

public OnQueryError(errorid, error[], resultid, extraid, callback[], query[], connectionHandle) {
	if(IsPlayerConnected(extraid) && resultid == THREAD_CHECK_BANS_LIST) {
	    ShowPlayerDialog(extraid, 0, DIALOG_STYLE_MSGBOX, "MySQL problem!", "You missed a step! Here's a list of the potential causes:\n\n- the MySQL connection details are invalid\n- the database dump wasn't imported correctly\n- an unexpected error ocurred\n\nPlease revisit the installation instructions.", "OK", "");
	}
	
	return printf("errorid: %d | error: %s | resultid: %d | extraid: %d | callback: %s | query: %s", errorid, error, resultid, extraid, callback, query);
}

public OnQueryFinish(query[], resultid, extraid, connectionHandle) {
	switch(resultid) {
	    case THREAD_UNBAN_IP: {
			SendClientMessage(extraid, COLOR_WHITE, "You have successfully unbanned the IP.");
		}
		case THREAD_CHANGE_BUSINESS_TYPE_ITEMS: {
			createRelevantItems(extraid);
		}
	    case THREAD_TIMESTAMP_CONNECT: {
			mysql_store_result();
			
			if(mysql_num_rows() == 0)
			    return SendClientMessage(extraid, COLOR_GENANNOUNCE, "SERVER:"EMBED_WHITE" Welcome to the server!");
			    
            GetPlayerName(extraid, szPlayerName, MAX_PLAYER_NAME);

			mysql_fetch_row_format(result);
			format(szMessage, sizeof(szMessage), "SERVER:"EMBED_WHITE" Welcome back %s, you last visited us on %s.", szPlayerName, result);
			SendClientMessage(extraid, COLOR_GENANNOUNCE, szMessage);
			
  			if(playerVariables[extraid][pGroup] >= 1) {
			    format(szMessage, sizeof(szMessage), "(Group) "EMBED_WHITE"%s from your group has just logged in.", szPlayerName);
			    SendToGroup(playerVariables[extraid][pGroup], COLOR_GENANNOUNCE, szMessage);

		        format(szMessage, sizeof(szMessage), "(Group) MOTD: "EMBED_WHITE"%s", groupVariables[playerVariables[extraid][pGroup]][gGroupMOTD]);
		        SendClientMessage(extraid, COLOR_GENANNOUNCE, szMessage);
         	}
         	
         	mysql_free_result();
		}
		case THREAD_ADMIN_SECURITY: {
			mysql_store_result();
			
			if(!mysql_num_rows()) {
			    if(GetPVarInt(extraid, "pAdminPIN") == 0)
					return 1;
					
			    SetPVarInt(extraid, "pAdminFrozen", 1);
			    
			    ShowPlayerDialog(extraid, DIALOG_ADMIN_PIN, DIALOG_STYLE_INPUT, "SERVER: Admin authentication verification", "The system has recognised that you have connected with an IP that you've never used before.\n\nPlease confirm your admin PIN to continue:", "OK", "Cancel");
			} else mysql_free_result();
		}
		/*case THREAD_LOAD_PLAYER_VEHICLES: {
			mysql_store_result();
			
			if(mysql_num_rows() == 0)
			    return 1;

			new
			    iModel,
			    Float: fPos[3],
			    Float: fAngle,
			    iColours[2],
			    iPaintjob,
			    iComponents[14],
			    iVehicleID;

			while(mysql_retrieve_row()) {
			    mysql_get_field("pvModel", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Model", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iModel = strval(result);
			    
			    mysql_get_field("pvPosX", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_PosX", iVehicleID);
			    SetPVarFloat(extraid, szSmallString, floatstr(result));
			    fPos[0] = floatstr(result);
			    
			    mysql_get_field("pvPosY", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_PosY", iVehicleID);
			    SetPVarFloat(extraid, szSmallString, floatstr(result));
			    fPos[1] = floatstr(result);
			    
			    mysql_get_field("pvPosZ", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_PosZ", iVehicleID);
			    SetPVarFloat(extraid, szSmallString, floatstr(result));
			    fPos[2] = floatstr(result);
			    
			    mysql_get_field("pvPosZAngle", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_PosZAngle", iVehicleID);
			    SetPVarFloat(extraid, szSmallString, floatstr(result));
			    fAngle = floatstr(result);
			    
			    mysql_get_field("pvColour1", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Colour1", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iColours[0] = strval(result);

			    mysql_get_field("pvColour1", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Colour2", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iColours[1] = strval(result);
			    
			    mysql_get_field("pvPaintjob", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Paintjob", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iPaintjob = strval(result);

			    mysql_get_field("pvStaticPrice", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_StaticPrice", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));

			    mysql_get_field("pvComponent0", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component0", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iComponents[0] = strval(result);

			    mysql_get_field("pvComponent1", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component1", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iComponents[1] = strval(result);

				mysql_get_field("pvComponent2", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component2", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iComponents[2] = strval(result);

			    mysql_get_field("pvComponent3", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component3", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iComponents[3] = strval(result);

				mysql_get_field("pvComponent4", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component4", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iComponents[4] = strval(result);

			    mysql_get_field("pvComponent5", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component5", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iComponents[5] = strval(result);

				mysql_get_field("pvComponent6", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component6", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iComponents[6] = strval(result);

			    mysql_get_field("pvComponent7", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component7", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iComponents[7] = strval(result);

				mysql_get_field("pvComponent8", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component8", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iComponents[8] = strval(result);

			    mysql_get_field("pvComponent9", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component9", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iComponents[9] = strval(result);

				mysql_get_field("pvComponent10", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component10", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iComponents[10] = strval(result);

			    mysql_get_field("pvComponent11", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component11", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iComponents[11] = strval(result);

				mysql_get_field("pvComponent12", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component12", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iComponents[12] = strval(result);

			    mysql_get_field("pvComponent13", result);
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component13", iVehicleID);
			    SetPVarInt(extraid, szSmallString, strval(result));
			    iComponents[13] = strval(result);
			    
			    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_RealID", iVehicleID);
			    SetPVarInt(extraid, szSmallString, CreateVehicle(iModel, fPos[0], fPos[1], fPos[2], fAngle, iColours[0], iColours[1], 0));

				for(new i = 0; i <= 13; i++)
					AddVehicleComponent(GetPVarInt(extraid, szSmallString), iComponents[i]);

				ChangeVehiclePaintjob(GetPVarInt(extraid, szSmallString), iPaintjob);
				
                systemVariables[vehicleCounts][1]++;
			    iVehicleID++;
			}
			
			mysql_free_result();
		}*/
		case THREAD_INITIATE_BUSINESS_ITEMS: {
            mysql_store_result();

            new
				x;
            
			for(x = 0; x < MAX_BUSINESS_ITEMS; x++) {
				businessItems[x][bItemBusiness] = 0;
				businessItems[x][bItemType] = 0;
				businessItems[x][bItemPrice] = 0;
				format(businessItems[x][bItemName], 32, "");
			}
			
			x = 0;

			while(mysql_retrieve_row()) {
			    x++;
			    
			    mysql_get_field("itemBusinessId", result);
			    businessItems[x][bItemBusiness] = strval(result);

			    mysql_get_field("itemTypeId", result);
			    businessItems[x][bItemType] = strval(result);
			    
			    mysql_get_field("itemName", businessItems[x][bItemName]);
			    
			    mysql_get_field("itemPrice", result);
			    businessItems[x][bItemPrice] = strval(result);
			}
            
            mysql_free_result();
		}
		case THREAD_LAST_CONNECTIONS: {
			mysql_store_result();
			
			if(mysql_num_rows() < 1)
			    return SendClientMessage(extraid, COLOR_GREY, "You haven't connected more than once yet.");

    		format(szLargeString, sizeof(szLargeString), "Last ~5 of your connections:\n");
			while(mysql_fetch_row_format(result, " ")) {
			    format(szLargeString, sizeof(szLargeString), "%s\n%s", szLargeString, result);
			}
			
			ShowPlayerDialog(extraid, 0, DIALOG_STYLE_MSGBOX, "SERVER: Connection log", szLargeString, "OK", "");
			
			mysql_free_result();
		}
	    case THREAD_CHECK_PLAYER_NAMES: {
	        mysql_store_result();

	        if(mysql_num_rows() == 0)
	            return SendClientMessage(extraid, COLOR_GREY, "There are no recorded name changes for this player.");

			new
			    iNCID,
			    szOldName[MAX_PLAYER_NAME],
			    szTime[20],
			    szNewName[MAX_PLAYER_NAME];

			format(szLargeString, sizeof(szLargeString), "Name changes:\n");
            while(mysql_fetch_row_format(result)) { 
                sscanf(result, "p<|>ds[24]s[24]s[20]", iNCID, szOldName, szNewName, szTime);
                format(szLargeString, sizeof(szLargeString), "%s\n- (%d) Name: %s (changed from %s, %s)", szLargeString, iNCID, szNewName, szOldName, szTime);
            }

            ShowPlayerDialog(extraid, 0, DIALOG_STYLE_MSGBOX, "SERVER: Name changes", szLargeString, "OK", "");

			mysql_free_result();
	    }
	    case THREAD_LOAD_ATMS: {
			mysql_store_result();
			
			new
			    x;
			
			while(mysql_retrieve_row()) {
			    mysql_get_field("atmId", result);
			    x = strval(result);
			    
				mysql_get_field("atmPosX", result);
				atmVariables[x][fATMPos][0] = floatstr(result);
				
				mysql_get_field("atmPosY", result);
				atmVariables[x][fATMPos][1] = floatstr(result);
				
				mysql_get_field("atmPosZ", result);
				atmVariables[x][fATMPos][2] = floatstr(result) - 0.7;
				
				mysql_get_field("atmPosRotX", result);
				atmVariables[x][fATMPosRot][0] = floatstr(result);

				mysql_get_field("atmPosRotY", result);
				atmVariables[x][fATMPosRot][1] = floatstr(result);

				mysql_get_field("atmPosRotZ", result);
				atmVariables[x][fATMPosRot][2] = floatstr(result);
				
				atmVariables[x][rObjectId] = CreateDynamicObject(2618, atmVariables[x][fATMPos][0], atmVariables[x][fATMPos][1], atmVariables[x][fATMPos][2], atmVariables[x][fATMPosRot][0], atmVariables[x][fATMPosRot][1], atmVariables[x][fATMPosRot][2], -1, -1, -1, 500.0);
				atmVariables[x][rTextLabel] = CreateDynamic3DTextLabel("ATM\n\nWithdraw your cash here!\n\nPress ~k~~PED_DUCK~ to use this ATM.", COLOR_YELLOW, atmVariables[x][fATMPos][0], atmVariables[x][fATMPos][1], atmVariables[x][fATMPos][2], 50.0);
			}
			
			mysql_free_result();
		}
	    case THREAD_CHANGE_SPAWN: {
			SendClientMessage(extraid, COLOR_WHITE, "You have successfully changed the newbie spawn and newbie skin.");
			GetPlayerName(extraid, szPlayerName, MAX_PLAYER_NAME);
			format(szMessage, sizeof(szMessage), "AdmWarn: %s has changed the newbie spawn & skin.", szPlayerName);
			submitToAdmins(szMessage, COLOR_HOTORANGE);
		}
	    case THREAD_CHECK_ACCOUNT_USERNAME: {
	    	mysql_store_result();
			if(mysql_num_rows() == 0) {

			    if(!IsPlayerConnected(extraid))
					return mysql_free_result(); // Incase they're disconnected since... Sometimes queries F*"!%$" up.

			    new
					charCounts[5];

				GetPlayerName(extraid, szPlayerName, MAX_PLAYER_NAME);

				for(new n; n < MAX_PLAYER_NAME; n++) {
					switch(szPlayerName[n]) {
						case '[', ']', '.', '$', '(', ')', '@', '=': charCounts[1]++;
						case '_': charCounts[0]++;
						case '0' .. '9': charCounts[2]++;
						case 'a' .. 'z': charCounts[3]++;
						case 'A' .. 'Z': charCounts[4]++;
					}
				}
				if(charCounts[0] == 0 || charCounts[0] >= 3) {
					SendClientMessage(extraid, COLOR_GREY, "Your name is not valid. {FFFFFF}Please use an underscore and a first/last name (i.e. Mark_Edwards).");
					invalidNameChange(extraid);
				}
				else if(charCounts[1] >= 1) {
					SendClientMessage(extraid, COLOR_GREY, "Your name is not valid, as it contains symbols. {FFFFFF}Please use a roleplay name.");
					invalidNameChange(extraid);
				}
				else if(charCounts[2] >= 1) {
					SendClientMessage(extraid, COLOR_GREY, "Your name is not valid, as it contains numbers. {FFFFFF}Please use a roleplay name.");
					invalidNameChange(extraid);
				}
				else if(charCounts[3] == strlen(szPlayerName) - 1) {
					SendClientMessage(extraid, COLOR_GREY, "Your name is not valid, as it is lower case. {FFFFFF}Please use a roleplay name (i.e. Dave_Meniketti).");
					invalidNameChange(extraid);
				}
				else if(charCounts[4] == strlen(szPlayerName) - 1) {
					SendClientMessage(extraid, COLOR_GREY, "Your name is not valid, as it is upper case. {FFFFFF}Please use a roleplay name (i.e. Dave_Jones).");
					invalidNameChange(extraid);
				}
				else {
				    SendClientMessage(extraid, COLOR_GENANNOUNCE, "SERVER: {FFFFFF}Welcome to "SERVER_NAME".");
				    SendClientMessage(extraid, COLOR_GENANNOUNCE, "SERVER: {FFFFFF}You aren't registered yet. Please enter your desired password in the dialog box to register.");

				    ShowPlayerDialog(extraid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "SERVER: Registration", "Welcome to the "SERVER_NAME" Server.\n\nPlease enter your desired password below!", "Register", "Cancel");
				}
			}
			else {
			    if(!IsPlayerConnected(extraid))
					return mysql_free_result(); 

				SendClientMessage(extraid, COLOR_GENANNOUNCE, "SERVER: {FFFFFF}Welcome to "SERVER_NAME".");
				SendClientMessage(extraid, COLOR_GENANNOUNCE, "SERVER: {FFFFFF}You already have a registered account, please enter your password into the dialog box.");

				ShowPlayerDialog(extraid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "SERVER: Login", "Welcome to the "SERVER_NAME" Server.\n\nPlease enter your password below!", "Login", "Cancel");
			}

			mysql_free_result();
		}
		case THREAD_MOBILE_HISTORY: {
			mysql_store_result();

			if(mysql_num_rows() > 0) {
			    new
			        iLoop;

				format(szMessage, sizeof(szMessage), "");
				format(szLargeString, sizeof(szLargeString), "");
       			while(mysql_retrieve_row()) {
			        if(iLoop == 0)
						format(szLargeString, sizeof(szLargeString), "\n");

					mysql_get_field("phoneAction", szMessage);
					format(szLargeString, sizeof(szLargeString), "%s%s\n", szLargeString, szMessage);
			        iLoop++;
			    }

			    mysql_free_result();
			    return ShowPlayerDialog(extraid, DIALOG_MOBILE_HISTORY, DIALOG_STYLE_LIST, "Mobile Phone: History", szLargeString, "Return", "");
			} else {
			    return ShowPlayerDialog(extraid, DIALOG_MOBILE_HISTORY, DIALOG_STYLE_LIST, "Mobile Phone: History", "There is no recorded history of your mobile phone usage.", "Return", "");
			}
		}
		case THREAD_MOBILE_LIST_CONTACTS: {
			mysql_store_result();

			if(mysql_num_rows() > 0) {
			    new
			        iLoop,
			        szGet[3][64],
			        iNum[2],
			        szCat[512];

			    while(mysql_retrieve_row()) {
			        if(iLoop == 0)
			            format(szCat, sizeof(szCat), "\n{FFFFFF}");

					mysql_get_field("contactName", szGet[0]);
					mysql_get_field("contactAdded", szGet[1]);
					mysql_get_field("contactAddee", szGet[2]);

					iNum[0] = strval(szGet[1]);
					iNum[1] = strval(szGet[2]);

					format(szCat, sizeof(szCat), "%s%s "EMBED_GREY"(#%d){FFFFFF}\n", szCat, szGet[0], iNum[0]);

			        iLoop++;
			    }

				mysql_free_result();
				return ShowPlayerDialog(extraid, DIALOG_MOBILE_HISTORY, DIALOG_STYLE_LIST, "Mobile Phone: List Contacts", szCat, "Return", "");
			} else {
			    return ShowPlayerDialog(extraid, DIALOG_MOBILE_HISTORY, DIALOG_STYLE_LIST, "Mobile Phone: List Contacts", "You don't have any contacts.", "Return", "");
			}
		}
		case THREAD_CHECK_PLATES: {
		    mysql_store_result();

		    mysql_retrieve_row();

		    if(mysql_num_rows() > 0) {
		        mysql_free_result();
			    return ShowPlayerDialog(extraid, DIALOG_LICENSE_PLATE, DIALOG_STYLE_INPUT, "License plate registration", "{FFFFFF}ERROR:"EMBED_GREY" The plate specified already exists. Pick another one.{FFFFFF}\n\nPlease enter a license plate for your vehicle. \n\nThere is only two conditions:\n- The license plate must be unique\n- The license plate can be alphanumerical, but it must consist of only 7 characters and include one space.", "Select", "");
		    }

		    GetPVarString(extraid, "plate", playerVariables[extraid][pCarLicensePlate], 32);
		    DeletePVar(extraid, "plate");

		    SendClientMessage(extraid, COLOR_WHITE, "The license plate you selected has been applied to your vehicle.");

		    SetVehicleNumberPlate(playerVariables[extraid][pCarID], playerVariables[extraid][pCarLicensePlate]);
		    SetVehicleVirtualWorld(playerVariables[extraid][pCarID], GetVehicleVirtualWorld(playerVariables[extraid][pCarID])+1);
		    SetVehicleVirtualWorld(playerVariables[extraid][pCarID], GetVehicleVirtualWorld(playerVariables[extraid][pCarID])-1);
		}
		case THREAD_CHECK_CREDENTIALS: {
		    mysql_store_result();

			if(!IsPlayerConnected(extraid)) return mysql_free_result(); // Incase they're disconnected since... Sometimes queries F*"!%$" up.

			if(mysql_num_rows() == 0) { // INCORRECT PASSWORD!1

				SetPVarInt(extraid, "LA", GetPVarInt(extraid, "LA") + 1);

				new
					playerIP[32];

				if(GetPVarInt(extraid, "LA") > MAX_LOGIN_ATTEMPTS) {
					SendClientMessage(extraid, COLOR_RED, "You have used all available login attempts.");
					GetPlayerIp(extraid, playerIP, sizeof(playerIP));

					GetPlayerName(extraid, szPlayerName, MAX_PLAYER_NAME);
					format(szMessage, sizeof(szMessage), "AdmWarn: {FFFFFF}IP %s has been banned (%d failed 3 attempts on account %s).", playerIP, MAX_LOGIN_ATTEMPTS, szPlayerName);
					submitToAdmins(szMessage, COLOR_HOTORANGE);

					IPBan(playerIP, "Exceeded maximum login attempts.");
					Kick(extraid);
					return 1;

				}
			    else {
					ShowPlayerDialog(extraid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "SERVER: Login", "Welcome to the "SERVER_NAME" Server.\n\nPlease enter your password below!", "Login", "Cancel");
					format(szMessage, sizeof(szMessage), "Incorrect password. You have %d remaining login attempts left.", MAX_LOGIN_ATTEMPTS - GetPVarInt(extraid, "LA"));
					SendClientMessage(extraid, COLOR_HOTORANGE, szMessage);
					return 1;
				}
			}
			else {
			    clearScreen(extraid);
			    DeletePVar(extraid, "LA");

				mysql_retrieve_row();

				mysql_get_field("playerBanned", result);

				if(strval(result) >= 1) {

					new
						playerIP[32];

				    SendClientMessage(extraid, COLOR_RED, "You are banned from this server.");

					GetPlayerIp(extraid, playerIP, sizeof(playerIP));
					GetPlayerName(extraid, szPlayerName, MAX_PLAYER_NAME);

					format(szMessage, sizeof(szMessage), "AdmWarn: {FFFFFF}%s has attempted to evade their account ban (using IP %s).", szPlayerName, playerIP);
					submitToAdmins(szMessage, COLOR_HOTORANGE);

					format(szMessage, sizeof(szMessage), "Attempted ban evasion (%s).", szPlayerName);

					IPBan(playerIP, szMessage);
					Kick(extraid);
				}

				playerVariables[extraid][pBanned] = strval(result);

				mysql_get_field("playerPassword", playerVariables[extraid][pPassword]);

                mysql_get_field("playerEmail", playerVariables[extraid][pEmail]);

                mysql_get_field("playerSkin", result);
                playerVariables[extraid][pSkin] = strval(result);

                mysql_get_field("playerMoney", result);
                playerVariables[extraid][pMoney] = strval(result);

                mysql_get_field("playerBankMoney", result);
                playerVariables[extraid][pBankMoney] = strval(result);

                mysql_get_field("playerPosX", result);
                playerVariables[extraid][pPos][0] = floatstr(result);

                mysql_get_field("playerPosY", result);
                playerVariables[extraid][pPos][1] = floatstr(result);

                mysql_get_field("playerPosZ", result);
                playerVariables[extraid][pPos][2] = floatstr(result);

                mysql_get_field("playerHealth", result);
                playerVariables[extraid][pHealth] = floatstr(result);

                mysql_get_field("playerArmour", result);
                playerVariables[extraid][pArmour] = floatstr(result);
                
				mysql_get_field("playerVIP", result);
                playerVariables[extraid][pVIP] = strval(result);

                mysql_get_field("playerSeconds", result);
                playerVariables[extraid][pSeconds] = strval(result);

                mysql_get_field("playerAdminLevel", result);
                playerVariables[extraid][pAdminLevel] = strval(result);
                
                if(playerVariables[extraid][pAdminLevel] > 0) {
                    mysql_get_field("playerAdminPIN", result);
                    SetPVarInt(extraid, "pAdminPIN", strval(result));
                }

                mysql_get_field("playerAccent", playerVariables[extraid][pAccent]);

	            mysql_get_field("playerInterior", result);
	            playerVariables[extraid][pInterior] = strval(result);

	            mysql_get_field("playerVirtualWorld", result);
	            playerVariables[extraid][pVirtualWorld] = strval(result);

                mysql_get_field("playerID", result);
                playerVariables[extraid][pInternalID] = strval(result);

				mysql_get_field("playerCarLicensePlate", playerVariables[extraid][pCarLicensePlate]);

                mysql_get_field("playerJob", result);
                playerVariables[extraid][pJob] = strval(result);

                mysql_get_field("playerWeapon0", result);
                playerVariables[extraid][pWeapons][0] = strval(result);

                mysql_get_field("playerWeapon1", result);
                playerVariables[extraid][pWeapons][1] = strval(result);

                mysql_get_field("playerWeapon2", result);
                playerVariables[extraid][pWeapons][2] = strval(result);

                mysql_get_field("playerWeapon3", result);
                playerVariables[extraid][pWeapons][3] = strval(result);

                mysql_get_field("playerWeapon4", result);
                playerVariables[extraid][pWeapons][4] = strval(result);

                mysql_get_field("playerWeapon5", result);
                playerVariables[extraid][pWeapons][5] = strval(result);

                mysql_get_field("playerWeapon6", result);
                playerVariables[extraid][pWeapons][6] = strval(result);

                mysql_get_field("playerWeapon7", result);
                playerVariables[extraid][pWeapons][7] = strval(result);

                mysql_get_field("playerWeapon8", result);
                playerVariables[extraid][pWeapons][8] = strval(result);

                mysql_get_field("playerWeapon9", result);
                playerVariables[extraid][pWeapons][9] = strval(result);

				mysql_get_field("playerWeapon10", result);
                playerVariables[extraid][pWeapons][10] = strval(result);

				mysql_get_field("playerWeapon11", result);
                playerVariables[extraid][pWeapons][11] = strval(result);

				mysql_get_field("playerWeapon12", result);
                playerVariables[extraid][pWeapons][12] = strval(result);

				mysql_get_field("playerJobSkill1", result);
                playerVariables[extraid][pJobSkill][0] = strval(result);

				mysql_get_field("playerJobSkill2", result);
                playerVariables[extraid][pJobSkill][1] = strval(result);

				mysql_get_field("playerMaterials", result);
                playerVariables[extraid][pMaterials] = strval(result);

				mysql_get_field("playerGroup", result);
                playerVariables[extraid][pGroup] = strval(result);

				mysql_get_field("playerGroupRank", result);
                playerVariables[extraid][pGroupRank] = strval(result);

				mysql_get_field("playerHours", result);
                playerVariables[extraid][pPlayingHours] = strval(result);

                mysql_get_field("playerWarning1", playerVariables[extraid][pWarning1]);
                mysql_get_field("playerWarning2", playerVariables[extraid][pWarning2]);
                mysql_get_field("playerWarning3", playerVariables[extraid][pWarning3]);

				mysql_get_field("playerHospitalized", result);
                playerVariables[extraid][pHospitalized] = strval(result);

				mysql_get_field("playerAdminName", playerVariables[extraid][pAdminName]);

				mysql_get_field("playerFirstLogin", result);
				playerVariables[extraid][pFirstLogin] = strval(result);

				mysql_get_field("playerGender", result);
				playerVariables[extraid][pGender] = strval(result);

				mysql_get_field("playerPrisonID", result);
                playerVariables[extraid][pPrisonID] = strval(result);

				mysql_get_field("playerPrisonTime", result);
                playerVariables[extraid][pPrisonTime] = strval(result);

                mysql_get_field("playerPhoneNumber", result);
                playerVariables[extraid][pPhoneNumber] = strval(result);

                mysql_get_field("playerPhoneBook", result);
                playerVariables[extraid][pPhoneBook] = strval(result);

                mysql_get_field("playerHelperLevel", result);
                playerVariables[extraid][pHelper] = strval(result);

                mysql_get_field("playerDropCarTimeout", result);
                playerVariables[extraid][pDropCarTimeout] = strval(result);

                mysql_get_field("playerRope", result);
                playerVariables[extraid][pRope] = strval(result);

                mysql_get_field("playerAdminDuty", result);
                playerVariables[extraid][pAdminDuty] = strval(result);

                mysql_get_field("playerCrimes", result);
                playerVariables[extraid][pCrimes] = strval(result);

                mysql_get_field("playerArrests", result);
                playerVariables[extraid][pArrests] = strval(result);

                mysql_get_field("playerWarrants", result);
                playerVariables[extraid][pWarrants] = strval(result);

                mysql_get_field("playerLevel", result);
                playerVariables[extraid][pLevel] = strval(result);

                mysql_get_field("playerAge", result);
                playerVariables[extraid][pAge] = strval(result);

                mysql_get_field("playerCarModel", result);
                playerVariables[extraid][pCarModel] = strval(result);

                mysql_get_field("playerCarMod0", result);
                playerVariables[extraid][pCarMods][0] = strval(result);

                mysql_get_field("playerCarMod1", result);
                playerVariables[extraid][pCarMods][1] = strval(result);

                mysql_get_field("playerCarMod2", result);
                playerVariables[extraid][pCarMods][2] = strval(result);

                mysql_get_field("playerCarMod3", result);
                playerVariables[extraid][pCarMods][3] = strval(result);

                mysql_get_field("playerCarMod4", result);
                playerVariables[extraid][pCarMods][4] = strval(result);

                mysql_get_field("playerCarMod5", result);
                playerVariables[extraid][pCarMods][5] = strval(result);

                mysql_get_field("playerCarMod6", result);
                playerVariables[extraid][pCarMods][6] = strval(result);

                mysql_get_field("playerCarMod7", result);
                playerVariables[extraid][pCarMods][7] = strval(result);

                mysql_get_field("playerCarMod8", result);
                playerVariables[extraid][pCarMods][8] = strval(result);

                mysql_get_field("playerCarMod9", result);
                playerVariables[extraid][pCarMods][9] = strval(result);

                mysql_get_field("playerCarMod10", result);
                playerVariables[extraid][pCarMods][10] = strval(result);

                mysql_get_field("playerCarMod11", result);
                playerVariables[extraid][pCarMods][11] = strval(result);

                mysql_get_field("playerCarMod12", result);
                playerVariables[extraid][pCarMods][12] = strval(result);

                mysql_get_field("playerCarPosX", result);
                playerVariables[extraid][pCarPos][0] = floatstr(result);

                mysql_get_field("playerCarPosY", result);
                playerVariables[extraid][pCarPos][1] = floatstr(result);

                mysql_get_field("playerCarPosZ", result);
                playerVariables[extraid][pCarPos][2] = floatstr(result);

                mysql_get_field("playerCarPosZAngle", result);
                playerVariables[extraid][pCarPos][3] = floatstr(result);

                mysql_get_field("playerCarColour1", result);
                playerVariables[extraid][pCarColour][0] = strval(result);

                mysql_get_field("playerCarColour2", result);
                playerVariables[extraid][pCarColour][1] = strval(result);

                mysql_get_field("playerCarPaintJob", result);
                playerVariables[extraid][pCarPaintjob] = strval(result);

                mysql_get_field("playerCarLock", result);
                playerVariables[extraid][pCarLock] = strval(result);

                mysql_get_field("playerFightStyle", result);
                playerVariables[extraid][pFightStyle] = strval(result);

                mysql_get_field("playerCarWeapon1", result);
                playerVariables[extraid][pCarWeapons][0] = strval(result);

                mysql_get_field("playerCarWeapon2", result);
                playerVariables[extraid][pCarWeapons][1] = strval(result);

                mysql_get_field("playerCarWeapon3", result);
                playerVariables[extraid][pCarWeapons][2] = strval(result);

                mysql_get_field("playerCarWeapon4", result);
                playerVariables[extraid][pCarWeapons][3] = strval(result);

                mysql_get_field("playerCarWeapon5", result);
                playerVariables[extraid][pCarWeapons][4] = strval(result);

                mysql_get_field("playerCarTrunk1", result);
                playerVariables[extraid][pCarTrunk][0] = strval(result);

                mysql_get_field("playerCarTrunk2", result);
                playerVariables[extraid][pCarTrunk][1] = strval(result);

                mysql_get_field("playerPhoneCredit", result);
                playerVariables[extraid][pPhoneCredit] = strval(result);

                mysql_get_field("playerWalkieTalkie", result);
                playerVariables[extraid][pWalkieTalkie] = strval(result);

				GetPlayerName(extraid, playerVariables[extraid][pNormalName], MAX_PLAYER_NAME);

				GetPlayerIp(extraid, playerVariables[extraid][pConnectionIP], 32);

				playerVariables[extraid][pStatus] = 1;
				
				if(playerVariables[extraid][pAdminLevel] > 0) {
					format(result, sizeof(result), "SELECT conIP from playerconnections WHERE conPlayerID = %d AND conIP = '%s'", playerVariables[extraid][pInternalID], playerVariables[extraid][pConnectionIP]);
					mysql_query(result, THREAD_ADMIN_SECURITY, extraid);
					
					if(GetPVarInt(extraid, "pAdminPIN") == 0)
				    	ShowPlayerDialog(extraid, DIALOG_SET_ADMIN_PIN, DIALOG_STYLE_INPUT, "SERVER: Admin PIN creation", "The system has detected you do not yet have an admin PIN set.\n\nThis is a new compulsory security measure.\n\nPlease set a four digit pin:", "OK", "");
				}
				
				format(result, sizeof(result), "SELECT `conTS` FROM `playerconnections` WHERE `conPlayerID` = '%d' ORDER BY `conId` DESC LIMIT 1", playerVariables[extraid][pInternalID]);
				mysql_query(result, THREAD_TIMESTAMP_CONNECT, extraid);

				format(result, sizeof(result), "INSERT INTO playerconnections (conName, conIP, conPlayerID) VALUES('%s', '%s', %d)", playerVariables[extraid][pNormalName], playerVariables[extraid][pConnectionIP], playerVariables[extraid][pInternalID]);
				mysql_query(result, THREAD_RANDOM);

				format(result, sizeof(result), "UPDATE playeraccounts SET playerStatus = '1' WHERE playerID = %d", playerVariables[extraid][pInternalID]);
				mysql_query(result, THREAD_RANDOM);
				
				/*format(result, sizeof(result), "SELECT * FROM playervehicles WHERE pvOwnerId = %d", playerVariables[extraid][pInternalID]);
				mysql_query(result, THREAD_LOAD_PLAYER_VEHICLES, extraid);*/

			    if(playerVariables[extraid][pFirstLogin] >= 1) {
			        // Dialog to send player in to quiz and prevent any other code for the player from being executed, as they have to complete the quiz/tutorial first.
			        return ShowPlayerDialog(extraid, DIALOG_QUIZ, DIALOG_STYLE_LIST, "What is roleplay in SA-MP?", "A type of gamemode where you realistically act out a character\nAn STD\nA track by Jay-Z\nA type of gamemode where you just kill people", "Select", "");
				}

                SetSpawnInfo(extraid, 0, playerVariables[extraid][pSkin], playerVariables[extraid][pPos][0], playerVariables[extraid][pPos][1], playerVariables[extraid][pPos][2], 0, 0, 0, 0, 0, 0, 0);
				SpawnPlayer(extraid);

	         	if(playerVariables[extraid][pWarrants] > 0) {
	         	    SetPlayerWantedLevel(extraid, playerVariables[extraid][pWarrants]);
	         	    SendClientMessage(extraid, COLOR_HOTORANGE, "You're still a wanted man! Your criminal record has been reinstated.");
	         	}

	         	format(szQueryOutput, sizeof(szQueryOutput), "SELECT * FROM `banksuspensions` WHERE `playerID` = %d", playerVariables[extraid][pInternalID]);
				mysql_query(szQueryOutput, THREAD_BANK_SUSPENSION, extraid);

	         	if(playerVariables[extraid][pCarModel] > 0)
					SpawnPlayerVehicle(extraid);

				if(playerVariables[extraid][pLevel] > 0)
				    SetPlayerScore(extraid, playerVariables[extraid][pLevel]);

				if(playerVariables[extraid][pAdminDuty] == 1 && playerVariables[extraid][pAdminLevel] < 1) {
					playerVariables[extraid][pAdminLevel] = 0;
					playerVariables[extraid][pAdminDuty] = 0;
					format(playerVariables[extraid][pAdminName], MAX_PLAYER_NAME, "(null)");
					SendClientMessage(extraid, COLOR_HOTORANGE, "You're no longer an administrator.");
				}

				if(playerVariables[extraid][pAdminLevel] > 0 && playerVariables[extraid][pAdminDuty] > 1)
				    SetPlayerName(extraid, playerVariables[extraid][pAdminName]);
			}

			mysql_free_result();
		}
		case THREAD_BANK_SUSPENSION: {
			mysql_store_result();

			if(mysql_num_rows() < 1)
			    return 1;

			mysql_retrieve_row();

			mysql_get_field("suspensionReason", result);
			SetPVarString(extraid, "BSuspend", result);

			mysql_get_field("suspendeeID", result);
			mysql_free_result();

			format(szQueryOutput, sizeof(szQueryOutput), "SELECT `playerName` FROM `playeraccounts` WHERE `playerID` = %d", strval(result));
			mysql_query(szQueryOutput);
			mysql_store_result();
			mysql_retrieve_row();

			mysql_get_field("playerName", result);
			SetPVarString(extraid, "BSuspendee", result);

			mysql_free_result();
		}
		case THREAD_CHECK_BANS_LIST: {
		    mysql_store_result();
		    
		    // The query worked. We know there's no (serious) MySQL problems, so we won't display the error dialog.
		    SetPVarInt(extraid, "bcs", 1);

			if(!IsPlayerConnected(extraid))
				return mysql_free_result(); // Incase they're disconnected since... Sometimes queries F*"!%$" up.

		    if(mysql_num_rows() >= 1) {
				SendClientMessage(extraid, COLOR_RED, "You're banned from this server.");
				Kick(extraid);
			}
		    else {
				new
			        playerEscapedName[MAX_PLAYER_NAME],
			        queryUsername[100];

			    GetPlayerName(extraid, szPlayerName, MAX_PLAYER_NAME);
			    mysql_real_escape_string(szPlayerName, playerEscapedName);

				// Continue with the rest of the auth code...
			    format(queryUsername, sizeof(queryUsername), "SELECT `playerName` FROM `playeraccounts` WHERE `playerName` = '%s'", playerEscapedName);
			    mysql_query(queryUsername, THREAD_CHECK_ACCOUNT_USERNAME, extraid);
		    }

		    mysql_free_result();
		}
		case THREAD_BAN_PLAYER: {
			format(szQueryOutput, sizeof(szQueryOutput), "UPDATE playeraccounts SET playerBanned = '1' WHERE playerID = '%d'", playerVariables[extraid][pInternalID]);
			mysql_query(szQueryOutput, THREAD_FINALIZE_BAN, extraid);
		}
		case THREAD_FINALIZE_BAN: return Kick(extraid);
		case THREAD_CHECK_PLAYER_NAME_BANNED: {
			mysql_store_result();

			if(mysql_num_rows() >= 1) {
			    GetPVarString(extraid, "playerNameUnban", szPlayerName, MAX_PLAYER_NAME);

				format(szQueryOutput, sizeof(szQueryOutput), "DELETE FROM bans WHERE playerNameBanned = '%s'", szPlayerName);
				mysql_query(szQueryOutput, THREAD_FINALIZE_UNBAN, extraid);
			}
			else {
			    SendClientMessage(extraid, COLOR_GREY, "The specified player name is not banned.");
			}

			mysql_free_result();
		}
		case THREAD_FINALIZE_UNBAN: {
		    new
		        szPlayerName2[MAX_PLAYER_NAME];

            GetPVarString(extraid, "playerNameUnban", szPlayerName2, MAX_PLAYER_NAME);
		    GetPlayerName(extraid, szPlayerName, MAX_PLAYER_NAME);
		    SendClientMessage(extraid, COLOR_WHITE, "The unban has been successful.");

			format(szMessage, sizeof(szMessage), "AdmWarn: {FFFFFF}%s has unbanned player %s.", szPlayerName, szPlayerName2);

			submitToAdmins(szMessage, COLOR_HOTORANGE);
		    adminLog(szMessage);

		    format(szMessage, sizeof(szMessage), "UPDATE playeraccounts SET playerBanned = '0' WHERE playerName = '%s'", szPlayerName2);
		    mysql_query(szMessage);
		}
		case THREAD_INITIATE_HOUSES: {
			mysql_store_result();

			new
			    x;

			while(mysql_retrieve_row()) {
				mysql_get_field("houseID", result);
				x = strval(result);

				mysql_get_field("houseExteriorPosX", result);
				houseVariables[x][hHouseExteriorPos][0] = floatstr(result);

				mysql_get_field("houseExteriorPosY", result);
				houseVariables[x][hHouseExteriorPos][1] = floatstr(result);

				mysql_get_field("houseExteriorPosZ", result);
				houseVariables[x][hHouseExteriorPos][2] = floatstr(result);

				mysql_get_field("houseInteriorPosX", result);
				houseVariables[x][hHouseInteriorPos][0] = floatstr(result);

				mysql_get_field("houseInteriorPosY", result);
				houseVariables[x][hHouseInteriorPos][1] = floatstr(result);

				mysql_get_field("houseInteriorPosZ", result);
				houseVariables[x][hHouseInteriorPos][2] = floatstr(result);

				mysql_get_field("houseInteriorID", result);
				houseVariables[x][hHouseInteriorID] = strval(result);

				mysql_get_field("houseExteriorID", result);
				houseVariables[x][hHouseExteriorID] = strval(result);

				mysql_get_field("houseOwner", houseVariables[x][hHouseOwner]);

				mysql_get_field("housePrice", result);
				houseVariables[x][hHousePrice] = strval(result);

				mysql_get_field("houseLocked", result);
				houseVariables[x][hHouseLocked] = strval(result);

				mysql_get_field("houseMoney", result);
				houseVariables[x][hMoney] = strval(result);

				mysql_get_field("houseWeapon1", result);
				houseVariables[x][hWeapons][0] = strval(result);

				mysql_get_field("houseWeapon2", result);
				houseVariables[x][hWeapons][1] = strval(result);

				mysql_get_field("houseWeapon3", result);
				houseVariables[x][hWeapons][2] = strval(result);

				mysql_get_field("houseWeapon4", result);
				houseVariables[x][hWeapons][3] = strval(result);

				mysql_get_field("houseWeapon5", result);
				houseVariables[x][hWeapons][4] = strval(result);

				mysql_get_field("houseWardrobe1", result);
				houseVariables[x][hWardrobe][0] = strval(result);

				mysql_get_field("houseWardrobe2", result);
				houseVariables[x][hWardrobe][1] = strval(result);

				mysql_get_field("houseWardrobe3", result);
				houseVariables[x][hWardrobe][2] = strval(result);

				mysql_get_field("houseWardrobe4", result);
				houseVariables[x][hWardrobe][3] = strval(result);

				mysql_get_field("houseWardrobe5", result);
				houseVariables[x][hWardrobe][4] = strval(result);

				mysql_get_field("houseMaterials", result);
				houseVariables[x][hMaterials] = strval(result);

				if(!strcmp(houseVariables[x][hHouseOwner], "Nobody", true) && strlen(houseVariables[x][hHouseOwner]) >= 1) {
				    new
				        labelString[96];

				    if(houseVariables[x][hHouseLocked] == 1) {
				    	format(labelString, sizeof(labelString), "House %d (un-owned - /buyhouse)\nPrice: $%d\n\n(locked)", x, houseVariables[x][hHousePrice]);
				    }
				    else {
				        format(labelString, sizeof(labelString), "House %d (un-owned - /buyhouse)\nPrice: $%d\n\nPress ~k~~PED_DUCK~ to enter.", x, houseVariables[x][hHousePrice]);
				    }

				    houseVariables[x][hLabelID] = CreateDynamic3DTextLabel(labelString, COLOR_YELLOW, houseVariables[x][hHouseExteriorPos][0], houseVariables[x][hHouseExteriorPos][1], houseVariables[x][hHouseExteriorPos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
					houseVariables[x][hPickupID] = CreateDynamicPickup(1273, 23, houseVariables[x][hHouseExteriorPos][0], houseVariables[x][hHouseExteriorPos][1], houseVariables[x][hHouseExteriorPos][2], 0, houseVariables[x][hHouseExteriorID], -1, 250);
				}
				else {
				    new
				        labelString[96];

				    if(houseVariables[x][hHouseLocked] == 1) {
				    	format(labelString, sizeof(labelString), "House %d (owned)\nOwner: %s\n\n(locked)", x, houseVariables[x][hHouseOwner]);
				    }
				    else {
				        format(labelString, sizeof(labelString), "House %d (owned)\nOwner: %s\n\nPress ~k~~PED_DUCK~ to enter.", x, houseVariables[x][hHouseOwner]);
				    }

				    houseVariables[x][hLabelID] = CreateDynamic3DTextLabel(labelString, COLOR_YELLOW, houseVariables[x][hHouseExteriorPos][0], houseVariables[x][hHouseExteriorPos][1], houseVariables[x][hHouseExteriorPos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
				    houseVariables[x][hPickupID] = CreateDynamicPickup(1272, 23, houseVariables[x][hHouseExteriorPos][0], houseVariables[x][hHouseExteriorPos][1], houseVariables[x][hHouseExteriorPos][2], 0, houseVariables[x][hHouseExteriorID], -1, 50);
				}

				systemVariables[houseCount]++;
			}

			printf("[script] %d houses loaded.", systemVariables[houseCount]);

			mysql_free_result();
		}
		case THREAD_INITIATE_BUSINESSES: {
			mysql_store_result();

			new
			    x;

			while(mysql_retrieve_row()) {
				mysql_get_field("businessID", result);
				x = strval(result);

				mysql_get_field("businessName", businessVariables[x][bName]);

				mysql_get_field("businessOwner", businessVariables[x][bOwner]);

				mysql_get_field("businessType", result);
				businessVariables[x][bType] = strval(result);

				mysql_get_field("businessExteriorX", result);
				businessVariables[x][bExteriorPos][0] = floatstr(result);

				mysql_get_field("businessExteriorY", result);
				businessVariables[x][bExteriorPos][1] = floatstr(result);

				mysql_get_field("businessExteriorZ", result);
				businessVariables[x][bExteriorPos][2] = floatstr(result);

				mysql_get_field("businessInteriorX", result);
				businessVariables[x][bInteriorPos][0] = floatstr(result);

				mysql_get_field("businessInteriorY", result);
				businessVariables[x][bInteriorPos][1] = floatstr(result);

				mysql_get_field("businessInteriorZ", result);
				businessVariables[x][bInteriorPos][2] = floatstr(result);

				mysql_get_field("businessInterior", result);
				businessVariables[x][bInterior] = strval(result);

				mysql_get_field("businessLock", result);
				businessVariables[x][bLocked] = strval(result);

				mysql_get_field("businessPrice", result);
				businessVariables[x][bPrice] = strval(result);

				mysql_get_field("businessVault", result);
				businessVariables[x][bVault] = strval(result);

				mysql_get_field("businessMiscX", result);
				businessVariables[x][bMiscPos][0] = floatstr(result);

				mysql_get_field("businessMiscY", result);
				businessVariables[x][bMiscPos][1] = floatstr(result);

				mysql_get_field("businessMiscZ", result);
				businessVariables[x][bMiscPos][2] = floatstr(result);

				switch(businessVariables[x][bLocked]) {
					case 1: {
					    if(!strcmp(businessVariables[x][bOwner], "Nobody", true)) {
							format(result, sizeof(result), "%s\n(Business %d - un-owned)\nPrice: $%d (/buybusiness)\n\n(locked)", businessVariables[x][bName], x, businessVariables[x][bPrice]);
						}
						else {
						    format(result, sizeof(result), "%s\n(Business %d - owned by %s)\n\n(locked)", businessVariables[x][bName], x, businessVariables[x][bOwner]);
						}
					}
					case 0: {
					    if(!strcmp(businessVariables[x][bOwner], "Nobody", true)) {
							format(result, sizeof(result), "%s\n(Business %d - un-owned)\nPrice: $%d (/buybusiness)\n\nPress ~k~~PED_DUCK~ to enter", businessVariables[x][bName], x, businessVariables[x][bPrice]);
						}
						else {
						    format(result, sizeof(result), "%s\n(Business %d - owned by %s)\n\nPress ~k~~PED_DUCK~ to enter", businessVariables[x][bName], x, businessVariables[x][bOwner]);
						}
					}
				}

				businessVariables[x][bLabelID] = CreateDynamic3DTextLabel(result, COLOR_YELLOW, businessVariables[x][bExteriorPos][0], businessVariables[x][bExteriorPos][1], businessVariables[x][bExteriorPos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
				businessVariables[x][bPickupID] = CreateDynamicPickup(1239, 23, businessVariables[x][bExteriorPos][0], businessVariables[x][bExteriorPos][1], businessVariables[x][bExteriorPos][2], 0, 0, -1, 250);
				systemVariables[businessCount]++;
			}

			mysql_free_result();
		}
		case THREAD_INITIATE_VEHICLES: {
			mysql_store_result();

			new
			    x,
				bool: success = true;

			while(mysql_retrieve_row()) {
			    mysql_get_field("vehicleID", result);
			    x = strval(result);

				if(systemVariables[vehicleCounts][0] + systemVariables[vehicleCounts][1] + systemVariables[vehicleCounts][2] < MAX_VEHICLES) {
					mysql_get_field("vehicleModelID", result);
					vehicleVariables[x][vVehicleModelID] = strval(result);

					mysql_get_field("vehiclePosX", result);
					vehicleVariables[x][vVehiclePosition][0] = floatstr(result);

					mysql_get_field("vehiclePosY", result);
					vehicleVariables[x][vVehiclePosition][1] = floatstr(result);

					mysql_get_field("vehiclePosZ", result);
					vehicleVariables[x][vVehiclePosition][2] = floatstr(result);

					mysql_get_field("vehiclePosRotation", result);
					vehicleVariables[x][vVehicleRotation] = floatstr(result);

					mysql_get_field("vehicleGroup", result);
					vehicleVariables[x][vVehicleGroup] = strval(result);

					mysql_get_field("vehicleCol1", result);
					vehicleVariables[x][vVehicleColour][0] = strval(result);

					mysql_get_field("vehicleCol2", result);
					vehicleVariables[x][vVehicleColour][1] = strval(result);

					if(vehicleVariables[x][vVehicleColour][0] < 0) {
						vehicleVariables[x][vVehicleColour][0] = random(126);
					}
					if(vehicleVariables[x][vVehicleColour][1] < 0) {
						vehicleVariables[x][vVehicleColour][1] = random(126);
					}

					vehicleVariables[x][vVehicleScriptID] = CreateVehicle(vehicleVariables[x][vVehicleModelID], vehicleVariables[x][vVehiclePosition][0], vehicleVariables[x][vVehiclePosition][1], vehicleVariables[x][vVehiclePosition][2], vehicleVariables[x][vVehicleRotation], vehicleVariables[x][vVehicleColour][0], vehicleVariables[x][vVehicleColour][1], 60000);

					switch(vehicleVariables[x][vVehicleModelID]) { // OnVehicleSpawn has some annoying glitches with this!1. Should fix.
						case 427, 428, 432, 601, 528: SetVehicleHealth(vehicleVariables[x][vVehicleScriptID], 5000.0);
					}
					systemVariables[vehicleCounts][0]++;
				}
				else {
					success = false;
					printf("ERROR: Vehicle limit reached (MODEL %d, VEHICLEID %d, MAXIMUM %d, TYPE STATIC) [01x08]", vehicleVariables[x][vVehicleModelID], x, MAX_VEHICLES);
				}
			}
			if(success) printf("[script] %d vehicles loaded.", systemVariables[vehicleCounts][0]);
			mysql_free_result();
		}
		case THREAD_INITIATE_JOBS: {
			mysql_store_result();

			new
			    x;

			while(mysql_retrieve_row()) {

			    mysql_get_field("jobID", result);
			    x = strval(result);

			    mysql_get_field("jobType", result);
			    jobVariables[x][jJobType] = strval(result);

			    mysql_get_field("jobPositionX", result);
			    jobVariables[x][jJobPosition][0] = floatstr(result);

			    mysql_get_field("jobPositionY", result);
			    jobVariables[x][jJobPosition][1] = floatstr(result);

			    mysql_get_field("jobPositionZ", result);
			    jobVariables[x][jJobPosition][2] = floatstr(result);

			    mysql_get_field("jobName", jobVariables[x][jJobName]);

			    format(result, sizeof(result), "Job %s\nType /getjob", jobVariables[x][jJobName]);

			    jobVariables[x][jJobPickupID] = CreateDynamicPickup(1239, 23, jobVariables[x][jJobPosition][0], jobVariables[x][jJobPosition][1], jobVariables[x][jJobPosition][2], 0, -1, -1, 50);
				jobVariables[x][jJobLabelID] = CreateDynamic3DTextLabel(result, COLOR_YELLOW, jobVariables[x][jJobPosition][0], jobVariables[x][jJobPosition][1], jobVariables[x][jJobPosition][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 50.0);
			}

			mysql_free_result();
		}
		case THREAD_INITIATE_GROUPS: {
		    mysql_store_result();

			new
			    x;

			while(mysql_retrieve_row()) {
			    mysql_get_field("groupID", result);
			    x = strval(result);

			    mysql_get_field("groupName", groupVariables[x][gGroupName]);

			    mysql_get_field("groupType", result);
			    groupVariables[x][gGroupType] = strval(result);

			    mysql_get_field("groupHQExteriorPosX", result);
			    groupVariables[x][gGroupExteriorPos][0] = floatstr(result);

			    mysql_get_field("groupHQExteriorPosY", result);
			    groupVariables[x][gGroupExteriorPos][1] = floatstr(result);

			    mysql_get_field("groupHQExteriorPosZ", result);
			    groupVariables[x][gGroupExteriorPos][2] = floatstr(result);

			    mysql_get_field("groupHQInteriorPosX", result);
			    groupVariables[x][gGroupInteriorPos][0] = floatstr(result);

			    mysql_get_field("groupHQInteriorPosY", result);
			    groupVariables[x][gGroupInteriorPos][1] = floatstr(result);

			    mysql_get_field("groupHQInteriorPosZ", result);
			    groupVariables[x][gGroupInteriorPos][2] = floatstr(result);

			    mysql_get_field("groupHQInteriorID", result);
			    groupVariables[x][gGroupHQInteriorID] = strval(result);

			    mysql_get_field("groupHQLockStatus", result);
			    groupVariables[x][gGroupHQLockStatus] = strval(result);

			    mysql_get_field("groupSafeMoney", result);
			    groupVariables[x][gSafe][0] = strval(result);

			    mysql_get_field("groupSafeMats", result);
			    groupVariables[x][gSafe][1] = strval(result);

			    mysql_get_field("groupSafePosX", result);
			    groupVariables[x][gSafePos][0] = floatstr(result);

			    mysql_get_field("groupSafePosY", result);
			    groupVariables[x][gSafePos][1] = floatstr(result);

			    mysql_get_field("groupSafePosZ", result);
			    groupVariables[x][gSafePos][2] = floatstr(result);

			  /*  mysql_get_field("groupSafePot", result);
			    groupVariables[x][gSafe][2] = strval(result);

			    mysql_get_field("groupSafeCocaine", result);
			    groupVariables[x][gSafe][3] = strval(result); Drugs are out for now. */

			    mysql_get_field("groupMOTD", groupVariables[x][gGroupMOTD]);

			    mysql_get_field("groupRankName1", groupVariables[x][gGroupRankName1]);
			    mysql_get_field("groupRankName2", groupVariables[x][gGroupRankName2]);
			    mysql_get_field("groupRankName3", groupVariables[x][gGroupRankName3]);
			    mysql_get_field("groupRankName4", groupVariables[x][gGroupRankName4]);
			    mysql_get_field("groupRankName5", groupVariables[x][gGroupRankName5]);
			    mysql_get_field("groupRankName6", groupVariables[x][gGroupRankName6]);

				switch(groupVariables[x][gGroupHQLockStatus]) {
			    	case 0: format(result, sizeof(result), "%s's HQ\n\nPress ~k~~PED_DUCK~ to enter.", groupVariables[x][gGroupName]);
			    	case 1: format(result, sizeof(result), "%s's HQ\n\n(locked)", groupVariables[x][gGroupName]);
			    }

				groupVariables[x][gGroupPickupID] = CreateDynamicPickup(1239, 23, groupVariables[x][gGroupExteriorPos][0], groupVariables[x][gGroupExteriorPos][1], groupVariables[x][gGroupExteriorPos][2], 0, -1, -1, 10);
				groupVariables[x][gGroupLabelID] = CreateDynamic3DTextLabel(result, COLOR_YELLOW, groupVariables[x][gGroupExteriorPos][0], groupVariables[x][gGroupExteriorPos][1], groupVariables[x][gGroupExteriorPos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 25.0);

				format(result, sizeof(result), "%s\nGroup Safe", groupVariables[x][gGroupName]);

				groupVariables[x][gSafePickupID] = CreateDynamicPickup(1239, 23, groupVariables[x][gSafePos][0], groupVariables[x][gSafePos][1], groupVariables[x][gSafePos][2], GROUP_VIRTUAL_WORLD+x, groupVariables[x][gGroupHQInteriorID], -1, 10);
				groupVariables[x][gSafeLabelID] = CreateDynamic3DTextLabel(result, COLOR_YELLOW, groupVariables[x][gSafePos][0], groupVariables[x][gSafePos][1], groupVariables[x][gSafePos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, GROUP_VIRTUAL_WORLD+x, groupVariables[x][gGroupHQInteriorID], -1, 20.0);
			}

		    mysql_free_result();
		}
		case THREAD_INITIATE_ASSETS: {
			mysql_store_result();

			new
			    x;

			while(mysql_retrieve_row()) {
			    mysql_get_field("assetID", result);
			    x = strval(result);

			    mysql_get_field("assetValue", result);
			    assetVariables[x][aAssetValue] = strval(result);

			    mysql_get_field("assetName", assetVariables[x][aAssetName]);
			}

			mysql_free_result();
		}
	}

	return 1;
}

stock showStats(playerid, targetid) {
	new
		param1[32],
		date[3],
		param2[32],
		param4[32],
		param3[32]; // I'll add one or two more of these later, they'll be used to show things like sex (if sex = whatever, param1 = "Male";). And we can use them over and over again.

    SendClientMessage(playerid, COLOR_TEAL, "--------------------------------------------------------------------------------------------------------------------------------");

	getdate(date[0], date[1], date[2]);

	if(playerVariables[targetid][pJob] == 0) { param1 = "Unemployed"; }
	else { strcpy(param1, jobVariables[playerVariables[targetid][pJob]][jJobName], sizeof(param1)); } // dest, source, length format(param1, sizeof(param1),"%s",jobVariables[playerVariables[targetid][pJob]][jJobName]); }

	switch(playerVariables[targetid][pGender]) { //{ param2 = "Male"; } else { param2 = "Female"; }
		case 1: param2 = "Male";
		case 2: param2 = "Female";
		default: param2 = "Unknown";
	}

	if(playerVariables[targetid][pPhoneNumber] != -1) { format(param3,sizeof(param3),"%d",playerVariables[targetid][pPhoneNumber]); }
	else { param3 = "None"; }

	format(szMessage, sizeof(szMessage), "%s | Age: %d (born %d) | Gender: %s | Playing hours: %d | Phone number: %s | Job: %s", playerVariables[targetid][pNormalName], date[0]-playerVariables[targetid][pAge], playerVariables[targetid][pAge], param2, playerVariables[targetid][pPlayingHours], param3, param1, param4);
	SendClientMessage(playerid, COLOR_WHITE, szMessage);

	if(playerVariables[targetid][pGroup] < 1) {
		param1 = "None";
		param2 = "None";
	}
	else {
		format(param1, sizeof(param1), "%s", groupVariables[playerVariables[targetid][pGroup]][gGroupName]);

		switch(playerVariables[targetid][pGroupRank]) { // strcpy(dest, source, length);
			case 1: format(param2, sizeof(param2), "%s", groupVariables[playerVariables[targetid][pGroup]][gGroupRankName1]);
			case 2: format(param2, sizeof(param2), "%s", groupVariables[playerVariables[targetid][pGroup]][gGroupRankName2]);
			case 3: format(param2, sizeof(param2), "%s", groupVariables[playerVariables[targetid][pGroup]][gGroupRankName3]);
			case 4: format(param2, sizeof(param2), "%s", groupVariables[playerVariables[targetid][pGroup]][gGroupRankName4]);
			case 5: format(param2, sizeof(param2), "%s", groupVariables[playerVariables[targetid][pGroup]][gGroupRankName5]);
			case 6: format(param2, sizeof(param2), "%s", groupVariables[playerVariables[targetid][pGroup]][gGroupRankName6]);
		}
	}

	if(playerVariables[targetid][pWalkieTalkie] == -1) param3 = "None";
	else if(playerVariables[targetid][pWalkieTalkie] == 0) param3 = "Disabled";
	else format(param3, sizeof(param3), "#%d khz", playerVariables[targetid][pWalkieTalkie]);

	format(szMessage, sizeof(szMessage), "Group: %s | Rank: %s (%d) | Bank: $%d | Cash: $%d | Materials: %d | Radio: %s", param1, param2, playerVariables[targetid][pGroupRank], playerVariables[targetid][pBankMoney], playerVariables[targetid][pMoney], playerVariables[targetid][pMaterials], param3);
	SendClientMessage(playerid, COLOR_WHITE, szMessage);

	format(szMessage, sizeof(szMessage), "Rope: %d | Weapon skill: %d (%d weapons) | Tracking skill: %d (%d searches) | Arrests: %d | Crimes: %d | Credit: $%d", playerVariables[targetid][pRope], playerVariables[targetid][pJobSkill][0]/50, playerVariables[targetid][pJobSkill][0], playerVariables[targetid][pJobSkill][1]/50, playerVariables[targetid][pJobSkill][1], playerVariables[targetid][pArrests], playerVariables[targetid][pCrimes], playerVariables[targetid][pPhoneCredit] / 60);
	SendClientMessage(playerid, COLOR_WHITE, szMessage);

	if(playerVariables[playerid][pAdminLevel] >= 1) {
		new
			Float:HAFloats[2],
			country[MAX_COUNTRY_NAME];

		GetPlayerHealth(targetid,HAFloats[0]);
		GetPlayerArmour(targetid,HAFloats[1]);
		GetCountryName(playerVariables[targetid][pConnectionIP], country, sizeof(country));

		if(playerVariables[targetid][pCarModel] >= 400)
			format(param4, sizeof(param4), "%s (ID %d)", VehicleNames[playerVariables[targetid][pCarModel] - 400], playerVariables[targetid][pCarID]);
		else
			param4 = "None";

		param1 = (playerVariables[targetid][pStatus] != 1) ? ("Unauthenticated") : ("Authenticated");
			
		format(szMessage, sizeof(szMessage), "Status: %s | Admin Level: %d | Interior: %d | VW: %d | House: %d | Business: %d | Vehicle: %s", param1, playerVariables[targetid][pAdminLevel], playerVariables[targetid][pInterior], playerVariables[targetid][pVirtualWorld], getPlayerHouseID(targetid), getPlayerBusinessID(targetid), param4);
		SendClientMessage(playerid, COLOR_WHITE, szMessage);

		switch(playerVariables[targetid][pPrisonID]) {
			case 0: format(szMessage, sizeof(szMessage), "IP: %s | Country: %s | Admin Name: %s | Health: %.1f | Armour: %.1f", playerVariables[targetid][pConnectionIP], country, playerVariables[targetid][pAdminName], HAFloats[0], HAFloats[1]);
			case 1: format(szMessage, sizeof(szMessage), "IP: %s | Country: %s | Admin Name: %s | Health: %.1f | Armour: %.1f | Admin Prison Time: %d", playerVariables[targetid][pConnectionIP], country, playerVariables[targetid][pAdminName], HAFloats[0], HAFloats[1], playerVariables[targetid][pPrisonTime]);
			case 2: format(szMessage, sizeof(szMessage), "IP: %s | Country: %s | Admin Name: %s | Health: %.1f | Armour: %.1f | Admin Jail Time: %d", playerVariables[targetid][pConnectionIP], country, playerVariables[targetid][pAdminName], HAFloats[0], HAFloats[1], playerVariables[targetid][pPrisonTime]);
			case 3: format(szMessage, sizeof(szMessage), "IP: %s | Country: %s | Admin Name: %s | Health: %.1f | Armour: %.1f | Jail Time: %d", playerVariables[targetid][pConnectionIP], country, playerVariables[targetid][pAdminName], HAFloats[0], HAFloats[1], playerVariables[targetid][pPrisonTime]);
		}

		SendClientMessage(playerid, COLOR_WHITE, szMessage);
	}

	SendClientMessage(playerid, COLOR_TEAL, "--------------------------------------------------------------------------------------------------------------------------------");
	return 1;
}

public invalidNameChange(playerid) {
	// Anti-spam mechanism to confirm the feature isn't being spammed
    if(gettime()-GetPVarInt(playerid, "namet") < 3) {
        if(GetPVarInt(playerid, "namett") != 0)
            KillTimer(GetPVarInt(playerid, "namett")); // Kill the timer if it already exists and let it create a new one
            
        // Call (self) again in 4 seconds to avoid clogging the server with useless requests
        SetPVarInt(playerid, "namett", SetTimerEx("invalidNameChange", 4000, false, "d", playerid));
        return 1;
    }
        
	format(playerVariables[playerid][pNormalName], MAX_PLAYER_NAME, "NONRPNAME[%d]", playerid);
	SetPlayerName(playerid, playerVariables[playerid][pNormalName]);
	
	SendClientMessage(playerid, COLOR_GREY, "You are being prompted to change your name. You can do this by following the instructions as they are written in the dialog.");
	ShowPlayerDialog(playerid, DIALOG_RP_NAME_CHANGE, DIALOG_STYLE_INPUT, "SERVER: Non RP name change", "This server has a strict name policy.\n\nYou must enter a valid roleplay name, the name must:\n- Be under 20 characters\n- Not contain numbers\n- Contain only two uppercase characters for the forename and surname\n- Be in the format of Forename_Surname", "OK", "Cancel");
	SetPVarInt(playerid, "namet", gettime());
	return 1;
}

/*stock despawnPlayersVehicles(playerid) {
	new
	    iIterator;

	for(;;) {
	    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_RealID", iIterator);

	    if(GetPVarType(playerid, szSmallString) != 0)
	        DestroyVehicle(GetPVarInt(playerid, szSmallString));
		else
		    break;
		    
		iIterator++;
	}
	return 1;
}

stock getPlayerVehicleSlot(playerid, vehicleid) {
	new
	    iIterator;

	for(;;) {
	    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_RealID", iIterator);

	    if(GetPVarInt(playerid, szSmallString) == vehicleid)
	        return iIterator;
		else
		    break;
		    
		iIterator++;
	}

	return -1;
}

stock getPlayerVehicleOwnerId(vehicleid) {
	new
	    iIterator;
	    
	foreach(Player, i) {
		for(;;) {
		    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_RealID", iIterator);

		    if(GetPVarInt(playerid, szSmallString) == vehicleid)
		        return i;
			else
			    break;

			iIterator++;
		}
	}
	
	return INVALID_PLAYER_ID;
}

stock countPlayersVehicles(playerid) {
	new
	    iIterator,
	    iCount;
	    
	for(;;) {
	    format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Model", iIterator);
	    
	    if(GetPVarType(playerid, szSmallString) != 0)
	        iCount++;
		else
		    break;

		iIterator++;
	}
	
	return iCount;
}*/

stock suspensionCheck(playerid) {
	if(GetPVarType(playerid, "BSuspend") != 0) {
	    new
	        szReason[64],
			szSuspendee[MAX_PLAYER_NAME];

	    GetPVarString(playerid, "BSuspend", szReason, sizeof(szReason));
	    GetPVarString(playerid, "BSuspendee", szSuspendee, MAX_PLAYER_NAME);
	    format(szMessage, sizeof(szMessage), "Your bank account has been suspended by {FFFFFF}%s{CECECE}. Reason: {FFFFFF}%s{CECECE}.", szSuspendee, szReason);
	    SendClientMessage(playerid, COLOR_GREY, szMessage);
	    return 1;
	}

	return 0;
}

stock submitToAdmins(string[], color) {
	foreach(Player, x) {
		if(playerVariables[x][pAdminLevel] >= 1) {
			SendClientMessage(x, color, string);
		}
	}
	return 1;
}

stock substr_count(substring[], string[]) {
	new
		tmpcount;

	for( new i = 0; i < strlen(string); i++)
	{
        if(strfind(string[i], substring, true))
        {
			tmpcount++;
        }
	}
	return tmpcount;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid) {
	#if defined DEBUG
	    printf("[debug] OnPlayerInteriorChange(%d, %d, %d)", playerid, newinteriorid, oldinteriorid);
	#endif
	
	if(newinteriorid == 0) {
		SetPlayerWeather(playerid, weatherVariables[0]);
		SetPlayerVirtualWorld(playerid, 0); // Setting their virtual world in interior 0 keeps some annoying VW issues at bay.
	}
	else SetPlayerWeather(playerid, INTERIOR_WEATHER_ID);

	if(playerVariables[playerid][pSpectating] == INVALID_PLAYER_ID && playerVariables[playerid][pEvent] == 0) {
		playerVariables[playerid][pInterior] = newinteriorid;
		playerVariables[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid) {
	#if defined DEBUG
	    printf("[debug] OnPlayerExitVehicle(%d, %d)", playerid, vehicleid);
	#endif
	
	return SetPlayerArmedWeapon(playerid, 0);
}

stock IsAPlane(vehicleid) {
	switch(GetVehicleModel(vehicleid)) {
		case 592, 577, 511, 512, 593, 520, 553, 476, 519, 460, 513, 548, 425, 417, 487, 488, 497, 563, 447, 469: return 1;
	}
	return 0;
}

stock IsABoat(vehicleid) {
	switch(GetVehicleModel(vehicleid)) {
		case 472, 473, 493, 595, 484, 430, 453, 452, 446, 454: return 1;
	}
	return 0;
}

stock SendToGroupType(type, colour, szMessage2[]) {
	for(new iGroup; iGroup < MAX_GROUPS; iGroup++) {
	    if(groupVariables[iGroup][gGroupType] == type)
	        SendToGroup(iGroup, colour, szMessage2);
	}
	return 1;
}

stock IsACopCar(vehicleid) {
	switch(GetVehicleModel(vehicleid)) {
		case 596 .. 599: return 1;
	}
	return 0;
}

public OnPlayerStateChange(playerid, newstate, oldstate) {
	#if defined DEBUG
	    printf("[debug] OnPlayerStateChange(%d, %d, %d)", playerid, newstate, oldstate);
	#endif
	
	if(newstate == 3) {
		if(IsAPlane(GetPlayerVehicleID(playerid))) {
			givePlayerValidWeapon(playerid, 46);
		}
	}
	else if(newstate == 2) { // Removed the passenger check, as it caused weapons to bug.
		if(playerVariables[playerid][pEvent] == 0) {
			ResetPlayerWeapons(playerid);
			givePlayerWeapons(playerid);
		}
		if(IsAPlane(GetPlayerVehicleID(playerid))) {
			givePlayerValidWeapon(playerid, 46);
		}

		for(new i = 0; i < MAX_VEHICLES; i++) {
		    if(vehicleVariables[i][vVehicleScriptID] == GetPlayerVehicleID(playerid) && vehicleVariables[i][vVehicleGroup] != 0 && vehicleVariables[i][vVehicleGroup] != playerVariables[playerid][pGroup]) {

				if(playerVariables[playerid][pAdminLevel] >= 1 && playerVariables[playerid][pAdminDuty] >= 1) {
					format(szMessage, sizeof(szMessage), "This %s (model %d, ID %d) is locked to group %s (%d).", VehicleNames[GetVehicleModel(i) - 400], GetVehicleModel(i), i, groupVariables[vehicleVariables[i][vVehicleGroup]][gGroupName], vehicleVariables[i][vVehicleGroup]);
					SendClientMessage(playerid, COLOR_GREY, szMessage);
					return 1;
				}
				else {
					SendClientMessage(playerid, COLOR_GREY, "This vehicle is locked.");
					RemovePlayerFromVehicle(playerid);
					return 1;
				}
			}
        }
		foreach(Player, x) {
			if(playerVariables[x][pCarID] == GetPlayerVehicleID(playerid)) {
				if(playerVariables[playerid][pAdminLevel] >= 1 && playerVariables[playerid][pAdminDuty] >= 1) {

					GetPlayerName(x, szPlayerName, MAX_PLAYER_NAME);
					format(szMessage, sizeof(szMessage), "This %s (model %d, ID %d) is owned by %s.", VehicleNames[playerVariables[x][pCarModel] - 400], playerVariables[x][pCarModel], playerVariables[x][pCarID], szPlayerName);
					SendClientMessage(playerid, COLOR_GREY, szMessage);
				}
				else if(playerVariables[x][pCarLock] == 1) {
					RemovePlayerFromVehicle(playerid);
					SendClientMessage(playerid, COLOR_GREY, "This vehicle is locked.");
				}
			}
		}
		

		// Confirm the old state was on foot and if they should be frozen, then remove them
		if(oldstate == 1 && playerVariables[playerid][pFreezeType] != 0 && playerVariables[playerid][pFreezeTime] != 0)
  			RemovePlayerFromVehicle(playerid);
    }

	foreach(Player, x) {
		if(playerVariables[x][pSpectating] != INVALID_PLAYER_ID && playerVariables[x][pSpectating] == playerid) {
			if(newstate == 2 && oldstate == 1 || newstate == 3 && oldstate == 1) {
				PlayerSpectateVehicle(x, GetPlayerVehicleID(playerid));
			}
			else {
				PlayerSpectatePlayer(x, playerid);
			}
		}
	}
	
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid) {
	#if defined DEBUG
	    printf("[debug] OnVehicleStreamIn(%d, %d)", vehicleid, forplayerid);
	#endif
	
	foreach(Player, x) {
	    if(playerVariables[x][pCarID] == vehicleid && playerVariables[x][pCarLock] == 1) {
			SetVehicleParamsForPlayer(vehicleid, forplayerid, 0, 1);
	    }
	}
	return 1;
}

stock createRelevantItems(const businessid) {
	switch(businessVariables[businessid][bType]) {
		case 1: {
			format(szLargeString, sizeof(szLargeString), "INSERT INTO `businessitems` (`itemBusinessId`, `itemTypeId`, `itemPrice`, `itemName`) VALUES (%d, 1, 5, 'Rope'), (%d, 2, 15, 'Walkie Talkie'), (%d, 3, 10, 'Phone Book'),", businessid, businessid, businessid);
			format(szLargeString, sizeof(szLargeString), "%s(%d, 4, 10, 'Phone Credit'), (%d, 5, 10, 'Mobile Phone');", szLargeString, businessid, businessid);
			mysql_query(szLargeString);
		}
		case 2: {
 			format(szLargeString, sizeof(szLargeString), "INSERT INTO `businessitems` (`itemBusinessId`, `itemTypeId`, `itemPrice`, `itemName`) VALUES (%d, 18, 50, 'All Skins');", businessid);
			mysql_query(szLargeString);
		}
		case 3: {
 			format(szLargeString, sizeof(szLargeString), "INSERT INTO `businessitems` (`itemBusinessId`, `itemTypeId`, `itemPrice`, `itemName`) VALUES (%d, 14, 4, 'Cigar'), (%d, 15, 1, 'Sprunk'), (%d, 16, 10, 'Wine'), (%d, 17, 3, 'Beer');", businessid, businessid, businessid, businessid);
			mysql_query(szLargeString);
		}
		case 4: {
 			format(szLargeString, sizeof(szLargeString), "INSERT INTO `businessitems` (`itemBusinessId`, `itemTypeId`, `itemPrice`, `itemName`) VALUES (%d, 9, 10, 'Purple Dildo'), (%d, 10, 15, 'Small White Vibrator'), (%d, 11, 20, 'Large White Vibrator'),", businessid, businessid, businessid);
			format(szLargeString, sizeof(szLargeString), "%s(%d, 12, 15, 'Silver Vibrator'), (%d, 13, 10, 'Flowers');", szLargeString, businessid, businessid);
			mysql_query(szLargeString);
		}
		case 7: {
			format(szLargeString, sizeof(szLargeString), "INSERT INTO `businessitems` (`itemBusinessId`, `itemTypeId`, `itemPrice`, `itemName`) VALUES (%d, 6, 5, 'Box Meal 1'), (%d, 7, 10, 'Box Meal 2'), (%d, 8, 20, 'Box Meal 3');", businessid, businessid, businessid);
			mysql_query(szLargeString);
		}
	}
	
	mysql_query("SELECT * FROM businessitems", THREAD_INITIATE_BUSINESS_ITEMS);
	return 1;
}

stock getPlayerCheckpointReason(const playerid) {
    switch(playerVariables[playerid][pCheckpoint]) {
		case 1: {
		    format(szMessage, sizeof(szMessage), "Detective");
			return szMessage;
		}
		case 2: {
		    format(szMessage, sizeof(szMessage), "Matrun");
			return szMessage;
		}
		case 3: {
			format(szMessage, sizeof(szMessage), "Dropcar");
			return szMessage;
		}
		case 4: {
			format(szMessage, sizeof(szMessage), "Findcar");
			return szMessage;
		}
		case 5: {
			format(szMessage, sizeof(szMessage), "Backup");
			return szMessage;
		}
		case 6: {
			format(szMessage, sizeof(szMessage), "Home/Business");
			return szMessage;
		}
	}

	format(szMessage, sizeof(szMessage), "01x05");
	return szMessage;
}

public OnPlayerEnterCheckpoint(playerid) {
	#if defined DEBUG
	    printf("[debug] OnPlayerEnterCheckpoint(%d)", playerid);
	#endif
	
	switch(playerVariables[playerid][pCheckpoint]) {
	    case 1: {
	        SendClientMessage(playerid, COLOR_WHITE, "You have reached your destination.");
	        DisablePlayerCheckpoint(playerid);

	        playerVariables[playerid][pCheckpoint] = 0;
	    }
		case 2: {
		    if(playerVariables[playerid][pMatrunTime] < 30) {
		        GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

		        format(szMessage, sizeof(szMessage), "AdmWarn: {FFFFFF}%s may possibly be teleport matrunning (reached checkpoint in %d seconds).", szPlayerName, playerVariables[playerid][pMatrunTime]);
				submitToAdmins(szMessage, COLOR_HOTORANGE);
			}
		    else {
		        SendClientMessage(playerid, COLOR_WHITE, "You have collected 100 materials!");
		        DisablePlayerCheckpoint(playerid);

		        playerVariables[playerid][pCheckpoint] = 0;
		        playerVariables[playerid][pMaterials] += 100;
		        playerVariables[playerid][pMatrunTime] = 0;
	        }
	    }
	    case 3: {
			if(!IsPlayerInAnyVehicle(playerid))
				return SendClientMessage(playerid, COLOR_GREY, "You aren't in a vehicle; please get a vehicle to drop off at the crane.");

			else if(playerVariables[playerid][pCarID] == GetPlayerVehicleID(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You can't sell your own vehicle here.");

			foreach(Player, v) {
				if(playerVariables[v][pCarID] == GetPlayerVehicleID(playerid)) {
					DestroyVehicle(GetPlayerVehicleID(playerid)); // If an owned car is destroyed... it'll be manually despawned...

					playerVariables[v][pCarPos][0] = 2157.5559; // ...moved to the LS junk yard...
					playerVariables[v][pCarPos][1] = -1977.6494;
					playerVariables[v][pCarPos][2] = 13.3835;
					playerVariables[v][pCarPos][3] = 177.3687; // have its Z angle set

					SpawnPlayerVehicle(v); // And spawned.

					SetVehicleHealth(playerVariables[v][pCarID], 400.0); // A wrecked car is a wrecked car.
				}
				else SetVehicleToRespawn(GetPlayerVehicleID(playerid));
			}

			new
				string[61],
				rand;

			switch(GetVehicleModel(GetPlayerVehicleID(playerid))) { // Thanks to Danny for these, lol
				case 405: rand = random(2000) + 2500;
				case 561: rand = random(2000) + 2750;
				case 535: rand = random(2000) + 2250;
				case 463: rand = random(2000) + 2000;
				case 461: rand = random(2000) + 2500;
				case 429: rand = random(2000) + 4500;
				case 451: rand = random(2000) + 4750;
				case 491: rand = random(2000) + 1800;
				case 492: rand = random(2000) + 1500;
				case 603: rand = random(2000) + 3800;
				case 502: rand = random(2000) + 5000;
				case 558: rand = random(2000) + 2500;
				case 554: rand = random(2000) + 1900;
				case 588: rand = random(2000) + 2300;
				case 518: rand = random(2000) + 2250;
				case 475: rand = random(2000) + 2300;
				case 542: rand = random(2000) + 2000;
				case 466: rand = random(2000) + 2400;
				case 462: rand = random(2000) + 500;
				case 596: rand = random(2000) + 3000;
				case 427: rand = random(2000) + 4500;
				case 528: rand = random(2000) + 4250;
				case 601: rand = random(2000) + 5000;
				case 523: rand = random(2000) + 3000;
				case 600: rand = random(2000) + 2250;
				case 468: rand = random(2000) + 2000;
				case 418: rand = random(2000) + 2100;
				case 482: rand = random(2000) + 2750;
				case 440: rand = random(2000) + 2250;
				case 587: rand = random(2000) + 3800;
				case 412: rand = random(2000) + 2500;
				case 534: rand = random(2000) + 2700;
				case 536: rand = random(2000) + 2600;
				case 567: rand = random(2000) + 2650;
				case 448: rand = random(2000) + 550;
				case 602: rand = random(2000) + 3100;
				case 586: rand = random(2000) + 2200;
				case 421: rand = random(2000) + 2900;
				case 581: rand = random(2000) + 2250;
				case 521: rand = random(2000) + 2750;
				case 598: rand = random(2000) + 3250;
				case 574: rand = random(2000) + 750;
				case 500: rand = random(2000) + 2700;
				case 579: rand = random(2000) + 3100;
				case 467: rand = random(2000) + 2000;
				case 426: rand = random(2000) + 2600;
				case 555: rand = random(2000) + 3250;
				case 437: rand = random(2000) + 4800;
				case 428: rand = random(2000) + 4750;
				case 442: rand = random(2000) + 2200;
				case 458: rand = random(2000) + 2000;
				case 527: rand = random(2000) + 1950;
				case 496: rand = random(2000) + 2100;
				case 400: rand = random(2000) + 3000;
				case 605: rand = random(2000) + 900;
				case 604: rand = random(2000) + 900;
				case 522: rand = random(2000) + 5000;
				case 438: rand = random(2000) + 2750;
				case 420: rand = random(2000) + 2600;
				case 404: rand = random(2000) + 1250;
				case 585: rand = random(2000) + 2400;
				case 543: rand = random(2000) + 2000;
				case 515: rand = random(2000) + 4500;
				case 560: rand = random(2000) + 3900;
				case 409: rand = random(2000) + 2950;
				case 402: rand = random(2000) + 3250;
				default: rand = random(2000) + 1000;
			}

			playerVariables[playerid][pDropCarTimeout] = 1800;
            playerVariables[playerid][pCheckpoint] = 0;
            DisablePlayerCheckpoint(playerid);
			playerVariables[playerid][pMoney] += rand;

			format(string, sizeof(string), "You have dropped your vehicle at the crane and earned $%d!", rand);
            SendClientMessage(playerid, COLOR_WHITE, string);
		}
		case 4: {

	        SendClientMessage(playerid, COLOR_WHITE, "You have reached your vehicle.");
	        DisablePlayerCheckpoint(playerid);

	        playerVariables[playerid][pCheckpoint] = 0;

		}
		case 5: {
			if(playerVariables[playerid][pBackup] != -1) {

				SendClientMessage(playerid, COLOR_WHITE, "You have reached the backup checkpoint.");
				DisablePlayerCheckpoint(playerid);

				playerVariables[playerid][pCheckpoint] = 0;
				playerVariables[playerid][pBackup] = -1;
			}
		}
    	default: {
			DisablePlayerCheckpoint(playerid);
			playerVariables[playerid][pCheckpoint] = 0;
		}
    }
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(playerVariables[playerid][pTutorial] == 1) {
	    new
			Keys,
			ud,
			lr;

	    GetPlayerKeys(playerid, Keys, ud, lr);
	    if(lr > 0) {
	        if(playerVariables[playerid][pSkinCount]+1 >= sizeof(tutorialSkins)) {
	            SetPlayerSkin(playerid, 0);
	            playerVariables[playerid][pSkinCount] = 0;
	            PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
	        }
	        else {
		        playerVariables[playerid][pSkinCount]++;
				SetPlayerSkin(playerid, tutorialSkins[playerVariables[playerid][pSkinCount]]);
			}
		}
	    else if(lr < 0) {
	        if(playerVariables[playerid][pSkinCount]-1 < 0) {
	            SetPlayerSkin(playerid, 0);
	            playerVariables[playerid][pSkinCount] = 0;
	            PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
	        }
	        else {
		        playerVariables[playerid][pSkinCount]--;
				SetPlayerSkin(playerid, tutorialSkins[playerVariables[playerid][pSkinCount]]);
			}
		}
	}

	if(playerVariables[playerid][pOnRequest] != INVALID_PLAYER_ID) {
	    new
			Keys,
			ud,
			lr;

	    GetPlayerKeys(playerid, Keys, ud, lr);

	    if(lr > 0) {
	        GetPlayerPos(playerVariables[playerid][pOnRequest], playerVariables[playerVariables[playerid][pOnRequest]][pPos][0], playerVariables[playerVariables[playerid][pOnRequest]][pPos][1], playerVariables[playerVariables[playerid][pOnRequest]][pPos][2]);

	        SetPlayerPos(playerid, playerVariables[playerVariables[playerid][pOnRequest]][pPos][0], playerVariables[playerVariables[playerid][pOnRequest]][pPos][1], playerVariables[playerVariables[playerid][pOnRequest]][pPos][2]);
			TextDrawHideForPlayer(playerid, textdrawVariables[1]);

			SendClientMessage(playerid, COLOR_WHITE, "You have teleported to the player who has requested help.");

			playerVariables[playerid][pOnRequest] = INVALID_PLAYER_ID;
		}
	    else if(lr < 0) {
			TextDrawHideForPlayer(playerid, textdrawVariables[1]);
			playerVariables[playerid][pOnRequest] = INVALID_PLAYER_ID;
		}
	}

	if(playerVariables[playerid][pTabbed] == 1) {
		playerVariables[playerid][pTabbed] = 0;
		DestroyDynamic3DTextLabel(playerVariables[playerid][pAFKLabel]);
		if(playerVariables[playerid][pOutstandingWeaponRemovalSlot] >= 1) {
		    if(playerVariables[playerid][pOutstandingWeaponRemovalSlot] == 40) {
		        ResetPlayerWeapons(playerid);
		    }
		    else {
			    ResetPlayerWeapons(playerid);
				playerVariables[playerid][pWeapons][playerVariables[playerid][pOutstandingWeaponRemovalSlot]] = 0;
				givePlayerWeapons(playerid);
			}
			playerVariables[playerid][pAnticheatExemption] = 6;
		}
	}

    if(playerVariables[playerid][pTutorial] >= 4 && playerVariables[playerid][pTutorial] < 14 && GetPVarInt(playerid, "tutTime") > 0)
		TextDrawShowForPlayer(playerid, textdrawVariables[8]);

	if(playerVariables[playerid][pTutorial] >= 4 && playerVariables[playerid][pTutorial] < 14 && GetPVarInt(playerid, "tutTime") < 1) {
	    new
			Keys,
			ud,
			lr;

	    GetPlayerKeys(playerid, Keys, ud, lr);
	    if(lr > 0) {
	        playerVariables[playerid][pTutorial]++;
	        switch(playerVariables[playerid][pTutorial]) {
				case 5: {
					SendClientMessage(playerid, COLOR_YELLOW, "Overview");
					SendClientMessage(playerid, COLOR_WHITE, "This is a roleplay server, which means you act out a character as if it were real.");
					SendClientMessage(playerid, COLOR_WHITE, "Pressing the button to open the textbox (usually T) and simply typing a message,");
					SendClientMessage(playerid, COLOR_WHITE, "will broadcast what you've typed to the people around you as an 'IC' (in character) message.");
					SendClientMessage(playerid, COLOR_WHITE, " ");
					SendClientMessage(playerid, COLOR_WHITE, "Using /b and typing your message (e.g. /b hello) will enclose what you've written in double parenthesis.");
                    SendClientMessage(playerid, COLOR_WHITE, "This will broadcast your message to the people around you as an 'OOC' (out of character) message.");
                    SendClientMessage(playerid, COLOR_WHITE, " ");
                    SendClientMessage(playerid, COLOR_WHITE, "Similarly, using /o has the same purpose as /b, though this time the message will be broadcasted throughout the entire server.");

                    SetPVarInt(playerid, "tutTime", 10);
                    TextDrawHideForPlayer(playerid, textdrawVariables[7]);
                    SendClientMessage(playerid, COLOR_YELLOW, "");
				}
				case 6: {
				    clearScreen(playerid);
					SendClientMessage(playerid, COLOR_YELLOW, "Locations:");
					SendClientMessage(playerid, COLOR_YELLOW, "");

					SendClientMessage(playerid, COLOR_YELLOW, "The Bank");
					SendClientMessage(playerid, COLOR_WHITE, "This is the place you'll want to go to make your various monetary transactions.");
					SendClientMessage(playerid, COLOR_WHITE, "The following commands will be useful:");
					SendClientMessage(playerid, COLOR_WHITE, "/balance, /withdraw and /deposit");

					SetPlayerVirtualWorld(playerid, 0);
					SetPlayerInterior(playerid, 0);

					SetPlayerCameraPos(playerid, 608.430480, -1203.073608, 17.801227);
					SetPlayerCameraLookAt(playerid, 594.246276, -1237.907348, 17.801227);
					SetPlayerPos(playerid, 526.8502, -1261.1985, 16.2272-30);

					SetPVarInt(playerid, "tutTime", 4);
					TextDrawHideForPlayer(playerid, textdrawVariables[7]);
					SendClientMessage(playerid, COLOR_YELLOW, "");
				}
				case 7: {
					SendClientMessage(playerid, COLOR_YELLOW, "The Crane");
					SendClientMessage(playerid, COLOR_WHITE, "At the crane, you can drop off vehicles for money.");
					SendClientMessage(playerid, COLOR_WHITE, "Use the command /dropcar to drive the vehicle to the red marker.");

					SetPlayerCameraPos(playerid, 2637.447265, -2226.906738, 16.296875);
					SetPlayerCameraLookAt(playerid, 2651.442626, -2227.208496, 16.296875);
					SetPlayerPos(playerid, 2641.4473, -2226.9067, 16.2969-30);

					SetPVarInt(playerid, "tutTime", 5);
					TextDrawHideForPlayer(playerid, textdrawVariables[7]);
					SendClientMessage(playerid, COLOR_YELLOW, "");
				}
				case 8: {
					SendClientMessage(playerid, COLOR_YELLOW, "Los Santos Police Department");
					SendClientMessage(playerid, COLOR_WHITE, "This is the place where you'll find police officers.");
					SendClientMessage(playerid, COLOR_WHITE, "Inside, you should wait in lobby before being served.");
					SendClientMessage(playerid, COLOR_WHITE, "If you want to apply to the LSPD, please visit our forum.");

					SetPlayerCameraPos(playerid, 1495.273925, -1675.542358, 28.382812);
					SetPlayerCameraLookAt(playerid, 1535.268432, -1675.874023, 13.382812);
					SetPlayerPos(playerid, 2641.4473, -2226.9067, 16.2969-30);

					SetPVarInt(playerid, "tutTime", 6);
					TextDrawHideForPlayer(playerid, textdrawVariables[7]);
					SendClientMessage(playerid, COLOR_YELLOW, "");
				}
				case 9: {
				    clearScreen(playerid);
					SendClientMessage(playerid, COLOR_YELLOW, "Jobs:");
					SendClientMessage(playerid, COLOR_YELLOW, "");

					SendClientMessage(playerid, COLOR_WHITE, "Having a job gives you something to do. ");
					SendClientMessage(playerid, COLOR_WHITE, "Your job may also have a skill depending on the job you have.");
                    SendClientMessage(playerid, COLOR_WHITE, "All jobs are productive in some way.");

                    SetPVarInt(playerid, "tutTime", 2);
                    TextDrawHideForPlayer(playerid, textdrawVariables[7]);
                    SendClientMessage(playerid, COLOR_YELLOW, "");
				}
				case 10: {
					SendClientMessage(playerid, COLOR_YELLOW, "Mechanic Job");
					SendClientMessage(playerid, COLOR_WHITE, "You can find the Mechanic job near the crane at Ocean Docks.");
					SendClientMessage(playerid, COLOR_WHITE, "A mechanic can repair vehicles, add nitrous and even repaint vehicles.");

					SetPlayerCameraPos(playerid, 2314.167724, -2328.139892, 21.382812);
					SetPlayerCameraLookAt(playerid, 2323.291748, -2321.122314, 13.382812);
					SetPlayerPos(playerid, 2316.1677, -2328.1399, 13.3828-30);

					SetPVarInt(playerid, "tutTime", 5);
					TextDrawHideForPlayer(playerid, textdrawVariables[7]);
					SendClientMessage(playerid, COLOR_YELLOW, "");
				}
				case 11: {
					SendClientMessage(playerid, COLOR_YELLOW, "Arms Dealer Job");
					SendClientMessage(playerid, COLOR_WHITE, "You can find the Arms Dealer job at the front of LS Ammunation.");
					SendClientMessage(playerid, COLOR_WHITE, "An arms dealer goes on material runs to obtain materials.");
					SendClientMessage(playerid, COLOR_WHITE, "They can then use those materials to create weapons.");
					SendClientMessage(playerid, COLOR_WHITE, "There are ten weapon levels.");
					SendClientMessage(playerid, COLOR_WHITE, "Each level unlocks a new weapon. Every 50 weapons levels you up.");

					SetPlayerCameraPos(playerid, 1353.600097, -1301.909790, 19.382812);
					SetPlayerCameraLookAt(playerid, 1361.592285, -1285.515136, 13.382812);
					SetPlayerPos(playerid, 1351.6001, -1285.9098, 13.3828-30);

					SetPVarInt(playerid, "tutTime", 6);
					TextDrawHideForPlayer(playerid, textdrawVariables[7]);
					SendClientMessage(playerid, COLOR_YELLOW, "");
				}
				case 12: {
					SendClientMessage(playerid, COLOR_YELLOW, "Detective Job");
					SendClientMessage(playerid, COLOR_WHITE, "You can find the Detective job near the bank.");
					SendClientMessage(playerid, COLOR_WHITE, "A detective can track people, vehicles and houses");
					SendClientMessage(playerid, COLOR_WHITE, "To track vehicles and houses, however, you'll need to level up.");
					SendClientMessage(playerid, COLOR_WHITE, "As with the arms dealer job, there are 10 levels.");
					SendClientMessage(playerid, COLOR_WHITE, "Every 50 searches levels you up.");

					SetPlayerCameraPos(playerid, 622.514709, -1458.283691, 22.256816);
					SetPlayerCameraLookAt(playerid, 612.514709, -1458.298583, 14.256817);
					SetPlayerPos(playerid, 622.5147, -1458.2837, 14.2568-30);

					SetPVarInt(playerid, "tutTime", 10);
					TextDrawHideForPlayer(playerid, textdrawVariables[7]);
				}
				case 13: {
					SendClientMessage(playerid, COLOR_YELLOW, "Levels");
					SendClientMessage(playerid, COLOR_WHITE, "A very new feature to this script is a levels system.");
					SendClientMessage(playerid, COLOR_WHITE, "");
					SendClientMessage(playerid, COLOR_WHITE, "You can now gain OOC levels which will benefit you throughout the server.");
					SendClientMessage(playerid, COLOR_WHITE, "As of present, levels don't really do much - but future updates shall introduce a bunch of new features!");
                    SendClientMessage(playerid, COLOR_WHITE, "");
                    SendClientMessage(playerid, COLOR_WHITE, "You can only level up every X hours, and it costs money from your character's bank account.");

					SetPlayerCameraPos(playerid, 622.514709, -1458.283691, 22.256816);
					SetPlayerCameraLookAt(playerid, 612.514709, -1458.298583, 14.256817);
					SetPlayerPos(playerid, 622.5147, -1458.2837, 14.2568-30);

					SetPVarInt(playerid, "tutTime", 10);
					TextDrawHideForPlayer(playerid, textdrawVariables[7]);
				}
				case 14: {
					SendClientMessage(playerid, COLOR_YELLOW, "Conclusion");
					SendClientMessage(playerid, COLOR_WHITE, "Thanks for reading/watching the tutorial, your character will now spawn. ");
					SendClientMessage(playerid, COLOR_WHITE, "If you have any questions or concerns which relate to gameplay on our server, please use "EMBED_GREY"/n"EMBED_WHITE".");
                    SendClientMessage(playerid, COLOR_WHITE, "If you wish to obtain help from an official member of staff, please use "EMBED_GREY"/helpme"EMBED_WHITE".");
                    SendClientMessage(playerid, COLOR_WHITE, "If you see any players breaking rules, please use "EMBED_GREY"/report"EMBED_WHITE".");
                    
                    format(szMessage, sizeof(szMessage), "Last, but not least, please make sure that you register on our community forums: "EMBED_GREY"%s"EMBED_WHITE".", szServerWebsite);
                 	SendClientMessage(playerid, COLOR_WHITE, szMessage);
                 	
					firstPlayerSpawn(playerid);
					TextDrawHideForPlayer(playerid, textdrawVariables[7]);
				}
			}
		}
	    else if(lr < 0) {
	        playerVariables[playerid][pTutorial]--;

	        if(playerVariables[playerid][pTutorial] < 5) {
	            playerVariables[playerid][pTutorial] = 5;
	            PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
	        }

	        switch(playerVariables[playerid][pTutorial]) {
				case 5: {
					SendClientMessage(playerid, COLOR_YELLOW, "Overview");
					SendClientMessage(playerid, COLOR_WHITE, "This is a roleplay server, which means you act out a character as if it were real.");
					SendClientMessage(playerid, COLOR_WHITE, "Pressing the button to open the textbox (usually T) and simply typing a message,");
					SendClientMessage(playerid, COLOR_WHITE, "will broadcast what you've typed to the people around you as an 'IC' (in character) message.");
					SendClientMessage(playerid, COLOR_WHITE, " ");
					SendClientMessage(playerid, COLOR_WHITE, "Using /b and typing your message (e.g. /b hello) will enclose what you've written in double parenthesis.");
                    SendClientMessage(playerid, COLOR_WHITE, "This will broadcast your message to the people around you as an 'OOC' (out of character) message.");
                    SendClientMessage(playerid, COLOR_WHITE, " ");
                    SendClientMessage(playerid, COLOR_WHITE, "Similarly, using /o has the same purpose as /b, though this time the message will be broadcasted throughout the entire server.");

                    SetPVarInt(playerid, "tutTime", 10);
                    TextDrawHideForPlayer(playerid, textdrawVariables[7]);
				}
				case 6: {
				    clearScreen(playerid);
					SendClientMessage(playerid, COLOR_YELLOW, "Locations:");
					SendClientMessage(playerid, COLOR_YELLOW, "");

					SendClientMessage(playerid, COLOR_YELLOW, "The Bank");
					SendClientMessage(playerid, COLOR_WHITE, "This is the place you'll want to go to make your various monetary transactions.");
					SendClientMessage(playerid, COLOR_WHITE, "The following commands will be useful:");
					SendClientMessage(playerid, COLOR_WHITE, "/balance, /withdraw and /deposit");

					SetPlayerVirtualWorld(playerid, 0);
					SetPlayerInterior(playerid, 0);

					SetPlayerCameraPos(playerid, 608.430480, -1203.073608, 17.801227);
					SetPlayerCameraLookAt(playerid, 594.246276, -1237.907348, 17.801227);
					SetPlayerPos(playerid, 526.8502, -1261.1985, 16.2272-30);

					SetPVarInt(playerid, "tutTime", 4);
					TextDrawHideForPlayer(playerid, textdrawVariables[7]);
				}
				case 7: {
					SendClientMessage(playerid, COLOR_YELLOW, "The Crane");
					SendClientMessage(playerid, COLOR_WHITE, "At the crane, you can drop off vehicles for money.");
					SendClientMessage(playerid, COLOR_WHITE, "Use the command /dropcar to drive the vehicle to the red marker.");

					SetPlayerCameraPos(playerid, 2637.447265, -2226.906738, 16.296875);
					SetPlayerCameraLookAt(playerid, 2651.442626, -2227.208496, 16.296875);
					SetPlayerPos(playerid, 2641.4473, -2226.9067, 16.2969-30);

					SetPVarInt(playerid, "tutTime", 5);
					TextDrawHideForPlayer(playerid, textdrawVariables[8]);
				}
				case 8: {
					SendClientMessage(playerid, COLOR_YELLOW, "Los Santos Police Department");
					SendClientMessage(playerid, COLOR_WHITE, "This is the place where you'll find police officers.");
					SendClientMessage(playerid, COLOR_WHITE, "Inside, you should wait in lobby before being served.");
					SendClientMessage(playerid, COLOR_WHITE, "If you want to apply to the LSPD, please visit our forum.");

					SetPlayerCameraPos(playerid, 1495.273925, -1675.542358, 28.382812);
					SetPlayerCameraLookAt(playerid, 1535.268432, -1675.874023, 13.382812);
					SetPlayerPos(playerid, 2641.4473, -2226.9067, 16.2969-30);

					SetPVarInt(playerid, "tutTime", 6);
					TextDrawHideForPlayer(playerid, textdrawVariables[7]);
				}
				case 9: {
				    clearScreen(playerid);
					SendClientMessage(playerid, COLOR_YELLOW, "Jobs:");
					SendClientMessage(playerid, COLOR_YELLOW, "");

					SendClientMessage(playerid, COLOR_WHITE, "Having a job gives you something to do. ");
					SendClientMessage(playerid, COLOR_WHITE, "Your job may also have a skill depending on the job you have.");
                    SendClientMessage(playerid, COLOR_WHITE, "All jobs are productive in some way.");

                    SetPVarInt(playerid, "tutTime", 5);
                    TextDrawHideForPlayer(playerid, textdrawVariables[7]);
				}
				case 10: {
					SendClientMessage(playerid, COLOR_YELLOW, "Mechanic Job");
					SendClientMessage(playerid, COLOR_WHITE, "You can find the Mechanic job near the crane at Ocean Docks.");
					SendClientMessage(playerid, COLOR_WHITE, "A mechanic can repair vehicles, add nitrous and even repaint vehicles.");

					SetPlayerCameraPos(playerid, 2314.167724, -2328.139892, 21.382812);
					SetPlayerCameraLookAt(playerid, 2323.291748, -2321.122314, 13.382812);
					SetPlayerPos(playerid, 2316.1677, -2328.1399, 13.3828-30);

					SetPVarInt(playerid, "tutTime", 5);
					TextDrawHideForPlayer(playerid, textdrawVariables[7]);
				}
				case 11: {
					SendClientMessage(playerid, COLOR_YELLOW, "Arms Dealer Job");
					SendClientMessage(playerid, COLOR_WHITE, "You can find the Arms Dealer job at the front of LS Ammunation.");
					SendClientMessage(playerid, COLOR_WHITE, "An arms dealer goes on material runs to obtain materials.");
					SendClientMessage(playerid, COLOR_WHITE, "They can then use those materials to create weapons.");
					SendClientMessage(playerid, COLOR_WHITE, "There are ten weapon levels.");
					SendClientMessage(playerid, COLOR_WHITE, "Each level unlocks a new weapon. Every 50 weapons levels you up.");

					SetPlayerCameraPos(playerid, 1353.600097, -1301.909790, 19.382812);
					SetPlayerCameraLookAt(playerid, 1361.592285, -1285.515136, 13.382812);
					SetPlayerPos(playerid, 1351.6001, -1285.9098, 13.3828-30);

					SetPVarInt(playerid, "tutTime", 10);
					TextDrawHideForPlayer(playerid, textdrawVariables[7]);
				}
				case 12: {
					SendClientMessage(playerid, COLOR_YELLOW, "Detective Job");
					SendClientMessage(playerid, COLOR_WHITE, "You can find the Detective job near the bank.");
					SendClientMessage(playerid, COLOR_WHITE, "A detective can track people, vehicles and houses");
					SendClientMessage(playerid, COLOR_WHITE, "To track vehicles and houses, however, you'll need to level up.");
					SendClientMessage(playerid, COLOR_WHITE, "As with the arms dealer job, there are 10 levels.");
					SendClientMessage(playerid, COLOR_WHITE, "Every 50 searches levels you up.");

					SetPlayerCameraPos(playerid, 622.514709, -1458.283691, 22.256816);
					SetPlayerCameraLookAt(playerid, 612.514709, -1458.298583, 14.256817);
					SetPlayerPos(playerid, 622.5147, -1458.2837, 14.2568-30);

					SetPVarInt(playerid, "tutTime", 10);
					TextDrawHideForPlayer(playerid, textdrawVariables[7]);
				}
				case 13: {
					SendClientMessage(playerid, COLOR_YELLOW, "Levels");
					SendClientMessage(playerid, COLOR_WHITE, "A very new feature to this script is a levels system.");
					SendClientMessage(playerid, COLOR_WHITE, "");
					SendClientMessage(playerid, COLOR_WHITE, "You can now gain OOC levels which will benefit you throughout the server.");
					SendClientMessage(playerid, COLOR_WHITE, "As of present, levels don't really do much - but future updates shall introduce a bunch of new features!");
                    SendClientMessage(playerid, COLOR_WHITE, "");
                    SendClientMessage(playerid, COLOR_WHITE, "You can only level up every X hours, and it costs money from your character's bank account.");

					SetPlayerCameraPos(playerid, 622.514709, -1458.283691, 22.256816);
					SetPlayerCameraLookAt(playerid, 612.514709, -1458.298583, 14.256817);
					SetPlayerPos(playerid, 622.5147, -1458.2837, 14.2568-30);

					SetPVarInt(playerid, "tutTime", 10);
					TextDrawHideForPlayer(playerid, textdrawVariables[7]);
				}
				case 14: {
					SendClientMessage(playerid, COLOR_YELLOW, "Conclusion");
					SendClientMessage(playerid, COLOR_WHITE, "Thanks for reading/watching the tutorial, your character will now spawn. ");
					SendClientMessage(playerid, COLOR_WHITE, "If you have any questions or concerns which relate to gameplay on our server, please use "EMBED_GREY"/n"EMBED_WHITE".");
                    SendClientMessage(playerid, COLOR_WHITE, "If you wish to obtain help from an official member of staff, please use "EMBED_GREY"/helpme"EMBED_WHITE".");
                    SendClientMessage(playerid, COLOR_WHITE, "If you see any players breaking rules, please use "EMBED_GREY"/report"EMBED_WHITE".");

                    format(szMessage, sizeof(szMessage), "Last, but not least, please make sure that you register on our community forums: "EMBED_GREY"%s"EMBED_WHITE".", szServerWebsite);
                 	SendClientMessage(playerid, COLOR_WHITE, szMessage);

					firstPlayerSpawn(playerid);
					TextDrawHideForPlayer(playerid, textdrawVariables[7]);
				}
			}
		}
	}

	if(GetPlayerState(playerid) == 2) {
		for(new v; v < MAX_SPIKES; v++) {
			if(spikeVariables[v][sPos][0] != 0 && spikeVariables[v][sPos][1] != 0 && spikeVariables[v][sPos][2] != 0) {
				if(IsVehicleInRangeOfPoint(GetPlayerVehicleID(playerid), 2.0, spikeVariables[v][sPos][0], spikeVariables[v][sPos][1], spikeVariables[v][sPos][2])) {

					new
						Damage[4];

					GetVehicleDamageStatus(GetPlayerVehicleID(playerid), Damage[0], Damage[1], Damage[2], Damage[3]); // Set tires to 15 and watch 'em pop.
					UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), Damage[0], Damage[1], Damage[2], 15);
				}
			}
		}
	}
	playerVariables[playerid][pConnectedSeconds] = gettime();
	return 1;
}

stock forceAdminConfirmPIN(playerid, cmd[] = "", cmdparams[] = "") {
	if(GetPVarInt(playerid, "pAdminPIN") == 0)
		return 1;

    SetPVarInt(playerid, "pAdminFrozen", 1);
    
    if(strlen(cmd) != 0 || strlen(cmdparams) != 0) {
        SetPVarString(playerid, "doCmd", cmd);
        SetPVarString(playerid, "doCmdParams", cmdparams);
	}

    ShowPlayerDialog(playerid, DIALOG_ADMIN_PIN, DIALOG_STYLE_INPUT, "SERVER: Admin authentication verification", "This action requires you to enter your admin PIN in.\n\nPlease confirm your admin PIN to continue:", "OK", "Cancel");
	return 1;
}

stock saveBusiness(const id) {
	if(strlen(businessVariables[id][bOwner]) >= 1) {
		new
		    queryString[1424];

		format(queryString, sizeof(queryString), "UPDATE businesses SET businessExteriorX = '%f', businessExteriorY = '%f', businessExteriorZ = '%f', businessInteriorX = '%f', businessInteriorY = '%f', businessInteriorZ = '%f', businessInterior = '%d', businessType = '%d', businessName = '%s', businessOwner = '%s', businessPrice = '%d', businessVault = '%d', businessLock = '%d', businessMiscX = '%f', businessMiscY = '%f', businessMiscZ = '%f' WHERE businessID = '%d'", businessVariables[id][bExteriorPos][0],
		businessVariables[id][bExteriorPos][1],	businessVariables[id][bExteriorPos][2],	businessVariables[id][bInteriorPos][0], businessVariables[id][bInteriorPos][1],	businessVariables[id][bInteriorPos][2],	businessVariables[id][bInterior], businessVariables[id][bType], businessVariables[id][bName], businessVariables[id][bOwner], businessVariables[id][bPrice], businessVariables[id][bVault], businessVariables[id][bLocked], businessVariables[id][bMiscPos][0],
		businessVariables[id][bMiscPos][1], businessVariables[id][bMiscPos][2], id);
		mysql_query(queryString);
	}
	else {
	    return false;
	}

	return 1;
}

stock saveVehicle(const id) {
	if(vehicleVariables[id][vVehicleModelID] >= 1) {
	    new
	        queryString[255];

	    GetVehiclePos(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehiclePosition][0], vehicleVariables[id][vVehiclePosition][1], vehicleVariables[id][vVehiclePosition][2]);
	    GetVehicleZAngle(vehicleVariables[id][vVehicleScriptID], vehicleVariables[id][vVehicleRotation]);

	    format(queryString, sizeof(queryString), "UPDATE vehicles SET vehicleModelID = '%d', vehiclePosX = '%f', vehiclePosY = '%f', vehiclePosZ = '%f', vehiclePosRotation = '%f', vehicleGroup = '%d', vehicleCol1 = '%d', vehicleCol2 = '%d' WHERE vehicleID = '%d'", vehicleVariables[id][vVehicleModelID],	vehicleVariables[id][vVehiclePosition][0],
		vehicleVariables[id][vVehiclePosition][1], vehicleVariables[id][vVehiclePosition][2], vehicleVariables[id][vVehicleRotation], vehicleVariables[id][vVehicleGroup], vehicleVariables[id][vVehicleColour][0], vehicleVariables[id][vVehicleColour][1], id);
		mysql_query(queryString);
	}
	return 1;
}

stock saveHouse(const id) {
	if(strlen(houseVariables[id][hHouseOwner]) >= 1) {
		format(szLargeString, sizeof(szLargeString), "UPDATE houses SET houseExteriorPosX = '%f', houseExteriorPosY = '%f', houseExteriorPosZ = '%f', houseInteriorPosX = '%f', houseInteriorPosY = '%f', houseInteriorPosZ = '%f'", houseVariables[id][hHouseExteriorPos][0], houseVariables[id][hHouseExteriorPos][1], houseVariables[id][hHouseExteriorPos][2], houseVariables[id][hHouseInteriorPos][0], houseVariables[id][hHouseInteriorPos][1], houseVariables[id][hHouseInteriorPos][2]);
		format(szLargeString, sizeof(szLargeString), "%s, housePrice = '%d', houseOwner = '%s', houseExteriorID = '%d', houseInteriorID = '%d', houseLocked = '%d', houseMoney = '%d', houseMaterials = '%d', houseWeapon1 = '%d', houseWeapon2 = '%d', houseWeapon3 = '%d', houseWeapon4 = '%d', houseWeapon5 = '%d'", szLargeString, houseVariables[id][hHousePrice], houseVariables[id][hHouseOwner], houseVariables[id][hHouseExteriorID],
		houseVariables[id][hHouseInteriorID], houseVariables[id][hHouseLocked],	houseVariables[id][hMoney], houseVariables[id][hMaterials], houseVariables[id][hWeapons][0], houseVariables[id][hWeapons][1], houseVariables[id][hWeapons][2], houseVariables[id][hWeapons][3], houseVariables[id][hWeapons][4]);
		format(szLargeString, sizeof(szLargeString), "%s, houseWardrobe1 = '%d', houseWardrobe2 = '%d', houseWardrobe3 = '%d', houseWardrobe4 = '%d', houseWardrobe5 = '%d' WHERE houseID = '%d'", szLargeString, houseVariables[id][hWardrobe][0], houseVariables[id][hWardrobe][1], houseVariables[id][hWardrobe][2], houseVariables[id][hWardrobe][3], houseVariables[id][hWardrobe][4], id);
		mysql_query(szLargeString);
	}
	else {
	    return false;
	}

	return 1;
}

stock saveAsset(const id) {
	if(strlen(assetVariables[id][aAssetName]) >= 1) {
		format(szQueryOutput, sizeof(szQueryOutput), "UPDATE assets SET assetName = '%s', assetValue = '%d' WHERE assetID = '%d'", assetVariables[id][aAssetName], assetVariables[id][aAssetValue]);
		mysql_query(szQueryOutput);
	}
	return 1;
}

stock saveGroup(const id) {
	if(strlen(groupVariables[id][gGroupName]) >= 1) {
		format(szLargeString, sizeof(szLargeString), "UPDATE groups SET groupName = '%s', groupHQExteriorPosX = '%f', groupHQExteriorPosY = '%f', groupHQExteriorPosZ = '%f'", groupVariables[id][gGroupName], groupVariables[id][gGroupExteriorPos][0], groupVariables[id][gGroupExteriorPos][1], groupVariables[id][gGroupExteriorPos][2]);
		format(szLargeString, sizeof(szLargeString), "%s, groupHQInteriorID = '%d', groupHQLockStatus = '%d', groupHQInteriorPosX = '%f', groupHQInteriorPosY = '%f', groupHQInteriorPosZ = '%f', groupSafeMoney = '%d', groupSafeMats = '%d', groupMOTD = '%s'", szLargeString, groupVariables[id][gGroupHQInteriorID],
		groupVariables[id][gGroupHQLockStatus], groupVariables[id][gGroupInteriorPos][0], groupVariables[id][gGroupInteriorPos][1], groupVariables[id][gGroupInteriorPos][2], groupVariables[id][gSafe][0], groupVariables[id][gSafe][1], groupVariables[id][gGroupMOTD]);
		format(szLargeString, sizeof(szLargeString), "%s, groupRankName1 = '%s', groupRankName2 = '%s', groupRankName3 = '%s', groupRankName4 = '%s', groupRankName5 = '%s', groupRankName6 = '%s'", szLargeString, groupVariables[id][gGroupRankName1], groupVariables[id][gGroupRankName2], groupVariables[id][gGroupRankName3], groupVariables[id][gGroupRankName4], groupVariables[id][gGroupRankName5], groupVariables[id][gGroupRankName6]);
		format(szLargeString, sizeof(szLargeString), "%s, groupSafePosX = '%f', groupSafePosY = '%f', groupSafePosZ = '%f', groupType = '%d' WHERE groupID = '%d'", szLargeString, groupVariables[id][gSafePos][0], groupVariables[id][gSafePos][1], groupVariables[id][gSafePos][2], groupVariables[id][gGroupType], id);
		mysql_query(szLargeString);
	}
	else {
		return 0;
	}

	return 1;

}

stock initiateJobs() {
    return mysql_query("SELECT * FROM jobs", THREAD_INITIATE_JOBS);
}

stock initiateBusinesses() {
	mysql_query("SELECT * FROM businessitems", THREAD_INITIATE_BUSINESS_ITEMS);
    return mysql_query("SELECT * FROM businesses", THREAD_INITIATE_BUSINESSES);
}

stock initiateAssets() {
	return mysql_query("SELECT * FROM assets", THREAD_INITIATE_ASSETS);
}

stock initiateHouseSpawns() {
	return mysql_query("SELECT * FROM houses", THREAD_INITIATE_HOUSES);
}

stock initiateVehicleSpawns() {
	return mysql_query("SELECT * FROM vehicles", THREAD_INITIATE_VEHICLES);
}

stock initiateGroups() {
	return mysql_query("SELECT * FROM groups", THREAD_INITIATE_GROUPS);
}

stock clearScreen(const playerid) {
    SendClientMessage(playerid, COLOR_WHITE, " ");
    SendClientMessage(playerid, COLOR_WHITE, " ");
    SendClientMessage(playerid, COLOR_WHITE, " ");
    SendClientMessage(playerid, COLOR_WHITE, " ");
    SendClientMessage(playerid, COLOR_WHITE, " ");
    SendClientMessage(playerid, COLOR_WHITE, " ");
    SendClientMessage(playerid, COLOR_WHITE, " ");
    SendClientMessage(playerid, COLOR_WHITE, " ");
    SendClientMessage(playerid, COLOR_WHITE, " ");
    SendClientMessage(playerid, COLOR_WHITE, " ");
    SendClientMessage(playerid, COLOR_WHITE, " ");
	return 1;
}

/*stock checkPlayerVehiclesForDesync(const playerid) {
    new
        x;
        
    for(;;) {
        x++;
        
        format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Model", x);
        format(szSmallString2, sizeof(szSmallString2), "playerVehicle%d_RealID", x);
        if(GetPVarInt(playerid, szSmallString) == GetVehicleModel(GetPVarInt(playerid, szSmallString2))) {
            despawnPlayersVehicles(playerid);
            respawnPlayerVehicles(playerid);
            SendClientMessage(playerid, COLOR_GREY, "Your player vehicles are suffering from a desync issue in SA-MP. They have been respawned to fix this issue.");
        }
	}
	return 1;
}

stock respawnPlayerVehicles(playerid) {
	new
		iModel,
		Float: fPos[3],
		Float: fAngle,
		iColours[2],
		iPaintjob,
		iComponents[14],
	    iCount = countPlayerVehicles(playerid);
	    
	for(new iVehicleID = 0; iVehicleID < iCount; i++) {
		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Model", iVehicleID);
		iModel = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_PosX", iVehicleID);
		fPos[0] = GetPVarFloat(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_PosY", iVehicleID);
		fPos[1] = GetPVarFloat(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_PosZ", iVehicleID);
		fPos[2] = GetPVarFloat(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_PosZAngle", iVehicleID);
		fAngle = GetPVarFloat(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Colour1", iVehicleID);
		iColours[0] = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Colour2", iVehicleID);
		iColours[1] = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Paintjob", iVehicleID);
		iPaintjob = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component0", iVehicleID);
		iComponents[0] = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component1", iVehicleID);
		iComponents[1] = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component2", iVehicleID);
		iComponents[2] = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component3", iVehicleID);
		iComponents[3] = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component4", iVehicleID);
		iComponents[4] = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component5", iVehicleID);
		iComponents[5] = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component6", iVehicleID);
		iComponents[6] = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component7", iVehicleID);
		iComponents[7] = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component8", iVehicleID);
		iComponents[8] = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component9", iVehicleID);
		iComponents[9] = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component10", iVehicleID);
		iComponents[10] = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component11", iVehicleID);
		iComponents[11] = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component12", iVehicleID);
		iComponents[12] = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_Component13", iVehicleID);
		iComponents[13] = GetPVarInt(playerid, szSmallString);

		format(szSmallString, sizeof(szSmallString), "playerVehicle%d_RealID", iVehicleID);
		SetPVarInt(extraid, szSmallString, CreateVehicle(iModel, fPos[0], fPos[1], fPos[2], fAngle, iColours[0], iColours[1], 0));

		for(new i = 0; i <= 13; i++)
			AddVehicleComponent(GetPVarInt(extraid, szSmallString), iComponents[i]);

		ChangeVehiclePaintjob(GetPVarInt(extraid, szSmallString), iPaintjob);
	}
	return 1;
}*/

stock initiateHospital(const playerid) {
	TogglePlayerControllable(playerid, false);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);

	if(random(2) == 0) {
		SetPlayerPos(playerid, 1188.4574,-1309.2242,10.5625);
		SetPlayerCameraPos(playerid,1188.4574,-1309.2242,13.5625+6.0);
		SetPlayerCameraLookAt(playerid,1175.5581,-1324.7922,18.1610);

		SetPVarInt(playerid, "hosp", 1);
	} else {
		SetPlayerPos(playerid, 1999.5308,-1449.3281,10.5594);
		SetPlayerCameraPos(playerid,1999.5308,-1449.3281,13.5594+6.0);
		SetPlayerCameraLookAt(playerid,2036.2179,-1410.3223,17.1641);

	    SetPVarInt(playerid, "hosp", 2);
	}

	SendClientMessage(playerid, COLOR_LIGHTRED, "You must spend some time in the Hospital to recover from the injuries you recently sustained.");
	SendClientMessage(playerid, COLOR_LIGHTRED, "Before you are discharged, hospital staff will confiscate your weapons and you will be billed for the health care you received.");
	playerVariables[playerid][pHospitalized] = 2;
	SetPlayerHealth(playerid, 10);
	return 1;
}

stock PreloadAnimLib(playerid, animlib[]) {
	return ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
}

public OnPlayerRequestSpawn(playerid) {
	if(playerVariables[playerid][pFirstLogin] >= 1)
	    return 0;

	return 1;
}

public OnPlayerSpawn(playerid) {
	#if defined DEBUG
	    printf("[debug] OnPlayerSpawn(%d)", playerid);
	#endif
	
	PreloadAnimLib(playerid,"BOMBER");
	PreloadAnimLib(playerid,"RAPPING");
	PreloadAnimLib(playerid,"SHOP");
	PreloadAnimLib(playerid,"BEACH");
	PreloadAnimLib(playerid,"SMOKING");
	PreloadAnimLib(playerid,"ON_LOOKERS");
	PreloadAnimLib(playerid,"DEALER");
	PreloadAnimLib(playerid,"CRACK");
	PreloadAnimLib(playerid,"CARRY");
	PreloadAnimLib(playerid,"COP_AMBIENT");
	PreloadAnimLib(playerid,"PARK");
	PreloadAnimLib(playerid,"INT_HOUSE");
	PreloadAnimLib(playerid,"FOOD");
	PreloadAnimLib(playerid,"GANGS");
	PreloadAnimLib(playerid,"PED");
	PreloadAnimLib(playerid,"FAT");

	SetPlayerColor(playerid, COLOR_WHITE);
	SetPlayerFightingStyle(playerid, playerVariables[playerid][pFightStyle]);

    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 998);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 998); // Skilled, but not dual-wield.

	if(playerVariables[playerid][pPrisonTime] >= 1) {
	    switch(playerVariables[playerid][pPrisonID]) {
			case 1: {
			    SetPlayerPos(playerid, -26.8721, 2320.9290, 24.3034);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
			case 2: {
				SetPlayerPos(playerid, 264.58, 77.38, 1001.04);
				SetPlayerInterior(playerid, 6);
				SetPlayerVirtualWorld(playerid, 0);
			}
			case 3: {

				SetPlayerInterior(playerid, 10);
				SetPlayerVirtualWorld(playerid, GROUP_VIRTUAL_WORLD+1);

				new spawn = random(sizeof(JailSpawns));

				SetPlayerPos(playerid, JailSpawns[spawn][0], JailSpawns[spawn][1], JailSpawns[spawn][2]);
				SetPlayerFacingAngle(playerid, 0);
			}
		}
		return 1;
	}

	if(playerVariables[playerid][pTutorial] == 1) {
		SetPlayerInterior(playerid, 14);
		SetPlayerPos(playerid, 216.9770, -155.4791, 1000.5234);
		SetPlayerFacingAngle(playerid, 267.9681);
		TogglePlayerControllable(playerid, false);
		return 1;
	}

	if(playerVariables[playerid][pHospitalized] >= 1)
	    return initiateHospital(playerid);

	SetPlayerSkin(playerid, playerVariables[playerid][pSkin]);
	SetPlayerPos(playerid, playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2]);
	SetPlayerInterior(playerid, playerVariables[playerid][pInterior]);
	SetPlayerVirtualWorld(playerid, playerVariables[playerid][pVirtualWorld]);
	SetCameraBehindPlayer(playerid);

	playerVariables[playerid][pSkinSet] = 1;

	ResetPlayerWeapons(playerid);
	givePlayerWeapons(playerid);

	if(playerVariables[playerid][pEvent] >= 1)
		playerVariables[playerid][pEvent] = 0;

	if(playerVariables[playerid][pAdminDuty] == 1) {
		SetPlayerHealth(playerid, 500000.0);
	}
	else {
		SetPlayerHealth(playerid, playerVariables[playerid][pHealth]);
		SetPlayerArmour(playerid, playerVariables[playerid][pArmour]);
	}

	if(!GetPlayerInterior(playerid)) {
		SetPlayerWeather(playerid, weatherVariables[0]);
	}
	else {
		SetPlayerWeather(playerid, INTERIOR_WEATHER_ID);
	}

	syncPlayerTime(playerid);
	TogglePlayerControllable(playerid, true);

	return 1;
}

public OnPlayerDeath(playerid, killerid, reason) {
	#if defined DEBUG
	    printf("[debug] OnPlayerDeath(%d, %d, %d)", playerid, killerid, reason);
	#endif
	
	new
		playerNames[2][MAX_PLAYER_NAME];

	if(playerVariables[playerid][pEvent] >= 1) {
		GetPlayerName(killerid, playerNames[0], MAX_PLAYER_NAME);
		GetPlayerName(playerid, playerNames[1], MAX_PLAYER_NAME);

		eventVariables[eEventCount]--;

    	if(eventVariables[eEventCount] <= 1) {
    	    format(szMessage, sizeof(szMessage), "%s has won the event, killing %s with a %s - congratulations!", playerNames[0], playerNames[1], WeaponNames[GetPlayerWeapon(killerid)]);
			SendClientMessageToAll(COLOR_LIGHTRED, szMessage);

			ResetPlayerWeapons(killerid);
			givePlayerWeapons(killerid);

    	    SetPlayerPos(killerid, playerVariables[killerid][pPos][0], playerVariables[killerid][pPos][1], playerVariables[killerid][pPos][2]);
			SetPlayerInterior(killerid, playerVariables[killerid][pInterior]);
			SetPlayerVirtualWorld(killerid, playerVariables[killerid][pVirtualWorld]);
			SetPlayerSkin(killerid, playerVariables[killerid][pSkin]);
			SetCameraBehindPlayer(killerid);

			SetPlayerHealth(killerid, playerVariables[killerid][pHealth]);
			SetPlayerArmour(killerid, playerVariables[killerid][pArmour]);

    	    SendClientMessage(killerid, COLOR_WHITE, "Congratulations on winning the event!");

			eventVariables[eEventCount] = 0;
			eventVariables[eEventStat] = 0;
			eventVariables[eEventSkin] = 0;
			playerVariables[killerid][pEvent] = 0;
    	}
		else {
    	    format(szMessage, sizeof(szMessage), "%s has left the event (killed by %s with a %s). %d participants remain.", playerNames[1], playerNames[0], WeaponNames[GetPlayerWeapon(killerid)], eventVariables[eEventCount]);
			SendToEvent(COLOR_YELLOW, szMessage);
		}
	}
	else {
		if(playerVariables[playerid][pAdminDuty] == 1) {
			GetPlayerPos(playerid, playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2]);
		}
		else playerVariables[playerid][pHospitalized] = 1;
	}
	return 1;
}

stock savePlayerData(const playerid) {
	if(playerVariables[playerid][pStatus] >= 1 || playerVariables[playerid][pStatus] == -1) {
		new
		    saveQuery[3500];

		if(playerVariables[playerid][pCarModel] >= 1 && doesVehicleExist(playerVariables[playerid][pCarID])) {
		    GetVehiclePos(playerVariables[playerid][pCarID], playerVariables[playerid][pCarPos][0], playerVariables[playerid][pCarPos][1], playerVariables[playerid][pCarPos][2]);
		    GetVehicleZAngle(playerVariables[playerid][pCarID], playerVariables[playerid][pCarPos][3]);

            for(new i = 0; i < 13; i++) {
                playerVariables[playerid][pCarMods][i] = GetVehicleComponentInSlot(playerVariables[playerid][pCarID], i);
            }
		}

		if(playerVariables[playerid][pAdminDuty] == 0 && playerVariables[playerid][pEvent] == 0) {
			GetPlayerHealth(playerid, playerVariables[playerid][pHealth]);
			GetPlayerArmour(playerid, playerVariables[playerid][pArmour]);
		}

		// If they're not in an event and not spectating, current pos is saved. Otherwise, they'll be set back to the pos they last used /joinevent or /spec.
		if(playerVariables[playerid][pSpectating] == INVALID_PLAYER_ID && playerVariables[playerid][pEvent] == 0) {
			GetPlayerPos(playerid, playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2]);
			playerVariables[playerid][pInterior] = GetPlayerInterior(playerid);
			playerVariables[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid); // If someone disconnects while spectating.
		}

		format(saveQuery, sizeof(saveQuery), "UPDATE playeraccounts SET playerBanned = '%d', playerSeconds = '%d', playerSkin = '%d', playerMoney = '%d', playerBankMoney = '%d'", playerVariables[playerid][pBanned], playerVariables[playerid][pSeconds], playerVariables[playerid][pSkin], playerVariables[playerid][pMoney], playerVariables[playerid][pBankMoney]);

		format(saveQuery, sizeof(saveQuery), "%s, playerInterior = '%d', playerVirtualWorld = '%d', playerHealth = '%f', playerArmour = '%f', playerPosX = '%f', playerPosY = '%f', playerPosZ = '%f'", saveQuery, playerVariables[playerid][pInterior], playerVariables[playerid][pVirtualWorld], playerVariables[playerid][pHealth], playerVariables[playerid][pArmour], playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2]);

		format(saveQuery, sizeof(saveQuery), "%s, playerAccent = '%s', playerAdminLevel = '%d', playerJob = '%d', playerWeapon0 = '%d', playerWeapon1 = '%d', playerWeapon2 = '%d', playerWeapon3 = '%d'", saveQuery, playerVariables[playerid][pAccent], playerVariables[playerid][pAdminLevel], playerVariables[playerid][pJob], playerVariables[playerid][pWeapons][0], playerVariables[playerid][pWeapons][1], playerVariables[playerid][pWeapons][2], playerVariables[playerid][pWeapons][3]);

		format(saveQuery, sizeof(saveQuery), "%s, playerWeapon4 = '%d', playerWeapon5 = '%d', playerWeapon6 = '%d', playerWeapon7 = '%d', playerWeapon8 = '%d', playerWeapon9 = '%d', playerWeapon10 = '%d'", saveQuery, playerVariables[playerid][pWeapons][4], playerVariables[playerid][pWeapons][5], playerVariables[playerid][pWeapons][6], playerVariables[playerid][pWeapons][7], playerVariables[playerid][pWeapons][8], playerVariables[playerid][pWeapons][9], playerVariables[playerid][pWeapons][10]);

		format(saveQuery, sizeof(saveQuery), "%s, playerWeapon11 = '%d', playerWeapon12 = '%d', playerJobSkill1 = '%d', playerJobSkill2 = '%d', playerMaterials = '%d', playerHours = '%d', playerLevel = '%d'", saveQuery, playerVariables[playerid][pWeapons][11], playerVariables[playerid][pWeapons][12], playerVariables[playerid][pJobSkill][0], playerVariables[playerid][pJobSkill][1], playerVariables[playerid][pMaterials], playerVariables[playerid][pPlayingHours], playerVariables[playerid][pLevel]);

		format(saveQuery, sizeof(saveQuery), "%s, playerWarning1 = '%s', playerWarning2 = '%s', playerWarning3 = '%s', playerHospitalized = '%d', playerFirstLogin = '%d', playerAdminName = '%s', playerPrisonTime = '%d', playerPrisonID = '%d', playerPhoneNumber = '%d'", saveQuery, playerVariables[playerid][pWarning1], playerVariables[playerid][pWarning2], playerVariables[playerid][pWarning3], playerVariables[playerid][pHospitalized], playerVariables[playerid][pFirstLogin], playerVariables[playerid][pAdminName],
		playerVariables[playerid][pPrisonTime], playerVariables[playerid][pPrisonID], playerVariables[playerid][pPhoneNumber]);

		format(saveQuery, sizeof(saveQuery), "%s, playerCarPaintJob = '%d', playerCarLock = '%d', playerStatus = '%d', playerGender = '%d', playerFightStyle = '%d', playerCarWeapon1 = '%d', playerCarWeapon2 = '%d', playerCarWeapon3 = '%d', playerCarWeapon4 = '%d', playerCarWeapon5 = '%d', playerCarLicensePlate = '%s'", saveQuery, playerVariables[playerid][pCarPaintjob], playerVariables[playerid][pCarLock],
		playerVariables[playerid][pStatus], playerVariables[playerid][pGender], playerVariables[playerid][pFightStyle], playerVariables[playerid][pCarWeapons][0], playerVariables[playerid][pCarWeapons][1], playerVariables[playerid][pCarWeapons][2], playerVariables[playerid][pCarWeapons][3], playerVariables[playerid][pCarWeapons][4], playerVariables[playerid][pCarLicensePlate]);

		format(saveQuery, sizeof(saveQuery), "%s, playerCarModel = '%d', playerCarColour1 = '%d', playerCarColour2 = '%d', playerCarPosX = '%f', playerCarPosY = '%f', playerCarPosZ = '%f', playerCarPosZAngle = '%f', playerCarMod0 = '%d', playerCarMod1 = '%d', playerCarMod2 = '%d', playerCarMod3 = '%d', playerCarMod4 = '%d', playerCarMod5 = '%d', playerCarMod6 = '%d'", saveQuery, playerVariables[playerid][pCarModel], playerVariables[playerid][pCarColour][0], playerVariables[playerid][pCarColour][1],
		playerVariables[playerid][pCarPos][0], playerVariables[playerid][pCarPos][1], playerVariables[playerid][pCarPos][2], playerVariables[playerid][pCarPos][3], playerVariables[playerid][pCarMods][0], playerVariables[playerid][pCarMods][1], playerVariables[playerid][pCarMods][2], playerVariables[playerid][pCarMods][3], playerVariables[playerid][pCarMods][4], playerVariables[playerid][pCarMods][5], playerVariables[playerid][pCarMods][6]);

		format(saveQuery, sizeof(saveQuery), "%s, playerCarTrunk1 = '%d', playerCarTrunk2 = '%d', playerPhoneCredit = '%d', playerWalkieTalkie = '%d'", saveQuery, playerVariables[playerid][pCarTrunk][0], playerVariables[playerid][pCarTrunk][1], playerVariables[playerid][pPhoneCredit], playerVariables[playerid][pWalkieTalkie]);

		format(saveQuery, sizeof(saveQuery), "%s, playerPhoneBook = '%d', playerGroup = '%d', playerGroupRank = '%d', playerIP = '%s', playerDropCarTimeout = '%d', playerRope = '%d', playerAdminDuty = '%d', playerCrimes = '%d', playerArrests = '%d', playerWarrants = '%d', playerAge = '%d', playerCarMod7 = '%d', playerCarMod8 = '%d', playerCarMod9 = '%d', playerCarMod10 = '%d', playerCarMod11 = '%d', playerCarMod12 = '%d'", saveQuery, playerVariables[playerid][pPhoneBook],
		playerVariables[playerid][pGroup], playerVariables[playerid][pGroupRank], playerVariables[playerid][pConnectionIP], playerVariables[playerid][pDropCarTimeout], playerVariables[playerid][pRope], playerVariables[playerid][pAdminDuty], playerVariables[playerid][pCrimes], playerVariables[playerid][pArrests], playerVariables[playerid][pWarrants], playerVariables[playerid][pAge], playerVariables[playerid][pCarMods][7], playerVariables[playerid][pCarMods][8],
		playerVariables[playerid][pCarMods][9], playerVariables[playerid][pCarMods][10], playerVariables[playerid][pCarMods][11], playerVariables[playerid][pCarMods][12]);

		if(playerVariables[playerid][pHelper] > 0)
		    format(saveQuery, sizeof(saveQuery), "%s, playerHelperLevel = %d", saveQuery, playerVariables[playerid][pHelper]);
		    
		if(playerVariables[playerid][pAdminLevel] > 0)
		    format(saveQuery, sizeof(saveQuery), "%s, playerAdminPIN = %d", saveQuery, GetPVarInt(playerid, "pAdminPIN"));
		    
		format(saveQuery, sizeof(saveQuery), "%s WHERE playerID = '%d'", saveQuery, playerVariables[playerid][pInternalID]);
		mysql_query(saveQuery);
	}

	return 1;
}

stock doesVehicleExist(const vehicleid) {
    if(GetVehicleModel(vehicleid) >= 400) {
		return 1;
	}
	return 0;
}

public OnPlayerDisconnect(playerid, reason) {
	#if defined DEBUG
	    printf("[debug] OnPlayerDisconnect(%d, %d)", playerid, reason);
	#endif
	
	if(playerVariables[playerid][pStatus] == 1) 
	{
        //despawnPlayersVehicles(playerid);
        
	    playerVariables[playerid][pStatus] = -1; // Reset state to disconnected
		foreach(Player, x) 
		{
			if(playerVariables[x][pSpectating] == playerid) 
			{
				playerVariables[x][pSpectating] = INVALID_PLAYER_ID;

				TogglePlayerSpectating(x, false);
				SetCameraBehindPlayer(x);

				SetPlayerPos(x, playerVariables[x][pPos][0], playerVariables[x][pPos][1], playerVariables[x][pPos][2]);
				SetPlayerInterior(x, playerVariables[x][pInterior]);
				SetPlayerVirtualWorld(x, playerVariables[x][pVirtualWorld]);

				TextDrawHideForPlayer(x, textdrawVariables[4]);

				SendClientMessage(x, COLOR_GREY, "The player you were spectating has disconnected.");
			}
		}

		if(playerVariables[playerid][pAdminDuty] >= 1) {
			SetPlayerName(playerid, playerVariables[playerid][pNormalName]);
		}

		if(playerVariables[playerid][pFreezeType] >= 1 && playerVariables[playerid][pFreezeType] <= 4) {
			playerVariables[playerid][pPrisonTime] = 900;
			playerVariables[playerid][pPrisonID] = 2;
		}

		if(playerVariables[playerid][pDrag] != -1) {
			SendClientMessage(playerVariables[playerid][pDrag], COLOR_WHITE, "The person you were dragging has disconnected.");
			playerVariables[playerVariables[playerid][pDrag]][pDrag] = -1; // Kills off any disconnections.
		}
		if(playerVariables[playerid][pPhoneCall] != -1 && playerVariables[playerid][pPhoneCall] < MAX_PLAYERS) {

			SendClientMessage(playerVariables[playerid][pPhoneCall], COLOR_WHITE, "Your call has been terminated by the other party.");

			if(GetPlayerSpecialAction(playerVariables[playerid][pPhoneCall]) == SPECIAL_ACTION_USECELLPHONE) {
				SetPlayerSpecialAction(playerVariables[playerid][pPhoneCall], SPECIAL_ACTION_STOPUSECELLPHONE);
			}

		    playerVariables[playerVariables[playerid][pPhoneCall]][pPhoneCall] = -1;
		}

		savePlayerData(playerid);

		if(playerVariables[playerid][pAdminLevel] < 1) {
			switch(reason) {
				case 1: format(szMessage, sizeof(szMessage), "%s has left the server.", playerVariables[playerid][pNormalName]);
				case 2:	format(szMessage, sizeof(szMessage), "%s has been kicked or banned from the server.", playerVariables[playerid][pNormalName]);
				default: format(szMessage, sizeof(szMessage), "%s has timed out from the server.", playerVariables[playerid][pNormalName]);
			}
			nearByMessage(playerid, COLOR_GENANNOUNCE, szMessage);
		}

		if(playerVariables[playerid][pGroup] >= 1) {
			switch(reason) {
				case 0: {
					format(szMessage, sizeof(szMessage), "%s from your group has disconnected (timeout).", playerVariables[playerid][pNormalName]);
				}
				case 1: {
					format(szMessage, sizeof(szMessage), "%s from your group has disconnected (quit).", playerVariables[playerid][pNormalName]);
				}
				case 2: {
					format(szMessage, sizeof(szMessage), "%s from your group has disconnected (banned/kicked).", playerVariables[playerid][pNormalName]);
				}
			}

			SendToGroup(playerVariables[playerid][pGroup], COLOR_GENANNOUNCE, szMessage);
		}

		if(playerVariables[playerid][pEvent] >= 1) {
			eventVariables[eEventCount]--;
			playerVariables[playerid][pEvent] = 0;
			ResetPlayerWeapons(playerid);

			if(eventVariables[eEventCount] <= 1) {

				new
					iCount;

				foreach(Player, i) {
					if(playerVariables[i][pEvent] >= 1) {

						TogglePlayerControllable(i, true);

						ResetPlayerWeapons(i);
						givePlayerWeapons(i);

						SetPlayerPos(i, playerVariables[i][pPos][0], playerVariables[i][pPos][1], playerVariables[i][pPos][2]);
						SetPlayerInterior(i, playerVariables[i][pInterior]);
						SetPlayerVirtualWorld(i, playerVariables[i][pVirtualWorld]);
						SetPlayerSkin(i, playerVariables[i][pSkin]);
						SetCameraBehindPlayer(i);

						iCount++;
						GetPlayerName(i, szPlayerName, MAX_PLAYER_NAME);

						SetPlayerHealth(i, playerVariables[i][pHealth]);
						SetPlayerArmour(i, playerVariables[i][pArmour]);
						playerVariables[i][pEvent] = 0;

					}
				}
				if(iCount == 1) {
					format(szMessage, sizeof(szMessage), "%s has won the event by default (after %s disconnected) - congratulations!", szPlayerName, playerVariables[playerid][pNormalName]);
					SendClientMessageToAll(COLOR_LIGHTRED, szMessage);
				}
				else {
					format(szMessage, sizeof(szMessage), "The event has ended (no participants left, %s disconnected).",playerVariables[playerid][pNormalName]);
					SendClientMessageToAll(COLOR_LIGHTRED, szMessage);
				}

				eventVariables[eEventStat] = 0;
				eventVariables[eEventCount] = 0;

				eventVariables[eEventSkin] = 0;
			}
			else {
				switch(reason) {
					case 0: format(szMessage, sizeof(szMessage), "%s has disconnected from the event (timeout). %d participants remain.", playerVariables[playerid][pNormalName], eventVariables[eEventCount]);
					case 1: format(szMessage, sizeof(szMessage), "%s has disconnected from the event (quit). %d participants remain.", playerVariables[playerid][pNormalName], eventVariables[eEventCount]);
					case 2: format(szMessage, sizeof(szMessage), "%s has disconnected from the event (kicked/banned). %d participants remain.", playerVariables[playerid][pNormalName], eventVariables[eEventCount]);
				}
				SendToEvent(COLOR_YELLOW, szMessage);
			}
		}

		if(playerVariables[playerid][pCarModel] >= 1) {
			DestroyVehicle(playerVariables[playerid][pCarID]);
			systemVariables[vehicleCounts][1]--;
			playerVariables[playerid][pCarID] = -1;
		}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	#if defined DEBUG
	    printf("[debug] OnPlayerKeyStateChange(%d, %d, %d)", playerid, newkeys, oldkeys);
	#endif
	
	// Disregard any key state changes if the player is frozen and prevent any further code from being executed
	if(playerVariables[playerid][pFreezeType] != 0 && playerVariables[playerid][pFreezeTime] != 0)
	    return 0;
	
	if(IsKeyJustDown(KEY_SUBMISSION, newkeys, oldkeys)) {
	    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 525) { // For impounding cars.

	        new
				playerTowTruck = GetPlayerVehicleID(playerid);

	        if(!IsTrailerAttachedToVehicle(playerTowTruck)) {
				new
					targetVehicle = GetClosestVehicle(playerid, playerTowTruck); // Exempt the player's own vehicle from the loop.

				if(!IsAPlane(targetVehicle) && IsPlayerInRangeOfVehicle(playerid, targetVehicle, 10.0)) {
					AttachTrailerToVehicle(targetVehicle, playerTowTruck);
				}
	        }
	        else DetachTrailerFromVehicle(playerTowTruck);
	    }
	}
	if(IsKeyJustDown(KEY_FIRE, newkeys, oldkeys)) {
		if(GetPlayerWeapon(playerid) == 17 && !IsPlayerInAnyVehicle(playerid) && playerVariables[playerid][pFreezeType] == 0) {
			foreach(Player, i) {
				if(playerid != i && !IsPlayerInAnyVehicle(i) && playerVariables[i][pFreezeType] == 0 && GetPlayerSkin(i) != 285) {
					if(IsPlayerAimingAtPlayer(playerid, i)) {

						playerVariables[i][pFreezeType] = 5; // Using 5 on FreezeType makes more sense
						playerVariables[i][pFreezeTime] = 10;
						TogglePlayerControllable(i, false);
						SetPlayerDrunkLevel(i, 50000);
						ApplyAnimation(i, "FAT", "IDLE_TIRED", 4.1, 1, 1, 1, 1, 0, 1);
					}
				}
			}
		}
	}
    if(IsKeyJustDown(KEY_WALK, newkeys, oldkeys)) {
		if(playerVariables[playerid][pSpectating] != INVALID_PLAYER_ID && playerVariables[playerid][pAdminLevel] >= 1) {

			playerVariables[playerid][pSpectating] = INVALID_PLAYER_ID;

		    TogglePlayerSpectating(playerid, false);
			SetCameraBehindPlayer(playerid);

		    SetPlayerPos(playerid, playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2]);
		    SetPlayerInterior(playerid, playerVariables[playerid][pInterior]);
		    SetPlayerVirtualWorld(playerid, playerVariables[playerid][pVirtualWorld]);

		    TextDrawHideForPlayer(playerid, textdrawVariables[4]);
			return 1;
		}
    }
	if(IsKeyJustDown(KEY_SECONDARY_ATTACK, newkeys, oldkeys)) {
        if(playerVariables[playerid][pTutorial] == 1) {
            playerVariables[playerid][pSkin] = GetPlayerSkin(playerid);

			SendClientMessage(playerid, COLOR_YELLOW, "Great. You've selected your clothes/skin.");

            playerVariables[playerid][pTutorial] = 2;

			SetTimerEx("genderSelection", 1000, false, "d", playerid);

            TextDrawHideForPlayer(playerid, textdrawVariables[2]);
			return 1;
		}
		
		if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1) {
			if(IsPlayerInRangeOfPoint(playerid, 3.0, 232.899703, 109.074996, 1009.211791))
			{
				if(playerVariables[playerid][pGroup] == 1 && playerVariables[playerid][pGroupRank] >= 5) {
					MoveDynamicObject(LSPDObjs[0][0],232.89999390,105.57499695,1009.21179199, 3.5); //commander south
					MoveDynamicObject(LSPDObjs[0][1],232.89941406,112.57499695,1009.21179199, 3.5); //commander north
					LSPDObjs[0][2] = 1;
					PlayerPlaySoundEx(1083, 232.899703, 109.074996, 1009.211791);
					SetTimerEx("ShutUp",4000,false,"d",0);
				}
			}
			else if(IsPlayerInRangeOfPoint(playerid, 3.0, 275.750000, 117.399414, 1003.617187))
			{
				MoveDynamicObject(LSPDObjs[1][0],275.75000000,120.89941406,1003.61718750, 3.5); // interrogation north
				MoveDynamicObject(LSPDObjs[1][1],275.75000000,118.89941406,1003.61718750, 3.5); // interrogation south
				LSPDObjs[1][2] = 1;
				PlayerPlaySoundEx(1083, 275.750000, 117.399414, 1003.617187);
				SetTimerEx("ShutUp",4000,false,"d",1);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 3.0, 253.201660, 109.099609, 1002.220703))
			{
				MoveDynamicObject(LSPDObjs[2][0],253.20410156,105.59960938,1002.22070312,3.5); // north west lobby door
				MoveDynamicObject(LSPDObjs[2][1],253.19921875,112.59960938,1002.22070312,3.5); // north east lobby door
				LSPDObjs[2][2] = 1;
				PlayerPlaySoundEx(1083, 253.201660, 109.099609, 1002.220703);
				SetTimerEx("ShutUp",4000,false,"d",2);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 3.0, 239.566894, 117.599609, 1002.220703))
			{
				MoveDynamicObject(LSPDObjs[3][0],239.56933594,114.09960938,1002.22070312,3.5); // south west lobby door
				MoveDynamicObject(LSPDObjs[3][1],239.56445312,121.09960938,1002.22070312,3.5); // south east lobby door
				LSPDObjs[3][2] = 1;
				PlayerPlaySoundEx(1083, 239.566894, 117.599609, 1002.220703);
				SetTimerEx("ShutUp",4000,false,"d",3);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, 265.951171, 115.826660, 1003.622863))
			{
				MoveDynamicObject(LSPDObjs[4][0],263.45,115.82421875,1003.62286377,3.5); // cam room
				MoveDynamicObject(LSPDObjs[4][1],268.75,115.82910156,1003.62286377, 3.5); // cam room
				LSPDObjs[4][2] = 1;
				PlayerPlaySoundEx(1083, 265.951171, 115.826660, 1003.622863);
				SetTimerEx("ShutUp",4000,false,"d",4);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 2.0, 265.820007, 112.530761, 1003.622863))
			{
				MoveDynamicObject(LSPDObjs[5][0],268.8,112.53222656,1003.62286377, 3.5); // locker
				MoveDynamicObject(LSPDObjs[5][1],263.3,112.52929688,1003.62286377, 3.5); // locker
				LSPDObjs[5][2] = 1;
				PlayerPlaySoundEx(1083, 265.820007, 112.530761, 1003.622863);
				SetTimerEx("ShutUp",4000,false,"d",5);
			}
			else if(IsPlayerInRangeOfPoint(playerid, 3.0, 231.099609, 119.532226, 1009.224426)) // Chief of Police
			{
				if(playerVariables[playerid][pGroup] == 1 && playerVariables[playerid][pGroupRank] == 6) {
					MoveDynamicObject(LSPDObjs[6][0],227.0,119.52929688,1009.22442627, 3.5);
					MoveDynamicObject(LSPDObjs[6][1],229.75,119.53515625,1009.22442627, 3.5);
					LSPDObjs[6][2] = 1;
					PlayerPlaySoundEx(1083, 231.099609, 119.532226, 1009.224426);
					SetTimerEx("ShutUp",4000,false,"d",6);
				}
			}
			else if(IsPlayerInRangeOfPoint(playerid, 3.0, 217.800003, 116.529647, 998.015625)) // Cells
			{
				MoveDynamicObject(LSPDObjs[7][0],220.5,116.52999878,998.01562500,3.5);
				MoveDynamicObject(LSPDObjs[7][1],215.3,116.52929688,998.01562500,3.5);
				LSPDObjs[7][2] = 1;
				PlayerPlaySoundEx(1083, 217.800003, 116.529647, 998.015625);
				SetTimerEx("ShutUp",4000,false,"d",7);
			}
		}
		if(IsPlayerInRangeOfPoint(playerid,1.0,237.9,115.6,1010.2)) {
			SetPlayerPos(playerid,237.9,115.6,1010.2);
			SetPlayerFacingAngle(playerid, 270);
			ApplyAnimation(playerid, "VENDING", "VEND_Use", 1, 0, 0, 0, 0, 4000);
			SetTimerEx("VendDrink", 2500, false, "d", playerid);
		}
	}
	if(IsKeyJustDown(KEY_CROUCH, newkeys, oldkeys)) {
		for(new x = 0; x < MAX_HOUSES; x++) {
			if(IsPlayerInRangeOfPoint(playerid, 2.0, houseVariables[x][hHouseExteriorPos][0], houseVariables[x][hHouseExteriorPos][1], houseVariables[x][hHouseExteriorPos][2])) {
				if(houseVariables[x][hHouseLocked] == 1) {
					SendClientMessage(playerid, COLOR_GREY, "This house is locked.");
					if(playerVariables[playerid][pAdminLevel] >= 1 && playerVariables[playerid][pAdminDuty] >= 1) {
					    SetPVarInt(playerid, "hE", x); // I'd create a variable for this, but seeing as we'll only ever use this for one thing, this will be better for optimization.
					    ShowPlayerDialog(playerid, DIALOG_HOUSE_ENTER, DIALOG_STYLE_MSGBOX, "SERVER: Housing", "This house is locked.\r\nAs an administrator, you can breach this lock and enter. Would you like to do so?", "Yes", "No");
					}
					else if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1 && playerVariables[playerid][pGroup] != 0) {
					    SetPVarInt(playerid, "hE", x);
					    ShowPlayerDialog(playerid, DIALOG_HOUSE_ENTER, DIALOG_STYLE_MSGBOX, "SERVER: Housing", "This house is locked.\r\nAs a law enforcement officer, you can breach this lock and enter. Would you like to do so?", "Yes", "No");
					}
				}
				else {
					SetPlayerPos(playerid, houseVariables[x][hHouseInteriorPos][0], houseVariables[x][hHouseInteriorPos][1], houseVariables[x][hHouseInteriorPos][2]);
					SetPlayerInterior(playerid, houseVariables[x][hHouseInteriorID]);
					SetPlayerVirtualWorld(playerid, HOUSE_VIRTUAL_WORLD+x);
				}
				return 1;
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.0, houseVariables[x][hHouseInteriorPos][0], houseVariables[x][hHouseInteriorPos][1], houseVariables[x][hHouseInteriorPos][2]) && GetPlayerVirtualWorld(playerid) == HOUSE_VIRTUAL_WORLD+x) {
				SetPlayerPos(playerid, houseVariables[x][hHouseExteriorPos][0], houseVariables[x][hHouseExteriorPos][1], houseVariables[x][hHouseExteriorPos][2]);
				SetPlayerInterior(playerid, houseVariables[x][hHouseExteriorID]);
				SetPlayerVirtualWorld(playerid, 0);
				return 1;
			}
		}
		
		for(new x = 0; x < MAX_ATMS; x++) {
		    if(IsPlayerInRangeOfPoint(playerid, 2.0, atmVariables[x][fATMPos][0], atmVariables[x][fATMPos][1], atmVariables[x][fATMPos][2])) {
				ShowPlayerDialog(playerid, DIALOG_ATM_MENU, DIALOG_STYLE_LIST, "SERVER: Automated Teller Machine", "Check Balance\nWithdraw", "OK", "Cancel");
			}
		}
		
		/* BANK */
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 595.5443,-1250.3405,18.2836)) {
			SetPlayerPos(playerid, 2306.8481,-16.0682,26.7496);
			SetPlayerVirtualWorld(playerid, 2);
		}
		else if(IsPlayerInRangeOfPoint(playerid, 2.0, 2306.8481,-16.0682,26.7496)) {
			SetPlayerPos(playerid, 595.5443,-1250.3405,18.2836);
			SetPlayerVirtualWorld(playerid, 0);
		}
		
		for(new x = 0; x < MAX_BUSINESSES; x++) {
			if(IsPlayerInRangeOfPoint(playerid, 2.0, businessVariables[x][bExteriorPos][0], businessVariables[x][bExteriorPos][1], businessVariables[x][bExteriorPos][2])) {
				if(businessVariables[x][bLocked] == 1) {
					SendClientMessage(playerid, COLOR_GREY, "This business is locked.");
					if(playerVariables[playerid][pAdminLevel] >= 1 && playerVariables[playerid][pAdminDuty] >= 1) {
					    SetPVarInt(playerid, "bE", x); // I'd create a variable for this, but seeing as we'll only ever use this for one thing, this will be better for optimization.
					    ShowPlayerDialog(playerid, DIALOG_BUSINESS_ENTER, DIALOG_STYLE_MSGBOX, "SERVER: Businesses", "{FFFFFF}This business is locked.\r\nAs an "EMBED_GREY"administrator{FFFFFF}, you can breach this lock and enter. Would you like to do so?", "Yes", "No");
					}
					else if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1 && playerVariables[playerid][pGroup] != 0) {
					    SetPVarInt(playerid, "bE", x);
					    ShowPlayerDialog(playerid, DIALOG_BUSINESS_ENTER, DIALOG_STYLE_MSGBOX, "SERVER: Businesses", "{FFFFFF}This business is locked.\r\nAs a "EMBED_GREY"law enforcement officer{FFFFFF}, you can breach this lock and enter. Would you like to do so?", "Yes", "No");
					}
				}
				else {
					businessTypeMessages(x, playerid);

					SetPlayerPos(playerid, businessVariables[x][bInteriorPos][0], businessVariables[x][bInteriorPos][1], businessVariables[x][bInteriorPos][2]);
					SetPlayerInterior(playerid, businessVariables[x][bInterior]);
					SetPlayerVirtualWorld(playerid, BUSINESS_VIRTUAL_WORLD+x);
				}
				return 1;
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.0, businessVariables[x][bInteriorPos][0], businessVariables[x][bInteriorPos][1], businessVariables[x][bInteriorPos][2]) && GetPlayerVirtualWorld(playerid) == BUSINESS_VIRTUAL_WORLD+x) {
				SetPlayerPos(playerid, businessVariables[x][bExteriorPos][0], businessVariables[x][bExteriorPos][1], businessVariables[x][bExteriorPos][2]);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				return 1;
			}
		}
		for(new x = 0; x < MAX_GROUPS; x++) {
			if(IsPlayerInRangeOfPoint(playerid, 2.0, groupVariables[x][gGroupExteriorPos][0], groupVariables[x][gGroupExteriorPos][1], groupVariables[x][gGroupExteriorPos][2])) {
				if(groupVariables[x][gGroupHQLockStatus] == 1) {
					SendClientMessage(playerid, COLOR_GREY, "This HQ is locked.");
					if(playerVariables[playerid][pAdminLevel] >= 1 && playerVariables[playerid][pAdminDuty] >= 1) {
					    SetPVarInt(playerid, "gE", x); // I'd create a variable for this, but seeing as we'll only ever use this for one thing, this will be better for optimization.
					    ShowPlayerDialog(playerid, DIALOG_GROUP_ENTER, DIALOG_STYLE_MSGBOX, "SERVER: Group HQ", "This Group HQ is locked.\r\nAs an administrator, you can breach this lock and enter. Would you like to do so?", "Yes", "No");
					}
 					else if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1 && playerVariables[playerid][pGroup] != 0) {
					    SetPVarInt(playerid, "gE", x);
					    ShowPlayerDialog(playerid, DIALOG_GROUP_ENTER, DIALOG_STYLE_MSGBOX, "SERVER: Group HQ", "This Group HQ is locked.\r\nAs a law enforcement officer, you can breach this lock and enter. Would you like to do so?", "Yes", "No");
					}
				}
				else {
					SetPlayerPos(playerid, groupVariables[x][gGroupInteriorPos][0], groupVariables[x][gGroupInteriorPos][1], groupVariables[x][gGroupInteriorPos][2]);
					SetPlayerInterior(playerid, groupVariables[x][gGroupHQInteriorID]);
					SetPlayerVirtualWorld(playerid, GROUP_VIRTUAL_WORLD+x);
				}
				return 1;
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.0, groupVariables[x][gGroupInteriorPos][0], groupVariables[x][gGroupInteriorPos][1], groupVariables[x][gGroupInteriorPos][2]) && GetPlayerVirtualWorld(playerid) == GROUP_VIRTUAL_WORLD+x) {
				SetPlayerPos(playerid, groupVariables[x][gGroupExteriorPos][0], groupVariables[x][gGroupExteriorPos][1], groupVariables[x][gGroupExteriorPos][2]);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				return 1;
			}
		}
	}
	return 1;
}

stock businessTypeMessages(const businessid, const playerid) {
	switch(businessVariables[businessid][bType]) {
		case 1: {
			SendClientMessage(playerid, COLOR_WHITE, "Welcome! The commands of this business are as follows: /buy");
			if(playerVariables[playerid][pFish] != -1) {
				switch(playerVariables[playerid][pFish]) {
				    case 0: {
				        ShowPlayerDialog(playerid, DIALOG_SELL_FISH, DIALOG_STYLE_MSGBOX, "SERVER: Fishing", "You are currently carrying $1000 worth of fish.\n\nWould you like to sell your fish to this store for $1000?", "Yes", "No");
				    }
				    case 1: {
				        ShowPlayerDialog(playerid, DIALOG_SELL_FISH, DIALOG_STYLE_MSGBOX, "SERVER: Fishing", "You are currently carrying $750 worth of fish.\n\nWould you like to sell your fish to this store for $750?", "Yes", "No");
				    }
				    case 2: {
            			ShowPlayerDialog(playerid, DIALOG_SELL_FISH, DIALOG_STYLE_MSGBOX, "SERVER: Fishing", "You are currently carrying $250 worth of fish.\n\nWould you like to sell your fish to this store for $250?", "Yes", "No");
				    }
				    case 3: {
				        ShowPlayerDialog(playerid, DIALOG_SELL_FISH, DIALOG_STYLE_MSGBOX, "SERVER: Fishing", "You are currently carrying $900 worth of fish.\n\nWould you like to sell your fish to this store for $900?", "Yes", "No");
				    }
				    case 4: {
				        ShowPlayerDialog(playerid, DIALOG_SELL_FISH, DIALOG_STYLE_MSGBOX, "SERVER: Fishing", "You are currently carrying $500 worth of fish.\n\nWould you like to sell your fish to this store for $500?", "Yes", "No");
				    }
				}
			}
		}
		case 2: {
			SendClientMessage(playerid, COLOR_WHITE, "Welcome! The commands of this business are as follows: /buyclothes");
		}
		case 3, 4, 7: {
			SendClientMessage(playerid, COLOR_WHITE, "Welcome! The commands of this business are as follows: /buy");
		}
		case 5: {
			SendClientMessage(playerid, COLOR_WHITE, "Welcome! The commands of this business are as follows: /buyvehicle");
		}
		case 6: {
			SendClientMessage(playerid, COLOR_WHITE, "Welcome! The commands of this business are as follows: /buyfightstyle");
		}
	}
	
	return 1;
}

public VendDrink(playerid) {
    new
		Float:health;

	ApplyAnimation(playerid, "VENDING", "VEND_Drink_P", 1, 0, 0, 0, 0, 1750);
	GetPlayerHealth(playerid,health);
	if(health > 65.0) SetPlayerHealth(playerid,100.0); // This limits player health to 100 (as values over 100.0 could otherwise be achieved, which isn't good).
	else SetPlayerHealth(playerid,health+35.0); // A Sprunk machine gives exactly 35.0 HP per hit.
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2) {
	#if defined DEBUG
	    printf("[debug] OnVehicleRespray(%d, %d, %d, %d)", playerid, vehicleid, color1, color2);
	#endif

	/* With modifications, we don't need to do this as there's already a GetVehicleComponentInSlot function.
	However, this will save paint if a player who doesn't own the car is driving. */
	SetPVarInt(playerid, "pC", 1);
	foreach(Player, v) {
		if(GetPlayerVehicleID(playerid) == playerVariables[v][pCarID]) {
			playerVariables[v][pCarColour][0] = color1;
			playerVariables[v][pCarColour][1] = color2;
		}
	}
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid) { // No need to deduct money; thanks to SA:MP, OnVehicleRespray is called when a paint job has been applied.
	#if defined DEBUG
	    printf("[debug] OnVehiclePaintjob(%d, %d, %d)", playerid, vehicleid, paintjobid);
	#endif
	
	SetPVarInt(playerid, "pC", 1);
	foreach(Player, v) {
		if(GetPlayerVehicleID(playerid) == playerVariables[v][pCarID]) {
			playerVariables[v][pCarPaintjob] = paintjobid;
		}
	}
}

public OnEnterExitModShop(playerid, enterexit, interiorid) {
	#if defined DEBUG
	    printf("[debug] OnEnterExitModShop(%d, %d, %d)", playerid, enterexit, interiorid);
	#endif

	if(enterexit == 0) {
		if(GetPVarInt(playerid, "pC") == 1) {
			playerVariables[playerid][pMoney] -= 500;
			DeletePVar(playerid, "pC");
		}
		foreach(Player, v) {
			if(GetPlayerVehicleID(playerid) == playerVariables[v][pCarID]) {
				for(new i = 0; i < 13; i++) {
					playerVariables[v][pCarMods][i] = GetVehicleComponentInSlot(playerVariables[v][pCarID], i);
				}
			}
		}
	}
}

public OnVehicleMod(playerid, vehicleid, componentid) {
	#if defined DEBUG
	    printf("[debug] OnVehicleMod(%d, %d, %d)", playerid, vehicleid, componentid);
	#endif
	
	if(GetPlayerInterior(playerid) < 1 && GetPlayerInterior(playerid) > 3 && playerVariables[playerid][pAdminLevel] < 3) {
		GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
		format(szMessage, sizeof(szMessage), "AdmWarn: {FFFFFF}%s may possibly be hacking vehicle mods (added component %d to their %s).", szPlayerName, componentid, VehicleNames[GetVehicleModel(vehicleid) - 400]);
		submitToAdmins(szMessage, COLOR_HOTORANGE);
	}

	else if(GetPlayerInterior(playerid) >= 1 && GetPlayerInterior(playerid) <= 3) {

		switch(componentid) { // Get the price for the vehicle component, only if they're in a mod garage.

			case 1024:												playerVariables[playerid][pMoney] -= 50;
			case 1006:  											playerVariables[playerid][pMoney] -= 80;
			case 1004, 1145, 1013, 1091, 1086:						playerVariables[playerid][pMoney] -= 100;
			case 1005, 1143, 1022, 1035, 1088:						playerVariables[playerid][pMoney] -= 150;
			case 1021, 1009, 1002, 1016, 1068, 1153:				playerVariables[playerid][pMoney] -= 200;
			case 1011:												playerVariables[playerid][pMoney] -= 220;
			case 1012, 1020, 1003, 1067:							playerVariables[playerid][pMoney] -= 250;
			case 1019:												playerVariables[playerid][pMoney] -= 300;
			case 1018, 1023, 1093:									playerVariables[playerid][pMoney] -= 350;
			case 1014, 1000:										playerVariables[playerid][pMoney] -= 400;
			case 1163, 1090, 1070:									playerVariables[playerid][pMoney] -= 450;
			case 1008, 1007, 1017, 1015, 1044, 1043, 1036:		   	playerVariables[playerid][pMoney] -= 500;
			case 1045:												playerVariables[playerid][pMoney] -= 510;
			case 1001, 1158, 1069, 1164:							playerVariables[playerid][pMoney] -= 550;
			case 1050, 1058, 1097:									playerVariables[playerid][pMoney] -= 620;
			case 1162, 1089:										playerVariables[playerid][pMoney] -= 650;
			case 1028, 1085:										playerVariables[playerid][pMoney] -= 770;
			case 1122, 1106, 1108, 1118:							playerVariables[playerid][pMoney] -= 780;
			case 1134:												playerVariables[playerid][pMoney] -= 800;
			case 1082:												playerVariables[playerid][pMoney] -= 820;
			case 1064, 1133:										playerVariables[playerid][pMoney] -= 830;
			case 1165, 1167, 1065:									playerVariables[playerid][pMoney] -= 850;
			case 1175, 1177, 1172, 1080:							playerVariables[playerid][pMoney] -= 900;
			case 1100, 1119, 1192:									playerVariables[playerid][pMoney] -= 940;
			case 1173, 1161, 1166, 1168:							playerVariables[playerid][pMoney] -= 950;
			case 1010, 1149, 1176, 1042, 1136, 1025, 1096, 1174:   	playerVariables[playerid][pMoney] -= 1000;
			case 1155, 1154:										playerVariables[playerid][pMoney] -= 1030;
			case 1160, 1159:										playerVariables[playerid][pMoney] -= 1050;
			case 1150:												playerVariables[playerid][pMoney] -= 1090;
			case 1193, 1073:										playerVariables[playerid][pMoney] -= 1100;
			case 1190, 1078:										playerVariables[playerid][pMoney] -= 1200;
			case 1135, 1087:										playerVariables[playerid][pMoney] -= 1500;
			case 1083, 1076:										playerVariables[playerid][pMoney] -= 1560;
			case 1179, 1184:										playerVariables[playerid][pMoney] -= 2150;
			case 1046:												playerVariables[playerid][pMoney] -= 710;
			case 1152:												playerVariables[playerid][pMoney] -= 910;
			case 1151:												playerVariables[playerid][pMoney] -= 840;
			case 1054:												playerVariables[playerid][pMoney] -= 210;
			case 1053:												playerVariables[playerid][pMoney] -= 130;
			case 1049:												playerVariables[playerid][pMoney] -= 810;
			case 1047:												playerVariables[playerid][pMoney] -= 670;
			case 1048:												playerVariables[playerid][pMoney] -= 530;
			case 1066:												playerVariables[playerid][pMoney] -= 750;
			case 1034:												playerVariables[playerid][pMoney] -= 790;
			case 1037:												playerVariables[playerid][pMoney] -= 690;
			case 1171:												playerVariables[playerid][pMoney] -= 990;
			case 1148:												playerVariables[playerid][pMoney] -= 890;
			case 1038:												playerVariables[playerid][pMoney] -= 190;
			case 1146:												playerVariables[playerid][pMoney] -= 490;
			case 1039:												playerVariables[playerid][pMoney] -= 390;
			case 1059:												playerVariables[playerid][pMoney] -= 720;
			case 1157:												playerVariables[playerid][pMoney] -= 930;
			case 1156:												playerVariables[playerid][pMoney] -= 920;
			case 1055:												playerVariables[playerid][pMoney] -= 230;
			case 1061:												playerVariables[playerid][pMoney] -= 180;
			case 1060:												playerVariables[playerid][pMoney] -= 530;
			case 1056:												playerVariables[playerid][pMoney] -= 520;
			case 1057:												playerVariables[playerid][pMoney] -= 430;
			case 1029:												playerVariables[playerid][pMoney] -= 680;
			case 1169:												playerVariables[playerid][pMoney] -= 970;
			case 1170:												playerVariables[playerid][pMoney] -= 880;
			case 1141:												playerVariables[playerid][pMoney] -= 980;
			case 1140:												playerVariables[playerid][pMoney] -= 870;
			case 1032:												playerVariables[playerid][pMoney] -= 170;
			case 1033:												playerVariables[playerid][pMoney] -= 120;
			case 1138:												playerVariables[playerid][pMoney] -= 580;
			case 1139:												playerVariables[playerid][pMoney] -= 470;
			case 1026:												playerVariables[playerid][pMoney] -= 480;
			case 1031:												playerVariables[playerid][pMoney] -= 370;
			case 1092:												playerVariables[playerid][pMoney] -= 750;
			case 1128:												playerVariables[playerid][pMoney] -= 3340;
			case 1103:												playerVariables[playerid][pMoney] -= 3250;
			case 1183:												playerVariables[playerid][pMoney] -= 2040;
			case 1182:												playerVariables[playerid][pMoney] -= 2130;
			case 1181:												playerVariables[playerid][pMoney] -= 2050;
			case 1104:												playerVariables[playerid][pMoney] -= 1610;
			case 1105:												playerVariables[playerid][pMoney] -= 1540;
			case 1126:												playerVariables[playerid][pMoney] -= 3340;
			case 1127:												playerVariables[playerid][pMoney] -= 3250;
			case 1185:												playerVariables[playerid][pMoney] -= 2040;
			case 1180:												playerVariables[playerid][pMoney] -= 2130;
			case 1178:												playerVariables[playerid][pMoney] -= 2050;
			case 1123:												playerVariables[playerid][pMoney] -= 860;
			case 1125:												playerVariables[playerid][pMoney] -= 1120;
			case 1130:												playerVariables[playerid][pMoney] -= 3380;
			case 1131:												playerVariables[playerid][pMoney] -= 3290;
			case 1189:												playerVariables[playerid][pMoney] -= 2200;
			case 1188:												playerVariables[playerid][pMoney] -= 2080;
			case 1187:												playerVariables[playerid][pMoney] -= 2175;
			case 1186:												playerVariables[playerid][pMoney] -= 2095;
			case 1129:												playerVariables[playerid][pMoney] -= 1650;
			case 1132:												playerVariables[playerid][pMoney] -= 1590;
			case 1113:												playerVariables[playerid][pMoney] -= 3340;
			case 1114:												playerVariables[playerid][pMoney] -= 3250;
			case 1117:												playerVariables[playerid][pMoney] -= 2040;
			case 1115:												playerVariables[playerid][pMoney] -= 2130;
			case 1116:												playerVariables[playerid][pMoney] -= 2050;
			case 1109:												playerVariables[playerid][pMoney] -= 1610;
			case 1110:												playerVariables[playerid][pMoney] -= 1540;
			case 1191:												playerVariables[playerid][pMoney] -= 1040;
			case 1079:												playerVariables[playerid][pMoney] -= 1030;
			case 1075:												playerVariables[playerid][pMoney] -= 980;
			case 1077:												playerVariables[playerid][pMoney] -= 1620;
			case 1074:												playerVariables[playerid][pMoney] -= 1030;
			case 1081:												playerVariables[playerid][pMoney] -= 1230;
			case 1084:												playerVariables[playerid][pMoney] -= 1350;
			case 1098:												playerVariables[playerid][pMoney] -= 1140;
		}
	}
	return 1;
}

CMD:abandoncar(playerid, params[]) {
	if(playerVariables[playerid][pCarModel] >= 1) {
		if(IsPlayerInRangeOfVehicle(playerid, playerVariables[playerid][pCarID], 5.0)) {
			DestroyPlayerVehicle(playerid);
			SendClientMessage(playerid, COLOR_GREY, "You have abandoned your vehicle.");

			if(playerVariables[playerid][pCheckpoint] == 4) {
				DisablePlayerCheckpoint(playerid);
				playerVariables[playerid][pCheckpoint] = 0;
			}
		}
		else SendClientMessage(playerid, COLOR_GREY, "You're too far away from your vehicle.");
	}
	return 1;
}

CMD:givecar(playerid, params[]) {
	if(sscanf(params, "u", iTarget))
		SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/givecar [playerid]");
	else if(!IsPlayerAuthed(iTarget))
		SendClientMessage(playerid, COLOR_GREY, "The specified player is not connected, or has not authenticated.");
	else
	{
		if(playerVariables[playerid][pCarModel] >= 1) 
		{
			if(IsPlayerInRangeOfPlayer(playerid, iTarget, 5.0)) 
			{
				SetPVarInt(iTarget, "gC", playerid + 1);
				// The usual culprit - barely accessed, barely used. As PVars return 0 if they don't exist, adding +1 ensures they return a valid playerid.

				GetPlayerName(iTarget, szPlayerName, MAX_PLAYER_NAME);

				format(szMessage, sizeof(szMessage), "You have offered %s the keys to your %s.", szPlayerName, VehicleNames[playerVariables[playerid][pCarModel] - 400]);
				SendClientMessage(playerid, COLOR_WHITE, szMessage);

				GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

				format(szMessage, sizeof(szMessage), "%s is offering you the keys to their %s (type /accept givecar).", szPlayerName, VehicleNames[playerVariables[playerid][pCarModel] - 400]);
				SendClientMessage(iTarget, COLOR_NICESKY, szMessage);
			}
			else SendClientMessage(playerid, COLOR_GREY, "You're too far away from that person.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You don't own a vehicle.");
	}
	return 1;
}

CMD:lockcar(playerid, params[]) {
	if(doesVehicleExist(playerVariables[playerid][pCarID]) && playerVariables[playerid][pCarModel] >= 1) {
		if(IsPlayerInRangeOfVehicle(playerid, playerVariables[playerid][pCarID], 10.0)) {

			GetVehiclePos(playerVariables[playerid][pCarID], playerVariables[playerid][pCarPos][0], playerVariables[playerid][pCarPos][1], playerVariables[playerid][pCarPos][2]);
			PlayerPlaySoundEx(1145, playerVariables[playerid][pCarPos][0], playerVariables[playerid][pCarPos][1], playerVariables[playerid][pCarPos][2]);

			switch(playerVariables[playerid][pCarLock]) {
				case 0: {
					playerVariables[playerid][pCarLock] = 1;
					SendClientMessage(playerid, COLOR_WHITE, "You have locked your vehicle.");

					foreach(Player, x) {
						SetVehicleParamsForPlayer(playerVariables[playerid][pCarID], x, 0, 1);
					}
				}
				default: {
					playerVariables[playerid][pCarLock] = 0;
					SendClientMessage(playerid, COLOR_WHITE, "You have unlocked your vehicle.");

					foreach(Player, x) {
						SetVehicleParamsForPlayer(playerVariables[playerid][pCarID], x, 0, 0);
					}
				}
			}
		}
		else SendClientMessage(playerid, COLOR_GREY, "You're too far away from your vehicle.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "You don't own a vehicle.");
	return 1;
}

CMD:findcar(playerid, params[]) {
	if(playerVariables[playerid][pCarModel] >= 1) {
		if(playerVariables[playerid][pCheckpoint] == 0 && playerVariables[playerid][pCheckpoint] != 4) {
			GetVehiclePos(playerVariables[playerid][pCarID], playerVariables[playerid][pCarPos][0], playerVariables[playerid][pCarPos][1], playerVariables[playerid][pCarPos][2]);
			SetPlayerCheckpoint(playerid, playerVariables[playerid][pCarPos][0], playerVariables[playerid][pCarPos][1], playerVariables[playerid][pCarPos][2], 10.0);
			playerVariables[playerid][pCheckpoint] = 4;

			format(szMessage, sizeof(szMessage), "A checkpoint has been set to your %s.", VehicleNames[playerVariables[playerid][pCarModel] - 400]);
			SendClientMessage(playerid, COLOR_WHITE, szMessage);
		}
		else {
			format(szMessage, sizeof(szMessage), "You already have an active checkpoint (%s), reach it first, or /killcheckpoint.", getPlayerCheckpointReason(playerid));
			SendClientMessage(playerid, COLOR_GREY, szMessage);
		}
	}
	else SendClientMessage(playerid, COLOR_GREY, "You don't own a vehicle.");
	return 1;
}

CMD:unmodcar(playerid, params[]) {
	if(playerVariables[playerid][pCarModel] >= 1) {
		if(IsPlayerInRangeOfVehicle(playerid, playerVariables[playerid][pCarID], 5.0)) {

			new
				Float: vHealth,
				Damage[4];

			GetVehicleDamageStatus(playerVariables[playerid][pCarID], Damage[0], Damage[1], Damage[2], Damage[3]);
			GetVehiclePos(playerVariables[playerid][pCarID], playerVariables[playerid][pCarPos][0], playerVariables[playerid][pCarPos][1], playerVariables[playerid][pCarPos][2]);
			GetVehicleZAngle(playerVariables[playerid][pCarID], playerVariables[playerid][pCarPos][3]);
			GetVehicleHealth(playerVariables[playerid][pCarID], vHealth);

			for(new i = 0; i < 13; i++) {
				playerVariables[playerid][pCarMods][i] = 0;
			}

			playerVariables[playerid][pCarPaintjob] = -1;

			if(IsPlayerInVehicle(playerid, playerVariables[playerid][pCarID]) && GetPlayerState(playerid) == 2) {
				DestroyVehicle(playerVariables[playerid][pCarID]);
				systemVariables[vehicleCounts][1]--;
				playerVariables[playerid][pCarID] = -1;
				SpawnPlayerVehicle(playerid);
				PutPlayerInVehicle(playerid, playerVariables[playerid][pCarID], 0);
			}
			else {
				DestroyVehicle(playerVariables[playerid][pCarID]);
				playerVariables[playerid][pCarID] = -1;
				systemVariables[vehicleCounts][1]--;
				SpawnPlayerVehicle(playerid);
			}
			SetVehicleHealth(playerVariables[playerid][pCarID], vHealth);
			UpdateVehicleDamageStatus(playerVariables[playerid][pCarID], Damage[0], Damage[1], Damage[2], Damage[3]);
		}
		else SendClientMessage(playerid, COLOR_GREY, "You're too far away from your vehicle.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "You don't own a vehicle.");
	return 1;
}
// ------------------------- VEHICLE STOCKS -------------------------

stock PurchaseVehicleFromDealer(playerid, model, price) { // This is going to stop so much code-rape. :3
	if(playerVariables[playerid][pMoney] >= price) {
		if(playerVariables[playerid][pCarModel] < 1) {

			new
				string[64],
				businessID = GetPlayerVirtualWorld(playerid)-BUSINESS_VIRTUAL_WORLD;

			playerVariables[playerid][pCarModel] = model; // Set the model.
			playerVariables[playerid][pCarPaintjob] = -1;

			playerVariables[playerid][pCarColour][0] = random(126);
			playerVariables[playerid][pCarColour][1] = random(126);

			playerVariables[playerid][pCarPos][0] = businessVariables[businessID][bMiscPos][0]; // Set the pos to the business misc pos.
			playerVariables[playerid][pCarPos][1] = businessVariables[businessID][bMiscPos][1];
			playerVariables[playerid][pCarPos][2] = businessVariables[businessID][bMiscPos][2];

			SpawnPlayerVehicle(playerid);

			playerVariables[playerid][pMoney] -= price;
			businessVariables[businessID][bVault] += price;

			format(string, sizeof(string), "Congratulations! You have purchased a %s for $%d.", VehicleNames[model - 400], price);
			SendClientMessage(playerid, COLOR_WHITE, string);

			ShowPlayerDialog(playerid, DIALOG_LICENSE_PLATE, DIALOG_STYLE_INPUT, "License plate registration", "Please enter a license plate for your vehicle. \n\nThere is only two conditions:\n- The license plate must be unique\n- The license plate can be alphanumerical, but it must consist of only 7 characters and include one space.", "Select", "");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You already have a vehicle; sell it first.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this vehicle.");
}

stock DestroyPlayerVehicle(playerid) { // This can be used for two things; resetting all vars, and completely destroying a player vehicle.

	playerVariables[playerid][pCarPos][0] = 0.0;
	playerVariables[playerid][pCarPos][1] = 0.0;
	playerVariables[playerid][pCarPos][2] = 0.0;
	playerVariables[playerid][pCarPos][3] = 0.0;
	playerVariables[playerid][pCarColour][0] = -1;
	playerVariables[playerid][pCarColour][1] = -1;
	playerVariables[playerid][pCarModel] = 0;
	playerVariables[playerid][pCarPaintjob] = -1; // 0 is a valid paintjob. D:
	playerVariables[playerid][pCarTrunk][0] = 0;
	playerVariables[playerid][pCarTrunk][1] = 0;

	new
		x;

	while(x < 13) {
		playerVariables[playerid][pCarMods][x] = 0;
		x++;
	}

	x = 0;

	while(x < 5) {
		playerVariables[playerid][pCarWeapons][x] = 0;
		x++;
	}

	if(doesVehicleExist(playerVariables[playerid][pCarID])) DestroyVehicle(playerVariables[playerid][pCarID]);

	playerVariables[playerid][pCarID] = -1;
	systemVariables[vehicleCounts][1]--;

	return 1;
}

stock SetAllVehiclesToRespawn() { // Doesn't bother looping through all cars/players, more efficient


	systemVariables[vehicleCounts][0] = 0;
	systemVariables[vehicleCounts][1] = 0;

	for(new x; x < MAX_VEHICLES; x++) {
		if(doesVehicleExist(vehicleVariables[x][vVehicleScriptID])) { // Saved
			DestroyVehicle(vehicleVariables[x][vVehicleScriptID]);
			vehicleVariables[x][vVehicleScriptID] = CreateVehicle(vehicleVariables[x][vVehicleModelID], vehicleVariables[x][vVehiclePosition][0], vehicleVariables[x][vVehiclePosition][1], vehicleVariables[x][vVehiclePosition][2], vehicleVariables[x][vVehicleRotation], vehicleVariables[x][vVehicleColour][0], vehicleVariables[x][vVehicleColour][1], 60000);
			systemVariables[vehicleCounts][0]++;
		}
		else if(doesVehicleExist(AdminSpawnedVehicles[x])) { // Admin
			SetVehicleToRespawn(AdminSpawnedVehicles[x]);
		}
	}
	foreach(Player, v) {  // Player.
		if(doesVehicleExist(playerVariables[v][pCarID]) && playerVariables[v][pCarModel] >= 1) {

			GetVehiclePos(playerVariables[v][pCarID], playerVariables[v][pCarPos][0], playerVariables[v][pCarPos][1], playerVariables[v][pCarPos][2]);
			GetVehicleZAngle(playerVariables[v][pCarID], playerVariables[v][pCarPos][3]);

			DestroyVehicle(playerVariables[v][pCarID]);
			playerVariables[v][pCarID] = CreateVehicle(playerVariables[v][pCarModel], playerVariables[v][pCarPos][0], playerVariables[v][pCarPos][1], playerVariables[v][pCarPos][2], playerVariables[v][pCarPos][3], playerVariables[v][pCarColour][0], playerVariables[v][pCarColour][1], -1);

			for(new i = 0; i < 13; i++) {
				if(playerVariables[v][pCarMods][i] >= 1) AddVehicleComponent(playerVariables[v][pCarID], playerVariables[v][pCarMods][i]);
			}
			if(playerVariables[v][pCarPaintjob] >= 0) ChangeVehiclePaintjob(playerVariables[v][pCarID], playerVariables[v][pCarPaintjob]);
			systemVariables[vehicleCounts][1]++;
		}
	}
	return 1;
}

stock SetVehicleToRespawnEx(vehicleid) { // Great for respawning any given type of vehicle (player/admin/saved).

	foreach(Player, v) {  // Player.
		if(vehicleid == playerVariables[v][pCarID] && playerVariables[v][pCarModel] >= 1) {

			GetVehiclePos(playerVariables[v][pCarID], playerVariables[v][pCarPos][0], playerVariables[v][pCarPos][1], playerVariables[v][pCarPos][2]);
			GetVehicleZAngle(playerVariables[v][pCarID], playerVariables[v][pCarPos][3]);

			DestroyVehicle(playerVariables[v][pCarID]);
			playerVariables[v][pCarID] = CreateVehicle(playerVariables[v][pCarModel], playerVariables[v][pCarPos][0], playerVariables[v][pCarPos][1], playerVariables[v][pCarPos][2], playerVariables[v][pCarPos][3], playerVariables[v][pCarColour][0], playerVariables[v][pCarColour][1], -1);

			for(new i = 0; i < 13; i++) {
				if(playerVariables[v][pCarMods][i] >= 1) AddVehicleComponent(playerVariables[v][pCarID], playerVariables[v][pCarMods][i]);
			}
			if(playerVariables[v][pCarPaintjob] >= 0) ChangeVehiclePaintjob(playerVariables[v][pCarID], playerVariables[v][pCarPaintjob]);
			return 1;
		}
	}

	for(new x; x < MAX_VEHICLES; x++) {
		if(vehicleVariables[x][vVehicleScriptID] == vehicleid) { // Saved
			DestroyVehicle(vehicleVariables[x][vVehicleScriptID]);
			vehicleVariables[x][vVehicleScriptID] = CreateVehicle(vehicleVariables[x][vVehicleModelID], vehicleVariables[x][vVehiclePosition][0], vehicleVariables[x][vVehiclePosition][1], vehicleVariables[x][vVehiclePosition][2], vehicleVariables[x][vVehicleRotation], vehicleVariables[x][vVehicleColour][0], vehicleVariables[x][vVehicleColour][1], 60000);
			return 1;
		}
		else if(AdminSpawnedVehicles[x] == vehicleid) { // Admin
			SetVehicleToRespawn(AdminSpawnedVehicles[x]);
			return 1;
		}
	}
	return 1;
}

stock SpawnPlayerVehicle(playerid) {
	if(playerVariables[playerid][pCarModel] >= 1) {
		if(systemVariables[vehicleCounts][0] + systemVariables[vehicleCounts][1] + systemVariables[vehicleCounts][2] < MAX_VEHICLES) {
			if(doesVehicleExist(playerVariables[playerid][pCarID])) DestroyVehicle(playerVariables[playerid][pCarID]); // In case the IDs decide to f*$^# up.
			playerVariables[playerid][pCarID] = CreateVehicle(playerVariables[playerid][pCarModel], playerVariables[playerid][pCarPos][0], playerVariables[playerid][pCarPos][1], playerVariables[playerid][pCarPos][2], playerVariables[playerid][pCarPos][3], playerVariables[playerid][pCarColour][0], playerVariables[playerid][pCarColour][1], -1);

			for(new i = 0; i < 13; i++) {
				if(playerVariables[playerid][pCarMods][i] >= 1) AddVehicleComponent(playerVariables[playerid][pCarID], playerVariables[playerid][pCarMods][i]);
			}

			systemVariables[vehicleCounts][1]++;
			if(playerVariables[playerid][pCarPaintjob] >= 0) ChangeVehiclePaintjob(playerVariables[playerid][pCarID], playerVariables[playerid][pCarPaintjob]);
	        SetVehicleNumberPlate(playerVariables[playerid][pCarID], playerVariables[playerid][pCarLicensePlate]);

	        // De-stream the vehicle
	        SetVehicleVirtualWorld(playerVariables[playerid][pCarID], GetVehicleVirtualWorld(playerVariables[playerid][pCarID])+1);
	        SetVehicleVirtualWorld(playerVariables[playerid][pCarID], GetVehicleVirtualWorld(playerVariables[playerid][pCarID])-1);
		}
		else printf("ERROR: Vehicle limit reached (MODEL %d, PLAYER %d, MAXIMUM %d, TYPE PLAYER) [01x08]", playerVariables[playerid][pCarModel], playerid, MAX_VEHICLES);
	}
	return 1;
}

// ------------------------- END OF VEHICLE STOCKS -------------------------

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	#if defined DEBUG
	    printf("[debug] OnDialogResponse(%d, %d, %d, %d, %s)", playerid, dialogid, response, listitem, inputtext);
	#endif
	
	if(!isnull(inputtext))
		for(new strPos; inputtext[strPos] > 0; strPos++)
			if(inputtext[strPos] == '%')
				inputtext[strPos] = '\0'; // SA-MP placeholder exploit patch

	switch(dialogid) {
	    case DIALOG_GMX: {
	        if(playerVariables[playerid][pAdminLevel] >= 5) {
	            if(!response)
	                return SendClientMessage(playerid, COLOR_GREY, "Restart attempt canned.");

		        SendClientMessage(playerid, COLOR_YELLOW, "---- SERVER RESTART ----");

		        foreach(Player, x) {
					if(playerVariables[x][pAdminDuty] > 0) {
						playerVariables[x][pAdminDuty] = 0;
						SetPlayerName(x, playerVariables[x][pNormalName]);
						SendClientMessage(x, COLOR_WHITE, "A server restart has been initiated; you have been forced off administrative duty to prevent being automatically kicked.");
						SetPlayerHealth(x, 100);
					}

					savePlayerData(x);
				}
				SendClientMessage(playerid, COLOR_GREY, "- Player data saved.");

				for(new xh = 0; xh < MAX_HOUSES; xh++) {
		            saveHouse(xh);
				}
				SendClientMessage(playerid, COLOR_GREY, "- House data saved.");

				for(new xf = 0; xf < MAX_GROUPS; xf++) {
		            saveGroup(xf);
				}
				SendClientMessage(playerid, COLOR_GREY, "- Group data saved.");

				for(new xf = 0; xf < MAX_BUSINESSES; xf++) {
		            saveBusiness(xf);
				}
				SendClientMessage(playerid, COLOR_GREY, "- Business data saved.");

				for(new xf = 0; xf < MAX_ASSETS; xf++) {
		            saveAsset(xf);
				}
				SendClientMessage(playerid, COLOR_GREY, "- Server asset data saved.");
				
				#if !defined NO_IRC
				 	IRC_Quit(scriptBots[0], "SA-MP server restart issued by an Admin");
				#endif

				SendClientMessage(playerid, COLOR_WHITE, "Restarting timer activated.");

				iGMXTick = 6;
				iGMXTimer = SetTimer("restartTimer", 1000, true);

				SendClientMessage(playerid, COLOR_YELLOW, "---- SERVER RESTART ----");
	        }
	    }
	    case DIALOG_SET_ADMIN_PIN: {
			if(strlen(inputtext) != 4 && strval(inputtext) < 1000 || strval(inputtext) >= 10000)
   				return ShowPlayerDialog(playerid, DIALOG_SET_ADMIN_PIN, DIALOG_STYLE_INPUT, "SERVER: Admin PIN creation", "The system has detected you do not yet have an admin PIN set.\n\nThis is a new compulsory security measure.\n\nPlease set a **four digit** pin:", "OK", "");

			SetPVarInt(playerid, "pAdminPIN", strval(inputtext));
			
			SendClientMessage(playerid, COLOR_GENANNOUNCE, "SERVER:{FFFFFF} Your new admin PIN has been set. Thank you for helping keep the server secure!");
		}
	    case DIALOG_MOBILE_HISTORY: {
	        return cmd_mobile(playerid, "n");
	    }
	    case DIALOG_QUIZ: {
	        switch(listitem) {
				case 0: {
					SetPVarInt(playerid, "quiz", 1);
				    ShowPlayerDialog(playerid, DIALOG_DO_TUTORIAL, DIALOG_STYLE_MSGBOX, "Brilliant!", "You've answered the question successfully.\n\nYou'll be taken to set some character preferences in a few seconds, unless you press 'OK'.", "OK", "");
					SetPVarInt(playerid, "tutt", SetTimerEx("initiateTutorial", 3000, false, "d", playerid));
				}
				case 1, 2, 3: {
				    ShowPlayerDialog(playerid, DIALOG_DO_TUTORIAL, DIALOG_STYLE_MSGBOX, "Bad luck!", "You've unfortunately failed to answer the question correctly, therefore you're going to have to watch our basic tutorial. \n\nThis box will disappear and you will partake in the tutorial after choosing your character preferences in a few seconds, unless you press 'OK'.", "OK", "");
                    SetPVarInt(playerid, "tutt", SetTimerEx("initiateTutorial", 3000, false, "d", playerid));
				}
			}
	    }
	    case DIALOG_DO_TUTORIAL: {
	        if(playerVariables[playerid][pTutorial] == 0) {
		        KillTimer(GetPVarInt(playerid, "tutt"));
		        hidePlayerDialog(playerid);

				return initiateTutorial(playerid);
			}
		}
	    case DIALOG_ATM_MENU: {
		    if(!response)
		        return 1;

			// Reset the player's position to revoke the player crouching animation for convenience
			GetPlayerPos(playerid, playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2]);
			SetPlayerPos(playerid, playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2]);
			    
	        switch(listitem) {
	            case 0: {
					format(szMessage, sizeof(szMessage), "Your bank account balance is currently standing at $%d.", playerVariables[playerid][pBankMoney]);
					ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "SERVER: Automated Teller Machine", szMessage, "OK", "");
				}
	            case 1: {
	                ShowPlayerDialog(playerid, DIALOG_ATM_WITHDRAWAL, DIALOG_STYLE_INPUT, "SERVER: ATM", "Please specify the amount of money that you'd like to withdraw.\n\nYou can withdraw up to $10,000 from this ATM.\n\nNote: This ATM charges $2 from any withdrawals you make.", "OK", "Cancel");
				}
	        }
		}
		case DIALOG_ATM_WITHDRAWAL: {
		    if(!response)
		        return 1;
		        
			new
			    iWithdrawalAmount = strval(inputtext);

			if(playerVariables[playerid][pBankMoney] > iWithdrawalAmount && iWithdrawalAmount > 1 && iWithdrawalAmount < 10000) {
			    playerVariables[playerid][pBankMoney] -= iWithdrawalAmount - 2;
			    playerVariables[playerid][pMoney] += iWithdrawalAmount;
			    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "SERVER: Automated Teller Machine", "Your money has been withdrawn. \n\nThank you for using our ATM today!", "OK", "");
			} else {
			    SendClientMessage(playerid, COLOR_GREY, "You do not have enough money to withdraw this amount.");
			    ShowPlayerDialog(playerid, DIALOG_ATM_WITHDRAWAL, DIALOG_STYLE_INPUT, "SERVER: ATM", "Please select a value of money that you currently have in your bank account.\n\nPlease specify the amount of money that you'd like to withdraw. \n\nYou can withdraw up to $10,000 from this ATM.\n\nNote: This ATM charges $2 from any withdrawals you make.", "OK", "Cancel");
			}
		}
	    case DIALOG_MOBILE_CONTACTS_MAIN: {
	        switch(listitem) {
				case 0: {
					new
					    szQuery[150];

					format(szQuery, sizeof(szQuery), "SELECT `contactName`, `contactAdded`, `contactAddee` FROM `phonecontacts` WHERE `contactAddee` = %d LIMIT 10", playerVariables[playerid][pPhoneNumber]);
					mysql_query(szQuery, THREAD_MOBILE_LIST_CONTACTS, playerid);
				}
				case 1: return 1;
				case 2: return 1;
			}
	    }
	    case DIALOG_PHONE_MENU: {
	        if(!response)
	            return 1;

	        switch(listitem) {
				case 0: { /* History */
					new
					    szQuery[99];

					format(szQuery, sizeof(szQuery), "SELECT `phoneNumber`, `phoneAction` FROM `phonelogs` WHERE `phoneNumber` = %d LIMIT 5", playerVariables[playerid][pPhoneNumber]);
					mysql_query(szQuery, THREAD_MOBILE_HISTORY, playerid);
				}
				case 1: { /* Contacts */
				    ShowPlayerDialog(playerid, DIALOG_MOBILE_CONTACTS_MAIN, DIALOG_STYLE_LIST, "Mobile Phone: Contacts", "List Contacts\nAdd Contact\nRemove Contact", "Proceed", "Return");
				}
			}
	    }
	    case DIALOG_RP_NAME_CHANGE: { 
	    	new
				charCounts[5];
				
			if(strlen(inputtext) > 20) {
			    SendClientMessage(playerid, COLOR_GREY, "Your name must be less than 20 characters.");
				invalidNameChange(playerid);
			    return 1;
			}
			
			format(szPlayerName, MAX_PLAYER_NAME, "%s", inputtext);

			for(new n; n < MAX_PLAYER_NAME; n++) {
				switch(szPlayerName[n]) {
					case '[', ']', '.', '$', '(', ')', '@', '=': charCounts[1]++;
					case '_': charCounts[0]++;
					case '0' .. '9': charCounts[2]++;
					case 'a' .. 'z': charCounts[3]++;
					case 'A' .. 'Z': charCounts[4]++;
				}
			}
			if(charCounts[0] == 0 || charCounts[0] >= 3) {
				SendClientMessage(playerid, COLOR_GREY, "Your name is not valid. {FFFFFF}Please use an underscore and a first/last name (i.e. Mark_Edwards).");
				invalidNameChange(playerid);
			}
			else if(charCounts[1] >= 1) {
				SendClientMessage(playerid, COLOR_GREY, "Your name is not valid, as it contains symbols. {FFFFFF}Please use a roleplay name.");
				invalidNameChange(playerid);
			}
			else if(charCounts[2] >= 1) {
				SendClientMessage(playerid, COLOR_GREY, "Your name is not valid, as it contains numbers. {FFFFFF}Please use a roleplay name.");
				invalidNameChange(playerid);
			}
			else if(charCounts[3] == strlen(inputtext) - 1) {
				SendClientMessage(playerid, COLOR_GREY, "Your name is not valid, as it is lower case. {FFFFFF}Please use a roleplay name (i.e. Dave_Meniketti).");
				invalidNameChange(playerid);
			}
			else if(charCounts[4] == strlen(inputtext) - 1) {
				SendClientMessage(playerid, COLOR_GREY, "Your name is not valid, as it is upper case. {FFFFFF}Please use a roleplay name (i.e. Dave_Jones).");
				invalidNameChange(playerid);
			}
			else {
			    mysql_real_escape_string(inputtext, playerVariables[playerid][pNormalName]);
			    SetPlayerName(playerid, playerVariables[playerid][pNormalName]);

				format(szQueryOutput, sizeof(szQueryOutput), "SELECT `playerName` FROM `playeraccounts` WHERE `playerName` = '%s'", playerVariables[playerid][pNormalName]);
			    mysql_query(szQueryOutput, THREAD_CHECK_ACCOUNT_USERNAME, playerid);
			}
		}
	    case DIALOG_LICENSE_PLATE: {
			if(strfind(inputtext, " ", true, 0) == -1)
			    return ShowPlayerDialog(playerid, DIALOG_LICENSE_PLATE, DIALOG_STYLE_INPUT, "License plate registration", "{FFFFFF}ERROR:"EMBED_GREY" Your license plate didn't contain a space.{FFFFFF}\n\nPlease enter a license plate for your vehicle. \n\nThere is only two conditions:\n- The license plate must be unique\n- The license plate can be alphanumerical, but it must consist of only 7 characters and include one space.", "Select", "");

			if(strfind(inputtext, "[", true, 0) != -1 || strfind(inputtext, "]", true, 0) != -1 || strfind(inputtext, ".", true, 0) != -1 || strfind(inputtext, "$", true, 0) != -1 || strfind(inputtext, "(", true, 0) != -1 || strfind(inputtext, ")", true, 0) != -1 || strfind(inputtext, "=", true, 0) != -1 || strfind(inputtext, "@", true, 0) != -1)
			return ShowPlayerDialog(playerid, DIALOG_LICENSE_PLATE, DIALOG_STYLE_INPUT, "License plate registration", "{FFFFFF}ERROR:"EMBED_GREY" Your license plate contained non-alphanumerical characters.{FFFFFF}\n\nPlease enter a license plate for your vehicle. \n\nThere is only two conditions:\n- The license plate must be unique\n- The license plate can be alphanumerical, but it must consist of only 7 characters and include one space.", "Select", "");

			if(strlen(inputtext) != 7)
			    return ShowPlayerDialog(playerid, DIALOG_LICENSE_PLATE, DIALOG_STYLE_INPUT, "License plate registration", "{FFFFFF}ERROR:"EMBED_GREY" Your license plate must be 7 characters in length.{FFFFFF}\n\nPlease enter a license plate for your vehicle. \n\nThere is only two conditions:\n- The license plate must be unique\n- The license plate can be alphanumerical, but it must consist of only 7 characters and include one space.", "Select", "");

			new
			    szEscapedPlate[32],
			    szQuery[122];

			mysql_real_escape_string(inputtext, szEscapedPlate);
			SetPVarString(playerid, "plate", szEscapedPlate);

			format(szQuery, sizeof(szQuery), "SELECT `playerCarLicensePlate` FROM `playeraccounts` WHERE `playerCarLicensePlate` = '%s'", szEscapedPlate);
			mysql_query(szQuery, THREAD_CHECK_PLATES, playerid);
	    }
		case DIALOG_FIGHTSTYLE: if(response) switch(listitem) {
			case 0: {
				if(playerVariables[playerid][pFightStyle] != FIGHT_STYLE_BOXING) {
					if(playerVariables[playerid][pMoney] >= 10000){

						new
							business = GetPlayerVirtualWorld(playerid) - BUSINESS_VIRTUAL_WORLD;

						playerVariables[playerid][pMoney] -= 10000;
						playerVariables[playerid][pFightStyle] = FIGHT_STYLE_BOXING;
						businessVariables[business][bVault] += 10000;
						SendClientMessage(playerid, COLOR_WHITE, "You have successfully purchased this style of fighting.");
						SetPlayerFightingStyle(playerid, playerVariables[playerid][pFightStyle]);
					}
					else SendClientMessage(playerid, COLOR_GREY, "You do not have enough money to purchase this.");
				}
				else SendClientMessage(playerid, COLOR_GREY, "You are already using this style.");
			}
			case 1: {
				if(playerVariables[playerid][pFightStyle] != FIGHT_STYLE_KUNGFU) {
					if(playerVariables[playerid][pMoney] >= 25000){

						new
							business = GetPlayerVirtualWorld(playerid) - BUSINESS_VIRTUAL_WORLD;

						playerVariables[playerid][pMoney] -= 25000;
						playerVariables[playerid][pFightStyle] = FIGHT_STYLE_KUNGFU;
						businessVariables[business][bVault] += 25000;
						SendClientMessage(playerid, COLOR_WHITE, "You have successfully purchased this style of fighting.");
						SetPlayerFightingStyle(playerid, playerVariables[playerid][pFightStyle]);
					}
					else SendClientMessage(playerid, COLOR_GREY, "You do not have enough money to purchase this.");
				}
				else SendClientMessage(playerid, COLOR_GREY, "You are already using this style.");
			}
			case 2: {
				if(playerVariables[playerid][pFightStyle] != FIGHT_STYLE_KNEEHEAD) {
					if(playerVariables[playerid][pMoney] >= 15000){

						new
							business = GetPlayerVirtualWorld(playerid) - BUSINESS_VIRTUAL_WORLD;

						playerVariables[playerid][pMoney] -= 15000;
						playerVariables[playerid][pFightStyle] = FIGHT_STYLE_KNEEHEAD;
						businessVariables[business][bVault] += 15000;
						SendClientMessage(playerid, COLOR_WHITE, "You have successfully purchased this style of fighting.");
						SetPlayerFightingStyle(playerid, playerVariables[playerid][pFightStyle]);
					}
					else SendClientMessage(playerid, COLOR_GREY, "You do not have enough money to purchase this.");
				}
				else SendClientMessage(playerid, COLOR_GREY, "You are already using this style.");
			}
			case 3: {
				if(playerVariables[playerid][pFightStyle] != FIGHT_STYLE_GRABKICK) {
					if(playerVariables[playerid][pMoney] >= 12000){

						new
							business = GetPlayerVirtualWorld(playerid) - BUSINESS_VIRTUAL_WORLD;

						playerVariables[playerid][pMoney] -= 12000;
						playerVariables[playerid][pFightStyle] = FIGHT_STYLE_GRABKICK;
						businessVariables[business][bVault] += 12000;
						SendClientMessage(playerid, COLOR_WHITE, "You have successfully purchased this style of fighting.");
						SetPlayerFightingStyle(playerid, playerVariables[playerid][pFightStyle]);
					}
					else SendClientMessage(playerid, COLOR_GREY, "You do not have enough money to purchase this.");
				}
				else SendClientMessage(playerid, COLOR_GREY, "You are already using this style.");
			}
			case 4: {
				if(playerVariables[playerid][pFightStyle] != FIGHT_STYLE_ELBOW) {
					if(playerVariables[playerid][pMoney] >= 10000){

						new
							business = GetPlayerVirtualWorld(playerid) - BUSINESS_VIRTUAL_WORLD;

						playerVariables[playerid][pMoney] -= 10000;
						playerVariables[playerid][pFightStyle] = FIGHT_STYLE_ELBOW;
						businessVariables[business][bVault] += 10000;
						SendClientMessage(playerid, COLOR_WHITE, "You have successfully purchased this style of fighting.");
						SetPlayerFightingStyle(playerid, playerVariables[playerid][pFightStyle]);
					}
					else SendClientMessage(playerid, COLOR_GREY, "You do not have enough money to purchase this.");
				}
				else SendClientMessage(playerid, COLOR_GREY, "You are already using this style.");
			}
			case 5: {
				if(playerVariables[playerid][pFightStyle] != FIGHT_STYLE_NORMAL) {
					if(playerVariables[playerid][pMoney] >= 5000){

						new
							business = GetPlayerVirtualWorld(playerid) - BUSINESS_VIRTUAL_WORLD;

						playerVariables[playerid][pMoney] -= 5000;
						playerVariables[playerid][pFightStyle] = FIGHT_STYLE_NORMAL;
						businessVariables[business][bVault] += 5000;
						SendClientMessage(playerid, COLOR_WHITE, "You have successfully purchased this style of fighting.");
						SetPlayerFightingStyle(playerid, playerVariables[playerid][pFightStyle]);
					}
					else SendClientMessage(playerid, COLOR_GREY, "You do not have enough money to purchase this.");
				}
				else SendClientMessage(playerid, COLOR_GREY, "You are already using this style.");
			}
		}
		case DIALOG_ADMIN_PIN: {
			if(strlen(inputtext) != 4)
			    return ShowPlayerDialog(playerid, DIALOG_ADMIN_PIN, DIALOG_STYLE_INPUT, "SERVER: Admin authentication verification", "Incorrect PIN!\n\nPlease confirm your admin PIN to continue:", "OK", "Cancel");

			if(strval(inputtext) == GetPVarInt(playerid, "pAdminPIN")) {
			    DeletePVar(playerid, "pAdminFrozen");
			    SendClientMessage(playerid, COLOR_GENANNOUNCE, "SERVER:{FFFFFF} You've entered the correct PIN.");
			    SetPVarInt(playerid, "pAdminPINConfirmed", ADMIN_PIN_TIMEOUT);
			    
			    if(GetPVarType(playerid, "doCmd") != 0 || GetPVarType(playerid, "doCmdParams") != 0) {
			        new
			            szCommand[28],
			            szCommandParams[100];
			            
					GetPVarString(playerid, "doCmd", szCommand, sizeof(szCommand));
					GetPVarString(playerid, "doCmdParams", szCommandParams, sizeof(szCommandParams));
					
					for(new i = 0; i < strlen(szCommand); i++) {
						tolower(szCommand[i]);
					}
					
					format(szMessage, sizeof(szMessage), "cmd_%s", szCommand);
					CallLocalFunction(szMessage, "ds", playerid, szCommandParams);

					DeletePVar(playerid, "doCmd");
					DeletePVar(playerid, "doCmdParams");
			    }
			} else {
				SetPVarInt(playerid, "LA", GetPVarInt(playerid, "LA") + 1);

				if(GetPVarInt(playerid, "LA") > MAX_LOGIN_ATTEMPTS) {
					SendClientMessage(playerid, COLOR_RED, "You have used all available login attempts.");

					GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
					format(szMessage, sizeof(szMessage), "AdmWarn: {FFFFFF}Admin %s has been banned (%d failed 3 admin PIN attempts).", szPlayerName, MAX_LOGIN_ATTEMPTS);
					submitToAdmins(szMessage, COLOR_HOTORANGE);

					scriptBan(playerid, "Maximum admin PIN attempts exceeded.");
					return 1;
				}
			    else {
			    	ShowPlayerDialog(playerid, DIALOG_ADMIN_PIN, DIALOG_STYLE_INPUT, "SERVER: Admin authentication verification", "Incorrect PIN!\n\nThe system has recognised that you have connected with an IP that you've never used before.\n\nPlease confirm your admin PIN to continue:", "OK", "Cancel");
					format(szMessage, sizeof(szMessage), "Incorrect admin PIN. You have %d remaining login attempts left.", MAX_LOGIN_ATTEMPTS - GetPVarInt(playerid, "LA"));
					SendClientMessage(playerid, COLOR_HOTORANGE, szMessage);
					return 1;
				}
			}
		}
		case DIALOG_SELL_FISH: {
		    switch(response) {
				case 1: {
					switch(playerVariables[playerid][pFish]) {
					    case 0: {
					        playerVariables[playerid][pMoney] += 1000;
							SendClientMessage(playerid, COLOR_WHITE, "Congratulations, you have sold your collected fish for $1000.");
					    }
					    case 1: {
					        playerVariables[playerid][pMoney] += 750;
							SendClientMessage(playerid, COLOR_WHITE, "Congratulations, you have sold your collected fish for $750.");
					    }
					    case 2: {
					        playerVariables[playerid][pMoney] += 250;
							SendClientMessage(playerid, COLOR_WHITE, "Congratulations, you have sold your collected fish for $250.");
					    }
					    case 3: {
					        playerVariables[playerid][pMoney] += 900;
							SendClientMessage(playerid, COLOR_WHITE, "Congratulations, you have sold your collected fish for $900.");
					    }
					    case 4: {
					        playerVariables[playerid][pMoney] += 500;
							SendClientMessage(playerid, COLOR_WHITE, "Congratulations, you have sold your collected fish for $500.");
					    }
					}

					playerVariables[playerid][pFish] = -1;
				}
			}
		}
		case DIALOG_BUYCAR: if(response) switch(listitem) {
			case 0: ShowPlayerDialog(playerid, DIALOG_BUYCAR_CRAP, DIALOG_STYLE_LIST, "Vehicle Dealership (Second Hand)", "Blista Compact ($8,000)\nClover ($4,300)\nStallion ($5,700)\nTampa ($3,800)", "Select", "Cancel");
			case 1: ShowPlayerDialog(playerid, DIALOG_BUYCAR_CLASSIC, DIALOG_STYLE_LIST, "Vehicle Dealership (Classic Autos)", "Blade ($22,000)\nRemington ($28,000)\nSavanna ($30,000)\nSlamvan ($32,000)\nTornado ($24,500)\nOceanic ($16,200)\nBroadway ($32,750)", "Select", "Cancel");
			case 2: ShowPlayerDialog(playerid, DIALOG_BUYCAR_SEDAN, DIALOG_STYLE_LIST, "Vehicle Dealership (Sedans)", "Elegant ($34,000)\nPremier ($30,000)\nSentinel ($45,000)\nStretch ($85,000)\nSunrise ($33,000)\nWashington ($38,000)\nMerit ($37,500)\nStafford($135,200)", "Select", "Cancel");
			case 3: ShowPlayerDialog(playerid, DIALOG_BUYCAR_SUV, DIALOG_STYLE_LIST, "Vehicle Dealership (SUVs/Trucks)", "Huntley ($48,000)\nLandstalker ($37,000)\nMesa ($35,000)\nRancher ($43,000)\nSandking ($60,000)\nYosemite ($10,000)", "Select", "Cancel");
			case 4: ShowPlayerDialog(playerid, DIALOG_BUYCAR_BIKE, DIALOG_STYLE_LIST, "Vehicle Dealership (Motorcycles)", "Wayfarer ($15,000)\nFCR-900 ($20,000)\nPCJ-600 ($20,000)\nFreeway ($21,000)", "Select", "Cancel");
			case 5: ShowPlayerDialog(playerid, DIALOG_BUYCAR_MUSCLE, DIALOG_STYLE_LIST, "Vehicle Dealership (Performance Vehicles)", "Banshee ($120,000)\nBuffalo ($57,000)\nComet ($80,000)\nPhoenix ($90,000)\nSultan ($85,000)\nElegy ($54,000)\nAlpha ($51,000)", "Select", "Cancel");
		}
		case DIALOG_BUYCAR_BIKE: if(response) switch (listitem) {

			case 0: PurchaseVehicleFromDealer(playerid, 586, 15000);
			case 1: PurchaseVehicleFromDealer(playerid, 521, 20000);
			case 2: PurchaseVehicleFromDealer(playerid, 461, 20000);
			case 3: PurchaseVehicleFromDealer(playerid, 463, 21000);
		}
		case DIALOG_BUYCAR_CRAP: if(response) switch (listitem) {

			case 0: PurchaseVehicleFromDealer(playerid, 496, 8000);
			case 1: PurchaseVehicleFromDealer(playerid, 542, 4300);
			case 2: PurchaseVehicleFromDealer(playerid, 439, 5700);
			case 3: PurchaseVehicleFromDealer(playerid, 549, 3800);

		}
		case DIALOG_BUYCAR_CLASSIC: if(response) switch (listitem) {

			case 0: PurchaseVehicleFromDealer(playerid, 536, 22000);
			case 1: PurchaseVehicleFromDealer(playerid, 534, 28000);
			case 2: PurchaseVehicleFromDealer(playerid, 567, 30000);
			case 3: PurchaseVehicleFromDealer(playerid, 535, 32000);
			case 4: PurchaseVehicleFromDealer(playerid, 576, 24500);
			case 5: PurchaseVehicleFromDealer(playerid, 467, 16200);
			case 6: PurchaseVehicleFromDealer(playerid, 575, 32750);
		}
		case DIALOG_BUYCAR_SEDAN: if(response) switch(listitem) {

			case 0: PurchaseVehicleFromDealer(playerid, 507, 34000);
			case 1: PurchaseVehicleFromDealer(playerid, 426, 30000);
			case 2: PurchaseVehicleFromDealer(playerid, 405, 45000);
			case 3: PurchaseVehicleFromDealer(playerid, 409, 85000);
			case 4: PurchaseVehicleFromDealer(playerid, 550, 33000);
			case 5: PurchaseVehicleFromDealer(playerid, 421, 38000);
			case 6: PurchaseVehicleFromDealer(playerid, 551, 37000);
			case 7: PurchaseVehicleFromDealer(playerid, 580, 135200);
		}
		case DIALOG_BUYCAR_SUV: if(response) switch(listitem) {

			case 0: PurchaseVehicleFromDealer(playerid, 579, 48000);
			case 1: PurchaseVehicleFromDealer(playerid, 400, 37000);
			case 2: PurchaseVehicleFromDealer(playerid, 500, 35000);
			case 3: PurchaseVehicleFromDealer(playerid, 489, 43000);
			case 4: PurchaseVehicleFromDealer(playerid, 495, 60000);
			case 5: PurchaseVehicleFromDealer(playerid, 554, 10000);
		}
		case DIALOG_BUYCAR_MUSCLE: if(response) switch(listitem) {

			case 0: PurchaseVehicleFromDealer(playerid, 429, 120000);
			case 1: PurchaseVehicleFromDealer(playerid, 402, 57000);
			case 2: PurchaseVehicleFromDealer(playerid, 480, 80000);
			case 3: PurchaseVehicleFromDealer(playerid, 603, 90000);
			case 4: PurchaseVehicleFromDealer(playerid, 560, 85000);
			case 5: PurchaseVehicleFromDealer(playerid, 562, 54000);
			case 6: PurchaseVehicleFromDealer(playerid, 602, 51000);
		}
		case DIALOG_DROPITEM: if(response) {

			new
				string[78];
			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

			switch(listitem) {
				case 0: {

					format(string, sizeof(string), "* %s has dropped their materials.", szPlayerName);
					nearByMessage(playerid, COLOR_PURPLE, string);
					SendClientMessage(playerid, COLOR_WHITE, "You have dropped your materials.");

					playerVariables[playerid][pMaterials] = 0;
				}
				case 1: {
					format(string, sizeof(string), "* %s has dropped their phone.", szPlayerName);
					nearByMessage(playerid, COLOR_PURPLE, string);
					SendClientMessage(playerid, COLOR_WHITE, "You have dropped your phone.");

					playerVariables[playerid][pPhoneNumber] = -1;
				}
				case 2: {
					format(string, sizeof(string), "* %s has dropped their walkie talkie.", szPlayerName);
					nearByMessage(playerid, COLOR_PURPLE, string);
					SendClientMessage(playerid, COLOR_WHITE, "You have dropped your walkie talkie.");

					playerVariables[playerid][pWalkieTalkie] = -1;
				}
				case 3: {
					new
						weapon = GetPlayerWeapon(playerid);

					format(string, sizeof(string), "* %s has dropped their %s.", szPlayerName, WeaponNames[weapon]);
					nearByMessage(playerid, COLOR_PURPLE, string);

					format(string, sizeof(string), "You have dropped your %s.", WeaponNames[weapon]);
					SendClientMessage(playerid, COLOR_WHITE, string);

					removePlayerWeapon(playerid, weapon);
				}
			}
		}
		case DIALOG_ELEVATOR3: if(response) switch (listitem) {
			case 0: {
				SetPlayerPos(playerid, 1564.6584,-1670.2607,52.4503);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
			case 1: {
				SetPlayerPos(playerid, 1564.8, -1666.2, 28.3);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
			case 2: {
				SetPlayerPos(playerid, 1568.6676, -1689.9708, 6.2188);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
		}
		case DIALOG_ELEVATOR1: if(response) switch (listitem) {
			case 0: {
				SetPlayerPos(playerid, 1564.6584,-1670.2607,52.4503);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
			case 1: {
				SetPlayerPos(playerid, 276.0980, 122.1232, 1004.6172);
				SetPlayerInterior(playerid, 10);
				SetPlayerVirtualWorld(playerid, GROUP_VIRTUAL_WORLD+1);
			}
			case 2: {
				SetPlayerPos(playerid, 1568.6676, -1689.9708, 6.2188);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
		}
		case DIALOG_ELEVATOR2: if(response) switch (listitem) {
			case 0: {
				SetPlayerPos(playerid, 1564.6584,-1670.2607,52.4503);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
			case 1: {
				SetPlayerPos(playerid, 1564.8, -1666.2, 28.3);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
			case 2: {
				SetPlayerPos(playerid, 276.0980, 122.1232, 1004.6172);
				SetPlayerInterior(playerid, 10);
				SetPlayerVirtualWorld(playerid, GROUP_VIRTUAL_WORLD+1);
			}
		}
		case DIALOG_ELEVATOR4: if(response) switch (listitem) {
			case 0: {
				SetPlayerPos(playerid, 1564.8, -1666.2, 28.3);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
			case 1: {
				SetPlayerPos(playerid, 276.0980, 122.1232, 1004.6172);
				SetPlayerInterior(playerid, 10);
				SetPlayerVirtualWorld(playerid, GROUP_VIRTUAL_WORLD+1);
			}
			case 2: {
				SetPlayerPos(playerid, 1568.6676, -1689.9708, 6.2188);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
		}
		case DIALOG_GO6: {
		    if(response) switch(listitem) {
		        case 0: {
		            SetPlayerVirtualWorld(playerid, 0);
		            SetPlayerInterior(playerid, 5);
		            SetPlayerPos(playerid, 772.111999, -3.898649, 1000.728820);
		        }
		        case 1: {
           			SetPlayerVirtualWorld(playerid, 0);
		            SetPlayerInterior(playerid, 6);
		            SetPlayerPos(playerid, 774.213989, -48.924297, 1000.585937);
		        }
		        case 2: {
		            SetPlayerVirtualWorld(playerid, 0);
		            SetPlayerInterior(playerid, 7);
		            SetPlayerPos(playerid, 773.579956, -77.096694, 1000.655029);
		        }
		    }
		}
		case DIALOG_GO5: {
			if(response) switch(listitem) {
					case 0: {
					   	SetPlayerVirtualWorld(playerid, 0);
					    SetPlayerInterior(playerid, 10);
					    SetPlayerPos(playerid, -975.975708, 1060.983032, 1345.671875);
					}
					case 1: {
					   	SetPlayerVirtualWorld(playerid, 0);
					    SetPlayerInterior(playerid, 0);
						SetPlayerPos(playerid, 223.431976, 1872.400268, 13.734375);
					}
					case 2: {
						SetPlayerVirtualWorld(playerid, 0);
					    SetPlayerInterior(playerid, 1);
					    SetPlayerPos(playerid, 1412.639892, -1.787510, 1000.924377);
			     	}
					case 3: {
						SetPlayerVirtualWorld(playerid, 0);
					    SetPlayerInterior(playerid, 18);
					    SetPlayerPos(playerid, 1302.519897, -1.787510, 1001.028259);
					}
					case 4: {
						SetPlayerVirtualWorld(playerid, 0);
					    SetPlayerInterior(playerid, 1);
					    SetPlayerPos(playerid, 963.418762, 2108.292480, 1011.030273);
					}
					case 5: {
						SetPlayerVirtualWorld(playerid, 0);
					    SetPlayerInterior(playerid, 17);
					    SetPlayerPos(playerid, -959.564392, 1848.576782, 9.000000);
					}
				}
			}
			case DIALOG_GO4: {
			    if(response) switch(listitem) {
			        case 0: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 0);
			            SetPlayerPos(playerid, 595.5443,-1250.3405,18.2836);
			        }
			        case 1: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 0);
			            SetPlayerPos(playerid, 2222.6714, -1724.8436, 13.5625);
			        }
			        case 2: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 0);
			            SetPlayerPos(playerid, 1172.359985, -1323.313110, 15.402919);
			        }
			        case 3: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 0);
			            SetPlayerPos(playerid, 2034.196166, -1402.591430, 17.295030);
			        }
			        case 4: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 0);
			            SetPlayerPos(playerid, 738.9963, -1417.2211, 13.5234);
			        }
			    }
			}
			case DIALOG_GO3: {
			    if(response) switch(listitem) {
			        case 0: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 0);
			            SetPlayerPos(playerid, 1550.2311, -1675.4509, 15.3155);
			        }
			        case 1: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 0);
			            SetPlayerPos(playerid, -1641.9742, 431.1623, 7.1102);
			        }
			        case 2: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 0);
			            SetPlayerPos(playerid, 1699.2, 1435.1, 10.7);
			        }
			    }
			}
			case DIALOG_GO2: {
			    if(response) switch(listitem) {
			        case 0: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 4);
			            SetPlayerPos(playerid, -1444.645507, -664.526000, 1053.572998);
			        }
			        case 1: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 1);
			            SetPlayerPos(playerid, -1401.829956, 107.051300, 1032.273437);
			        }
			        case 2: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 15);
			            SetPlayerPos(playerid, -1398.103515, 937.631164, 1036.479125);
			        }
			        case 3: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 7);
			            SetPlayerPos(playerid, -1398.065307, -217.028900, 1051.115844);
			        }
			        case 4: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 14);
			            SetPlayerPos(playerid, -1465.268676, 1557.868286, 1052.531250);
			        }
			    }
			}
			case DIALOG_GO1: {
			    if(response) switch(listitem) {
			        case 0: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 5);
			            SetPlayerPos(playerid, 1267.663208, -781.323242, 1091.906250);
			        }
			        case 1: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 3);
			            SetPlayerPos(playerid, 2496.049804, -1695.238159, 1014.742187);
			        }
			        case 2: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 2);
			            SetPlayerPos(playerid, 2454.717041, -1700.871582, 1013.515197);
			        }
			        case 3: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 3);
			            SetPlayerPos(playerid, 964.106994, -53.205497, 1001.124572);
			        }
			        case 4: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 8);
			            SetPlayerPos(playerid, 2807.619873, -1171.899902, 1025.570312);
			        }
			        case 5: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 5);
			            SetPlayerPos(playerid, 318.564971, 1118.209960, 1083.882812);
			        }
			        case 6: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 1);
			            SetPlayerPos(playerid, 244.411987, 305.032989, 999.148437);
			        }
			        case 7: {
			            SetPlayerVirtualWorld(playerid, 0);
			            SetPlayerInterior(playerid, 2);
			            SetPlayerPos(playerid, 271.884979, 306.631988, 999.148437);
			        }
			    }
			}
			case DIALOG_GO: {
		        if(response) switch(listitem) {
		            case 0: ShowPlayerDialog(playerid, DIALOG_GO1, DIALOG_STYLE_LIST, "SERVER: House Interiors", "Madd Doggs'\nCJ's House\nRyder's House\nTiger Skin Brothel\nColonel Fuhrberger's\nCrack Den\nDenise's Room\nKatie's Room", "Select", "Cancel");
		            case 1: ShowPlayerDialog(playerid, DIALOG_GO2, DIALOG_STYLE_LIST, "SERVER: Race Tracks", "Dirt Track\nVice Stadium\nBloodbowl Stadium\n8-Track Stadium\nKickstart Stadium", "Select", "Cancel");
		            case 2: ShowPlayerDialog(playerid, DIALOG_GO3, DIALOG_STYLE_LIST, "SERVER: City Locations", "Los Santos\nSan Fierro\nLas Venturas", "Select", "Cancel");
		            case 3: ShowPlayerDialog(playerid, DIALOG_GO4, DIALOG_STYLE_LIST, "SERVER: Popular Locations", "Bank (exterior)\nGym (exterior)\nAll Saints Hospital\nCounty General Hospital\nNewbie Spawn\n", "Select", "Cancel");
		            case 4: ShowPlayerDialog(playerid, DIALOG_GO6, DIALOG_STYLE_LIST, "SERVER: Gym Interiors", "Ganton Gym (LS)\nCobra Martial Arts (SF)\nBelow the Belt Gym (LV)", "Select", "Cancel");
		            case 5: ShowPlayerDialog(playerid, DIALOG_GO5, DIALOG_STYLE_LIST, "SERVER: Other Locations", "RC Battlefield\nArea 69\nWarehouse 1\nWarehouse 2\nMeat Factory\nSherman Dam\n", "Select", "Cancel");
		        }
			}
			case DIALOG_HELP: {
				if(response) switch(listitem) {
					case 0: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: General Commands", "/stats /connections /pay /accept /drag /detain /eject /dropcar /killcheckpoint /give /eject /tie /helpme /ringbell /ad /seepms /kill \n/frisk /detain /admins /time /seeooc /seenewbie /giveweapon /givearmour /drop /joinevent /quitevent","Return","Exit");
					case 1: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Chat Commands", "/o (global OOC message)\r\n/n (newbie chat message)\n/pm (OOCly PM another player)r\n/b (local OOC message)\r\n/w(hisper)\r\n/low (quiet message)\r\n/me (action)\r\n/do (action)\r\n/wt (walkie talkie)","Return","Exit");
					case 2: {
						if(playerVariables[playerid][pGroup] == 0) return ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Group Commands", "You're not in a group.","Return","Exit");
						switch(groupVariables[playerVariables[playerid][pGroup]][gGroupType]) {
							case 0: switch(playerVariables[playerid][pGroupRank]) {
									case 5: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Group Commands", "/g /gdeposit /gwithdraw /showmotd /invite /uninvite /changerank /gwithdraw /gdeposit /gmotd /lockhq /listmygroup","Return","Exit");
									case 6: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Group Commands", "/g /gdeposit /gwithdraw /showmotd /invite /uninvite /changerank /gwithdraw /gdeposit /gmotd /lockhq /listmygroup \n/granknames /gname /gsafepos","Return","Exit");
									default: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Group Commands", "/g /gdeposit /showmotd","Return","Exit");
								}
							case 1: { // LSPD
								switch(playerVariables[playerid][pGroupRank]) {
									case 4: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Group Commands", "/r /d /m /su /wanted /fingerprint /ticket /cuff /uncuff /tazer /lspd /showmotd /gdeposit /backup /cancelbackup /acceptbackup /confiscate /deployspike /destroyspike\n/listmygroup /swatinv /spikes","Return","Exit");
									case 5: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Group Commands", "/r /d /m /su /wanted /fingerprint /ticket /cuff /uncuff /tazer /lspd /showmotd /gdeposit /backup /cancelbackup /acceptbackup /confiscate /deployspike /destroyspike\n/gwithdraw /listmygroup /swatinv /spikes /invite /uninvite /changerank /gwithdraw /gmotd /lockhq /gov","Return","Exit");
									case 6: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Group Commands", "/r /d /m /su /wanted /fingerprint /ticket /cuff /uncuff /tazer /lspd /showmotd /gdeposit /backup /cancelbackup /acceptbackup /confiscate /deployspike /destroyspike\n/gwithdraw /listmygroup /swatinv /spikes /invite /uninvite /changerank /gwithdraw /gmotd /lockhq /gov /granknames /gname /gsafepos","Return","Exit");
									default: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Group Commands", "/r /d /m /su /wanted /fingerprint /ticket /cuff /uncuff /tazer /lspd /showmotd /gdeposit /backup /cancelbackup /acceptbackup /confiscate /deployspike /destroyspike","Return","Exit");
								}
							}
							case 2: { // GOVERNMENT
								switch(playerVariables[playerid][pGroupRank]) {
									case 6: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Group Commands", "/r /d /showmotd /gdeposit /gwithdraw /listmygroup /invite /uninvite /changerank /gmotd /granknames /gname /lockhq /taxrate /gsafepos","Return","Exit");
								}
							}
						}
					}
					case 3: {
						ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Animation Commands",
						"\
						/handsup /drunk /bomb /rob /laugh /lookout /robman /crossarms /sit /siteat /hide /vomit /eat\n\
						/wave /slapass /deal /taichi /crack /smoke /chat /dance /finger /taichi /drinkwater /pedmove /bat\n\
						/checktime /sleep /blob /opendoor /wavedown /reload /cpr /dive /showoff /box /tag /salute\n\
						/goggles /cry /dj /cheer /throw /robbed /hurt /nobreath /bar /getjiggy /fallover /rap /piss\n\
						/crabs /handwash /signal /stop /gesture /masturbate","Return","Exit");
					}
					case 4: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: House Commands", "/home /buyhouse /sellhouse /lockhouse /hgetweapon /hstoreweapon /hwithdraw /hdeposit /changeclothes", "Return","Exit");
					case 5: switch(jobVariables[playerVariables[playerid][pJob]][jJobType]) {
						case 1: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Job Commands (Arms Dealer)", "/creategun /giveweapon /getmats","Return","Exit");
						case 2: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Job Commands (Detective)", "/track /trackcar /trackplates /trackhouse /trackbusiness","Return","Exit");
						case 3: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Job Commands (Mechanic)", "/fixcar /noscar /colourcar /hydcar","Return","Exit");
						case 4: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Job Commands (Fisherman)", "/fish","Return","Exit");
						default: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Job Commands", "You don't have a public job.","Return","Exit");
					}
					case 6: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Business Commands", "/business /lockbusiness /buybusiness /bwithdraw /businessname /bbalance /buy /sellbusiness /bspawnpos", "Return","Exit");
					case 7: {
					    if(playerVariables[playerid][pHelper] >= 1) ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Helper Commands", "/he /nmute /helperduty /accepthelp /viewhelp", "Return","Exit");
						else SendClientMessage(playerid, COLOR_GREY, "You aren't an official helper.");
					}
					case 8: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Vehicle Commands", "/findcar /abandoncar /lockcar /givecar /unmodcar /vbalance /vstoreweapon /vgetweapon /vdeposit /vwithdraw", "Return","Exit");
					case 9: ShowPlayerDialog(playerid, DIALOG_HELP2, DIALOG_STYLE_MSGBOX, "SERVER: Bank Commands", "/wiretransfer /deposit /balance /withdraw", "Return","Exit");
				}
			}
			case DIALOG_GENDER_SELECTION: {
				switch(response) {
					case 1: {
						SendClientMessage(playerid, COLOR_YELLOW, "Great. We now know that you're a man.");
						playerVariables[playerid][pGender] = 1;
						playerVariables[playerid][pTutorial] = 3;
					}
					case 0: {
					    SendClientMessage(playerid, COLOR_YELLOW, "Great. We now know that you're a woman.");
					    playerVariables[playerid][pGender] = 2;
					    playerVariables[playerid][pTutorial] = 3;
					}
				}

				ShowPlayerDialog(playerid, DIALOG_TUTORIAL_DOB, DIALOG_STYLE_INPUT, "SERVER: Character Age", "Please enter the age of your character.", "Proceed", "Cancel");
			}
			case DIALOG_SEX_SHOP: {
			    if(!response)
					return 1;

				listitem += 1;

			    new
			        i,
			        b,
			        businessID = GetPlayerVirtualWorld(playerid)-BUSINESS_VIRTUAL_WORLD;

		        for(new x = 0; x < MAX_BUSINESS_ITEMS; x++) {
		            b++;
		            format(szSmallString, sizeof(szSmallString), "menuItem%d", x);
		            if(GetPVarType(playerid, szSmallString) != 0)
		                i = GetPVarInt(playerid, szSmallString);

					if(b == listitem) {
					    for(new xf = 0; xf < MAX_BUSINESS_ITEMS; xf++) {
				            format(szSmallString, sizeof(szSmallString), "menuItem%d", xf);
				            if(GetPVarType(playerid, szSmallString) != 0)
				                DeletePVar(playerid, szSmallString);
							else
							    break;
					    }

					    break;
					}
				}

                switch(businessItems[i][bItemType]) {
	                case 9: {
						if(playerVariables[playerid][pMoney] >= businessItems[i][bItemPrice]) {
							playerVariables[playerid][pMoney] -= businessItems[i][bItemPrice];
	                        businessVariables[businessID][bVault] += businessItems[i][bItemPrice];

							givePlayerValidWeapon(playerid, 10);

							switch(random(4)) {
								case 0: format(szMessage, sizeof(szMessage), "You've purchased the %s. Don't get too wild.", businessItems[i][bItemName]);
								case 1: format(szMessage, sizeof(szMessage), "You've purchased the %s. Don't blame us if you get it stuck up there!", businessItems[i][bItemName]);
								case 2: format(szMessage, sizeof(szMessage), "You've purchased the %s. There's no warranty for this product!", businessItems[i][bItemName]);
								case 3: format(szMessage, sizeof(szMessage), "You've purchased the %s. Justin Bieber approves of this.", businessItems[i][bItemName]);
							}
							
                            SendClientMessage(playerid, COLOR_WHITE, szMessage);
                            return 1;
	                    } else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this product.");
					}
	                case 10: {
						if(playerVariables[playerid][pMoney] >= businessItems[i][bItemPrice]) {
							playerVariables[playerid][pMoney] -= businessItems[i][bItemPrice];
	                        businessVariables[businessID][bVault] += businessItems[i][bItemPrice];

							givePlayerValidWeapon(playerid, 11);

							switch(random(4)) {
								case 0: format(szMessage, sizeof(szMessage), "You've purchased the %s. Don't get too wild.", businessItems[i][bItemName]);
								case 1: format(szMessage, sizeof(szMessage), "You've purchased the %s. Don't blame us if you get it stuck up there!", businessItems[i][bItemName]);
								case 2: format(szMessage, sizeof(szMessage), "You've purchased the %s. There's no warranty for this product!", businessItems[i][bItemName]);
								case 3: format(szMessage, sizeof(szMessage), "You've purchased the %s. Justin Bieber approves of this.", businessItems[i][bItemName]);
							}

                            SendClientMessage(playerid, COLOR_WHITE, szMessage);
                            return 1;
	                    } else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this product.");
					}
	                case 11: {
						if(playerVariables[playerid][pMoney] >= businessItems[i][bItemPrice]) {
							playerVariables[playerid][pMoney] -= businessItems[i][bItemPrice];
	                        businessVariables[businessID][bVault] += businessItems[i][bItemPrice];

							givePlayerValidWeapon(playerid, 12);

							switch(random(4)) {
								case 0: format(szMessage, sizeof(szMessage), "You've purchased the %s. Don't get too wild.", businessItems[i][bItemName]);
								case 1: format(szMessage, sizeof(szMessage), "You've purchased the %s. Don't blame us if you get it stuck up there!", businessItems[i][bItemName]);
								case 2: format(szMessage, sizeof(szMessage), "You've purchased the %s. There's no warranty for this product!", businessItems[i][bItemName]);
								case 3: format(szMessage, sizeof(szMessage), "You've purchased the %s. Justin Bieber approves of this.", businessItems[i][bItemName]);
							}

                            SendClientMessage(playerid, COLOR_WHITE, szMessage);
                            return 1;
	                    } else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this product.");
					}
	                case 12: {
						if(playerVariables[playerid][pMoney] >= businessItems[i][bItemPrice]) {
							playerVariables[playerid][pMoney] -= businessItems[i][bItemPrice];
	                        businessVariables[businessID][bVault] += businessItems[i][bItemPrice];

							givePlayerValidWeapon(playerid, 13);

							switch(random(4)) {
								case 0: format(szMessage, sizeof(szMessage), "You've purchased the %s. Don't get too wild.", businessItems[i][bItemName]);
								case 1: format(szMessage, sizeof(szMessage), "You've purchased the %s. Don't blame us if you get it stuck up there!", businessItems[i][bItemName]);
								case 2: format(szMessage, sizeof(szMessage), "You've purchased the %s. There's no warranty for this product!", businessItems[i][bItemName]);
								case 3: format(szMessage, sizeof(szMessage), "You've purchased the %s. Justin Bieber approves of this.", businessItems[i][bItemName]);
							}

                            SendClientMessage(playerid, COLOR_WHITE, szMessage);
                            return 1;
	                    } else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this product.");
					}
	                case 13: {
						if(playerVariables[playerid][pMoney] >= businessItems[i][bItemPrice]) {
							playerVariables[playerid][pMoney] -= businessItems[i][bItemPrice];
	                        businessVariables[businessID][bVault] += businessItems[i][bItemPrice];

							givePlayerValidWeapon(playerid, 14);

							switch(random(4)) {
								case 0: format(szMessage, sizeof(szMessage), "You've purchased the %s. Don't get too wild.", businessItems[i][bItemName]);
								case 1: format(szMessage, sizeof(szMessage), "You've purchased the %s. Don't blame us if you get it stuck up there!", businessItems[i][bItemName]);
								case 2: format(szMessage, sizeof(szMessage), "You've purchased the %s. There's no warranty for this product!", businessItems[i][bItemName]);
								case 3: format(szMessage, sizeof(szMessage), "You've purchased the %s. Justin Bieber approves of this.", businessItems[i][bItemName]);
							}

                            SendClientMessage(playerid, COLOR_WHITE, szMessage);
                            return 1;
	                    } else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this product.");
					}
				}
            }
			case DIALOG_FOOD: {
			    if(!response)
					return 1;

				listitem += 1;

			    new
			        i,
			        b,
			        businessID = GetPlayerVirtualWorld(playerid)-BUSINESS_VIRTUAL_WORLD;

		        for(new x = 0; x < MAX_BUSINESS_ITEMS; x++) {
		            b++;
		            format(szSmallString, sizeof(szSmallString), "menuItem%d", x);
		            if(GetPVarType(playerid, szSmallString) != 0)
		                i = GetPVarInt(playerid, szSmallString);

					if(b == listitem) {
					    for(new xf = 0; xf < MAX_BUSINESS_ITEMS; xf++) {
				            format(szSmallString, sizeof(szSmallString), "menuItem%d", xf);
				            if(GetPVarType(playerid, szSmallString) != 0)
				                DeletePVar(playerid, szSmallString);
							else
							    break;
					    }

					    break;
					}
				}

                switch(businessItems[i][bItemType]) {
	                case 6: {
						if(playerVariables[playerid][pMoney] >= businessItems[i][bItemPrice]) {
						    GetPlayerHealth(playerid, playerVariables[playerid][pHealth]);
						    
							if(playerVariables[playerid][pHealth] > 95.0)
								return SendClientMessage(playerid, COLOR_GREY, "You are unable to consume this product.");

							playerVariables[playerid][pMoney] -= businessItems[i][bItemPrice];
	                        businessVariables[businessID][bVault] += businessItems[i][bItemPrice];

							SetPlayerHealth(playerid, playerVariables[playerid][pHealth]+5);

							format(szMessage, sizeof(szMessage), "You've purchased and consumed the %s, which has increased your health by 5 percent.", businessItems[i][bItemName]);
                            SendClientMessage(playerid, COLOR_WHITE, szMessage);
                            return 1;
	                    } else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this product.");
					}
					case 7: {
						if(playerVariables[playerid][pMoney] >= businessItems[i][bItemPrice]) {
						    GetPlayerHealth(playerid, playerVariables[playerid][pHealth]);

							if(playerVariables[playerid][pHealth] > 90.0)
								return SendClientMessage(playerid, COLOR_GREY, "You are unable to consume this product.");

							playerVariables[playerid][pMoney] -= businessItems[i][bItemPrice];
	                        businessVariables[businessID][bVault] += businessItems[i][bItemPrice];

							SetPlayerHealth(playerid, playerVariables[playerid][pHealth]+10);

							format(szMessage, sizeof(szMessage), "You've purchased and consumed the %s, which has increased your health by 10 percent.", businessItems[i][bItemName]);
                            SendClientMessage(playerid, COLOR_WHITE, szMessage);
                            return 1;
	                    } else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this product.");
					}
					case 8: {
						if(playerVariables[playerid][pMoney] >= businessItems[i][bItemPrice]) {
						    GetPlayerHealth(playerid, playerVariables[playerid][pHealth]);

							if(playerVariables[playerid][pHealth] > 70.0)
								return SendClientMessage(playerid, COLOR_GREY, "You are unable to consume this product.");

							playerVariables[playerid][pMoney] -= businessItems[i][bItemPrice];
	                        businessVariables[businessID][bVault] += businessItems[i][bItemPrice];

							SetPlayerHealth(playerid, playerVariables[playerid][pHealth]+30);

							format(szMessage, sizeof(szMessage), "You've purchased and consumed the %s, which has increased your health by 30 percent.", businessItems[i][bItemName]);
                            SendClientMessage(playerid, COLOR_WHITE, szMessage);
                            return 1;
	                    } else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this product.");
					}
				}
            }
			case DIALOG_TWENTYFOURSEVEN: {
			    if(!response)
					return 1;
					
				listitem += 1;

			    new
			        i,
			        b,
			        businessID = GetPlayerVirtualWorld(playerid)-BUSINESS_VIRTUAL_WORLD;
			        
		        for(new x = 0; x < MAX_BUSINESS_ITEMS; x++) {
		            b++;
		            format(szSmallString, sizeof(szSmallString), "menuItem%d", x);
		            if(GetPVarType(playerid, szSmallString) != 0)
		                i = GetPVarInt(playerid, szSmallString);

					if(b == listitem) {
					    for(new xf = 0; xf < MAX_BUSINESS_ITEMS; xf++) {
				            format(szSmallString, sizeof(szSmallString), "menuItem%d", xf);
				            if(GetPVarType(playerid, szSmallString) != 0)
				                DeletePVar(playerid, szSmallString);
							else
							    break;
					    }
					    
					    break;
					}
				}
				
                switch(businessItems[i][bItemType]) {
	                case 1: {
						if(playerVariables[playerid][pMoney] >= businessItems[i][bItemPrice]) {
							if(playerVariables[playerid][pRope] >= 30)
								return SendClientMessage(playerid, COLOR_GREY, "You are unable to purchase any more rope.");

							playerVariables[playerid][pMoney] -= businessItems[i][bItemPrice];
		                            	
	                        businessVariables[businessID][bVault] += businessItems[i][bItemPrice];
	                        playerVariables[playerid][pRope]++;

                            SendClientMessage(playerid, COLOR_WHITE, "You have purchased 1 line of Rope!");
                            return 1;
	                    } else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this product.");
					}
					case 2: {
	    				if(playerVariables[playerid][pMoney] >= businessItems[i][bItemPrice]) {
							if(playerVariables[playerid][pWalkieTalkie] != -1)
							    return SendClientMessage(playerid, COLOR_GREY, "You are unable to purchase another walkie talkie.");

							playerVariables[playerid][pMoney] -= businessItems[i][bItemPrice];
							businessVariables[businessID][bVault] += businessItems[i][bItemPrice];
							playerVariables[playerid][pWalkieTalkie] = 0;

							SendClientMessage(playerid, COLOR_WHITE, "You have purchased a walkie talkie - use /setfrequency to tune it, and /wt to speak.");
							return 1;
						} else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this product.");
					}
					case 3: {
						if(playerVariables[playerid][pMoney] >= businessItems[i][bItemPrice]) {
							if(playerVariables[playerid][pPhoneBook] != 1)
							    return SendClientMessage(playerid, COLOR_GREY, "You are unable to purchase another phonebook.");

							playerVariables[playerid][pMoney] -= businessItems[i][bItemPrice];
							businessVariables[businessID][bVault] += businessItems[i][bItemPrice];
							playerVariables[playerid][pPhoneBook] = 1;

							SendClientMessage(playerid, COLOR_WHITE, "You have purchased a phonebook. Use /number to trace a number down!");
							return 1;
						} else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this product.");
					}
					case 4: {
						if(playerVariables[playerid][pPhoneNumber] == -1)
						    return SendClientMessage(playerid, COLOR_GREY, "You do not have a phone.");

	                    if(playerVariables[playerid][pMoney] >= businessItems[i][bItemPrice]) {
							playerVariables[playerid][pMoney] -= businessItems[i][bItemPrice];
							businessVariables[businessID][bVault] += businessItems[i][bItemPrice];
							playerVariables[playerid][pPhoneCredit] += businessItems[i][bItemPrice]*60;

							format(szMessage, sizeof(szMessage), "You have purchased a $%d credit voucher for your mobile phone which has been automatically applied.", businessItems[i][bItemPrice]);
							SendClientMessage(playerid, COLOR_WHITE, szMessage);
							return 1;
						} else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this product.");
					}
					case 5: {
						if(playerVariables[playerid][pPhoneNumber] != -1)
						    SendClientMessage(playerid, COLOR_GREY, "You already had a phone, your phone will be replaced and your number will be changed.");

	                    if(playerVariables[playerid][pMoney] >= businessItems[i][bItemPrice]) {
							playerVariables[playerid][pMoney] -= businessItems[i][bItemPrice];
							businessVariables[businessID][bVault] += businessItems[i][bItemPrice];
					        playerVariables[playerid][pPhoneNumber] = random(89999999)+10000000; // Random eight digit phone number (which won't get crazy ones like 0, etc)

							format(szMessage, sizeof(szMessage), "You have purchased a %s! Your number is %d.", businessItems[i][bItemName], playerVariables[playerid][pPhoneNumber]);
						    SendClientMessage(playerid, COLOR_WHITE, szMessage);
							return 1;
						} else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this product.");
					}
				}
            }
			case DIALOG_REPORT: if(response) {
				switch(listitem) {
					case 0: {
					    new
					        Float: playerPosC[3];

					    GetPlayerPos(GetPVarInt(playerid, "aRf"), playerPosC[0],  playerPosC[1],  playerPosC[2]);
					    SetPlayerPos(playerid, playerPosC[0], playerPosC[1], playerPosC[2]);

					    DeletePVar(playerid, "aR");
					    DeletePVar(playerid, "aRf");
					}
					case 1: {
						if(playerVariables[playerid][pSpectating] == INVALID_PLAYER_ID) {
							GetPlayerPos(playerid, playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2]);
							playerVariables[playerid][pInterior] = GetPlayerInterior(playerid);
							playerVariables[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
							playerVariables[playerid][pSkin] = GetPlayerSkin(playerid);
						}

					    playerVariables[playerid][pSpectating] = GetPVarInt(playerid, "aRf");
					    TogglePlayerSpectating(playerid, true);

					    if(IsPlayerInAnyVehicle(GetPVarInt(playerid, "aRf"))) {
					        PlayerSpectateVehicle(playerid, GetPlayerVehicleID(GetPVarInt(playerid, "aRf")));
					    }
					    else {
							PlayerSpectatePlayer(playerid, GetPVarInt(playerid, "aRf"));
						}

						TextDrawShowForPlayer(playerid, textdrawVariables[4]);

					    DeletePVar(playerid, "aR");
					    DeletePVar(playerid, "aRf");
					}
				}
			}
			case DIALOG_TUTORIAL_DOB: {
				if(isnull(inputtext)) {
				    return ShowPlayerDialog(playerid, DIALOG_TUTORIAL_DOB, DIALOG_STYLE_INPUT, "SERVER: Character Age", "Please enter the age of your character.", "Proceed", "Cancel");
				}
				else {
					new
					    Age = strval(inputtext);

					if(Age >= 16 && Age < 122) {
					    new
							date[3];

						getdate(date[0], date[1], date[2]);

						playerVariables[playerid][pAge] = date[0] - Age;
					    format(szMessage, sizeof(szMessage), "You have set your character's age to %d (born in %d).", Age, playerVariables[playerid][pAge]);
						SendClientMessage(playerid, COLOR_YELLOW, szMessage);

						if(GetPVarInt(playerid, "quiz") == 1) {
							ShowPlayerDialog(playerid, DIALOG_TUTORIAL_CHOICE, DIALOG_STYLE_MSGBOX, "SERVER: Tutorial", "Do you wish to participate in our server tutorial? This is optional for you and will only take a few minutes.","Yes","No");
						} else {
							playerVariables[playerid][pTutorial] = 4;
							TextDrawShowForPlayer(playerid, textdrawVariables[3]);
							SendClientMessage(playerid, COLOR_WHITE, "You're now participating in our mandatory server tutorial. Please pay close attention to the screen. ");
							SendClientMessage(playerid, COLOR_WHITE, "Please press your RIGHT arrow to proceed through the tutorial.");
						}
					}
					else {
					    SendClientMessage(playerid, COLOR_WHITE, "Your character must be older than 16, and can't be older than 122 years old.");
						return ShowPlayerDialog(playerid, DIALOG_TUTORIAL_DOB, DIALOG_STYLE_INPUT, "SERVER: Character Age", "Please enter the age of your character.", "Proceed", "Cancel");
					}
				}
			}
			case DIALOG_TUTORIAL_CHOICE: {
			    if(!response) {
					SendClientMessage(playerid, COLOR_YELLOW, "Conclusion");
					SendClientMessage(playerid, COLOR_WHITE, "Your character will now spawn. Welcome to the server!");
					SendClientMessage(playerid, COLOR_WHITE, "If you have any questions or concerns which relate to gameplay on our server, please use "EMBED_GREY"/n"EMBED_WHITE".");
                    SendClientMessage(playerid, COLOR_WHITE, "If you wish to obtain help from an official member of staff, please use "EMBED_GREY"/helpme"EMBED_WHITE".");
                    SendClientMessage(playerid, COLOR_WHITE, "If you see any players breaking rules, please use "EMBED_GREY"/report"EMBED_WHITE".");

                    format(szMessage, sizeof(szMessage), "Last, but not least, please make sure that you register on our community forums: "EMBED_GREY"%s"EMBED_WHITE".", szServerWebsite);
                 	SendClientMessage(playerid, COLOR_WHITE, szMessage);
                 	
			        firstPlayerSpawn(playerid);
			    } else {
					playerVariables[playerid][pTutorial] = 4;
					TextDrawShowForPlayer(playerid, textdrawVariables[3]);
					SendClientMessage(playerid, COLOR_WHITE, "You're now participating in our mandatory server tutorial. Please pay close attention to the screen. ");
					SendClientMessage(playerid, COLOR_WHITE, "Please press your RIGHT arrow to proceed through the tutorial.");
				}
			}
			case DIALOG_HELP2: {
				if(response) return showHelp(playerid);
			}
			case DIALOG_BAR: { 
			    if(!response)
					return 1;

				listitem += 1;

			    new
			        i,
			        b,
			        businessID = GetPlayerVirtualWorld(playerid)-BUSINESS_VIRTUAL_WORLD;

		        for(new x = 0; x < MAX_BUSINESS_ITEMS; x++) {
		            b++;
		            format(szSmallString, sizeof(szSmallString), "menuItem%d", x);
		            if(GetPVarType(playerid, szSmallString) != 0)
		                i = GetPVarInt(playerid, szSmallString);

					if(b == listitem) {
					    for(new xf = 0; xf < MAX_BUSINESS_ITEMS; xf++) {
				            format(szSmallString, sizeof(szSmallString), "menuItem%d", xf);
				            if(GetPVarType(playerid, szSmallString) != 0)
				                DeletePVar(playerid, szSmallString);
							else
							    break;
					    }

					    break;
					}
				}

                switch(businessItems[i][bItemType]) {
	                case 14: {
						if(playerVariables[playerid][pMoney] >= businessItems[i][bItemPrice]) {
							playerVariables[playerid][pMoney] -= businessItems[i][bItemPrice];
	                        businessVariables[businessID][bVault] += businessItems[i][bItemPrice];

							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);

							format(szMessage, sizeof(szMessage), "You've purchased %s.", businessItems[i][bItemName]);
                            SendClientMessage(playerid, COLOR_WHITE, szMessage);
                            return 1;
	                    } else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this product.");
					}
	                case 15: {
						if(playerVariables[playerid][pMoney] >= businessItems[i][bItemPrice]) {
							playerVariables[playerid][pMoney] -= businessItems[i][bItemPrice];
	                        businessVariables[businessID][bVault] += businessItems[i][bItemPrice];

							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);

							format(szMessage, sizeof(szMessage), "You've purchased %s.", businessItems[i][bItemName]);
                            SendClientMessage(playerid, COLOR_WHITE, szMessage);
                            return 1;
	                    } else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this product.");
					}
	                case 16: {
						if(playerVariables[playerid][pMoney] >= businessItems[i][bItemPrice]) {
							playerVariables[playerid][pMoney] -= businessItems[i][bItemPrice];
	                        businessVariables[businessID][bVault] += businessItems[i][bItemPrice];

							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_BEER);

							format(szMessage, sizeof(szMessage), "You've purchased %s.", businessItems[i][bItemName]);
                            SendClientMessage(playerid, COLOR_WHITE, szMessage);
                            return 1;
	                    } else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this product.");
					}
	                case 17: {
						if(playerVariables[playerid][pMoney] >= businessItems[i][bItemPrice]) {
							playerVariables[playerid][pMoney] -= businessItems[i][bItemPrice];
	                        businessVariables[businessID][bVault] += businessItems[i][bItemPrice];

							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_WINE);

							format(szMessage, sizeof(szMessage), "You've purchased %s.", businessItems[i][bItemName]);
                            SendClientMessage(playerid, COLOR_WHITE, szMessage);
                            return 1;
	                    } else return SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this product.");
					}
				}
			}
		    case DIALOG_LSPD_CLOTHING: {
		        if(response) switch(listitem) {
				    case 0: ShowPlayerDialog(playerid, DIALOG_LSPD_CLOTHING_OFFICIAL, DIALOG_STYLE_LIST, "Official Clothing", "Probationary Officer\nPatrol/Specialist Officer\nTRU Patrol\nMotorcycle/Aircraft\nAfrican American\nOverweight\nHispanic\nTactical Gear\nSergeant\nCommander\nChief", "Select", "Cancel");
				    case 1: ShowPlayerDialog(playerid, DIALOG_LSPD_CLOTHING_CUSTOM, DIALOG_STYLE_INPUT, "Custom Selection", "Enter a skin ID you wish to use.", "Select", "Cancel");
				}
		    }
		    case DIALOG_LSPD_CLOTHING_OFFICIAL: {
		        if(response) switch(listitem) {
		            case 0: {
				        SetPlayerSkin(playerid, 71);
				        playerVariables[playerid][pSkin] = 71;
		            }
		            case 1: {
				        SetPlayerSkin(playerid, 280);
				        playerVariables[playerid][pSkin] = 280;
		            }
		            case 2: {
				        SetPlayerSkin(playerid, 281);
				        playerVariables[playerid][pSkin] = 281;
		            }
		            case 3: {
				        SetPlayerSkin(playerid, 284);
				        playerVariables[playerid][pSkin] = 284;
		            }
		            case 4: {
				        SetPlayerSkin(playerid, 265);
				        playerVariables[playerid][pSkin] = 265;
		            }
		            case 5: {
				        SetPlayerSkin(playerid, 266);
				        playerVariables[playerid][pSkin] = 266;
		            }
		            case 6: {
				        SetPlayerSkin(playerid, 267);
				        playerVariables[playerid][pSkin] = 267;
		            }
		            case 7: {
				        SetPlayerSkin(playerid, 285);
				        playerVariables[playerid][pSkin] = 285;
		            }
		            case 8: {
		                if(playerVariables[playerid][pGroupRank] < 4) return SendClientMessage(playerid, COLOR_WHITE, "You're not a sergeant.");
				        SetPlayerSkin(playerid, 282);
				        playerVariables[playerid][pSkin] = 282;
		            }
		            case 9: {
		                if(playerVariables[playerid][pGroupRank] < 5) return SendClientMessage(playerid, COLOR_WHITE, "You're not a commander.");
				        SetPlayerSkin(playerid, 283);
				        playerVariables[playerid][pSkin] = 283;
		            }
		            case 10: {
		                if(playerVariables[playerid][pGroupRank] < 6) return SendClientMessage(playerid, COLOR_WHITE, "You're not the Chief of Police.");
				        SetPlayerSkin(playerid, 288);
				        playerVariables[playerid][pSkin] = 288;
		            }
		        }
		    }
		    case DIALOG_LSPD_CLOTHING_CUSTOM: {
				if(!response) return 1;
		        new skin;
		        if(sscanf(inputtext,"d",skin)) return ShowPlayerDialog(playerid, DIALOG_LSPD_CLOTHING_CUSTOM, DIALOG_STYLE_INPUT, "Custom Selection", "Invalid skin.\r\nEnter a skin ID you wish to use.", "Select", "Cancel"); {
					if(!IsValidSkin(skin)) return ShowPlayerDialog(playerid, DIALOG_LSPD_CLOTHING_CUSTOM, DIALOG_STYLE_INPUT, "Custom Selection", "Invalid skin.\r\nEnter a skin ID you wish to use.", "Select", "Cancel");
					switch(skin) {
					    case 282, 283, 286, 288: return ShowPlayerDialog(playerid, DIALOG_LSPD_CLOTHING_CUSTOM, DIALOG_STYLE_INPUT, "Custom Selection", "Invalid skin.\r\nEnter a skin ID you wish to use.", "Select", "Cancel");
						default: {
					        SetPlayerSkin(playerid, skin);
					        playerVariables[playerid][pSkin] = skin;
						}
					}
				}
		    }

		    case DIALOG_LSPD_RELEASE: {

		        new id;
            	if(sscanf(inputtext,"u",id)) {
            	    SendClientMessage(playerid, COLOR_GREY, "Invalid name specified (use a proper player name or ID).");
            	}
				else {
				    if(IsPlayerAuthed(id)) {
            			if(playerVariables[id][pPrisonTime] > 0 && playerVariables[id][pPrisonID] == 3) {
				            new
								Rstring[58],
								playerNames[2][MAX_PLAYER_NAME];

							playerVariables[id][pPrisonID] = 0;
							playerVariables[id][pPrisonTime] = 0;
							SetPlayerPos(id, 738.9963, -1417.2211, 13.5234);
							SetPlayerInterior(id, 0);
							SetPlayerVirtualWorld(id, 0);


							GetPlayerName(playerid, playerNames[0], MAX_PLAYER_NAME);
							GetPlayerName(id, playerNames[1], MAX_PLAYER_NAME);

							switch(playerVariables[playerid][pGroupRank]) {
								case 5:	format(Rstring, sizeof(Rstring), "Dispatch: %s %s has released %s from detainment.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName5], playerNames[0], playerNames[1]);
								case 6:	format(Rstring, sizeof(Rstring), "Dispatch: %s %s has released %s from detainment.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName6], playerNames[0], playerNames[1]);
							}
							SendToGroup(playerVariables[playerid][pGroup], COLOR_RADIOCHAT, Rstring);

							switch(playerVariables[playerid][pGroupRank]) {
								case 5:	format(Rstring, sizeof(Rstring), "%s %s has released you from jail.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName5], playerNames[0]);
								case 6:	format(Rstring, sizeof(Rstring), "%s %s has released you from jail.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName6], playerNames[0]);
							}
				            SendClientMessage(id, COLOR_WHITE, Rstring);

							format(Rstring, sizeof(Rstring), "You have successfully released %s from jail.", playerNames[1]);
							SendClientMessage(playerid, COLOR_WHITE, Rstring);
				        }
				        else {
				            SendClientMessage(playerid, COLOR_WHITE, "That player is not jailed (in character).");
				        }
				    }
				}
			}

		    case DIALOG_LSPD_CLEAR: {

		        new
					warrantid;

            	if(sscanf(inputtext,"u",warrantid))
					return SendClientMessage(playerid, COLOR_GREY, "Invalid name specified (use a proper player name or ID).");

				else if(IsPlayerAuthed(warrantid)) {
					new
						WarrantplayerNames[2][MAX_PLAYER_NAME];

					GetPlayerName(playerid, WarrantplayerNames[0], MAX_PLAYER_NAME);
					GetPlayerName(warrantid, WarrantplayerNames[1], MAX_PLAYER_NAME);

					switch(playerVariables[playerid][pGroupRank]) {
						case 5:	format(szMessage, sizeof(szMessage), "Dispatch: %s %s has cleared all warrants on %s.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName5], WarrantplayerNames[0], WarrantplayerNames[1]);
						case 6:	format(szMessage, sizeof(szMessage), "Dispatch: %s %s has cleared all warrants on %s.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName6], WarrantplayerNames[0], WarrantplayerNames[1]);
					}
					SendToGroup(playerVariables[playerid][pGroup], COLOR_RADIOCHAT, szMessage);
					playerVariables[warrantid][pWarrants] = 0;
				}
				else SendClientMessage(playerid, COLOR_GREY, "The specified player is not connected, or has not authenticated.");
		    }
		    case DIALOG_LSPD_EQUIPMENT: {
		        if(response) switch(listitem) {
		            case 0: ShowPlayerDialog(playerid, LSPD_DIALOG_EQUIPMENT1, DIALOG_STYLE_LIST, "Equipment", "Nitestick\nMace\nDesert Eagle\nMP5\nShotgun\nKevlar Vest", "Select", "Cancel");
		            case 1: {
		                if(groupVariables[playerVariables[playerid][pGroup]][gswatInv] == 1) {
		                    ShowPlayerDialog(playerid, LSPD_DIALOG_EQUIPMENT2, DIALOG_STYLE_LIST, "SWAT Equipment", "CS Gas ($500)\nM4A1 ($3,000)\nSPAS-12 ($5,000)\nSniper Rifle ($5,000)", "Select", "Cancel");
		                }
		                else {
		                    SendClientMessage(playerid, COLOR_WHITE, "The SWAT inventory is currently unavailable.");
		                }
		            }
		        }
		    }
		    case LSPD_DIALOG_EQUIPMENT2: {
		        if(response) switch(listitem) {
		            case 0: {
		                if(groupVariables[GOVERNMENT_GROUP_ID][gSafe][0] >= 500) {
		                    groupVariables[GOVERNMENT_GROUP_ID][gSafe][0] -= 500;
		                    SendClientMessage(playerid, COLOR_WHITE, "You have withdrawn CS gas. This has cost the government $500, so use it properly.");
							PlayerPlaySound(playerid, 1052, 0, 0, 0);
		                    givePlayerValidWeapon(playerid, 17);
		                }
		                else {
		                    SendClientMessage(playerid, COLOR_WHITE, "The government are unable to afford this weapon on your behalf.");
		                }
		            }
		            case 1: {
		                if(groupVariables[GOVERNMENT_GROUP_ID][gSafe][0] >= 3000)
		                {
		                    groupVariables[GOVERNMENT_GROUP_ID][gSafe][0] -= 3000;
		                    SendClientMessage(playerid, COLOR_WHITE, "You have withdrawn an M4A1. This has cost the government $3,000, so use it properly.");
		                    givePlayerValidWeapon(playerid, 31);
							PlayerPlaySound(playerid, 1052, 0, 0, 0);
		                }
		                else {
		                    SendClientMessage(playerid, COLOR_WHITE, "The government are unable to afford this weapon on your behalf.");
		                }
		            }
		            case 2: {
		                if(groupVariables[GOVERNMENT_GROUP_ID][gSafe][0] >= 5000)
		                {
		                    groupVariables[GOVERNMENT_GROUP_ID][gSafe][0] -= 5000;
		                    SendClientMessage(playerid, COLOR_WHITE, "You have withdrawn a SPAS12. This has cost the government $5,000, so use it properly.");
		                    givePlayerValidWeapon(playerid, 27);
							PlayerPlaySound(playerid, 1052, 0, 0, 0);
		                }
		                else {
		                    SendClientMessage(playerid, COLOR_WHITE, "The government are unable to afford this weapon on your behalf.");
		                }
		            }
		            case 3: {
		                if(groupVariables[GOVERNMENT_GROUP_ID][gSafe][0] >= 5000) {
		                    groupVariables[GOVERNMENT_GROUP_ID][gSafe][0] -= 5000;
		                    SendClientMessage(playerid, COLOR_WHITE, "You have withdrawn a sniper rifle. This has cost the government $5,000, so use it properly.");
		                    givePlayerValidWeapon(playerid, 34);
							PlayerPlaySound(playerid, 1052, 0, 0, 0);
		                }
		                else {
		                    SendClientMessage(playerid, COLOR_WHITE, "The government are unable to afford this weapon on your behalf.");
		                }
		            }
		        }
		    }
	  	case LSPD_DIALOG_EQUIPMENT1: {
      		if(response) switch(listitem) {
		       	case 0: givePlayerValidWeapon(playerid, 3) && PlayerPlaySound(playerid, 1052, 0, 0, 0);
		       	case 1: givePlayerValidWeapon(playerid, 41) && PlayerPlaySound(playerid, 1052, 0, 0, 0);
		       	case 2: givePlayerValidWeapon(playerid, 24) && PlayerPlaySound(playerid, 1052, 0, 0, 0);
	        	case 3: givePlayerValidWeapon(playerid, 29) && PlayerPlaySound(playerid, 1052, 0, 0, 0);
	        	case 4: givePlayerValidWeapon(playerid, 25) && PlayerPlaySound(playerid, 1052, 0, 0, 0);
				case 5: SetPlayerArmour(playerid, 100.0) && PlayerPlaySound(playerid, 1052, 0, 0, 0);
			}
    	}
 		case DIALOG_LSPD: {
   			if(response) switch(listitem) {
                    case 0: ShowPlayerDialog(playerid, DIALOG_LSPD_EQUIPMENT, DIALOG_STYLE_LIST, "Equipment", "Normal Equipment\nSWAT Equipment", "Select", "Cancel");
					case 1: {
						if(playerVariables[playerid][pGroupRank] >= 5) ShowPlayerDialog(playerid, DIALOG_LSPD_RELEASE, DIALOG_STYLE_INPUT, "Release Suspect", "Please enter the suspect's name.", "Proceed", "Cancel");
						else SendClientMessage(playerid, COLOR_GREY, "You do not have the authority to do this.");
					}
					case 2: ShowPlayerDialog(playerid, DIALOG_LSPD_CLOTHING, DIALOG_STYLE_LIST, "Clothing", "Official Clothing\nCustom Selection", "Select", "Cancel");
		            case 3: {
						if(playerVariables[playerid][pGroupRank] >= 5) ShowPlayerDialog(playerid, DIALOG_LSPD_CLEAR, DIALOG_STYLE_INPUT, "Clear Suspect", "Please enter the suspect's name.", "Proceed", "Cancel");
						else SendClientMessage(playerid, COLOR_GREY, "You do not have the authority to do this.");
					}
			}
		}
		case DIALOG_LOGIN: {
		    if(!response) return Kick(playerid);

		    new
		        query[300],
		        escapedName[MAX_PLAYER_NAME],
				escapedPassword[129];

			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

			WP_Hash(escapedPassword, sizeof(escapedPassword), inputtext);

			mysql_real_escape_string(szPlayerName, escapedName);

			format(query, sizeof(query), "SELECT * FROM `playeraccounts` WHERE playerName = '%s' AND playerPassword = '%s'", escapedName, escapedPassword);
			mysql_query(query, THREAD_CHECK_CREDENTIALS, playerid);
		}
		case DIALOG_GROUP_ENTER: {
			if(response == 1) {
			    new
			        x = GetPVarInt(playerid, "gE"); // So we don't have to access it each and every time.

                DeletePVar(playerid, "gE");

			    new
					name[MAX_PLAYER_NAME];

				GetPlayerName(playerid, name, MAX_PLAYER_NAME);
			    format(szMessage, sizeof(szMessage), "* %s breaks down the door and enters the building.", name);
                nearByMessage(playerid, COLOR_PURPLE, szMessage);

				if(playerVariables[playerid][pAdminDuty] < 1 && groupVariables[x][gGroupHQLockStatus] == 1) {
					groupVariables[x][gGroupHQLockStatus] = 0;
					format(szMessage, sizeof(szMessage), "%s's HQ\n\nPress ~k~~PED_DUCK~ to enter.", groupVariables[x][gGroupName]);
					UpdateDynamic3DTextLabelText(groupVariables[x][gGroupLabelID], COLOR_YELLOW, szMessage);
				}

				SetPlayerPos(playerid, groupVariables[x][gGroupInteriorPos][0], groupVariables[x][gGroupInteriorPos][1], groupVariables[x][gGroupInteriorPos][2]);
				SetPlayerInterior(playerid, groupVariables[x][gGroupHQInteriorID]);
				SetPlayerVirtualWorld(playerid, GROUP_VIRTUAL_WORLD+x);
			}
		}
		case DIALOG_REGISTER: {
			if(strlen(inputtext) < 1)
			    return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "SERVER: Registration", "Your password must exceed 1 character!\n\nWelcome to the "SERVER_NAME" Server.\n\nPlease enter your desired password below!", "Register", "Cancel");

			new
				wpHash[129];

			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
			mysql_real_escape_string(szPlayerName, szPlayerName);

			WP_Hash(wpHash, sizeof(wpHash), inputtext);

			format(szLargeString, sizeof(szLargeString), "INSERT INTO playeraccounts (playerName, playerPassword) VALUES('%s', '%s')", szPlayerName, wpHash);
			mysql_query(szLargeString);

			SendClientMessage(playerid, COLOR_WHITE, "SERVER: Your account is now registered!");
			format(szLargeString, sizeof(szLargeString), "SELECT * FROM `playeraccounts` WHERE `playerName` = '%s' AND `playerPassword` = '%s'", szPlayerName, wpHash);
			mysql_query(szLargeString, THREAD_CHECK_CREDENTIALS, playerid);
		}
		case DIALOG_HOUSE_ENTER: {
			if(response == 1) {
			    new
			        x = GetPVarInt(playerid, "hE"); // So we don't have to access it each and every time.

                DeletePVar(playerid, "hE");

				GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
			    format(szMessage,sizeof(szMessage),"* %s breaks down the door and enters the house.", szPlayerName);
                nearByMessage(playerid, COLOR_PURPLE, szMessage);

                if(playerVariables[playerid][pAdminDuty] < 1 && houseVariables[x][hHouseLocked] == 1) { // Might seem redundant, but if many people break in at once this'll stop unnecessary code from being executed.
					houseVariables[x][hHouseLocked] = 0;
					if(!strcmp(houseVariables[x][hHouseOwner], "Nobody", true) && strlen(houseVariables[x][hHouseOwner]) >= 1)
						format(szMessage, sizeof(szMessage), "House %d (un-owned - /buyhouse)\nPrice: $%d\n\n(locked)", x, houseVariables[x][hHousePrice]);
					else
					    format(szMessage, sizeof(szMessage), "House %d (owned)\nOwner: %s\n\nPress ~k~~PED_DUCK~ to enter.", x, houseVariables[x][hHouseOwner]);
					    
					UpdateDynamic3DTextLabelText(houseVariables[x][hLabelID], COLOR_YELLOW, szMessage);
				}

				SetPlayerPos(playerid, houseVariables[x][hHouseInteriorPos][0], houseVariables[x][hHouseInteriorPos][1], houseVariables[x][hHouseInteriorPos][2]);
				SetPlayerInterior(playerid, houseVariables[x][hHouseInteriorID]);
				SetPlayerVirtualWorld(playerid, HOUSE_VIRTUAL_WORLD+x);
			}
		}
		case DIALOG_BUSINESS_ENTER: {
			if(response == 1) {
			    new
			        x = GetPVarInt(playerid, "bE"); // So we don't have to access it each and every time.

                DeletePVar(playerid, "bE");

				GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
			    format(szMessage, sizeof(szMessage),"* %s breaks down the door and enters the business.", szPlayerName);
                nearByMessage(playerid, COLOR_PURPLE, szMessage);

                if(playerVariables[playerid][pAdminDuty] < 1 && businessVariables[x][bLocked] == 1) {
					businessVariables[x][bLocked] = 0;
					
					if(!strcmp(businessVariables[x][bOwner], "Nobody"))
					    format(szMessage, sizeof(szMessage), "%s\n(Business %d - un-owned)\nPrice: $%d (/buybusiness)\n\n(locked)", businessVariables[x][bName], x, businessVariables[x][bPrice]);
					else
					    format(szMessage, sizeof(szMessage), "%s\n(Business %d - owned by %s)\n\nPress ~k~~PED_DUCK~ to enter", businessVariables[x][bName], x, businessVariables[x][bOwner]);
					
					UpdateDynamic3DTextLabelText(businessVariables[x][bLabelID], COLOR_YELLOW, szMessage);
				}

				SetPlayerPos(playerid, businessVariables[x][bInteriorPos][0], businessVariables[x][bInteriorPos][1], businessVariables[x][bInteriorPos][2]);
				SetPlayerInterior(playerid, businessVariables[x][bInterior]);
				SetPlayerVirtualWorld(playerid, BUSINESS_VIRTUAL_WORLD+x);
			}
		}
  		case DIALOG_CREATEGUN: {
			if(!response)
				return 1;
				
			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
			
		    switch(listitem) {
				case 0: {
					if(playerVariables[playerid][pMaterials] >= 30) {
						givePlayerValidWeapon(playerid, 8);
				        playerVariables[playerid][pMaterials] -= 30;
				        SendClientMessage(playerid, COLOR_WHITE, "You have created a katana. Type /giveweapon [playerid] to pass the weapon on.");
				        format(szMessage, sizeof(szMessage), "* %s has created a katana from their materials.", szPlayerName);
				        nearByMessage(playerid, COLOR_PURPLE, szMessage);
						playerVariables[playerid][pJobDelay] = 30;
				        playerVariables[playerid][pJobSkill][0]++;
						switch(playerVariables[playerid][pJobSkill][0]) {
							case 50, 100, 150, 200, 250, 300, 350, 400, 450, 500: {
								format(szMessage,sizeof(szMessage),"Congratulations! Your weapon creation skill level is now %d. You can now create more powerful weapons.",playerVariables[playerid][pJobSkill][0]/50);
								SendClientMessage(playerid,COLOR_WHITE,szMessage);
							}
						}
				    }
					else {
						SendClientMessage(playerid, COLOR_GREY, "You do not have enough materials.");
					}
				}
				case 1: {
					if(playerVariables[playerid][pMaterials] >= 30) {

						givePlayerValidWeapon(playerid, 15);
						playerVariables[playerid][pMaterials] -= 30;
						SendClientMessage(playerid, COLOR_WHITE,"You have created a cane. Type /giveweapon [playerid] to pass the weapon on.");
						format(szMessage, sizeof(szMessage), "* %s has created a cane from their materials.", szPlayerName);
						nearByMessage(playerid, COLOR_PURPLE, szMessage);
						playerVariables[playerid][pJobSkill][0]++;
						playerVariables[playerid][pJobDelay] = 30;
						switch(playerVariables[playerid][pJobSkill][0]) {
							case 50, 100, 150, 200, 250, 300, 350, 400, 450, 500: {
								format(szMessage,sizeof(szMessage),"Congratulations! Your weapon creation skill level is now %d. You can now create more powerful weapons.",playerVariables[playerid][pJobSkill][0]/50);
								SendClientMessage(playerid,COLOR_WHITE,szMessage);
							}
						}
					}
					else {
						SendClientMessage(playerid, COLOR_GREY, "You do not have enough materials.");
					}
				}
				case 2: {
					if(playerVariables[playerid][pMaterials] >= 33) {

						givePlayerValidWeapon(playerid, 7);
						playerVariables[playerid][pMaterials] -= 33;
						SendClientMessage(playerid, COLOR_WHITE,"You have created a pool cue. Type /giveweapon [playerid] to pass the weapon on.");
						format(szMessage, sizeof(szMessage), "* %s has created a pool cue from their materials.", szPlayerName);
						nearByMessage(playerid, COLOR_PURPLE, szMessage);
						playerVariables[playerid][pJobSkill][0]++;
						playerVariables[playerid][pJobDelay] = 30;
						switch(playerVariables[playerid][pJobSkill][0]) {
							case 50, 100, 150, 200, 250, 300, 350, 400, 450, 500: {
								format(szMessage,sizeof(szMessage),"Congratulations! Your weapon creation skill level is now %d. You can now create more powerful weapons.",playerVariables[playerid][pJobSkill][0]/50);
								SendClientMessage(playerid,COLOR_WHITE,szMessage);
							}
						}
					}
					else {
						SendClientMessage(playerid, COLOR_GREY, "You do not have enough materials.");
					}
				}
				case 3: {
					if(playerVariables[playerid][pMaterials] >= 35) {

						givePlayerValidWeapon(playerid, 5);
						playerVariables[playerid][pMaterials] -= 35;
						SendClientMessage(playerid, COLOR_WHITE, "You have created a baseball bat. Type /giveweapon [playerid] to pass the weapon on.");
						format(szMessage, sizeof(szMessage), "* %s has created a baseball bat from their materials.", szPlayerName);
						nearByMessage( playerid, COLOR_PURPLE, szMessage);
						playerVariables[playerid][pJobSkill][0]++;
						playerVariables[playerid][pJobDelay] = 30;
						switch(playerVariables[playerid][pJobSkill][0]) {
							case 50, 100, 150, 200, 250, 300, 350, 400, 450, 500: {
								format(szMessage,sizeof(szMessage),"Congratulations! Your weapon creation skill level is now %d. You can now create more powerful weapons.",playerVariables[playerid][pJobSkill][0]/50);
								SendClientMessage(playerid,COLOR_WHITE,szMessage);
							}
						}
					}
					else {
						SendClientMessage(playerid, COLOR_GREY, "You do not have enough materials.");
					}
				}
				case 4: {
					if(playerVariables[playerid][pMaterials] >= 50) {

						givePlayerValidWeapon(playerid, 6);
						playerVariables[playerid][pMaterials] -= 50;
						SendClientMessage(playerid, COLOR_WHITE,"You have created a shovel. Type /giveweapon [playerid] to pass the weapon on.");
						format(szMessage, sizeof(szMessage), "* %s has created a shovel from their materials.", szPlayerName);
						nearByMessage( playerid, COLOR_PURPLE, szMessage);
						playerVariables[playerid][pJobSkill][0]++;
						playerVariables[playerid][pJobDelay] = 30;
						switch(playerVariables[playerid][pJobSkill][0]) {
							case 50, 100, 150, 200, 250, 300, 350, 400, 450, 500: {
								format(szMessage,sizeof(szMessage),"Congratulations! Your weapon creation skill level is now %d. You can now create more powerful weapons.",playerVariables[playerid][pJobSkill][0]/50);
								SendClientMessage(playerid,COLOR_WHITE,szMessage);
							}
						}
					}
					else {
						SendClientMessage(playerid, COLOR_GREY, "You do not have enough materials.");
					}
				}
				case 5: {
					if(playerVariables[playerid][pMaterials] >= 250) {

						givePlayerValidWeapon(playerid, 22);
						playerVariables[playerid][pMaterials] -= 250;
						SendClientMessage(playerid, COLOR_WHITE,"You have created a 9mm pistol. Type /giveweapon [playerid] to pass the weapon on.");
						format(szMessage, sizeof(szMessage), "* %s has created a 9mm pistol from their materials.", szPlayerName);
						nearByMessage( playerid, COLOR_PURPLE, szMessage);
						playerVariables[playerid][pJobSkill][0]++;
						playerVariables[playerid][pJobDelay] = 30;
						switch(playerVariables[playerid][pJobSkill][0]) {
							case 50, 100, 150, 200, 250, 300, 350, 400, 450, 500: {
								format(szMessage,sizeof(szMessage),"Congratulations! Your weapon creation skill level is now %d. You can now create more powerful weapons.",playerVariables[playerid][pJobSkill][0]/50);
								SendClientMessage(playerid,COLOR_WHITE,szMessage);
							}
						}
					}
					else {
						SendClientMessage(playerid, COLOR_GREY, "You do not have enough materials.");
					}
				}
				case 6: {
					if(playerVariables[playerid][pMaterials] >= 300) {

						givePlayerValidWeapon(playerid, 23);
						playerVariables[playerid][pMaterials] -= 300;
						SendClientMessage(playerid, COLOR_WHITE, "You have created a silenced pistol. Type /giveweapon [playerid] to pass the weapon on.");
						format(szMessage, sizeof(szMessage), "* %s has created a silenced pistol from their materials.", szPlayerName);
						nearByMessage( playerid, COLOR_PURPLE, szMessage);
						playerVariables[playerid][pJobSkill][0]++;
						playerVariables[playerid][pJobDelay] = 30;
						switch(playerVariables[playerid][pJobSkill][0]) {
							case 50, 100, 150, 200, 250, 300, 350, 400, 450, 500: {
								format(szMessage,sizeof(szMessage),"Congratulations! Your weapon creation skill level is now %d. You can now create more powerful weapons.",playerVariables[playerid][pJobSkill][0]/50);
								SendClientMessage(playerid,COLOR_WHITE,szMessage);
							}
						}
					}
					else {
						SendClientMessage(playerid, COLOR_GREY, "You do not have enough materials.");
					}
				}
				case 7: {
					if(playerVariables[playerid][pMaterials] >= 550) {

						givePlayerValidWeapon(playerid, 25);
						playerVariables[playerid][pMaterials] -= 550;
						SendClientMessage(playerid, COLOR_WHITE,"You have created a shotgun. Type /giveweapon [playerid] to pass the weapon on.");
						format(szMessage, sizeof(szMessage), "* %s has created a shotgun from their materials.", szPlayerName);
						nearByMessage( playerid, COLOR_PURPLE, szMessage);
						playerVariables[playerid][pJobSkill][0]++;
						playerVariables[playerid][pJobDelay] = 30;
						switch(playerVariables[playerid][pJobSkill][0]) {
							case 50, 100, 150, 200, 250, 300, 350, 400, 450, 500: {
								format(szMessage,sizeof(szMessage),"Congratulations! Your weapon creation skill level is now %d. You can now create more powerful weapons.",playerVariables[playerid][pJobSkill][0]/50);
								SendClientMessage(playerid,COLOR_WHITE,szMessage);
							}
						}
					}
					else {
						SendClientMessage(playerid, COLOR_GREY, "You do not have enough materials.");
					}
				}

				case 8: {
					if(playerVariables[playerid][pMaterials] >= 680) {

						givePlayerValidWeapon(playerid, 24);
						playerVariables[playerid][pMaterials] -= 680;
						SendClientMessage(playerid, COLOR_WHITE, "You have created a Desert Eagle. Type /giveweapon [playerid] to pass the weapon on.");
						format(szMessage, sizeof(szMessage), "* %s has created a Desert Eagle from their materials.", szPlayerName);
						nearByMessage(playerid, COLOR_PURPLE, szMessage);
						playerVariables[playerid][pJobSkill][0]++;
						playerVariables[playerid][pJobDelay] = 30;
						switch(playerVariables[playerid][pJobSkill][0]) {
							case 50, 100, 150, 200, 250, 300, 350, 400, 450, 500: {
								format(szMessage,sizeof(szMessage),"Congratulations! Your weapon creation skill level is now %d. You can now create more powerful weapons.",playerVariables[playerid][pJobSkill][0]/50);
								SendClientMessage(playerid,COLOR_WHITE,szMessage);
							}
						}
					}
					else {
						SendClientMessage(playerid, COLOR_GREY, "You do not have enough materials.");
					}
				}

				case 9: {
					if( playerVariables[playerid][pMaterials] >= 850 )
					{
						givePlayerValidWeapon(playerid, 29);
						playerVariables[playerid][pMaterials] -= 850;
						SendClientMessage(playerid, COLOR_WHITE, "You have created an MP5. Type /giveweapon [playerid] to pass the weapon on.");
						format(szMessage, sizeof(szMessage), "* %s has created a %s from their materials.", szPlayerName);
						nearByMessage( playerid, COLOR_PURPLE, szMessage);
						playerVariables[playerid][pJobSkill][0]++;
						playerVariables[playerid][pJobDelay] = 30;
						switch(playerVariables[playerid][pJobSkill][0]) {
							case 50, 100, 150, 200, 250, 300, 350, 400, 450, 500: {
								format(szMessage,sizeof(szMessage),"Congratulations! Your weapon creation skill level is now %d. You can now create more powerful weapons.",playerVariables[playerid][pJobSkill][0]/50);
								SendClientMessage(playerid,COLOR_WHITE,szMessage);
							}
						}
					}
					else {
						SendClientMessage(playerid, COLOR_GREY, "You do not have enough materials.");
					}
				}
				case 10: {
					if(playerVariables[playerid][pMaterials] >= 900 )
					{

						givePlayerValidWeapon(playerid, 28);
						playerVariables[playerid][pMaterials] -= 900;
						SendClientMessage(playerid, COLOR_WHITE, "You have created a Micro Uzi. Type /giveweapon [playerid] to pass the weapon on.");
						format(szMessage, sizeof(szMessage), "* %s has created a Micro Uzi from their materials.", szPlayerName);
						nearByMessage( playerid, COLOR_PURPLE, szMessage);
						playerVariables[playerid][pJobSkill][0]++;
						playerVariables[playerid][pJobDelay] = 30;
						switch(playerVariables[playerid][pJobSkill][0]) {
							case 50, 100, 150, 200, 250, 300, 350, 400, 450, 500: {
								format(szMessage,sizeof(szMessage),"Congratulations! Your weapon creation skill level is now %d. You can now create more powerful weapons.",playerVariables[playerid][pJobSkill][0]/50);
								SendClientMessage(playerid,COLOR_WHITE,szMessage);
							}
						}
					}
					else
					{
						SendClientMessage(playerid, COLOR_GREY, "You do not have enough materials.");
					}
				}
				case 11: {
					if(playerVariables[playerid][pMaterials] >= 1500) {

						givePlayerValidWeapon(playerid, 30);
						playerVariables[playerid][pMaterials] -= 1500;
						SendClientMessage(playerid, COLOR_WHITE, "You have created an AK-47. Type /giveweapon [playerid] to pass the weapon on.");
						format(szMessage, sizeof(szMessage), "* %s has created an AK-47 from their materials.", szPlayerName);
						nearByMessage( playerid, COLOR_PURPLE, szMessage);
						playerVariables[playerid][pJobSkill][0]++;
						playerVariables[playerid][pJobDelay] = 30;
						switch(playerVariables[playerid][pJobSkill][0]) {
							case 50, 100, 150, 200, 250, 300, 350, 400, 450, 500: {
								format(szMessage,sizeof(szMessage),"Congratulations! Your weapon creation skill level is now %d. You can now create more powerful weapons.",playerVariables[playerid][pJobSkill][0]/50);
								SendClientMessage(playerid,COLOR_WHITE,szMessage);
							}
						}
					}
					else {
						SendClientMessage(playerid, COLOR_GREY, "You do not have enough materials.");
					}
				}
				case 12: {
					if(playerVariables[playerid][pMaterials] >= 2000)
					{
						givePlayerValidWeapon(playerid, 31);
						playerVariables[playerid][pMaterials] -= 2000;
						SendClientMessage(playerid, COLOR_WHITE, "You have created an M4A1. Type /giveweapon [playerid] to pass the weapon on.");
						format(szMessage, sizeof(szMessage), "* %s has created an M4A1 from their materials.", szPlayerName);
						nearByMessage(playerid, COLOR_PURPLE, szMessage);
						playerVariables[playerid][pJobSkill][0]++;
						playerVariables[playerid][pJobDelay] = 30;
						switch(playerVariables[playerid][pJobSkill][0]) {
							case 50, 100, 150, 200, 250, 300, 350, 400, 450, 500: {
								format(szMessage,sizeof(szMessage),"Congratulations! Your weapon creation skill level is now %d. You can now create more powerful weapons.",playerVariables[playerid][pJobSkill][0]/50);
								SendClientMessage(playerid,COLOR_WHITE,szMessage);
							}
						}
					}
					else {
						SendClientMessage(playerid, COLOR_GREY, "You do not have enough materials.");
					}
				}
				case 13: {
					if(playerVariables[playerid][pMaterials] >= 2450) {

						givePlayerValidWeapon(playerid, 34);
						playerVariables[playerid][pMaterials] -= 2450;
						SendClientMessage(playerid, COLOR_WHITE,"You have created a sniper rifle. Type /giveweapon [playerid] to pass the weapon on.");
						format(szMessage, sizeof(szMessage), "* %s has created a sniper rifle from their materials.", szPlayerName);
						nearByMessage( playerid, COLOR_PURPLE, szMessage);
						playerVariables[playerid][pJobSkill][0]++;
						playerVariables[playerid][pJobDelay] = 30;
						switch(playerVariables[playerid][pJobSkill][0]) {
							case 50, 100, 150, 200, 250, 300, 350, 400, 450, 500: {
								format(szMessage,sizeof(szMessage),"Congratulations! Your weapon creation skill level is now %d. You can now create more powerful weapons.",playerVariables[playerid][pJobSkill][0]/50);
								SendClientMessage(playerid,COLOR_WHITE,szMessage);
							}
						}
					}
					else {
						SendClientMessage(playerid, COLOR_GREY, "You do not have enough materials.");
					}
				}
				case 14: {
					if(playerVariables[playerid][pMaterials] >= 2550) {
						givePlayerValidWeapon(playerid, 27);
						playerVariables[playerid][pMaterials] -= 2550;
						SendClientMessage(playerid, COLOR_WHITE, "You have created a SPAS12. Type /giveweapon [playerid] to pass the weapon on.");
						format(szMessage, sizeof(szMessage), "* %s has created a SPAS12 from their materials.", szPlayerName);
						nearByMessage(playerid, COLOR_PURPLE, szMessage);
						playerVariables[playerid][pJobSkill][0]++;
						playerVariables[playerid][pJobDelay] = 30;
						switch(playerVariables[playerid][pJobSkill][0]) {
							case 50, 100, 150, 200, 250, 300, 350, 400, 450, 500: {
								format(szMessage,sizeof(szMessage),"Congratulations! Your weapon creation skill level is now %d. You can now create more powerful weapons.",playerVariables[playerid][pJobSkill][0]/50);
								SendClientMessage(playerid,COLOR_WHITE,szMessage);
							}
						}
					}
					else {
						SendClientMessage(playerid, COLOR_GREY, "You do not have enough materials.");
					}
				}
				case 15: {
					if(playerVariables[playerid][pMaterials] >= 1750) {
						SetPlayerArmour(playerid, 100);
						playerVariables[playerid][pMaterials] -= 1750;
						SendClientMessage(playerid, COLOR_WHITE, "You have created a kevlar vest. Type /givearmour [playerid] to pass it on.");
						format(szMessage, sizeof(szMessage), "* %s has created a kevlar vest from their materials.", szPlayerName);
						nearByMessage(playerid, COLOR_PURPLE, szMessage);
						playerVariables[playerid][pJobSkill][0]++;
						playerVariables[playerid][pJobDelay] = 30;
						switch(playerVariables[playerid][pJobSkill][0]) {
							case 50, 100, 150, 200, 250, 300, 350, 400, 450, 500: {
								format(szMessage,sizeof(szMessage),"Congratulations! Your weapon creation skill level is now %d. You can now create more powerful weapons.",playerVariables[playerid][pJobSkill][0]/50);
								SendClientMessage(playerid,COLOR_WHITE,szMessage);
							}
						}
					}
					else SendClientMessage(playerid, COLOR_GREY, "You do not have enough materials.");
				}
			}
		}
	}
	return 1;
}

stock nearByMessage(playerid, color, string[], Float: Distance = 12.0) {
	new
	    Float: nbCoords[3];

	GetPlayerPos(playerid, nbCoords[0], nbCoords[1], nbCoords[2]);

	foreach(Player, i) {
	    if(playerVariables[i][pStatus] >= 1) {
	        if(IsPlayerInRangeOfPoint(i, Distance, nbCoords[0], nbCoords[1], nbCoords[2]) && (GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))) {
				SendClientMessage(i, color, string);
			}
	    }
	}

	return 1;
}

public OnPlayerText(playerid, text[]) {
	#if defined DEBUG
	    printf("[debug] OnPlayerText(%d, %s)", playerid, text);
	#endif

	if(playerVariables[playerid][pStatus] >= 1 && playerVariables[playerid][pMuted] == 0) {
		new
		    iRetStr = strfind(text, "(", true, 0);

		GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
		for(new i = 0; i < strlen(szPlayerName); i++) {
			if(szPlayerName[i] == '_')
			    szPlayerName[i] = ' ';
		}

		if(iRetStr < 4 && iRetStr != -1 && playerVariables[playerid][pAdminDuty] == 0) {
			format(szMessage, sizeof(szMessage), "%s says: (( %s ))", szPlayerName, text);
			nearByMessage(playerid, COLOR_WHITE, szMessage);
			return 1;
		}

		if(playerVariables[playerid][pPhoneCall] != -1) {
			format(szMessage, sizeof(szMessage), "(cellphone) \"%s\"", text);
			SetPlayerChatBubble(playerid, szMessage, COLOR_CHATBUBBLE, 10.0, 10000);
			if(!strcmp(playerVariables[playerid][pAccent], "None", true))
				format(szMessage, sizeof(szMessage), "(cellphone) %s says: %s", szPlayerName, text);
			else
				format(szMessage, sizeof(szMessage), "(cellphone) (%s Accent)%s says: %s", playerVariables[playerid][pAccent], szPlayerName, text);

			nearByMessage(playerid, COLOR_WHITE, szMessage);

			switch (playerVariables[playerid][pPhoneCall]) {
				case 911: {
					if(!strcmp(text, "LSPD", true) || !strcmp(text, "police", true)) {
						SendClientMessage(playerid, COLOR_WHITE, "(cellphone) 911: You have reached the Los Santos Police emergency hotline; can you describe the crime?");
						playerVariables[playerid][pPhoneCall] = 912;
					}
					else if(!strcmp(text, "LSFMD", true) || !strcmp(text, "medic", true) || !strcmp(text, "ambulance", true)) {
						SendClientMessage(playerid, COLOR_WHITE, "(cellphone) 911: This is the Los Santos Fire & Medic Department emergency hotline; describe the emergency, please.");
						playerVariables[playerid][pPhoneCall] = 914;
					}
					else SendClientMessage(playerid, COLOR_WHITE, "(cellphone) 911: Sorry, I didn't quite understand that... speak again?");
				}
				case 912: {
					if(strlen(text) > 1) {
						new
							location[MAX_ZONE_NAME];

						GetPlayer2DZone(playerid, location, MAX_ZONE_NAME);
			            format(szMessage, sizeof(szMessage), "Dispatch: %s has reported: '%s' (10-20 %s)", szPlayerName, text, location);
						SendToGroup(1, COLOR_RADIOCHAT, szMessage);

						SendClientMessage(playerid, COLOR_WHITE, "(cellphone) 911: Thank you for reporting this incident; a patrol unit is now on its way.");

						SendClientMessage(playerid, COLOR_WHITE, "Your call has been terminated by the other party.");

						if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE) {
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
						}
						playerVariables[playerid][pPhoneCall] = -1;
					}
				}
				case 914: {
					if(strlen(text) > 1) {
						new
							location[MAX_ZONE_NAME];

						GetPlayer2DZone(playerid, location, MAX_ZONE_NAME);
			            format(szMessage, sizeof(szMessage), "Dispatch: %s has reported '%s' (10-20 %s)", szPlayerName, text, location);
						SendToGroupType(4, COLOR_RED, szMessage);

						SendClientMessage(playerid, COLOR_WHITE, "(cellphone) 911: Thank you for reporting this incident; we are on our way.");

						SendClientMessage(playerid, COLOR_WHITE, "Your call has been terminated by the other party.");

						if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE)
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);

						playerVariables[playerid][pPhoneCall] = -1;
					}
				}
				default: { // If they're calling a player, this code is executed.
					SendClientMessage(playerVariables[playerid][pPhoneCall], COLOR_GREY, szMessage);
					mysql_real_escape_string(szMessage, szMessage);
					format(szLargeString, sizeof(szLargeString), "INSERT INTO chatlogs (value, playerinternalid) VALUES('%s', '%d')", szMessage, playerVariables[playerid][pInternalID]);
					mysql_query(szLargeString);
				}
			}
		}

		else {
            if(!strcmp(playerVariables[playerid][pAccent], "None", true))
		    	format(szMessage, sizeof(szMessage), "{FFFFFF}%s says: %s", szPlayerName, text);
			else
		    	format(szMessage, sizeof(szMessage), "(%s Accent) {FFFFFF}%s says: %s", playerVariables[playerid][pAccent], szPlayerName, text);

		    if(playerVariables[playerid][pAdminDuty] >= 1) format(szMessage, sizeof(szMessage), "%s says: (( %s ))", szPlayerName, text);
			nearByMessage(playerid, COLOR_GREY, szMessage);
			mysql_real_escape_string(szMessage, szMessage);
			format(szLargeString, sizeof(szLargeString), "INSERT INTO chatlogs (value, playerinternalid) VALUES('%s', '%d')", szMessage, playerVariables[playerid][pInternalID]);
			mysql_query(szLargeString);
			format(szMessage, sizeof(szMessage), "\"%s\"", text);
			SetPlayerChatBubble(playerid, szMessage, COLOR_CHATBUBBLE, 10.0, 10000);
		}

		playerVariables[playerid][pSpamCount]++;
	}
	return 0;
}

getPlayerHouseID(playerid) {
	new
	    x;

    while(x < MAX_HOUSES) {
		if(strlen(houseVariables[x][hHouseOwner]) >= 1) {
	        if(!strcmp(houseVariables[x][hHouseOwner], playerVariables[playerid][pNormalName], true)) {
				return x;
			}
		}
		x++;
	}

    return 0;
}

getPlayerBusinessID(const playerid) {
	new
	    x;

    while(x < MAX_BUSINESSES) {
		if(strlen(businessVariables[x][bOwner]) >= 1) {
	        if(!strcmp(businessVariables[x][bOwner], playerVariables[playerid][pNormalName], true)) {
				return x;
			}
		}
		x++;
	}

    return 0;
}

stock resetPlayerVariables(const playerid) {
	playerVariables[playerid][pStatus] = 0; // Not authenticated, but connected
	playerVariables[playerid][pSeconds] = 0;
	playerVariables[playerid][pSkin] = 299;
	playerVariables[playerid][pSkinCount] = 0;
	playerVariables[playerid][pMoney] = 0;
	playerVariables[playerid][pTazer] = 0;
	playerVariables[playerid][pOnRequest] = INVALID_PLAYER_ID;
	playerVariables[playerid][pFish] = -1;
	playerVariables[playerid][pBankMoney] = 20000;
	playerVariables[playerid][pHealth] = 100;
	playerVariables[playerid][pFishing] = 0;
	playerVariables[playerid][pArmour] = 0;
	playerVariables[playerid][pPMStatus] = 0;
	playerVariables[playerid][pAnticheatExemption] = 0;
	playerVariables[playerid][pPos][0] = 0;
	playerVariables[playerid][pEvent] = 0;
	playerVariables[playerid][pJetpack] = 0;
	playerVariables[playerid][pWalkieTalkie] = -1;
	playerVariables[playerid][pLevel] = 0;
	playerVariables[playerid][pTabbed] = 0;
	playerVariables[playerid][pHackWarnTime] = 0;
	playerVariables[playerid][pCarPaintjob] = -1;
	playerVariables[playerid][pBackup] = -1;
	playerVariables[playerid][pRope] = 0;
	playerVariables[playerid][pCarID] = -1;
	playerVariables[playerid][pFightStyle] = 4;
	playerVariables[playerid][pVIP] = 0;
	playerVariables[playerid][pCarColour][0] = -1;
	playerVariables[playerid][pCarColour][1] = -1;
	playerVariables[playerid][pMatrunTime] = 0;
	playerVariables[playerid][pPhoneBook] = 0;
	playerVariables[playerid][pHelperDuty] = 0;
	playerVariables[playerid][pDropCarTimeout] = 0;
	playerVariables[playerid][pPos][1] = 0;
	playerVariables[playerid][pHelper] = 0;
	playerVariables[playerid][pPhoneNumber] = -1;
	playerVariables[playerid][pPos][2] = 0;
	playerVariables[playerid][pSkinSet] = 0;
	playerVariables[playerid][pTutorial] = 0;
	playerVariables[playerid][pCarModel] = 0;
	playerVariables[playerid][pGender] = 1;
	playerVariables[playerid][pPhoneStatus] = 1;
	playerVariables[playerid][pHackWarnings] = 0;
	playerVariables[playerid][pSeeOOC] = 1;
	playerVariables[playerid][pGroup] = 0;
	playerVariables[playerid][pGroupRank] = 0;
	playerVariables[playerid][pPrisonTime] = 0;
	playerVariables[playerid][pPrisonID] = 0;
	playerVariables[playerid][pHospitalized] = 0;
	playerVariables[playerid][pSpamCount] = 0;
	playerVariables[playerid][pNewbieEnabled] = 1;
	playerVariables[playerid][pMuted] = 0;
	playerVariables[playerid][pAdminLevel] = 0;
	playerVariables[playerid][pPhoneCall] = -1;
	playerVariables[playerid][pInternalID] = -1;
	playerVariables[playerid][pVirtualWorld] = 0;
	playerVariables[playerid][pSpectating] = INVALID_PLAYER_ID;
	playerVariables[playerid][pJob] = 0;
	playerVariables[playerid][pFirstLogin] = 0;
	playerVariables[playerid][pAdminDuty] = 0;
	playerVariables[playerid][pReport] = 0;
	playerVariables[playerid][pInterior] = 0;
	playerVariables[playerid][pPlayingHours] = 0;
	playerVariables[playerid][pJobDelay] = 0;
	playerVariables[playerid][pCheckpoint] = 0;
	playerVariables[playerid][pMaterials] = 0;
	playerVariables[playerid][pJobSkill][0] = 0;
	playerVariables[playerid][pJobSkill][1] = 0;
	playerVariables[playerid][pPhoneCall] = -1;
	playerVariables[playerid][pFreezeTime] = 0;
	playerVariables[playerid][pFreezeType] = 0;
	playerVariables[playerid][pOOCMuted] = 0;
	playerVariables[playerid][pNewbieTimeout] = 0;
	playerVariables[playerid][pDrag] = -1;
	playerVariables[playerid][pAge] = 0;
	playerVariables[playerid][pCarTrunk][0] = 0;
	playerVariables[playerid][pCarTrunk][1] = 0;
	playerVariables[playerid][pPhoneCredit] = 0;

	new
	    x;

	while(x < 13) {
		playerVariables[playerid][pWeapons][x] = 0;
		x++;
	}

	x = 0;

	while(x < 13) {
		playerVariables[playerid][pCarMods][x] = 0;
		x++;
	}

	x = 0;

	while(x < 5) {
		playerVariables[playerid][pCarWeapons][x] = 0;
		x++;
	}

	format(playerVariables[playerid][pWarning1], 32, "(null)");
	format(playerVariables[playerid][pWarning2], 32, "(null)");
	format(playerVariables[playerid][pWarning3], 32, "(null)");
	format(playerVariables[playerid][pEmail], 255, "(null)");
	format(playerVariables[playerid][pReportMessage], 64, "(null)");
	format(playerVariables[playerid][pCarLicensePlate], 32, "3VFT W%d", 10+random(80));
	format(playerVariables[playerid][pPassword], 129, "(null)");
	format(playerVariables[playerid][pAccent], 20, "American");
	format(playerVariables[playerid][pAdminName], MAX_PLAYER_NAME, "(null)");
	format(playerVariables[playerid][pConnectionIP], 32, "(null)");

	GetPlayerName(playerid, playerVariables[playerid][pNormalName], MAX_PLAYER_NAME);

	playerVariables[playerid][pConnectedSeconds] = 0;

	return true;
}

stock initiateConnections() {
	new
	    File: fhConnectionInfo = fopen("MySQL.txt", io_read);

	fread(fhConnectionInfo, szQueryOutput);
	fclose(fhConnectionInfo);

	sscanf(szQueryOutput, "p<|>e<s[32]s[32]s[32]s[64]>", connectionInfo);
	
	#if defined DEBUG
	printf("[debug] initiateConnections() '%s', '%s', '%s', '%s'", szQueryOutput, connectionInfo[szDatabaseHostname], connectionInfo[szDatabaseUsername], connectionInfo[szDatabaseName], connectionInfo[szDatabasePassword]);
	#endif
	
	databaseConnection = mysql_connect(connectionInfo[szDatabaseHostname], connectionInfo[szDatabaseUsername], connectionInfo[szDatabaseName], connectionInfo[szDatabasePassword]);
	return true;
}

stock validResetPlayerWeapons(const playerid) {
	playerVariables[playerid][pAnticheatExemption] = 6;

	new
	    xLoop;

	ResetPlayerWeapons(playerid);

	while(xLoop < 13) {
		playerVariables[playerid][pWeapons][xLoop] = 0;
		xLoop++;
	}

	if(playerVariables[playerid][pTabbed] >= 1) {
		playerVariables[playerid][pOutstandingWeaponRemovalSlot] = 40;
	}

	return 1;
}

stock adminLog(string[]) {
	new
	    queryString[201],
	    cleanString[128];

	mysql_real_escape_string(string, cleanString);

	format(queryString, sizeof(queryString), "INSERT INTO adminlog (value, tickcount) VALUES('%s', '%d')", cleanString, GetTickCount());
	return mysql_query(queryString);
}

stock syncPlayerTime(const playerid) {
	if(!GetPlayerInterior(playerid)) {
		SetPlayerWeather(playerid, weatherVariables[0]);
	}
	else SetPlayerWeather(playerid, INTERIOR_WEATHER_ID);
	return SetPlayerTime(playerid, gTime[0], gTime[1]);
}

public globalPlayerLoop() {
	pingTick++;
	if(pingTick >= 120) {
	    if(mysql_ping() == -1) {
			mysql_reconnect(); // After 120 seconds (2 minutes), we need to ensure the connection is still alive. MySQL sometimes plays up and forces the connection to timeout.
		}
		pingTick = 0;
	}

	if(adTick >= 1)
		adTick--;

	/* --------------------- WORLD TIME --------------------- */

	gettime(gTime[0], gTime[1], gTime[2]);

	if(gTime[1] >= 59 && gTime[2] >= 59) {

		weatherVariables[1] += random(3) + 1; // Weather changes aren't regular.

		SetWorldTime(gTime[0]); // Set the world time to keep the worldtime variable updated (and ensure it syncs instantly for connecting players).

		if(weatherVariables[1] >= MAX_WEATHER_POINTS) {
			weatherVariables[0] = validWeatherIDs[random(sizeof(validWeatherIDs))];
			foreach(Player, i) {
				if(!GetPlayerInterior(i)) {
					SetPlayerWeather(i, weatherVariables[0]);
				}
				else SetPlayerWeather(i, INTERIOR_WEATHER_ID);
			}
			weatherVariables[1] = 0;
		}
	}

	/* ------------------------------------------------------ */

	foreach(Player, x) {
	
	    playerVariables[x][pConnectedSeconds] += 1;

		if(gTime[2] >= 59) syncPlayerTime(x);

	    if(playerVariables[x][pStatus] == 1) {
		    playerVariables[x][pSeconds]++;

			if(playerVariables[x][pMuted] >= 1) {
			    playerVariables[x][pMuted]--; // We don't need two variables for muting - just use -1 to permamute (admin mute) and a positive var for a temp mute.

			    if(playerVariables[x][pMuted] == 0) {
			        SendClientMessage(x, COLOR_GREY, "You have now been automatically unmuted.");
			    }
			}

			if(playerVariables[x][pAnticheatExemption] >= 1) {
				playerVariables[x][pAnticheatExemption]--;
			}
			
			if(playerVariables[x][pAdminLevel] > 0) {
				if(GetPVarInt(x, "pAdminPINConfirmed") >= 1)
				    SetPVarInt(x, "pAdminPINConfirmed", GetPVarInt(x, "pAdminPINConfirmed")-1);
			}

			if(playerVariables[x][pPhoneCall] != -1) {

				playerVariables[x][pPhoneCredit]--;

				if(playerVariables[x][pPhoneCredit] == 60) {
					SendClientMessage(x, COLOR_HOTORANGE, "You're almost out of credit, you have 60 seconds left.");
				}
				
				else if(playerVariables[x][pPhoneCredit] < 1) {
					SendClientMessage(x, COLOR_WHITE, "Your phone has ran out of credit, visit a 24/7 to buy a top up voucher.");

					if(GetPlayerSpecialAction(x) == SPECIAL_ACTION_USECELLPHONE) {
						SetPlayerSpecialAction(x, SPECIAL_ACTION_STOPUSECELLPHONE);
					}
					if(playerVariables[x][pPhoneCall] != -1 && playerVariables[x][pPhoneCall] < MAX_PLAYERS) {

						SendClientMessage(playerVariables[x][pPhoneCall], COLOR_WHITE, "Your call has been terminated by the other party (ran out of credit).");

						if(GetPlayerSpecialAction(playerVariables[x][pPhoneCall]) == SPECIAL_ACTION_USECELLPHONE) {
							SetPlayerSpecialAction(playerVariables[x][pPhoneCall], SPECIAL_ACTION_STOPUSECELLPHONE);
						}
						playerVariables[playerVariables[x][pPhoneCall]][pPhoneCall] = -1;
					}
					playerVariables[x][pPhoneCall] = -1;
				}
			}

			if(playerVariables[x][pFishing] >= 1) {
			    playerVariables[x][pFishing]++;
			    /*SetProgressBarValue(playerVariables[x][pFishingBar], GetProgressBarValue(playerVariables[x][pFishingBar])+10);
			    UpdateProgressBar(playerVariables[x][pFishingBar], x);*/

			    if(playerVariables[x][pFishing] == 10) {
			        /*HideProgressBarForPlayer(x, playerVariables[x][pFishingBar]); // Refer to /fish for reason why this is commented out
			        DestroyProgressBar(playerVariables[x][pFishingBar]);*/

			        new
			            randFish = random(5);

			        playerVariables[x][pFish] = randFish;

					format(szMessage, sizeof(szMessage), "You have reeled in a %s.", fishNames[randFish]);
					SendClientMessage(x, COLOR_WHITE, szMessage);

					switch(randFish) {
					    case 0: SendClientMessage(x, COLOR_WHITE, "The fish that you collected is worth $1000. To sell your fish, please visit a 24/7.");
					    case 1: SendClientMessage(x, COLOR_WHITE, "The fish that you collected is worth $750. To sell your fish, please visit a 24/7.");
					    case 2: SendClientMessage(x, COLOR_WHITE, "The fish that you collected is worth $250. To sell your fish, please visit a 24/7.");
					    case 3: SendClientMessage(x, COLOR_WHITE, "The fish that you collected is worth $900. To sell your fish, please visit a 24/7.");
					    case 4: SendClientMessage(x, COLOR_WHITE, "The fish that you collected is worth $500. To sell your fish, please visit a 24/7.");
					}

					playerVariables[x][pJobDelay] = 900;
				}
			}

			if(playerVariables[x][pSpectating] != INVALID_PLAYER_ID) { // OnPlayerInteriorChange doesn't work properly when spectating.
				if(GetPlayerInterior(x) != GetPlayerInterior(playerVariables[x][pSpectating])){
					SetPlayerInterior(x, GetPlayerInterior(playerVariables[x][pSpectating]));
				}
				if(GetPlayerVirtualWorld(x) != GetPlayerVirtualWorld(playerVariables[x][pSpectating])){
					SetPlayerVirtualWorld(x, GetPlayerVirtualWorld(playerVariables[x][pSpectating]));
				}
			}
            if(playerVariables[x][pBackup] != -1) {
                if(IsPlayerAuthed(playerVariables[x][pBackup])) {
                    GetPlayerPos(playerVariables[x][pBackup], playerVariables[playerVariables[x][pBackup]][pPos][0], playerVariables[playerVariables[x][pBackup]][pPos][1], playerVariables[playerVariables[x][pBackup]][pPos][2]);
                    SetPlayerCheckpoint(x, playerVariables[playerVariables[x][pBackup]][pPos][0], playerVariables[playerVariables[x][pBackup]][pPos][1], playerVariables[playerVariables[x][pBackup]][pPos][2], 10.0);
                }
                else {
                    playerVariables[x][pBackup] = -1;
					playerVariables[x][pCheckpoint] = 0;

                    SendClientMessage(x, COLOR_GREY, "The player requesting for backup has disconnected.");
                    DisablePlayerCheckpoint(x);
                }
            }

			if(playerVariables[x][pDrag] != -1) { // Considering how slow SetPlayerPos works in practice, using a 1000ms timer in lieu of OnPlayerUpdate (the old script) is a better idea.
				if(IsPlayerAuthed(playerVariables[x][pDrag])) {
					switch(GetPlayerState(playerVariables[x][pDrag])) { // If they're not on foot, they're not gonna be dragging anything...
						case 1: { // on foot
							GetPlayerPos(playerVariables[x][pDrag], playerVariables[x][pPos][0], playerVariables[x][pPos][1], playerVariables[x][pPos][2]);
							SetPlayerPos(x, playerVariables[x][pPos][0], playerVariables[x][pPos][1], playerVariables[x][pPos][2]);

							SetPlayerVirtualWorld(x, GetPlayerVirtualWorld(playerVariables[x][pDrag]));
							SetPlayerInterior(x, GetPlayerInterior(playerVariables[x][pDrag]));
						}
						case 2, 3: {
							SendClientMessage(playerVariables[x][pDrag], COLOR_GREY, "You can't enter a vehicle while dragging someone (use /detain).");
							RemovePlayerFromVehicle(playerVariables[x][pDrag]);
						}
						case 7: { // Death
							SendClientMessage(x, COLOR_WHITE, "The person who was dragging you has been wasted.");
							playerVariables[x][pDrag] = -1;
						}
					}
				}
				else {

					SendClientMessage(x, COLOR_WHITE, "The person who was dragging you has disconnected.");
					playerVariables[x][pDrag] = -1; // Kills off any disconnections.
				}
			}

			if(playerVariables[x][pMatrunTime] >= 1) {
				playerVariables[x][pMatrunTime]++;
			}

	        if(playerVariables[x][pJobDelay] >= 1) {
	   	    	playerVariables[x][pJobDelay]--;
				if(playerVariables[x][pJobDelay] == 0) SendClientMessage(x, COLOR_WHITE, "Your job reload time is over.");
	        }

	        if(playerVariables[x][pNewbieTimeout] > 0) {
	            playerVariables[x][pNewbieTimeout]--;
	            if(playerVariables[x][pNewbieTimeout] == 0) SendClientMessage(x, COLOR_WHITE, "You may now speak in the newbie chat channel again.");
	        }

			if(playerVariables[x][pHackWarnings] >= 1) {
				playerVariables[x][pHackWarnTime]++;

				if(playerVariables[x][pHackWarnTime] >= 10) {
					playerVariables[x][pHackWarnings] = 0;
					playerVariables[x][pHackWarnTime] = 0;
				}
			}

			if(playerVariables[x][pDropCarTimeout] >= 1) {
                playerVariables[x][pDropCarTimeout]--;
                if(playerVariables[x][pDropCarTimeout] == 1) {
                    playerVariables[x][pDropCarTimeout] = 0;
                    SendClientMessage(x, COLOR_WHITE, "You can now drop vehicles again at the crane.");
				}
			}

			if(GetPVarInt(x, "tutTime") > 0) {
			    SetPVarInt(x, "tutTime", GetPVarInt(x, "tutTime")-1);
			    if(GetPVarInt(x, "tutTime") == 0) {
			        TextDrawHideForPlayer(x, textdrawVariables[8]);
			        TextDrawShowForPlayer(x, textdrawVariables[7]);
			    }
			}

			if(playerVariables[x][pHospitalized] >= 2) {
                playerVariables[x][pHospitalized]++;
                GetPlayerHealth(x, playerVariables[x][pHealth]);
                SetPlayerHealth(x, playerVariables[x][pHealth]+7.5);

                if(playerVariables[x][pHealth]+10 >= 100) {
                    SetPlayerHealth(x, 100);
                    playerVariables[x][pHospitalized] = 0;

                    switch(GetPVarInt(x, "hosp")) {
                   	 	case 1: {
	                        playerVariables[x][pPos][0] = 1172.359985;
							playerVariables[x][pPos][1] = -1323.313110;
							playerVariables[x][pPos][2] = 15.402919;
							playerVariables[x][pHealth] = 75;
							playerVariables[x][pArmour] = 0;
							playerVariables[x][pVirtualWorld] = 0;
							playerVariables[x][pInterior] = 0;
	                        SetSpawnInfo(x, 0, playerVariables[x][pSkin], 1172.359985, -1323.313110, 15.402919, 0, 0, 0, 0, 0, 0, 0);
	                        SpawnPlayer(x);
	                        SendClientMessage(x, COLOR_LIGHTRED, "You have been released from Hospital.");
	                        SendClientMessage(x, COLOR_LIGHTRED, "You have been charged $1,000 for your stay, and any weapons you had have been confiscated.");
	                        playerVariables[x][pMoney] -= 1000;
	                        validResetPlayerWeapons(x);
	                        DeletePVar(x, "hosp");
                        }
                        case 2: {
	                        playerVariables[x][pPos][0] = 2034.196166;
							playerVariables[x][pPos][1] = -1402.591430;
							playerVariables[x][pPos][2] = 17.295030;
							playerVariables[x][pHealth] = 75;
							playerVariables[x][pArmour] = 0;
							playerVariables[x][pVirtualWorld] = 0;
							playerVariables[x][pInterior] = 0;
	                        SetSpawnInfo(x, 0, playerVariables[x][pSkin], 2034.196166, -1402.591430, 17.295030, 0, 0, 0, 0, 0, 0, 0);
	                        SpawnPlayer(x);
	                        SendClientMessage(x, COLOR_LIGHTRED, "You have been released from Hospital.");
	                        SendClientMessage(x, COLOR_LIGHTRED, "You have been charged $1,000 for your stay, and any weapons you had have been confiscated.");
	                        playerVariables[x][pMoney] -= 1000;
	                        validResetPlayerWeapons(x);
	                        SetPlayerPos(x, 2034.196166, -1402.591430, 17.295030);
	                        DeletePVar(x, "hosp");
                        }
                    }
				}
			}

			if(playerVariables[x][pSkinSet] >= 1) {
			    playerVariables[x][pSkinSet]++;
			    if(playerVariables[x][pSkinSet] == 3 && GetPlayerSkin(x) != playerVariables[x][pSkin]) {
					SetPlayerSkin(x, playerVariables[x][pSkin]); // Set the skin first.
				}
				if(playerVariables[x][pSkinSet] == 4) {
                    givePlayerWeapons(x); // Then give the player their weapons. Seems like a SA-MP bug? Pain in the arse might I add!
                    playerVariables[x][pSkinSet] = 0;
					TogglePlayerControllable(x, true);
				}
			}

			if(playerVariables[x][pFreezeTime] != 0) {
				TogglePlayerControllable(x, 0);
				if(playerVariables[x][pFreezeType] == 5)
					ApplyAnimation(x, "FAT", "IDLE_TIRED", 4.1, 1, 1, 1, 1, 0, 1);
					
				if(playerVariables[x][pFreezeTime] > 0) {
					playerVariables[x][pFreezeTime]--;
					if(playerVariables[x][pFreezeTime] == 0) {
						if(playerVariables[x][pFreezeType] == 5) {
							SetPlayerDrunkLevel(x, 0);
							ClearAnimations(x);
						}
						playerVariables[x][pFreezeType] = 0;
						TogglePlayerControllable(x, true);
					}
				}

			}

			if(playerVariables[x][pPrisonID] > 0) {
                playerVariables[x][pPrisonTime]--;

                switch(playerVariables[x][pPrisonID]) {
					case 1: {
						format(szMessage, sizeof(szMessage), "~n~~n~~n~~n~~n~~n~~n~ ~r~Prisoned!~n~~w~%d seconds (%d minutes) left", playerVariables[x][pPrisonTime], playerVariables[x][pPrisonTime]/60);
					}
					case 2, 3: { // We're going to be using 3 for IC jail, so... yeah
						format(szMessage, sizeof(szMessage), "~n~~n~~n~~n~~n~~n~~n~ ~r~Jailed!~n~~w~%d seconds (%d minutes) left", playerVariables[x][pPrisonTime], playerVariables[x][pPrisonTime]/60);
					}
				}

				GameTextForPlayer(x, szMessage, 2000, 3); // Always specify the game text time longer than the intended time; it always fades out before it should, causing an annoying flash.

                if(playerVariables[x][pPrisonTime] == 1 && playerVariables[x][pPrisonID] >= 1) {
                    playerVariables[x][pPrisonID] = 0;
                    playerVariables[x][pPrisonTime] = 0;
                    SendClientMessage(x, COLOR_WHITE, "Your time is up! You have been released from jail/prison.");
					SetPlayerPos(x, 738.9963, -1417.2211, 13.5234);
					SetPlayerVirtualWorld(x, 0);
					SetPlayerInterior(x, 0);
				}
			}

			if(playerVariables[x][pSpamCount] >= 1)
				playerVariables[x][pSpamCount]--;

			if(playerVariables[x][pSpamCount] >= 5 && playerVariables[x][pAdminLevel] == 0) {
			    playerVariables[x][pMuted] = 10;
			    playerVariables[x][pSpamCount] = 0;
			    SendClientMessage(x, COLOR_GREY, "You have been auto-muted for spamming. You will be unmuted in 10 seconds.");
			}

		    if(playerVariables[x][pSeconds] >= 3600) {

		        playerVariables[x][pSeconds] = 0;
		        playerVariables[x][pPlayingHours]++;

		        new
		            BankInterest = playerVariables[x][pBankMoney] / 1000,
		            RandPay = (random(495) + 5) * (playerVariables[x][pPlayingHours]/60) + random(5000) + 500,
					TotalPay = BankInterest + RandPay;

				if(playerVariables[x][pBankMoney]+playerVariables[x][pMoney] > -5000000) {
		            SendClientMessage(x, COLOR_TEAL, "----------------------------------------------------------------------------");
					SendClientMessage(x, COLOR_WHITE, "Your paycheck has arrived; please visit the bank to withdraw your money.");
					playerVariables[x][pBankMoney] += TotalPay;
                    new taxamount = ((TotalPay/100) * assetVariables[1][aAssetValue]);
                    if(taxamount > 1) {
                        playerVariables[x][pBankMoney] -= taxamount;
                        groupVariables[GOVERNMENT_GROUP_ID][gSafe][0] += taxamount;
                        saveGroup(GOVERNMENT_GROUP_ID);
                    }
					format(szMessage, sizeof(szMessage), "Paycheck: $%d | Bank balance: $%d | Bank interest: $%d | Tax: $%d (%d percent) | Total earnings: $%d", RandPay, playerVariables[x][pBankMoney], BankInterest, taxamount, assetVariables[1][aAssetValue], TotalPay-taxamount);
		            SendClientMessage(x, COLOR_GREY, szMessage);
		            SendClientMessage(x, COLOR_TEAL, "----------------------------------------------------------------------------");

		            savePlayerData(x);
				}
				else {
				    SendClientMessage(x, COLOR_WHITE, "You're too poor to obtain a paycheck.");
				}
		    }

		    if(GetPlayerMoney(x) != playerVariables[x][pMoney]) {
				ResetPlayerMoney(x);
				GivePlayerMoney(x, playerVariables[x][pMoney]);
			}
	    }
	}

	return true;
}
// -------------------------------------------------- ANIMATION CODE ------------------------------------------ //


stock PlayerFacePlayer(playerid, targetplayerid) { // Yeah, this'll fix the handshake headaches we had last time around (shaking air).
	new
		Float: Angle;

	GetPlayerFacingAngle(playerid, Angle);
	SetPlayerFacingAngle(targetplayerid, Angle+180);
	return 1;
}

stock GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance) { // And this'll keep the players close.

	new Float: a;

	GetPlayerPos(playerid, x, y, a);
	GetPlayerFacingAngle(playerid, a);

	if (GetPlayerVehicleID(playerid)) {
 		GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}

	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}

stock IsPlayerAimingAtPlayer(playerid, aimid) {

	new
		Float:Floats[7];

	GetPlayerPos(playerid, Floats[0], Floats[1], Floats[2]);
	GetPlayerPos(aimid, Floats[3], Floats[4], Floats[5]);
	new Float:Distance = floatsqroot(floatpower(floatabs(Floats[0]-Floats[3]), 2) + floatpower(floatabs(Floats[1]-Floats[4]), 2));
	if(Distance < 10.0) {
		GetPlayerFacingAngle(playerid, Floats[6]);
		Floats[0] += (Distance * floatsin(-Floats[6], degrees));
		Floats[1] += (Distance * floatcos(-Floats[6], degrees));
	    Distance = floatsqroot(floatpower(floatabs(Floats[0]-Floats[3]), 2) + floatpower(floatabs(Floats[1]-Floats[4]), 2));

  		if(Distance < 2.0) {
    		return true;
  		}
	}
	return false;
}

CMD:explode(playerid, params[]) {

	new
		ID;

	if(playerVariables[playerid][pAdminLevel] >= 4) {
		if(sscanf(params, "u", ID)) {
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/explode [playerid]");
		}
	    else if(IsPlayerAuthed(ID)) {
			if(playerVariables[playerid][pAdminLevel] >= playerVariables[ID][pAdminLevel]) {

				new
					Float:fNuke[3],
					string[45];

				GetPlayerName(ID, szPlayerName, MAX_PLAYER_NAME);
				GetPlayerPos(ID, fNuke[0], fNuke[1], fNuke[2]);

				CreateExplosion(fNuke[0], fNuke[1], fNuke[2], 9, 100.0);
				CreateExplosion(fNuke[0], fNuke[1], fNuke[2], 7, 100.0);
				CreateExplosion(fNuke[0], fNuke[1], fNuke[2]+10.0, 7, 100.0);
				CreateExplosion(fNuke[0]+random(10)-5, fNuke[1]+random(10)-5, fNuke[2]+random(10)-5, 6, 100.0);

				if(IsPlayerInAnyVehicle(ID)) {
					GetVehicleVelocity(GetPlayerVehicleID(ID), fNuke[0], fNuke[1], fNuke[2]);
					SetVehicleVelocity(GetPlayerVehicleID(ID), fNuke[0]+random(10)-5, fNuke[1]+random(10)-5, fNuke[2]+random(10)-5);
				}
				else SetPlayerVelocity(ID, random(10)-5, random(10)-5, random(10)-5);

				format(string, sizeof(string), "You have exploded %s.", szPlayerName);
				SendClientMessage(playerid, COLOR_WHITE, string);
			}
			else SendClientMessage(playerid, COLOR_GREY, "You can't explode a higher level administrator.");
	    }
	    else SendClientMessage(playerid, COLOR_GREY, "The specified player is not connected, or has not authenticated.");
	}
	return 1;
}

CMD:closestcar(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 1) {
	    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {

	        new
				playerWarpVehicle = GetClosestVehicle(playerid),
				string[64];

	        if(doesVehicleExist(playerWarpVehicle)) {
				PutPlayerInVehicle(playerid, playerWarpVehicle, 0);
				format(string, sizeof(string), "You have teleported into a %s (vehicle ID %d).", VehicleNames[GetVehicleModel(playerWarpVehicle) - 400], playerWarpVehicle);
				SendClientMessage(playerid, COLOR_WHITE, string);
			}
			else SendClientMessage(playerid, COLOR_GREY, "No vehicles are in range.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You can only use this command while on foot.");
	}
	return 1;
}

CMD:sethelper(playerid, params[]) {
	new
		ID,
		level;

	if(playerVariables[playerid][pAdminLevel] >= 5) {

		if(sscanf(params, "ud", ID, level))
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/sethelper [playerid] [level]");

	    if(IsPlayerAuthed(ID)) {
			if(level >= 0 && level <= 4) {
				new
					string[79];

				GetPlayerName(ID, szPlayerName, MAX_PLAYER_NAME);
				format(string, sizeof(string), "You have made %s a level %d helper.", szPlayerName, level);
				SendClientMessage(playerid, COLOR_WHITE, string);

				GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

				if(level == 0) format(string, sizeof(string), "Administrator %s has removed you from the helper team.", szPlayerName);
				else if(level >= playerVariables[ID][pHelper]) format(string, sizeof(string), "Administrator %s has promoted you to a level %d helper.", szPlayerName, level);
				else if (level <= playerVariables[ID][pHelper]) format(string, sizeof(string), "Administrator %s has demoted you to a level %d helper.", szPlayerName, level);

				SendClientMessage(ID, COLOR_NICESKY, string);

				playerVariables[ID][pHelper] = level;
			}
			else SendClientMessage(playerid, COLOR_GREY, "Valid helper levels are 0 to 4.");
	    }
	    else SendClientMessage(playerid, COLOR_GREY, "The specified player is not connected, or has not authenticated.");
	}
	return 1;
}

CMD:vehname(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 3) {

		SendClientMessage(playerid, COLOR_TEAL, "--------------------------------------------------------------------------------------------------------------------------------");
		SendClientMessage(playerid, COLOR_WHITE, "Vehicle Search:");

		new
			rcount;

		if(isnull(params))
			return SendClientMessage(playerid, COLOR_GREY, "No keyword specified.");
			
		if(strlen(params) < 3)
			return SendClientMessage(playerid, COLOR_GREY, "Search keyword too short.");

		for(new v; v < sizeof(VehicleNames); v++) {
			if(strfind(VehicleNames[v], params, true) != -1) {

				if(rcount == 0)
					format(szMessage, sizeof(szMessage), "%s (ID %d)", VehicleNames[v], v+400);
				else
					format(szMessage, sizeof(szMessage), "%s | %s (ID %d)", szMessage, VehicleNames[v], v+400);

				rcount++;
			}
		}

		if(rcount == 0)
			SendClientMessage(playerid, COLOR_GREY, "No results found.");

		else
			if(strlen(szMessage) >= 128)
				SendClientMessage(playerid, COLOR_GREY, "Too many results found.");
			else
				SendClientMessage(playerid, COLOR_WHITE, szMessage);

		SendClientMessage(playerid, COLOR_TEAL, "--------------------------------------------------------------------------------------------------------------------------------");
	}
	return 1;
}

CMD:gunname(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 3) {

		SendClientMessage(playerid, COLOR_TEAL, "--------------------------------------------------------------------------------------------------------------------------------");
		SendClientMessage(playerid, COLOR_WHITE, "Weapon Search:");

		new
			rcount;

		if(isnull(params))
			return SendClientMessage(playerid, COLOR_GREY, "No keyword specified.");
			
		if(strlen(params) < 3)
			return SendClientMessage(playerid, COLOR_GREY, "Search keyword too short.");

		for(new v; v < sizeof(WeaponNames); v++) {
			if(strfind(WeaponNames[v], params, true) != -1) {

				if(rcount == 0)
					format(szMessage, sizeof(szMessage), "%s (ID %d)", WeaponNames[v], v);
				else
					format(szMessage, sizeof(szMessage), "%s | %s (ID %d)", szMessage, WeaponNames[v], v);

				rcount++;
			}
		}

		if(rcount == 0)
			SendClientMessage(playerid, COLOR_GREY, "No results found.");

		else if(strlen(szMessage) >= 128)
			SendClientMessage(playerid, COLOR_GREY, "Too many results found.");

		else
			SendClientMessage(playerid, COLOR_WHITE, szMessage);

		SendClientMessage(playerid, COLOR_TEAL, "--------------------------------------------------------------------------------------------------------------------------------");
	}
	return 1;
}

CMD:elevator(playerid, params[]) {
	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1) {
		if(IsPlayerInRangeOfPoint(playerid, 1, 276.0980, 122.1232, 1004.6172)) { // Interior
			ShowPlayerDialog(playerid, DIALOG_ELEVATOR3, DIALOG_STYLE_LIST, "Elevator", "Upper Roof\nLower Roof\nGarage", "Select", "Cancel");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1, 1568.6676, -1689.9708, 6.2188)) { // Garage
			ShowPlayerDialog(playerid, DIALOG_ELEVATOR2, DIALOG_STYLE_LIST, "Elevator", "Upper Roof\nLower Roof\nInterior", "Select", "Cancel");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1, 1564.8, -1666.2, 28.3)) { // Lower roof
			ShowPlayerDialog(playerid, DIALOG_ELEVATOR1, DIALOG_STYLE_LIST, "Elevator", "Upper Roof\nInterior\nGarage", "Select", "Cancel");
		}
		else if(IsPlayerInRangeOfPoint(playerid, 1, 1564.6584,-1670.2607,52.4503)) { // Upper roof
			ShowPlayerDialog(playerid, DIALOG_ELEVATOR4, DIALOG_STYLE_LIST, "Elevator", "Lower Roof\nInterior\nGarage", "Select", "Cancel");
		}
	}
	return 1;
}

CMD:gate(playerid, params[]) {
	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1) {
		if(IsPlayerInRangeOfPoint(playerid, 15.0, 1544.6, -1630.8, 13.0)) switch(LSPDGates[0][1]) {
			case 0: {
				SetDynamicObjectRot(LSPDGates[0][0],0.0, 0, 90.0);
				LSPDGates[0][1] = 1;
			}
			case 1: {
				SetDynamicObjectRot(LSPDGates[0][0],0.0, 90.0, 90.0);
				LSPDGates[0][1] = 0;
			}
		}
		else if(IsPlayerInRangeOfPoint(playerid, 15.0, 1589.19995117,-1637.98498535,14.69999981)) switch (LSPDGates[1][1]) {
			case 0: {
				MoveDynamicObject(LSPDGates[1][0] ,1589.19995117,-1637.98498535,9.69999981, 1.0);
				LSPDGates[1][1] = 1;
				PlayerPlaySoundEx(1035, 1589.19995117,-1637.98498535,14.69999981);
			}
			case 1: {
				MoveDynamicObject(LSPDGates[1][0],1589.19995117,-1637.98498535,14.69999981, 1.0);
				LSPDGates[1][1] = 0;
				PlayerPlaySoundEx(1035, 1589.19995117,-1637.98498535,14.69999981);
			}
		}
	}
	return 1;
}

CMD:shakehand(playerid, params[]) {
	new
	    style,
		id;

    if(GetPlayerState(playerid) != 1)
		return SendClientMessage(playerid, COLOR_GREY, "You can only shake hands while on foot.");
		
    if(playerVariables[playerid][pFreezeTime] != 0)
		return SendClientMessage(playerid, COLOR_GREY, "You can't shake hands while cuffed, tazed, or frozen.");
		
	if(sscanf(params, "ud", id, style))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/shakehand [playerid] [1-9]");
		
 	if(id != INVALID_PLAYER_ID) {
   		if(IsPlayerInRangeOfPlayer(playerid, id, 1.5)) {
     		if(style > 0 && style < 9) {
              	GetPlayerName(id, szPlayerName, MAX_PLAYER_NAME);

	            SetPVarInt(id,"hs",style); // DYNAMICALLY ALLOCATED MEMORY!!11. Nah, this won't be accessed regularly
				SetPVarInt(id,"hsID",playerid); // and won't stay in memory for very long.

	            format(szMessage, sizeof(szMessage), "You have requested to shake hands with %s.", szPlayerName);
	            SendClientMessage(playerid, COLOR_WHITE, szMessage);

           		GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
	            format(szMessage, sizeof(szMessage), "%s is requesting to shake hands with you - type /accept handshake to do so.", szPlayerName);
	            SendClientMessage(id, COLOR_NICESKY, szMessage);
	        }
         	else {
           		SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/shakehand [playerid] [1-8]");
           	}
       	}
       	else {
       		SendClientMessage(playerid, COLOR_GREY, "Please stand closer to them.");
	    }
  	}
    else {
	    SendClientMessage(playerid, COLOR_GREY, "That player is not connected or is not logged in.");
    }
	return 1;
}

CMD:piss(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
	SetPlayerSpecialAction(playerid, 68);
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
	return 1;
}

CMD:handsup(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
	return 1;
}

CMD:drunk(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
	ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.0, 1, 1, 1, 1, 0);
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
	return 1;
}

CMD:bomb(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:rob(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
	ApplyAnimation(playerid, "ped", "ARRESTgun", 4.0, 0, 1, 1, 1, 0);
 	return 1;
}

CMD:laugh(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
 	ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:lookout(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:robman(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0);
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
   	return 1;
}

CMD:hide(playerid, params[]) {

    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0);
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
   	return 1;
}

CMD:vomit(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:eat(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:slapass(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:crack(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
   	return 1;
}

CMD:finger(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "PED", "fucku", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:taichi(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "PARK", "Tai_Chi_Loop", 4.0, 1, 0, 0, 0, 0);
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
   	return 1;
}

CMD:drinkwater(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "BAR", "dnk_stndF_loop", 4.0, 1, 0, 0, 0, 0);
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
   	return 1;
}

CMD:checktime(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:sleep(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "CRACK", "crckdeth4", 4.0, 0, 1, 1, 1, -1);
   	return 1;
}

CMD:blob(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "CRACK", "crckidle1", 4.0, 0, 1, 1, 1, -1);
   	return 1;
}

CMD:opendoor(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "AIRPORT", "thrw_barl_thrw", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:wavedown(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "BD_FIRE", "BD_Panic_01", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:cpr(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "MEDIC", "CPR", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:dive(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "DODGE", "Crush_Jump", 4.0, 0, 1, 1, 1, 0);
   	return 1;
}

CMD:showoff(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "Freeweights", "gym_free_celebrate", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:goggles(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:cry(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "GRAVEYARD", "mrnF_loop", 4.0, 1, 0, 0, 0, 0);
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
   	return 1;
}

CMD:throw(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "GRENADE", "WEAPON_throw", 4.0, 0, 0, 0, 0, 0);
	playerVariables[playerid][pAnimation] = 1;
   	return 1;
}

CMD:robbed(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "SHOP", "SHP_Rob_GiveCash", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:hurt(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.0, 1, 0, 0, 0, 0);
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
   	return 1;
}

CMD:box(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "GYMNASIUM", "GYMshadowbox", 4.0, 1, 0, 0, 0, 0);
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
   	return 1;
}

CMD:handwash(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:crabs(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "MISC", "Scratchballs_01", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:salute(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "ON_LOOKERS", "Pointup_loop", 4.0, 1, 0, 0, 0, 0);
	playerVariables[playerid][pAnimation] = 1;
   	return 1;
}

CMD:masturbate(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "PAULNMAC", "wank_out", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:stop(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	ApplyAnimation(playerid, "PED", "endchat_01", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:rap(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/rap [1-3]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "RAPPING", "RAP_A_Loop", 4.0, 1, 0, 0, 0, 0);
    	case 2: ApplyAnimation(playerid, "RAPPING", "RAP_B_Loop", 4.0, 1, 0, 0, 0, 0);
     	case 3: ApplyAnimation(playerid, "RAPPING", "RAP_C_Loop", 4.0, 1, 0, 0, 0, 0);
      	default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/rap [1-3]");
   	}
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
   	return 1;
 }

CMD:chat(playerid, params[]) {
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
	new animid;
	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/chat [1-7]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.0, 0, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.0, 0, 0, 0, 0, 0);
		case 3: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkB", 4.0, 0, 0, 0, 0, 0);
  		case 4: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.0, 0, 0, 0, 0, 0);
  		case 5: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkF", 4.0, 0, 0, 0, 0, 0);
  		case 6: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkG", 4.0, 0, 0, 0, 0, 0);
	    case 7: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkH", 4.0, 0, 0, 0, 0, 0);
  		default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/chat [1-7]");
 	}
 	return 1;
}

CMD:gesture(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/gesture [1-15]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "GHANDS", "gsign1", 4.0, 0, 0, 0, 0, 0);
        case 2: ApplyAnimation(playerid, "GHANDS", "gsign1LH", 4.0, 0, 0, 0, 0, 0);
        case 3: ApplyAnimation(playerid, "GHANDS", "gsign2", 4.0, 0, 0, 0, 0, 0);
        case 4: ApplyAnimation(playerid, "GHANDS", "gsign2LH", 4.0, 0, 0, 0, 0, 0);
        case 5: ApplyAnimation(playerid, "GHANDS", "gsign3", 4.0, 0, 0, 0, 0, 0);
        case 6: ApplyAnimation(playerid, "GHANDS", "gsign3LH", 4.0, 0, 0, 0, 0, 0);
        case 7: ApplyAnimation(playerid, "GHANDS", "gsign4", 4.0, 0, 0, 0, 0, 0);
        case 8: ApplyAnimation(playerid, "GHANDS", "gsign4LH", 4.0, 0, 0, 0, 0, 0);
        case 9: ApplyAnimation(playerid, "GHANDS", "gsign5", 4.0, 0, 0, 0, 0, 0);
        case 10: ApplyAnimation(playerid, "GHANDS", "gsign5", 4.0, 0, 0, 0, 0, 0);
        case 11: ApplyAnimation(playerid, "GHANDS", "gsign5LH", 4.0, 0, 0, 0, 0, 0);
        case 12: ApplyAnimation(playerid, "GANGS", "Invite_No", 4.0, 0, 0, 0, 0, 0);
        case 13: ApplyAnimation(playerid, "GANGS", "Invite_Yes", 4.0, 0, 0, 0, 0, 0);
        case 14: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkD", 4.0, 0, 0, 0, 0, 0);
        case 15: ApplyAnimation(playerid, "GANGS", "smkcig_prtl", 4.0, 0, 0, 0, 0, 0);
  		default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/gesture [1-15]");
   	}
   	return 1;
}

CMD:lay(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/lay [1-3]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "BEACH", "bather", 4.0, 1, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.0, 1, 0, 0, 0, 0);
  		case 3: ApplyAnimation(playerid, "BEACH", "SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0);
  		default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/lay [1-3]");
 	}
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
 	return 1;
}

CMD:wave(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/wave [1-3]");
	switch(animid) {
 		case 1: ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0);
 		case 2: ApplyAnimation(playerid, "KISSING", "gfwave2", 4.0, 0, 0, 0, 0, 0);
 		case 3: ApplyAnimation(playerid, "PED", "endchat_03", 4.0, 0, 0, 0, 0, 0);
 		default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/wave [1-3]");
 	}
 	return 1;
}

CMD:signal(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
   	new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/signal [1-2]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "POLICE", "CopTraf_Come", 4.0, 0, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "POLICE", "CopTraf_Stop", 4.0, 0, 0, 0, 0, 0);
  		default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/signal [1-2]");
   	}
   	return 1;
}

CMD:nobreath(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
    new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/nobreath [1-3]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
    	case 2: ApplyAnimation(playerid, "PED", "IDLE_tired", 4.0, 1, 0, 0, 0, 0);
     	case 3: ApplyAnimation(playerid, "FAT", "IDLE_tired", 4.0, 1, 0, 0, 0, 0);
     	default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/nobreath [1-3]");
 	}
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
 	return 1;
}

CMD:fallover(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
    new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/fallover [1-3]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.0, 0, 1, 1, 1, 0);
    	case 2: ApplyAnimation(playerid, "PED", "KO_shot_face", 4.0, 0, 1, 1, 1, 0);
     	case 3: ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.0, 0, 1, 1, 1, 0);
      	default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/fallover [1-3]");
 	}
 	return 1;
}

CMD:pedmove(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
    new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/pedmove [1-26]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "PED", "JOG_femaleA", 4.0, 1, 1, 1, 1, 1);
    	case 2: ApplyAnimation(playerid, "PED", "JOG_maleA", 4.0, 1, 1, 1, 1, 1);
	    case 3: ApplyAnimation(playerid, "PED", "WOMAN_walkfatold", 4.0, 1, 1, 1, 1, 1);
	    case 4: ApplyAnimation(playerid, "PED", "run_fat", 4.0, 1, 1, 1, 1, 1);
	    case 5: ApplyAnimation(playerid, "PED", "run_fatold", 4.0, 1, 1, 1, 1, 1);
	    case 6: ApplyAnimation(playerid, "PED", "run_old", 4.0, 1, 1, 1, 1, 1);
	    case 7: ApplyAnimation(playerid, "PED", "Run_Wuzi", 4.0, 1, 1, 1, 1, 1);
	    case 8: ApplyAnimation(playerid, "PED", "swat_run", 4.0, 1, 1, 1, 1, 1);
     	case 9: ApplyAnimation(playerid, "PED", "WALK_fat", 4.0, 1, 1, 1, 1, 1);
      	case 10: ApplyAnimation(playerid, "PED", "WALK_fatold", 4.0, 1, 1, 1, 1, 1);
       	case 11: ApplyAnimation(playerid, "PED", "WALK_gang1", 4.0, 1, 1, 1, 1, 1);
	    case 12: ApplyAnimation(playerid, "PED", "WALK_gang2", 4.0, 1, 1, 1, 1, 1);
	    case 13: ApplyAnimation(playerid, "PED", "WALK_old", 4.0, 1, 1, 1, 1, 1);
	    case 14: ApplyAnimation(playerid, "PED", "WALK_shuffle", 4.0, 1, 1, 1, 1, 1);
	    case 15: ApplyAnimation(playerid, "PED", "woman_run", 4.0, 1, 1, 1, 1, 1);
	    case 16: ApplyAnimation(playerid, "PED", "WOMAN_runbusy", 4.0, 1, 1, 1, 1, 1);
	    case 17: ApplyAnimation(playerid, "PED", "WOMAN_runfatold", 4.0, 1, 1, 1, 1, 1);
	    case 18: ApplyAnimation(playerid, "PED", "woman_runpanic", 4.0, 1, 1, 1, 1, 1);
	    case 19: ApplyAnimation(playerid, "PED", "WOMAN_runsexy", 4.0, 1, 1, 1, 1, 1);
	    case 20: ApplyAnimation(playerid, "PED", "WOMAN_walkbusy", 4.0, 1, 1, 1, 1, 1);
	    case 21: ApplyAnimation(playerid, "PED", "WOMAN_walkfatold", 4.0, 1, 1, 1, 1, 1);
	    case 22: ApplyAnimation(playerid, "PED", "WOMAN_walknorm", 4.0, 1, 1, 1, 1, 1);
	    case 23: ApplyAnimation(playerid, "PED", "WOMAN_walkold", 4.0, 1, 1, 1, 1, 1);
     	case 24: ApplyAnimation(playerid, "PED", "WOMAN_walkpro", 4.0, 1, 1, 1, 1, 1);
  		case 25: ApplyAnimation(playerid, "PED", "WOMAN_walksexy", 4.0, 1, 1, 1, 1, 1);
  		case 26: ApplyAnimation(playerid, "PED", "WOMAN_walkshop", 4.0, 1, 1, 1, 1, 1);
  		default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/pedmove [1-26]");
 	}
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
	return 1;
}

CMD:getjiggy(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
    new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/getjiggy [1-9]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "DANCING", "DAN_Down_A", 4.0, 1, 0, 0, 0, 0);
    	case 2: ApplyAnimation(playerid, "DANCING", "DAN_Left_A", 4.0, 1, 0, 0, 0, 0);
     	case 3: ApplyAnimation(playerid, "DANCING", "DAN_Loop_A", 4.0, 1, 0, 0, 0, 0);
      	case 4: ApplyAnimation(playerid, "DANCING", "DAN_Right_A", 4.0, 1, 0, 0, 0, 0);
       	case 5: ApplyAnimation(playerid, "DANCING", "DAN_Up_A", 4.0, 1, 0, 0, 0, 0);
        case 6: ApplyAnimation(playerid, "DANCING", "dnce_M_a", 4.0, 1, 0, 0, 0, 0);
       	case 7: ApplyAnimation(playerid, "DANCING", "dnce_M_b", 4.0, 1, 0, 0, 0, 0);
        case 8: ApplyAnimation(playerid, "DANCING", "dnce_M_c", 4.0, 1, 0, 0, 0, 0);
        case 9: ApplyAnimation(playerid, "DANCING", "dnce_M_d", 4.0, 1, 0, 0, 0, 0);
        default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/getjiggy [1-9]");
   	}
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
   	return 1;
}

CMD:stripclub(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
    new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/stripclub [1-2]");
	switch(animid) {

       	case 1: ApplyAnimation(playerid, "STRIP", "PLY_CASH", 4.0, 0, 0, 0, 0, 0);
       	case 2: ApplyAnimation(playerid, "STRIP", "PUN_CASH", 4.0, 0, 0, 0, 0, 0);
       	default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/stripclub [1-2]");
 	}
 	return 1;
}

CMD:smoke(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
    new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/smoke [1-3]");
	switch(animid) {

		case 1: ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.0, 0, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0);
		case 3: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
  		default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/smoke [1-2]");
 	}
 	return 1;
}

CMD:dj(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
    new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/dj [1-4]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "SCRATCHING", "scdldlp", 4.0, 1, 0, 0, 0, 0);
    	case 2: ApplyAnimation(playerid, "SCRATCHING", "scdlulp", 4.0, 1, 0, 0, 0, 0);
     	case 3: ApplyAnimation(playerid, "SCRATCHING", "scdrdlp", 4.0, 1, 0, 0, 0, 0);
     	case 4: ApplyAnimation(playerid, "SCRATCHING", "scdrulp", 4.0, 1, 0, 0, 0, 0);
      	default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/dj [1-4]");
 	}
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
	return 1;
}

CMD:reload(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
    new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/reload - 1 (Desert Eagle), 2 (SPAS12), 3 (UZI/AK-47/M4A1)");
	switch(animid) {
		case 1: ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.0, 0, 0, 0, 0, 0);
 		case 3: ApplyAnimation(playerid, "UZI", "UZI_reload", 4.0,0,0,0,0,0);
		default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/reload - 1 (Desert Eagle), 2 (SPAS12), 3 (UZI/AK-47/M4A1)");
 	}
 	return 1;
}

CMD:tag(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
    new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/tag [1-2]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "GRAFFITI", "graffiti_Chkout", 4.0, 0, 0, 0, 0, 0);
    	case 2: ApplyAnimation(playerid, "GRAFFITI", "spraycan_fire", 4.0, 0, 0, 0, 0, 0);
  		default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/tag [1-2]");
 	}
 	return 1;
}

CMD:deal(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	if(playerVariables[playerid][pEvent] == 1) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event.");
    new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/deal [1-2]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
  		default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/deal [1-2]");
 	}
 	return 1;
}

CMD:stopanim(playerid, params[]) {
	if(playerVariables[playerid][pFreezeType] == 0 && GetPlayerState(playerid) == 1 && playerVariables[playerid][pEvent] == 0) {
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
		TextDrawHideForPlayer(playerid, textdrawVariables[5]);
		SendClientMessage(playerid, COLOR_WHITE, "Animations cleared.");
		ClearAnimations(playerid);
		playerVariables[playerid][pAnimation] = 0;
		TogglePlayerControllable(playerid, 1);
	}
	else SendClientMessage(playerid, COLOR_GREY, "You can't do this right now.");
	return 1;
}

CMD:time(playerid, params[]) {
	new
	    time[3];

	gettime(time[0], time[1], time[2]);

	if(time[1] < 10) format(szMessage, sizeof(szMessage), "The current time is %d:0%d (%d seconds).", time[0], time[1], time[2]);
	else format(szMessage, sizeof(szMessage), "The current time is %d:%d (%d seconds).", time[0], time[1], time[2]);

	SendClientMessage(playerid, COLOR_WHITE, szMessage);

	format(szMessage, sizeof(szMessage), "Your next paycheck is due in %d minutes (%d seconds).", (3600-playerVariables[playerid][pSeconds])/60, (3600-playerVariables[playerid][pSeconds]));
	SendClientMessage(playerid, COLOR_WHITE, szMessage);

	if(playerVariables[playerid][pDropCarTimeout] >= 1) {
		format(szMessage, sizeof(szMessage), "You will be able to drop vehicles at the crane again in %d seconds (%d minutes).", playerVariables[playerid][pDropCarTimeout], playerVariables[playerid][pDropCarTimeout]/60);
		SendClientMessage(playerid, COLOR_WHITE, szMessage);
	}
	return 1;
}

CMD:crossarms(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
    new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/crossarms [1-4]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);
  		case 2: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
  		case 3: ApplyAnimation(playerid, "GRAVEYARD", "mrnM_loop", 4.0, 1, 0, 0, 0, 0);
  		case 4: ApplyAnimation(playerid, "GRAVEYARD", "prst_loopa", 4.0, 1, 0, 0, 0, 0);
  		default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/crossarms [1-4]");
 	}
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
 	return 1;
}

CMD:bat(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
	new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/bat [1-2]");
	switch(animid) {
		case 1: ApplyAnimation(playerid, "CRACK", "Bbalbat_Idle_01", 4.0, 1, 0, 0, 0, 0);
		case 2: ApplyAnimation(playerid, "CRACK", "Bbalbat_Idle_02", 4.0, 1, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/bat [1-2]");
 	}
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
 	return 1;
}

CMD:cheer(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
   	new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/cheer [1-8]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "ON_LOOKERS", "shout_01", 4.0, 0, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "ON_LOOKERS", "shout_02", 4.0, 0, 0, 0, 0, 0);
  		case 3: ApplyAnimation(playerid, "ON_LOOKERS", "shout_in", 4.0, 0, 0, 0, 0, 0);
  		case 4: ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY_B", 4.0, 1, 0, 0, 0, 0);
  		case 5: ApplyAnimation(playerid, "RIOT", "RIOT_CHANT", 4.0, 0, 0, 0, 0, 0);
  		case 6: ApplyAnimation(playerid, "RIOT", "RIOT_shout", 4.0, 0, 0, 0, 0, 0);
  		case 7: ApplyAnimation(playerid, "STRIP", "PUN_HOLLER", 4.0, 0, 0, 0, 0, 0);
  		case 8: ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.0, 0, 0, 0, 0, 0);
  		default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/cheer [1-8]");
 	}
   	return 1;
}

CMD:sit(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
   	new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/sit [1-6]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "BEACH", "bather", 4.0, 1, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.0, 1, 0, 0, 0, 0);
  		case 3: ApplyAnimation(playerid, "BEACH", "ParkSit_W_loop", 4.0, 1, 0, 0, 0, 0);
		case 4: ApplyAnimation(playerid, "BEACH", "SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0);
  		case 5: ApplyAnimation(playerid, "BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0);
  		case 6: ApplyAnimation(playerid, "PED", "SEAT_down", 4.0, 0, 1, 1, 1, 0);
  		default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/sit [1-6]");
 	}
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
 	return 1;
}

CMD:siteat(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
    new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/siteat [1-2]");
	switch(animid) {

		case 1: ApplyAnimation(playerid, "FOOD", "FF_Sit_Eat3", 4.0, 1, 0, 0, 0, 0);
		case 2: ApplyAnimation(playerid, "FOOD", "FF_Sit_Eat2", 4.0, 1, 0, 0, 0, 0);
  		default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/siteat [1-2]");
   	}
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
   	return 1;
}

CMD:bar(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
    new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/bar [1-5]");
	switch(animid) {

  		case 1: ApplyAnimation(playerid, "BAR", "Barcustom_get", 4.0, 0, 1, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "BAR", "Barserve_bottle", 4.0, 0, 0, 0, 0, 0);
  		case 3: ApplyAnimation(playerid, "BAR", "Barserve_give", 4.0, 0, 0, 0, 0, 0);
		case 4: ApplyAnimation(playerid, "BAR", "dnk_stndM_loop", 4.0, 0, 0, 0, 0, 0);
	    case 5: ApplyAnimation(playerid, "BAR", "BARman_idle", 4.0, 0, 0, 0, 0, 0);
  		default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/bar [1-5]");
 	}
   	return 1;
}

CMD:dance(playerid, params[]) {
    if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot.");
    if(playerVariables[playerid][pFreezeTime] != 0) return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed, or frozen.");
    new animid;
   	if(sscanf(params,"d",animid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/dance [1-4]");
	switch(animid) {

  		case 1: SetPlayerSpecialAction(playerid, 5);
	    case 2: SetPlayerSpecialAction(playerid, 6);
        case 3: SetPlayerSpecialAction(playerid, 7);
	    case 4: SetPlayerSpecialAction(playerid, 8);
  		default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/dance [style 1-4]");
	}
	TextDrawShowForPlayer(playerid, textdrawVariables[5]);
	playerVariables[playerid][pAnimation] = 1;
 	return 1;
}

CMD:cancelbackup(playerid, params[]) {
	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1) {
	    DeletePVar(playerid, "rB");
	    SendClientMessage(playerid, COLOR_WHITE, "You have canceled your backup request.");
	}
	return 1;
}

CMD:backup(playerid, params[]) {
	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1) {
		new
			string[113];

		GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

	    format(string, sizeof(string), "Dispatch: %s is requesting for immediate backup (( '/acceptbackup %d' to take the call )).", szPlayerName, playerid);
	    SendToGroup(playerVariables[playerid][pGroup], COLOR_RADIOCHAT, string);

	    SetPVarInt(playerid, "rB", 1); // Unlike the backup var (which will be called repeatedly) this will only be looked up when someone uses /acceptbackup.
	}
	return 1;
}

CMD:acceptbackup(playerid, params[]) {
	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1) {
		if(sscanf(params, "u", iTarget))
			SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/acceptbackup [playerid]");

		else if(playerVariables[iTarget][pStatus] == 1) {
			if(playerVariables[playerid][pCheckpoint] == 0 || playerVariables[playerid][pCheckpoint] == 5) {
				if(GetPVarInt(iTarget, "rB") == 1) {

					GetPlayerName(iTarget, szPlayerName, MAX_PLAYER_NAME);
					format(szMessage, sizeof(szMessage), "You have responded to %s's backup call.", szPlayerName);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);

					playerVariables[playerid][pCheckpoint] = 5;
					playerVariables[playerid][pBackup] = iTarget;

                    GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
					format(szMessage, sizeof(szMessage), "%s has responded to your backup call.", szPlayerName);
					SendClientMessage(iTarget, COLOR_WHITE, szMessage);
				}
				else SendClientMessage(playerid, COLOR_GREY, "Invalid backup call specified.");
			}
			else {
				format(szMessage, sizeof(szMessage), "You already have an active checkpoint (%s), reach it first, or /killcheckpoint.", getPlayerCheckpointReason(playerid));
				SendClientMessage(playerid, COLOR_GREY, szMessage);
			}
		}
		else SendClientMessage(playerid, COLOR_GREY, "Invalid backup call specified.");
	}
	return 1;
}

CMD:wt(playerid, params[]) {
    if(isnull(params))
        return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/wt [message]");

	else if(playerVariables[playerid][pFreezeType] > 0) {
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command while cuffed, tazed, or frozen.");
	}
    else switch(playerVariables[playerid][pWalkieTalkie]) {
		case -1: SendClientMessage(playerid, COLOR_GREY, "You don't have a walkie talkie.");
		case 0: SendClientMessage(playerid, COLOR_GREY, "You need to set a broadcast frequency first (using /setfrequency).");
		default: {
			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
			format(szMessage, sizeof(szMessage), "(Walkie Talkie) %s: %s", szPlayerName, params);
			SendToFrequency(playerVariables[playerid][pWalkieTalkie], COLOR_SMS, szMessage);
			format(szMessage ,sizeof(szMessage),"(radio) ''%s''", params);
			SetPlayerChatBubble(playerid, szMessage, COLOR_CHATBUBBLE, 10.0, 10000);
	    }
	}
	return 1;
}

CMD:setfrequency(playerid, params[]) {
	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/setfrequency [frequency] (0 to switch off).");

	else if(playerVariables[playerid][pWalkieTalkie] == -1) {
		return SendClientMessage(playerid, COLOR_GREY, "You don't have a walkie talkie.");
	}

	new
		walkieFreq = strval(params);

	if(walkieFreq < 0)
		return SendClientMessage(playerid, COLOR_GREY, "Invalid frequency specified.");

	else switch(walkieFreq) {
		case 0: {
			SendClientMessage(playerid, COLOR_GREY, "You have switched off your walkie talkie.");
			playerVariables[playerid][pWalkieTalkie] = 0;
		}
		default: {
			format(szMessage, sizeof(szMessage), "You are now broadcasting at the frequency of #%d khz.", walkieFreq);
			SendClientMessage(playerid, COLOR_WHITE, szMessage);
			playerVariables[playerid][pWalkieTalkie] = walkieFreq;
		}
	}
	return 1;
}

CMD:g(playerid, params[]) {
	return cmd_group(playerid, params);
}

CMD:group(playerid, params[]) {
	if(playerVariables[playerid][pStatus] != 1 || playerVariables[playerid][pGroup] < 1)
		return SendClientMessage(playerid, COLOR_GREY, "Your group data is invalid.");

	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1 || groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 2)
	    return SendClientMessage(playerid, COLOR_GREY, "This group does not have an OOC chat.");

	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/g(roup) [message]");

	if(playerVariables[playerid][pFreezeType] > 0)
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command while cuffed, tazed, or frozen.");

 	GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

	switch(playerVariables[playerid][pGroupRank]) {
		case 1:	format(szMessage, sizeof(szMessage), "(Group Chat) %s %s: %s", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName1], szPlayerName, params);
		case 2:	format(szMessage, sizeof(szMessage), "(Group Chat) %s %s: %s", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName2], szPlayerName, params);
		case 3:	format(szMessage, sizeof(szMessage), "(Group Chat) %s %s: %s", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName3], szPlayerName, params);
		case 4:	format(szMessage, sizeof(szMessage), "(Group Chat) %s %s: %s", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName4], szPlayerName, params);
		case 5:	format(szMessage, sizeof(szMessage), "(Group Chat) %s %s: %s", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName5], szPlayerName, params);
		case 6:	format(szMessage, sizeof(szMessage), "(Group Chat) %s %s: %s", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName6], szPlayerName, params);
		default: format(szMessage, sizeof(szMessage), "(Group Chat) %s %s: %s", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName1], szPlayerName, params);
	}

    SendToGroup(playerVariables[playerid][pGroup], COLOR_DCHAT, szMessage);
	return 1;
}

CMD:r(playerid, params[]) {
	return cmd_radio(playerid, params);
}

CMD:radio(playerid, params[]) {
	if(playerVariables[playerid][pStatus] != 1 || playerVariables[playerid][pGroup] < 1)
		return SendClientMessage(playerid, COLOR_GREY, "Your group data is invalid.");

	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] != 1 && groupVariables[playerVariables[playerid][pGroup]][gGroupType] != 2) {
	    return SendClientMessage(playerid, COLOR_GREY, "This group does not have an official radio frequency.");
	}

	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/g(roup) [message]");

	if(playerVariables[playerid][pFreezeType] > 0)
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command while cuffed, tazed, or frozen.");

	GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

	switch(playerVariables[playerid][pGroupRank]) {
		case 1:	format(szMessage, sizeof(szMessage), "** %s %s: %s, over.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName1], szPlayerName, params);
		case 2:	format(szMessage, sizeof(szMessage), "** %s %s: %s, over.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName2], szPlayerName, params);
		case 3:	format(szMessage, sizeof(szMessage), "** %s %s: %s, over.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName3], szPlayerName, params);
		case 4:	format(szMessage, sizeof(szMessage), "** %s %s: %s, over.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName4], szPlayerName, params);
		case 5:	format(szMessage, sizeof(szMessage), "** %s %s: %s, over.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName5], szPlayerName, params);
		case 6:	format(szMessage, sizeof(szMessage), "** %s %s: %s, over.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName6], szPlayerName, params);
		default: format(szMessage, sizeof(szMessage), "** %s %s: %s, over.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName1], szPlayerName, params);
	}

    SendToGroup(playerVariables[playerid][pGroup], COLOR_RADIOCHAT, szMessage);
    format(szMessage, sizeof(szMessage),"(radio) ''%s''", params);
    SetPlayerChatBubble(playerid, szMessage, COLOR_CHATBUBBLE, 10.0, 10000);
	return 1;
}

CMD:d(playerid, params[]) {
	return cmd_department(playerid, params);
}

CMD:department(playerid, params[]) {
	if(playerVariables[playerid][pStatus] != 1 || playerVariables[playerid][pGroup] < 1)
		return SendClientMessage(playerid, COLOR_GREY, "Your group data is invalid.");

	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] != 1 && groupVariables[playerVariables[playerid][pGroup]][gGroupType] != 2) {
	    return SendClientMessage(playerid, COLOR_GREY, "This group does not have an official radio frequency.");
	}

	if(playerVariables[playerid][pFreezeType] > 0) {
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command while cuffed, tazed, or frozen.");
	}

	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/d(epartment) [message]");

 	GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

	switch(playerVariables[playerid][pGroupRank]) {
		case 1:	format(szMessage, sizeof(szMessage), "*** %s %s: %s, over.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName1], szPlayerName, params);
		case 2:	format(szMessage, sizeof(szMessage), "*** %s %s: %s, over.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName2], szPlayerName, params);
		case 3:	format(szMessage, sizeof(szMessage), "*** %s %s: %s, over.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName3], szPlayerName, params);
		case 4:	format(szMessage, sizeof(szMessage), "*** %s %s: %s, over.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName4], szPlayerName, params);
		case 5:	format(szMessage, sizeof(szMessage), "*** %s %s: %s, over.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName5], szPlayerName, params);
		case 6:	format(szMessage, sizeof(szMessage), "*** %s %s: %s, over.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName6], szPlayerName, params);
		default: format(szMessage, sizeof(szMessage), "*** %s %s: %s, over.", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName1], szPlayerName, params);
	}

    sendDepartmentMessage(COLOR_DCHAT, szMessage);
    format(szMessage, sizeof(szMessage), "(radio) ''%s''",params);
    SetPlayerChatBubble(playerid, szMessage, COLOR_CHATBUBBLE, 10.0, 10000);
	return 1;
}

CMD:unsuspendbank(playerid, params[]) {
	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 2 && playerVariables[playerid][pGroup] != 0) {
		if(playerVariables[playerid][pGroupRank] > 4) {
		    if(isnull(params))
		        return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/unsuspendbank [player name]");

			strcpy(szPlayerName, params, MAX_PLAYER_NAME);
			mysql_real_escape_string(szPlayerName, szPlayerName);

		    iTarget = getIdFromName(szPlayerName);

			if(iTarget == -1)
				return SendClientMessage(playerid, COLOR_GREY, "Error attempting to retrieve an ID from the name.");

			format(szQueryOutput, sizeof(szQueryOutput), "DELETE FROM `banksuspensions` WHERE `playerID` = %d", iTarget);
			mysql_query(szQueryOutput);

			foreach(Player, x) {
				if(playerVariables[x][pInternalID] == iTarget) {
					DeletePVar(x, "BSuspend");
					DeletePVar(x, "BSuspendee");
				}
			}

			format(szMessage, sizeof(szMessage), "You've unsuspended %s's account.", szPlayerName);
			SendClientMessage(playerid, COLOR_WHITE, szMessage);
		}
	}
	return 1;
}

CMD:suspendbank(playerid, params[]) {
	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 2 && playerVariables[playerid][pGroup] != 0) {
		if(playerVariables[playerid][pGroupRank] > 4) {
		    new
		        szReason[64];

		    if(sscanf(params, "us[64]", iTarget, szReason))
		        return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/suspendbank [playerid] [reason]");

            if(playerVariables[iTarget][pGroupRank] > 4 && groupVariables[playerVariables[iTarget][pGroup]][gGroupType] != 0)
                return SendClientMessage(playerid, COLOR_GREY, "Clearance failure.");

			mysql_real_escape_string(szReason, szReason);
			format(szQueryOutput, sizeof(szQueryOutput), "INSERT INTO `banksuspensions` (`suspendeeID`, `playerID`, `suspensionReason`) VALUES(%d, %d, '%e')", playerVariables[playerid][pInternalID], playerVariables[iTarget][pInternalID], szReason);
			mysql_query(szQueryOutput);

			SetPVarString(iTarget, "BSuspend", szReason);

			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
			SetPVarString(iTarget, "BSuspendee", szPlayerName);

			GetPlayerName(iTarget, szPlayerName, MAX_PLAYER_NAME);
			format(szMessage, sizeof(szMessage), "You have successfully suspended the bank account of %s.", szPlayerName);
			SendClientMessage(playerid, COLOR_WHITE, szMessage);
		}
	}

	return 1;
}

CMD:taxrate(playerid, params[]) {
	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 2 && playerVariables[playerid][pGroup] != 0) {
		if(playerVariables[playerid][pGroupRank] > 4) {
			if(!isnull(params)) {

			    new rate = strval(params);

			    if(rate > 0 && rate <= 50) {

				    new string[41];
				    format(string,sizeof(string),"You have set the tax rate to %d percent.",rate);
					SendClientMessage(playerid, COLOR_WHITE, string);
				    assetVariables[1][aAssetValue] = rate;

					saveAsset(1);
			    }
			    else SendClientMessage(playerid, COLOR_GREY, "The tax rate must be between 1 and 50 percent.");
			}
			else SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/taxrate [percentage]");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You're not authorised to do this.");
	}
	return 1;
}

CMD:gov(playerid, params[]) {

	new
		string[128];

	if(isnull(params)) SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/gov [message]");

	else if((groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1 || groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 2) && playerVariables[playerid][pGroupRank] > 4)
	{
		format(string, sizeof(string), "------ Government Announcement (%s) ------", groupVariables[playerVariables[playerid][pGroup]][gGroupName]);
		SendClientMessageToAll(COLOR_TEAL, string);

		GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
		switch(playerVariables[playerid][pGroupRank]) {
			case 5: format(string, sizeof(string), "* %s %s: %s", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName5], szPlayerName, params);
			case 6: format(string, sizeof(string), "* %s %s: %s", groupVariables[playerVariables[playerid][pGroup]][gGroupRankName6], szPlayerName, params);
		}
		SendClientMessageToAll(COLOR_WHITE, string);
		format(string, sizeof(string), "------ Government Announcement (%s) ------", groupVariables[playerVariables[playerid][pGroup]][gGroupName]);
		SendClientMessageToAll(COLOR_TEAL, string);
	}
	return 1;
}

CMD:bbalance(playerid, params[]) {
	if(getPlayerBusinessID(playerid) >= 1) {
	    new
	        businessID = getPlayerBusinessID(playerid);

	    format(szMessage, sizeof(szMessage), "Business Vault Balance: $%d.", businessVariables[businessID][bVault]);
	    SendClientMessage(playerid, COLOR_WHITE, szMessage);
	}
	return 1;
}

CMD:gdeposit(playerid, params[])
{
    if(playerVariables[playerid][pStatus] != 1) return 1;
    if(playerVariables[playerid][pGroup] != 0) {

		new
			item[9],
			string[64],
			amount;

		if(sscanf(params, "sd", item, amount)) {
			SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/gdeposit [money/materials] [amount]");

			format(string, sizeof(string), "Safe balance: $%d, %d materials.", groupVariables[playerVariables[playerid][pGroup]][gSafe][0], groupVariables[playerVariables[playerid][pGroup]][gSafe][1]);
			SendClientMessage(playerid, COLOR_GREY, string);
		}
		else {
		    if(amount > 0) {
			    if(IsPlayerInRangeOfPoint(playerid, 5.0, groupVariables[playerVariables[playerid][pGroup]][gSafePos][0], groupVariables[playerVariables[playerid][pGroup]][gSafePos][1], groupVariables[playerVariables[playerid][pGroup]][gSafePos][2])) {
			        if(strcmp(item, "money", true) == 0) {
						if(playerVariables[playerid][pMoney] >= amount) {
					    	playerVariables[playerid][pMoney] -= amount;
					    	groupVariables[playerVariables[playerid][pGroup]][gSafe][0] += amount;
					    	format(string, sizeof(string), "You have deposited $%d in your group safe.", amount);
				    		SendClientMessage(playerid, COLOR_WHITE, string);
				    		saveGroup(playerVariables[playerid][pGroup]);

							GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
							format(string, sizeof(string), "* %s deposits $%d in their group safe.", szPlayerName, amount);
							nearByMessage(playerid, COLOR_PURPLE, string);
						}
						else {
					    	SendClientMessage(playerid, COLOR_WHITE, "You don't have that amount of money.");
						}
					}
					else if(strcmp(item, "materials", true) == 0 ) {
						if(playerVariables[playerid][pMaterials] >= amount) {
					    	playerVariables[playerid][pMaterials] -= amount;
					    	groupVariables[playerVariables[playerid][pGroup]][gSafe][1] += amount;
					    	format(string, sizeof(string), "You have deposited %d materials in your group safe.", amount);
				    		SendClientMessage(playerid, COLOR_WHITE, string);
				    		saveGroup(playerVariables[playerid][pGroup]);

							GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
							format(string, sizeof(string), "* %s deposits %d materials in their group safe.", szPlayerName, amount);
							nearByMessage(playerid, COLOR_PURPLE, string);
						}
						else {
					    	SendClientMessage(playerid, COLOR_WHITE, "You don't have that amount of materials.");
						}
					}
				}
				else {
				    SendClientMessage(playerid, COLOR_WHITE, "You must be at your group safe to do this.");
				}
			}
		}
	}
	return 1;
}

CMD:accepthelp(playerid, params[]) {
    if(playerVariables[playerid][pHelper] >= 1) {
        if(sscanf(params, "u", iTarget))
            return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/accepthelp [playerid]");

        else {
            if(iTarget == INVALID_PLAYER_ID)
				return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");

            if(GetPVarType(iTarget, "hR") == 0)
				return SendClientMessage(playerid, COLOR_GREY, "The specified playerid/name does not have an active help request.");

            new
                helpString[64];

            GetPVarString(iTarget, "hR", helpString, sizeof(helpString));

            GetPlayerName(iTarget, szPlayerName, MAX_PLAYER_NAME);

            format(szMessage, sizeof(szMessage), "You have accepted %s's help request (%s).", szPlayerName, helpString);
            SendClientMessage(playerid, COLOR_WHITE, szMessage);

            playerVariables[playerid][pOnRequest] = iTarget; // PVar lookup time is slower, better to use a variable for this.

            TextDrawShowForPlayer(playerid, textdrawVariables[1]);

            DeletePVar(iTarget, "hR");

            GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
            format(szMessage, sizeof(szMessage), "%s has accepted your help request.", szPlayerName);
            SendClientMessage(iTarget, COLOR_NEWBIE, szMessage);
        }
    }
	return 1;
}

CMD:viewhelp(playerid, params[]) {
    if(playerVariables[playerid][pHelper] >= 1) {
        SendClientMessage(playerid, COLOR_TEAL, "---------------------------------------------------------------------------------------------------------------------------------");
        foreach(Player, x) {
			if(GetPVarType(x, "hR") != 0) {
			    GetPVarString(x, "hR", szMediumString, sizeof(szMediumString));
				format(szMessage, sizeof(szMessage), "Requested by: %s | Problem: %s", playerVariables[x][pNormalName], szMediumString);
				SendClientMessage(playerid, COLOR_WHITE, szMessage);
			}
		}
        SendClientMessage(playerid, COLOR_TEAL, "---------------------------------------------------------------------------------------------------------------------------------");
	}
	return 1;
}

CMD:helpme(playerid, params[]) {
	if(playerVariables[playerid][pPlayingHours] < 20) {
	    if(isnull(params))
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/helpme [subject]");
			
	    if(strlen(params) >= 63) {
			return SendClientMessage(playerid, COLOR_GREY, "Your message was too long. 62 characters or lower, only.");
		} else {
			SetPVarString(playerid, "hR", params);
			SendClientMessage(playerid, COLOR_WHITE, "Your request has been sent. Please wait a few minutes, our helpers have a lot to deal with!");

			new
			    string[128];

			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

			format(string, sizeof(string), "A new help request from %s (ID: %d) has been submitted.", szPlayerName);

			foreach(Player, x) {
				if(playerVariables[x][pHelperDuty] >= 1 && playerVariables[x][pHelper] >= 1) {
					SendClientMessage(x, COLOR_NEWBIE, string);
				}
			}
		}
	}
	else {
		return SendClientMessage(playerid, COLOR_GREY, "You already have 20+ playing hours. You are unable to get help from a helper, please use /n for your questions.");
	}

	return 1;
}

CMD:helperduty(playerid, params[]) {
	if(playerVariables[playerid][pHelper] >= 1) {
	    switch(playerVariables[playerid][pHelperDuty]) {
			case 0: {
				playerVariables[playerid][pHelperDuty] = 1;
				SendClientMessage(playerid, COLOR_WHITE, "You are now on duty as a Helper.");
			}
			case 1: {
				playerVariables[playerid][pHelperDuty] = 0;
				SendClientMessage(playerid, COLOR_WHITE, "You are now off duty as a Helper.");
			}
		}
	}
	return 1; //
}

CMD:vgroup(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 4) {
	    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You must be inside the vehicle that you wish to alter the group requirement of.");

		new
			string[96],
		    groupParam = strval(params);

		if(groupParam < 0 || groupParam > MAX_GROUPS) return SendClientMessage(playerid, COLOR_GREY, "Invalid group ID.");

        for(new x = 0; x < MAX_VEHICLES; x++) {
            if(vehicleVariables[x][vVehicleScriptID] == GetPlayerVehicleID(playerid)) {
                vehicleVariables[x][vVehicleGroup] = groupParam;

                saveVehicle(x);

                switch(groupParam) {

					case 0: format(string, sizeof(string), "You have removed group restrictions from this vehicle (%d).", x);
					default: format(string, sizeof(string), "You have changed this vehicle's group to %s (vehicle %d).", groupVariables[groupParam][gGroupName], x);
				}
				SendClientMessage(playerid, COLOR_WHITE, string);
				return 1;
			}
        }
	}
	return 1;
}

CMD:vcolour(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 4) {
	    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You must be inside the vehicle that you wish to alter the colour of.");

		new
			string[80],
		    colour1,
			colour2;

		if(sscanf(params,"dd", colour1, colour2)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/vcolour [colour 1] [colour 2]");

        for(new x = 0; x < MAX_VEHICLES; x++) {
            if(vehicleVariables[x][vVehicleScriptID] == GetPlayerVehicleID(playerid)) {
                vehicleVariables[x][vVehicleColour][0] = colour1;
				vehicleVariables[x][vVehicleColour][1] = colour2;

				ChangeVehicleColor(vehicleVariables[x][vVehicleScriptID], vehicleVariables[x][vVehicleColour][0], vehicleVariables[x][vVehicleColour][1]);

                saveVehicle(x);

				format(string, sizeof(string), "You have changed this vehicle's colour combination to %d, %d (vehicle %d).", colour1, colour2, x);
				SendClientMessage(playerid, COLOR_WHITE, string);
				return 1;
			}
        }
	}
	return 1;
}

CMD:vrespawn(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 1 && IsPlayerInAnyVehicle(playerid)) SetVehicleToRespawnEx(GetPlayerVehicleID(playerid));
	return 1;
}

CMD:vmassrespawn(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 4) {
		SetAllVehiclesToRespawn();
		SendClientMessage(playerid, COLOR_WHITE, "All vehicles have been respawned.");
	}
	return 1;
}

CMD:vmodel(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 4) {
		if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/vmodel [modelid]");
		else if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You must be inside the vehicle that you wish to change the model of.");
		else if(strval(params) < 400 || strval(params) > 611) return SendClientMessage(playerid, COLOR_WHITE, "Valid car IDs start at 400, and end at 611.");

		new
			string[64];

        for(new x = 0; x < MAX_VEHICLES; x++) {
            if(vehicleVariables[x][vVehicleScriptID] == GetPlayerVehicleID(playerid)) {

				vehicleVariables[x][vVehicleModelID] = strval(params);

				DestroyVehicle(vehicleVariables[x][vVehicleScriptID]);
				vehicleVariables[x][vVehicleScriptID] = CreateVehicle(vehicleVariables[x][vVehicleModelID], vehicleVariables[x][vVehiclePosition][0], vehicleVariables[x][vVehiclePosition][1], vehicleVariables[x][vVehiclePosition][2], vehicleVariables[x][vVehicleRotation], vehicleVariables[x][vVehicleColour][0], vehicleVariables[x][vVehicleColour][1], 60000);
				PutPlayerInVehicle(playerid, vehicleVariables[x][vVehicleScriptID], 0);

                saveVehicle(x);

				format(string, sizeof(string), "You have successfully changed vehicle %d to a %s.", x, VehicleNames[vehicleVariables[x][vVehicleModelID] - 400]);
				SendClientMessage(playerid, COLOR_WHITE, string);
				return 1;
			}
        }
	}
	return 1;
}

CMD:vmove(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 4) {
	    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You must be inside the vehicle that you wish to move.");

		new
			string[42];

        for(new x = 0; x < MAX_VEHICLES; x++) {
            if(vehicleVariables[x][vVehicleScriptID] == GetPlayerVehicleID(playerid)) {

                GetVehiclePos(x, vehicleVariables[x][vVehiclePosition][0], vehicleVariables[x][vVehiclePosition][1], vehicleVariables[x][vVehiclePosition][2]);
				GetVehicleZAngle(x, vehicleVariables[x][vVehicleRotation]);

				DestroyVehicle(vehicleVariables[x][vVehicleScriptID]);
				vehicleVariables[x][vVehicleScriptID] = CreateVehicle(vehicleVariables[x][vVehicleModelID], vehicleVariables[x][vVehiclePosition][0], vehicleVariables[x][vVehiclePosition][1], vehicleVariables[x][vVehiclePosition][2], vehicleVariables[x][vVehicleRotation], vehicleVariables[x][vVehicleColour][0], vehicleVariables[x][vVehicleColour][1], 60000);
				PutPlayerInVehicle(playerid, vehicleVariables[x][vVehicleScriptID], 0);

                saveVehicle(x);

				format(string, sizeof(string), "You have successfully moved vehicle %d.", x);
				SendClientMessage(playerid, COLOR_WHITE, string);
				return 1;
			}
        }
	}
	return 1;
}

CMD:ad(playerid, params[]) {
	if(!isnull(params)) {
		if(playerVariables[playerid][pPhoneNumber] != -1) {
		    if(adTick == 0) {
				if(playerVariables[playerid][pMoney] >= 1000) {
					new
						adText[128],
						queryString[255];

					mysql_real_escape_string(params, adText);
					format(queryString, sizeof(queryString), "INSERT INTO playeradvertisements (playerID, advertisementText, Time2) VALUES('%d', '%s', '%d')", playerVariables[playerid][pInternalID], adText, gettime());
					mysql_query(queryString);

					GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
					format(queryString, sizeof(queryString), "Advertisement: %s (by %s).", params, szPlayerName);
					SendClientMessageToAll(COLOR_GREEN, queryString);
					playerVariables[playerid][pMoney] -= 1000;
					adTick = 60;
				}
				else SendClientMessage(playerid, COLOR_GREY, "You don't have enough money for this.");
		    }
		    else {
				return SendClientMessage(playerid, COLOR_GREY, "You must wait 60 seconds to post a global advertisement.");
			}
		}
		else {
			return SendClientMessage(playerid, COLOR_GREY, "You don't have a phone, so you're unable to submit an advertisement.");
		}
	}
	else {
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/ad [advertisement text]");
	}
	return 1;
}

CMD:deployspike(playerid, params[]) { // Same method as old VX script, though recoded.
	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1) {
		if(GetPlayerState(playerid) == 1) {

			new
				x = -1,
				string[76];

			for(new i; i < MAX_SPIKES; i++) {
				if(spikeVariables[i][sPos][0] == 0 && spikeVariables[i][sPos][1] == 0 && spikeVariables[i][sPos][2] == 0) {
					x = i;
					break;
				}
			}

			if(x != -1) {

				GetPlayerPos(playerid, spikeVariables[x][sPos][0], spikeVariables[x][sPos][1], spikeVariables[x][sPos][2]);
				GetPlayerFacingAngle(playerid, spikeVariables[x][sPos][3]);

				spikeVariables[x][sObjID] = CreateDynamicObject(2899, spikeVariables[x][sPos][0], spikeVariables[x][sPos][1], spikeVariables[x][sPos][2] - 0.8, 0.0, 0.0, spikeVariables[x][sPos][3], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), -1, 200.0);
				GetPlayerName(playerid, spikeVariables[x][sDeployer], MAX_PLAYER_NAME);

				format(string, sizeof(string),"You have successfully deployed a spike (ID %d).", x);
				SendClientMessage(playerid, COLOR_WHITE, string);
			}
			else {

				format(string, sizeof(string), "No more spike strips can be deployed (the limit is %d). Destroy some first.", MAX_SPIKES);
				SendClientMessage(playerid, COLOR_GREY, string);
			}
		}
		else SendClientMessage(playerid, COLOR_GREY, "You can only deploy spikes while on foot.");
	}
	return 1;
}

CMD:destroyspike(playerid, params[]) {
	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1) {

		new
			targetID,
			string[75];

		if(!isnull(params)) {

			targetID = strval(params);

			if(spikeVariables[targetID][sPos][0] != 0 && spikeVariables[targetID][sPos][1] != 0 && spikeVariables[targetID][sPos][2] != 0) {

				DestroyDynamicObject(spikeVariables[targetID][sObjID]);

				for(new i; i < 4; i++) spikeVariables[targetID][sPos][i] = 0;

				spikeVariables[targetID][sObjID] = INVALID_OBJECT_ID;
				format(spikeVariables[targetID][sDeployer], MAX_PLAYER_NAME, "(null)");

				format(string, sizeof(string), "You have successfully destroyed spike ID %d.", targetID);
				SendClientMessage(playerid, COLOR_WHITE, string);
			}
			else SendClientMessage(playerid, COLOR_GREY, "Invalid spike specified.");
		}
		else SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/destroyspike [spike]");
	}
	return 1;
}

CMD:spikes(playerid, params[]) {

	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1 && playerVariables[playerid][pGroupRank] >= 4) {

		new
			dString[128],
			sZone[MAX_ZONE_NAME],
			x,
			y;

		SendClientMessage(playerid, COLOR_TEAL, "---------------------------------------------------------------------------------------------------------------------------------");
		SendClientMessage(playerid, COLOR_WHITE, "Deployed spike strips:");
		for(new i; i < MAX_SPIKES; i++) {
			if(spikeVariables[i][sPos][0] != 0 && spikeVariables[i][sPos][1] != 0 && spikeVariables[i][sPos][2] != 0) {

				Get2DPosZone(spikeVariables[i][sPos][0], spikeVariables[i][sPos][1], sZone, MAX_ZONE_NAME); // Edited a_zones function (GET INCLUDE FROM SVN!!1)
				y++;
				if(x == 0) format(dString, sizeof(dString), "ID %d (%s, deployed by %s)", i, sZone, spikeVariables[i][sDeployer]);
				else format(dString, sizeof(dString), "%s | ID %d (%s, deployed by %s)", dString, i, sZone, spikeVariables[i][sDeployer]);
				x++;

				if(x == 2) {
					SendClientMessage(playerid, COLOR_WHITE, dString);
					x = 0;
				}
			}
		}
		if(x == 1) SendClientMessage(playerid, COLOR_WHITE, dString);
		if(y == 0) SendClientMessage(playerid, COLOR_WHITE, "No spike strips are currently deployed.");
		SendClientMessage(playerid, COLOR_TEAL, "---------------------------------------------------------------------------------------------------------------------------------");
	}
	return 1;
}

CMD:confiscate(playerid, params[])
{
	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1) {
		new
			targetID,
			string[128],
			item[12],
			playerNames[2][MAX_PLAYER_NAME];

		if(sscanf(params, "us[12]", targetID, item)) {
			SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/confiscate [playerid] [item]");
			SendClientMessage(playerid, COLOR_GREY, "Items: Materials, Phone, Weapons");
		}
		else if(IsPlayerAuthed(targetID)){
			if(IsPlayerInRangeOfPlayer(playerid, targetID, 3.0)) {
				if(playerVariables[targetID][pFreezeType] == 2 || playerVariables[targetID][pFreezeType] == 4 || (GetPlayerSpecialAction(targetID) == SPECIAL_ACTION_HANDSUP && playerVariables[targetID][pFreezeType] == 0)) {
					if(!strcmp(item, "materials", true)) {
						if(playerVariables[targetID][pMaterials] >= 1) {

							GetPlayerName(playerid, playerNames[0], MAX_PLAYER_NAME);
							GetPlayerName(targetID, playerNames[1], MAX_PLAYER_NAME);

							format(string, sizeof(string), "* %s has confiscated %d materials from %s.", playerNames[0], playerVariables[targetID][pMaterials], playerNames[1]);
							nearByMessage(playerid, COLOR_PURPLE, string);

							format(string, sizeof(string), "%s has confiscated your materials.", playerNames[0]);
							SendClientMessage(targetID, COLOR_WHITE, string);

							format(string, sizeof(string), "You have confiscated %s's materials (%d).", playerNames[1], playerVariables[targetID][pMaterials]);
							SendClientMessage(playerid, COLOR_WHITE, string);

							playerVariables[playerid][pMaterials] += playerVariables[targetID][pMaterials];
							playerVariables[targetID][pMaterials] = 0;
						}
						else SendClientMessage(playerid, COLOR_GREY, "This player has no materials to confiscate.");

					}
					else if(!strcmp(item, "weapons", true)) {

						GetPlayerName(playerid, playerNames[0], MAX_PLAYER_NAME);
						GetPlayerName(targetID, playerNames[1], MAX_PLAYER_NAME);

						format(string, sizeof(string), "* %s has confiscated %s's weapons.", playerNames[0], playerNames[1]);
						nearByMessage(playerid, COLOR_PURPLE, string);

						format(string, sizeof(string), "%s has confiscated your weapons.", playerNames[0]);
						SendClientMessage(targetID, COLOR_WHITE, string);

						format(string, sizeof(string), "You have confiscated %s's weapons.", playerNames[1]);
						SendClientMessage(playerid, COLOR_WHITE, string);

						validResetPlayerWeapons(targetID);
					}
					else if(!strcmp(item, "phone", true)) {
						if(playerVariables[targetID][pPhoneNumber] != -1) {

							GetPlayerName(playerid, playerNames[0], MAX_PLAYER_NAME);
							GetPlayerName(targetID, playerNames[1], MAX_PLAYER_NAME);

							format(string, sizeof(string), "* %s has confiscated %s's phone.", playerNames[0], playerNames[1]);
							nearByMessage(playerid, COLOR_PURPLE, string);

							format(string, sizeof(string), "%s has confiscated your phone.", playerNames[0]);
							SendClientMessage(targetID, COLOR_WHITE, string);

							format(string, sizeof(string), "You have confiscated %s's phone.", playerNames[1]);
							SendClientMessage(playerid, COLOR_WHITE, string);

							playerVariables[targetID][pPhoneNumber] = -1;
						}
						else SendClientMessage(playerid, COLOR_GREY, "This player has no phone to confiscate.");
					}
					else SendClientMessage(playerid, COLOR_GREY, "Invalid item specified.");
				}
				else SendClientMessage(playerid, COLOR_GREY, "That person must first be subdued, or have their hands up.");
			}
			else SendClientMessage(playerid, COLOR_GREY, "You're too far away.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
	}
	return 1;
}

CMD:gwithdraw(playerid, params[]) {
    if(playerVariables[playerid][pStatus] != 1) return 1;
    if(playerVariables[playerid][pGroup] != 0 && playerVariables[playerid][pGroupRank] >= 5) {

		new
			item[9],
			string[64],
			amount;

		if(sscanf(params, "sd", item, amount)) {
			SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/gwithdraw [money/materials] [amount]");

			format(string, sizeof(string), "Safe balance: $%d, %d materials.", groupVariables[playerVariables[playerid][pGroup]][gSafe][0], groupVariables[playerVariables[playerid][pGroup]][gSafe][1]);
			SendClientMessage(playerid, COLOR_GREY, string);
		}
		else {
		    if(amount > 0) {
			    if(IsPlayerInRangeOfPoint(playerid, 5.0, groupVariables[playerVariables[playerid][pGroup]][gSafePos][0], groupVariables[playerVariables[playerid][pGroup]][gSafePos][1], groupVariables[playerVariables[playerid][pGroup]][gSafePos][2])) {
			        if(strcmp(item, "money", true) == 0) {
						if(groupVariables[playerVariables[playerid][pGroup]][gSafe][0] >= amount) {
					    	playerVariables[playerid][pMoney] += amount;
					    	groupVariables[playerVariables[playerid][pGroup]][gSafe][0] -= amount;
					    	format(string, sizeof(string), "You have withdrawn $%d from your group safe.", amount);
				    		SendClientMessage(playerid, COLOR_WHITE, string);
				    		saveGroup(playerVariables[playerid][pGroup]);

							GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
							format(string, sizeof(string), "* %s withdraws $%d from their group safe.", szPlayerName, amount);
							nearByMessage(playerid, COLOR_PURPLE, string);
						}
						else {
					    	SendClientMessage(playerid, COLOR_WHITE, "You don't have that amount of money in your group safe.");
						}
					}
					else if(strcmp(item, "materials", true) == 0 ) {
						if(groupVariables[playerVariables[playerid][pGroup]][gSafe][1] >= amount) {
					    	playerVariables[playerid][pMaterials] += amount;
					    	groupVariables[playerVariables[playerid][pGroup]][gSafe][1] -= amount;
					    	format(string, sizeof(string), "You have withdrawn %d materials from your group safe.", amount);
				    		SendClientMessage(playerid, COLOR_WHITE, string);
				    		saveGroup(playerVariables[playerid][pGroup]);

							GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
							format(string, sizeof(string), "* %s withdraws %d materials from their group safe.", szPlayerName, amount);
							nearByMessage(playerid, COLOR_PURPLE, string);
						}
						else {
					    	SendClientMessage(playerid, COLOR_WHITE, "Your don't have that amount of materials in your group safe.");
						}
					}
				}
				else {
				    SendClientMessage(playerid, COLOR_WHITE, "You must be at your group safe to do this.");
				}
			}
		}
	}
	return 1;
}

CMD:killcheckpoint(playerid, params[]) {
	DisablePlayerCheckpoint(playerid);
	playerVariables[playerid][pCheckpoint] = 0;
	playerVariables[playerid][pBackup] = -1;
	SendClientMessage(playerid, COLOR_WHITE,"You have disabled your current checkpoint.");
	return 1;
}

CMD:quitevent(playerid, params[]) {

	if(playerVariables[playerid][pEvent] >= 1) {
		if(eventVariables[eEventStat] == 1) {

			new
				string[128];

			TogglePlayerControllable(playerid, true);

			ResetPlayerWeapons(playerid);
			givePlayerWeapons(playerid);

			SetPlayerPos(playerid, playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2]);
			SetPlayerInterior(playerid, playerVariables[playerid][pInterior]);
			SetPlayerVirtualWorld(playerid, playerVariables[playerid][pVirtualWorld]);
			SetPlayerSkin(playerid, playerVariables[playerid][pSkin]);
			SetCameraBehindPlayer(playerid);

			if(playerVariables[playerid][pAdminDuty] == 1) {
				SetPlayerHealth(playerid, 500000.0);
			}
			else {
				SetPlayerHealth(playerid, playerVariables[playerid][pHealth]);
				SetPlayerArmour(playerid, playerVariables[playerid][pArmour]);
			}

			SendClientMessage(playerid, COLOR_WHITE, "You have quit the event.");
			playerVariables[playerid][pEvent] = 0;
			eventVariables[eEventCount]--;

    	    format(string, sizeof(string), "%s has left the event (quit). %d participants remain.", playerVariables[playerid][pNormalName], eventVariables[eEventCount]);
			SendToEvent(COLOR_YELLOW, string);
		}
		else SendClientMessage(playerid, COLOR_WHITE, "The event has already begun - it's too late to quit.");
	}
	else SendClientMessage(playerid, COLOR_WHITE, "You're not in an event.");
	return 1;
}

CMD:swatinv(playerid,params[]) {
	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1 && playerVariables[playerid][pGroup] != 0) {

		if(playerVariables[playerid][pGroupRank] > 3) {
			new string[64];
			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
			if(groupVariables[playerVariables[playerid][pGroup]][gswatInv] == 0) {
				groupVariables[playerVariables[playerid][pGroup]][gswatInv] = 1;
				format(string, sizeof(string), "The SWAT inventory has been enabled by %s.", szPlayerName);
				SendToGroup(playerVariables[playerid][pGroup], COLOR_HOTORANGE, string);
			}
			else {
				groupVariables[playerVariables[playerid][pGroup]][gswatInv] = 0;
				format(string, sizeof(string), "The SWAT inventory has been disabled by %s.", szPlayerName);
				SendToGroup(playerVariables[playerid][pGroup], COLOR_HOTORANGE, string);
			}
		}
	}
	return 1;
}

CMD:tazer(playerid, params[]) {
	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1 && playerVariables[playerid][pGroup] != 0) {
	    switch(playerVariables[playerid][pTazer]) {
			case 0: {
			    givePlayerValidWeapon(playerid, 22);
			    playerVariables[playerid][pTazer] = 1;
			}
			case 1: {
			    removePlayerWeapon(playerid, 22);
			    playerVariables[playerid][pTazer] = 0;
			}
		}
	}
	return 1;
}

CMD:taser(playerid, params[]) {
	return cmd_tazer(playerid, params);
}

CMD:setplayervehicle(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 3) {
		new
			string[64],
		    carModelID,
		    targetID;

		if(sscanf(params, "ud", targetID, carModelID)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/setplayervehicle [playerid] [model id]");
		if(targetID == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");

		if((carModelID < 400 || carModelID > 611) && carModelID != 0) return SendClientMessage(playerid, COLOR_GREY, "Invalid model ID (valid IDs are between 400 and 611). Specify model 0 to delete a player vehicle.");

		GetPlayerName(targetID, szPlayerName, MAX_PLAYER_NAME);

		if(carModelID == 0) { // Basically, specifying 0 in the command will delete the vehicle (which was pretty useful in the past).
			if(playerVariables[targetID][pCarModel] >= 1) {
				DestroyPlayerVehicle(targetID);
				format(string, sizeof(string), "You have deleted %s (ID: %d)'s vehicle.", szPlayerName, targetID);
				SendClientMessage(playerid, COLOR_WHITE, string);
			}
			else return SendClientMessage(playerid, COLOR_GREY, "This player does not own a vehicle.");
		}
		else {

			DestroyPlayerVehicle(targetID);

			GetPlayerPos(playerid, playerVariables[targetID][pCarPos][0], playerVariables[targetID][pCarPos][1], playerVariables[targetID][pCarPos][2]);
			GetPlayerFacingAngle(playerid, playerVariables[targetID][pCarPos][3]);

			playerVariables[targetID][pCarModel] = carModelID;

			SpawnPlayerVehicle(targetID);
			format(string, sizeof(string), "You have set %s (ID: %d)'s vehicle to a %s.", szPlayerName, targetID, VehicleNames[playerVariables[targetID][pCarModel] - 400]);
			SendClientMessage(playerid, COLOR_WHITE, string);
		}
	}
	return 1;
}

CMD:listguns(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 1) {
	    new
	        targetid;

		if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/listguns [playerid]");
		if(targetid == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");

		SendClientMessage(playerid, COLOR_TEAL, "--------------------------------------------------------------");

		for(new i = 0; i < 13; i++) {
		    if(playerVariables[targetid][pWeapons][i] >= 1) {
			    format(szMessage, sizeof(szMessage), "Weapon: %s (%d) | Slot: %d", WeaponNames[playerVariables[targetid][pWeapons][i]], playerVariables[targetid][pWeapons][i], i);
			    SendClientMessage(playerid, COLOR_WHITE, szMessage);
		    }
		}

		SendClientMessage(playerid, COLOR_TEAL, "--------------------------------------------------------------");
	}
	return 1;
}

CMD:eject(playerid, params[]) {
	new
		targetID;

	if(sscanf(params, "u", targetID))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/eject [playerid]");

	if(GetPlayerState(playerid) == 2) {
		if(GetPlayerVehicleID(playerid) == GetPlayerVehicleID(targetID)) {

			new
				string[128],
				playerName[2][MAX_PLAYER_NAME];

			GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
			GetPlayerName(targetID, playerName[1], MAX_PLAYER_NAME);

			format(string, sizeof(string), "* %s has thrown %s out of their vehicle.", playerName[0], playerName[1]);
			nearByMessage(playerid, COLOR_PURPLE, string);

			RemovePlayerFromVehicle(targetID);
		}
		else SendClientMessage(playerid, COLOR_GREY, "That person is not in your vehicle.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "You're not driving a vehicle.");
	return 1;
}

CMD:detain(playerid, params[]) {
	new
		seat,
		targetID;

	if(sscanf(params, "ud", targetID, seat))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/detain [playerid] [seat (1-3)]");

	if(playerVariables[targetID][pFreezeType] == 2 || playerVariables[targetID][pFreezeType] == 4) {
		if(seat > 0 && seat < 4) {
			if(IsPlayerInRangeOfPlayer(playerid, targetID, 5.0) && IsPlayerInRangeOfVehicle(playerid, GetClosestVehicle(playerid), 5.0)) {

				new
					detaintarget = GetClosestVehicle(playerid);

				if(checkVehicleSeat(detaintarget, seat) != 0) SendClientMessage(playerid, COLOR_GREY, "That seat ID is occupied.");

				else {

					new
						playerName[2][MAX_PLAYER_NAME],
						string[92];

					GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
					GetPlayerName(targetID, playerName[1], MAX_PLAYER_NAME);

					format(string, sizeof(string), "* %s has been detained into the vehicle by %s.", playerName[1], playerName[0]);
					nearByMessage(playerid, COLOR_PURPLE, string);

					PutPlayerInVehicle(targetID, detaintarget, seat);
				}
			}
			else SendClientMessage(playerid, COLOR_GREY, "You must be closer to the player you wish to detain, and the vehicle you wish to detain into.");
	    }
	}
	return 1;
}

CMD:drag(playerid, params[]) {

	new
		targetID,
		string[99],
		playerName[2][MAX_PLAYER_NAME];

	foreach(Player, x) {
		if(playerVariables[x][pDrag] == playerid) {

			GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
			GetPlayerName(x, playerName[1], MAX_PLAYER_NAME);

			playerVariables[x][pDrag] = -1;

			format(string, sizeof(string), "You have stopped dragging %s.", playerName[1]);
			SendClientMessage(playerid, COLOR_WHITE, string);

			format(string, sizeof(string), "* %s has stopped dragging %s, releasing their grip.", playerName[0], playerName[1]);

			return nearByMessage(playerid, COLOR_PURPLE, string);
		}
	}

	if(sscanf(params, "u", targetID))
		SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/drag [playerid] (use again to stop).");

	else if(playerVariables[targetID][pFreezeType] == 2 || playerVariables[targetID][pFreezeType] == 4) {
		if(IsPlayerInRangeOfPlayer(playerid, targetID, 2.0)) {
			if(!IsPlayerInAnyVehicle(targetID) && !IsPlayerInAnyVehicle(playerid)) {

				GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
				GetPlayerName(targetID, playerName[1], MAX_PLAYER_NAME);

				playerVariables[targetID][pDrag] = playerid;
				format(string, sizeof(string), "You are now dragging %s.", playerName[1]);
				SendClientMessage(playerid, COLOR_WHITE, string);

				format(string, sizeof(string), "* %s grabs %s by the arm, and starts dragging them.", playerName[0], playerName[1]);
				nearByMessage(playerid, COLOR_PURPLE, string);
			}
			else SendClientMessage(playerid, COLOR_GREY, "Neither you, nor the person you wish to drag, can be in a vehicle.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You're too far away.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "The person you wish to drag must be restrained first (cuffed, or tied).");
	return 1;
}

CMD:fingerprint(playerid, params[]) {

	new
		targetID,
		string[106],
		dates[3],
		playerNames[2][MAX_PLAYER_NAME];

	if(sscanf(params, "u", targetID)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/fingerprint [playerid]");

	else if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1) {
		if(IsPlayerAuthed(targetID)) {
			if(playerVariables[targetID][pFreezeType] == 2 || playerVariables[targetID][pFreezeType] == 4 || (GetPlayerSpecialAction(targetID) == SPECIAL_ACTION_HANDSUP && playerVariables[targetID][pFreezeType] == 0)) {
				if(IsPlayerInRangeOfPlayer(playerid, targetID, 2.0)) {

					GetPlayerName(targetID, playerNames[0], MAX_PLAYER_NAME);
					GetPlayerName(playerid, playerNames[1], MAX_PLAYER_NAME);

					getdate(dates[0], dates[1], dates[2]);

					format(string, sizeof(string), "* %s grabs ahold of %s's finger, and places it on the scanner.", playerNames[1], playerNames[0]);
					nearByMessage(playerid, COLOR_PURPLE, string);

					SendClientMessage(playerid, COLOR_TEAL, "----------------------------------------------------------------");

					if(playerVariables[targetID][pCrimes] > 0 || playerVariables[targetID][pArrests] > 0 || playerVariables[targetID][pWarrants] > 0) {

						format(string, sizeof(string), "Citizen's registered name: %s", playerNames[0]);
						SendClientMessage(playerid, COLOR_WHITE, string);
						format(string, sizeof(string), "Citizen's age: %d (born %d)", dates[0] - playerVariables[targetID][pAge], playerVariables[targetID][pAge]);
						SendClientMessage(playerid, COLOR_WHITE, string);

						switch(playerVariables[targetID][pGender]) {
							case 1: SendClientMessage(playerid, COLOR_WHITE, "Citizen's gender: Male");
							case 2: SendClientMessage(playerid, COLOR_WHITE, "Citizen's gender: Female");
							default: SendClientMessage(playerid, COLOR_WHITE, "Citizen's gender: Unknown");
						}
						if(playerVariables[targetID][pPhoneNumber] == -1) {
							SendClientMessage(playerid, COLOR_WHITE, "Citizen's phone number: None");
						}
						else {
							format(string, sizeof(string), "Citizen's phone number: %d", playerVariables[targetID][pPhoneNumber]);
							SendClientMessage(playerid, COLOR_WHITE, string);
						}
					}
					else SendClientMessage(playerid, COLOR_WHITE, "No results found.");

					SendClientMessage(playerid, COLOR_TEAL, "----------------------------------------------------------------");
				}
				else SendClientMessage(playerid, COLOR_GREY, "You're too far away.");
			}
			else SendClientMessage(playerid, COLOR_GREY, "The person you wish to fingerprint must be restrained first (cuffed, or tied).");
		}
		else SendClientMessage(playerid, COLOR_GREY, "The specified player is either not connected or has not authenticated.");
	}
	return 1;
}

CMD:wanted(playerid, params[]) {
	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1) {

		new
			dString[128],
			x;

		SendClientMessage(playerid, COLOR_TEAL, "---------------------------------------------------------------------------------------------------------------------------------");
		SendClientMessage(playerid, COLOR_WHITE, "Active Felons:");
		foreach(Player, i) {
			if(playerVariables[i][pWarrants] >= 1) {

				GetPlayerName(i, szPlayerName, MAX_PLAYER_NAME);

				if(x == 0)
					format(dString, sizeof(dString), "%s (%d)", szPlayerName, playerVariables[i][pWarrants]);
				else
					format(dString, sizeof(dString), "%s | %s (%d)", dString, szPlayerName, playerVariables[i][pWarrants]);

				if(x == 3) {
					SendClientMessage(playerid, COLOR_WHITE, dString);
					x = 0;
				}

				else x++;
			}
		}

		if(x < 3 && x > 0)
			SendClientMessage(playerid, COLOR_WHITE, dString);

		if(x == 0)
			SendClientMessage(playerid, COLOR_WHITE, "No active felons found.");

		SendClientMessage(playerid, COLOR_TEAL, "---------------------------------------------------------------------------------------------------------------------------------");
	}

	return 1;
}

CMD:ticket(playerid, params[]) {

	new
		targetID,
		price,
		string[96],
		playerName[2][MAX_PLAYER_NAME];

	if(sscanf(params, "ud", targetID, price)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/ticket [playerid] [price]");

	else if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1) {
		if(IsPlayerAuthed(targetID)) {
			if(playerid != targetID) {
				if(IsPlayerInRangeOfPlayer(playerid, targetID, 3.0)) {
					if(price >= 1 && price <= 100000) {

						GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
						GetPlayerName(targetID, playerName[1], MAX_PLAYER_NAME);

						format(string, sizeof(string), "* %s writes up a ticket, and hands it to %s.", playerName[0], playerName[1]);
						nearByMessage(playerid, COLOR_PURPLE, string);

						format(string, sizeof(string), "You have issued %s a ticket costing $%d.", playerName[1], price);
						SendClientMessage(playerid, COLOR_WHITE, string);

						format(string, sizeof(string), "%s has issued you a ticket costing $%d - /accept ticket to pay the fine.", playerName[0], price);
						SendClientMessage(targetID, COLOR_GENANNOUNCE, string);

						SetPVarInt(targetID, "tP", price);
						SetPVarInt(targetID, "tID", playerid + 1);
					}
					else SendClientMessage(playerid, COLOR_GREY, "Invalid price specified (must be between $1 and $100,000).");
				}
				else SendClientMessage(playerid, COLOR_GREY, "You're too far away.");
			}
			else SendClientMessage(playerid, COLOR_GREY, "You can't ticket yourself.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "The specified player is either not connected or has not authenticated.");
	}
	return 1;
}

CMD:suspect(playerid, params[]) {
	return cmd_su(playerid, params);
}

CMD:su(playerid, params[]) {

	new
		targetID,
		string[128],
		crime[96],
		playerName[2][MAX_PLAYER_NAME];

	if(sscanf(params, "us", targetID, crime))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/su [playerid] [offence]");

	else if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1) {
		if(IsPlayerAuthed(targetID)) {
			if(groupVariables[playerVariables[targetID][pGroup]][gGroupType] != 1) {

				GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
				GetPlayerName(targetID, playerName[1], MAX_PLAYER_NAME);

				format(string, sizeof(string), "Dispatch: %s has issued an arrest warrant on %s (%s).", playerName[0], playerName[1], crime);
				SendToGroup(playerVariables[playerid][pGroup], COLOR_RADIOCHAT, string);

				playerVariables[targetID][pWarrants]++;
				if(playerVariables[targetID][pWarrants] < 7)
					SetPlayerWantedLevel(targetID, playerVariables[targetID][pWarrants]);
			}
			else SendClientMessage(playerid, COLOR_GREY, "You can't place an arrest warrant on this person.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "The specified player is either not connected or has not authenticated.");
	}
	return 1;
}

CMD:arrest(playerid, params[]) {

	new
		string[128],
		playerName[2][MAX_PLAYER_NAME],
		targetID,
		arrestInfo[3];

	if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] != 1) return SendClientMessage(playerid, COLOR_GREY, "You're not a law enforcement officer.");

	else if(sscanf(params, "udd", targetID, arrestInfo[0], arrestInfo[1])) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/arrest [playerid] [time] [price]");

	else if(targetID == playerid) return SendClientMessage(playerid, COLOR_GREY, "You can't arrest yourself.");

	else if((IsPlayerInRangeOfPoint(playerid,5, 1528.5240,-1678.2472,5.8906) && IsPlayerInRangeOfPoint(targetID,5, 1528.5240,-1678.2472,5.8906)) || (IsPlayerInRangeOfPoint(playerid, 20.0, 221.25, 110.0, 999.02) && IsPlayerInRangeOfPoint(targetID, 20.0, 221.25, 110.0, 999.02))) {
		if(playerVariables[targetID][pFreezeType] == 2) {
			if(arrestInfo[0] <= 60 && arrestInfo[0] > 0 && arrestInfo[1] <= 30000 && arrestInfo[1] >= 0) {

				GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
				GetPlayerName(targetID, playerName[1], MAX_PLAYER_NAME);

				validResetPlayerWeapons(targetID);

				playerVariables[targetID][pMoney] -= arrestInfo[1];
				playerVariables[targetID][pFreezeTime] = 0;
				playerVariables[targetID][pFreezeType] = 0;
				playerVariables[targetID][pPrisonID] = 3;
				playerVariables[targetID][pPrisonTime] = arrestInfo[0] * 60;
				playerVariables[targetID][pArmour] = 0;
				playerVariables[targetID][pArrests]++;
				playerVariables[targetID][pCrimes] += playerVariables[targetID][pWarrants];
				playerVariables[targetID][pWarrants] = 0;

				SetPlayerArmour(targetID, 0);
				TogglePlayerControllable(targetID, true);

				groupVariables[playerVariables[playerid][pGroup]][gSafe][0] += arrestInfo[1];

				format(string, sizeof(string),"You have been arrested by %s for %d minutes, and issued a fine of $%d.", playerName[0], arrestInfo[0], arrestInfo[1]);
				SendClientMessage(targetID, COLOR_NICESKY, string);

				format(string, sizeof(string),"Dispatch: %s has processed suspect %s, issuing a fine of $%d with a sentence of %d minutes.", playerName[0], playerName[1], arrestInfo[1], arrestInfo[0]);
				SendToGroup(playerVariables[playerid][pGroup], COLOR_RADIOCHAT, string);

				SetPlayerInterior(targetID, 10);
				SetPlayerVirtualWorld(targetID, GROUP_VIRTUAL_WORLD+1);

				arrestInfo[2] = random(sizeof(JailSpawns));

				SetPlayerPos(targetID, JailSpawns[arrestInfo[2]][0], JailSpawns[arrestInfo[2]][1], JailSpawns[arrestInfo[2]][2]);
				SetPlayerFacingAngle(targetID, 0);
			}
			else SendClientMessage(playerid, COLOR_GREY, "Fine price must be between $0 and $30,000; time must be 60 minutes or less.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "The person you wish to arrest must be restrained first (cuffed).");
	}
	else SendClientMessage(playerid, COLOR_GREY, "Both you and the person you wish to arrest must be at the arrest point.");
	return 1;
}

CMD:frisk(playerid, params[]) {

	new
		targetID,
		string[128],
		playerNames[2][MAX_PLAYER_NAME],
		count;

	if(sscanf(params, "u", targetID)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/frisk [playerid]");

	else if(IsPlayerInRangeOfPlayer(playerid, targetID, 2.0)) {
		if(playerVariables[targetID][pFreezeType] == 2 || (GetPlayerSpecialAction(targetID) == SPECIAL_ACTION_HANDSUP && playerVariables[targetID][pFreezeType] == 0) || playerVariables[targetID][pFreezeType] == 4) {

			GetPlayerName(playerid, playerNames[0], MAX_PLAYER_NAME);
			GetPlayerName(targetID, playerNames[1], MAX_PLAYER_NAME);

			format(string, sizeof(string), "* %s has frisked %s.", playerNames[0], playerNames[1]);
			nearByMessage(playerid, COLOR_PURPLE, string);

			SendClientMessage(playerid, COLOR_TEAL, "----------------------------------------------------------------");

			for(new x; x < 13; x++) { // Retrieve all weapons in slots, get their names, shove them into one string.
				if(playerVariables[targetID][pWeapons][x] > 0) {
					if(count == 0) format(string, sizeof(string), "* Weapons: %s", WeaponNames[playerVariables[targetID][pWeapons][x]]);
					else format(string, sizeof(string), "%s, %s", string, WeaponNames[playerVariables[targetID][pWeapons][x]]);
					count++;
				}
			}
			if(count >= 1) SendClientMessage(playerid, COLOR_GREY, string);

			if(playerVariables[targetID][pMaterials] >= 1) {
				format(string, sizeof(string), "* Materials: %d", playerVariables[targetID][pMaterials]);
				SendClientMessage(playerid, COLOR_GREY, string);
				count++;
			}
			if(playerVariables[targetID][pPhoneNumber] != -1) {
				SendClientMessage(playerid, COLOR_GREY, "Phone");
			}
			if(count == 0) SendClientMessage(playerid, COLOR_GREY, "No items found.");

			SendClientMessage(playerid, COLOR_TEAL, "----------------------------------------------------------------");
	    }
		else SendClientMessage(playerid, COLOR_GREY, "That person must first be subdued, or have their hands up.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "You're too far away.");
	return 1;
}

CMD:cuff(playerid, params[]) {

	new
		string[128],
		playerName[2][MAX_PLAYER_NAME],
		target,
		Float:Pos[3];

    if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] != 1) return SendClientMessage(playerid, COLOR_GREY, "You're not a law enforcement officer.");

	else if(sscanf(params, "u", target)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/cuff [playerid]");

	else if(target == playerid) return SendClientMessage(playerid, COLOR_GREY, "You can't cuff yourself.");

    else {
	    if(IsPlayerInRangeOfPlayer(playerid, target, 3.0)) {
            if(playerVariables[target][pFreezeType] == 5 || playerVariables[target][pFreezeType] == 1 || (GetPlayerSpecialAction(target) == SPECIAL_ACTION_HANDSUP && playerVariables[target][pFreezeType] == 0) || playerVariables[target][pFreezeType] == 4) { // CAN NEVAR BE EXPLOITED!1 Means admin-frozen people can't be exploited out with cuffs.

				GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
				GetPlayerName(target, playerName[1], MAX_PLAYER_NAME);

				TogglePlayerControllable(target, 0);
				playerVariables[target][pFreezeTime] = 900;
				playerVariables[target][pFreezeType] = 2;
				GameTextForPlayer(target,"~n~~r~Handcuffed!",4000,4);

				GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);

				format(string, sizeof(string), "* %s has handcuffed %s.", playerName[0], playerName[1]);
				nearByMessage(playerid, COLOR_PURPLE, string);
				format(string, sizeof(string),"You have handcuffed %s.", playerName[1]);
				SendClientMessage(playerid, COLOR_NICESKY, string);

				PlayerPlaySoundEx(1145, Pos[0], Pos[1], Pos[2]);
				ApplyAnimation(target, "PED", "cower", 1, 1, 0, 0, 0, 0, 1);
    	    }
    	    else SendClientMessage(playerid, COLOR_GREY, "That person must first be subdued, or have their hands up.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You're too far away.");
	}
	return 1;
}

CMD:unfreeze(playerid, params[]) {
	return cmd_freeze(playerid, params);
}

CMD:freeze(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 2) {
		new
			string[128],
			target;

		if(sscanf(params, "u", target)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/freeze [playerid]");

		else if(playerVariables[playerid][pAdminLevel] >= playerVariables[target][pAdminLevel]) {

			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

			switch(playerVariables[target][pFreezeType]) {
				case 3: {

					playerVariables[target][pFreezeTime] = 0;
					playerVariables[target][pFreezeType] = 0;
					TogglePlayerControllable(target, 1);

					format(string, sizeof(string), "You have been unfrozen by Administrator %s.", szPlayerName);
					SendClientMessage(target, COLOR_WHITE, string);

					GetPlayerName(target, szPlayerName, MAX_PLAYER_NAME);
					format(string, sizeof(string), "You have unfrozen %s.", szPlayerName);
					SendClientMessage(playerid, COLOR_WHITE, string);
				}
				default: {

					TogglePlayerControllable(target, 0);
					playerVariables[target][pFreezeTime] = -1;
					playerVariables[target][pFreezeType] = 3;

					format(string, sizeof(string), "You have been frozen by Administrator %s.", szPlayerName);
					SendClientMessage(target, COLOR_WHITE, string);

					GetPlayerName(target, szPlayerName, MAX_PLAYER_NAME);
					format(string, sizeof(string), "You have frozen %s.", szPlayerName);
					SendClientMessage(playerid, COLOR_WHITE, string);
				}
			}
		}
		else SendClientMessage(playerid, COLOR_GREY, "You can't freeze a higher level administrator.");
	}
	return 1;
}

CMD:uncuff(playerid, params[]) {
	new
		string[128],
		playerName[2][MAX_PLAYER_NAME],
		target;

	if(sscanf(params, "u", target)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/uncuff [playerid]");

    if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] != 1) {
        SendClientMessage(playerid, COLOR_GREY, "You're not a law enforcement officer.");
    }

	else if(target == playerid) SendClientMessage(playerid, COLOR_GREY, "You can't uncuff yourself.");

    else {
	    if(IsPlayerInRangeOfPlayer(playerid, target, 4.0)) {
            if(playerVariables[target][pFreezeType] == 2) {

				GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
				GetPlayerName(target, playerName[1], MAX_PLAYER_NAME);

				playerVariables[target][pFreezeTime] = 0;
				playerVariables[target][pFreezeType] = 0;

				TogglePlayerControllable(target, 1);
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
				ClearAnimations(target);
				ApplyAnimation(target, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
				GameTextForPlayer(target,"~n~~g~Uncuffed!",4000,4);

				format(string, sizeof(string), "* %s has uncuffed %s.", playerName[0], playerName[1]);
				nearByMessage(playerid, COLOR_PURPLE, string);
				format(string, sizeof(string),"You have uncuffed %s.", playerName[1]);
				SendClientMessage(playerid, COLOR_NICESKY, string);
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);

				if(playerVariables[target][pDrag] != -1) {
					format(string, sizeof(string), "You have stopped dragging %s.", playerName[1]);
					SendClientMessage(playerid, COLOR_WHITE, string);

					playerVariables[target][pDrag] = -1;

					format(string, sizeof(string), "* %s has stopped dragging %s, releasing their grip.", playerName[0], playerName[1]);

					return nearByMessage(playerid, COLOR_PURPLE, string);
				}
    	    }
    	    else SendClientMessage(playerid, COLOR_GREY, "That person is not cuffed.");
		}
	}
	return 1;
}

CMD:deposit(playerid, params[]) {

	new
		cash,
		string[128];

	if(sscanf(params, "d", cash)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/deposit [amount]");
	else if(cash <= 0) return SendClientMessage(playerid, COLOR_GREY, "Invalid amount specified.");
	else {
		if(IsPlayerInRangeOfPoint(playerid, 15.0, 2306.8481,-16.0682,26.7496) && GetPlayerVirtualWorld(playerid) == 2) {
			if(playerVariables[playerid][pMoney] < cash) SendClientMessage(playerid, COLOR_GREY, "You don't have enough money for this transaction.");
			else if(cash >= 1) {
				playerVariables[playerid][pBankMoney] += cash;
				playerVariables[playerid][pMoney] -= cash;
				format(string, sizeof(string), "You have deposited $%d into your bank account. Your account balance is now $%d.", cash, playerVariables[playerid][pBankMoney]);
				SendClientMessage(playerid, COLOR_DCHAT, string);
			}
			else SendClientMessage(playerid, COLOR_GREY, "Invalid amount specified.");
		}
		else {
			SendClientMessage(playerid, COLOR_GREY, "You're not at the bank.");
		}
	}
	return 1;
}

CMD:wiretransfer(playerid, params[]) {

	new
		cash,
		targetID,
		string[128];

	if(sscanf(params, "ud", targetID, cash)) SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/wiretransfer [playerid] [amount]");
	else if(cash <= 0) return SendClientMessage(playerid, COLOR_GREY, "Invalid amount specified.");
	else if(IsPlayerInRangeOfPoint(playerid, 15.0, 2306.8481,-16.0682,26.7496) && GetPlayerVirtualWorld(playerid) == 2) {
	    if(suspensionCheck(playerid) == 1)
	        return 1;

		if(playerVariables[playerid][pPlayingHours] >= 10) {
			if(IsPlayerAuthed(targetID)) {
				if(playerVariables[playerid][pBankMoney] >= cash) {
					if(cash >= 1) {

						playerVariables[playerid][pBankMoney] -= cash;
						playerVariables[targetID][pBankMoney] += cash;

						GetPlayerName(targetID, szPlayerName, MAX_PLAYER_NAME);
						format(string, sizeof(string), "You have transferred $%d into %s's account. Your account balance is now $%d.", cash, szPlayerName, playerVariables[playerid][pBankMoney]);
						SendClientMessage(playerid, COLOR_DCHAT, string);

						GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
						format(string, sizeof(string), "%s has transferred $%d into your account. Your account balance is now $%d.", szPlayerName, cash, playerVariables[playerid][pBankMoney]);
						SendClientMessage(targetID, COLOR_DCHAT, string);
					}
					else SendClientMessage(playerid, COLOR_GREY, "Invalid amount specified.");
				}
				else SendClientMessage(playerid, COLOR_GREY, "Your account balance is insufficient for this transaction.");
			}
			else SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You must have at least ten playing hours to use this command.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "You're not at the bank.");
	return 1;
}

CMD:withdraw(playerid, params[]) {

	new
		cash,
		string[128];

	if(sscanf(params, "d", cash)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/withdraw [amount]");
	else if(cash <= 0) return SendClientMessage(playerid, COLOR_GREY, "Invalid amount specified.");
	else {
		if(IsPlayerInRangeOfPoint(playerid, 15.0, 2306.8481,-16.0682,26.7496) && GetPlayerVirtualWorld(playerid) == 2) {
	    	if(suspensionCheck(playerid) == 1)
	        	return 1;

			if(playerVariables[playerid][pBankMoney] < cash) SendClientMessage(playerid, COLOR_GREY, "Your account balance is insufficient for this transaction.");
			else if(cash >= 1) {
				playerVariables[playerid][pMoney] += cash;
				playerVariables[playerid][pBankMoney] -= cash;
				format(string, sizeof(string), "You have withdrawn $%d from your bank account. Your account balance is now $%d.", cash, playerVariables[playerid][pBankMoney]);
				SendClientMessage(playerid, COLOR_DCHAT, string);
			}
			else SendClientMessage(playerid, COLOR_GREY, "Invalid amount specified.");
		}
		else {
			SendClientMessage(playerid, COLOR_GREY, "You're not at the bank.");
		}
	}
	return 1;
}

CMD:balance(playerid, params[]) {
    if(IsPlayerInRangeOfPoint(playerid, 15.0, 2306.8481,-16.0682,26.7496) && GetPlayerVirtualWorld(playerid) == 2) {
	    if(suspensionCheck(playerid) == 1)
	        return 1;

        format(szMessage, sizeof(szMessage), "Your current bank account balance is: $%d", playerVariables[playerid][pBankMoney]);
        SendClientMessage(playerid, COLOR_DCHAT, szMessage);
    } else SendClientMessage(playerid, COLOR_GREY, "You're not at the bank.");
	return 1;
}

CMD:go(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] > 0) {
		ShowPlayerDialog(playerid, DIALOG_GO, DIALOG_STYLE_LIST, "SERVER: Teleport Locations", "House Interiors\nRace Tracks\nCity Locations\nPopular Locations\nGym Interiors\nOther", "Select", "Cancel");
	}
	return 1;
}

CMD:lspd(playerid,params[]) {
    if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1 && playerVariables[playerid][pGroup] != 0) {
	    new string[64];
	 	if(IsPlayerInRangeOfPoint(playerid, 5, 264.1055,109.8094,1004.6172) && GetPlayerInterior(playerid) == 10) {
   			format(string, sizeof(string), "%s Menu", groupVariables[playerVariables[playerid][pGroup]][gGroupName]);
	    	ShowPlayerDialog(playerid, DIALOG_LSPD, DIALOG_STYLE_LIST, string, "Equipment\nRelease Suspect\nClothing\nClear Suspect", "Select", "Cancel");
		}
    }
	return 1;
}

CMD:fixcar(playerid, params[]) {
	if(jobVariables[playerVariables[playerid][pJob]][jJobType] == 3 || playerVariables[playerid][pAdminDuty] >= 1) {
		if(IsPlayerInAnyVehicle(playerid)) {

			new
				vehString[72],
				Float: soPos[3],
				vehicleID = GetPlayerVehicleID(playerid);

		    if(playerVariables[playerid][pJobDelay] == 0) { // DELAY!1
			    if(GetPlayerSpeed(playerid, 0) == 0) {

					GetVehiclePos(vehicleID, soPos[0], soPos[1], soPos[2]);
					PlayerPlaySoundEx(1133, soPos[0], soPos[1], soPos[2]);

				    RepairVehicle(vehicleID);
					format(vehString, sizeof(vehString), "You have repaired your %s.", VehicleNames[GetVehicleModel(vehicleID) - 400]);
					SendClientMessage(playerid, COLOR_WHITE, vehString);
				    playerVariables[playerid][pJobDelay] = 60;
			    }
			    else SendClientMessage(playerid, COLOR_WHITE, "You must stop your vehicle first.");
		    }
		    else {
				format(vehString, sizeof(vehString), "You need to wait %d seconds until you can use a mechanic command again.",playerVariables[playerid][pJobDelay]);
		        SendClientMessage(playerid, COLOR_GREY, vehString);
			}
		}
	}
	return 1;
}

CMD:colourcar(playerid, params[]) {
	if(jobVariables[playerVariables[playerid][pJob]][jJobType] == 3) {

		new
			colors[2],
			Float: soPos[3],
			vehicleID = GetPlayerVehicleID(playerid);

		if(sscanf(params, "dd", colors[0], colors[1])) {
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/colourcar [colour 1] [colour 2]");
		}
		else if(vehicleID) {
			if(playerVariables[playerid][pJobDelay] == 0) { // DELAY!1
				if(GetPlayerSpeed(playerid, 0) == 0) {
					if(colors[0] >= 0 && colors[0] < 256 && colors[1] >= 0 && colors[1] < 256) {

						GetVehiclePos(vehicleID, soPos[0], soPos[1], soPos[2]);
						PlayerPlaySoundEx(1134, soPos[0], soPos[1], soPos[2]);

						ChangeVehicleColor(vehicleID, colors[0], colors[1]);

						foreach(Player, v) {
							if(playerVariables[v][pCarID] == vehicleID) {
								playerVariables[v][pCarColour][0] = colors[0];
								playerVariables[v][pCarColour][1] = colors[1];
							}
						}
						SendClientMessage(playerid, COLOR_WHITE, "You have resprayed your vehicle.");
						playerVariables[playerid][pJobDelay] = 60;
					}
					else SendClientMessage(playerid, COLOR_WHITE, "Valid vehicle colours are 0 to 255.");
				}
				else SendClientMessage(playerid, COLOR_WHITE, "You must stop your vehicle first.");
			}
			else SendClientMessage(playerid, COLOR_WHITE, "Please wait your job reload time.");
		}
	}
	return 1;
}

CMD:trackplates(playerid, params[]) {
	if(isnull(params))
	    return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/trackplates [plate]");

	if(jobVariables[playerVariables[playerid][pJob]][jJobType] != 2 && groupVariables[playerVariables[playerid][pGroup]][gGroupType] != 1)
	    return SendClientMessage(playerid, COLOR_GREY, "You are not a Detective or a LEO.");

 	if(playerVariables[playerid][pJobSkill][1] < 500 && groupVariables[playerVariables[playerid][pGroup]][gGroupType] != 1)
  		return SendClientMessage(playerid, COLOR_GREY, "You are not a Level 5 detective.");

	foreach(Player, x) {
		if(strcmp(playerVariables[x][pCarLicensePlate], params, true) == 0) {
			GetPlayerName(x, szPlayerName, MAX_PLAYER_NAME);
			format(szMessage, sizeof(szMessage), "Plate: "EMBED_GREY"%s{FFFFFF} | Vehicle Owner: "EMBED_GREY"%s", playerVariables[x][pCarLicensePlate], szPlayerName);
			SendClientMessage(playerid, COLOR_WHITE, szMessage);
		    return 1;
		}
	}
	return 1;
}

CMD:trackhouse(playerid, params[]) {
	new
		id,
		string[128],
		house;

	if(sscanf(params, "u", id))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/trackhouse [playerid]");

	else if(jobVariables[playerVariables[playerid][pJob]][jJobType] == 2) {
	    if(playerVariables[playerid][pJobSkill][1] >= 400) {
	        if(IsPlayerAuthed(id)) {

				if(id == playerid)
					return SendClientMessage(playerid, COLOR_GREY, "Use /home to set a checkpoint to your house.");

	            if(playerVariables[playerid][pJobDelay] >= 1) {
	                format(string,sizeof(string),"You need to wait %d seconds until you can use a detective command again.",playerVariables[playerid][pJobDelay]);
	                SendClientMessage(playerid, COLOR_GREY, string);
	            }
	            else if(playerVariables[playerid][pCheckpoint] >= 2) {
					format(string, sizeof(string), "You already have an active checkpoint (%s), reach it first, or /killcheckpoint.", getPlayerCheckpointReason(playerid));
					SendClientMessage(playerid, COLOR_GREY,string);
				}
				else if(playerVariables[id][pAdminDuty] >= 1) SendClientMessage(playerid, COLOR_GREY, "You can't track this person's house at the moment.");
				else {

					house = getPlayerHouseID(id);
					if(house >= 1) {

						SetPlayerCheckpoint(playerid, houseVariables[house][hHouseExteriorPos][0], houseVariables[house][hHouseExteriorPos][1], houseVariables[house][hHouseExteriorPos][2], 5.0);

						format(string, sizeof(string), "A checkpoint has been set to %s's house.", playerVariables[id][pNormalName]);
						SendClientMessage(playerid, COLOR_WHITE, string);

						switch(playerVariables[playerid][pJobSkill][1]) {
							case 400 .. 449: playerVariables[playerid][pJobDelay] = 40;
							case 450 .. 499: playerVariables[playerid][pJobDelay] = 30;
							default: playerVariables[playerid][pJobDelay] = 20;
						}

						playerVariables[playerid][pJobSkill][1]++;
						playerVariables[playerid][pCheckpoint] = 1;
					}
					else SendClientMessage(playerid, COLOR_GREY, "This person does not own a house.");
	            }
	        }
			else SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
	    }
		else SendClientMessage(playerid, COLOR_GREY, "Your detective skill must be at least level 8 to use this.");
	}
	return 1;
}

CMD:business(playerid, params[]) {

	new
		business = getPlayerBusinessID(playerid);

	if(business >= 1) {
		if(playerVariables[playerid][pCheckpoint] >= 1) {
			new string[96];
			format(string, sizeof(string), "You already have an active checkpoint (%s), reach it first, or /killcheckpoint.", getPlayerCheckpointReason(playerid));
			return SendClientMessage(playerid, COLOR_GREY,string);
		}
		SetPlayerCheckpoint(playerid, businessVariables[business][bExteriorPos][0], businessVariables[business][bExteriorPos][1], businessVariables[business][bExteriorPos][2], 5.0);
		SendClientMessage(playerid, COLOR_WHITE, "A checkpoint has been set to your business.");
		playerVariables[playerid][pCheckpoint] = 6;
	}
	else SendClientMessage(playerid, COLOR_GREY, "You don't own a business.");
	return 1;
}

CMD:home(playerid, params[]) {

	new
		house = getPlayerHouseID(playerid);

	if(house >= 1) {
		if(playerVariables[playerid][pCheckpoint] >= 1) {
			new string[96];
			format(string, sizeof(string), "You already have an active checkpoint (%s), reach it first, or /killcheckpoint.", getPlayerCheckpointReason(playerid));
			return SendClientMessage(playerid, COLOR_GREY,string);
		}
		SetPlayerCheckpoint(playerid, houseVariables[house][hHouseExteriorPos][0], houseVariables[house][hHouseExteriorPos][1], houseVariables[house][hHouseExteriorPos][2], 5.0);
		SendClientMessage(playerid, COLOR_WHITE, "A checkpoint has been set to your house.");
		playerVariables[playerid][pCheckpoint] = 6;
	}
	else SendClientMessage(playerid, COLOR_GREY, "You don't own a house.");
	return 1;
}

CMD:trackbusiness(playerid, params[]) {
	new
		id,
		string[128],
		house;

	if(sscanf(params, "u", id))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/trackbusiness [playerid]");

	else if(jobVariables[playerVariables[playerid][pJob]][jJobType] == 2) {
	    if(playerVariables[playerid][pJobSkill][1] >= 400) {
	        if(IsPlayerAuthed(id)) {

				if(id == playerid) return SendClientMessage(playerid, COLOR_GREY, "Use /business to set a checkpoint to your business.");

	            if(playerVariables[playerid][pJobDelay] >= 1) {
	                format(string,sizeof(string),"You need to wait %d seconds until you can use a detective command again.",playerVariables[playerid][pJobDelay]);
	                SendClientMessage(playerid, COLOR_GREY, string);
	            }
	            else if(playerVariables[playerid][pCheckpoint] >= 2) {
					format(string, sizeof(string), "You already have an active checkpoint (%s), reach it first, or /killcheckpoint.", getPlayerCheckpointReason(playerid));
					SendClientMessage(playerid, COLOR_GREY,string);
				}
				else if(playerVariables[id][pAdminDuty] >= 1) SendClientMessage(playerid, COLOR_GREY, "You can't track this person's business at the moment.");
				else {

					house = getPlayerBusinessID(id);
					if(house >= 1) {

						SetPlayerCheckpoint(playerid, businessVariables[house][bExteriorPos][0], businessVariables[house][bExteriorPos][1], businessVariables[house][bExteriorPos][2], 5.0);

						format(string, sizeof(string), "A checkpoint has been set to %s's business.", playerVariables[id][pNormalName]);
						SendClientMessage(playerid, COLOR_WHITE, string);

						switch(playerVariables[playerid][pJobSkill][1]) {
							case 400 .. 449: playerVariables[playerid][pJobDelay] = 40;
							case 450 .. 499: playerVariables[playerid][pJobDelay] = 30;
							default: playerVariables[playerid][pJobDelay] = 20;
						}

						playerVariables[playerid][pJobSkill][1]++;
						playerVariables[playerid][pCheckpoint] = 1;
					}
					else SendClientMessage(playerid, COLOR_GREY, "This person does not own a business.");
	            }
	        }
			else SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
	    }
		else SendClientMessage(playerid, COLOR_GREY, "Your detective skill must be at least level 8 to use this.");
	}
	return 1;
}

CMD:trackcar(playerid, params[]) {

	new
		id,
		string[128];

	if(sscanf(params, "u", id))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/trackcar [playerid]");

	else if(jobVariables[playerVariables[playerid][pJob]][jJobType] == 2)
	{
	    if(playerVariables[playerid][pJobSkill][1] >= 250) {
	        if(IsPlayerAuthed(id)) {

				if(id == playerid) return SendClientMessage(playerid, COLOR_GREY, "Use /findcar to track your own vehicle.");

	            if(playerVariables[playerid][pJobDelay] >= 1) {
	                format(string,sizeof(string),"You need to wait %d seconds until you can use a detective command again.",playerVariables[playerid][pJobDelay]);
	                SendClientMessage(playerid, COLOR_GREY, string);
	            }
	            else if(playerVariables[playerid][pCheckpoint] >= 2) {
					format(string, sizeof(string), "You already have an active checkpoint (%s), reach it first, or /killcheckpoint.", getPlayerCheckpointReason(playerid));
					SendClientMessage(playerid, COLOR_GREY,string);
				}
				else if(playerVariables[id][pAdminDuty] >= 1) SendClientMessage(playerid, COLOR_GREY, "You can't track this person's vehicle at the moment.");
				else {

					GetVehiclePos(playerVariables[id][pCarID], playerVariables[id][pCarPos][0], playerVariables[id][pCarPos][1], playerVariables[id][pCarPos][2]);
					SetPlayerCheckpoint(playerid, playerVariables[id][pCarPos][0], playerVariables[id][pCarPos][1], playerVariables[id][pCarPos][2], 10.0);

					format(string, sizeof(string), "A checkpoint has been set, %s's %s was last seen at the marked area.", playerVariables[id][pNormalName], VehicleNames[playerVariables[id][pCarModel] - 400]);
					SendClientMessage(playerid, COLOR_WHITE, string);

					switch(playerVariables[playerid][pJobSkill][1]) {
						case 250 .. 299: playerVariables[playerid][pJobDelay] = 70;
						case 300 .. 349: playerVariables[playerid][pJobDelay] = 60;
						case 350 .. 399: playerVariables[playerid][pJobDelay] = 50;
						case 400 .. 449: playerVariables[playerid][pJobDelay] = 40;
						case 450 .. 499: playerVariables[playerid][pJobDelay] = 30;
						default: playerVariables[playerid][pJobDelay] = 20;
					}

					playerVariables[playerid][pJobSkill][1]++;
					playerVariables[playerid][pCheckpoint] = 1;
	            }
	        }
			else SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
	    }
		else SendClientMessage(playerid, COLOR_GREY, "Your detective skill must be at least level 5 to use this.");
	}
	return 1;
}

CMD:track(playerid, params[]) 
{
	new string[128];
	if(playerVariables[playerid][pJobDelay] >= 1)
	{
		format(string,sizeof(string),"You need to wait %d seconds until you can use a detective command again.",playerVariables[playerid][pJobDelay]);
		SendClientMessage(playerid, COLOR_GREY, string);
	}
	if(playerVariables[playerid][pCheckpoint] >= 2) 
	{ 
		// Having to reach the first find checkpoint is pretty annoying. Let's make it hassle-free.
		format(string, sizeof(string), "You already have an active checkpoint (%s), reach it first, or /killcheckpoint.", getPlayerCheckpointReason(playerid));
		SendClientMessage(playerid, COLOR_GREY,string);
	}
	
	new id, Float:FindFloats[3];

	if(sscanf(params, "u", id))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/track [playerid]");
	else if(id == playerid)
		return SendClientMessage(playerid, COLOR_GREY, "You can't track yourself.");
	else if(playerVariables[id][pStatus] != 1)
		return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
	else if(jobVariables[playerVariables[playerid][pJob]][jJobType] == 2)
	{
	    if(GetPlayerInterior(id) >= 1 || GetPlayerVirtualWorld(id) >= 1 || playerVariables[id][pSpectating] != INVALID_PLAYER_ID)
			SendClientMessage(playerid, COLOR_GREY, "That player is an alternate interior or virtual world.");
		else if(playerVariables[id][pAdminDuty] >= 1)
			SendClientMessage(playerid, COLOR_GREY, "You can't track this person at the moment.");
		else 
		{
			GetPlayerPos(id, FindFloats[0], FindFloats[1], FindFloats[2]);
			SetPlayerCheckpoint(playerid, FindFloats[0], FindFloats[1], FindFloats[2], 5.0);

			format(string, sizeof(string), "A checkpoint has been set, %s was last seen at the marked area.", playerVariables[id][pNormalName]);
			SendClientMessage(playerid, COLOR_WHITE, string);

			playerVariables[playerid][pCheckpoint] = 1;

			switch(playerVariables[playerid][pJobSkill][1]) {
				case 0 .. 49: playerVariables[playerid][pJobDelay] = 120;
				case 50 .. 99: playerVariables[playerid][pJobDelay] = 110;
				case 100 .. 149: playerVariables[playerid][pJobDelay] = 100;
				case 150 .. 199: playerVariables[playerid][pJobDelay] = 90;
				case 200 .. 249: playerVariables[playerid][pJobDelay] = 80;
				case 250 .. 299: playerVariables[playerid][pJobDelay] = 70;
				case 300 .. 349: playerVariables[playerid][pJobDelay] = 60;
				case 350 .. 399: playerVariables[playerid][pJobDelay] = 50;
				case 400 .. 449: playerVariables[playerid][pJobDelay] = 40;
				case 450 .. 499: playerVariables[playerid][pJobDelay] = 30;
				default: playerVariables[playerid][pJobDelay] = 20;
			}

			playerVariables[playerid][pJobSkill][1] ++;

			switch(playerVariables[playerid][pJobSkill][1]) 
			{
				case 50, 100, 150, 200, 250, 300, 350, 400, 450, 500: 
				{
					format(string,sizeof(string),"Congratulations! Your detective skill level is now %d. You will now have a lower delay between each track attempt.",playerVariables[playerid][pJobSkill][1]/50);
					SendClientMessage(playerid,COLOR_WHITE,string);
				}
			}
		}
	}
	return 1;
}

CMD:kill(playerid, params[]) {
    if(playerVariables[playerid][pEvent] != 0) {
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command while in an event.");
	}
    else if(playerVariables[playerid][pFreezeType] != 0) {
		return SendClientMessage(playerid, COLOR_GREY, "You can't use this command while cuffed, tazed, or frozen.");
	}
    else {
		return SetPlayerHealth(playerid, -1);
	}
}

CMD:untie(playerid, params[]) {
	if(sscanf(params, "u", iTarget)) {
    	return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/untie [playerid]");
    }
    else {
		if(iTarget == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");

		if(iTarget == playerid)
			return SendClientMessage(playerid, COLOR_GREY, "You can't untie yourself.");

		if(IsPlayerInRangeOfPlayer(playerid, iTarget, 2.0)) {
			new
				playerName[2][MAX_PLAYER_NAME];

			GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
			GetPlayerName(iTarget, playerName[1], MAX_PLAYER_NAME);

			if(random(6) < 3) {
				if(playerVariables[iTarget][pFreezeType] != 4) {
					return SendClientMessage(playerid, COLOR_GREY, "This player is not tied.");
				}
				else {
					format(szMessage, sizeof(szMessage), "* %s has attempted to untie %s and has succeeded.", playerName[0], playerName[1]);
					nearByMessage(playerid, COLOR_PURPLE, szMessage);

					playerVariables[iTarget][pFreezeType] = 0;
					playerVariables[iTarget][pFreezeTime] = 0;

					TogglePlayerControllable(iTarget, true);

					return SendClientMessage(playerid, COLOR_WHITE, "Attempt successful!");
				}
			}
			else {
				format(szMessage, sizeof(szMessage), "* %s has attempted to untie %s and has failed.", playerName[0], playerName[1]);
				nearByMessage(playerid, COLOR_PURPLE, szMessage);

				return SendClientMessage(playerid, COLOR_GREY, "Attempt failed!");
			}
		}
		else SendClientMessage(playerid, COLOR_GREY, "You're too far away.");
	}
	return 1;
}

CMD:tie(playerid, params[]) {
	new
	    targetID;

	if(sscanf(params, "u", targetID)) { // Using sscanf instead of isnull because we're handling a playerid/name.
    	return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/tie [playerid]");
    }
    else {
		if(targetID == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
			
		if(targetID == playerid)
			return SendClientMessage(playerid, COLOR_GREY, "You can't tie yourself.");
			
		if(IsPlayerInRangeOfPlayer(playerid, targetID, 2.0)) {

			new
				playerName[2][MAX_PLAYER_NAME],
				msgSz[128];

			GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
			GetPlayerName(targetID, playerName[1], MAX_PLAYER_NAME);

			if(playerVariables[playerid][pRope] >= 1) {
				if(random(6) < 3) {
					if(playerVariables[targetID][pFreezeType] > 0 && playerVariables[targetID][pFreezeType] < 5) {
						return SendClientMessage(playerid, COLOR_GREY, "Attempt failed: player is already frozen.");
					}
					else {
						playerVariables[playerid][pRope]--;

						format(msgSz, sizeof(msgSz), "* %s has attempted to tie %s and has succeeded.", playerName[0], playerName[1]);
						nearByMessage(playerid, COLOR_PURPLE, msgSz);

						TogglePlayerControllable(targetID, false);

						playerVariables[targetID][pFreezeType] = 4;
						playerVariables[targetID][pFreezeTime] = 180;

						return SendClientMessage(playerid, COLOR_WHITE, "Attempt successful!");
					}
				}
				else {
					format(msgSz, sizeof(msgSz), "* %s has attempted to tie %s and has failed.", playerName[0], playerName[1]);
					nearByMessage(playerid, COLOR_PURPLE, msgSz);

					return SendClientMessage(playerid, COLOR_GREY, "Attempt failed!");
				}
			}
			else {
				return SendClientMessage(playerid, COLOR_GREY, "You don't have any rope.");
			}
		}
		else SendClientMessage(playerid, COLOR_GREY, "You're too far away.");
	}
	return 1;
}

CMD:setadminname(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 4) {
        new
            userID,
            playerNameString[MAX_PLAYER_NAME];

        if(sscanf(params, "us[24]", userID, playerNameString)) {
            return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/setadminname [playerid] [adminname]");
        }
        else {
            if(!IsPlayerConnected(userID))
				return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");

            if(playerVariables[userID][pAdminLevel] >= 1) {
                if(playerVariables[userID][pAdminLevel] > playerVariables[playerid][pAdminLevel]) {
                    return SendClientMessage(playerid, COLOR_GREY, "You can't change the admin name of a higher level administrator.");
                }
                else {
                    new
                        messageString[128];

                    format(messageString, sizeof(messageString), "You have changed %s's admin name to %s.", playerVariables[userID][pAdminName], playerNameString);
                    SendClientMessage(playerid, COLOR_WHITE, messageString);

                    format(messageString, sizeof(messageString), "%s has changed your admin name to %s.", playerVariables[playerid][pAdminName], playerNameString);
                    SendClientMessage(userID, COLOR_WHITE, messageString);

                    format(playerVariables[userID][pAdminName], MAX_PLAYER_NAME, "%s", playerNameString);
                    
                    if(playerVariables[userID][pAdminDuty] >= 1)
						SetPlayerName(userID, playerNameString);
						
                    return 1;
                }
            }
            else {
                return SendClientMessage(playerid, COLOR_GREY, "You can't change a non-admin's admin name.");
            }
        }
	}
	return 1;
}

CMD:setnewbiespawn(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 5) {
        if(GetPVarInt(playerid, "pAdminPINConfirmed") >= 1) {
	        GetPlayerPos(playerid, playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2]);
	        format(szLargeString, sizeof(szLargeString), "ALTER TABLE `playeraccounts` CHANGE `playerPosX` `playerPosX` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '%f',", playerVariables[playerid][pPos][0]);
	        format(szLargeString, sizeof(szLargeString), "%s CHANGE `playerPosY` `playerPosY` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '%f',", szLargeString, playerVariables[playerid][pPos][1]);
	        format(szLargeString, sizeof(szLargeString), "%s CHANGE `playerPosZ` `playerPosZ` VARCHAR( 255 ) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '%f',", szLargeString, playerVariables[playerid][pPos][2]);
	        format(szLargeString, sizeof(szLargeString), "%s CHANGE `playerInterior` `playerInterior` INT( 6 ) NOT NULL DEFAULT '%d',", szLargeString, GetPlayerInterior(playerid));
	        format(szLargeString, sizeof(szLargeString), "%s CHANGE `playerSkin` `playerSkin` INT( 6 ) NOT NULL DEFAULT '%d',", szLargeString, GetPlayerSkin(playerid));
	        format(szLargeString, sizeof(szLargeString), "%s CHANGE `playerVirtualWorld` `playerVirtualWorld` INT( 6 ) NOT NULL DEFAULT '%d'", szLargeString, GetPlayerVirtualWorld(playerid));
	        mysql_query(szLargeString, THREAD_CHANGE_SPAWN, playerid);
	        SendClientMessage(playerid, COLOR_GENANNOUNCE, "SERVER:{FFFFFF} You've successfully changed the newbie spawn position.");
        } else {
            forceAdminConfirmPIN(playerid, "setnewbiespawn", params);
        }
    }
	return 1;
}

CMD:setadminlevel(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] < 5)
        return 0;

	if(GetPVarInt(playerid, "pAdminPINConfirmed") >= 1) {
		new
		    iLevel;

		if(sscanf(params, "ud", iTarget, iLevel))
		    return SendClientMessage(playerid, COLOR_GREY, "Syntax: /setadminlevel [playerid] [admin level]");

		if(iTarget == INVALID_PLAYER_ID)
		    return SendClientMessage(playerid, COLOR_GREY, "The specified player is not connected, or has not authenticated.");

		if(playerVariables[iTarget][pAdminLevel] > playerVariables[playerid][pAdminLevel] || iTarget == playerid)
		    return SendClientMessage(playerid, COLOR_GREY, "You can't modify the admin level of someone who retains a higher level of admin.");

		if(playerVariables[iTarget][pAdminLevel] < iLevel) {
		    format(szMessage, sizeof(szMessage), "You've been promoted to level %d admin, by %s.", iLevel, playerVariables[playerid][pNormalName]);
		    SendClientMessage(iTarget, COLOR_YELLOW, szMessage);

		    format(szMessage, sizeof(szMessage), "You've promoted %s to level %d admin.", playerVariables[iTarget][pNormalName], iLevel);
		    SendClientMessage(playerid, COLOR_YELLOW, szMessage);
		} else {
		    format(szMessage, sizeof(szMessage), "You've been demoted to level %d admin, by %s.", iLevel, playerVariables[playerid][pNormalName]);
		    SendClientMessage(iTarget, COLOR_YELLOW, szMessage);

		    format(szMessage, sizeof(szMessage), "You've demoted %s to level %d admin.", playerVariables[iTarget][pNormalName], iLevel);
		    SendClientMessage(playerid, COLOR_YELLOW, szMessage);
		}

	    playerVariables[iTarget][pAdminLevel] = iLevel;
	    
	    
    } else forceAdminConfirmPIN(playerid, "setadminlevel", params);
    
	return 1;
}

CMD:adminduty(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 1) {
		if(!strcmp(playerVariables[playerid][pAdminName], "(null)", true)) {
			return SendClientMessage(playerid, COLOR_GREY, "You don't have an admin name set. Contact a Head Admin (or higher) first.");
		}
		else {
		    switch(playerVariables[playerid][pAdminDuty]) {
				case 0: {
				    playerVariables[playerid][pAdminDuty] = 1;
					GetPlayerHealth(playerid, playerVariables[playerid][pHealth]);
					GetPlayerArmour(playerid, playerVariables[playerid][pArmour]);
					SetPlayerName(playerid, playerVariables[playerid][pAdminName]);
					SetPlayerHealth(playerid, 500000.0);
					format(szMessage, sizeof(szMessage), "Notice: {FFFFFF}Admin %s (%s) is now on administrative duty.", playerVariables[playerid][pAdminName], playerVariables[playerid][pNormalName]);
				}
				case 1: {
				    playerVariables[playerid][pAdminDuty] = 0;
					SetPlayerName(playerid, playerVariables[playerid][pNormalName]);
					SetPlayerHealth(playerid, playerVariables[playerid][pHealth]);
					SetPlayerArmour(playerid, playerVariables[playerid][pArmour]);
					format(szMessage, sizeof(szMessage), "Notice: {FFFFFF}Admin %s (%s) is now off administrative duty.", playerVariables[playerid][pAdminName], playerVariables[playerid][pNormalName]);
				}
			}
			submitToAdmins(szMessage, COLOR_HOTORANGE);
		}
	}
	return 1;
}

CMD:admins(playerid, params[]) {
    SendClientMessage(playerid, COLOR_TEAL, "----------------------------------------------------------------------------");

	foreach(Player, x) {
		if(playerVariables[x][pAdminLevel] >= 1 && playerVariables[x][pAdminDuty] >= 1) {
			format(szMessage, sizeof(szMessage), "Administrator %s is on duty (level %d).", playerVariables[x][pAdminName], playerVariables[x][pAdminLevel]);
			SendClientMessage(playerid, COLOR_GREEN, szMessage);
		}
		if(playerVariables[x][pAdminLevel] >= 1 && playerVariables[playerid][pAdminLevel] >= 1 && playerVariables[x][pAdminDuty] < 1) {
			format(szMessage, sizeof(szMessage), "Administrator %s (%s) is off duty (level %d).", playerVariables[x][pAdminName], playerVariables[x][pNormalName], playerVariables[x][pAdminLevel]);
			SendClientMessage(playerid, COLOR_GREY, szMessage);
		}
	}

    SendClientMessage(playerid, COLOR_TEAL, "----------------------------------------------------------------------------");
	return 1;
}

CMD:give(playerid, params[]) {
	new
	    giveSz[12],
		amount,
		targetID;

	if(sscanf(params, "us[12]d", targetID, giveSz, amount)) {
	    SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/give [playerid] [item] [amount]");
	    return SendClientMessage(playerid, COLOR_GREY, "Items: Materials");
	}
	else {
	    if(targetID == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
	    if(!IsPlayerInRangeOfPlayer(playerid, targetID, 5.0)) return SendClientMessage(playerid, COLOR_GREY, "You're too far away.");

	    if(strcmp(giveSz, "materials", true) == 0) {
	        new
	            playerName[2][MAX_PLAYER_NAME];

	        GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
	        GetPlayerName(targetID, playerName[1], MAX_PLAYER_NAME);

			if(playerVariables[playerid][pMaterials] >= amount) {
			    if(amount < 1)
					return 1;

                playerVariables[playerid][pMaterials] -= amount;
                playerVariables[targetID][pMaterials] += amount;

                format(szMessage, sizeof(szMessage), "You have given %d materials to %s.", amount, playerName[1]);
                SendClientMessage(playerid, COLOR_WHITE, szMessage);

                format(szMessage, sizeof(szMessage), "%s has given you %d materials.", playerName[0], amount);
                SendClientMessage(targetID, COLOR_WHITE, szMessage);

                format(szMessage, sizeof(szMessage), "* %s has given %d materials to %s.", playerName[0], amount, playerName[1]);
                nearByMessage(playerid, COLOR_PURPLE, szMessage);
			}
			else {
				format(szMessage, sizeof(szMessage), "You don't have enough materials to complete this trade. You need %d more materials.", playerVariables[playerid][pMaterials]-amount);
				SendClientMessage(playerid, COLOR_WHITE, szMessage);
			}
		}
	}
	return 1;
}

CMD:giveweapon(playerid, params[]) {
	new
		id,
		weapon;

	if(sscanf(params, "u", id))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/giveweapon [playerid]");
		
	else if(playerVariables[playerid][pFreezeType] == 0) {
		if(id != INVALID_PLAYER_ID) {
	   	    if(IsPlayerInRangeOfPlayer(playerid, id, 4.0) && !IsPlayerInAnyVehicle(playerid)) {

				weapon = GetPlayerWeapon(playerid);

				switch(weapon) {
					case 16, 18, 35, 36, 37, 38, 39, 40, 44, 45, 46, 0: SendClientMessage(playerid, COLOR_GREY, "Invalid weapon.");
					default: {

						GetPlayerName(id, szPlayerName, MAX_PLAYER_NAME);
						format(szMessage, sizeof(szMessage), "You have offered to give %s your %s.", szPlayerName, WeaponNames[weapon]);
						SendClientMessage(playerid, COLOR_WHITE, szMessage);

						GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
						format(szMessage, sizeof(szMessage), "%s has offered to give you their %s - type /accept weapon to receive it.", szPlayerName, WeaponNames[weapon]);
						SendClientMessage(id, COLOR_NICESKY, szMessage);

						SetPVarInt(id,"gunID",playerid);
						SetPVarInt(playerid,"gun",weapon);
						SetPVarInt(playerid,"slot",GetWeaponSlot(weapon));
					}
				}
	    	}
	    	else SendClientMessage(playerid, COLOR_GREY, "You're too far away or in a vehicle.");
	    }
		else SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "You can't do this while cuffed, tazed, or frozen.");
	return 1;
}

CMD:givearmour(playerid, params[]) {
	new
		id;

	if(sscanf(params, "u", id))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/givearmour [playerid]");

	else if(playerVariables[playerid][pFreezeType] == 0) {
		if(id != INVALID_PLAYER_ID) {
	   	    if(IsPlayerInRangeOfPlayer(playerid, id, 4.0)) {

				new
					Float:fArmour;

				GetPlayerArmour(playerid, fArmour);

				if(fArmour > 0) {
					GetPlayerName(id, szPlayerName, MAX_PLAYER_NAME);
					format(szMessage, sizeof(szMessage), "You have offered to give %s your kevlar vest (%.1f percent).", szPlayerName, fArmour);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);

					GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
					format(szMessage, sizeof(szMessage), "%s has offered to give you their kevlar vest (%.1f percent) - type /accept armour to receive it.", szPlayerName, fArmour);
					SendClientMessage(id, COLOR_NICESKY, szMessage);

					SetPVarInt(id, "aID", playerid + 1);
				}
				else SendClientMessage(playerid, COLOR_GREY, "You have no armour to give.");
	    	}
	    	else SendClientMessage(playerid, COLOR_GREY, "You're too far away.");
	    }
		else SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "You can't do this while cuffed, tazed, or frozen.");
	return 1;
}

CMD:noscar(playerid, params[]) 
{
	if(jobVariables[playerVariables[playerid][pJob]][jJobType] == 3) 
	{
		new vehicleID = GetPlayerVehicleID(playerid);
		if(vehicleID != 0) 
		{
			new Float:soPos[3], vehicleModel = GetVehicleModel(vehicleID);

			if(IsInvalidNOSVehicle(vehicleModel)) 
			{
				format(szMessage, sizeof(szMessage), "You can't modify this %s.", VehicleNames[vehicleModel - 400]);
		        SendClientMessage(playerid, COLOR_GREY, szMessage);
		    }
		    else if(playerVariables[playerid][pJobDelay] == 0) 
			{

				GetVehiclePos(vehicleID, soPos[0], soPos[1], soPos[2]);
				PlayerPlaySoundEx(1133, soPos[0], soPos[1], soPos[2]);

				AddVehicleComponent(vehicleID, 1010);
				format(szMessage, sizeof(szMessage), "You have applied nitrous to your %s for $1,000.", VehicleNames[vehicleModel - 400]);
				SendClientMessage(playerid, COLOR_WHITE, szMessage);
				playerVariables[playerid][pMoney] -= 1000;
				playerVariables[playerid][pJobDelay] = 60;
		    }
		    else 
			{
				format(szMessage, sizeof(szMessage), "You need to wait %d seconds until you can use a mechanic command again.",playerVariables[playerid][pJobDelay]);
		        SendClientMessage(playerid, COLOR_GREY, szMessage);
			}
		}
		else
			SendClientMessage(playerid, COLOR_GREY, "You're not in any vehicle.");
	}
	return 1;
}

CMD:hydcar(playerid, params[]) 
{
	if(jobVariables[playerVariables[playerid][pJob]][jJobType] == 3) 
	{
		new vehicleID = GetPlayerVehicleID(playerid);
		if(vehicleID != 0) 
		{
			new Float:soPos[3], vehicleModel = GetVehicleModel(vehicleID);

			if(IsInvalidNOSVehicle(vehicleModel)) 
			{
				format(szMessage, sizeof(szMessage), "You can't modify this %s.", VehicleNames[vehicleModel - 400]);
		        SendClientMessage(playerid, COLOR_GREY, szMessage);
		    }
		    else if(playerVariables[playerid][pJobDelay] == 0) 
			{
				GetVehiclePos(vehicleID, soPos[0], soPos[1], soPos[2]);
				PlayerPlaySoundEx(1133, soPos[0], soPos[1], soPos[2]);

				AddVehicleComponent(vehicleID, 1087);
				format(szMessage, sizeof(szMessage), "You have applied hydraulics to your %s for $1,000.", VehicleNames[vehicleModel - 400]);
				SendClientMessage(playerid, COLOR_WHITE, szMessage);
				playerVariables[playerid][pMoney] -= 1000;
				playerVariables[playerid][pJobDelay] = 60;
		    }
		    else 
			{
				format(szMessage, sizeof(szMessage), "You need to wait %d seconds until you can use a mechanic command again.",playerVariables[playerid][pJobDelay]);
		        SendClientMessage(playerid, COLOR_GREY, szMessage);
			}
		}
		else 
			SendClientMessage(playerid, COLOR_GREY, "You're not in any vehicle.");
	}
	return 1;
}


CMD:seenewbie(playerid, params[]) {
	if(playerVariables[playerid][pNewbieEnabled] == 1) {
	    playerVariables[playerid][pNewbieEnabled] = 0;
	    SendClientMessage(playerid, COLOR_WHITE, "You will no longer see newbie chat.");
	}
	else {
	    playerVariables[playerid][pNewbieEnabled] = 1;
	    SendClientMessage(playerid, COLOR_WHITE, "You will now see newbie chat.");
	}
	return 1;
}

CMD:getmats(playerid, params[]) {
    if(jobVariables[playerVariables[playerid][pJob]][jJobType] != 1) return 1;

	if(IsPlayerInRangeOfPoint(playerid, 5, 1423.9871, -1319.2954, 13.5547)) {
	    if(playerVariables[playerid][pCheckpoint] == 0) {
	        if(playerVariables[playerid][pMoney] >= 1000) {
		        SetPlayerCheckpoint(playerid, 2166.6870, -2272.5073, 13.3623, 10);
		        SendClientMessage(playerid, COLOR_WHITE, "Reach the checkpoint to collect your materials.");
		        playerVariables[playerid][pCheckpoint] = 2;
		        playerVariables[playerid][pMoney] -= 1000;
		        playerVariables[playerid][pMatrunTime] = 1;
	        }
	        else {
				return SendClientMessage(playerid, COLOR_GREY, "You need to pay $1000 to collect materials.");
			}
	    }
	    else {
	        format(szMessage, sizeof(szMessage), "You already have an active checkpoint (%s), reach it first, or /killcheckpoint.", getPlayerCheckpointReason(playerid));
			SendClientMessage(playerid, COLOR_WHITE, szMessage);
		}
	}

	return 1;
}

CMD:dropcar(playerid, params[]) {
	if(playerVariables[playerid][pCheckpoint] >= 1) {
        format(szMessage, sizeof(szMessage), "You already have an active checkpoint (%s), reach it first, or /killcheckpoint.", getPlayerCheckpointReason(playerid));
		SendClientMessage(playerid, COLOR_WHITE, szMessage);
	}
	else {
	    if(playerVariables[playerid][pDropCarTimeout] >= 1)
			return SendClientMessage(playerid, COLOR_GREY, "You can't drop a vehicle as you still have time to wait. Check /time.");
			
	    playerVariables[playerid][pCheckpoint] = 3;
	    SendClientMessage(playerid, COLOR_WHITE, "Reach the checkpoint to drop your vehicle off at the crane.");
		SetPlayerCheckpoint(playerid, 2699.2781, -2225.4299, 13.5501, 10);
	}
	return 1;
}

CMD:newbie(playerid, params[]) {
	if(playerVariables[playerid][pNewbieTimeout] > 0 && playerVariables[playerid][pAdminLevel] < 1) {
		SendClientMessage(playerid,COLOR_GREY, "You must wait until you can speak again in the newbie chat channel.");
		return 1;
	}
	if(!isnull(params)) {
	    GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

		if(playerVariables[playerid][pAdminLevel] > 0 && playerVariables[playerid][pAdminDuty] != 0) {
			format(szMessage, sizeof(szMessage), "** Admin %s: %s", szPlayerName, params);
		}
		else if(playerVariables[playerid][pHelper] >= 1 && playerVariables[playerid][pHelperDuty] >= 1) {
		    format(szMessage, sizeof(szMessage), "** Helper %s: %s", szPlayerName, params);
			playerVariables[playerid][pNewbieTimeout] = 5;
		}
		else if(playerVariables[playerid][pAdminLevel] > 0 && playerVariables[playerid][pAdminDuty] == 0) {
			format(szMessage, sizeof(szMessage), "** Player %s: %s", szPlayerName, params);
		}
		else if(playerVariables[playerid][pPlayingHours] >= 100) {
			format(szMessage, sizeof(szMessage), "** Player %s: %s", szPlayerName, params);
			playerVariables[playerid][pNewbieTimeout] = 30;
		}
		else {
			format(szMessage, sizeof(szMessage), "** Newbie %s: %s", szPlayerName, params);
			playerVariables[playerid][pNewbieTimeout] = 30;
		}
		foreach(Player, x) {
			if(playerVariables[x][pStatus] == 1 && playerVariables[x][pNewbieEnabled] == 1) {
				SendClientMessage(x, COLOR_NEWBIE, szMessage);
			}
		}
	}
	else {
	    return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/(n)ewbie [question]");
	}
	return 1;
}

CMD:listassets(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 5) {
        for(new x = 0; x < MAX_ASSETS; x++) {
			if(strlen(assetVariables[x][aAssetName]) >= 1) {
				format(szMessage, sizeof(szMessage), "Asset Name: %s | Asset ID: %d | Value: %d", assetVariables[x][aAssetName], x, assetVariables[x][aAssetValue]);
				SendClientMessage(playerid, COLOR_WHITE, szMessage);
			}
		}
	}
	return 1;
}

CMD:listmygroup(playerid, params[]) {
	if(playerVariables[playerid][pGroup] >= 1 && playerVariables[playerid][pGroupRank] >= 4) {
		SendClientMessage(playerid, COLOR_TEAL, "----------------------------------------------------------------");

		foreach(Player, i) {
	        if(IsPlayerAuthed(i) && playerVariables[i][pGroup] == playerVariables[playerid][pGroup] && playerVariables[i][pAdminDuty] < 1) {

				switch(playerVariables[i][pGroupRank]) {
					case 1: format(szMessage, sizeof(szMessage), "* (%d) %s %s", playerVariables[i][pGroupRank], groupVariables[playerVariables[i][pGroup]][gGroupRankName1], playerVariables[i][pNormalName]);
					case 2: format(szMessage, sizeof(szMessage), "* (%d) %s %s", playerVariables[i][pGroupRank], groupVariables[playerVariables[i][pGroup]][gGroupRankName2], playerVariables[i][pNormalName]);
					case 3: format(szMessage, sizeof(szMessage), "* (%d) %s %s", playerVariables[i][pGroupRank], groupVariables[playerVariables[i][pGroup]][gGroupRankName3], playerVariables[i][pNormalName]);
					case 4: format(szMessage, sizeof(szMessage), "* (%d) %s %s", playerVariables[i][pGroupRank], groupVariables[playerVariables[i][pGroup]][gGroupRankName4], playerVariables[i][pNormalName]);
					case 5: format(szMessage, sizeof(szMessage), "* (%d) %s %s", playerVariables[i][pGroupRank], groupVariables[playerVariables[i][pGroup]][gGroupRankName5], playerVariables[i][pNormalName]);
					case 6: format(szMessage, sizeof(szMessage), "* (%d) %s %s", playerVariables[i][pGroupRank], groupVariables[playerVariables[i][pGroup]][gGroupRankName6], playerVariables[i][pNormalName]);

				}
				SendClientMessage(playerid, COLOR_WHITE, szMessage);
	        }
	    }
	    SendClientMessage(playerid, COLOR_TEAL, "----------------------------------------------------------------");
	}
	return 1;
}

CMD:n(playerid, params[]) {
	return cmd_newbie(playerid, params);
}

CMD:set(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 3) {
        new
            item[32],
            userID,
            amount;

        if(sscanf(params, "us[32]d", userID, item, amount)) {
			SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/set [playerid] [item] [amount]");
			SendClientMessage(playerid, COLOR_GREY, "Items: Health, Armour, Money, BankMoney, Skin, Interior, VirtualWorld, Job, JobSkill1, JobSkill2,");
			SendClientMessage(playerid, COLOR_GREY, "Phone, Materials, Group, GroupRank, Age, Gender");
		}
        else if(IsPlayerAuthed(userID)) {
            if(playerVariables[playerid][pAdminLevel] >= playerVariables[userID][pAdminLevel]) {
				GetPlayerName(userID, szPlayerName, MAX_PLAYER_NAME);

				if(strcmp(item, "health", true) == 0) {
					format(szMessage, sizeof(szMessage), "You have set %s (ID: %d)'s health to %d.", szPlayerName, userID, amount);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);
					SetPlayerHealth(userID, amount);
				}
				else if(strcmp(item, "jobskill2", true) == 0) {
					format(szMessage, sizeof(szMessage), "You have set %s (ID: %d)'s JobSkill2 to %d.", szPlayerName, userID, amount);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);
					playerVariables[userID][pJobSkill][1] = amount;
				}
				else if(strcmp(item, "jobskill1", true) == 0) {
					format(szMessage, sizeof(szMessage), "You have set %s (ID: %d)'s JobSkill1 to %d.", szPlayerName, userID, amount);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);
					playerVariables[userID][pJobSkill][0] = amount;
				}
				else if(strcmp(item, "virtualworld", true) == 0) {
					format(szMessage, sizeof(szMessage), "You have set %s (ID: %d)'s virtual world to %d.", szPlayerName, userID, amount);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);
					SetPlayerVirtualWorld(userID, amount);
					playerVariables[userID][pVirtualWorld] = amount;
				}
				else if(strcmp(item, "interior", true) == 0) {
					format(szMessage, sizeof(szMessage), "You have set %s (ID: %d)'s interior to %d.", szPlayerName, userID, amount);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);
					SetPlayerInterior(userID, amount);
					playerVariables[userID][pInterior] = amount;
				}
				else if(strcmp(item, "job", true) == 0) {
					if(amount >= 0 && amount <= MAX_JOBS) {
						format(szMessage, sizeof(szMessage), "You have set %s (ID: %d)'s job to %d.", szPlayerName, userID, amount);
						SendClientMessage(playerid, COLOR_WHITE, szMessage);
						playerVariables[userID][pJob] = amount;
						playerVariables[userID][pJobDelay] = 0;
					}
					else SendClientMessage(playerid, COLOR_GREY, "Invalid job specified.");
				}
				else if(strcmp(item, "armour", true) == 0) {
					format(szMessage, sizeof(szMessage), "You have set %s (ID: %d)'s armour to %d.", szPlayerName, userID, amount);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);
					SetPlayerArmour(userID, amount);
				}
				else if(strcmp(item, "bankmoney", true) == 0) {
					format(szMessage, sizeof(szMessage), "You have set %s (ID: %d)'s bank balance to %d.", szPlayerName, userID, amount);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);
					playerVariables[userID][pBankMoney] = amount;
				}
				else if(strcmp(item, "money", true) == 0) {
					format(szMessage, sizeof(szMessage), "You have set %s (ID: %d)'s money to %d.", szPlayerName, userID, amount);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);
					playerVariables[userID][pMoney] = amount;
				}
				else if(strcmp(item, "materials", true) == 0) {
					format(szMessage, sizeof(szMessage), "You have set %s (ID: %d)'s materials to %d.", szPlayerName, userID, amount);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);
					playerVariables[userID][pMaterials] = amount;
				}
				else if(strcmp(item, "skin", true) == 0) {
					if(IsValidSkin(amount)) {
						format(szMessage, sizeof(szMessage), "You have set %s (ID: %d)'s skin to %d.", szPlayerName, userID, amount);
						SendClientMessage(playerid, COLOR_WHITE, szMessage);
						SetPlayerSkin(userID, amount);
						if(playerVariables[userID][pEvent] == 1) SendClientMessage(playerid, COLOR_WHITE, "As this player is participating in an event, their original skin will be restored once it has ended.");
						else playerVariables[userID][pSkin] = amount;
					}
					else SendClientMessage(playerid, COLOR_GREY, "Invalid skin specified.");
				}
				else if(strcmp(item, "phone", true) == 0) {
					format(szMessage, sizeof(szMessage), "You have set %s (ID: %d)'s phone number to %d.", szPlayerName, userID, amount);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);
					playerVariables[userID][pPhoneNumber] = amount;
				}
				else if(strcmp(item, "group", true) == 0) {
					if(amount >= 0 && amount <= MAX_GROUPS) {

						format(szMessage, sizeof(szMessage), "You have set %s (ID: %d)'s group to %d.", szPlayerName, userID, amount);
						SendClientMessage(playerid, COLOR_WHITE, szMessage);

						format(szMessage, sizeof(szMessage), "%s has left the group (admin-set).", szPlayerName);
						SendToGroup(playerVariables[userID][pGroup], COLOR_GENANNOUNCE, szMessage);

						playerVariables[userID][pGroup] = amount;

						format(szMessage, sizeof(szMessage), "%s has joined the group (admin-set).", szPlayerName);
						SendToGroup(playerVariables[userID][pGroup], COLOR_GENANNOUNCE, szMessage);
					}
					else SendClientMessage(playerid, COLOR_GREY, "Invalid group specified.");
				}
				else if(strcmp(item, "grouprank", true) == 0) {
					if(amount >= 1 && amount <= 6) {
						format(szMessage, sizeof(szMessage), "You have set %s (ID: %d)'s group rank to %d.", szPlayerName, userID, amount);
						SendClientMessage(playerid, COLOR_WHITE, szMessage);
						playerVariables[userID][pGroupRank] = amount;
					}
					else SendClientMessage(playerid, COLOR_GREY, "Invalid rank specified.");
				}
				else if(strcmp(item, "age", true) == 0) {
					if(amount >= 16 && amount <= 122) {

						new
							dates[3];

						getdate(dates[0], dates[1], dates[2]);
						playerVariables[userID][pAge] = dates[0] - amount;

						format(szMessage, sizeof(szMessage), "You have set %s (ID: %d)'s age to %d (birth year %d).", szPlayerName, userID, amount, playerVariables[userID][pAge]);
						SendClientMessage(playerid, COLOR_WHITE, szMessage);
					}
					else SendClientMessage(playerid, COLOR_GREY, "Invalid age specified (must be between 16 and 122 years old).");
				}
				else if(strcmp(item, "gender", true) == 0) {
					if(amount >= 1 && amount <= 2) {

						playerVariables[userID][pGender] = amount;

						switch(playerVariables[userID][pGender]) {
							case 1: format(szMessage, sizeof(szMessage), "You have set %s (ID: %d)'s gender to male.", szPlayerName, userID);
							case 2: format(szMessage, sizeof(szMessage), "You have set %s (ID: %d)'s gender to female.", szPlayerName, userID);
						}
						SendClientMessage(playerid, COLOR_WHITE, szMessage);
					}
					else SendClientMessage(playerid, COLOR_GREY, "Invalid gender specified; must be 1 (male) or 2 (female).");
				}
			}
			else SendClientMessage(playerid, COLOR_GREY, "You can't set a higher level administrator's statistics.");
        }
		else SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
    }
	return 1;
}

CMD:gmotd(playerid, params[]) {
	if(playerVariables[playerid][pGroup] >= 1 && playerVariables[playerid][pGroupRank] >= 5) {
	    if(!isnull(params)) {
			format(szMessage, sizeof(szMessage), "You have changed the group MOTD to %s.", params);
			SendClientMessage(playerid, COLOR_WHITE, szMessage);

			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
			format(szMessage, sizeof(szMessage), "%s has changed the group MOTD to '%s'.", szPlayerName, params);
			SendToGroup(playerVariables[playerid][pGroup], COLOR_GENANNOUNCE, szMessage);

			mysql_real_escape_string(params, szMessage);

			strcpy(groupVariables[playerVariables[playerid][pGroup]][gGroupMOTD], szMessage, 128);
		}
		else {
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/gmotd [text]");
		}
	}
	return 1;
}

CMD:gsafepos(playerid, params[]) {
	if(playerVariables[playerid][pGroup] >= 1 && playerVariables[playerid][pGroupRank] >= 6) {

		GetPlayerPos(playerid, groupVariables[playerVariables[playerid][pGroup]][gSafePos][0], groupVariables[playerVariables[playerid][pGroup]][gSafePos][1], groupVariables[playerVariables[playerid][pGroup]][gSafePos][2]);

		DestroyDynamicPickup(groupVariables[playerVariables[playerid][pGroup]][gSafePickupID]);
		DestroyDynamic3DTextLabel(groupVariables[playerVariables[playerid][pGroup]][gSafeLabelID]);

		format(szMessage, sizeof(szMessage), "%s\nGroup Safe", groupVariables[playerVariables[playerid][pGroup]][gGroupName]);

		groupVariables[playerVariables[playerid][pGroup]][gSafePickupID] = CreateDynamicPickup(1239, 23, groupVariables[playerVariables[playerid][pGroup]][gSafePos][0], groupVariables[playerVariables[playerid][pGroup]][gSafePos][1], groupVariables[playerVariables[playerid][pGroup]][gSafePos][2], GROUP_VIRTUAL_WORLD+playerVariables[playerid][pGroup], groupVariables[playerVariables[playerid][pGroup]][gGroupHQInteriorID], -1, 50);
		groupVariables[playerVariables[playerid][pGroup]][gSafeLabelID] = CreateDynamic3DTextLabel(szMessage, COLOR_YELLOW, groupVariables[playerVariables[playerid][pGroup]][gSafePos][0], groupVariables[playerVariables[playerid][pGroup]][gSafePos][1], groupVariables[playerVariables[playerid][pGroup]][gSafePos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, GROUP_VIRTUAL_WORLD+playerVariables[playerid][pGroup], groupVariables[playerVariables[playerid][pGroup]][gGroupHQInteriorID], -1, 50.0);

		SendClientMessage(playerid, COLOR_WHITE, "You have adjusted the position of your group's safe.");
	}
	return 1;
}

CMD:gname(playerid, params[]) {
	if(playerVariables[playerid][pGroup] >= 1 && playerVariables[playerid][pGroupRank] >= 6) {
	    if(!isnull(params)) {

			new
				safeString[102];

			format(safeString, sizeof(safeString), "You have changed the group name to %s.", params);
			SendClientMessage(playerid, COLOR_WHITE, safeString);

			mysql_real_escape_string(params, safeString);

			strcpy(groupVariables[playerVariables[playerid][pGroup]][gGroupName], safeString, 64);

			switch(groupVariables[playerVariables[playerid][pGroup]][gGroupHQLockStatus]) {
				case 0: format(safeString, sizeof(safeString), "%s's HQ\n\nPress ~k~~PED_DUCK~ to enter.", groupVariables[playerVariables[playerid][pGroup]][gGroupName]);
				case 1: format(safeString, sizeof(safeString), "%s's HQ\n\n(locked)", groupVariables[playerVariables[playerid][pGroup]][gGroupName]);
			}

			UpdateDynamic3DTextLabelText(groupVariables[playerVariables[playerid][pGroup]][gGroupLabelID], COLOR_YELLOW, safeString);

			format(safeString, sizeof(safeString), "%s\nGroup Safe", groupVariables[playerVariables[playerid][pGroup]][gGroupName]);

			UpdateDynamic3DTextLabelText(groupVariables[playerVariables[playerid][pGroup]][gSafeLabelID], COLOR_YELLOW, safeString);

		}
		else SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/gname [group name]");
	}
	return 1;
}

CMD:showmotd(playerid, params[]) {
	if(playerVariables[playerid][pGroup] >= 1) {

		new string[128];
		format(string, sizeof(string), "Group MOTD: {FFFFFF}%s", groupVariables[playerVariables[playerid][pGroup]][gGroupMOTD]);
		SendClientMessage(playerid, COLOR_GENANNOUNCE, string);
	}
	return 1;
}

CMD:upgradelevel(playerid, params[]) {
	/* 1 level costs Level x min_level_upgrade_cost */
	if(playerVariables[playerid][pBankMoney] >= playerVariables[playerid][pLevel] + 1 * assetVariables[3][aAssetValue] && playerVariables[playerid][pBankMoney] > 0) {
	    if(playerVariables[playerid][pLevel] >= 10)
	        return SendClientMessage(playerid, COLOR_GREY, "You're at the maximum level.");

		if(FetchLevelFromHours(playerVariables[playerid][pPlayingHours]) == playerVariables[playerid][pLevel])
		    return SendClientMessage(playerid, COLOR_GREY, "You can't upgrade your level yet.");

        playerVariables[playerid][pLevel] += 1;
        playerVariables[playerid][pBankMoney] -= playerVariables[playerid][pLevel] + 1 * assetVariables[3][aAssetValue];

        SetPlayerScore(playerid, playerVariables[playerid][pLevel]);
	}
	return 1;
}

CMD:invite(playerid, params[]) {
    if(playerVariables[playerid][pGroup] >= 1 && playerVariables[playerid][pGroupRank] >= 5) {
        new
            userID;

        if(sscanf(params, "u", userID)) {
            return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/invite [playerid]");
        }
        else {
            if(!IsPlayerConnected(userID)) return SendClientMessage(playerid, COLOR_GREY, "The specified userID/name is not connected.");
			else if(playerVariables[userID][pGroup] > 0) return SendClientMessage(playerid, COLOR_GREY, "That player is already in a group.");

			if(playerVariables[userID][pLevel] < assetVariables[2][aAssetValue]) {
			    format(szMessage, sizeof(szMessage), "You can't invite a player below level %d.", assetVariables[2][aAssetValue]);
			    SendClientMessage(playerid, COLOR_GREY, szMessage);

			    format(szMessage, sizeof(szMessage), "You have been invited to a group, but you can't accept the invite. You must be at least level %d, you've got %d levels to go!", assetVariables[2][aAssetValue], assetVariables[2][aAssetValue]-playerVariables[userID][pLevel]);
			    return SendClientMessage(playerid, COLOR_GREY, szMessage);
			}

			GetPlayerName(userID, szPlayerName, MAX_PLAYER_NAME);
			format(szMessage, sizeof(szMessage), "You have invited %s to join your group.", szPlayerName);
			SendClientMessage(playerid, COLOR_WHITE, szMessage);

			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
			format(szMessage, sizeof(szMessage), "%s has invited you to join group %s (to accept the invitation, type '/accept invite').", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupName]);
			SendClientMessage(userID, COLOR_NICESKY, szMessage);

			SetPVarInt(userID, "invID", playerVariables[playerid][pGroup]); // Storing in a PVar as it's something that won't be used frequently, saving memory. Also, keeping the variable names short, as they're stored in memory and literally kill!!1
		}
    }

    return 1;
}

CMD:uninvite(playerid, params[]) {
	if(playerVariables[playerid][pGroup] >= 1 && playerVariables[playerid][pGroupRank] >= 5) {
	    new
	        userID;

        if(sscanf(params, "u", userID)) {
            return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/uninvite [playerid]");
        }
        else {
            if(!IsPlayerConnected(userID)) return SendClientMessage(playerid, COLOR_GREY, "The specified userID/name is not connected.");
			else if(playerVariables[playerid][pGroup] != playerVariables[userID][pGroup]) return SendClientMessage(playerid, COLOR_GREY, "That player isn't in your group.");
			else if(playerVariables[playerid][pGroupRank] <= playerVariables[userID][pGroupRank]) return SendClientMessage(playerid, COLOR_GREY, "You can't uninvite this person.");

			new
				messageString[119];

			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
			format(messageString, sizeof(messageString), "%s has removed you from the %s.", szPlayerName, groupVariables[playerVariables[userID][pGroup]][gGroupName]);
			SendClientMessage(userID, COLOR_NICESKY, messageString);

			GetPlayerName(userID, szPlayerName, MAX_PLAYER_NAME);
			format(messageString, sizeof(messageString), "You have removed %s from your group.", szPlayerName);
			SendClientMessage(playerid, COLOR_WHITE, messageString);

			format(messageString, sizeof(messageString), "%s has left the group (uninvited).", szPlayerName);
			SendToGroup(playerVariables[playerid][pGroup], COLOR_GENANNOUNCE, messageString);

			playerVariables[userID][pGroup] = 0;
			playerVariables[userID][pGroupRank] = 0;
        }
	}
	return 1;
}
CMD:lockhq(playerid, params[]) {
	if(playerVariables[playerid][pGroup] >= 1 && playerVariables[playerid][pGroupRank] >= 5) {
		switch(groupVariables[playerVariables[playerid][pGroup]][gGroupHQLockStatus]) {
			case 1: {
			    SendClientMessage(playerid, COLOR_WHITE, "HQ unlocked.");
				groupVariables[playerVariables[playerid][pGroup]][gGroupHQLockStatus] = 0;
				format(szMessage, sizeof(szMessage), "%s's HQ\n\nPress ~k~~PED_DUCK~ to enter.", groupVariables[playerVariables[playerid][pGroup]][gGroupName]);
			}
			case 0: {
			    SendClientMessage(playerid, COLOR_WHITE, "HQ locked.");
				groupVariables[playerVariables[playerid][pGroup]][gGroupHQLockStatus] = 1;
			    format(szMessage, sizeof(szMessage), "%s's HQ\n\n(locked)", groupVariables[playerVariables[playerid][pGroup]][gGroupName]);
			}
		}

		UpdateDynamic3DTextLabelText(groupVariables[playerVariables[playerid][pGroup]][gGroupLabelID], COLOR_YELLOW, szMessage);
	}
	return 1;
}
CMD:changerank(playerid, params[]) {
	if(playerVariables[playerid][pGroup] >= 1 && playerVariables[playerid][pGroupRank] >= 5) {
	    new
			rank,
	        userID;

        if(sscanf(params, "ud", userID, rank)) {
            SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/changerank [playerid] [rank]");
        }
        else {
            if(!IsPlayerConnected(userID)) return SendClientMessage(playerid, COLOR_GREY, "The specified userID/name is not connected.");
			else if(rank < 1 || rank > 6) return SendClientMessage(playerid, COLOR_GREY, "Invalid rank specified.");
			else if(playerVariables[playerid][pGroup] != playerVariables[userID][pGroup]) return SendClientMessage(playerid, COLOR_GREY, "That player isn't in your group.");
			else if(playerVariables[playerid][pGroupRank] <= rank) return SendClientMessage(playerid, COLOR_GREY, "You can't promote to this rank.");
			else if(playerVariables[playerid][pGroupRank] <= playerVariables[userID][pGroupRank]) return SendClientMessage(playerid, COLOR_GREY, "You can't alter this person's rank.");
			else if(playerVariables[userID][pGroupRank] == rank) return SendClientMessage(playerid, COLOR_GREY, "That person is already of that rank.");
			else {

				new
					messageString[128];

				GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
				if(rank > playerVariables[userID][pGroupRank]) switch(rank) {

					case 1: format(messageString, sizeof(messageString), "%s has promoted you to the rank of %s (1).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName1]);
					case 2: format(messageString, sizeof(messageString), "%s has promoted you to the rank of %s (2).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName2]);
					case 3: format(messageString, sizeof(messageString), "%s has promoted you to the rank of %s (3).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName3]);
					case 4: format(messageString, sizeof(messageString), "%s has promoted you to the rank of %s (4).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName4]);
					case 5: format(messageString, sizeof(messageString), "%s has promoted you to the rank of %s (5).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName5]);
					case 6: format(messageString, sizeof(messageString), "%s has promoted you to the rank of %s (6).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName6]);

				}
				else switch(rank) {

					case 1: format(messageString, sizeof(messageString), "%s has demoted you to the rank of %s (1).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName1]);
					case 2: format(messageString, sizeof(messageString), "%s has demoted you to the rank of %s (2).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName2]);
					case 3: format(messageString, sizeof(messageString), "%s has demoted you to the rank of %s (3).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName3]);
					case 4: format(messageString, sizeof(messageString), "%s has demoted you to the rank of %s (4).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName4]);
					case 5: format(messageString, sizeof(messageString), "%s has demoted you to the rank of %s (5).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName5]);
					case 6: format(messageString, sizeof(messageString), "%s has demoted you to the rank of %s (6).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName6]);
				}
				SendClientMessage(userID, COLOR_NICESKY, messageString);

				GetPlayerName(userID, szPlayerName, MAX_PLAYER_NAME);

				if(rank > playerVariables[userID][pGroupRank]) switch(rank) {

					case 1: format(messageString, sizeof(messageString), "You have promoted %s to the rank of %s (1).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName1]);
					case 2: format(messageString, sizeof(messageString), "You have promoted %s to the rank of %s (2).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName2]);
					case 3: format(messageString, sizeof(messageString), "You have promoted %s to the rank of %s (3).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName3]);
					case 4: format(messageString, sizeof(messageString), "You have promoted %s to the rank of %s (4).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName4]);
					case 5: format(messageString, sizeof(messageString), "You have promoted %s to the rank of %s (5).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName5]);
					case 6: format(messageString, sizeof(messageString), "You have promoted %s to the rank of %s (6).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName6]);

				}
				else switch(rank) {

					case 1: format(messageString, sizeof(messageString), "You have demoted %s to the rank of %s (1).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName1]);
					case 2: format(messageString, sizeof(messageString), "You have demoted %s to the rank of %s (2).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName2]);
					case 3: format(messageString, sizeof(messageString), "You have demoted %s to the rank of %s (3).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName3]);
					case 4: format(messageString, sizeof(messageString), "You have demoted %s to the rank of %s (4).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName4]);
					case 5: format(messageString, sizeof(messageString), "You have demoted %s to the rank of %s (5).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName5]);
					case 6: format(messageString, sizeof(messageString), "You have demoted %s to the rank of %s (6).", szPlayerName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName6]);
				}
				SendClientMessage(playerid, COLOR_WHITE, messageString);

				playerVariables[userID][pGroupRank] = rank;
			}
        }
	}
	return 1;
}

CMD:granknames(playerid, params[]) {
    if(playerVariables[playerid][pGroup] >= 1 && playerVariables[playerid][pGroupRank] >= 6) {
		new
		    rankName[32],
		    rankID;

	    if(sscanf(params, "ds[32]", rankID, rankName)) {
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/granknames [rankid (1-6)] [rank title]");
		}
	    else {
	        new
				messageString[128];

	        switch(rankID) {
				case 1: {
				    mysql_real_escape_string(rankName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName1]);

				    format(messageString, sizeof(messageString), "You have changed the title of Rank 1 to '%s'.", rankName);
				    SendClientMessage(playerid, COLOR_WHITE, messageString);
				}
				case 2: {
				    mysql_real_escape_string(rankName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName2]);

				    format(messageString, sizeof(messageString), "You have changed the title of Rank 2 to '%s'.", rankName);
				    SendClientMessage(playerid, COLOR_WHITE, messageString);
				}
				case 3: {
				    mysql_real_escape_string(rankName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName3]);

				    format(messageString, sizeof(messageString), "You have changed the title of Rank 3 to '%s'.", rankName);
				    SendClientMessage(playerid, COLOR_WHITE, messageString);
				}
				case 4: {
				    mysql_real_escape_string(rankName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName4]);

				    format(messageString, sizeof(messageString), "You have changed the title of Rank 4 to '%s'.", rankName);
				    SendClientMessage(playerid, COLOR_WHITE, messageString);
				}
				case 5: {
				    mysql_real_escape_string(rankName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName5]);

				    format(messageString, sizeof(messageString), "You have changed the title of Rank 5 to '%s'.", rankName);
				    SendClientMessage(playerid, COLOR_WHITE, messageString);
				}
				case 6: {
				    mysql_real_escape_string(rankName, groupVariables[playerVariables[playerid][pGroup]][gGroupRankName6]);

				    format(messageString, sizeof(messageString), "You have changed the title of Rank 6 to '%s'.", rankName);
				    SendClientMessage(playerid, COLOR_WHITE, messageString);
				}
			}
	    }
    }
	return 1;
}

CMD:accept(playerid, params[]) {
	if(!isnull(params)) {
		if(strcmp(params, "ticket", true) == 0) {

			new
				ticketer = GetPVarInt(playerid, "tID") - 1,
				ticketPrice = GetPVarInt(playerid, "tP"),
				ticketString[128],
				ticketNames[2][MAX_PLAYER_NAME];

			if(ticketer != -1 && ticketPrice > 0) {
				if(IsPlayerAuthed(ticketer)) {
					if(IsPlayerInRangeOfPlayer(playerid, ticketer, 3.0)) {
						if(playerVariables[playerid][pMoney] >= ticketPrice) {

							GetPlayerName(playerid, ticketNames[0], MAX_PLAYER_NAME);
							GetPlayerName(ticketer, ticketNames[1], MAX_PLAYER_NAME);

							format(ticketString, sizeof(ticketString), "* %s takes out $%d in cash, and hands it to %s.", ticketNames[0], ticketPrice, ticketNames[1]);
							nearByMessage(playerid, COLOR_PURPLE, ticketString);

							format(ticketString, sizeof(ticketString), "%s has accepted the $%d ticket you issued them - you have received $%d.", ticketNames[0], ticketPrice, ticketPrice / 2);
							SendClientMessage(ticketer, COLOR_WHITE, ticketString);

							format(ticketString, sizeof(ticketString), "You have paid the $%d ticket %s issued you.", ticketPrice, ticketNames[1]);
							SendClientMessage(playerid, COLOR_WHITE, ticketString);

							playerVariables[playerid][pMoney] -= ticketPrice;
							playerVariables[ticketer][pMoney] += ticketPrice / 2;

							groupVariables[playerVariables[ticketer][pGroup]][gSafe][0] += ticketPrice / 2;

							DeletePVar(playerid, "tID");
							DeletePVar(playerid, "tP");

						}
						else {

							format(ticketString, sizeof(ticketString), "You can't afford to pay this ticket of $%d - you need another $%d to do so.", ticketPrice, ticketPrice - playerVariables[playerid][pMoney]);
							SendClientMessage(playerid, COLOR_GREY, ticketString);
						}
					}
					else SendClientMessage(playerid, COLOR_GREY, "You're too far away.");
				}
				else {
					SendClientMessage(playerid, COLOR_GREY, "The person issuing the ticket has disconnected.");
					DeletePVar(playerid, "tID");
					DeletePVar(playerid, "tP");
				}
			}
			else SendClientMessage(playerid, COLOR_GREY, "Nobody has issued you a ticket.");
		}
		else if(strcmp(params, "givecar", true) == 0) {

			new
				playerCarOffer = GetPVarInt(playerid, "gC") - 1, // <Divide by zero here>
				giveCarString[128],
				x,
				giveCarPlayerName[2][MAX_PLAYER_NAME];

		    if(playerCarOffer != -1) {
		        if(IsPlayerAuthed(playerCarOffer)) {
					if(playerVariables[playerid][pCarModel] < 1) {
						if(IsPlayerInRangeOfPlayer(playerid, playerCarOffer, 5.0)) {
							GetVehiclePos(playerVariables[playerCarOffer][pCarID], playerVariables[playerid][pCarPos][0], playerVariables[playerid][pCarPos][1], playerVariables[playerid][pCarPos][2]);
							GetVehicleZAngle(playerVariables[playerCarOffer][pCarID], playerVariables[playerid][pCarPos][3]); // Get pos and Z angle, save 'em to the accepting player

							playerVariables[playerid][pCarModel] = playerVariables[playerCarOffer][pCarModel]; // Transfer the car model

							playerVariables[playerid][pCarColour][0] = playerVariables[playerCarOffer][pCarColour][0]; // And the colours, and paint job
							playerVariables[playerid][pCarColour][1] = playerVariables[playerCarOffer][pCarColour][1];
							playerVariables[playerid][pCarPaintjob] = playerVariables[playerCarOffer][pCarPaintjob];

							playerVariables[playerid][pCarTrunk][0] = playerVariables[playerCarOffer][pCarTrunk][0];
							playerVariables[playerid][pCarTrunk][1] = playerVariables[playerCarOffer][pCarTrunk][1];

							while(x < 13) {
								playerVariables[playerid][pCarMods][x] = GetVehicleComponentInSlot(playerVariables[playerCarOffer][pCarID], x); // Mods, too.
								x++;
							}

							x = 0;

							while(x < 5) {
								playerVariables[playerid][pCarWeapons][x] = playerVariables[playerCarOffer][pCarWeapons][x];
								x++;
							}

							GetPlayerName(playerCarOffer, giveCarPlayerName[1], MAX_PLAYER_NAME);
							GetPlayerName(playerid, giveCarPlayerName[0], MAX_PLAYER_NAME);

							format(giveCarString, sizeof(giveCarString), "%s has accepted your offer, and is now the owner of this %s.", giveCarPlayerName[0], VehicleNames[playerVariables[playerid][pCarModel] - 400]);
							SendClientMessage(playerCarOffer, COLOR_WHITE, giveCarString);

							format(giveCarString, sizeof(giveCarString), "You have accepted %s's offer, and are now the owner of this %s.", giveCarPlayerName[1], VehicleNames[playerVariables[playerid][pCarModel] - 400]);
							SendClientMessage(playerid, COLOR_WHITE, giveCarString);

							format(giveCarString, sizeof(giveCarString), "* %s has given their car keys to %s.", giveCarPlayerName[1], giveCarPlayerName[0]);
							nearByMessage(playerid, COLOR_PURPLE, giveCarString);

							DestroyPlayerVehicle(playerCarOffer);
							SpawnPlayerVehicle(playerid);
							DeletePVar(playerid, "gC");
							
							ShowPlayerDialog(playerid, DIALOG_LICENSE_PLATE, DIALOG_STYLE_INPUT, "License plate registration", "Please enter a license plate for your vehicle. \n\nThere is only two conditions:\n- The license plate must be unique\n- The license plate can be alphanumerical, but it must consist of only 7 characters and include one space.", "Select", "");
						}
						else SendClientMessage(playerid, COLOR_GREY, "You're too far away.");
					}
					else SendClientMessage(playerid, COLOR_GREY, "You already own a vehicle.");
		        }
		        else { // Offering player disconnects.
		            DeletePVar(playerid, "gC");
		            SendClientMessage(playerid, COLOR_GREY, "The person offering the vehicle has disconnected.");
		        }
		    }
		    else SendClientMessage(playerid, COLOR_GREY, "Nobody has offered you a vehicle.");
		}
	    else if(strcmp(params, "invite", true) == 0) {
	        if(GetPVarInt(playerid, "invID") >= 1) {
	            new
	                messageString[64];

	            playerVariables[playerid][pGroup] = GetPVarInt(playerid, "invID");
				playerVariables[playerid][pGroupRank] = 1;

				DeletePVar(playerid, "invID");

				format(messageString, sizeof(messageString), "You are now a member of the %s.", groupVariables[playerVariables[playerid][pGroup]][gGroupName]);
				SendClientMessage(playerid, COLOR_NICESKY, messageString);

				GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
				format(messageString, sizeof(messageString), "%s has joined the group (invitation).", szPlayerName);
				SendToGroup(playerVariables[playerid][pGroup], COLOR_GENANNOUNCE, messageString);

	        }
	        else {
				return SendClientMessage(playerid, COLOR_GREY, "You don't have an active group invite request.");
			}
	    }

		else if(strcmp(params, "handshake", true) == 0) {
		    if(GetPVarInt(playerid,"hs") != 0) {
		        if(GetPlayerState(playerid) != 1) return SendClientMessage(playerid, COLOR_GREY, "You can only do this while on foot.");
		        if(IsPlayerInRangeOfPlayer(playerid, GetPVarInt(playerid,"hsID"), 1.5)) {

		            new
						Float: PosFloats[3],
						string[73],
						playerNames[2][MAX_PLAYER_NAME],
						shakeOffer = GetPVarInt(playerid,"hsID"),
						shakeStyle = GetPVarInt(playerid,"hs");

					if(!IsPlayerAuthed(shakeOffer)) return 1;

					PlayerFacePlayer(playerid, shakeOffer);
		            GetPlayerPos(shakeOffer, PosFloats[0], PosFloats[1], PosFloats[2]);
		            GetXYInFrontOfPlayer(shakeOffer, PosFloats[0], PosFloats[1], 0.5);
		            SetPlayerPos(playerid, PosFloats[0], PosFloats[1], PosFloats[2]); // Ensures that the players are in perfect position for it to happen.

					switch(shakeStyle) {
			            case 1: {
			                ApplyAnimation(playerid, "GANGS", "hndshkaa", 3.0, 1, 1, 1, 0, 1500, 1);
			                ApplyAnimation(shakeOffer, "GANGS", "hndshkaa", 3.0, 1, 1, 1, 0, 1500, 1);
			                ApplyAnimation(playerid, "GANGS", "hndshkaa", 3.0, 1, 1, 1, 0, 1500, 1);
			                ApplyAnimation(shakeOffer, "GANGS", "hndshkaa", 3.0, 1, 1, 1, 0, 1500, 1);
						}
			            case 2: {
			                ApplyAnimation(playerid, "GANGS", "hndshkba", 3.0, 1, 1, 1, 0, 1500, 1 );
			                ApplyAnimation(shakeOffer, "GANGS", "hndshkba", 3.0, 1, 1, 1, 0, 1500, 1);
			                ApplyAnimation(playerid, "GANGS", "hndshkba", 3.0, 1, 1, 1, 0, 1500, 1 );
			                ApplyAnimation(shakeOffer, "GANGS", "hndshkba", 3.0, 1, 1, 1, 0, 1500, 1);
			            }
			            case 3: {
			                ApplyAnimation(playerid, "GANGS", "hndshkca", 3.0, 1, 1, 1, 0, 1500, 1 );
			                ApplyAnimation(shakeOffer, "GANGS", "hndshkcb", 3.0, 1, 1, 1, 0, 1500, 1);
			                ApplyAnimation(playerid, "GANGS", "hndshkca", 3.0, 1, 1, 1, 0, 1500, 1 );
			                ApplyAnimation(shakeOffer, "GANGS", "hndshkcb", 3.0, 1, 1, 1, 0, 1500, 1);
			            }
			            case 4: {
			                ApplyAnimation(playerid, "GANGS", "hndshkda",3.0, 1, 1, 1, 0, 1500, 1);
			                ApplyAnimation(shakeOffer, "GANGS", "hndshkda", 3.0, 1, 1, 1, 0, 1500, 1);
			                ApplyAnimation(playerid, "GANGS", "hndshkda",3.0, 1, 1, 1, 0, 1500, 1);
			                ApplyAnimation(shakeOffer, "GANGS", "hndshkda", 3.0, 1, 1, 1, 0, 1500, 1);
			            }
			            case 5: {
			                ApplyAnimation(playerid, "GANGS", "hndshkea", 3.0, 1, 1, 1, 0, 1500, 1);
			                ApplyAnimation(shakeOffer, "GANGS", "hndshkea", 3.0, 1, 1, 1, 0, 1500, 1);
			                ApplyAnimation(playerid, "GANGS", "hndshkea", 3.0, 1, 1, 1, 0, 1500, 1);
			                ApplyAnimation(shakeOffer, "GANGS", "hndshkea", 3.0, 1, 1, 1, 0, 1500, 1);
			            }
			            case 6: {
			                ApplyAnimation(playerid, "GANGS", "hndshkfa", 3.0, 1, 1, 1, 0, 1500, 1 );
			                ApplyAnimation(shakeOffer, "GANGS", "hndshkfa", 3.0, 1, 1, 1, 0, 1500, 1);
			                ApplyAnimation(playerid, "GANGS", "hndshkfa", 3.0, 1, 1, 1, 0, 1500, 1 );
			                ApplyAnimation(shakeOffer, "GANGS", "hndshkfa", 3.0, 1, 1, 1, 0, 1500, 1);
			            }
			            case 7: {
			                ApplyAnimation(playerid, "GANGS", "prtial_hndshk_01", 3.0, 1, 1, 1, 0, 1500, 1);
			                ApplyAnimation(shakeOffer, "GANGS", "prtial_hndshk_01", 3.0, 1, 1, 1, 0, 1500, 1);
			                ApplyAnimation(playerid, "GANGS", "prtial_hndshk_01", 3.0, 1, 1, 1, 0, 1500, 1);
			                ApplyAnimation(shakeOffer, "GANGS", "prtial_hndshk_01", 3.0, 1, 1, 1, 0, 1500, 1);
			            }
			            case 8: {
							ApplyAnimation(playerid, "GANGS", "prtial_hndshk_biz_01", 3.7, 1, 1, 1, 0, 2200, 1);
							ApplyAnimation(shakeOffer, "GANGS", "prtial_hndshk_biz_01", 3.5, 1, 1, 1, 0, 2200, 1);
							ApplyAnimation(playerid, "GANGS", "prtial_hndshk_biz_01", 3.7, 1, 1, 1, 0, 2200, 1);
							ApplyAnimation(shakeOffer, "GANGS", "prtial_hndshk_biz_01", 3.5, 1, 1, 1, 0, 2200, 1);
			            }
					}
					GetPlayerName(playerid, playerNames[0], MAX_PLAYER_NAME);
					GetPlayerName(shakeOffer, playerNames[1], MAX_PLAYER_NAME);
					DeletePVar(playerid,"hs");
					DeletePVar(playerid,"hsID");
					format(string, sizeof(string), "* %s has shaken hands with %s.", playerNames[1], playerNames[0]);
					nearByMessage(playerid, COLOR_PURPLE, string);
				}
				else {
				    SendClientMessage( playerid, COLOR_GREY, "You're too far away.");
				}
		    }
		    else {
		        SendClientMessage(playerid, COLOR_GREY, "You don't have a pending handshake request.");
		    }
		}
		else if(strcmp(params, "weapon", true) == 0) {

			new
				playerOffering = GetPVarInt(playerid,"gunID"),
				weaponOffering = GetPVarInt(GetPVarInt(playerid,"gunID"),"gun"),
				slotOffering = GetPVarInt(GetPVarInt(playerid,"gunID"),"slot"),
				WplayerName[2][MAX_PLAYER_NAME],
				wstring[128];

	   		if(weaponOffering != 0 && slotOffering != 0) {
				if(IsPlayerInRangeOfPlayer(playerid, playerOffering, 5.0) && !IsPlayerInAnyVehicle(playerid) && !IsPlayerInAnyVehicle(playerOffering)) {

					if(playerVariables[playerOffering][pWeapons][slotOffering] != weaponOffering) {
						return SendClientMessage(playerid, COLOR_GREY, "The player offering you a weapon no longer has it.");
					}
					else if(playerVariables[playerOffering][pFreezeType] > 0) {
						return SendClientMessage(playerid, COLOR_GREY, "That person is cuffed, tazed, or frozen - they can't do this.");
					}
					else if(playerVariables[playerid][pFreezeType] > 0) {
						return SendClientMessage(playerid, COLOR_GREY, "You can't do this while cuffed, tazed, or frozen.");
					}
					else {

						givePlayerValidWeapon(playerid, weaponOffering);
						removePlayerWeapon(playerOffering, weaponOffering);

						GetPlayerName(playerOffering, WplayerName[0], MAX_PLAYER_NAME);
						GetPlayerName(playerid, WplayerName[1], MAX_PLAYER_NAME);

						format(wstring, sizeof(wstring), "You have accepted the %s from %s.", WeaponNames[weaponOffering], WplayerName[0]);
						SendClientMessage(playerid, COLOR_WHITE, wstring);

						format(wstring, sizeof(wstring), "%s has accepted the %s you offered them.", WplayerName[1], WeaponNames[weaponOffering]);
						SendClientMessage(playerOffering, COLOR_WHITE, wstring);

						format(wstring, sizeof(wstring), "* %s has given their %s to %s.", WplayerName[0], WeaponNames[weaponOffering], WplayerName[1]);
						nearByMessage(playerid, COLOR_PURPLE, wstring);

						DeletePVar(playerOffering,"gun");
						DeletePVar(playerid,"gunID");
						DeletePVar(playerOffering,"slot");
					}
		    	}
		    	else SendClientMessage(playerid, COLOR_GREY, "You're too far away from the person offering, or either of you are in a vehicle.");
		    }
	    	else SendClientMessage(playerid, COLOR_GREY, "Nobody offered you a weapon.");
		}
		else if(strcmp(params, "armour", true) == 0) {

			new
				aplayerOffering = GetPVarInt(playerid,"aID") - 1,
				AplayerName[2][MAX_PLAYER_NAME],
				astring[128];

	   		if(playerOffering != INVALID_PLAYER_ID) {
				if(IsPlayerInRangeOfPlayer(playerid, aplayerOffering, 5.0)) {

					if(playerVariables[aplayerOffering][pFreezeType] > 0) {
						return SendClientMessage(playerid, COLOR_GREY, "That person is cuffed, tazed, or frozen - they can't do this.");
					}
					else if(playerVariables[playerid][pFreezeType] > 0) {
						return SendClientMessage(playerid, COLOR_GREY, "You can't do this while cuffed, tazed, or frozen.");
					}
					else {

						new
							Float:ArmourFloats[2];

						GetPlayerArmour(aplayerOffering, ArmourFloats[0]);
						GetPlayerArmour(playerid, ArmourFloats[1]);

						if(ArmourFloats[1] + ArmourFloats[0] >= 100) SetPlayerArmour(playerid, 100);
						else SetPlayerArmour(playerid, ArmourFloats[1] + ArmourFloats[0]);

						SetPlayerArmour(aplayerOffering, 0.0);

						GetPlayerName(aplayerOffering, AplayerName[0], MAX_PLAYER_NAME);
						GetPlayerName(playerid, AplayerName[1], MAX_PLAYER_NAME);
						format(astring, sizeof(astring), "You have accepted the kevlar vest from %s.", AplayerName[0]);
						SendClientMessage(playerid, COLOR_WHITE, astring);

						format(astring, sizeof(astring), "%s has accepted the kevlar vest you offered them.", AplayerName[1]);
						SendClientMessage(aplayerOffering, COLOR_WHITE, astring);

						format(astring, sizeof(astring), "* %s has given their kevlar vest to %s.", AplayerName[0], AplayerName[1]);
						nearByMessage(playerid, COLOR_PURPLE, astring);

						DeletePVar(playerid,"aID");
					}
		    	}
		    	else SendClientMessage(playerid, COLOR_GREY, "You're too far away from the person offering.");
		    }
	    	else SendClientMessage(playerid, COLOR_GREY, "Nobody offered you armour.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "Invalid item specified.");
    }
    else {
		SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/accept [item]");
		SendClientMessage(playerid, COLOR_GREY, "Items: Invite, Handshake, Weapon, Givecar, Ticket, Armour");
	}
	return 1;
}

CMD:a(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 1) {
		if(!isnull(params)) {
		    new
		        messageString[128];

		    format(messageString, sizeof(messageString), "* Admin %s (%d) says: %s", playerVariables[playerid][pAdminName], playerVariables[playerid][pAdminLevel], params);
		    submitToAdmins(messageString, COLOR_YELLOW);
		}
		else {
			SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/a [message]");
		}
	}
	return 1;
}

CMD:seepms(playerid, params[]) {
	switch(playerVariables[playerid][pPMStatus]) {
		case 0: {
		    playerVariables[playerid][pPMStatus] = 1;
			return SendClientMessage(playerid, COLOR_WHITE, "You have disabled your PMs.");
		}
		case 1: {
		    playerVariables[playerid][pPMStatus] = 0;
			return SendClientMessage(playerid, COLOR_WHITE, "You have enabled your PMs.");
		}
	}
	return 1;
}

CMD:pm(playerid, params[])
{
	new
		message[128],
		id;

	if(sscanf(params, "us[128]", id, message))
		SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/pm [playerid] [message]");
	else if(playerVariables[id][pStatus] != 1)
		SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
	else if(playerVariables[id][pPMStatus] != 0)
		SendClientMessage(playerid, COLOR_GREY, "That player's PMs aren't enabled.");
	else
	{
		GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

		format(szMessage, sizeof(szMessage), "(( PM from %s: %s ))", szPlayerName, message);
		SendClientMessage(id, COLOR_YELLOW, szMessage);

		GetPlayerName(id, szPlayerName, MAX_PLAYER_NAME);

		format(szMessage, sizeof(szMessage), "(( PM sent to %s: %s ))", szPlayerName, message);
		SendClientMessage(playerid, COLOR_GREY, szMessage);
    }
	return 1;
}

CMD:w(playerid, params[]) {
	return cmd_whisper(playerid, params);
}

CMD:whisper(playerid, params[]) {
	new
		message[128],
		id;

	if(sscanf(params, "us[128]", id, message)) {
		SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/whisper [playerid] [message]");
	}
	else if(playerVariables[id][pStatus] != 1)
	{
		SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
	}
	else if(playerVariables[id][pSeeWhisper] != 0) 
	{
		SendClientMessage(playerid, COLOR_GREY, "That player's whispers aren't enabled.");
	}
	else if(!IsPlayerInRangeOfPlayer(playerid, id, 2.0))
	{
		SendClientMessage(playerid, COLOR_GREY, "You're too far away.");
	}
	{
		new
			giveplayerName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
		format(szMessage, sizeof(szMessage), "%s whispers: %s", szPlayerName, message);
		SendClientMessage(id, COLOR_NICESKY, szMessage);

		GetPlayerName(id, giveplayerName, MAX_PLAYER_NAME);

		format(szMessage, sizeof(szMessage), "You whisper to %s: %s", giveplayerName, message);
		SendClientMessage(playerid, COLOR_NICESKY, szMessage);

		format(szMessage, sizeof(szMessage), "* %s whispers something to %s.", szPlayerName, giveplayerName);
		nearByMessage(playerid, COLOR_PURPLE, szMessage, 2.0);
    }
	return 1;
}

CMD:adminchat(playerid, params[]) {
	return cmd_a(playerid, params);
}

CMD:commands(playerid, params[]) {
	return showHelp(playerid);
}

stock showHelp(playerid) {
	return ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_LIST, "SERVER: Commands", "General\nChat\nGroups\nAnimations\nHouses\nJobs\n\nBusinesses\nHelpers\nVehicles\nBank", "Select", "Exit");
}

CMD:asellbusiness(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 3) {
        new
            houseID = strval(params);

		if(!isnull(params)) {
		    if(houseID < 1 || houseID > MAX_BUSINESSES) return SendClientMessage(playerid, COLOR_GREY, "Invalid business ID.");

	        new
	            labelString[96];

	        format(businessVariables[houseID][bOwner], MAX_PLAYER_NAME, "Nobody");

	        DestroyDynamicPickup(businessVariables[houseID][bPickupID]);
	        DestroyDynamic3DTextLabel(businessVariables[houseID][bLabelID]);

			format(labelString, sizeof(labelString), "%s\n(Business %d - un-owned)\nPrice: $%d (/buybusiness)\n\n(locked)", businessVariables[houseID][bName], houseID, businessVariables[houseID][bPrice]);

			businessVariables[houseID][bLabelID] = CreateDynamic3DTextLabel(labelString, COLOR_YELLOW, businessVariables[houseID][bExteriorPos][0], businessVariables[houseID][bExteriorPos][1], businessVariables[houseID][bExteriorPos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
			businessVariables[houseID][bPickupID] = CreateDynamicPickup(1239, 23, businessVariables[houseID][bExteriorPos][0], businessVariables[houseID][bExteriorPos][1], businessVariables[houseID][bExteriorPos][2], 0, 0, -1, 250);

			businessVariables[houseID][bLocked] = 1;

			format(labelString, sizeof(labelString), "You have admin-sold business ID %d.", houseID);
			SendClientMessage(playerid, COLOR_WHITE, labelString);

		    saveHouse(houseID);
		}
		else {
		    return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/asellbusiness [businessid]");
		}
    }

    return 1;
}

CMD:he(playerid, params[]) {
	if(playerVariables[playerid][pHelper] >= 1 || playerVariables[playerid][pAdminLevel] >= 1) {
		if(!isnull(params)) {
		    new
		        msgSz[128];

			if(playerVariables[playerid][pAdminLevel] >= 1)
				format(msgSz, sizeof(msgSz), "* Administrator %s (%d): %s", playerVariables[playerid][pAdminName], playerVariables[playerid][pAdminLevel], params);

			if(playerVariables[playerid][pHelper] >= 1)
				format(msgSz, sizeof(msgSz), "* Helper %s (%d): %s", playerVariables[playerid][pNormalName], playerVariables[playerid][pHelper], params);


			foreach(Player, x) {
			    if(playerVariables[x][pHelper] >= 1 || playerVariables[x][pAdminLevel] >= 1) {
                    SendClientMessage(x, COLOR_GENANNOUNCE, msgSz);
				}
			}
		}
		else {
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/he [message]");
		}
	}
	return 1;
}

CMD:asellhouse(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 3) {
        new
            houseID = strval(params);

		if(!isnull(params)) {
		    if(houseID < 1 || houseID > MAX_HOUSES) return SendClientMessage(playerid, COLOR_GREY, "Invalid house ID.");

	        new
	            labelString[96];

	        format(houseVariables[houseID][hHouseOwner], MAX_PLAYER_NAME, "Nobody");
	        format(labelString, sizeof(labelString), "House %d (un-owned - /buyhouse)\nPrice: $%d\n\n(locked)", houseID, houseVariables[houseID][hHousePrice]);

	        DestroyDynamicPickup(houseVariables[houseID][hPickupID]);
	        DestroyDynamic3DTextLabel(houseVariables[houseID][hLabelID]);

	        houseVariables[houseID][hLabelID] = CreateDynamic3DTextLabel(labelString, COLOR_YELLOW, houseVariables[houseID][hHouseExteriorPos][0], houseVariables[houseID][hHouseExteriorPos][1], houseVariables[houseID][hHouseExteriorPos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
			houseVariables[houseID][hPickupID] = CreateDynamicPickup(1273, 23, houseVariables[houseID][hHouseExteriorPos][0], houseVariables[houseID][hHouseExteriorPos][1], houseVariables[houseID][hHouseExteriorPos][2], 0, houseVariables[houseID][hHouseExteriorID], -1, 250);

			houseVariables[houseID][hHouseLocked] = 1;

			format(labelString, sizeof(labelString), "You have admin-sold house ID %d.", houseID);
			SendClientMessage(playerid, COLOR_WHITE, labelString);

		    saveHouse(houseID);
		}
		else {
		    return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/asellhouse [houseid]");
		}
    }

    return 1;
}

CMD:sellbusiness(playerid, params[]) {
	if(playerVariables[playerid][pStatus] >= 1) {
	    new
	        businessID = getPlayerBusinessID(playerid);

	    if(businessID < 1)
	        return 1;

	    new
	    	labelString[96];

		playerVariables[playerid][pMoney] += businessVariables[businessID][bPrice];

        format(businessVariables[businessID][bOwner], MAX_PLAYER_NAME, "Nobody");
        format(labelString, sizeof(labelString), "%s\n(Business %d - un-owned)\nPrice: $%d (/buybusiness)\n\nPress ~k~~PED_DUCK~ to enter", businessVariables[businessID][bName], businessID, businessVariables[businessID][bPrice]);

        DestroyDynamicPickup(businessVariables[businessID][bPickupID]);
        DestroyDynamic3DTextLabel(businessVariables[businessID][bLabelID]);

		businessVariables[businessID][bLabelID] = CreateDynamic3DTextLabel(labelString, COLOR_YELLOW, businessVariables[businessID][bExteriorPos][0], businessVariables[businessID][bExteriorPos][1], businessVariables[businessID][bExteriorPos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
		businessVariables[businessID][bPickupID] = CreateDynamicPickup(1239, 23, businessVariables[businessID][bExteriorPos][0], businessVariables[businessID][bExteriorPos][1], businessVariables[businessID][bExteriorPos][2], 0, 0, -1, 250);

		businessVariables[businessID][bLocked] = 1;

		format(labelString, sizeof(labelString), "Business sold! You have been given back $%d for the business.", businessVariables[businessID][bPrice]);
		SendClientMessage(playerid, COLOR_WHITE, labelString);

		saveBusiness(businessID);
	}
	return 1;
}

CMD:sellhouse(playerid, params[]) {
	if(playerVariables[playerid][pStatus] >= 1) {
	    new
	        houseID = getPlayerHouseID(playerid);

	    if(houseID < 1)
	        return 1;

		new
	    	labelString[96];

        playerVariables[playerid][pMoney] += houseVariables[houseID][hHousePrice];

        format(houseVariables[houseID][hHouseOwner], MAX_PLAYER_NAME, "Nobody");
        format(labelString, sizeof(labelString), "House %d (un-owned - /buyhouse)\nPrice: $%d\n\n(locked)", houseID, houseVariables[houseID][hHousePrice]);

        DestroyDynamicPickup(houseVariables[houseID][hPickupID]);
        DestroyDynamic3DTextLabel(houseVariables[houseID][hLabelID]);

        houseVariables[houseID][hLabelID] = CreateDynamic3DTextLabel(labelString, COLOR_YELLOW, houseVariables[houseID][hHouseExteriorPos][0], houseVariables[houseID][hHouseExteriorPos][1], houseVariables[houseID][hHouseExteriorPos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
		houseVariables[houseID][hPickupID] = CreateDynamicPickup(1273, 23, houseVariables[houseID][hHouseExteriorPos][0], houseVariables[houseID][hHouseExteriorPos][1], houseVariables[houseID][hHouseExteriorPos][2], 0, houseVariables[houseID][hHouseExteriorID], -1, 250);

		houseVariables[houseID][hHouseLocked] = 1;

		format(labelString, sizeof(labelString), "House sold! You have been given back $%d for the house.", houseVariables[houseID][hHousePrice]);
		SendClientMessage(playerid, COLOR_WHITE, labelString);

		saveHouse(houseID);
	}
	return 1;
}

CMD:ringbell(playerid, params[]) {
	if(GetPlayerState(playerid) == 1) {
		for(new x = 0; x < MAX_HOUSES; x++) {
			if(IsPlayerInRangeOfPoint(playerid, 2.0, houseVariables[x][hHouseExteriorPos][0], houseVariables[x][hHouseExteriorPos][1], houseVariables[x][hHouseExteriorPos][2])) {

				new
					string[80];

				GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
				format(string, sizeof(string), "* %s presses a button, ringing the doorbell of the house.", szPlayerName);
				nearByMessage(playerid, COLOR_PURPLE, string);

				foreach(Player, i) {
					if(GetPlayerVirtualWorld(i) == x + HOUSE_VIRTUAL_WORLD) {
						SendClientMessage(i, COLOR_PURPLE, "* The doorbell rings.");
					}
				}
			}
		}
	}
	return 1;
}

CMD:lockhouse(playerid, params[]) {
	if(playerVariables[playerid][pStatus] >= 1) {
	    new
	        houseID = getPlayerHouseID(playerid);

	    if(houseID >= 1) {
			if(IsPlayerInRangeOfPoint(playerid, 2.0, houseVariables[houseID][hHouseExteriorPos][0], houseVariables[houseID][hHouseExteriorPos][1], houseVariables[houseID][hHouseExteriorPos][2]) || IsPlayerInRangeOfPoint(playerid, 2.0, houseVariables[houseID][hHouseInteriorPos][0], houseVariables[houseID][hHouseInteriorPos][1], houseVariables[houseID][hHouseInteriorPos][2])) {

				new
					labelString[96];

				switch(houseVariables[houseID][hHouseLocked]) {
					case 1: {
						houseVariables[houseID][hHouseLocked] = 0;
						SendClientMessage(playerid, COLOR_WHITE, "House unlocked.");
						format(labelString, sizeof(labelString), "House %d (owned)\nOwner: %s\n\nPress ~k~~PED_DUCK~ to enter.", houseID, houseVariables[houseID][hHouseOwner]);
					}
					case 0: {
						houseVariables[houseID][hHouseLocked] = 1;
						SendClientMessage(playerid, COLOR_WHITE, "House locked.");
						format(labelString, sizeof(labelString), "House %d (owned)\nOwner: %s\n\n(locked)", houseID, houseVariables[houseID][hHouseOwner]);
					}
				}

				UpdateDynamic3DTextLabelText(houseVariables[houseID][hLabelID], COLOR_YELLOW, labelString);
				PlayerPlaySoundEx(1145, houseVariables[houseID][hHouseExteriorPos][0], houseVariables[houseID][hHouseExteriorPos][1], houseVariables[houseID][hHouseExteriorPos][2]);
				PlayerPlaySoundEx(1145, houseVariables[houseID][hHouseInteriorPos][0], houseVariables[houseID][hHouseInteriorPos][1], houseVariables[houseID][hHouseInteriorPos][2]);
			}
			else SendClientMessage(playerid, COLOR_GREY, "You're not at your house.");
	    }
	    else  SendClientMessage(playerid, COLOR_GREY, "You don't own a house.");
	}

	return 1;
}

CMD:listgroups(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 1) {
        for(new xf = 0; xf < MAX_GROUPS; xf++) {
			if(strlen(groupVariables[xf][gGroupName]) >= 1 && strcmp(groupVariables[xf][gGroupName], "None", true)) {
				format(szMessage, sizeof(szMessage), "ID: %d | Group Name: %s | Group Type: %d", xf, groupVariables[xf][gGroupName], groupVariables[xf][gGroupType]);
				SendClientMessage(playerid, COLOR_WHITE, szMessage);
			}
		}
	}
	return 1;
}

CMD:do(playerid, params[]) {
    if(playerVariables[playerid][pStatus] >= 1) {
        if(!isnull(params)) {
			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

			format(szMessage, sizeof(szMessage), "* %s (( %s )) ", params, szPlayerName);
			nearByMessage(playerid, COLOR_PURPLE, szMessage);
		}
		else {
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/do [action]");
		}
	}
	return 1;
}

CMD:bwithdraw(playerid, params[]) {
	if(getPlayerBusinessID(playerid) >= 1) {
	    if(!isnull(params)) {
			new
			    amount = strval(params),
			    businessID = getPlayerBusinessID(playerid);

        	if(amount < 1 || amount >= 5000000)
				return SendClientMessage(playerid, COLOR_GREY, "Withdrawal attempt failed.");

			if(businessVariables[businessID][bVault] >= amount) {
				format(szMessage, sizeof(szMessage), "You have withdrawn $%d from your business.", amount);
				SendClientMessage(playerid, COLOR_WHITE, szMessage);

				businessVariables[businessID][bVault] -= amount;
				playerVariables[playerid][pMoney] += amount;
			}
		}
		else {
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/bwithdraw [amount]");
		}
	}
	return 1;
}

CMD:charity(playerid, params[]) {
    if(playerVariables[playerid][pStatus] >= 1) {
        new
            value = strval(params);

        if(value < 1 || value >= 5000000)
			return SendClientMessage(playerid, COLOR_GREY, "The charity declined your donation.");

        if(playerVariables[playerid][pMoney] < 1)
			return SendClientMessage(playerid, COLOR_GREY, "The charity declined your donation.");

	    playerVariables[playerid][pMoney] -= value;

        if(playerVariables[playerid][pMoney] < 1)
			playerVariables[playerid][pMoney] = 0;

		format(szMessage, sizeof(szMessage), "The charity accepted your donation of $%d.", value);
        SendClientMessage(playerid, COLOR_YELLOW, szMessage);
    }

    return 1;
}

CMD:flipcoin(playerid, params[]) { // HAHAHAHAHAHAH OH WOW
    if(playerVariables[playerid][pStatus] >= 1) {
		GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

		if(playerVariables[playerid][pMoney] < 1)
			return SendClientMessage(playerid, COLOR_GREY, "You have no coins to flip.");

		if(random(5) < 3) {
			format(szMessage, sizeof(szMessage), "* %s has flipped their coin. The coin lands on the 'heads' side.", szPlayerName);
			nearByMessage(playerid, COLOR_PURPLE, szMessage);
		}
		else {
			format(szMessage, sizeof(szMessage), "* %s has flipped their coin. The coin lands on the 'tails' side.", szPlayerName);
			nearByMessage(playerid, COLOR_PURPLE, szMessage);
		}
	}
	return 1;
}

CMD:creategun(playerid, params[]) {
	if(jobVariables[playerVariables[playerid][pJob]][jJobType] == 1) {
		if(playerVariables[playerid][pFreezeType] == 0) {
			if(playerVariables[playerid][pJobDelay] == 0) {
				switch(playerVariables[playerid][pJobSkill][0]) {
					case 0 .. 49: ShowPlayerDialog(playerid, DIALOG_CREATEGUN, DIALOG_STYLE_LIST, "Weapon Selection", "Katana (30)\nCane (30)\nPool Cue (33)\nBaseball Bat (35)\nShovel (50)","Select", "Cancel");
					case 50 .. 99: ShowPlayerDialog(playerid, DIALOG_CREATEGUN, DIALOG_STYLE_LIST, "Weapon Selection", "Katana (30)\nCane (30)\nPool Cue (33)\nBaseball Bat (35)\nShovel (50)\n9mm pistol (250)","Select", "Cancel");
					case 100 .. 149: ShowPlayerDialog(playerid, DIALOG_CREATEGUN, DIALOG_STYLE_LIST, "Weapon Selection", "Katana (30)\nCane (30)\nPool Cue (33)\nBaseball Bat (35)\nShovel (50)\n9mm Pistol (250)\nSilenced Pistol (300)","Select", "Cancel");
					case 150 .. 199: ShowPlayerDialog(playerid, DIALOG_CREATEGUN, DIALOG_STYLE_LIST, "Weapon Selection", "Katana (30)\nCane (30)\nPool Cue (33)\nBaseball Bat (35)\nShovel (50)\n9mm Pistol (250)\nSilenced Pistol (300)\nShotgun (550)","Select", "Cancel");
					case 200 .. 249: ShowPlayerDialog(playerid, DIALOG_CREATEGUN, DIALOG_STYLE_LIST, "Weapon Selection", "Katana (30)\nCane (30)\nPool Cue (33)\nBaseball Bat (35)\nShovel (50)\n9mm Pistol (250)\nSilenced Pistol (300)\nShotgun (550)\nDesert Eagle (680)","Select", "Cancel");
					case 250 .. 299: ShowPlayerDialog(playerid, DIALOG_CREATEGUN, DIALOG_STYLE_LIST, "Weapon Selection", "Katana (30)\nCane (30)\nPool Cue (33)\nBaseball Bat (35)\nShovel (50)\n9mm Pistol (250)\nSilenced Pistol (300)\nShotgun (550)\nDesert Eagle (680)\nMP5 (850)","Select", "Cancel");
					case 300 .. 349: ShowPlayerDialog(playerid, DIALOG_CREATEGUN, DIALOG_STYLE_LIST, "Weapon Selection", "Katana (30)\nCane (30)\nPool Cue (33)\nBaseball Bat (35)\nShovel (50)\n9mm Pistol (250)\nSilenced Pistol (300)\nShotgun (550)\nDesert Eagle (680)\nMP5 (850)\nMicro Uzi (900)","Select", "Cancel");
					case 350 .. 399: ShowPlayerDialog(playerid, DIALOG_CREATEGUN, DIALOG_STYLE_LIST, "Weapon Selection", "Katana (30)\nCane (30)\nPool Cue (33)\nBaseball Bat (35)\nShovel (50)\n9mm Pistol (250)\nSilenced Pistol (300)\nShotgun (550)\nDesert Eagle (680)\nMP5 (850)\nMicro Uzi (900)\nAK-47 (1500)","Select", "Cancel");
					case 400 .. 449: ShowPlayerDialog(playerid, DIALOG_CREATEGUN, DIALOG_STYLE_LIST, "Weapon Selection", "Katana (30)\nCane (30)\nPool Cue (33)\nBaseball Bat (35)\nShovel (50)\n9mm Pistol (250)\nSilenced Pistol (300)\nShotgun (550)\nDesert Eagle (680)\nMP5 (850)\nMicro Uzi (900)\nAK-47 (1500)\nM4A1 (2000)","Select", "Cancel");
					case 450 .. 499: ShowPlayerDialog(playerid, DIALOG_CREATEGUN, DIALOG_STYLE_LIST, "Weapon Selection", "Katana (30)\nCane (30)\nPool Cue (33)\nBaseball Bat (35)\nShovel (50)\n9mm Pistol (250)\nSilenced Pistol (300)\nShotgun (550)\nDesert Eagle (680)\nMP5 (850)\nMicro Uzi (900)\nAK-47 (1500)\nM4A1 (2000)\nSniper (2450)","Select", "Cancel");
					default: ShowPlayerDialog(playerid, DIALOG_CREATEGUN, DIALOG_STYLE_LIST, "Weapon Selection", "Katana (30)\nCane (30)\nPool Cue (33)\nBaseball Bat (35)\nShovel (50)\n9mm Pistol (250)\nSilenced Pistol (300)\nShotgun (550)\nDesert Eagle (680)\nMP5 (850)\nMicro Uzi (900)\nAK-47 (1500)\nM4A1 (2000)\nSniper (2450)\nSPAS12 (2550)\nKevlar Vest (1750)","Select", "Cancel");
				}
			}
			else SendClientMessage(playerid, COLOR_GREY, "You must wait your reload time (30 seconds).");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You can't do this while cuffed, tazed, or frozen.");
	}
	return 1;
}

CMD:me(playerid, params[]) {
    if(playerVariables[playerid][pStatus] >= 1) {
        if(!isnull(params)) {
			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

			format(szMessage, sizeof(szMessage), "* %s %s", szPlayerName, params);
			nearByMessage(playerid, COLOR_PURPLE, szMessage);
		}
		else {
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/me [action]");
		}
	}
	return 1;
}

CMD:low(playerid, params[]) {
	if(playerVariables[playerid][pStatus] >= 1) {

		if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/low [message]");

		new
			queryString[255],
		    textString[128];

		GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
		format(textString, sizeof(textString), "%s says quietly [%s Accent]: %s", szPlayerName, playerVariables[playerid][pAccent], params);
		nearByMessage(playerid, COLOR_WHITE, textString, 2.0);
		format(textString, sizeof(textString), "(quietly) \"%s\"", params);
		SetPlayerChatBubble(playerid, textString, COLOR_CHATBUBBLE, 3.0, 10000);
		mysql_real_escape_string(textString, textString);

		format(queryString, sizeof(queryString), "INSERT INTO chatlogs (value, playerinternalid) VALUES('%s', '%d')", textString, playerVariables[playerid][pInternalID]);
		mysql_query(queryString);
	}
	return 1;
}

CMD:l(playerid, params[]) {
	return cmd_low(playerid, params);
}

CMD:shout(playerid, params[]) {
	if(playerVariables[playerid][pStatus] >= 1) {

		if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/shout [message]");
		new

			queryString[255],
		    textString[128];

		GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
		format(textString, sizeof(textString), "(shouts) \"%s!\"", params);
		SetPlayerChatBubble(playerid, textString, COLOR_CHATBUBBLE, 30.0, 10000);
		format(textString, sizeof(textString), "%s shouts [%s Accent]: %s!", szPlayerName, playerVariables[playerid][pAccent], params);
		nearByMessage(playerid, COLOR_WHITE, textString, 20.0);
		mysql_real_escape_string(textString, textString);

		format(queryString, sizeof(queryString), "INSERT INTO chatlogs (value, playerinternalid) VALUES('%s', '%d')", textString, playerVariables[playerid][pInternalID]);
		mysql_query(queryString);
	}
	return 1;
}

CMD:m(playerid, params[]) {
	return cmd_megaphone(playerid, params);
}

CMD:megaphone(playerid, params[]) {
	if(playerVariables[playerid][pStatus] >= 1) {
		if(groupVariables[playerVariables[playerid][pGroup]][gGroupType] == 1) {
			if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/megaphone [message]");
			else if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, "You're not in a vehicle.");

			new

				queryString[255],
				textString[128];

			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
			format(textString, sizeof(textString), "(megaphone) %s says: %s", szPlayerName, params);
			nearByMessage(playerid, COLOR_HOTORANGE, textString, 50.0);


			mysql_real_escape_string(textString, textString);

			format(queryString, sizeof(queryString), "INSERT INTO chatlogs (value, playerinternalid) VALUES('%s', '%d')", textString, playerVariables[playerid][pInternalID]);
			mysql_query(queryString);
		}
		else SendClientMessage(playerid, COLOR_GREY, "You're not a law enforcement officer.");
	}
	return 1;
}

CMD:s(playerid, params[]) {
	return cmd_shout(playerid, params);
}

CMD:b(playerid, params[]) {
	if(playerVariables[playerid][pStatus] >= 1) {

		if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/b [message]");
		new

			queryString[255],
		    textString[128];

		GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
		format(textString, sizeof(textString), "%s says: (( %s ))", szPlayerName, params);
		nearByMessage(playerid, COLOR_WHITE, textString, 5.0);
		mysql_real_escape_string(textString, textString);

		format(queryString, sizeof(queryString), "INSERT INTO chatlogs (value, playerinternalid) VALUES('%s', '%d')", textString, playerVariables[playerid][pInternalID]);
		mysql_query(queryString);
	}
	return 1;
}

CMD:report(playerid, params[]) {
	if(systemVariables[reportSystem] == 0) {
		if(isnull(params)) {
		    SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/report [message]");
		}
		else {
		    if(playerVariables[playerid][pReport] >= 1) {
		        SendClientMessage(playerid, COLOR_WHITE, "You already have an active report within our system, please wait for it to be answered.");
		    }
		    else {
		        if(strlen(params) >= 64) {
		            return SendClientMessage(playerid, COLOR_GREY, "Your report message was too long. Keep it under 64 characters.");
		        }
		        else {
				    SendClientMessage(playerid, COLOR_YELLOW, "Your report has been submitted and queued.");

        			strcpy(playerVariables[playerid][pReportMessage], params, 64);
				    playerVariables[playerid][pReport] = 1;

				    submitToAdmins("A new report has been submitted, check '/reports list'", COLOR_YELLOW);
			    }
		    }
		}
	}
	else {
	    SendClientMessage(playerid, COLOR_WHITE, "The report system is disabled right now. Please try again later.");
	}

	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source) {
	#if defined DEBUG
	    printf("[debug] OnPlayerClickPlayer(%d, %d, %d)", playerid, clickedplayerid, source);
	#endif
	
    if(playerVariables[playerid][pAdminLevel] >= 1) {

		    if(!IsPlayerAuthed(clickedplayerid))
				return SendClientMessage(playerid, COLOR_GREY, "The specified player is not connected, or has not authenticated.");

			if(playerVariables[playerid][pSpectating] == INVALID_PLAYER_ID) {
				GetPlayerPos(playerid, playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2]);
				playerVariables[playerid][pInterior] = GetPlayerInterior(playerid);
				playerVariables[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
				playerVariables[playerid][pSkin] = GetPlayerSkin(playerid);

				if(playerVariables[playerid][pAdminDuty] == 0) {
					GetPlayerHealth(playerid, playerVariables[playerid][pHealth]);
					GetPlayerArmour(playerid, playerVariables[playerid][pArmour]);
				}
		    }
		    playerVariables[playerid][pSpectating] = clickedplayerid;
		    TogglePlayerSpectating(playerid, true);

			SetPlayerInterior(playerid, GetPlayerInterior(clickedplayerid));
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(clickedplayerid));

		    if(IsPlayerInAnyVehicle(clickedplayerid)) {
		        PlayerSpectateVehicle(playerid, GetPlayerVehicleID(clickedplayerid));
		    }
		    else {
				PlayerSpectatePlayer(playerid, clickedplayerid);
			}

			TextDrawShowForPlayer(playerid, textdrawVariables[4]);
	}
	return 1;
}

CMD:spec(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 1) {
        new
            userID;

		if(sscanf(params, "u", userID)) {
		    return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/spec [playerid]");
		}
		else if(!IsPlayerAuthed(userID)) {
		    return SendClientMessage(playerid, COLOR_GREY, "The specified player is not connected, or has not authenticated.");
		}
		else {
			if(playerVariables[playerid][pSpectating] == INVALID_PLAYER_ID) { // Will only save pos/etc if they're NOT spectating. This will stop the annoying death/pos/int/VW/crash bugs everyone's experiencing...
				GetPlayerPos(playerid, playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2]);
				playerVariables[playerid][pInterior] = GetPlayerInterior(playerid);
				playerVariables[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);
				playerVariables[playerid][pSkin] = GetPlayerSkin(playerid);

				if(playerVariables[playerid][pAdminDuty] == 0) {
					GetPlayerHealth(playerid, playerVariables[playerid][pHealth]);
					GetPlayerArmour(playerid, playerVariables[playerid][pArmour]);
				}
		    }
		    playerVariables[playerid][pSpectating] = userID;
		    TogglePlayerSpectating(playerid, true);

			SetPlayerInterior(playerid, GetPlayerInterior(userID));
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(userID));

		    if(IsPlayerInAnyVehicle(userID)) {
		        PlayerSpectateVehicle(playerid, GetPlayerVehicleID(userID));
		    }
		    else {
				PlayerSpectatePlayer(playerid, userID);
			}
			if(playerVariables[userID][pTutorial] >= 1) {
				SendClientMessage(playerid, COLOR_GREY, "This player is currently in the tutorial.");
			}

			TextDrawShowForPlayer(playerid, textdrawVariables[4]);
		}
	}
	return 1;
}

CMD:buyclothes(playerid, params[]) {
	if(GetPlayerVirtualWorld(playerid)-BUSINESS_VIRTUAL_WORLD >= 1) {

		new
			skinID,
			slotID,
			iPrice,
			houseID = getPlayerHouseID(playerid),
			businessID = GetPlayerVirtualWorld(playerid) - BUSINESS_VIRTUAL_WORLD;
			
		if(businessID > 0) {
			for(new i = 0; i < MAX_BUSINESS_ITEMS; i++) {
				if(businessItems[i][bItemType] == 18 && businessItems[i][bItemBusiness] == businessID)
				    iPrice = businessItems[i][bItemPrice];
			}
		}

		if(businessVariables[businessID][bType] == 2) {
			if(houseID >= 1) {
				if(sscanf(params, "dd", skinID, slotID)) {
					return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/buyclothes [skinid] [house slot]");
				}
				else if(!IsValidSkin(skinID)) {
					return SendClientMessage(playerid, COLOR_GREY, "Invalid skin ID.");
				}
				else if(!IsPublicSkin(skinID) && playerVariables[playerid][pGroup] != 1) {
					return SendClientMessage(playerid, COLOR_GREY, "You can't purchase this skin.");
				}
				else if(slotID < 1 || slotID > 5) {
					return SendClientMessage(playerid, COLOR_GREY, "Invalid slot specified.");
				}
				else if(playerVariables[playerid][pMoney] >= 500) {
					playerVariables[playerid][pMoney] -= 500;
					businessVariables[businessID][bVault] += 500;
					playerVariables[playerid][pSkin] = skinID;
					houseVariables[houseID][hWardrobe][slotID - 1] = skinID;
					return SetPlayerSkin(playerid, skinID);
				}
				else {
				    format(szMessage, sizeof(szMessage), "You don't have $%d available.", iPrice);
					SendClientMessage(playerid, COLOR_GREY, szMessage);
				}
			}
			else if(!isnull(params)) {
				skinID = strval(params);

				if(!IsValidSkin(skinID)) {
					return SendClientMessage(playerid, COLOR_GREY, "Invalid skin ID.");
				}
				else if(!IsPublicSkin(skinID) && playerVariables[playerid][pGroup] != 1) {
					return SendClientMessage(playerid, COLOR_GREY, "You can't purchase this skin.");
				}
				else {
				    if(playerVariables[playerid][pMoney] >= iPrice) {
						playerVariables[playerid][pMoney] -= iPrice;
						businessVariables[businessID][bVault] += iPrice;
						playerVariables[playerid][pSkin] = skinID;
						return SetPlayerSkin(playerid, skinID);
					} else {
					    format(szMessage, sizeof(szMessage), "You don't have $%d available.", iPrice);
						SendClientMessage(playerid, COLOR_GREY, szMessage);
					}
				}
			}
			else {
   				format(szMessage, sizeof(szMessage), "Skins here cost $%d", iPrice);
				SendClientMessage(playerid, COLOR_GREY, szMessage);
				SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/buyclothes [skinid] (Skins cost $500.)");
			}
		}
	}
	return 1;
}

CMD:buy(playerid, params[]) {
	if(GetPlayerVirtualWorld(playerid)-BUSINESS_VIRTUAL_WORLD >= 1) {
	    new
	        businessID = GetPlayerVirtualWorld(playerid)-BUSINESS_VIRTUAL_WORLD;

	    if(businessVariables[businessID][bType] == 0)
	        return 1;
	        
		format(result, sizeof(result), "");
		
		new
		    iCount;

	    for(new i = 0; i < MAX_BUSINESS_ITEMS; i++) {
	    	if(businessItems[i][bItemBusiness] == businessID) {
	    	    format(szSmallString, sizeof(szSmallString), "menuItem%d", iCount);
	    	    SetPVarInt(playerid, szSmallString, i);
	    	    
	    	    if(businessItems[i][bItemType] == 4)
	        		format(result, sizeof(result), "%s\n$%d phone credit voucher", result, businessItems[i][bItemPrice]);
	        	else
	        		format(result, sizeof(result), "%s\n%s ($%d)", result, businessItems[i][bItemName], businessItems[i][bItemPrice]);

				iCount++;
      		}
	    }

		switch(businessVariables[businessID][bType]) {
			case 1: ShowPlayerDialog(playerid, DIALOG_TWENTYFOURSEVEN, DIALOG_STYLE_LIST, "SERVER: 24/7", result, "Select", "Exit");
			case 3: ShowPlayerDialog(playerid, DIALOG_BAR, DIALOG_STYLE_LIST, "SERVER: Bar", result, "Select", "Exit");
			case 4: ShowPlayerDialog(playerid, DIALOG_SEX_SHOP, DIALOG_STYLE_LIST, "SERVER: Sex Shop", result, "Select", "Exit");
			case 7: ShowPlayerDialog(playerid, DIALOG_FOOD, DIALOG_STYLE_LIST, "SERVER: Restaurant", result, "Select", "Exit");
		}
	}
	return 1;
}

CMD:buyvehicle(playerid, params[]) {
	if(GetPlayerVirtualWorld(playerid)-BUSINESS_VIRTUAL_WORLD >= 1) {
	    new
	        businessID = GetPlayerVirtualWorld(playerid) - BUSINESS_VIRTUAL_WORLD;

		if(businessVariables[businessID][bMiscPos][0] == 0.0 && businessVariables[businessID][bMiscPos][1] == 0.0 && businessVariables[businessID][bMiscPos][2] == 0.0) {
			return SendClientMessage(playerid, COLOR_GREY, "No spawn position has been set by the business owner - until one is set, the business will not operate.");
		}
	    switch(businessVariables[businessID][bType]) {
			case 5: {
				ShowPlayerDialog(playerid, DIALOG_BUYCAR, DIALOG_STYLE_LIST, "SERVER: Vehicle Dealership", "Second Hand\nClassic Autos\nSedans\nSUVs/Trucks\nMotorcycles\nPerformance Vehicles", "Select", "Cancel");
			}
		}
	}
	return 1;
}

CMD:buyfightstyle(playerid, params[]) {
	if(GetPlayerVirtualWorld(playerid)-BUSINESS_VIRTUAL_WORLD >= 1) {
	    new
	        businessID = GetPlayerVirtualWorld(playerid) - BUSINESS_VIRTUAL_WORLD;

	    switch(businessVariables[businessID][bType]) {
			case 6: ShowPlayerDialog(playerid, DIALOG_FIGHTSTYLE, DIALOG_STYLE_LIST, "SERVER: Fighting Styles", "Boxing ($10,000)\nKung Fu ($25,000)\nKnee Head ($15,000)\nGrab & Kick ($12,000)\nElbow ($10,000)\nGhetto ($5,000)", "Select", "Cancel");
		}
	}
	return 1;
}

CMD:vdeposit(playerid, params[]) {
	if(playerVariables[playerid][pCarModel] >= 1) {
	    if(IsPlayerInRangeOfVehicle(playerid, playerVariables[playerid][pCarID], 6.0)) {
			new
			    amount,

			    houseOperation[64];

			if(sscanf(params, "s[32]d", houseOperation, amount)) {
			    return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/vdeposit [money/materials] [amount]");
			}
			else if(!strcmp(houseOperation, "money", true)) {
				if(playerVariables[playerid][pMoney] >= amount) {
					if(amount >= 1 && amount < 60000000) {
						playerVariables[playerid][pCarTrunk][0] += amount;
						playerVariables[playerid][pMoney] -= amount;

						if(playerVariables[playerid][pCarTrunk][0] < 1)
							playerVariables[playerid][pCarTrunk][0] = 0;

						if(playerVariables[playerid][pMoney] < 1)
							playerVariables[playerid][pMoney] = 0;

						format(houseOperation, sizeof(houseOperation), "You have deposited $%d in your vehicle.", amount);
						SendClientMessage(playerid, COLOR_WHITE, houseOperation);

						GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
						format(houseOperation, sizeof(houseOperation), "* %s deposits $%d in their vehicle.", szPlayerName, amount);
						nearByMessage(playerid, COLOR_PURPLE, houseOperation);
					}
					else {
						SendClientMessage(playerid, COLOR_GREY, "You can't deposit a negative amount into a house safe. (01x01)");
						printf("[error] 01x01, %d", playerid);
					}
				}
			}
			else if(!strcmp(houseOperation, "materials", true)) {
				if(playerVariables[playerid][pMaterials] >= amount) {
					if(amount >= 1 && amount < 60000000) {
						playerVariables[playerid][pCarTrunk][1] += amount;
						playerVariables[playerid][pMaterials] -= amount;

						if(playerVariables[playerid][pCarTrunk][1] < 1) playerVariables[playerid][pCarTrunk][1] = 0;
						if(playerVariables[playerid][pMaterials] < 1) playerVariables[playerid][pMaterials] = 0;

						format(houseOperation, sizeof(houseOperation), "You have deposited %d materials in your vehicle.", amount);
						SendClientMessage(playerid, COLOR_WHITE, houseOperation);

						GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
						format(houseOperation, sizeof(houseOperation), "* %s deposits %d materials in their vehicle.", szPlayerName, amount);
						nearByMessage(playerid, COLOR_PURPLE, houseOperation);
					}
					else {
						SendClientMessage(playerid, COLOR_GREY, "You can't deposit a negative amount into a house safe. (01x01)");
						printf("[error] 01x01, %d", playerid);
					}
				}
			}
			else SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/vdeposit [money/materials] [amount]");
	    }
	    else SendClientMessage(playerid, COLOR_GREY, "You're too far away from your vehicle.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "You don't own a vehicle.");
	return 1;
}

CMD:vwithdraw(playerid, params[]) {
	if(playerVariables[playerid][pCarModel] >= 1) {
	    if(IsPlayerInRangeOfVehicle(playerid, playerVariables[playerid][pCarID], 6.0)) {
			new
			    amount,

			    houseOperation[72]; // For formatting afterwards.

			if(sscanf(params, "s[32]d", houseOperation, amount))
			    return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/vwithdraw [money/materials] [amount]");

			if(!strcmp(houseOperation, "money", true)) {
				if(playerVariables[playerid][pCarTrunk][0] >= amount) {
					if(amount >= 1 && amount < 60000000) {
						playerVariables[playerid][pCarTrunk][0] -= amount;
						playerVariables[playerid][pMoney] += amount;

						if(playerVariables[playerid][pCarTrunk][0] < 1) playerVariables[playerid][pCarTrunk][0] = 0;
						if(playerVariables[playerid][pMoney] < 1) playerVariables[playerid][pMoney] = 0;

						format(houseOperation, sizeof(houseOperation), "You have withdrawn $%d from your vehicle.", amount);
						SendClientMessage(playerid, COLOR_WHITE, houseOperation);

						GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
						format(houseOperation, sizeof(houseOperation), "* %s withdraws $%d from their vehicle.", szPlayerName, amount);
						nearByMessage(playerid, COLOR_PURPLE, houseOperation);
					}
					else SendClientMessage(playerid, COLOR_GREY, "(error) 01x04");
				}
			}
			else if(!strcmp(houseOperation, "materials", true)) {
				if(playerVariables[playerid][pCarTrunk][1] >= amount) {
					if(amount >= 1 && amount < 60000000) {
						playerVariables[playerid][pCarTrunk][1] -= amount;
						playerVariables[playerid][pMaterials] += amount;

						if(playerVariables[playerid][pCarTrunk][1] < 1) playerVariables[playerid][pCarTrunk][1] = 0;
						if(playerVariables[playerid][pMaterials] < 1) playerVariables[playerid][pMaterials] = 0;

						format(houseOperation, sizeof(houseOperation), "You have withdrawn %d materials from your vehicle.", amount);
						SendClientMessage(playerid, COLOR_WHITE, houseOperation);

						GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
						format(houseOperation, sizeof(houseOperation), "* %s withdraws %d materials from their vehicle.", szPlayerName, amount);
						nearByMessage(playerid, COLOR_PURPLE, houseOperation);
					}
					else SendClientMessage(playerid, COLOR_GREY, "(error) 01x04");
				}
			}
			else SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/vwithdraw [money/materials] [amount]");
	    }
	    else SendClientMessage(playerid, COLOR_GREY, "You're too far away from your vehicle.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "You don't own a vehicle.");
	return 1;
}

CMD:vbalance(playerid, params[]) {
	new
		x;

	if(playerVariables[playerid][pCarModel] >= 1) {
		if(IsPlayerInRangeOfVehicle(playerid, playerVariables[playerid][pCarID], 6.0)) {

			new
				messageString[128];

			format(messageString, sizeof(messageString), "Money: $%d | Materials: %d", playerVariables[playerid][pCarTrunk][0], playerVariables[playerid][pCarTrunk][1]);

			for(new i; i < 5; i++) {
				if(playerVariables[playerid][pCarWeapons][i] > 0) {
					if(x == 0) format(messageString, sizeof(messageString),"%s | Weapons: %s (slot %d)", messageString, WeaponNames[playerVariables[playerid][pCarWeapons][i]], i);
					else format(messageString, sizeof(messageString),"%s, %s (slot %d)", messageString, WeaponNames[playerVariables[playerid][pCarWeapons][i]], i);
					x++;
				}
			}
			SendClientMessage(playerid, COLOR_WHITE, messageString);
		}
		else SendClientMessage(playerid, COLOR_GREY, "You're too far away from your vehicle.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "You don't own a vehicle.");
	return 1;
}

CMD:vstoreweapon(playerid, params[]) {

	new
		slot = strval(params);

	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/vstoreweapon [slot 1-5]");

	else if(playerVariables[playerid][pCarModel] >= 1) {
	    if(IsPlayerInRangeOfVehicle(playerid, playerVariables[playerid][pCarID], 6.0)) {
			if(slot >= 1 && slot <= 5) {
				if(playerVariables[playerid][pCarWeapons][slot - 1] == 0) {

					new
						string[86],
						weapon;

					GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
					weapon = GetPlayerWeapon(playerid);

					switch(weapon) {
						case 16, 18, 35, 36, 37, 38, 39, 40, 44, 45, 46, 0: SendClientMessage(playerid, COLOR_GREY, "Invalid weapon.");
						default: {
							playerVariables[playerid][pCarWeapons][slot - 1] = weapon;
							removePlayerWeapon(playerid, weapon);

							format(string, sizeof(string), "* %s places their %s in their vehicle.", szPlayerName, WeaponNames[weapon]);
							nearByMessage(playerid, COLOR_PURPLE, string);

							format(string, sizeof(string), "You have stored your %s in slot %d.", WeaponNames[weapon], slot);
							SendClientMessage(playerid, COLOR_WHITE, string);

						}
					}
				}
				else SendClientMessage(playerid, COLOR_GREY, "That slot is already occupied.");
			}
			else SendClientMessage(playerid, COLOR_GREY, "Invalid slot specified.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You're too far away from your vehicle.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "You don't own a vehicle.");
	return 1;
}

CMD:vgetweapon(playerid, params[]) {

	new
		slot = strval(params);

	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/vgetweapon [slot 1-5]");

	else if(playerVariables[playerid][pCarModel] >= 1) {
	    if(IsPlayerInRangeOfVehicle(playerid, playerVariables[playerid][pCarID], 6.0)) {
			if(slot >= 1 && slot <= 5) {
				if(playerVariables[playerid][pCarWeapons][slot - 1] != 0) {
					if(playerVariables[playerid][pWeapons][GetWeaponSlot(playerVariables[playerid][pCarWeapons][slot - 1])] == 0) {

						new
							string[86];

						GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
						givePlayerValidWeapon(playerid, playerVariables[playerid][pCarWeapons][slot - 1]);

						format(string, sizeof(string), "* %s retrieves their %s from their vehicle.", szPlayerName, WeaponNames[playerVariables[playerid][pCarWeapons][slot - 1]]);
						nearByMessage(playerid, COLOR_PURPLE, string);

						format(string, sizeof(string), "You have withdrawn your %s from slot %d.", WeaponNames[playerVariables[playerid][pCarWeapons][slot - 1]], slot);
						SendClientMessage(playerid, COLOR_WHITE, string);
						playerVariables[playerid][pCarWeapons][slot - 1] = 0;
					}
					else SendClientMessage(playerid, COLOR_GREY, "You already have a weapon of this type on you - drop it first.");
				}
				else SendClientMessage(playerid, COLOR_GREY, "There is no weapon stored in that slot.");
			}
			else SendClientMessage(playerid, COLOR_GREY, "Invalid slot specified.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You're too far away from your vehicle.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "You don't own a vehicle.");
	return 1;
}

CMD:changeclothes(playerid, params[]) {

	new
		slot = strval(params),
		houseID = getPlayerHouseID(playerid),
		string[64];

	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/changeclothes [slot 1-5]");

	if(getPlayerHouseID(playerid) >= 1) {
	    if(GetPlayerVirtualWorld(playerid) == HOUSE_VIRTUAL_WORLD + houseID) {
			if(slot >= 1 && slot <= 5) {
				if(houseVariables[houseID][hWardrobe][slot - 1] != 0) {

					SetPlayerSkin(playerid, houseVariables[houseID][hWardrobe][slot - 1]);
					playerVariables[playerid][pSkin] = houseVariables[houseID][hWardrobe][slot - 1];

					format(string, sizeof(string), "You have changed your clothing (skin %d, slot %d).", houseVariables[houseID][hWardrobe][slot - 1], slot);
					SendClientMessage(playerid, COLOR_WHITE, string);

					GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
					format(string, sizeof(string), "* %s dresses in their new clothing.", szPlayerName);
					nearByMessage(playerid, COLOR_PURPLE, string);
				}
				else SendClientMessage(playerid, COLOR_GREY, "You don't have any clothing in that slot.");
		    }
		    else SendClientMessage(playerid, COLOR_GREY, "Invalid slot specified.");
	    }
	    else SendClientMessage(playerid, COLOR_GREY, "You're not inside your house.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "You don't have a house.");
	return 1;
}

CMD:hgetweapon(playerid, params[]) {

	new
		slot = strval(params),
		houseID = getPlayerHouseID(playerid);

	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/hgetweapon [slot 1-5]");

	else if(getPlayerHouseID(playerid) >= 1) {
	    if(GetPlayerVirtualWorld(playerid) == HOUSE_VIRTUAL_WORLD + houseID) {
			if(slot >= 1 && slot <= 5) {
				if(houseVariables[houseID][hWeapons][slot - 1] != 0) {
					if(playerVariables[playerid][pWeapons][GetWeaponSlot(houseVariables[houseID][hWeapons][slot - 1])] == 0) {

						new
							string[86];

						GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
						givePlayerValidWeapon(playerid, houseVariables[houseID][hWeapons][slot - 1]);

						format(string, sizeof(string), "* %s retrieves their %s from their safe.", szPlayerName, WeaponNames[houseVariables[houseID][hWeapons][slot - 1]]);
						nearByMessage(playerid, COLOR_PURPLE, string);

						format(string, sizeof(string), "You have withdrawn your %s from slot %d.", WeaponNames[houseVariables[houseID][hWeapons][slot - 1]], slot);
						SendClientMessage(playerid, COLOR_WHITE, string);
						houseVariables[houseID][hWeapons][slot - 1] = 0;
						saveHouse(houseID);
					}
					else SendClientMessage(playerid, COLOR_GREY, "You already have a weapon of this type on you - drop it first.");
				}
				else SendClientMessage(playerid, COLOR_GREY, "There is no weapon stored in that slot.");
			}
			else SendClientMessage(playerid, COLOR_GREY, "Invalid slot specified.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You're not inside your house.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "You don't have a house.");
	return 1;
}

CMD:hstoreweapon(playerid, params[]) {

	new
		slot = strval(params),
		houseID = getPlayerHouseID(playerid);

	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/hstoreweapon [slot 1-5]");

	else if(getPlayerHouseID(playerid) >= 1) {
	    if(GetPlayerVirtualWorld(playerid) == HOUSE_VIRTUAL_WORLD + houseID) {
			if(slot >= 1 && slot <= 5) {
				if(houseVariables[houseID][hWeapons][slot - 1] == 0) {

					new
						string[86],
						weapon;

					GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
					weapon = GetPlayerWeapon(playerid);

					switch(weapon) {
						case 16, 18, 35, 36, 37, 38, 39, 40, 44, 45, 46, 0: SendClientMessage(playerid, COLOR_GREY, "Invalid weapon.");
						default: {
							houseVariables[houseID][hWeapons][slot - 1] = weapon;
							removePlayerWeapon(playerid, weapon);

							format(string, sizeof(string), "* %s places their %s in their safe.", szPlayerName, WeaponNames[weapon]);
							nearByMessage(playerid, COLOR_PURPLE, string);

							format(string, sizeof(string), "You have stored your %s in slot %d.", WeaponNames[weapon], slot);
							SendClientMessage(playerid, COLOR_WHITE, string);

							saveHouse(houseID);
						}
					}
				}
				else SendClientMessage(playerid, COLOR_GREY, "That slot is already occupied.");
			}
			else SendClientMessage(playerid, COLOR_GREY, "Invalid slot specified.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You're not inside your house.");
	}
	else SendClientMessage(playerid, COLOR_GREY, "You don't have a house.");
	return 1;
}

CMD:hbalance(playerid, params[]) {
	new
	    houseID = getPlayerHouseID(playerid), // So we don't have to loop every single time... It's worth the 4 bytes!
		x;

	if(getPlayerHouseID(playerid) >= 1) {
	    new
	        messageString[128];

		format(messageString, sizeof(messageString), "Money: $%d | Materials: %d", houseVariables[houseID][hMoney], houseVariables[houseID][hMaterials]);

		for(new i; i < 5; i++) {
			if(houseVariables[houseID][hWeapons][i] > 0) {
				if(x == 0) format(messageString, sizeof(messageString),"%s | Weapons: %s (slot %d)", messageString, WeaponNames[houseVariables[houseID][hWeapons][i]], i);
				else format(messageString, sizeof(messageString),"%s, %s (slot %d)", messageString, WeaponNames[houseVariables[houseID][hWeapons][i]], i);
				x++;
			}
		}
		SendClientMessage(playerid, COLOR_WHITE, messageString);
	}
	else {
		return SendClientMessage(playerid, COLOR_GREY, "You don't have a house.");
	}
	return 1;
}

CMD:hwithdraw(playerid, params[]) {
	new
	    houseID = getPlayerHouseID(playerid); // So we don't have to loop every single time... It's worth the 4 bytes!

	if(getPlayerHouseID(playerid) >= 1) {
	    if(GetPlayerVirtualWorld(playerid) == HOUSE_VIRTUAL_WORLD+houseID) {
			new
			    amount,

			    houseOperation[72]; // For formatting afterwards.

			if(sscanf(params, "s[32]d", houseOperation, amount))
			    return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/hwithdraw [money/materials] [amount]");

		    if(!strcmp(houseOperation, "money", true)) {
		        if(houseVariables[houseID][hMoney] >= amount) {
		            if(amount >= 1 && amount < 60000000) {
		                houseVariables[houseID][hMoney] -= amount;
		                playerVariables[playerid][pMoney] += amount;

		                if(houseVariables[houseID][hMoney] < 1)
							houseVariables[houseID][hMoney] = 0;

		                if(playerVariables[playerid][pMoney] < 1)
							playerVariables[playerid][pMoney] = 0;

		                format(houseOperation, sizeof(houseOperation), "You have withdrawn $%d from your safe.", amount);
		                SendClientMessage(playerid, COLOR_WHITE, houseOperation);

						GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
						format(houseOperation, sizeof(houseOperation), "* %s withdraws $%d from their safe.", szPlayerName, amount);
						nearByMessage(playerid, COLOR_PURPLE, houseOperation);
		            }
					else {
						SendClientMessage(playerid, COLOR_GREY, "You can't withdraw a negative amount from a house safe. (01x03)");
						printf("[error] 01x03, %d", playerid);
					}
		        }
		    }
		    else if(!strcmp(houseOperation, "materials", true)) {
		        if(houseVariables[houseID][hMaterials] >= amount) {
		            if(amount >= 1 && amount < 60000000) {
		                houseVariables[houseID][hMaterials] -= amount;
		                playerVariables[playerid][pMaterials] += amount;

		                if(houseVariables[houseID][hMaterials] < 1)
							houseVariables[houseID][hMaterials] = 0;

						if(playerVariables[playerid][pMaterials] < 1)
							playerVariables[playerid][pMaterials] = 0;

		                format(houseOperation, sizeof(houseOperation), "You have withdrawn %d materials from your safe.", amount);
		                SendClientMessage(playerid, COLOR_WHITE, houseOperation);

						GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
						format(houseOperation, sizeof(houseOperation), "* %s withdraws %d materials from their safe.", szPlayerName, amount);
						nearByMessage(playerid, COLOR_PURPLE, houseOperation);
		            }
					else {
						SendClientMessage(playerid, COLOR_GREY, "You can't withdraw a negative amount from a house safe. (01x03)");
						printf("[error] 01x03, %d", playerid);
					}
		        }
		    }
		    else {
				return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/hwithdraw [money/materials] [amount]");
			}
		}
    }
    else {
		return SendClientMessage(playerid, COLOR_GREY, "You're not inside your house.");
	}
	return 1;
}

CMD:hdeposit(playerid, params[]) {
	new
	    houseID = getPlayerHouseID(playerid); // So we don't have to loop every single time... It's worth the 4 bytes!

	if(getPlayerHouseID(playerid) >= 1) {
	    if(GetPlayerVirtualWorld(playerid) == HOUSE_VIRTUAL_WORLD+houseID) {
			new
			    amount,
			    houseOperation[72]; // For formatting afterwards.

			if(sscanf(params, "s[32]d", houseOperation, amount)) {
			    return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/hdeposit [money/materials] [amount]");
			}
			else {
			    if(!strcmp(houseOperation, "money", true)) {
			        if(playerVariables[playerid][pMoney] >= amount) {
			            if(amount >= 1 && amount < 60000000) {
			                houseVariables[houseID][hMoney] += amount;
			                playerVariables[playerid][pMoney] -= amount;

			                if(houseVariables[houseID][hMoney] < 1) houseVariables[houseID][hMoney] = 0;
			                if(playerVariables[playerid][pMoney] < 1) playerVariables[playerid][pMoney] = 0;

			                format(houseOperation, sizeof(houseOperation), "You have deposited $%d in your safe.", amount);
			                SendClientMessage(playerid, COLOR_WHITE, houseOperation);

							GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
							format(houseOperation, sizeof(houseOperation), "* %s deposits $%d in their safe.", szPlayerName, amount);
							nearByMessage(playerid, COLOR_PURPLE, houseOperation);

			            }
					}
					else {
						SendClientMessage(playerid, COLOR_GREY, "You can't deposit a negative amountfrom a house safe. (01x01)");
						printf("[error] 01x01, %d", playerid);
			        }
			    }
			    else if(!strcmp(houseOperation, "materials", true)) {
			        if(playerVariables[playerid][pMaterials] >= amount) {
			            if(amount >= 1 && amount < 60000000) {
			                houseVariables[houseID][hMaterials] += amount;
			                playerVariables[playerid][pMaterials] -= amount;

			                if(houseVariables[houseID][hMaterials] < 1) houseVariables[houseID][hMaterials] = 0;
							if(playerVariables[playerid][pMaterials] < 1) playerVariables[playerid][pMaterials] = 0;

			                format(houseOperation, sizeof(houseOperation), "You have deposited %d materials in your safe.", amount);
			                SendClientMessage(playerid, COLOR_WHITE, houseOperation);

							GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
							format(houseOperation, sizeof(houseOperation), "* %s deposits %d materials in their safe.", szPlayerName, amount);
							nearByMessage(playerid, COLOR_PURPLE, houseOperation);
			            }
						else {
							SendClientMessage(playerid, COLOR_GREY, "You can't deposit a negative amountfrom a house safe. (01x01)");
							printf("[error] 01x01, %d", playerid);
				        }
			        }
			    }
			    else {
					return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/hdeposit [money/materials] [amount]");
				}
			}
	    }
	    else {
			return SendClientMessage(playerid, COLOR_GREY, "You're not inside your house.");
		}
	}
	return 1;
}

CMD:btype(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 4) {
        new
            bCID,
            bCType;

		if(sscanf(params, "dd", bCID, bCType)) {
		    SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/btype [businessid] [type]");
            SendClientMessage(playerid, COLOR_GREY, "Types: 0 - None, 1 - 24/7, 2 - Clothing, 3 - Bar, 4 - Sex Shop, 5 - Vehicle Dealership, 6 - Gym");
			SendClientMessage(playerid, COLOR_GREY, "Types: 7 - Restaurant");
			return 1;
		}

		if(!isnull(businessVariables[bCID][bOwner])) {
		    format(szMessage, sizeof(szMessage), "You have changed business ID %d to type %d.", bCID, bCType);
		    SendClientMessage(playerid, COLOR_WHITE, szMessage);
		    
		    if(businessVariables[bCID][bType] != bCType) {
		    	format(szQueryOutput, sizeof(szQueryOutput), "DELETE FROM `businessitems` WHERE `itemBusinessId` = %d;", bCID);
		    	mysql_query(szQueryOutput, THREAD_CHANGE_BUSINESS_TYPE_ITEMS, bCID);
		    }

		    businessVariables[bCID][bType] = bCType;
		    saveBusiness(bCID);
		    
		    foreach(Player, x) {
		        if(GetPlayerVirtualWorld(playerid)-BUSINESS_VIRTUAL_WORLD == bCID)
					businessTypeMessages(bCID, x);
		    }
		} else return SendClientMessage(playerid, COLOR_GREY, "Invalid business ID.");
	}
	return 1;
}

CMD:createbusiness(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 4) {
    	new
          	Float: floatPos[3];

		if(!strcmp(params, "exterior", true)) {
	        GetPlayerPos(playerid, floatPos[0], floatPos[1], floatPos[2]);

            SetPVarFloat(playerid, "pBeX", floatPos[0]);
            SetPVarFloat(playerid, "pBeY", floatPos[1]);
            SetPVarFloat(playerid, "pBeZ", floatPos[2]);

            SetPVarInt(playerid, "bExt", 1);

            SendClientMessage(playerid, COLOR_WHITE, "Business exterior position configured.");
		}
        else if(!strcmp(params, "interior", true)) {
        	GetPlayerPos(playerid, floatPos[0], floatPos[1], floatPos[2]);

            SetPVarFloat(playerid, "pBiX", floatPos[0]);
            SetPVarFloat(playerid, "pBiY", floatPos[1]);
            SetPVarFloat(playerid, "pBiZ", floatPos[2]);

			SetPVarInt(playerid, "pBiID", GetPlayerInterior(playerid));
            SetPVarInt(playerid, "bInt", 1);

            SendClientMessage(playerid, COLOR_WHITE, "Business interior position configured.");
		}
        else if(!strcmp(params, "Complete", true)) {
        	if(GetPVarInt(playerid, "bExt") != 1 || GetPVarInt(playerid, "bInt") != 1)
            	return SendClientMessage(playerid, COLOR_GREY, "You haven't configured either the business exterior or interior. Creation attempt failed.");

			new
			    i,
	       		labelString[128];

			mysql_query("INSERT INTO businesses (businessOwner, businessName) VALUES('Nobody', 'New Business')");
			i = mysql_insert_id();

			if(isnull(businessVariables[i][bOwner])) {
				businessVariables[i][bExteriorPos][0] = GetPVarFloat(playerid, "pBeX");
			    businessVariables[i][bExteriorPos][1] = GetPVarFloat(playerid, "pBeY");
			    businessVariables[i][bExteriorPos][2] = GetPVarFloat(playerid, "pBeZ");

			    businessVariables[i][bInteriorPos][0] = GetPVarFloat(playerid, "pBiX");
			    businessVariables[i][bInteriorPos][1] = GetPVarFloat(playerid, "pBiY");
			    businessVariables[i][bInteriorPos][2] = GetPVarFloat(playerid, "pBiZ");

			    businessVariables[i][bInterior] = GetPVarInt(playerid, "pBiID");

 		        format(businessVariables[i][bOwner], MAX_PLAYER_NAME, "Nobody");
 		        format(businessVariables[i][bName], 32, "Nothing");

 		        businessVariables[i][bLocked] = 1;

		        format(labelString, sizeof(labelString), "%s\n(Business %d - un-owned)\nPrice: $%d (/buybusiness)\n\n(locked)", businessVariables[i][bName], i, businessVariables[i][bPrice]);

		        businessVariables[i][bLabelID] = CreateDynamic3DTextLabel(labelString, COLOR_YELLOW, businessVariables[i][bExteriorPos][0], businessVariables[i][bExteriorPos][1], businessVariables[i][bExteriorPos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
				businessVariables[i][bPickupID] = CreateDynamicPickup(1239, 23, businessVariables[i][bExteriorPos][0], businessVariables[i][bExteriorPos][1], businessVariables[i][bExteriorPos][2], 0, 0, -1, 250);

				saveBusiness(i);

			    DeletePVar(playerid, "pBeX");
			    DeletePVar(playerid, "pBeY");
			    DeletePVar(playerid, "pBeZ");
			    DeletePVar(playerid, "pBiX");
			    DeletePVar(playerid, "pBeY");
			    DeletePVar(playerid, "pBeZ");
			    DeletePVar(playerid, "pBiID");

			    SetPlayerInterior(playerid, 0);
			    SetPlayerPos(playerid, businessVariables[i][bExteriorPos][0], businessVariables[i][bExteriorPos][1], businessVariables[i][bExteriorPos][2]);
				systemVariables[businessCount]++;
				
				createRelevantItems(i);
		        return SendClientMessage(playerid, COLOR_WHITE, "Business created!");
			} else
				return SendClientMessage(playerid, COLOR_WHITE, "There are no available business slots left.");

		} else
        	return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/createbusiness [interior/exit/complete]");
	}
	return 1;
}

CMD:drop(playerid, params[]) {
	new
		string[64];

	if(GetPlayerWeapon(playerid) == 0 || playerVariables[playerid][pEvent] != 0) format(string, sizeof(string),"Materials (%d)\nPhone\nWalkie Talkie", playerVariables[playerid][pMaterials]);
	else format(string, sizeof(string),"Materials (%d)\nPhone\nWalkie Talkie\nCurrent weapon (%s)", playerVariables[playerid][pMaterials], WeaponNames[GetPlayerWeapon(playerid)]);

    ShowPlayerDialog(playerid, DIALOG_DROPITEM, DIALOG_STYLE_LIST, "Inventory", string, "Select", "Cancel");
	return 1;
}

CMD:savevehicle(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 4) {
		if(!IsPlayerInAnyVehicle(playerid))
			return SendClientMessage(playerid, COLOR_GREY, "You need to be in a vehicle to save it.");

		if(GetPVarInt(playerid, "sCc") == 1) {

		    new
		        i,
		        queryString[255],
		        Float: vPos[4]; // x, y, z + z angle

		    GetVehiclePos(GetPlayerVehicleID(playerid), vPos[0], vPos[1], vPos[2]);
		    GetVehicleZAngle(GetPlayerVehicleID(playerid), vPos[3]);

		    format(queryString, sizeof(queryString), "INSERT INTO vehicles (vehicleModelID, vehiclePosX, vehiclePosY, vehiclePosZ, vehiclePosRotation) VALUES('%d', '%f', '%f', '%f', '%f')", GetVehicleModel(GetPlayerVehicleID(playerid)), vPos[0], vPos[1], vPos[2], vPos[3]);
		    mysql_query(queryString);

		    i = mysql_insert_id();

		    SendClientMessage(playerid, COLOR_WHITE, "Vehicle saved!");

		    vehicleVariables[i][vVehicleModelID] = GetVehicleModel(GetPlayerVehicleID(playerid));
		    vehicleVariables[i][vVehiclePosition][0] = vPos[0];
		    vehicleVariables[i][vVehiclePosition][1] = vPos[1];
		    vehicleVariables[i][vVehiclePosition][2] = vPos[2];

		    vehicleVariables[i][vVehicleRotation] = vPos[3];
		    vehicleVariables[i][vVehicleGroup] = 0;

		    vehicleVariables[i][vVehicleScriptID] = GetPlayerVehicleID(playerid);

		    for(new x = 0; x < MAX_VEHICLES; x++) {
		    	if(AdminSpawnedVehicles[x] == GetPlayerVehicleID(playerid)) {
		    	    AdminSpawnedVehicles[x] = 0; // If the vehicle is admin-spawned, we can remove it from the array and move it to the vehicle script enum/arrays.
		    	}
		    }

			systemVariables[vehicleCounts][2]--;
			systemVariables[vehicleCounts][0]++;
			DeletePVar(playerid, "sCc");
		}
		else {
		    SetPVarInt(playerid, "sCc", 1);
		    return SendClientMessage(playerid, COLOR_GREY, "Are you sure you wish to save this vehicle? Re-type the command to verify your action is legitimate.");
		}
	}
	return 1;
}

CMD:businessname(playerid, params[]) {
	if(getPlayerBusinessID(playerid) >= 1) {
	    if(isnull(params))
			 return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/businessname [businessname]");

	    if(strlen(params) >= 43 || strlen(params) < 1)
			return SendClientMessage(playerid, COLOR_GREY, "Invalid name length (1-42).");

	    new
	        x = getPlayerBusinessID(playerid);

	    format(result, sizeof(result), "You have changed the name of your business to '%s'.", params);
	    SendClientMessage(playerid, COLOR_WHITE, result);

		mysql_real_escape_string(params, params);
		strcpy(businessVariables[x][bName], params, 20);

	    switch(businessVariables[x][bLocked]) {
			case 1: {
				format(result, sizeof(result), "%s\n(Business %d - owned by %s)\n\n(locked)", businessVariables[x][bName], x, businessVariables[x][bOwner]);
			}
			case 0: {
				format(result, sizeof(result), "%s\n(Business %d - owned by %s)\n\nPress ~k~~PED_DUCK~ to enter", businessVariables[x][bName], x, businessVariables[x][bOwner]);
			}
		}

		UpdateDynamic3DTextLabelText(businessVariables[x][bLabelID], COLOR_YELLOW, result);
	}
	return 1;
}

CMD:createhouse(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 4) {
		new
	   		Float: floatPos[3];
	   		
		if(!strcmp(params, "Exterior", true)) {
	        GetPlayerPos(playerid, floatPos[0], floatPos[1], floatPos[2]);

	        SetPVarFloat(playerid, "pHeX", floatPos[0]);
	        SetPVarFloat(playerid, "pHeY", floatPos[1]);
	        SetPVarFloat(playerid, "pHeZ", floatPos[2]);

	        SetPVarInt(playerid, "hExt", 1);

	        SendClientMessage(playerid, COLOR_WHITE, "House exterior position configured.");
		} else if(!strcmp(params, "Interior", true)) {
            GetPlayerPos(playerid, floatPos[0], floatPos[1], floatPos[2]);

            SetPVarFloat(playerid, "pHiX", floatPos[0]);
            SetPVarFloat(playerid, "pHiY", floatPos[1]);
            SetPVarFloat(playerid, "pHiZ", floatPos[2]);

			SetPVarInt(playerid, "pHiID", GetPlayerInterior(playerid));
            SetPVarInt(playerid, "hInt", 1);

            SendClientMessage(playerid, COLOR_WHITE, "House interior position configured.");
		} else if(!strcmp(params, "Complete", true)) {
        	if(GetPVarInt(playerid, "hExt") != 1 || GetPVarInt(playerid, "hInt") != 1)
				return SendClientMessage(playerid, COLOR_GREY, "You haven't configured either the house exterior or interior. Creation attempt failed.");

			new
			    i,
           		labelString[96];

			mysql_query("INSERT INTO houses (houseOwner, houseLocked) VALUES('Nobody', '1')");
			i = mysql_insert_id();

			if(isnull(houseVariables[i][hHouseOwner])) {
				houseVariables[i][hHouseExteriorPos][0] = GetPVarFloat(playerid, "pHeX");
				houseVariables[i][hHouseExteriorPos][1] = GetPVarFloat(playerid, "pHeY");
				houseVariables[i][hHouseExteriorPos][2] = GetPVarFloat(playerid, "pHeZ");

			    houseVariables[i][hHouseInteriorPos][0] = GetPVarFloat(playerid, "pHiX");
			    houseVariables[i][hHouseInteriorPos][1] = GetPVarFloat(playerid, "pHiY");
			    houseVariables[i][hHouseInteriorPos][2] = GetPVarFloat(playerid, "pHiZ");

			    houseVariables[i][hHouseExteriorID] = 0;
			    houseVariables[i][hHouseInteriorID] = GetPVarInt(playerid, "pHiID");

			    houseVariables[i][hHouseLocked] = 1;

 		        format(houseVariables[i][hHouseOwner], MAX_PLAYER_NAME, "Nobody");
		        format(labelString, sizeof(labelString), "House %d (un-owned - /buyhouse)\nPrice: $%d\n\n(locked)", i, houseVariables[i][hHousePrice]);

		        houseVariables[i][hLabelID] = CreateDynamic3DTextLabel(labelString, COLOR_YELLOW, houseVariables[i][hHouseExteriorPos][0], houseVariables[i][hHouseExteriorPos][1], houseVariables[i][hHouseExteriorPos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
				houseVariables[i][hPickupID] = CreateDynamicPickup(1273, 23, houseVariables[i][hHouseExteriorPos][0], houseVariables[i][hHouseExteriorPos][1], houseVariables[i][hHouseExteriorPos][2], 0, 0, -1, 250);

				saveHouse(i);

			    DeletePVar(playerid, "pHeX");
			    DeletePVar(playerid, "pHeY");
			    DeletePVar(playerid, "pHeZ");
			    DeletePVar(playerid, "pHiX");
			    DeletePVar(playerid, "pHeY");
			    DeletePVar(playerid, "pHeZ");
			    DeletePVar(playerid, "pHiID");

			    SetPlayerInterior(playerid, 0);
			    SetPlayerPos(playerid, houseVariables[i][hHouseExteriorPos][0], houseVariables[i][hHouseExteriorPos][1], houseVariables[i][hHouseExteriorPos][2]);

				systemVariables[houseCount]++;
		        return SendClientMessage(playerid, COLOR_WHITE, "House created!");
			} else
				return SendClientMessage(playerid, COLOR_WHITE, "There are no available house slots left, sorry!");
		} else
		    return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/createhouse [exterior/interior/complete]");
	}
	return 1;
}

CMD:getvehicle(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 1) {
		new
		    iVehicleID = strval(params);

		if(doesVehicleExist(iVehicleID)) {
	        GetPlayerPos(playerid, playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2]);
	        SetVehiclePos(iVehicleID, playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2]);
	        
	        format(szMessage, sizeof(szMessage), "Vehicle %d has been teleported to your location", iVehicleID);
	        SendClientMessage(playerid, COLOR_WHITE, szMessage);
        }
    }
	return 1;
}

CMD:flipvehicle(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 1) {
        if(!IsPlayerInAnyVehicle(playerid))
            return SendClientMessage(playerid, COLOR_GREY, "You're not in a vehicle.");

        GetVehiclePos(GetPlayerVehicleID(playerid), playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2]);
        SetVehiclePos(GetPlayerVehicleID(playerid), playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2]);
        SendClientMessage(playerid, COLOR_WHITE, "Your vehicle has been flipped back over.");
    }
	return 1;
}

CMD:spawnweapon(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 3) {
        new
            weaponID,
            userID;

		if(sscanf(params, "ud", userID, weaponID))
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/spawnweapon [playerid] [weaponid]");

        if(userID != INVALID_PLAYER_ID) {
			new
				string[63];

			GetPlayerName(userID, szPlayerName, MAX_PLAYER_NAME);
			
			if(weaponID < 1 && weaponID > 48)
			    return SendClientMessage(playerid, COLOR_GREY, "Invalid weapon ID.");

			if(weaponID == 19) {
				if(GetPlayerState(userID) != 1) {
					return SendClientMessage(playerid, COLOR_GREY, "The specified player must be on foot.");
				}
				else {
					format(string, sizeof(string), "You have given %s a jetpack.", szPlayerName);
					SendClientMessage(playerid, COLOR_WHITE, string);
					playerVariables[userID][pJetpack] = 1;
					return SetPlayerSpecialAction(userID, SPECIAL_ACTION_USEJETPACK);
				}
			}
			else {
				format(string, sizeof(string), "You have given %s a %s.", szPlayerName, WeaponNames[weaponID]);
				SendClientMessage(playerid, COLOR_WHITE, string);
				return givePlayerValidWeapon(userID, weaponID);
			}
		}
		else SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
    }
    return 1;
}

CMD:get(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 1) {
        new
            userID;

		if(sscanf(params, "u", userID)) {
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/get [playerid]");
		}
        else {
            if(userID == INVALID_PLAYER_ID)
				return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");

			if(playerVariables[playerid][pAdminLevel] >= playerVariables[userID][pAdminLevel]) {
				new
					messageString[64],

					Float: fPos[3];

				GetPlayerPos(playerid, fPos[0], fPos[1], fPos[2]);
				if(GetPlayerState(userID) == 2) {

					SetVehiclePos(GetPlayerVehicleID(userID), fPos[0], fPos[1]+2, fPos[2]);
					LinkVehicleToInterior(GetPlayerVehicleID(userID), GetPlayerInterior(playerid));
					SetVehicleVirtualWorld(GetPlayerVehicleID(userID), GetPlayerVirtualWorld(playerid));
				}

				else SetPlayerPos(userID, fPos[0], fPos[1]+2, fPos[2]); // If they're driving a vehicle, it gets the vehicle; otherwise, it warps them only.

				SetPlayerInterior(userID, GetPlayerInterior(playerid));
				SetPlayerVirtualWorld(userID, GetPlayerVirtualWorld(playerid));

				GetPlayerName(userID, szPlayerName, MAX_PLAYER_NAME);
				format(messageString, sizeof(messageString), "You have teleported %s to you.", szPlayerName);
				SendClientMessage(playerid, COLOR_WHITE, messageString);
			}
			else SendClientMessage(playerid, COLOR_GREY, "You can't teleport a higher level administrator - request them to teleport to you.");
		}
    }

    return 1;
}

CMD:bprice(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 3) {
	    new
	        businessID,
	        businessPrice;

		if(sscanf(params, "dd", businessID, businessPrice)) {
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/bprice [businessid] [price]");
		}
		else {
		    if(businessID < 1 || businessID > MAX_BUSINESSES) {
				return SendClientMessage(playerid, COLOR_GREY, "Invalid business ID.");
			}
		    else {
				format(szMessage, sizeof(szMessage), "You have set business %d's price to $%d.", businessID, businessPrice);
				SendClientMessage(playerid, COLOR_WHITE, szMessage);

				businessVariables[businessID][bPrice] = businessPrice;

				if(!strcmp(businessVariables[businessID][bOwner], "Nobody", true) && strlen(businessVariables[businessID][bOwner]) >= 1) {
					switch(businessVariables[businessID][bLocked]) {
						case 1: format(szMessage, sizeof(szMessage), "%s\n(Business %d - un-owned)\nPrice: $%d (/buybusiness)\n\n(locked)", businessVariables[businessID][bName], businessID, businessVariables[businessID][bPrice]);
						default: format(szMessage, sizeof(szMessage), "%s\n(Business %d - un-owned)\nPrice: $%d (/buybusiness)\n\nPress ~k~~PED_DUCK~ to enter.", businessVariables[businessID][bName], businessID, businessVariables[businessID][bPrice]);
					}

					UpdateDynamic3DTextLabelText(businessVariables[businessID][bLabelID], COLOR_YELLOW, szMessage);
				}
			}
		}
	}
	return 1;
}

CMD:hprice(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 3) {
	    new
	        houseID,
	        housePrice;

		if(sscanf(params, "dd", houseID, housePrice))
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/hprice [houseid] [price]");

	    if(houseID < 1 || houseID > MAX_HOUSES)
			return SendClientMessage(playerid, COLOR_GREY, "Invalid house ID.");

		format(szMessage, sizeof(szMessage), "You have set house %d's price to $%d.", houseID, housePrice);
		SendClientMessage(playerid, COLOR_WHITE, szMessage);

		houseVariables[houseID][hHousePrice] = housePrice;

		if(!strcmp(houseVariables[houseID][hHouseOwner], "Nobody", true) && strlen(houseVariables[houseID][hHouseOwner]) >= 1) {
			switch(houseVariables[houseID][hHouseLocked]) {
				case 0: format(szMessage, sizeof(szMessage), "House %d (un-owned - /buyhouse)\nPrice: $%d\n\n(locked)", houseID, houseVariables[houseID][hHousePrice]);
				default: format(szMessage, sizeof(szMessage), "House %d (un-owned - /buyhouse)\nPrice: $%d\n\nPress ~k~~PED_DUCK~ to enter.", houseID, houseVariables[houseID][hHousePrice]);
			}

			UpdateDynamic3DTextLabelText(houseVariables[houseID][hLabelID], COLOR_YELLOW, szMessage);
		}
	}
	return 1;
}

CMD:gotoplayervehicle(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 2) {
        new
            userID;

		if(sscanf(params, "u", userID))
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/gotoplayervehicle [playerid]");

        if(userID == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");

		if(playerVariables[userID][pCarModel] < 1)
			return SendClientMessage(playerid, COLOR_GREY, "That player does not own a vehicle.");

		new
		    messageString[64];

		GetVehiclePos(playerVariables[userID][pCarID], playerVariables[userID][pCarPos][0], playerVariables[userID][pCarPos][1], playerVariables[userID][pCarPos][2]);

		if(GetPlayerState(playerid) == 2) {
			SetVehiclePos(GetPlayerVehicleID(playerid), playerVariables[userID][pCarPos][0], playerVariables[userID][pCarPos][1]+2, playerVariables[userID][pCarPos][2]);
			SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), GetVehicleVirtualWorld(playerVariables[userID][pCarID]));
			LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
		}
		else SetPlayerPos(playerid, playerVariables[userID][pCarPos][0], playerVariables[userID][pCarPos][1]+2, playerVariables[userID][pCarPos][2]);

		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, GetVehicleVirtualWorld(playerVariables[userID][pCarID]));

		GetPlayerName(userID, szPlayerName, MAX_PLAYER_NAME);

		format(messageString, sizeof(messageString), "You have teleported to %s's %s.", szPlayerName, VehicleNames[playerVariables[userID][pCarModel] - 400]);
		SendClientMessage(playerid, COLOR_WHITE, messageString);
    }
    return 1;
}

CMD:goto(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 1) {
        new
            userID;

		if(sscanf(params, "u", userID)) {
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/goto [playerid]");
		}
        else {
            if(!IsPlayerConnected(userID)) return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");

			new
			    messageString[64],

			    Float: fPos[3];

			GetPlayerPos(userID, fPos[0], fPos[1], fPos[2]);

			if(GetPlayerState(playerid) == 2) {

				SetVehiclePos(GetPlayerVehicleID(playerid), fPos[0], fPos[1]+2, fPos[2]);

				LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(userID));
				SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), GetPlayerVirtualWorld(userID));
			}

			else SetPlayerPos(playerid, fPos[0], fPos[1]+2, fPos[2]);

			SetPlayerInterior(playerid, GetPlayerInterior(userID));
			SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(userID));

			GetPlayerName(userID, szPlayerName, MAX_PLAYER_NAME);

			format(messageString, sizeof(messageString), "You have teleported to %s.", szPlayerName);
			SendClientMessage(playerid, COLOR_WHITE, messageString);
		}
    }

    return 1;
}

CMD:setleader(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 3) {
        new
            groupID,
            userID;

		if(sscanf(params, "ud", userID, groupID)) {
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/setleader [playerid] [groupid]");
		}
        else {
			if(groupID < 1 || groupID > MAX_GROUPS) return SendClientMessage(playerid, COLOR_GREY, "Invalid group ID.");

			playerVariables[userID][pGroup] = groupID;
			playerVariables[userID][pGroupRank] = 6;

			new

			    string[128];

			GetPlayerName(userID, szPlayerName, MAX_PLAYER_NAME);

			format(string, sizeof(string), "You have set %s to lead group %s.", szPlayerName, groupVariables[groupID][gGroupName]);
			SendClientMessage(playerid, COLOR_WHITE, string);

			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

			format(string, sizeof(string), "Administrator %s has set you to lead group %s.", szPlayerName, groupVariables[groupID][gGroupName]);
			SendClientMessage(userID, COLOR_WHITE, string);
		}
    }

    return 1;
}

CMD:buybusiness(playerid, params[]) {
    if(playerVariables[playerid][pStatus] >= 1) {
        for(new x = 0; x < MAX_BUSINESSES; x++) {
			if(IsPlayerInRangeOfPoint(playerid, 5, businessVariables[x][bExteriorPos][0], businessVariables[x][bExteriorPos][1], businessVariables[x][bExteriorPos][2])) {
				if(!strcmp(businessVariables[x][bOwner], "Nobody", true)) {
				    if(businessVariables[x][bPrice] == -1) return SendClientMessage(playerid, COLOR_GREY, "This business was blocked from being purchased by an administrator.");
					if(getPlayerBusinessID(playerid) >= 1) return SendClientMessage(playerid, COLOR_GREY, "You already own a business.");
					if(playerVariables[playerid][pMoney] >= businessVariables[x][bPrice]) {
						playerVariables[playerid][pMoney] -= businessVariables[x][bPrice];

						new
						    labelString[96];

						strcpy(businessVariables[x][bOwner], playerVariables[playerid][pNormalName], MAX_PLAYER_NAME);

						DestroyDynamicPickup(businessVariables[x][bPickupID]);

					    if(businessVariables[x][bLocked] == 1) {
					    	format(labelString, sizeof(labelString), "%s\n(Business %d - owned by %s)\n\n(locked)", businessVariables[x][bName], x, businessVariables[x][bOwner]);
					    }
					    else {
					        format(labelString, sizeof(labelString), "%s\n(Business %d - owned by %s)\n\nPress ~k~~PED_DUCK~ to enter", businessVariables[x][bName], x, businessVariables[x][bOwner]);
					    }
						UpdateDynamic3DTextLabelText(businessVariables[x][bLabelID], COLOR_YELLOW, labelString);
						businessVariables[x][bPickupID] = CreateDynamicPickup(1239, 23, businessVariables[x][bExteriorPos][0], businessVariables[x][bExteriorPos][1], businessVariables[x][bExteriorPos][2], 0, 0, -1, 250);

						SendClientMessage(playerid, COLOR_WHITE, "Congratulations on your purchase!");

						saveBusiness(x);
					}
					else SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this business.");
				}
				else {
					return SendClientMessage(playerid, COLOR_GREY, "You can't purchase an owned business.");
				}
			}
		}
    }
	return 1;
}

CMD:bspawnpos(playerid, params[]) {

	if(getPlayerBusinessID(playerid) >= 1) {

		new
			businessID = getPlayerBusinessID(playerid);

		if(businessVariables[businessID][bType] == 5) {
			if(IsPlayerInRangeOfPoint(playerid, 30.0, businessVariables[businessID][bExteriorPos][0], businessVariables[businessID][bExteriorPos][1], businessVariables[businessID][bExteriorPos][2])) {
				GetPlayerPos(playerid, businessVariables[businessID][bMiscPos][0], businessVariables[businessID][bMiscPos][1], businessVariables[businessID][bMiscPos][2]);
				SendClientMessage(playerid, COLOR_WHITE, "You have successfully altered the spawn position of your vehicle dealership business.");
			}
			else SendClientMessage(playerid, COLOR_GREY, "You must be within thirty metres of the exterior of your business.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You don't own a vehicle dealership.");
	}
	return 1;
}

CMD:movebusiness(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 3) {
	    new
	        houseID,
	        subject[32];

		if(sscanf(params, "ds[32]", houseID, subject)) {
		    SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/movebusiness [businessid] [exterior/interior]");
		}
		else {
		    if(houseID < 1 || houseID > MAX_BUSINESSES) return SendClientMessage(playerid, COLOR_GREY, "Invalid business ID.");

            if(strcmp(subject, "exterior", true) == 0) {
			    GetPlayerPos(playerid, businessVariables[houseID][bExteriorPos][0], businessVariables[houseID][bExteriorPos][1], businessVariables[houseID][bExteriorPos][2]);

			    DestroyDynamic3DTextLabel(businessVariables[houseID][bLabelID]);
			    DestroyDynamicPickup(businessVariables[houseID][bPickupID]);

				if(!strcmp(businessVariables[houseID][bOwner], "Nobody", true) && strlen(businessVariables[houseID][bOwner]) >= 1) {
				    new
				        labelString[96];

				    if(businessVariables[houseID][bLocked] == 1) {
				    	format(labelString, sizeof(labelString), "%s\n(Business %d - un-owned)\nPrice: $%d (/buybusiness)\n\n(locked)", businessVariables[houseID][bName], houseID, businessVariables[houseID][bPrice]);
				    }
				    else {
				        format(labelString, sizeof(labelString), "%s\n(Business %d - un-owned)\nPrice: $%d (/buybusiness)\n\nPress ~k~~PED_DUCK~ to enter.", businessVariables[houseID][bName], houseID, businessVariables[houseID][bPrice]);
				    }

				    businessVariables[houseID][bLabelID] = CreateDynamic3DTextLabel(labelString, COLOR_YELLOW, businessVariables[houseID][bExteriorPos][0], businessVariables[houseID][bExteriorPos][1], businessVariables[houseID][bExteriorPos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
					businessVariables[houseID][bPickupID] = CreateDynamicPickup(1239, 23, businessVariables[houseID][bExteriorPos][0], businessVariables[houseID][bExteriorPos][1], businessVariables[houseID][bExteriorPos][2], 0, 0, -1, 250);

				}
				else {
				    new
				        labelString[96];

				    if(businessVariables[houseID][bLocked] == 1) {
				    	format(labelString, sizeof(labelString), "%s\n(Business %d - owned by %s)\n\n(locked)", businessVariables[houseID][bName], houseID, businessVariables[houseID][bOwner]);
				    }
				    else {
				        format(labelString, sizeof(labelString), "%s\n(Business %d - owned by %s)\n\nPress ~k~~PED_DUCK~ to enter", businessVariables[houseID][bName], houseID, businessVariables[houseID][bOwner]);
				    }

				    businessVariables[houseID][bLabelID] = CreateDynamic3DTextLabel(labelString, COLOR_YELLOW, businessVariables[houseID][bExteriorPos][0], businessVariables[houseID][bExteriorPos][1], businessVariables[houseID][bExteriorPos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
					businessVariables[houseID][bPickupID] = CreateDynamicPickup(1239, 23, businessVariables[houseID][bExteriorPos][0], businessVariables[houseID][bExteriorPos][1], businessVariables[houseID][bExteriorPos][2], 0, 0, -1, 250);
				}

				SendClientMessage(playerid, COLOR_WHITE, "The business exterior has successfully been changed.");
			}
			else if(strcmp(subject, "interior", true) == 0) {
			    GetPlayerPos(playerid, businessVariables[houseID][bInteriorPos][0], businessVariables[houseID][bInteriorPos][1], businessVariables[houseID][bInteriorPos][2]);
			    businessVariables[houseID][bInterior] = GetPlayerInterior(playerid);
			    SendClientMessage(playerid, COLOR_WHITE, "The business interior has successfully been changed.");
			}
			saveBusiness(houseID);
		}
	}

	return 1;
}

CMD:movehq(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 3) {
	    new
	        ID,
	        subject[32],
			string[128];

		if(sscanf(params, "ds[32]", ID, subject)) {
		    SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/movehq [group ID] [exterior/interior]");
		}
		else {
		    if(ID < 1 || ID > MAX_GROUPS) return SendClientMessage(playerid, COLOR_GREY, "Invalid group ID.");

            if(strcmp(subject, "exterior", true) == 0) {
			    GetPlayerPos(playerid, groupVariables[ID][gGroupExteriorPos][0], groupVariables[ID][gGroupExteriorPos][1], groupVariables[ID][gGroupExteriorPos][2]);

			    DestroyDynamic3DTextLabel(groupVariables[ID][gGroupLabelID]);
			    DestroyDynamicPickup(groupVariables[ID][gGroupPickupID]);

				new
    				labelString[96];

				switch(groupVariables[ID][gGroupHQLockStatus]) {
			    	case 0: format(labelString, sizeof(labelString), "%s's HQ\n\nPress ~k~~PED_DUCK~ to enter.", groupVariables[ID][gGroupName]);
			    	case 1: format(labelString, sizeof(labelString), "%s's HQ\n\n(locked)", groupVariables[ID][gGroupName]);
			    }

				groupVariables[ID][gGroupLabelID] = CreateDynamic3DTextLabel(labelString, COLOR_YELLOW, groupVariables[ID][gGroupExteriorPos][0], groupVariables[ID][gGroupExteriorPos][1], groupVariables[ID][gGroupExteriorPos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 50.0);
				groupVariables[ID][gGroupPickupID] = CreateDynamicPickup(1239, 23, groupVariables[ID][gGroupExteriorPos][0], groupVariables[ID][gGroupExteriorPos][1], groupVariables[ID][gGroupExteriorPos][2], 0, -1, -1, 50);
			}
			else if(strcmp(subject, "interior", true) == 0){
			    GetPlayerPos(playerid, groupVariables[ID][gGroupInteriorPos][0], groupVariables[ID][gGroupInteriorPos][1], groupVariables[ID][gGroupInteriorPos][2]);
			    groupVariables[ID][gGroupHQInteriorID] = GetPlayerInterior(playerid);

			}
			format(string,sizeof(string),"You have successfully moved the %s of the %s group (ID %d).",subject,groupVariables[ID][gGroupName],ID);
			SendClientMessage(playerid, COLOR_WHITE, string);
		}
	}

	return 1;
}

CMD:movehouse(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 3) {
	    new
	        houseID,
	        subject[32];

		if(sscanf(params, "ds[32]", houseID, subject)) {
		    SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/movehouse [houseid] [exterior/interior]");
		}
		else {
		    if(houseID < 1 || houseID > MAX_HOUSES) return SendClientMessage(playerid, COLOR_GREY, "Invalid house ID.");

            if(strcmp(subject, "exterior", true) == 0) {
			    GetPlayerPos(playerid, houseVariables[houseID][hHouseExteriorPos][0], houseVariables[houseID][hHouseExteriorPos][1], houseVariables[houseID][hHouseExteriorPos][2]);

			    DestroyDynamic3DTextLabel(houseVariables[houseID][hLabelID]);
			    DestroyDynamicPickup(houseVariables[houseID][hPickupID]);

				if(!strcmp(houseVariables[houseID][hHouseOwner], "Nobody", true) && strlen(houseVariables[houseID][hHouseOwner]) >= 1) {
				    new
				        labelString[96];

				    if(houseVariables[houseID][hHouseLocked] == 1) {
				    	format(labelString, sizeof(labelString), "House %d (un-owned - /buyhouse)\nPrice: $%d\n\n(locked)", houseID, houseVariables[houseID][hHousePrice]);
				    }
				    else {
				        format(labelString, sizeof(labelString), "House %d (un-owned - /buyhouse)\nPrice: $%d\n\nPress ~k~~PED_DUCK~ to enter.", houseID, houseVariables[houseID][hHousePrice]);
				    }

				    houseVariables[houseID][hLabelID] = CreateDynamic3DTextLabel(labelString, COLOR_YELLOW, houseVariables[houseID][hHouseExteriorPos][0], houseVariables[houseID][hHouseExteriorPos][1], houseVariables[houseID][hHouseExteriorPos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
					houseVariables[houseID][hPickupID] = CreateDynamicPickup(1273, 23, houseVariables[houseID][hHouseExteriorPos][0], houseVariables[houseID][hHouseExteriorPos][1], houseVariables[houseID][hHouseExteriorPos][2], 0, houseVariables[houseID][hHouseExteriorID], -1, 250);

				}
				else {
				    new
				        labelString[96];

				    if(houseVariables[houseID][hHouseLocked] == 1) {
				    	format(labelString, sizeof(labelString), "House %d (owned)\nOwner: %s\n\n(locked)", houseID, houseVariables[houseID][hHouseOwner]);
				    }
				    else {
				        format(labelString, sizeof(labelString), "House %d (owned)\nOwner: %s\n\nPress ~k~~PED_DUCK~ to enter.", houseID, houseVariables[houseID][hHouseOwner]);
				    }

				    houseVariables[houseID][hLabelID] = CreateDynamic3DTextLabel(labelString, COLOR_YELLOW, houseVariables[houseID][hHouseExteriorPos][0], houseVariables[houseID][hHouseExteriorPos][1], houseVariables[houseID][hHouseExteriorPos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
				    houseVariables[houseID][hPickupID] = CreateDynamicPickup(1272, 23, houseVariables[houseID][hHouseExteriorPos][0], houseVariables[houseID][hHouseExteriorPos][1], houseVariables[houseID][hHouseExteriorPos][2], 0, houseVariables[houseID][hHouseExteriorID], -1, 50);
				}

				SendClientMessage(playerid, COLOR_WHITE, "The house exterior has successfully been changed.");
			}
			else if(strcmp(subject, "interior", true) == 0) {
			    GetPlayerPos(playerid, houseVariables[houseID][hHouseInteriorPos][0], houseVariables[houseID][hHouseInteriorPos][1], houseVariables[houseID][hHouseInteriorPos][2]);
			    houseVariables[houseID][hHouseInteriorID] = GetPlayerInterior(playerid);
			    SendClientMessage(playerid, COLOR_WHITE, "The house interior has successfully been changed.");
			}

			saveHouse(houseID);
		}
	}

	return 1;
}

CMD:gotohouse(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 3) {

		if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/gotohouse [houseid]");
	    new
	        houseID = strval(params);

		if(houseID < 1 || houseID > MAX_HOUSES) return SendClientMessage(playerid, COLOR_GREY, "Invalid house ID.");

		SetPlayerPos(playerid, houseVariables[houseID][hHouseExteriorPos][0], houseVariables[houseID][hHouseExteriorPos][1], houseVariables[houseID][hHouseExteriorPos][2]);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);

	}
	return 1;
}

CMD:gotobusiness(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 3) {

		if(isnull(params)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/gotobusiness [businessid]");
	    new
	        houseID = strval(params);

		if(houseID < 1 || houseID > MAX_BUSINESSES) return SendClientMessage(playerid, COLOR_GREY, "Invalid business ID.");

		SetPlayerPos(playerid, businessVariables[houseID][bExteriorPos][0],businessVariables[houseID][bExteriorPos][1], businessVariables[houseID][bExteriorPos][2]);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);

	}
	return 1;
}

CMD:fish(playerid, params[]) {
	if(playerVariables[playerid][pJob] == 4 && IsPlayerInAnyVehicle(playerid) && playerVariables[playerid][pFishing] == 0) {
		if(playerVariables[playerid][pJobDelay] > 0) {

			new
				string[57];

			format(string, sizeof(string), "You must wait %d minutes (%d seconds) until you can go fishing again.", playerVariables[playerid][pJobDelay] / 60, playerVariables[playerid][pJobDelay]);
			return SendClientMessage(playerid, COLOR_GREY, string);
		}
		else if(IsABoat(GetPlayerVehicleID(playerid))) {
            playerVariables[playerid][pFishing] = 1;
			/*playerVariables[playerid][pFishingBar] = CreateProgressBar(258.00, 137.00, 131.50, 3.19, COLOR_LIGHT, 100.0); // There's a bug people have noticed which I've not been able to fix; other players often see the textdraws when people are fishing
			ShowProgressBarForPlayer(playerid, playerVariables[playerid][pFishingBar]);*/
			SendClientMessage(playerid, COLOR_WHITE, "You're now fishing. It will take a few seconds to reel your fish in.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "This vehicle cannot be used for fishing.");
    } else {
		SendClientMessage(playerid, COLOR_GREY, "You're required to be in a boat, have the fisherman's job and not to actively be fishing.");
	}
	return 1;
}

CMD:gotopoint(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 3) {
	    new
	        interiorID,
	        Float: coordinates[3];

		if(sscanf(params, "fffd", coordinates[0], coordinates[1], coordinates[2], interiorID)) {
		    SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/gotopoint [x] [y] [z] [interior id]");
		}
		else {
		    SetPlayerInterior(playerid, interiorID);
		    SetPlayerPos(playerid, coordinates[0], coordinates[1], coordinates[2]);
		}
	}

	return 1;
}

CMD:connections(playerid, params[]) {
	format(szQueryOutput, sizeof(szQueryOutput), "SELECT playeraccounts.playerName, playerconnections.conTS FROM playerconnections INNER JOIN playeraccounts ON playerconnections.conPlayerID = playeraccounts.playerID WHERE playeraccounts.playerID = '%d' LIMIT 5", playerVariables[playerid][pInternalID]);
	mysql_query(szQueryOutput, THREAD_LAST_CONNECTIONS, playerid);
	return 1;
}

CMD:reports(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 1) {
		new
			tool[16]; 

		if(sscanf(params, "s[16] ", tool)) {
		    SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/reports [tool]");
		    SendClientMessage(playerid, COLOR_GREY, "Tools: List, Accept, Disregard, Status");
		}
		else {
		    if(strcmp(tool, "List", true) == 0) {
				SendClientMessage(playerid, COLOR_WHITE, "-------------------------------------------------------------------------------------------------------------------------------");

		        new
					string[128],
					reportCount;

		        foreach(Player, i) {
		            if(playerVariables[i][pReport] >= 1) {
		                GetPlayerName(i, szPlayerName, MAX_PLAYER_NAME);
		                format(string, sizeof(string), "[ACTIVE] %s [%d] has reported: %s", szPlayerName, i, playerVariables[i][pReportMessage]);
		                SendClientMessage(playerid, COLOR_YELLOW, string);
		                reportCount++;
		            }
		        }

		        format(string, sizeof(string), "ACTIVE REPORTS: %d.", reportCount);
		        SendClientMessage(playerid, COLOR_WHITE, string);

				SendClientMessage(playerid, COLOR_WHITE, "-------------------------------------------------------------------------------------------------------------------------------");
		    }
		    else if(strcmp(tool, "Accept", true) == 0)
		    {
		        new
					userID;

		        if(sscanf(params, "s[16]u", tool, userID)) {
		            SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/reports accept [playerid]");
		        }
				else if(playerVariables[userID][pStatus] != 1)
		        {
					SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
		        }
		        else if(playerVariables[userID][pReport] == 0)
		        {
					SendClientMessage(playerid, COLOR_GREY, "That player doesn't have an active report.");
				}
				else
				{
					new
						string[128];

					GetPlayerName(userID, szPlayerName, MAX_PLAYER_NAME);

		            format(string, sizeof(string), "You have accepted %s's report (%s)", szPlayerName, playerVariables[userID][pReportMessage]);
		            SendClientMessage(playerid, COLOR_WHITE, string);

		            playerVariables[userID][pReport] = 0;
		            format(playerVariables[userID][pReportMessage], 64, "(null)");

		            GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

		            format(string, sizeof(string), "Thank you for your report! Administrator %s is now reviewing your report.", szPlayerName);
		            SendClientMessage(userID, COLOR_YELLOW, string);

		            SetPVarInt(playerid, "aR", 1);
		            SetPVarInt(playerid, "aRf", userID);
					
					ShowPlayerDialog(playerid, DIALOG_REPORT, DIALOG_STYLE_LIST, "Report System", "Teleport\nSpectate\nTake no action", "Select", "Exit");
		        }
		    }
		    else if(strcmp(tool, "Disregard", true) == 0) {
		        new
					userID,
					string[128];

		        if(sscanf(params, "s[16]u", tool, userID)) {
		            SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/reports disregard [playerid]");
		        }
				else if(playerVariables[userID][pStatus] != 1)
		        {
					SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
		        }
				else if(playerVariables[userID][pReport] == 0)
		        {
					SendClientMessage(playerid, COLOR_GREY, "That player doesn't have an active report.");
				}
		        else 
				{
					GetPlayerName(userID, szPlayerName, MAX_PLAYER_NAME);

		            playerVariables[userID][pReport] = 0;
		            format(playerVariables[userID][pReportMessage], 64, "(null)");

		            format(string, sizeof(string), "You have disregarded %s's report.", szPlayerName);
		            SendClientMessage(playerid, COLOR_WHITE, string);
		        }
		    }
		    else if(strcmp(tool, "Status", true) == 0) {
		        if(playerVariables[playerid][pAdminLevel] >= 4) {
			        if(systemVariables[reportSystem] == 0) {
			            systemVariables[reportSystem] = 1;
			            SendClientMessage(playerid, COLOR_WHITE, "You have disabled the report system.");
			            SendClientMessageToAll(COLOR_YELLOW, "The report system has been temporarily disabled.");
			        }
			        else {
			            systemVariables[reportSystem] = 0;
			            SendClientMessage(playerid, COLOR_WHITE, "You have enabled the report system.");
			            SendClientMessageToAll(COLOR_YELLOW, "The report system has been re-enabled.");
			        }
		        }
		        else {
					return SendClientMessage(playerid, COLOR_GREY, "You need to be a Head Administrator or above to use this command.");
				}
 		    }
		    else {
			    SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/reports [tool]");
			    SendClientMessage(playerid, COLOR_GREY, "TOOLS: List, Accept, Disregard, Status");
		    }
		}
	}

	return 1;
}

CMD:announce(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 1) {
        if(!isnull(params)) {
			GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
			format(szMessage, sizeof(szMessage), "(( Announcement from %s: %s ))", szPlayerName, params);
			SendClientMessageToAll(COLOR_LIGHTRED, szMessage);
		}
		else {
		    return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/announce [text]");
		}
	}
	return 1;
}

CMD:o(playerid, params[]) {
	return cmd_ooc(playerid, params);
}

CMD:ooc(playerid, params[]) {
    if(systemVariables[OOCStatus] == 1)
		return SendClientMessage(playerid, COLOR_GREY, "The OOC chat channel is currently disabled.");

	if(playerVariables[playerid][pOOCMuted] == 1)
		return SendClientMessage(playerid, COLOR_GREY, "You have been muted from the OOC chat channel.");

    if(!isnull(params)) {
    	new
			playerName2[MAX_PLAYER_NAME];

	    GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

	    format(szMessage, sizeof(szMessage), "(( %s says: %s ))", szPlayerName, params);

		foreach(Player, x) {
			if(playerVariables[x][pSeeOOC] == 1) {
			    GetPlayerName(x, playerName2, MAX_PLAYER_NAME);
			    if(strfind(szMessage, playerName2, true) == -1) {
			        format(szMessage, sizeof(szMessage), "(( %s says: %s ))", szPlayerName, params);
	  				SendClientMessage(x, COLOR_LIGHT, szMessage);
  				} else {
  				    if(strfind(playerName2, szPlayerName, true) != -1) {
				        format(szMessage, sizeof(szMessage), "(( %s says: %s ))", szPlayerName, params);
		  				SendClientMessage(x, COLOR_LIGHT, szMessage);
  				    } else {
						format(szMessage, sizeof(szMessage), "(( %s says: "EMBED_LIGHTRED"%s "EMBED_OOC"))", szPlayerName, params);
		  				SendClientMessage(x, COLOR_LIGHT, szMessage);
		  				PlayerPlaySound(x, 1057, 0, 0, 0);
	  				}
  				}
			}
		}
		
		#if !defined NO_IRC
			format(szMessage, sizeof(szMessage), "%s says [in-game]: %s", szPlayerName, params);
			IRC_Say(scriptBots[0], IRC_CHANNEL_MAIN, szMessage);
		#endif
		return 1;
	}
	else
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/(o)oc [message]");
}

CMD:seeooc(playerid, params[]) 
{
    if(playerVariables[playerid][pStatus] == 1) 
	{
		if(playerVariables[playerid][pSeeOOC] == 1) {
		    playerVariables[playerid][pSeeOOC] = 0;
		    SendClientMessage(playerid, COLOR_WHITE, "You will no longer see any chat submitted to the public OOC channel.");
		}
		else {
		    playerVariables[playerid][pSeeOOC] = 1;
		    SendClientMessage(playerid, COLOR_WHITE, "You will now see any chat submitted to the public OOC channel.");
		}
	}
	return 1;
}

CMD:disableooc(playerid, params[]) 
{
    if(playerVariables[playerid][pAdminLevel] >= 2) 
	{
        if(systemVariables[OOCStatus] == 0) 
		{
		    systemVariables[OOCStatus] = 1;
		    SendClientMessageToAll(COLOR_LIGHTRED, "The OOC chat channel has been disabled.");
        }
        else 
		{
			SendClientMessage(playerid, COLOR_GREY, "OOC is already disbled.");
		}
    }
	return 1;
}

CMD:enableooc(playerid, params[]) 
{
    if(playerVariables[playerid][pAdminLevel] >= 2) 
	{
        if(systemVariables[OOCStatus] == 1) 
		{
		    systemVariables[OOCStatus] = 0;
		    SendClientMessageToAll(COLOR_LIGHTRED, "The OOC chat channel has been enabled.");
        }
        else 
		{
			SendClientMessage(playerid, COLOR_GREY, "OOC is already enabled.");
		}
    }
	return 1;
}

CMD:namechanges(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 1) {
        if(sscanf(params, "u", iTarget))
            return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/namechanges [playerid]");

		if(iTarget == INVALID_PLAYER_ID || playerVariables[playerid][pStatus] < 1)
		    return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");

		format(szQueryOutput, sizeof(szQueryOutput), "SELECT namechangeid, oldname, newname, time FROM namechanges WHERE userid = %d ORDER BY namechangeid ASC", playerVariables[iTarget][pInternalID]);
		mysql_query(szQueryOutput, THREAD_CHECK_PLAYER_NAMES, playerid);
    }
	return 1;
}

CMD:changename(playerid, params[]) 
{
	if(playerVariables[playerid][pAdminLevel] >= 4) 
	{
		new
			newName[MAX_PLAYER_NAME];

		if(sscanf(params, "us[24]", iTarget, newName)) 
		{
			SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/changename [playerid] [newname]");
		}
		else if(playerVariables[iTarget][pStatus] != 1)
		{
			SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
		}
		else 
		{
			if(getPlayerBusinessID(iTarget) >= 1)
				strcpy(businessVariables[getPlayerBusinessID(iTarget)][bOwner], newName, MAX_PLAYER_NAME);

			if(getPlayerHouseID(iTarget) >= 1)
				strcpy(houseVariables[getPlayerHouseID(iTarget)][hHouseOwner], newName, MAX_PLAYER_NAME);

			new
				playerName[2][MAX_PLAYER_NAME],
				querySz[150];

			format(querySz, sizeof(querySz), "SELECT playerName FROM playeraccounts WHERE playerName = '%s'", newName);
			mysql_query(querySz);
			mysql_store_result();

			if(mysql_num_rows() > 0) {
			    SendClientMessage(playerid, COLOR_GREY, "That name is already taken.");
			    mysql_free_result();
			    return 1;
			}

			mysql_real_escape_string(newName, newName);

			GetPlayerName(playerid, playerName[0], MAX_PLAYER_NAME);
			GetPlayerName(iTarget, playerName[1], MAX_PLAYER_NAME);

			format(querySz, sizeof(querySz), "UPDATE playeraccounts SET playerName = '%s' WHERE playerID = '%d'", newName, playerVariables[iTarget][pInternalID]);
			mysql_query(querySz); // No point in threading a simple response...

			format(querySz, sizeof(querySz), "INSERT INTO namechanges (userid, oldname, newname, adminid) VALUES(%d, '%s', '%s', %d)", playerVariables[iTarget][pInternalID], playerName[1], newName, playerVariables[playerid][pInternalID]);
			mysql_query(querySz);

			format(querySz, sizeof(querySz), "Administrator %s has changed your name to %s.", playerName[0], newName); // Might as well re-use the string...
			SendClientMessage(iTarget, COLOR_WHITE, querySz);

			format(querySz, sizeof(querySz), "You have changed %s (ID: %d)'s name to %s.", playerName[1], iTarget, newName);
			SendClientMessage(playerid, COLOR_WHITE, querySz);

			SetPlayerName(iTarget, newName);

			strcpy(playerVariables[iTarget][pNormalName], newName, MAX_PLAYER_NAME);
		}
	}
	return 1;
}

CMD:ahelp(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 1) {
        SendClientMessage(playerid, COLOR_TEAL, "--------------------------------------------------------------------------------------------------------------------------------");

	    SendClientMessage(playerid, COLOR_WHITE, "Level 1: /ban, /kick, /check, /reports, /announce, /warn, /listgroups, /a, /adminduty, /vrespawn, /fixcar, /flipvehicle");
		SendClientMessage(playerid, COLOR_WHITE, "Level 1: /go, /get, /goto, /spec, /slap, /listguns, /gotoplayervehicle, /serverstats, /closestcar, /namechanges, /getvehicle");

	    if(playerVariables[playerid][pAdminLevel] >= 2) {
	        SendClientMessage(playerid, COLOR_GREY, "Level 2: /enableooc, /disableooc, /prison, /jail, /release, /mute, /omute, /fine, /unfreeze, /freeze, /forcelogout");
	    }

	    if(playerVariables[playerid][pAdminLevel] >= 3) {
	        SendClientMessage(playerid, COLOR_WHITE, "Level 3: /unban, /unbanip, /veh, /despawnavehicles, /spawnweapon, /gotopoint, /setleader, /movehouse, /asellhouse");
	        SendClientMessage(playerid, COLOR_WHITE, "Level 3: /set, /hprice, /bprice, /vehname, /gunname, /explode, /gotohouse, /gotobusiness");
			SendClientMessage(playerid, COLOR_WHITE, "Level 3: /eventproperties, /startevent, /endevent, /setplayervehicle, /setweather, /vdespawn");
	    }

	    if(playerVariables[playerid][pAdminLevel] >= 4) {
	        SendClientMessage(playerid, COLOR_GREY, "Level 4: /setadminname, /createhouse, /createbusiness, /btype, /gtype");
			SendClientMessage(playerid, COLOR_GREY, "Level 4: /savevehicle, /vgroup, /vcolour, /vmove, /vmodel, /vmassrespawn, /changename");
	    }

	    if(playerVariables[playerid][pAdminLevel] >= 5) {
	        SendClientMessage(playerid, COLOR_WHITE, "Level 5: /savedata, /gmx, /sethelper, /listassets, /setnewbiespawn, /setadminlevel");
	    }

		SendClientMessage(playerid, COLOR_TEAL, "--------------------------------------------------------------------------------------------------------------------------------");
	}

	return 1;
}

CMD:ah(playerid, params[]) {
	return cmd_ahelp(playerid, params);
}

CMD:jail(playerid, params[]) 
{
    if(playerVariables[playerid][pAdminLevel] >= 2) 
	{
        new
            minutes,
            userID,
            reason[64];

        if(sscanf(params, "uds[64]", userID, minutes, reason)) 
		{
			SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/jail [playerid] [minutes] [reason]");
		}
		else if(playerVariables[playerid][pStatus] != 1)
		{
			SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
		}
		else 
		{
			if(minutes == 0) 
			{
	            GetPlayerName(userID, szPlayerName, MAX_PLAYER_NAME);

	            format(szMessage, sizeof(szMessage), "Release: %s has been released from prison by %s, reason: %s", szPlayerName, playerVariables[playerid][pAdminName], reason);
	            SendClientMessageToAll(COLOR_LIGHTRED, szMessage);

	            playerVariables[userID][pPrisonID] = 0;
	            playerVariables[userID][pPrisonTime] = 0;

	            SendClientMessage(userID, COLOR_WHITE, "Your time is up! You have been released from jail/prison.");
				SetPlayerPos(userID, 738.9963, -1417.2211, 13.5234);
				SetPlayerInterior(userID, 0);
				SetPlayerVirtualWorld(userID, 0);
			}

			if(playerVariables[playerid][pAdminLevel] >= playerVariables[userID][pAdminLevel])
			{
				GetPlayerName(userID, szPlayerName, MAX_PLAYER_NAME);
			    format(szMessage, sizeof(szMessage), "Jail: %s has been jailed by %s, reason: %s (%d minutes).", szPlayerName, playerVariables[playerid][pAdminName], reason, minutes);
				SendClientMessageToAll(COLOR_LIGHTRED, szMessage);

				playerVariables[userID][pPrisonTime] = minutes * 60;
				playerVariables[userID][pPrisonID] = 2;

				SetPlayerPos(userID, 264.58, 77.38, 1001.04);
				SetPlayerInterior(userID, 6);
				SetPlayerVirtualWorld(userID, 0);
			}
			else 
			{
				SendClientMessage(playerid, COLOR_GREY, "You can't jail a higher level administrator.");
			}
		}
	}
	return 1;
}

CMD:release(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 2) {
        new
            reason[64],
            targetid;

        if(sscanf(params, "us[64]", targetid, reason))
		{
            SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/release [playerid] [reason]");
        }
		else if(playerVariables[targetid][pStatus] != 1)
        {
			SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
		}
		else
		{
            GetPlayerName(targetid, szPlayerName, MAX_PLAYER_NAME);

            format(szMessage, sizeof(szMessage), "Release: %s has been released from prison by %s, reason: %s", szPlayerName, playerVariables[playerid][pAdminName], reason);
            SendClientMessageToAll(COLOR_LIGHTRED, szMessage);

            playerVariables[targetid][pPrisonID] = 0;
            playerVariables[targetid][pPrisonTime] = 0;

            SendClientMessage(targetid, COLOR_WHITE, "Your time is up! You have been released from jail/prison.");
			SetPlayerPos(targetid, 738.9963, -1417.2211, 13.5234);
			SetPlayerInterior(targetid, 0);
			SetPlayerVirtualWorld(targetid, 0);

			return 1;
		}
	}
	return 1;
}

CMD:prison(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 2) {
        new
            minutes,
            userID,
            reason[64];

        if(sscanf(params, "uds[64]", userID, minutes, reason)) {
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/prison [playerid] [minutes] [reason]");
		}
		else {
			if(!IsPlayerConnected(userID)) return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
			
			if(minutes == 0) {
	            GetPlayerName(userID, szPlayerName, MAX_PLAYER_NAME);

	            format(szMessage, sizeof(szMessage), "Release: %s has been released from prison by %s, reason: %s", szPlayerName, playerVariables[playerid][pAdminName], reason);
	            SendClientMessageToAll(COLOR_LIGHTRED, szMessage);

	            playerVariables[userID][pPrisonID] = 0;
	            playerVariables[userID][pPrisonTime] = 0;

	            SendClientMessage(userID, COLOR_WHITE, "Your time is up! You have been released from jail/prison.");
				SetPlayerPos(userID, 738.9963, -1417.2211, 13.5234);
				SetPlayerInterior(userID, 0);
				SetPlayerVirtualWorld(userID, 0);
			}
			
			if(playerVariables[playerid][pAdminLevel] >= playerVariables[userID][pAdminLevel]) {
				GetPlayerName(userID, szPlayerName, MAX_PLAYER_NAME);
			    format(szMessage, sizeof(szMessage), "Prison: %s has been prisoned by %s, reason: %s (%d minutes).", szPlayerName, playerVariables[playerid][pAdminName], reason, minutes);
				SendClientMessageToAll(COLOR_LIGHTRED, szMessage);

				playerVariables[userID][pPrisonTime] = minutes*60;
				playerVariables[userID][pPrisonID] = 1;

				SetPlayerPos(userID, -26.8721, 2320.9290, 24.3034);
				SetPlayerInterior(userID, 0);
				SetPlayerVirtualWorld(userID, 0);
			}
			else {
				return SendClientMessage(playerid, COLOR_GREY, "You can't prison a higher level administrator.");
			}
		}
	}
	return 1;
}

CMD:lockbusiness(playerid, params[]) {
	if(getPlayerBusinessID(playerid) >= 1) {
	    new
	        x = getPlayerBusinessID(playerid);

	    switch(businessVariables[x][bLocked]) {
			case 0: {
				format(result, sizeof(result), "%s\n(Business %d - owned by %s)\n\n(locked)", businessVariables[x][bName], x, businessVariables[x][bOwner]);

				businessVariables[x][bLocked] = 1;
				SendClientMessage(playerid, COLOR_WHITE, "Business locked.");
			}
			case 1: {
				format(result, sizeof(result), "%s\n(Business %d - owned by %s)\n\nPress ~k~~PED_DUCK~ to enter", businessVariables[x][bName], x, businessVariables[x][bOwner]);

			    businessVariables[x][bLocked] = 0;
			    SendClientMessage(playerid, COLOR_WHITE, "Business unlocked.");
			}
		}
		UpdateDynamic3DTextLabelText(businessVariables[x][bLabelID], COLOR_YELLOW, result);
	}

	return 1;
}

CMD:number(playerid, params[]) {
	if(playerVariables[playerid][pPhoneBook] >= 1) {
	    new
	        userID;

		if(sscanf(params, "u", userID)) {
		    return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/number [playerid]");
		}
		else {
		    if(!IsPlayerConnected(userID)) {
		        return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
		    }
		    else {
				GetPlayerName(userID, szPlayerName, MAX_PLAYER_NAME);

				if(playerVariables[userID][pPhoneNumber] == -1) {
				    format(szMessage, sizeof(szMessage), "Name: "EMBED_GREY"%s{FFFFFF} | Number: "EMBED_GREY"None", szPlayerName);
				    SendClientMessage(playerid, COLOR_WHITE, szMessage);
				}
				else {
					format(szMessage, sizeof(szMessage), "Name: "EMBED_GREY"%s{FFFFFF} | Number: "EMBED_GREY"%d", szPlayerName, playerVariables[userID][pPhoneNumber]);
					SendClientMessage(playerid, COLOR_WHITE, szMessage);
				}
			}
		}
	}
	else SendClientMessage(playerid, COLOR_GREY, "You don't have a phonebook.");
	return 1;
}

CMD:slap(playerid,params[])
{
	if(playerVariables[playerid][pAdminLevel] >= 1) 
	{
	    new
	        userID;

		if(sscanf(params, "u", userID))
			SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/slap [playerid]");
		else if(playerVariables[userID][pStatus] != 1)
			SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
	    else if(playerVariables[playerid][pAdminLevel] >= playerVariables[userID][pAdminLevel]) 
		{
            new
                string[64],

                Float: playerHealth,
                Float: fPos[3];

            GetPlayerName(userID, szPlayerName, MAX_PLAYER_NAME);

			GetPlayerPos(userID, fPos[0], fPos[1], fPos[2]);
			PlayerPlaySoundEx(1190, fPos[0], fPos[1], fPos[2]);
			SetPlayerPos(userID, fPos[0], fPos[1], fPos[2]+5);

			GetPlayerHealth(userID, playerHealth);
	    	SetPlayerHealth(userID, playerHealth-5);

		    format(string, sizeof(string), "You have slapped %s.", szPlayerName);
		    SendClientMessage(playerid, COLOR_WHITE, string);
		}
	}
	return 1;
}

CMD:help(playerid, params[]) {
	return showHelp(playerid);
}

CMD:check(playerid,params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 1) {

	    new
	        targetid;

		if(sscanf(params, "u", targetid))
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/check [playerid]");

		if(playerVariables[targetid][pStatus] != 1)
			return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");

		if(playerVariables[playerid][pAdminLevel] < playerVariables[targetid][pAdminLevel])
			return SendClientMessage(playerid, COLOR_GREY, "You can't check a higher level administrator.");

		showStats(playerid, targetid);
	}
	return 1;
}

CMD:statistics(playerid, params[]) {
	return showStats(playerid,playerid);
}

CMD:gtype(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 4) {
	    new
	        groupID,
	        groupType;

        if(sscanf(params, "dd", groupID, groupType))
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/gtype [groupid] [grouptypeid]");

		if(groupID > 0 && groupID < MAX_GROUPS) {
            format(szMessage, sizeof(szMessage), "You have set group %s's group type to %d.", groupVariables[groupID][gGroupName], groupType);
            SendClientMessage(playerid, COLOR_WHITE, szMessage);

            groupVariables[groupID][gGroupType] = groupType;
  		} else return SendClientMessage(playerid, COLOR_GREY, "Invalid Group ID!");
	}
	return 1;
}

CMD:quitgroup(playerid, params[]) {
	if(playerVariables[playerid][pGroup] != 0) {
		format(szMessage, sizeof(szMessage), "%s has left the group (quit).", szPlayerName);
	   	SendToGroup(playerVariables[playerid][pGroup], COLOR_GENANNOUNCE, szMessage);
	   	format(szMessage,sizeof(szMessage), "You have left the %s.",groupVariables[playerVariables[playerid][pGroup]][gGroupName]);
	   	SendClientMessage(playerid,COLOR_WHITE,szMessage);
	   	playerVariables[playerid][pGroup] = 0;
	   	playerVariables[playerid][pGroupRank] = 0;
   	}
   	else return SendClientMessage(playerid, COLOR_WHITE, "You don't have a group to quit.");
	return 1;
}

CMD:veh(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 3) {
        if(!isnull(params)) {

			new
				carid = strval(params),
				Float: carSpawnPos[4], // 3 for the usual dimensions, +1 for the rotation/angle.
				messageString[64];

			if(carid < 400 || carid > 611)
				return SendClientMessage(playerid, COLOR_WHITE, "Valid car IDs start at 400, and end at 611.");

			if(systemVariables[vehicleCounts][0] + systemVariables[vehicleCounts][1] + systemVariables[vehicleCounts][2] < MAX_VEHICLES) {
				GetPlayerPos(playerid, carSpawnPos[0], carSpawnPos[1], carSpawnPos[2]);
				GetPlayerFacingAngle(playerid, carSpawnPos[3]);

				AdminSpawnedVehicles[vehCount] = CreateVehicle(carid, carSpawnPos[0], carSpawnPos[1], carSpawnPos[2], carSpawnPos[3], -1, -1, -1);
				systemVariables[vehicleCounts][2]++;

				LinkVehicleToInterior(AdminSpawnedVehicles[vehCount], GetPlayerInterior(playerid));
				SetVehicleVirtualWorld(AdminSpawnedVehicles[vehCount], GetPlayerVirtualWorld(playerid));

				PutPlayerInVehicle(playerid, AdminSpawnedVehicles[vehCount], 0);

				switch(carid) {
					case 427, 428, 432, 601, 528: SetVehicleHealth(AdminSpawnedVehicles[vehCount], 5000.0);
				}

				format(messageString, sizeof(messageString), "You have spawned a %s (vehicle ID %d).", VehicleNames[carid - 400], AdminSpawnedVehicles[vehCount]);
				SendClientMessage(playerid, COLOR_WHITE, messageString);

				vehCount++;
			}
			else {
				SendClientMessage(playerid, COLOR_GREY, "(error) 01x08");
				printf("ERROR: Vehicle limit reached (MODEL %d, MAXIMUM %d, TYPE ADMIN) [01x08]", carid, MAX_VEHICLES);
			}
        }
        else {
            return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/veh [vehicleid]");
        }
    }
	return 1;
}

CMD:despawnavehicles(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 3) {
        new
			x;

        for(new i = 0; i < MAX_VEHICLES; i++) {
			if(AdminSpawnedVehicles[i] >= 1) {
			    DestroyVehicle(AdminSpawnedVehicles[i]);
			    AdminSpawnedVehicles[i] = 0;
			    x++;
				systemVariables[vehicleCounts][2]--;
			}
		}

		format(szMessage, sizeof(szMessage), "%d admin-spawned vehicles have been automatically destroyed.", x);
		SendClientMessage(playerid, COLOR_WHITE, szMessage);
    }
	return 1;
}

CMD:vdespawn(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 3) {

        for(new i = 0; i < MAX_VEHICLES; i++) {
			if(AdminSpawnedVehicles[i] == GetPlayerVehicleID(playerid)) {
				format(szMessage, sizeof(szMessage), "You have successfully despawned vehicle %d.", AdminSpawnedVehicles[i]);
				DestroyVehicle(AdminSpawnedVehicles[i]);
				AdminSpawnedVehicles[i] = 0;
				systemVariables[vehicleCounts][2]--;
				SendClientMessage(playerid, COLOR_WHITE, szMessage);
				return 1;
			}
		}
		SendClientMessage(playerid, COLOR_WHITE, "You are not in an admin spawned vehicle.");
    }
	return 1;
}

CMD:serverstats(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 1) {

	    new
			statString[128];

		SendClientMessage(playerid, COLOR_TEAL, "----------------------------------------------------------------------------");
        SendClientMessage(playerid, COLOR_WHITE, "System variables (current):");
        format(statString, sizeof(statString), "Objects: %d | Pickups: %d | 3D Text Labels: %d | Static vehicles: %d | Player vehicles: %d | Admin vehicles: %d", CountDynamicObjects(), CountDynamicPickups(), CountDynamic3DTextLabels(), systemVariables[vehicleCounts][0], systemVariables[vehicleCounts][1], systemVariables[vehicleCounts][2]);
		SendClientMessage(playerid, COLOR_WHITE, statString);
        format(statString, sizeof(statString), "Houses: %d | Businesses: %d | Total vehicle count: %d/%d | Weather: %d | Pending weather change: %d/%d", systemVariables[houseCount], systemVariables[businessCount], systemVariables[vehicleCounts][0] + systemVariables[vehicleCounts][1] + systemVariables[vehicleCounts][2], MAX_VEHICLES, weatherVariables[0], weatherVariables[1], MAX_WEATHER_POINTS);
		SendClientMessage(playerid, COLOR_WHITE, statString);
		SendClientMessage(playerid, COLOR_TEAL, "----------------------------------------------------------------------------");
	}
	return 1;
}

CMD:accent(playerid, params[]) {
	if(playerVariables[playerid][pStatus] >= 1) {
        if(!isnull(params)) {
            if(strlen(params) >= 19) {
                SendClientMessage(playerid, COLOR_GREY, "Invalid accent length. Accents can only consist of 1-19 characters.");
            }
            else {
				mysql_real_escape_string(params, playerVariables[playerid][pAccent]);

				format(szMessage, sizeof(szMessage), "You are now speaking in a '%s' accent.", params);
				SendClientMessage(playerid, COLOR_WHITE, szMessage);
			}
        }
        else {
            return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/accent [accent] ('none' to disable)");
        }
	}

	return 1;
}

CMD:warn(playerid, params[]) 
{
    if(playerVariables[playerid][pAdminLevel] != 1) 
	{
	    new
	        playerWarnID,
	        playerWarnReason[32];

	    if(sscanf(params, "us[32]", playerWarnID, playerWarnReason)) {
	        SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/warn [playerid] [reason (length is 32 characters maximum)]]");
	    }
	    else {
	        if(!IsPlayerAuthed(playerWarnID)) return SendClientMessage(playerid, COLOR_GREY, "The specified player is not connected, or has not authenticated.");

	        if(playerVariables[playerWarnID][pAdminLevel] >= playerVariables[playerid][pAdminLevel])
				return SendClientMessage(playerid, COLOR_GREY, "You can't warn a higher (or equal) level administrator.");

	        if(!strcmp(playerVariables[playerWarnID][pWarning1], "(null)", true)) {
	            new

	                messageString[128];

	            mysql_real_escape_string(playerWarnReason, playerVariables[playerWarnID][pWarning1]);

	            GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

	            format(messageString, sizeof(messageString), "You have been warned by Administrator %s, reason: %s. This is your first warning.", szPlayerName, playerWarnReason);
	            SendClientMessage(playerWarnID, COLOR_LIGHTRED, messageString);

	            GetPlayerName(playerWarnID, szPlayerName, MAX_PLAYER_NAME);

	            format(messageString, sizeof(messageString), "You have warned %s (for %s). This is their first warning.", szPlayerName, playerWarnReason);
	            SendClientMessage(playerWarnID, COLOR_LIGHTRED, messageString);
	        }
	        else if(!strcmp(playerVariables[playerWarnID][pWarning2], "(null)", true)) {
	            new

	                messageString[128];

	            mysql_real_escape_string(playerWarnReason, playerVariables[playerWarnID][pWarning2]);

	            GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

	            format(messageString, sizeof(messageString), "You have been warned by Administrator %s, reason: %s. This is your second warning.", szPlayerName, playerWarnReason);
	            SendClientMessage(playerWarnID, COLOR_LIGHTRED, messageString);

	            GetPlayerName(playerWarnID, szPlayerName, MAX_PLAYER_NAME);

	            format(messageString, sizeof(messageString), "You have warned %s (for %s). This is their second warning.", szPlayerName, playerWarnReason);
	            SendClientMessage(playerWarnID, COLOR_LIGHTRED, messageString);
	        }
	        else {
	            new

	                messageString[128];

	            mysql_real_escape_string(playerWarnReason, playerVariables[playerWarnID][pWarning3]);

	            GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

	            format(messageString, sizeof(messageString), "You have been warned by Administrator %s, reason: %s. This is your third warning.", szPlayerName, playerWarnReason);
	            SendClientMessage(playerWarnID, COLOR_LIGHTRED, messageString);

	            GetPlayerName(playerWarnID, szPlayerName, MAX_PLAYER_NAME);

	            format(messageString, sizeof(messageString), "You have warned %s (for %s). This is their third warning.", szPlayerName, playerWarnReason);
	            SendClientMessage(playerWarnID, COLOR_LIGHTRED, messageString);

	            GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

	            format(messageString, 42, "Third warning (last from %s)", szPlayerName);
	            scriptBan(playerWarnID, messageString);
	        }
	    }
	}
	return 1;
}

CMD:stats(playerid, params[]) {
	return cmd_statistics(playerid, params);
}

CMD:setweather(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 3) {
		if(!isnull(params)) {

			new
				weatherID = strval(params);

			if(weatherID >= 1 && weatherID <= 45) {

				weatherVariables[0] = weatherID;
				foreach(Player, i) {
					if(!GetPlayerInterior(i)) {
						SetPlayerWeather(i, weatherVariables[0]);
					}
				}
			}
			else SendClientMessage(playerid, COLOR_GREY, "Invalid weather ID specified (must be between 1 and 45).");
		}
		else SendClientMessage(playerid, COLOR_GREY, "No weather ID specified.");
	}
	return 1;
}

CMD:forcelogout(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 2) {
		new
	        playerLID;

	    if(sscanf(params, "u", playerLID))
	        return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/forcelogout [playerid]");

		if(playerVariables[playerid][pAdminLevel] < playerVariables[playerLID][pAdminLevel])
			return SendClientMessage(playerid, COLOR_GREY, "You can't force a higher level administrator to log out.");

		if(playerLID == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
			
		if(playerVariables[playerLID][pAdminDuty] != 0)
		    return SendClientMessage(playerid, COLOR_GREY, "You can't be on admin duty to do this.");

		GetPlayerName(playerLID, szPlayerName, MAX_PLAYER_NAME);
		format(szMessage, sizeof(szMessage), "You have forced %s to logout.", szPlayerName);
		SendClientMessage(playerid, COLOR_WHITE, szMessage);

	    savePlayerData(playerLID);
	    playerVariables[playerLID][pStatus] = 0;
	    
		if(playerVariables[playerLID][pCarModel] >= 1)
			DestroyVehicle(playerVariables[playerLID][pCarID]);
			
	    SendClientMessage(playerLID, COLOR_GREY, "You have been forced to logout by an administrator, for being deemed as away.");
	    ShowPlayerDialog(playerLID, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "SERVER: Login", "Welcome to the "SERVER_NAME" Server.\n\nPlease enter your password below!", "Login", "Cancel");
	}
	return 1;
}

CMD:ban(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 1) {
	    new
	        playerBanID,
	        playerBanReason[60];

	    if(sscanf(params, "us[60]", playerBanID, playerBanReason))
	    	return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/ban [playerid] [reason]");

		if(playerVariables[playerBanID][pAdminLevel] >= playerVariables[playerid][pAdminLevel])
			return SendClientMessage(playerid, COLOR_GREY, "You can't ban a higher (or equal) level administrator.");

        if(playerBanID == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");

		new

            playerIP[32],
            playerNameBanned[MAX_PLAYER_NAME],
            aString[384]; // Due to the fact that we'll be dealing with a large query after the ban announcement...

		GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
		GetPlayerName(playerBanID, playerNameBanned, MAX_PLAYER_NAME);

		GetPlayerIp(playerBanID, playerIP, sizeof(playerIP));

		playerVariables[playerBanID][pBanned] = 1;

       	format(aString, sizeof(aString), "Ban: %s has been banned by %s, reason: %s", playerNameBanned, playerVariables[playerid][pAdminName], playerBanReason);
       	SendClientMessageToAll(COLOR_LIGHTRED, aString);
       	mysql_real_escape_string(aString, aString);
       	adminLog(aString);

       	mysql_real_escape_string(szPlayerName, szPlayerName);
       	mysql_real_escape_string(playerNameBanned, playerNameBanned);

       	format(aString, sizeof(aString), "INSERT INTO bans (playerNameBanned, playerBannedBy, playerBanReason, IPBanned) VALUES('%s', '%s', '%s', '%s')", playerNameBanned, szPlayerName, playerBanReason, playerIP);
		mysql_query(aString, THREAD_BAN_PLAYER, playerBanID);
	}
	return 1;
}

CMD:kick(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 1) {
	    new
	        playerKickID,
	        playerKickReason[60];

	    if(sscanf(params, "us[60]", playerKickID, playerKickReason))
	        return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/kick [playerid] [reason]");

		if(playerVariables[playerKickID][pAdminLevel] >= playerVariables[playerid][pAdminLevel])
			return SendClientMessage(playerid, COLOR_GREY, "You can't kick a higher (or equal) level administrator.");

	    if(playerKickID == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");

  		new

            playerNameKicked[MAX_PLAYER_NAME],
            aString[128];

		GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
		GetPlayerName(playerKickID, playerNameKicked, MAX_PLAYER_NAME);

       	format(aString, sizeof(aString), "Kick: %s has been kicked by %s, reason: %s", playerNameKicked, playerVariables[playerid][pAdminName], playerKickReason);
       	SendClientMessageToAll(COLOR_LIGHTRED, aString);
       	mysql_real_escape_string(aString, aString);
       	adminLog(aString);

       	Kick(playerKickID);
	}
	return 1;
}

CMD:fine(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 2) {

	    new
	        ID,
			amount,
	        reason[60];

	    if(sscanf(params, "uds[60]", ID, amount, reason))
	        return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/fine [playerid] [amount] [reason]");

	    if(playerVariables[ID][pAdminLevel] >= playerVariables[playerid][pAdminLevel])
			return SendClientMessage(playerid, COLOR_GREY, "You can't fine a higher (or equal) level administrator.");

        if(ID == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");

		if(amount <= 0)
			return SendClientMessage(playerid, COLOR_GREY, "Invalid amount specified.");

       	new
       	    playerFined[MAX_PLAYER_NAME],
       	    string[128];

		GetPlayerName(ID, playerFined, MAX_PLAYER_NAME);

       	format(string, sizeof(string), "Fine: %s has been fined $%d by %s, reason: %s", playerFined, amount, playerVariables[playerid][pAdminName], reason);
       	SendClientMessageToAll(COLOR_LIGHTRED, string);
       	mysql_real_escape_string(string, string);
       	adminLog(string);

		playerVariables[ID][pMoney] -= amount;
	}
	return 1;
}

CMD:mute(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 2) {

	    new
	        ID;

	    if(sscanf(params, "u", ID))
	        return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/mute [playerid]");

        if(playerVariables[ID][pAdminLevel] > 0)
			return SendClientMessage(playerid, COLOR_GREY, "You can't mute an administrator.");

        if(ID == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");

  		new

            string[55];

		switch(playerVariables[ID][pMuted]) {
			case 0: {
				format(string, sizeof(string), "Administrator %s has muted you.", playerVariables[playerid][pAdminName]);
				SendClientMessage(ID, COLOR_WHITE, string);

				GetPlayerName(ID, szPlayerName, MAX_PLAYER_NAME);
				format(string, sizeof(string), "You have muted %s.", szPlayerName);
				SendClientMessage(playerid, COLOR_WHITE, string);

				playerVariables[ID][pMuted] = -1;
			}
			default: {
				format(string, sizeof(string), "Administrator %s has unmuted you.", playerVariables[playerid][pAdminName]);
				SendClientMessage(ID, COLOR_WHITE, string);

				GetPlayerName(ID, szPlayerName, MAX_PLAYER_NAME);
				format(string, sizeof(string), "You have unmuted %s.", szPlayerName);
				SendClientMessage(playerid, COLOR_WHITE, string);

				playerVariables[ID][pMuted] = 0;
			}
		}
	}
	return 1;
}

CMD:omute(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 2) {

	    new
	        ID;

	    if(sscanf(params, "u", ID))
	        return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/omute [playerid]");

        if(playerVariables[ID][pAdminLevel] > 0)
			return SendClientMessage(playerid, COLOR_GREY, "You can't mute an administrator.");

        if(ID == INVALID_PLAYER_ID)
			return SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");

       	new

       	    string[88];

		switch(playerVariables[ID][pOOCMuted]) {
			case 0: {
				format(string, sizeof(string), "Administrator %s has muted you from speaking in global OOC chat.", playerVariables[playerid][pAdminName]);
				SendClientMessage(ID, COLOR_WHITE, string);

				GetPlayerName(ID, szPlayerName, MAX_PLAYER_NAME);
				format(string, sizeof(string), "You have muted %s from speaking in global OOC chat.", szPlayerName);
				SendClientMessage(playerid, COLOR_WHITE, string);

				playerVariables[ID][pOOCMuted] = 1;
			}
			default: {
				format(string, sizeof(string), "Administrator %s has unmuted you from global OOC chat.", playerVariables[playerid][pAdminName]);
				SendClientMessage(ID, COLOR_WHITE, string);

				GetPlayerName(ID, szPlayerName, MAX_PLAYER_NAME);
				format(string, sizeof(string), "You have unmuted %s from the global OOC chat.", szPlayerName);
				SendClientMessage(playerid, COLOR_WHITE, string);

				playerVariables[ID][pOOCMuted] = 0;
			}
		}
	}
	return 1;
}

CMD:eventproperties(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 3) {

		new
			stringSplitter[8]; // Split the parameters here first (in case sscanf returns 1) so it isn't passed straight to the event vars.

		if(sscanf(params, "dddddddd", stringSplitter[0], stringSplitter[1], stringSplitter[2], stringSplitter[3], stringSplitter[4], stringSplitter[5], stringSplitter[6], stringSplitter[7]))
			return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/eventproperties [health] [armour] [skin] [weapon 1] [weapon 2] [weapon 3] [weapon 4] [weapon 5]");

		if(IsValidSkin(stringSplitter[3])) {

			// Set the parameters from the command
			eventVariables[eArmourHP][0] = stringSplitter[0];
			eventVariables[eArmourHP][1] = stringSplitter[1];
			eventVariables[eEventSkin] = stringSplitter[2];

			eventVariables[eEventWeapons][0] = stringSplitter[3];
			eventVariables[eEventWeapons][1] = stringSplitter[4];
			eventVariables[eEventWeapons][2] = stringSplitter[5];
			eventVariables[eEventWeapons][3] = stringSplitter[6];
			eventVariables[eEventWeapons][4] = stringSplitter[7];

			eventVariables[eEventVW] = GetPlayerVirtualWorld(playerid);
			eventVariables[eEventInt] = GetPlayerInterior(playerid);

			GetPlayerPos(playerid, eventVariables[eEventPos][0], eventVariables[eEventPos][1], eventVariables[eEventPos][2]);

			SendClientMessage(playerid, COLOR_WHITE, "The event properties have successfully been set - you may now /startevent, or change the properties again.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "Invalid skin specified.");
	}
	return 1;
}

CMD:startevent(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 3) {

		new
			string[93];

		if(eventVariables[eEventSkin] == 0)
			return SendClientMessage(playerid, COLOR_GREY, "No event properties have been set.");

		switch(eventVariables[eEventStat]) {
			case 0: {
				format(string, sizeof(string), "Administrator %s has set up an event - type /joinevent to participate!", playerVariables[playerid][pAdminName]);
				SendClientMessageToAll(COLOR_LIGHTRED, string);

				eventVariables[eEventStat] = 1;
			}
			case 1: {
				format(string, sizeof(string), "Administrator %s has started the event. Best of luck playing!", playerVariables[playerid][pAdminName]);
				SendClientMessageToAll(COLOR_LIGHTRED, string);

				foreach(Player, i) {
					if(playerVariables[i][pStatus] == 1 && playerVariables[i][pEvent] == 1) { // Authenticated & joined

						for(new x; x < 5; x++) {
							if(eventVariables[eEventWeapons][x] >= 1 && eventVariables[eEventWeapons][x] <= 46) {
								GivePlayerWeapon(i, eventVariables[eEventWeapons][x], 999999);
							}
						}
						TogglePlayerControllable(i, true);
						SendClientMessage(i, COLOR_WHITE, "Good luck! Everyone will be refunded, so have fun and play fair.");
					}
				}
				eventVariables[eEventStat] = 2;
			}
			default: SendClientMessage(playerid, COLOR_GREY, "An event is already in progress - use /endevent to close it.");
		}
	}
	return 1;
}

CMD:endevent(playerid, params[]) {
	if(playerVariables[playerid][pAdminLevel] >= 3) {

		new
			string[128];

		switch(eventVariables[eEventStat]) {
			case 0: SendClientMessage(playerid, COLOR_GREY, "There is currently no active event to close.");
			default: {
				foreach(Player, i) {
					if(playerVariables[playerid][pEvent] == 1) {

						TogglePlayerControllable(i, true);

						ResetPlayerWeapons(i);
						givePlayerWeapons(i);

						SetPlayerPos(i, playerVariables[i][pPos][0], playerVariables[i][pPos][1], playerVariables[i][pPos][2]);
						SetPlayerInterior(i, playerVariables[i][pInterior]);
						SetPlayerVirtualWorld(i, playerVariables[i][pVirtualWorld]);
						SetPlayerSkin(i, playerVariables[i][pSkin]);
						SetCameraBehindPlayer(i);

						if(playerVariables[i][pAdminDuty] == 1) {
							SetPlayerHealth(i, 500000.0);
							SetPlayerArmour(i, 0.0);
						}
						else {
							SetPlayerHealth(i, playerVariables[i][pHealth]);
							SetPlayerArmour(i, playerVariables[i][pArmour]);
						}

						playerVariables[i][pEvent] = 0;

					}
				}
				format(string, sizeof(string), "Administrator %s has closed the event.", playerVariables[playerid][pAdminName]);
				SendClientMessageToAll(COLOR_LIGHTRED, string);
				eventVariables[eEventStat] = 0;
				eventVariables[eEventCount] = 0;

				eventVariables[eEventSkin] = 0;
			}
		}
    }
    return 1;
}

CMD:joinevent(playerid, params[]) {
	switch(eventVariables[eEventStat]) {
		case 1: {
			if(playerVariables[playerid][pEvent] == 0) {
				switch(GetPlayerState(playerid)) {
					case 1, 2, 3: {
						foreach(Player, x) {
							if(playerVariables[x][pDrag] == playerid) {
								return SendClientMessage(playerid, COLOR_GREY, "You can't participate in an event while dragging someone - stop dragging them first.");
							}
						}
						if(playerVariables[playerid][pSpectating] != INVALID_PLAYER_ID) {
							return SendClientMessage(playerid, COLOR_GREY, "You can't join an event while spectating - finish your spectating session first.");
						}
						else if(playerVariables[playerid][pFreezeType] == 0 && playerVariables[playerid][pPrisonID] == 0 && playerVariables[playerid][pDrag] == -1) {
							if(playerVariables[playerid][pAdminDuty] == 0) { // If they're on aduty, GetPlayerHealth returns crap like 32.2 HP.
								GetPlayerHealth(playerid, playerVariables[playerid][pHealth]);
								GetPlayerArmour(playerid, playerVariables[playerid][pArmour]);
							}

							GetPlayerPos(playerid, playerVariables[playerid][pPos][0], playerVariables[playerid][pPos][1], playerVariables[playerid][pPos][2]);
							playerVariables[playerid][pInterior] = GetPlayerInterior(playerid);
							playerVariables[playerid][pVirtualWorld] = GetPlayerVirtualWorld(playerid);

							TogglePlayerControllable(playerid, false);
							playerVariables[playerid][pEvent] = 1;

							ResetPlayerWeapons(playerid);

							SetPlayerPos(playerid, eventVariables[eEventPos][0], eventVariables[eEventPos][1], eventVariables[eEventPos][2]);
							SetPlayerInterior(playerid, eventVariables[eEventInt]);
							SetPlayerVirtualWorld(playerid, eventVariables[eEventVW]);
							SetPlayerSkin(playerid, eventVariables[eEventSkin]);
							SetPlayerHealth(playerid, eventVariables[eArmourHP][0]);
							SetPlayerArmour(playerid, eventVariables[eArmourHP][1]);

							eventVariables[eEventCount]++;

							SendClientMessage(playerid, COLOR_WHITE, "You have joined the event - please wait patiently, it will be started shortly.");
						}
						else SendClientMessage(playerid, COLOR_GREY, "You can't participate in an event while frozen, jailed, prisoned, or while being dragged.");
					}
					default: SendClientMessage(playerid, COLOR_GREY, "You must spawn before joining an event.");
				}
			}
			else SendClientMessage(playerid, COLOR_GREY, "You are already participating in an event.");
		}
		case 2: SendClientMessage(playerid, COLOR_GREY, "The event has already started - you have missed it.");
		default: SendClientMessage(playerid, COLOR_GREY, "There is currently no active event to join.");
	}
	return 1;
}

CMD:savedata(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 5) {
        foreach(Player, x) {
			savePlayerData(x);
		}
		SendClientMessage(playerid, COLOR_YELLOW, "Player data saved.");

		for(new xh = 0; xh < MAX_HOUSES; xh++) {
            saveHouse(xh);
		}
		SendClientMessage(playerid, COLOR_YELLOW, "House data saved.");

		for(new xf = 0; xf < MAX_GROUPS; xf++) {
            saveGroup(xf);
		}
		SendClientMessage(playerid, COLOR_YELLOW, "Group data saved.");

		for(new xf = 0; xf < MAX_BUSINESSES; xf++) {
            saveBusiness(xf);
		}
		SendClientMessage(playerid, COLOR_YELLOW, "Business data saved.");

		for(new xf = 0; xf < MAX_ASSETS; xf++) {
            saveAsset(xf);
		}
		SendClientMessage(playerid, COLOR_YELLOW, "Server asset data saved.");
    }

    return 1;
}

CMD:gmx(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 5) {
		ShowPlayerDialog(playerid, DIALOG_GMX, DIALOG_STYLE_MSGBOX, "Server Restart", "Please confirm whether you are positive that you wish to initiate a server restart?", "Yes", "No");
    }
    return 1;
}

CMD:unbanip(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 3) {
		if(!isnull(params)) {
		    if(strlen(params) < 20) {
		        mysql_real_escape_string(params, szPlayerName);
				format(szQueryOutput, sizeof(szQueryOutput), "DELETE FROM bans WHERE IPBanned = '%s'", szPlayerName);
				mysql_query(szQueryOutput, THREAD_UNBAN_IP, playerid);
		    } else return SendClientMessage(playerid, COLOR_GREY, "Invalid IP length.");
		} else SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/unbanip [internet protocol address]");
	}
	return 1;
}

CMD:unban(playerid, params[]) {
    if(playerVariables[playerid][pAdminLevel] >= 3) {
		if(!isnull(params)) {
		    if(strlen(params) < MAX_PLAYER_NAME) {
				mysql_real_escape_string(params, szPlayerName);
				SetPVarString(playerid, "playerNameUnban", szPlayerName);
				format(szQueryOutput, sizeof(szQueryOutput), "SELECT * FROM `playeraccounts` WHERE `playerName` = '%s'", szPlayerName);
				mysql_query(szQueryOutput, THREAD_CHECK_PLAYER_NAME_BANNED, playerid);
			}
			else {
				SendClientMessage(playerid, COLOR_GREY, "Invalid name length specified (1-24).");
			}
		}
		else {
		    SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/unban [account name]");
		}
	}
	return 1;
}

CMD:buyhouse(playerid, params[]) {
    if(playerVariables[playerid][pStatus] >= 1) {
        for(new x = 0; x < MAX_HOUSES; x++) {
			if(IsPlayerInRangeOfPoint(playerid, 5, houseVariables[x][hHouseExteriorPos][0], houseVariables[x][hHouseExteriorPos][1], houseVariables[x][hHouseExteriorPos][2])) {
				if(!strcmp(houseVariables[x][hHouseOwner], "Nobody", true)) {
				    if(houseVariables[x][hHousePrice] == -1) return SendClientMessage(playerid, COLOR_GREY, "This house was blocked from being purchased by an administrator.");
					if(getPlayerHouseID(playerid) >= 1) return SendClientMessage(playerid, COLOR_GREY, "You can't own 2 houses.");
					if(playerVariables[playerid][pMoney] >= houseVariables[x][hHousePrice]) {
						playerVariables[playerid][pMoney] -= houseVariables[x][hHousePrice];

						new
						    labelString[96];

						strcpy(houseVariables[x][hHouseOwner], playerVariables[playerid][pNormalName], MAX_PLAYER_NAME);

						DestroyDynamicPickup(houseVariables[x][hPickupID]);
						DestroyDynamic3DTextLabel(houseVariables[x][hLabelID]);

					    if(houseVariables[x][hHouseLocked] == 1) {
					    	format(labelString, sizeof(labelString), "House %d (owned)\nOwner: %s\n\n(locked)", x, houseVariables[x][hHouseOwner]);
					    }
					    else {
					        format(labelString, sizeof(labelString), "House %d (owned)\nOwner: %s\n\nPress ~k~~PED_DUCK~ to enter.", x, houseVariables[x][hHouseOwner]);
					    }

					    houseVariables[x][hLabelID] = CreateDynamic3DTextLabel(labelString, COLOR_YELLOW, houseVariables[x][hHouseExteriorPos][0], houseVariables[x][hHouseExteriorPos][1], houseVariables[x][hHouseExteriorPos][2], 100, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
					    houseVariables[x][hPickupID] = CreateDynamicPickup(1272, 23, houseVariables[x][hHouseExteriorPos][0], houseVariables[x][hHouseExteriorPos][1], houseVariables[x][hHouseExteriorPos][2], 0, houseVariables[x][hHouseExteriorID], -1, 50);

						SendClientMessage(playerid, COLOR_WHITE, "Congratulations on your purchase - you are now the proud owner of this house!");

						saveHouse(x);
					}
					else SendClientMessage(playerid, COLOR_GREY, "You don't have enough money to purchase this house.");
				}
				else {
					return SendClientMessage(playerid, COLOR_GREY, "You can't purchase an owned house.");
				}
			}
		}
    }
	return 1;
}

CMD:pay(playerid, params[]) {
	new
		id,
		cash,
		string[128],
		ip1[32],
		ip2[32],
		giveplayerName[MAX_PLAYER_NAME];

	if(sscanf(params, "ud", id, cash))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/pay [playerid] [amount]");

	if(playerVariables[playerid][pMoney] >= cash) {
		if(id != playerid && IsPlayerAuthed(id)) {
			if(cash > 0 && ((playerVariables[playerid][pPlayingHours] < 10 && cash < 5000) || playerVariables[playerid][pPlayingHours] >= 10)) {
				if(playerVariables[playerid][pAdminDuty] != 0 && playerVariables[playerid][pAdminLevel] > 0 || (IsPlayerInRangeOfPlayer(playerid, id, 4.0) && playerVariables[id][pSpectating] == INVALID_PLAYER_ID)) {

					GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
					GetPlayerName(id, giveplayerName, MAX_PLAYER_NAME);

					playerVariables[playerid][pMoney] -= cash;
					playerVariables[id][pMoney] += cash;

					PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					PlayerPlaySound(id, 1052, 0.0, 0.0, 0.0);

					format(string, sizeof(string), "You have paid $%d to %s.", cash, giveplayerName);
					SendClientMessage(playerid, COLOR_WHITE, string);

					format(string, sizeof(string), "* %s takes out $%d in cash, and hands it to %s.", szPlayerName, cash, giveplayerName);
					nearByMessage(playerid, COLOR_PURPLE, string);

					GetPlayerIp(playerid, ip1, 32);
					GetPlayerIp(id, ip2, 32);

					format(string, sizeof(string), "%s has paid you $%d.", szPlayerName, cash);
					SendClientMessage(id, COLOR_WHITE, string);

					if(playerVariables[playerid][pSpamCount] >= 3)
					{
						if(!strcmp(ip1, ip2,true))
						{
							format(string, sizeof(string), "Warning: {FFFFFF}%s has attempted to repeatedly pay $%d to %s (sharing IP address %s).", szPlayerName, cash, giveplayerName, ip1);
							submitToAdmins(string, COLOR_HOTORANGE);
						}
						else if(playerVariables[playerid][pPlayingHours] < 2) {
							format(string, sizeof(string), "Warning: {FFFFFF}%s has attempted to repeatedly pay $%d to %s (with less than two playing hours).", szPlayerName, cash, giveplayerName);
							submitToAdmins(string, COLOR_HOTORANGE);
						}
					}
				}
				else SendClientMessage(playerid, COLOR_GREY, "You're too far away from this person.");
			}
			else SendClientMessage(playerid, COLOR_GREY, "Invalid amount specified (too high, or too low).");
		}
		else SendClientMessage(playerid, COLOR_GREY, "Invalid player specified (either yourself, or not connected).");
	}
	return 1;
}

CMD:getjob(playerid, params[]) {
    if(playerVariables[playerid][pStatus] >= 1) {
		new string[72];
		if(playerVariables[playerid][pJob] < 1) {
			for(new h = 0; h < sizeof(jobVariables); h++) {
			    if(IsPlayerInRangeOfPoint(playerid, 5, jobVariables[h][jJobPosition][0], jobVariables[h][jJobPosition][1], jobVariables[h][jJobPosition][2])) {
			        format(string, sizeof(string), "Congratulations. You have now become a %s.", jobVariables[h][jJobName]);
			        SendClientMessage(playerid, COLOR_WHITE, string);
			        playerVariables[playerid][pJob] = h;
				}
			}
		}
		else {
		    SendClientMessage(playerid, COLOR_WHITE, "You already have a job (type /quitjob first).");
		}
	}
	return 1;
}

CMD:quitjob(playerid, params[]) {
    if(playerVariables[playerid][pStatus] >= 1) {
		new string[128];
		if(playerVariables[playerid][pJob] >= 1) {
		    format(string, sizeof(string), "You have quit your job (%s).", jobVariables[playerVariables[playerid][pJob]][jJobName]);
		    SendClientMessage(playerid, COLOR_WHITE, string);
		    playerVariables[playerid][pJob] = 0;
			playerVariables[playerid][pJobDelay] = 0;
		}
	}
	return 1;
}

CMD:mobile(playerid, params[]) {
    if(playerVariables[playerid][pPhoneNumber] == -1)
        return SendClientMessage(playerid, COLOR_GREY, "You do not have a mobile phone.");

    if(playerVariables[playerid][pPhoneStatus] != 1)
        return SendClientMessage(playerid, COLOR_GREY, "Your phone is not switched on.");

	ShowPlayerDialog(playerid, DIALOG_PHONE_MENU, DIALOG_STYLE_LIST, "Mobile Phone: Menu", "History\nContacts\nWidgets\nOrganiser\nMessaging\nApplications\nSettings", "Select", "Cancel");
	return 1;
}

CMD:sms(playerid, params[]) {
	new
	    number,
	    szQuery[256],
	    szClearMsg[94],
	    count,
	    message[94];

    if(sscanf(params, "ds[94]", number, message))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/sms [number] [message]");

    if(number == -1)
		return SendClientMessage(playerid, COLOR_GREY, "Invalid number.");

    if(playerVariables[playerid][pPhoneStatus] != 1)
        return SendClientMessage(playerid, COLOR_GREY, "Your phone is not switched on.");

	if(playerVariables[playerid][pPhoneCredit] < 1)
		return SendClientMessage(playerid, COLOR_GREY, "You have no remaining phone credit - visit a 24/7 to top it up.");

    foreach(Player, x) {
		if(playerVariables[x][pPhoneNumber] == number) {
		    if(playerVariables[x][pPhoneStatus] == 1 && playerVariables[x][pPrisonID] != 3) {
		        GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);

		        format(szMessage, sizeof(szMessage), "SMS from %s (%d): %s", szPlayerName, playerVariables[playerid][pPhoneNumber], message);
		        SendClientMessage(x, COLOR_SMS, szMessage);

		        GetPlayerName(x, szPlayerName, MAX_PLAYER_NAME);

		        format(szMessage, sizeof(szMessage), "SMS sent to %s (%d): %s", szPlayerName, playerVariables[x][pPhoneNumber], message);
		        SendClientMessage(playerid, COLOR_SMS, szMessage);
				playerVariables[playerid][pPhoneCredit] -= 3;

				mysql_real_escape_string(message, szClearMsg);
				format(szQuery, sizeof(szQuery), "INSERT INTO `phonelogs` (`phoneNumber`, `phoneAction`) VALUES('%d', 'SMS to %s: %s')", playerVariables[playerid][pPhoneNumber], szPlayerName, message);
				mysql_query(szQuery);
		        return 1;
		    }
		    else {
				return SendClientMessage(playerid, COLOR_GREY, "The cellphone that you're trying to SMS is currently unavailable.");
			}
		}
		count++;
	}

	if(count < 1) return SendClientMessage(playerid, COLOR_GREY, "Invalid number.");
	return 1;
}

CMD:t(playerid, params[]) {
	return cmd_sms(playerid, params);
}

CMD:call(playerid, params[]) {
	new
		number,

		string[128];

 	if(isnull(params))
		return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/call [number]");

 	number = strval(params);

	if(playerVariables[playerid][pPhoneNumber] == -1) {
		SendClientMessage(playerid, COLOR_GREY, "You don't have a phone.");
	}
	else if(playerVariables[playerid][pPhoneNumber] == number) {
		SendClientMessage(playerid, COLOR_GREY, "You're trying to call yourself.");
	}
	else {
		if(playerVariables[playerid][pPhoneStatus] == 1) {
			if(playerVariables[playerid][pPhoneCredit] >= 1) {
				if(playerVariables[playerid][pPhoneCall] == -1) {
					if(number == 911) {
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
						playerVariables[playerid][pPhoneCall] = 911;
						SendClientMessage(playerid, COLOR_WHITE, "You've called Emergency services, please select the department you desire (i.e: LSPD, LSFMD).");
					}
					else if(number != -1) {
						GetPlayerName(playerid, szPlayerName, MAX_PLAYER_NAME);
						format(string, sizeof(string), "* %s takes out their cellphone, and dials in a number.", szPlayerName, number);
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
						nearByMessage(playerid, COLOR_PURPLE, string);

						foreach(Player, i) {
							if(playerVariables[i][pPhoneNumber] == number)  {
								if(playerVariables[i][pStatus] == 1 && playerVariables[i][pSpectating] == INVALID_PLAYER_ID && playerVariables[i][pPhoneStatus] == 1 && playerVariables[i][pPhoneCall] == -1 && playerVariables[i][pPrisonID] != 3) {

									GetPlayerName(i, szPlayerName, MAX_PLAYER_NAME);
									format(string, sizeof(string), "* %s's cellphone starts to ring...", szPlayerName);
									nearByMessage(i, COLOR_PURPLE, string);
									SendClientMessage(i, COLOR_WHITE, "Use /p(ickup) to answer your phone.");

									SendClientMessage(playerid, COLOR_WHITE, "You can use the 'T' chat to proceed to talk.");
									playerVariables[playerid][pPhoneCall] = i;
									return 1;
								}
								else {
									SendClientMessage(playerid, COLOR_GREY, "(cellphone) *busy tone*");
									return 1;
								}
							}
						}
						if(playerVariables[playerid][pPhoneCall] == -1) SendClientMessage(playerid, COLOR_GREY, "(cellphone) *busy tone*");
					}
					else SendClientMessage(playerid, COLOR_GREY, "Invalid number.");
				}
				else SendClientMessage(playerid, COLOR_GREY, "You are currently in a call.");
			}
			else SendClientMessage(playerid, COLOR_GREY, "You have no remaining phone credit - visit a 24/7 to top it up.");
		}
		else SendClientMessage(playerid, COLOR_GREY, "You must switch your phone on first (/togphone).");
	}
	return 1;
}

CMD:pickup(playerid, params[]) {
	foreach(Player, i) { // Setting the current-call var to the ID of the person calling.
		if(playerVariables[i][pPhoneCall] == playerid) {

			playerVariables[playerid][pPhoneCall] = i;
			SendClientMessage(playerid, COLOR_WHITE, "You have answered your phone.");
			SendClientMessage(playerVariables[playerid][pPhoneCall], COLOR_WHITE, "The other person has answered the call.");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
		}
	}
	return 1;
}

CMD:p(playerid, params[]) {
	return cmd_pickup(playerid, params);
}

CMD:h(playerid, params[]) {
	return cmd_hangup(playerid, params);
}

CMD:togphone(playerid, params[]) {
	if(playerVariables[playerid][pPhoneNumber] != -1) {
		if(playerVariables[playerid][pPhoneStatus] == 1) {
		    playerVariables[playerid][pPhoneStatus] = 0;
		    SendClientMessage(playerid, COLOR_WHITE, "Your phone has been turned off.");
		}
		else {
		    playerVariables[playerid][pPhoneStatus] = 1;
		    SendClientMessage(playerid, COLOR_WHITE, "Your phone is now switched on.");
		}
	}
	else SendClientMessage(playerid, COLOR_GREY, "You don't have a phone.");
	return 1;
}

CMD:hangup(playerid, params[]) {

	if(playerVariables[playerid][pPhoneCall] != -1)
		SendClientMessage(playerid, COLOR_WHITE, "You have terminated the current call.");

	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USECELLPHONE)
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);

	if(playerVariables[playerid][pPhoneCall] != -1 && playerVariables[playerid][pPhoneCall] < MAX_PLAYERS) { // Valid values are 0-MAX_PLAYERS, 911 and such are used for 911 calls.
		SendClientMessage(playerVariables[playerid][pPhoneCall], COLOR_WHITE, "Your call has been terminated by the other party.");

		if(GetPlayerSpecialAction(playerVariables[playerid][pPhoneCall]) == SPECIAL_ACTION_USECELLPHONE)
			SetPlayerSpecialAction(playerVariables[playerid][pPhoneCall], SPECIAL_ACTION_STOPUSECELLPHONE);

		playerVariables[playerVariables[playerid][pPhoneCall]][pPhoneCall] = -1;
	}

	playerVariables[playerid][pPhoneCall] = -1;
	return 1;
}

#if !defined NO_IRC
IRCCMD:admins(botid, channel[], user[], host[], params[]) {
    if(!strcmp(channel, IRC_CHANNEL_MAIN, true)) {
		new
		    msgSz[32],
		    playerCount;

		foreach(Player, i) {
		    if(playerVariables[i][pAdminDuty] >= 1) playerCount++;
		}

		format(msgSz, sizeof(msgSz), "Server (Active) Admin Count: %d", playerCount);
		IRC_Say(scriptBots[0], IRC_CHANNEL_MAIN, msgSz);
	}
	return 1;
}

IRCCMD:players(botid, channel[], user[], host[], params[]) {
    if(!strcmp(channel, IRC_CHANNEL_MAIN, true)) {
		new
		    msgSz[32],
		    playerCount;

		foreach(Player, i) {
			playerCount++;
		}

		format(msgSz, sizeof(msgSz), "Server Player Count: %d", playerCount);
		IRC_Say(scriptBots[0], IRC_CHANNEL_MAIN, msgSz);
	}
	return 1;
}

IRCCMD:savedata(botid, channel[], user[], host[], params[]) {
    if(!strcmp(channel, IRC_CHANNEL_MAIN, true)) {
	    if(IRC_IsHalfop(scriptBots[0], IRC_CHANNEL_MAIN, user) || IRC_IsOp(scriptBots[0], IRC_CHANNEL_MAIN, user) || IRC_IsOwner(scriptBots[0], IRC_CHANNEL_MAIN, user)) {
	        foreach(Player, x) {
				savePlayerData(x);
			}
			IRC_Say(scriptBots[0], channel, "Player data saved.");

			for(new xh = 0; xh < MAX_HOUSES; xh++) {
	            saveHouse(xh);
			}
			IRC_Say(scriptBots[0], channel, "House data saved.");

			for(new xf = 0; xf < MAX_GROUPS; xf++) {
	            saveGroup(xf);
			}
			IRC_Say(scriptBots[0], channel, "Group data saved.");

			for(new xf = 0; xf < MAX_BUSINESSES; xf++) {
	            saveBusiness(xf);
			}
			IRC_Say(scriptBots[0], channel, "Business data saved.");

			for(new xf = 0; xf < MAX_ASSETS; xf++) {
	            saveAsset(xf);
			}
			IRC_Say(scriptBots[0], channel, "Asset data saved.");

			return 1;
		}
	}

	return 1;
}

IRCCMD:kickplayer(botid, channel[], user[], host[], params[]) {
    if(!strcmp(channel, IRC_CHANNEL_MAIN, true)) {
		if(IRC_IsHalfop(scriptBots[0], IRC_CHANNEL_MAIN, user) || IRC_IsOp(scriptBots[0], IRC_CHANNEL_MAIN, user) || IRC_IsOwner(scriptBots[0], IRC_CHANNEL_MAIN, user)) {
		    new
		        playerKickID,
		        playerKickReason[128];

		    if(sscanf(params, "us[128]", playerKickID, playerKickReason))
				return IRC_Say(scriptBots[0], user, SYNTAX_MESSAGE"/kick [id/name] [reason]");

		    if(IsPlayerConnected(playerKickID)) {

				new
					msgSz[128];

				GetPlayerName(playerKickID, szPlayerName, MAX_PLAYER_NAME);
				format(msgSz, sizeof(msgSz), "Kick: %s has been kicked by %s (via IRC), reason: %s", szPlayerName, user, playerKickReason);
				SendClientMessageToAll(COLOR_LIGHTRED, msgSz);
				IRC_Say(scriptBots[0], IRC_CHANNEL_MAIN, msgSz);

				OnPlayerDisconnect(playerKickID, 2); // OnPlayerDisconnect isn't called for IRC kicks... strange.
				Kick(playerKickID);
		    }
		    else {
		        return IRC_Say(scriptBots[0], user, "Not connected.");
		    }
		}
	}
	return 1;
}

#endif
