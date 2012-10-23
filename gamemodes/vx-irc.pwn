#if !defined NO_IRC
forward IRCBotDelay();
	
new scriptBots[MAX_BOTS];

public IRCBotDelay() 
{
	scriptBots[0] = IRC_Connect(IRC_SERVER, IRC_PORT, "YOURBOTNAME", "Maurice Moss", "VXRP2SCRIPT");
	return 1;
}

public IRC_OnConnect(botid) 
{
    IRC_SendRaw(scriptBots[0], "PRIVMSG NickServ :IDENTIFY "IRC_BOT_PASS);
    IRC_JoinChannel(scriptBots[0], IRC_CHANNEL_MAIN);
    IRC_JoinChannel(scriptBots[0], IRC_STAFF_CHANNEL, IRC_STAFF_CHANNEL_PASSWORD);
	return 1;
}

public IRC_OnJoinChannel(botid, channel[]) 
{
	if(!strcmp(channel, IRC_CHANNEL_MAIN, true))
		IRC_Say(scriptBots[0], IRC_CHANNEL_MAIN, "Server started. Release: "SERVER_VERSION".");

	return 1;
}

public IRC_OnLeaveChannel(botid, channel[], message[]) 
{
	if(!strcmp(channel, IRC_CHANNEL_MAIN)) 
	{
	    IRC_JoinChannel(scriptBots[0], IRC_CHANNEL_MAIN);
	} 
	else if(!strcmp(channel, IRC_STAFF_CHANNEL)) 
	{
	    IRC_JoinChannel(scriptBots[0], IRC_STAFF_CHANNEL, IRC_STAFF_CHANNEL_PASSWORD);
	}
	
	return 1;
}

public IRC_OnDisconnect(botid) 
{
	return SetTimer("IRCBotDelay", 5000, false);
}

public IRC_OnUserSay(botid, recipient[], user[], host[], message[]) 
{
	if(systemVariables[OOCStatus] == 0) 
	{
	    if(!strcmp(recipient, IRC_CHANNEL_MAIN, true)) 
		{
	  		format(szMessage, sizeof(szMessage), "(( %s says [on IRC]: %s ))", user, message);

			foreach(Player, x) 
			{
				if(playerVariables[x][pSeeOOC] == 1) 
				{
					SendClientMessage(x, COLOR_LIGHT, szMessage);
				    GetPlayerName(x, szPlayerName, MAX_PLAYER_NAME);
				    if(strfind(szPlayerName, message, true, 0) != -1) 
					{
						PlayerPlaySound(x, 1057, 0, 0, 0);
					}
				}
			}
		}
		else if(!strcmp(recipient, IRC_STAFF_CHANNEL, true)) 
		{
		    format(szMessage, sizeof(szMessage), "* Admin %s says [on IRC]: %s", user, message);
		    submitToAdmins(szMessage, COLOR_YELLOW);
		}
	}
	return 1;
}

#if !defined NO_IRC
IRCCMD:admins(botid, channel[], user[], host[], params[]) 
{
    if(!strcmp(channel, IRC_CHANNEL_MAIN, true)) 
	{
		new msgSz[32], playerCount;

		foreach(Player, i) 
		{
		    if(playerVariables[i][pAdminDuty] >= 1) 
				playerCount++;
		}

		format(msgSz, sizeof(msgSz), "Server (Active) Admin Count: %d", playerCount);
		IRC_Say(scriptBots[0], IRC_CHANNEL_MAIN, msgSz);
	}
	return 1;
}

IRCCMD:players(botid, channel[], user[], host[], params[]) 
{
    if(!strcmp(channel, IRC_CHANNEL_MAIN, true)) 
	{
		new msgSz[32];
		format(msgSz, sizeof(msgSz), "Server Player Count: %d", Iter_Count(Player));
		IRC_Say(scriptBots[0], IRC_CHANNEL_MAIN, msgSz);
	}
	return 1;
}

IRCCMD:savedata(botid, channel[], user[], host[], params[]) 
{
    if(!strcmp(channel, IRC_CHANNEL_MAIN, true) && IRC_IsHalfop(scriptBots[0], IRC_CHANNEL_MAIN, user)) 
	{
		foreach(Player, x) 
		{
			savePlayerData(x);
		}
		IRC_Say(scriptBots[0], channel, "Player data saved.");

		for(new xh = 0; xh < MAX_HOUSES; xh++) 
		{
			saveHouse(xh);
		}
		IRC_Say(scriptBots[0], channel, "House data saved.");

		for(new xf = 0; xf < MAX_GROUPS; xf++) 
		{
	        saveGroup(xf);
		}
		IRC_Say(scriptBots[0], channel, "Group data saved.");

		for(new xf = 0; xf < MAX_BUSINESSES; xf++) 
		{
	        saveBusiness(xf);
		}
		IRC_Say(scriptBots[0], channel, "Business data saved.");

		for(new xf = 0; xf < MAX_ASSETS; xf++) 
		{
	        saveAsset(xf);
		}
		IRC_Say(scriptBots[0], channel, "Asset data saved.");
	}
	return 1;
}

IRCCMD:kickplayer(botid, channel[], user[], host[], params[]) 
{
	if(!strcmp(channel, IRC_CHANNEL_MAIN, true) && IRC_IsHalfOp(scriptBots[0], IRC_CHANNEL_MAIN, user))
	{
		new playerKickID,
			playerKickReason[128];
			
		if(sscanf(params, "us[128]", playerKickID, playerKickReason))
			IRC_Say(scriptBots[0], user, SYNTAX_MESSAGE"!kickplayer [id/name] [reason]");
		else if(playerKickID == INVALID_PLAYER_ID)
			IRC_Say(scriptBots[0], user, "Not connected.");
		else
		{
			new msgSz[128];

			GetPlayerName(playerKickID, szPlayerName, MAX_PLAYER_NAME);
			format(msgSz, sizeof(msgSz), "Kick: %s has been kicked by %s (via IRC), reason: %s", szPlayerName, user, playerKickReason);
			SendClientMessageToAll(COLOR_LIGHTRED, msgSz);
			IRC_Say(scriptBots[0], IRC_CHANNEL_MAIN, msgSz);

			// TO-DO: Check if this is necessary...
			OnPlayerDisconnect(playerKickID, 2); // OnPlayerDisconnect isn't called for IRC kicks... strange.
			Kick(playerKickID);
		}
	}
	return 1;
}
#endif