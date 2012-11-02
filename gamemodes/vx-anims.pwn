stock CanPlayerUseAnimation(playerid)
{
	if(GetPlayerState(playerid) != 1)
		return SendClientMessage(playerid, COLOR_GREY, "You can only use this animation while on foot."), false;
	if(playerVariables[playerid][pFreezeTime] != 0)
		return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while cuffed, tazed or frozen."), false;
	if(playerVariables[playerid][pEvent] == 1)
		return SendClientMessage(playerid, COLOR_GREY, "You can't use animations while in an event."), false;
	
	return true;
}

CMD:piss(playerid) 
{
	if(CanPlayerUseAnimation(playerid))
	{
		SetPlayerSpecialAction(playerid, 68);
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
	}
	return 1;
}

CMD:handsup(playerid) 
{
	if(CanPlayerUseAnimation(playerid))
	{
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
	}
	return 1;
}

CMD:drunk(playerid) 
{
	if(CanPlayerUseAnimation(playerid))
	{
		ApplyAnimation(playerid, "PED", "WALK_DRUNK", 4.0, 1, 1, 1, 1, 0);
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
	}
	return 1;
}

CMD:bomb(playerid)
{
    if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:rob(playerid)
{
    if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "ped", "ARRESTgun", 4.0, 0, 1, 1, 1, 0);
 	return 1;
}

