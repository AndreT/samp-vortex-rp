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
new eventVariables[eventE];

stock SendToEvent(const colour, const string[]) {
	foreach(Player, i) {
		if(playerVariables[i][pEvent] >= 1) SendClientMessage(i, colour, string);
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