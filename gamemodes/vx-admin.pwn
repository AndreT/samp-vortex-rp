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

			if(playerVariables[playerWarnID][pWarning1][0] == '*')
	        {
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
			else if(playerVariables[playerWarnID][pWarning2][0] == '*') 
			{
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
	        else 
			{
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

CMD:ban(playerid, params[]) 
{
	if(playerVariables[playerid][pAdminLevel] >= 1) 
	{
	    new playerBanID, playerBanReason[50];

	    if(sscanf(params, "us[128]", playerBanID, playerBanReason))
	    	SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/ban [playerid] [reason]");
		else if(!(3 <= strlen(playerBanReason) <= 46))
			SendClientMessage(playerid, COLOR_GREY, "Ban reason must stay between 3 and 46 characters.");
		else if(playerVariables[playerBanID][pAdminLevel] >= playerVariables[playerid][pAdminLevel])
			SendClientMessage(playerid, COLOR_GREY, "You can't ban a higher (or equal) level administrator.");
        else if(playerBanID == INVALID_PLAYER_ID)
			SendClientMessage(playerid, COLOR_GREY, "The specified player ID is either not connected or has not authenticated.");
		else
		{
			new playerIP[32],
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

			// TO-DO: doublecheck!
			//mysql_real_escape_string(szPlayerName, szPlayerName);
			//mysql_real_escape_string(playerNameBanned, playerNameBanned);

			format(aString, sizeof(aString), "INSERT INTO bans(playerNameBanned,playerBannedBy,playerBanReason,IPBanned) VALUES('%s','%s','%s','%s')", playerNameBanned, szPlayerName, playerBanReason, playerIP);
			mysql_query(aString, THREAD_BAN_PLAYER, playerBanID);
		}
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