CMD:laugh(playerid)
{
    if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:lookout(playerid)
{
    if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:robman(playerid)
{
    if(CanPlayerUseAnimation(playerid))
	{
		ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0);
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
	}
   	return 1;
}

CMD:hide(playerid)
{
	if(CanPlayerUseAnimation(playerid))
	{
		ApplyAnimation(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0);
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
	}
   	return 1;
}

CMD:vomit(playerid)
{
	if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:eat(playerid)
{
    if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:slapass(playerid)
{
    if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:crack(playerid)
{
    if(CanPlayerUseAnimation(playerid))
	{
		ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
	}
   	return 1;
}

CMD:finger(playerid)
{
    if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "PED", "fucku", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:taichi(playerid)
{
	if(CanPlayerUseAnimation(playerid))
	{
		ApplyAnimation(playerid, "PARK", "Tai_Chi_Loop", 4.0, 1, 0, 0, 0, 0);
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
   	}
	return 1;
}

CMD:drinkwater(playerid)
{
    if(CanPlayerUseAnimation(playerid))
	{
		ApplyAnimation(playerid, "BAR", "dnk_stndF_loop", 4.0, 1, 0, 0, 0, 0);
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
	}
   	return 1;
}

CMD:checktime(playerid)
{
    if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:sleep(playerid)
{
    if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "CRACK", "crckdeth4", 4.0, 0, 1, 1, 1, -1);
   	return 1;
}

CMD:blob(playerid)
{
    if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "CRACK", "crckidle1", 4.0, 0, 1, 1, 1, -1);
   	return 1;
}

CMD:opendoor(playerid)
{
    if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "AIRPORT", "thrw_barl_thrw", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:wavedown(playerid)
{
	if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "BD_FIRE", "BD_Panic_01", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:cpr(playerid)
{
    if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "MEDIC", "CPR", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:dive(playerid)
{
    if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "DODGE", "Crush_Jump", 4.0, 0, 1, 1, 1, 0);
   	return 1;
}

CMD:showoff(playerid)
{
	if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "Freeweights", "gym_free_celebrate", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:goggles(playerid)
{
	if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:cry(playerid)
{
    if(CanPlayerUseAnimation(playerid))
	{
		ApplyAnimation(playerid, "GRAVEYARD", "mrnF_loop", 4.0, 1, 0, 0, 0, 0);
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
   	}
	return 1;
}

CMD:throw(playerid)
{
    if(CanPlayerUseAnimation(playerid))
	{
		ApplyAnimation(playerid, "GRENADE", "WEAPON_throw", 4.0, 0, 0, 0, 0, 0);
		playerVariables[playerid][pAnimation] = 1;
	}
   	return 1;
}

CMD:robbed(playerid)
{
    if(CanPlayerUseAnimation(playerid))
		ApplyAnimation(playerid, "SHOP", "SHP_Rob_GiveCash", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:hurt(playerid)
{
    if(CanPlayerUseAnimation(playerid))
	{
		ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.0, 1, 0, 0, 0, 0);
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
   	}
	return 1;
}

CMD:box(playerid)
{
    if(CanPlayerUseAnimations(playerid))
    {
		ApplyAnimation(playerid, "GYMNASIUM", "GYMshadowbox", 4.0, 1, 0, 0, 0, 0);
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
   	}
	return 1;
}

CMD:handwash(playerid)
{
    if(CanPlayerUseAnimations(playerid))
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:crabs(playerid)
{
    if(CanPlayerUseAnimations(playerid))
		ApplyAnimation(playerid, "MISC", "Scratchballs_01", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:salute(playerid)
{
    if(CanPlayerUseAnimations(playerid))
    {
		ApplyAnimation(playerid, "ON_LOOKERS", "Pointup_loop", 4.0, 1, 0, 0, 0, 0);
		playerVariables[playerid][pAnimation] = 1;
   	}
	return 1;
}

CMD:masturbate(playerid)
{
    if(CanPlayerUseAnimations(playerid))
		ApplyAnimation(playerid, "PAULNMAC", "wank_out", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:stop(playerid)
{
    if(CanPlayerUseAnimations(playerid))
		ApplyAnimation(playerid, "PED", "endchat_01", 4.0, 0, 0, 0, 0, 0);
   	return 1;
}

CMD:rap(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/rap [1-3]");
		switch(temp) 
		{
			case 1: ApplyAnimation(playerid, "RAPPING", "RAP_A_Loop", 4.0, 1, 0, 0, 0, 0);
			case 2: ApplyAnimation(playerid, "RAPPING", "RAP_B_Loop", 4.0, 1, 0, 0, 0, 0);
			case 3: ApplyAnimation(playerid, "RAPPING", "RAP_C_Loop", 4.0, 1, 0, 0, 0, 0);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/rap [1-3]");
		}
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
	}
   	return 1;
}

CMD:chat(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
	{
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/chat [1-7]");
		switch(temp) 
		{
			case 1: ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.0, 0, 0, 0, 0, 0);
			case 2: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.0, 0, 0, 0, 0, 0);
			case 3: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkB", 4.0, 0, 0, 0, 0, 0);
			case 4: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.0, 0, 0, 0, 0, 0);
			case 5: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkF", 4.0, 0, 0, 0, 0, 0);
			case 6: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkG", 4.0, 0, 0, 0, 0, 0);
			case 7: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkH", 4.0, 0, 0, 0, 0, 0);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/chat [1-7]");
		}
	}
 	return 1;
}

CMD:gesture(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
	{
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/gesture [1-15]");
		switch(temp) 
		{
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
	}
   	return 1;
}

CMD:lay(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/lay [1-3]");
		switch(temp) 
		{
			case 1: ApplyAnimation(playerid, "BEACH", "bather", 4.0, 1, 0, 0, 0, 0);
			case 2: ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.0, 1, 0, 0, 0, 0);
			case 3: ApplyAnimation(playerid, "BEACH", "SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/lay [1-3]");
		}
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
	}
 	return 1;
}

CMD:wave(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/wave [1-3]");
		switch(temp) 
		{
			case 1: ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0);
			case 2: ApplyAnimation(playerid, "KISSING", "gfwave2", 4.0, 0, 0, 0, 0, 0);
			case 3: ApplyAnimation(playerid, "PED", "endchat_03", 4.0, 0, 0, 0, 0, 0);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/wave [1-3]");
		}
	}
 	return 1;
}

CMD:signal(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/signal [1-2]");
		switch(temp) 
		{
			case 1: ApplyAnimation(playerid, "POLICE", "CopTraf_Come", 4.0, 0, 0, 0, 0, 0);
			case 2: ApplyAnimation(playerid, "POLICE", "CopTraf_Stop", 4.0, 0, 0, 0, 0, 0);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/signal [1-2]");
		}
	}
   	return 1;
}

CMD:nobreath(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/nobreath [1-3]");
		switch(temp) 
		{
			case 1: ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
			case 2: ApplyAnimation(playerid, "PED", "IDLE_tired", 4.0, 1, 0, 0, 0, 0);
			case 3: ApplyAnimation(playerid, "FAT", "IDLE_tired", 4.0, 1, 0, 0, 0, 0);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/nobreath [1-3]");
		}
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
	}
 	return 1;
}

CMD:fallover(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/fallover [1-3]");
		switch(temp) 
		{
			case 1: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.0, 0, 1, 1, 1, 0);
			case 2: ApplyAnimation(playerid, "PED", "KO_shot_face", 4.0, 0, 1, 1, 1, 0);
			case 3: ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.0, 0, 1, 1, 1, 0);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/fallover [1-3]");
		}
	}
 	return 1;
}

CMD:pedmove(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/pedmove [1-26]");
		switch(temp) 
		{
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
	}
	return 1;
}

CMD:getjiggy(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/getjiggy [1-9]");
		switch(temp) 
		{
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
	}
   	return 1;
}

CMD:stripclub(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/stripclub [1-2]");
		switch(temp) 
		{
			case 1: ApplyAnimation(playerid, "STRIP", "PLY_CASH", 4.0, 0, 0, 0, 0, 0);
			case 2: ApplyAnimation(playerid, "STRIP", "PUN_CASH", 4.0, 0, 0, 0, 0, 0);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/stripclub [1-2]");
		}
	}
 	return 1;
}

CMD:smoke(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/smoke [1-3]");
		switch(temp) 
		{
			case 1: ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.0, 0, 0, 0, 0, 0);
			case 2: ApplyAnimation(playerid, "SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0);
			case 3: SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/smoke [1-2]");
		}
	}
 	return 1;
}

CMD:dj(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/dj [1-4]");
		switch(temp) 
		{
			case 1: ApplyAnimation(playerid, "SCRATCHING", "scdldlp", 4.0, 1, 0, 0, 0, 0);
			case 2: ApplyAnimation(playerid, "SCRATCHING", "scdlulp", 4.0, 1, 0, 0, 0, 0);
			case 3: ApplyAnimation(playerid, "SCRATCHING", "scdrdlp", 4.0, 1, 0, 0, 0, 0);
			case 4: ApplyAnimation(playerid, "SCRATCHING", "scdrulp", 4.0, 1, 0, 0, 0, 0);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/dj [1-4]");
		}
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
	}
	return 1;
}

CMD:reload(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/reload - 1 (Desert Eagle), 2 (SPAS12), 3 (UZI/AK-47/M4A1)");
		switch(temp) 
		{
			case 1: ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0);
			case 2: ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.0, 0, 0, 0, 0, 0);
			case 3: ApplyAnimation(playerid, "UZI", "UZI_reload", 4.0,0,0,0,0,0);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/reload - 1 (Desert Eagle), 2 (SPAS12), 3 (UZI/AK-47/M4A1)");
		}
	}
 	return 1;
}

CMD:tag(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/tag [1-2]");
		switch(temp) 
		{
			case 1: ApplyAnimation(playerid, "GRAFFITI", "graffiti_Chkout", 4.0, 0, 0, 0, 0, 0);
			case 2: ApplyAnimation(playerid, "GRAFFITI", "spraycan_fire", 4.0, 0, 0, 0, 0, 0);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/tag [1-2]");
		}
	}
 	return 1;
}

CMD:deal(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/deal [1-2]");
		switch(temp) 
		{
			case 1: ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);
			case 2: ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/deal [1-2]");
		}
	}
 	return 1;
}

CMD:crossarms(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/crossarms [1-4]");
		switch(temp) 
		{
			case 1: ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);
			case 2: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
			case 3: ApplyAnimation(playerid, "GRAVEYARD", "mrnM_loop", 4.0, 1, 0, 0, 0, 0);
			case 4: ApplyAnimation(playerid, "GRAVEYARD", "prst_loopa", 4.0, 1, 0, 0, 0, 0);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/crossarms [1-4]");
		}
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
	}
 	return 1;
}

CMD:bat(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/bat [1-2]");
		switch(temp) 
		{
			case 1: ApplyAnimation(playerid, "CRACK", "Bbalbat_Idle_01", 4.0, 1, 0, 0, 0, 0);
			case 2: ApplyAnimation(playerid, "CRACK", "Bbalbat_Idle_02", 4.0, 1, 0, 0, 0, 0);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/bat [1-2]");
		}
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
	}
 	return 1;
}

CMD:cheer(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/cheer [1-8]");
		switch(temp) 
		{
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
	}
   	return 1;
}

CMD:sit(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/sit [1-6]");
		switch(temp) 
		{
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
	}
 	return 1;
}

CMD:siteat(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/siteat [1-2]");
		switch(temp) 
		{
			case 1: ApplyAnimation(playerid, "FOOD", "FF_Sit_Eat3", 4.0, 1, 0, 0, 0, 0);
			case 2: ApplyAnimation(playerid, "FOOD", "FF_Sit_Eat2", 4.0, 1, 0, 0, 0, 0);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/siteat [1-2]");
		}
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
	}
   	return 1;
}

CMD:bar(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/bar [1-5]");
		switch(temp) 
		{
			case 1: ApplyAnimation(playerid, "BAR", "Barcustom_get", 4.0, 0, 1, 0, 0, 0);
			case 2: ApplyAnimation(playerid, "BAR", "Barserve_bottle", 4.0, 0, 0, 0, 0, 0);
			case 3: ApplyAnimation(playerid, "BAR", "Barserve_give", 4.0, 0, 0, 0, 0, 0);
			case 4: ApplyAnimation(playerid, "BAR", "dnk_stndM_loop", 4.0, 0, 0, 0, 0, 0);
			case 5: ApplyAnimation(playerid, "BAR", "BARman_idle", 4.0, 0, 0, 0, 0, 0);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/bar [1-5]");
		}
	}
   	return 1;
}

CMD:dance(playerid, params[])
{
    if(CanPlayerUseAnimations(playerid))
    {
		if(sscanf(params, "d", temp)) return SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/dance [1-4]");
		switch(temp)
		{
			case 1: SetPlayerSpecialAction(playerid, 5);
			case 2: SetPlayerSpecialAction(playerid, 6);
			case 3: SetPlayerSpecialAction(playerid, 7);
			case 4: SetPlayerSpecialAction(playerid, 8);
			default: SendClientMessage(playerid, COLOR_GREY, SYNTAX_MESSAGE"/dance [style 1-4]");
		}
		TextDrawShowForPlayer(playerid, textdrawVariables[5]);
		playerVariables[playerid][pAnimation] = 1;
	}
 	return 1;
}

CMD:stopanim(playerid) 
{
	if(playerVariables[playerid][pFreezeType] == 0 && GetPlayerState(playerid) == 1 && playerVariables[playerid][pEvent] == 0) 
	{
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
		TextDrawHideForPlayer(playerid, textdrawVariables[5]);
		SendClientMessage(playerid, COLOR_WHITE, "Animations cleared.");
		ClearAnimations(playerid);
		playerVariables[playerid][pAnimation] = 0;
		TogglePlayerControllable(playerid, 1);
	}
	else 
	{
		SendClientMessage(playerid, COLOR_GREY, "You can't do this right now.");
	}
	return 1;
}