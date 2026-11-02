#include bots\bots_funcs;

init()
{
	if(getDvar("bots_main") == "")
		setDvar("bots_main", true);
	if(getDvar("bots_main_debug") == "")
		setDvar("bots_main_debug", false);
	if(getDvar("bots_main_fun") == "")
		setDvar("bots_main_fun", true);
	
	if(getDvar("bots_main_firstIsHost") == "")
		setDvar("bots_main_firstIsHost", true);
	
	if(getDvar("bots_main_customMod") == "")
		setDvar("bots_main_customMod", false);
	
	if(getDvar("bots_main_dropWeapons") == "")
		setDvar("bots_main_dropWeapons", true);
	
		bots_precacheStuff();
		bots_loadWaypoints();
		bots_declareDvars();
		thread bots_watch();
		thread bots_onPlayerConnect();
		thread bots_onUAVAllies();
		thread bots_onUAVAxis();
		thread bots_fixGamemodes();
}

bots_fixGamemodes()
{
	for(i=0;i<19;i++)
	{
		if(isDefined(level.bombZones) && level.gametype == "sd")
		{
			for(i = 0; i < level.bombZones.size; i++)
				level.bombZones[i].onUse = ::bots_onUsePlantObjectFix;
			break;
		}
		
		wait 0.05;
	}
}

bots_precacheStuff()
{
	level.bots_bloodfx = loadfx("impacts/flesh_hit_body_fatal_exit");
	level.defuseObject = undefined;
	level.bots_smokeList = [];
	level.bots_fragList = [];
	level.bots_animWeapSubStr = "1q";
	level.bots_animWeapStandWalk = "none";
	level.bots_animWeapStandRun = "none";
	level.bots_animWeapCrouch = "none";
	level.bots_animWeapClimb = "none";
	level.bots_animWeapKnife = "none";
	if(!isDefined(game["botWarfare"]))
		game["botWarfare"] = true;
}

bots_declareDvars()
{
	setDvar("sv_botsPressAttackBtn", true);
	setDvar("sv_punkbuster", false);
	
	//bots_main
	//bots_main_debug
	setDvar("bots_manage_add", 0);//amount of bots to add to the game
	if(getDvar("bots_manage_fill") == "")
		setDvar("bots_manage_fill", 0);//amount of bots to maintain
	if(getDvar("bots_manage_fill_spec") == "")
		setDvar("bots_manage_fill_spec", true);//to count for fill if player is on spec team
	if(getDvar("bots_manage_fill_mode") == "")
		setDvar("bots_manage_fill_mode", 0);//fill mode, 0 adds everyone, 1 just bots, 2 maintains at maps, 3 is 2 with 1
	if(getDvar("bots_manage_fill_kick") == "")
		setDvar("bots_manage_fill_kick", false);//kick bots if too many
	setDvar("bots_manage_reset", false);//resets bots when 1
	
	if(getDvar("bots_team") == "")
		setDvar("bots_team", "autoassign");//which team for bots to join
	if(getDvar("bots_team_amount") == "")
		setDvar("bots_team_amount", 0);//amount of bots on axis team
	if(getDvar("bots_team_force") == "")
		setDvar("bots_team_force", false);//force bots on team
	if(getDvar("bots_team_mode") == "")
		setDvar("bots_team_mode", 0);//counts just bots when 1
	/*if(getDvar("bots_skill") == "")
		setDvar("bots_skill", 0);
	if(getDvar("bots_skill_axis_hard") == "")
		setDvar("bots_skill_axis_hard", 0);//amount of hard bots on axis team
	if(getDvar("bots_skill_axis_med") == "")
		setDvar("bots_skill_axis_med", 0);
	if(getDvar("bots_skill_allies_hard") == "")
		setDvar("bots_skill_allies_hard", 0);
	if(getDvar("bots_skill_allies_med") == "")
		setDvar("bots_skill_allies_med", 0);*/
	
	if(getDvar("bots_loadout") == "")
		setDvar("bots_loadout", "level");//loadout mode
	if(getDvar("bots_loadout_killstreak") == "")
		setDvar("bots_loadout_killstreak", true);//killstreak mode
	if(getDvar("bots_loadout_change") == "")
		setDvar("bots_loadout_change", true);//chance to change class
	if(getDvar("bots_loadout_remember") == "")
		setDvar("bots_loadout_remember", true);//will remember class
	if(getDvar("bots_loadout_lastStand") == "")
		setDvar("bots_loadout_lastStand", true);//
	if(getDvar("bots_loadout_tube") == "")
		setDvar("bots_loadout_tube", true);//
	if(getDvar("bots_loadout_sniper") == "")
		setDvar("bots_loadout_sniper", true);//
	if(getDvar("bots_loadout_nade") == "")
		setDvar("bots_loadout_nade", true);//
	if(getDvar("bots_loadout_shotgun") == "")
		setDvar("bots_loadout_shotgun", true);//will use *
	if(getDvar("bots_loadout_knife") == "")
		setDvar("bots_loadout_knife", true);//use the knife
	if(getDvar("bots_loadout_juggernaut") == "")
		setDvar("bots_loadout_juggernaut", true);//
	
	if(getDvar("bots_play_rageQuit") == "")
		setDvar("bots_play_rageQuit", true);//will ragequit if chance
	if(getDvar("bots_play_talk") == "")
		setDvar("bots_play_talk", 2.0);//talk rate scaler
	if(getDvar("bots_play_run") == "")
		setDvar("bots_play_run", true);//bots chance to run
	if(getDvar("bots_play_tdks") == "")
		setDvar("bots_play_tdks", true);//attack killsteaks
	if(getDvar("bots_play_destroyEq") == "")
		setDvar("bots_play_destroyEq", true);//attack equ
	if(getDvar("bots_play_attack") == "")
		setDvar("bots_play_attack", true);//attack
	if(getDvar("bots_play_outOfMyWay") == "")
		setDvar("bots_play_outOfMyWay", 0.0);//
	if(getDvar("bots_play_obj") == "")
		setDvar("bots_play_obj", true);//
	if(getDvar("bots_play_camp") == "")
		setDvar("bots_play_camp", true);//
	if(getDvar("bots_play_move") == "")
		setDvar("bots_play_move", true);//
	if(getDvar("bots_play_doStuck") == "")
		setDvar("bots_play_doStuck", true);//
	if(getDvar("bots_play_fakeAnims") == "")
		setDvar("bots_play_fakeAnims", true);//
	if(getDvar("bots_play_throwback") == "")
		setDvar("bots_play_throwback", true);//
	// Real player movement emits engine footsteps; disable the legacy synthetic layer by default.
	setDvar("bots_play_footsounds", false);
	
	if(getDvar("bots_main_experience") == "")
		setDvar("bots_main_experience", -2);//experience, -1 is always random, -2 is near host if offline
	if(getDvar("bots_main_prestige") == "")
		setDvar("bots_main_prestige", -2);//prestige (console only), -1 is always random, -2 is same as host if pc or offline
	
	if(getDvar("bots_main_GUIDs") == "")
		setDvar("bots_main_GUIDs", "");//host GUIDs, "" for off
	if(getDvar("bots_main_Names") == "")
		setDvar("bots_main_Names", "");//host names, "" for off
	
	if(getDvar("bots_main_menu") == "")
		setDvar("bots_main_menu", false);//enable host menu
	
	if(getDvar("bots_main_target") == "")
		setDvar("bots_main_target", "");
	
	if(getDvar("bots_main_target_host") == "")
		setDvar("bots_main_target_host", true);
	
	if (!isDefined(level.bots_knifeDis))
		level.bots_knifeDis = 128.0;//for how far bots can knife
	if (!isDefined(level.bots_minNadeDis))
		level.bots_minNadeDis = 400.0;//how far bots can nade at min distance
	if (!isDefined(level.bots_moveSpeedBase))
		level.bots_moveSpeedBase = 1.0;//scaler of how fast bots will move
	if (!isDefined(level.bots_objNear))
		level.bots_objNear = 50.0;//how near for a bot to be near an obj
	if (!isDefined(level.bots_useNear))
		level.bots_useNear = 100.0;//how near for a bot to be near an useable object
	
	if(!isDefined(level.bots_goalPoint))
	{
		if(level.waypointCount)
			level.bots_goalPoint = level.waypoints[randomint(level.waypointCount)];
		level.bots_goalRad = randomFloatRange(100,2500);
	}
	
	//optimizers
	level.bots_semiAuto = [];
	level.bots_semiAuto["barrett"] = true;
	level.bots_semiAuto["m21"] = true;
	
	level.bots_canShoot = [];
	level.bots_canShoot["knife"] = true;
	level.bots_canShoot["knifebig"] = true;
	level.bots_canShoot["bomb"] = true;
	level.bots_canShoot["climb"] = true;
	level.bots_canShoot["switch"] = true;
	
	level.bots_canStopShoot = [];
	level.bots_canStopShoot["ftube"] = true;
	level.bots_canStopShoot["nade_fire"] = true;
	level.bots_canStopShoot["reload"] = true;
	
	level.bots_canMove = [];
	level.bots_canMove["bomb"] = true;
	level.bots_canMove["reload"] = true;
	
	level.bots_shouldAim = [];
	level.bots_shouldAim["none"] = true;
	
	level.bots_shouldObj = [];
	level.bots_shouldObj["none"] = true;
	
	level.bots_doingNothing = [];
	level.bots_doingNothing["none"] = true;
	
	level.bots_isClimbing = [];
	level.bots_isClimbing["climb"] = true;
	
	level.bots_canClimb = [];
	level.bots_canClimb["climb"] = true;
	level.bots_canClimb["ftube"] = true;
	
	level.bots_forceSwitch = [];
	level.bots_forceSwitch["none"] = true;
	
	level.bots_devWalk = [];
	level.bots_devWalk["claymore_mp"] = true;
	level.bots_devWalk["c4_mp"] = true;
	level.bots_devWalk["frag_grenade_mp"] = true;
	level.bots_devWalk["concussion_grenade_mp"] = true;
	level.bots_devWalk["flash_grenade_mp"] = true;
	level.bots_devWalk["smoke_grenade_mp"] = true;
	
	level.bots_animNone = [];
	level.bots_animNone["none"] = true;
	level.bots_animNone["ftube"] = true;
	
	level.bots_animClimb = [];
	level.bots_animClimb["climb"] = true;
	
	level.bots_animKnife = [];
	level.bots_animKnife["knife"] = true;
	level.bots_animKnife["knifebig"] = true;
	
	level bots_updateVars();
		
	level.tbl_PerkData[0]["reference_full"] = true;
	level.default_perk["CLASS_CUSTOM1"][0] = "specialty_null";
	level.default_perk["CLASS_CUSTOM1"][1] = "specialty_null";
	level.default_perk["CLASS_CUSTOM1"][2] = "specialty_null";
}

bots_updateVars()
{
	// this isnt good practice
	// but honestly, it works, so its good enough for me :)

/*
	// THIS IS FOR PARSEC ONLY -- remember to change this back for prod
	level.bots_varSkill = 1;
*/

	if (level.console)
	{
		if (level.rankedMatch)
		{
			if (level.oldschool)
				level.bots_varSkill = 7;
			else if (level.hardcoreMode)
				level.bots_varSkill = 5;
			else if (level.teamBased)
				level.bots_varSkill = 4;
			else
				level.bots_varSkill = 4; // just in case we want to change how ffa difficulty is in the future
		}
		else if (!level.splitScreen)
			level.bots_varSkill = 3; // offlines a bit easier just in case someones using it for practice
		else
			level.bots_varSkill = 1; // splitscreen players dont give a fuck about bots. should we even have them there at all?
	}
	else
		level.bots_varSkill = 0;

	
	level.bots_varLoadout = getDvar("bots_loadout");
	level.bots_varLoadoutKS = getDvarInt("bots_loadout_killstreak");
	level.bots_varLoadoutChange = getDvarInt("bots_loadout_change");
	level.bots_varLoadoutRem = getDvarInt("bots_loadout_remember");
	level.bots_varLoadoutLS = getDvarInt("bots_loadout_lastStand");
	level.bots_varLoadoutTube = getDvarInt("bots_loadout_tube");
	level.bots_varLoadoutSniper = getDvarInt("bots_loadout_sniper");
	level.bots_varLoadoutNade = getDvarInt("bots_loadout_nade");
	level.bots_varLoadoutJug = getDvarInt("bots_loadout_juggernaut");
	level.bots_varLoadoutShotgun = getDvarInt("bots_loadout_shotgun");
	level.bots_varLoadoutKnife = getDvarInt("bots_loadout_knife");
	
	level.bots_varPlayQuit = getDvarInt("bots_play_rageQuit");
	level.bots_varPlayTalk = getDvarFloat("bots_play_talk");
	level.bots_varPlayRun = getDvarInt("bots_play_run");
	level.bots_varPlayTDKS = getDvarInt("bots_play_tdks");
	level.bots_varPlayEqu = getDvarInt("bots_play_destroyEq");
	level.bots_varPlayAttack = getDvarInt("bots_play_attack");
	level.bots_varPlayOFMW = getDvarFloat("bots_play_outOfMyWay");
	level.bots_varPlayObj = getDvarInt("bots_play_obj");
	level.bots_varPlayCamp = getDvarInt("bots_play_camp");
	level.bots_varPlayMove = getDvarInt("bots_play_move");
	level.bots_varPlayStuck = getDvarInt("bots_play_doStuck");
	level.bots_varPlayAnim = getDvarInt("bots_play_fakeAnims");
	level.bots_varPlayTB = getDvarInt("bots_play_throwback");
	level.bots_varPlayFoot = getDVarInt("bots_play_footsounds");
	
	level.bots_varTargetHost = getDVarInt("bots_main_target_host");
	
	level.bots_varTarget = getDvar("bots_main_target");
	
	if(level.bots_varPlayAttack)
		setDvar("sv_botsPressAttackBtn", true);
	else
		setDvar("sv_botsPressAttackBtn", false);
}

bots_watch()
{
	for(;;)
	{
		wait 1.5;
		// initTestClients(1); // Removed: moved to bots_watchBots to respect fillAmount
		bots_waitFrame();
		
		level bots_updateVars();
		bots_waitFrame();
		
		level bots_watchBots();
		bots_waitFrame();
	}
}

bots_watchBots()
{
	fillSpec = getDVarInt("bots_manage_fill_spec");
	fillMode = getDVarInt("bots_manage_fill_mode");
	
	if (level.rankedMatch) // public online host: honor the host-local pregame lobby simulation when enabled
	{
		if(getDvarInt("codxe_lobbybots_enabled"))
		{
			fillAmount = getDvarInt("codxe_lobbybots_target");
			fillMode = 1; // count bots only; the simulated lobby count is a bot target
		}
		else
			fillAmount = 18;
	}
	else if (!level.onlineGame && !level.splitScreen) // this is a LAN or system link game, fill with up to 8 bots to keep things interesting
		fillAmount = 8;
	else // this is either an online private game or a split screen game, these players likely don't want bots so we don't spawn any
		fillAmount = 0;

	setDvar("bots_manage_fill", fillAmount);
	
	botsTeam = getDVar("bots_team");
	doForceTeam = getDvarInt("bots_team_force");
	teamMode = getDvarInt("bots_team_mode");
	teamAmount = getDvarInt("bots_team_amount");
	
	var_allies_hard = getDVarInt("bots_skill_allies_hard");
	var_allies_med = getDVarInt("bots_skill_allies_med");
	var_axis_hard = getDVarInt("bots_skill_axis_hard");
	var_axis_med = getDVarInt("bots_skill_axis_med");
	
	allies_hard = 0;
	allies_med = 0;
	axis_hard = 0;
	axis_med = 0;
	
	axis = 0;
	allies = 0;
	
	bots = 0;
	players = 0;
	bots_waitFrame();
	
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		
		if(player bots_playerIsABot())
		{
			bots++;
			
			if(isDefined(player.pers["team"]))
			{
				if(player.pers["team"] == "axis")
				{
					axis++;
					
					if(level.bots_varSkill == 8)
					{
						if(axis_hard < var_axis_hard)
						{
							axis_hard++;
							player.pers["bots"]["skill"]["base"] = 6;
						}
						else if(axis_med < var_axis_med)
						{
							axis_med++;
							player.pers["bots"]["skill"]["base"] = 3;
						}
						else
							player.pers["bots"]["skill"]["base"] = 0;
					}
				}
				else if(player.pers["team"] == "allies")
				{
					allies++;
					
					if(level.bots_varSkill == 8)
					{
						if(allies_hard < var_allies_hard)
						{
							allies_hard++;
							player.pers["bots"]["skill"]["base"] = 6;
						}
						else if(allies_med < var_allies_med)
						{
							allies_med++;
							player.pers["bots"]["skill"]["base"] = 3;
						}
						else
							player.pers["bots"]["skill"]["base"] = 0;
					}
				}
			}
		}
		else
		{
			if(fillSpec || (isDefined(player.pers["team"]) && (player.pers["team"] == "axis" || player.pers["team"] == "allies")))
				players++;
			
			if(!teamMode && isDefined(player.pers["team"]))
			{
				if(player.pers["team"] == "axis")
					axis++;
				else if(player.pers["team"] == "allies")
					allies++;
			}
		}
	}
	if (fillMode == 4)
	{
		axisplayers = 0;
		alliesplayers = 0;
		
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			
			if(player bots_playerIsABot())
				continue;
			
			if(!isDefined(player.pers["team"]))
				continue;
			
			if(player.pers["team"] == "axis")
				axisplayers++;
			else if(player.pers["team"] == "allies")
				alliesplayers++;
		}
		
		result = fillAmount - abs(axisplayers - alliesplayers) + bots;
		
		if (players == 0)
		{
			if(bots < fillAmount)
				result = fillAmount-1;
			else if (bots > fillAmount)
				result = fillAmount+1;
			else
				result = fillAmount;
		}
		
		bots = result;
	}
	bots_waitFrame();
	
	if(fillMode == 0 || fillMode == 2)
		amount = bots + players;
	else
		amount = bots;
	
	if(amount < fillAmount)
		initTestClients(1);
	else if(amount > fillAmount && getDvarInt("bots_manage_fill_kick"))
	{
		tempBot = bots_getRandomBot();
		if(isDefined(tempBot))
			kick( tempBot getEntityNumber() );
	}
	bots_waitFrame();
	
	if(botsTeam == "custom")
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			
			if(!player bots_playerIsABot())
				continue;
			
			if(!isDefined(player.pers["team"]))
				continue;
			
			if(player.pers["team"] == "axis")
			{
				if(axis > teamAmount)
				{
					player thread bots_changeToTeamThread("allies");
					break;
				}
			}
			else
			{
				if(axis < teamAmount)
				{
					player thread bots_changeToTeamThread("axis");
					break;
				}
				else if(player.pers["team"] != "allies")
				{
					player thread bots_changeToTeamThread("allies");
					break;
				}
			}
		}
	}
	else if(doForceTeam)
	{
		if(botsTeam == "autoassign")
		{
			if(abs(axis - allies) > 1)
			{
				if(axis > allies)
				{
					for(i = 0; i < level.players.size; i++)
					{
						player = level.players[i];
						
						if(!player bots_playerIsABot())
							continue;
						
						if(!isDefined(player.pers["team"]) || player.pers["team"] == "allies")
							continue;
						
						player thread bots_changeToTeamThread("allies");
						break;
					}
				}
				else
				{
					for(i = 0; i < level.players.size; i++)
					{
						player = level.players[i];
						
						if(!player bots_playerIsABot())
							continue;
						
						if(!isDefined(player.pers["team"]) || player.pers["team"] == "axis")
							continue;
						
						player thread bots_changeToTeamThread("axis");
						break;
					}
				}
			}
		}
		else
		{
			for(i = 0; i < level.players.size; i++)
			{
				player = level.players[i];
				
				if(!player bots_playerIsABot())
					continue;
				
				if(!isDefined(player.pers["team"]) || player.pers["team"] == botsTeam)
					continue;
				
				player thread bots_changeToTeamThread(botsTeam);
			}
		}
	}
	bots_waitFrame();
}

bots_resetBots()
{
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		player notify("bot_reset");
		player freezecontrols(false);
		if(player bots_playerIsABot())
			player thread bots_resetBot();
	}
}
	
initTestClients(testclients)
{
	for(i = 0; i < testclients; i++)
	{
		ent[i] = addtestclient();

		if (isdefined(ent[i]))
		{
			ent[i].pers["isBot"] = true;
			ent[i].bots_fixOnce = 1;
			ent[i] thread bots_addedBot();
		}
		
		wait 0.25;
	}
}

bots_resetBot()
{
	self endon("bot_reset");
	self bots_changeToTeam("spectator");
	self thread bots_addedBot();
}

bots_watchDisconnect()
{
	self endon("bot_reset");
	self waittill("disconnect");
	self notify("bot_reset");
}

bots_addedBot()
{
	self thread bots_watchDisconnect();
	self endon("bot_reset");
	
	host = bots_getAHost();
	
	pres = 0;
	self setStat( int(tableLookup( "mp/playerStatsTable.csv", 1, "plevel", 0 )), pres );
	
	rank = getDvarInt("bots_main_experience");
    if( rank < 0 )
	{
		if(rank != -2 || !isDefined(host) || level.onlineGame )
			self setStat( int(tableLookup( "mp/playerStatsTable.csv", 1, "rankxp", 0 )), randomint(120281) );
		else
		{
			hostXP = host getStat( int(tableLookup( "mp/playerStatsTable.csv", 1, "rankxp", 0 )) );
			hostRank = maps\mp\gametypes\_rank::getRankForXp(hostXP);
			xp = 0;
			if(hostRank <= 9)
			{
				xp = hostXP + randomintrange(-1000, 1000);
				
				if(xp < 0)
					xp = 0;
			}
			else if(hostRank <= 19)
				xp = hostXP + randomintrange(-2500, 2500);
			else if(hostRank <= 29)
				xp = hostXP + randomintrange(-5000, 5000);
			else if(hostRank <= 39)
				xp = hostXP + randomintrange(-10000, 10000);
			else if(hostRank <= 49)
				xp = hostXP + randomintrange(-17500, 17500);
			else
				xp = hostXP + randomintrange(-20000, 20000);
			
			self setStat( int(tableLookup( "mp/playerStatsTable.csv", 1, "rankxp", 0 )), xp );
		}
	}
    else
		self setStat( int(tableLookup( "mp/playerStatsTable.csv", 1, "rankxp", 0 )), rank );
	
	self bots_initPersVars();
	self bots_traitAndSkill();
	
	self thread bots_StartBots();
	
	self bots_changeToTeam(getdvar("bots_team"));
}

bots_initNonPersVars()
{
	self.bots_fixOnce = 1;//multiround fix
	self.bots_atDeathLoc = false;//was at death loc
	self.bots_doing = "none";//bot's action
	self.bots_objDoing = "none";//extrnal obj stuff
	self.bots_aimDoing = "none";//extranal aim stuff
	self.bots_campingAngles = undefined;//camping angles
	self.bots_lastKS = 0;//how big was last ks before death
	self.bots_switchTime = false;//how long been since switched weapons anti switch spam
	self.bots_shootTime = false;//for anti semi spam
	self.bots_running = false;//tempVar(tm) if is running
	self.bots_runDelay = false;//tempvar delay after runnning
	self.bots_runTime = 0;//how much can run in time
	self.bots_camping = false;//is camping
	self.bots_realSeen = undefined;//target player
	self.bots_realEqu = undefined;//target equ
	self.bots_realTarKS = undefined;//target ks
	self.bots_lastSeen = [];//last real seen player in life
	self.bots_engageLimit = undefined;//if weapon has a distance limit
	
	self.bots_currentStaticWp = -1;//walking vars
	self.bots_tempwp = (0.0, 0.0, 0.0);
	self.bots_vObjectivePos = (0.0, 0.0, 0.0);
	self.bots_fMoveSpeed = 0.0;
	self.bots_stance = "stand";
	self.bots_lastStaticWP = -1;
	self.bots_targetWpIdx = -1;
	self.bots_secondNextWp = -1;
	
	self.bots_weap = "";
	self.bots_isAttached = "";
	self bots_clearStructs();
	
	self.bots_traitRandom = 0;//random trait every spawn
}

bots_initPersVars()
{
	self.pers["bots"]["class"]["primary"] = "";
	self.pers["bots"]["class"]["primaryCamo"] = 0;
	self.pers["bots"]["class"]["secondary"] = "";
	self.pers["bots"]["class"]["perk1"] = "";
	self.pers["bots"]["class"]["perk2"] = "";
	self.pers["bots"]["class"]["perk3"] = "";
	self.pers["bots"]["class"]["offhand"] = "";
	self.pers["bots"]["class"]["set"] = false;
	
	self.pers["bots"]["trait"]["vengeful"] = 0;//kill last person got killed by
	self.pers["bots"]["trait"]["talk"] = 0;//bot's personal talk amount
	self.pers["bots"]["trait"]["killsOverObj"] = 0;//loves to kill over obj
	self.pers["bots"]["trait"]["camp"] = 0;//how often to camp
	self.pers["bots"]["trait"]["follow"] = 0;//how often to follow
	self.pers["bots"]["trait"]["cfTime"] = 0.0;//how long to camp/follow
	self.pers["bots"]["trait"]["knife"] = 0;//how often to use knife
	self.pers["bots"]["trait"]["nade"] = 0;//how often to grenade
	self.pers["bots"]["trait"]["switch"] = 0;//how often to switch to offhand
	self.pers["bots"]["trait"]["rage"] = 0;//how often to ragequit
	self.pers["bots"]["trait"]["change"] = 0;//how often to change class
	self.pers["bots"]["trait"]["run"] = 0;//how often to run
	self.pers["bots"]["trait"]["asshole"] = 0;//force asshole trait
	self.pers["bots"]["trait"]["asshole_type"] = 0;//type of asshole

	self.pers["bots"]["skill"]["base"] = 0;//base skill level-more depth thinking 0 easy 6 hard dvar:0 random 1 easy 7 hard 8 custom 9 compRandom
	self.pers["bots"]["skill"]["viewDis"] = 0.0;//view distance
	self.pers["bots"]["skill"]["aimSpeed"] = 0;//aim speed
	self.pers["bots"]["skill"]["acc"] = 0;//accuracy
	self.pers["bots"]["skill"]["spawnWait"] = 0.0;//time to react when respawned
	self.pers["bots"]["skill"]["shootDelay"] = 0.0;//time to react with shooting (did you know this simple 'wait' was the very first spark to have me create my own bot mod?)
	self.pers["bots"]["skill"]["perfView"] = 0.0;//degrees in angle of puerperal vision
	self.pers["bots"]["skill"]["newTarg"] = 0.0;//how long to aim at new target
	self.pers["bots"]["skill"]["seenTime"] = 0;//how long to remember target seen
}

bots_traitAndSkill()
{
	self.pers["bots"]["trait"]["vengeful"] = randomint(3);
	self.pers["bots"]["trait"]["killsOverObj"] = randomint(3);
	self.pers["bots"]["trait"]["camp"] = RandomIntRange(300,1500);
	self.pers["bots"]["trait"]["follow"] = RandomIntRange(600,1500);
	self.pers["bots"]["trait"]["cfTime"] = RandomFloatRange(30,90);
	self.pers["bots"]["trait"]["knife"] = randomint(3);
	self.pers["bots"]["trait"]["nade"] = 400;
	self.pers["bots"]["trait"]["switch"] = 125;
	self.pers["bots"]["trait"]["rage"] = randomInt(15);
	self.pers["bots"]["trait"]["run"] = randomintrange(100,250);
	self.pers["bots"]["trait"]["change"] = randomint(25);
	self.pers["bots"]["trait"]["talk"] = randomintrange(-5, 5);

	if(randomInt(10) == 2)
	{
		self.pers["bots"]["trait"]["asshole"] = 1;
		self.pers["bots"]["trait"]["asshole_type"] = randomIntRange(1, 5);
	}

	if(self.pers["bots"]["trait"]["asshole"])
	{
		self.pers["bots"]["skill"]["base"] = 6;
		self.pers["bots"]["skill"]["viewDis"] = 9999.9;
		self.pers["bots"]["skill"]["aimSpeed"] = 1;
		self.pers["bots"]["skill"]["acc"] = 1;
		self.pers["bots"]["skill"]["spawnWait"] = 0.05;
		self.pers["bots"]["skill"]["shootDelay"] = 0.0;
		self.pers["bots"]["skill"]["perfView"] = 0.45;
		self.pers["bots"]["skill"]["newTarg"] = 0.0;
		self.pers["bots"]["skill"]["seenTime"] = 10000;
		return;
	}
	
	if(!level.bots_varSkill)
	{
		switch(randomint(25))
		{
			case 0:
			case 10:
				self.pers["bots"]["skill"]["base"] = 0;
			break;
			case 1:
			case 11:
			case 2:
			case 12:
			case 23:
				self.pers["bots"]["skill"]["base"] = 1;
			break;
			case 3:
			case 13:
			case 18:
			case 24:
				self.pers["bots"]["skill"]["base"] = 2;
			break;
			case 14:
			case 15:
			case 16:
			case 17:
			case 22:
			case 4:
			case 5:
			case 6:
				self.pers["bots"]["skill"]["base"] = 3;
			break;
			case 7:
			case 19:
			case 21:
				self.pers["bots"]["skill"]["base"] = 4;
			break;
			case 8:
			case 20:
				self.pers["bots"]["skill"]["base"] = 5;
			break;
			case 9:
				self.pers["bots"]["skill"]["base"] = 6;
			break;
		}
	}
	else
	{
		if(level.bots_varSkill == 9)
		{
			self.pers["bots"]["skill"]["base"] = randomint(7);
			self.pers["bots"]["skill"]["viewDis"] = RandomFloatRange(500,10000);
			self.pers["bots"]["skill"]["aimSpeed"] = RandomIntRange(2,9);
			self.pers["bots"]["skill"]["acc"] = RandomIntRange(1,8);
			self.pers["bots"]["skill"]["spawnWait"] = RandomFloatRange(0.05, 1.5);
			self.pers["bots"]["skill"]["shootDelay"] = RandomFloatRange(0, 1.5);
			self.pers["bots"]["skill"]["perfView"] = RandomFloatRange(0.5,0.95);
			self.pers["bots"]["skill"]["newTarg"] = RandomFloatRange(0,1.5);
			self.pers["bots"]["skill"]["seenTime"] = RandomIntRange(0,7500);
		}
	}
}

bots_StartBots()
{
	self bots_initNonPersVars();
	
	if(level.gameEnded)
		return;
	
	self thread bots_onBotEnd();
	self thread bots_onBotKill();
	self thread bots_onBotSpawn();
	self thread bots_onBotDeath();
	self thread bots_doSkill();
	
	self thread bots\Talk::Bots_TalkBegin();
}

bots_onWeapChange()
{
	self endon("bot_reset");
	self endon("death");
	while(1)
	{
		self waittill( "weapon_change", newWeapon );
		
		if(!isSubStr(newWeapon, level.bots_animWeapSubStr) && newWeapon != "none" && newWeapon != "" && self bots_getCurrentWeapon() != newWeapon)
			self bots_setspawnweapon(newWeapon);//fixes when bots pick up a weapon from ground
	}
}

bots_onReload()
{
	self endon("bot_reset");
	self endon("death");
	for(;;)
	{
		self waittill("reload");
		
		weap = self getCurrentWeapon();
		if(isDefined(self.bots_devWalk[weap]))
		{
			self.bots_devWalk[weap].stock = int(max(0, self.bots_devWalk[weap].stock - WeaponClipSize(weap)));
			self.bots_devWalk[weap].clip = WeaponClipSize(weap);
		}
	}
}

bots_onBotEnd()
{
	self endon("bot_reset");
	
	level waittill ( "game_ended" );
	
	self thread bots\talk::Bots_TalkEndGame();
	
	if(isAlive(self))
	{
		if(self.bots_isAttached != "")
		{
			self detach(getWeaponModel(self.bots_isAttached), "TAG_WEAPON_RIGHT", true);
			self.bots_isAttached = "";
		}
		
		weapon = self getCurrentWeapon();
		if(isSubStr(weapon, level.bots_animWeapSubStr))
		{
			self takeWeapon(weapon);
			self setspawnweapon(self.bots_weap);
		}
	}
	self botStop();
	self freezecontrols(true);
	
	self.pers["isBot"] = true;//because nonbots testclients gets kicked on connect
	self.pers["isBotWarfare"] = undefined;
	
	if(level.bots_varPlayQuit && bots_randomInt(self.pers["bots"]["trait"]["rage"]) == 4 && randomint(2))
		kick(self getEntityNumber());
	
	self notify("bot_reset");
}

bots_onBotSpawn()
{
	self endon("bot_reset");
	
	for(;;)
	{
		self waittill("spawned_player");
		
		self thread bots\bots_class::bots_doClass();
		
		self.bots_traitRandom = randomint(6);
	
		self.bots_running = false;
		self.bots_runTime = getdvarfloat("scr_player_sprinttime");
		self.bots_doing = "none";
		self.bots_aimDoing = "none";
		self.bots_campingAngles = undefined;
		self.bots_objDoing = "none";
		self.bots_shootTime = false;
		self.bots_switchTime = false;
		self.bots_runDelay = false;
		self.bots_camping = false;
		self.bots_realSeen = undefined;
		self.bots_realEqu = undefined;
		self.bots_realTarKS = undefined;
		self.bots_lastSeen = [];
		
		self.bots_currentStaticWp = -1;
		self.bots_tempwp = (0.0, 0.0, 0.0);
		self.bots_vObjectivePos = (0.0, 0.0, 0.0);
		self.bots_fMoveSpeed = 0.0;
		self.bots_stance = "stand";
		self.bots_lastStaticWP = -1;
		self.bots_targetWpIdx = -1;
		self.bots_secondNextWp = -1;
		
		self botStop();
		self botAction("+gostand");
		
		self.bots_isAttached = "";
		
		self.bots_lastKS = 0;
		
		self thread bots_doBotSpawn();
	}
}

bots_onBotDeath()
{
	self endon("bot_reset");
	for(;;)
	{
		self waittill("death");
		
		if(self.bots_isAttached != "")
		{
			self detach(getWeaponModel(self.bots_isAttached), "TAG_WEAPON_RIGHT", true);
			self.bots_isAttached = "";
		}
		
		self botStop();
		
		if(level.bots_varPlayQuit && (self.kills - self.deaths) < -5 && bots_randomInt(self.pers["bots"]["trait"]["rage"]) == 2 && self.cur_death_streak > 4 && randomint(2))
		{
			//doragequit - thanks to idea from rse v20
			self bots\talk::bots_Rage();
			wait randomint(4);
			kick(self getEntityNumber());
		}
		
		wait 0.05;//so lastAttacker gets updated because fatal frame of "damage" is same frame as "death"
		//dont worry "death" notify can't be called again until another 1.5 seconds at least
		if(isDefined(self.lastAttacker))
		{
			self.bots_atDeathLoc = false;
		
			self thread bots\talk::Bots_Talkdead();
		}
	}
}

bots_onBotKill()
{
	self endon("bot_reset");
	for(;;)
	{
		self waittill( "killed_enemy" );
		
		if(isDefined(self.lastKilledPlayer))
		{
			killLoc = self.lastKilledPlayer getOrigin();
			if(self bots\bots_walk::bots_shouldGetObj() && distance(killLoc, self.origin) < 500.0 && !randomInt(100))
				self thread bots\bots_walk::bots_goToLocAndTBag(killLoc);
			
			self thread bots\Talk::Bots_TalkKilled();
		}
		
		if(self.bots_lastKS < self.cur_kill_streak)
		{
			for(i=self.bots_lastKS+1;i<=self.cur_kill_streak;i++)
			{
				self thread bots\talk::bots_onGotStreak(i);
			}
		}
		
		self.bots_lastKS = self.cur_kill_streak;
	}
}

bots_doSkill()
{
	self endon("bot_reset");
	
	for(;;)
	{
		switch(level.bots_varSkill)
		{
			case 1:
				self.pers["bots"]["skill"]["base"] = 0;
			break;
			case 2:
				self.pers["bots"]["skill"]["base"] = 1;
			break;
			case 3:
				self.pers["bots"]["skill"]["base"] = 2;
			break;
			case 4:
				self.pers["bots"]["skill"]["base"] = 3;
			break;
			case 5:
				self.pers["bots"]["skill"]["base"] = 4;
			break;
			case 6:
				self.pers["bots"]["skill"]["base"] = 5;
			break;
			case 7:
				self.pers["bots"]["skill"]["base"] = 6;
			break;
		}
		if(level.bots_varSkill != 9)
		{
			switch(self.pers["bots"]["skill"]["base"])
			{
				case 0://easy
					self.pers["bots"]["skill"]["viewDis"] = 1000.0;
					self.pers["bots"]["skill"]["aimSpeed"] = 8;
					self.pers["bots"]["skill"]["acc"] = 7;
					self.pers["bots"]["skill"]["spawnWait"] = 1.0;
					self.pers["bots"]["skill"]["shootDelay"] = 1.0;
					self.pers["bots"]["skill"]["perfView"] = 0.85;
					self.pers["bots"]["skill"]["newTarg"] = 1.0;
					self.pers["bots"]["skill"]["seenTime"] = 0;
				break;
				case 1:
					self.pers["bots"]["skill"]["viewDis"] = 1500.0;
					self.pers["bots"]["skill"]["aimSpeed"] = 7;
					self.pers["bots"]["skill"]["acc"] = 6;
					self.pers["bots"]["skill"]["spawnWait"] = 0.75;
					self.pers["bots"]["skill"]["shootDelay"] = 0.75;
					self.pers["bots"]["skill"]["perfView"] = 0.8;
					self.pers["bots"]["skill"]["newTarg"] = 0.75;
					self.pers["bots"]["skill"]["seenTime"] = 1500;
				break;
				case 2:
					self.pers["bots"]["skill"]["viewDis"] = 2250.0;
					self.pers["bots"]["skill"]["aimSpeed"] = 6;
					self.pers["bots"]["skill"]["acc"] = 5;
					self.pers["bots"]["skill"]["spawnWait"] = 0.666;
					self.pers["bots"]["skill"]["shootDelay"] = 0.666;
					self.pers["bots"]["skill"]["perfView"] = 0.75;
					self.pers["bots"]["skill"]["newTarg"] = 0.666;
					self.pers["bots"]["skill"]["seenTime"] = 2000;
				break;
				case 3://med
					self.pers["bots"]["skill"]["viewDis"] = 2750.0;
					self.pers["bots"]["skill"]["aimSpeed"] = 5;
					self.pers["bots"]["skill"]["acc"] = 4;
					self.pers["bots"]["skill"]["spawnWait"] = 0.5;
					self.pers["bots"]["skill"]["shootDelay"] = 0.5;
					self.pers["bots"]["skill"]["perfView"] = 0.7;
					self.pers["bots"]["skill"]["newTarg"] = 0.5;
					self.pers["bots"]["skill"]["seenTime"] = 2666;
				break;
				case 4:
					self.pers["bots"]["skill"]["viewDis"] = 4000.0;
					self.pers["bots"]["skill"]["aimSpeed"] = 4;
					self.pers["bots"]["skill"]["acc"] = 3;
					self.pers["bots"]["skill"]["spawnWait"] = 0.333;
					self.pers["bots"]["skill"]["shootDelay"] = 0.25;
					self.pers["bots"]["skill"]["perfView"] = 0.65;
					self.pers["bots"]["skill"]["newTarg"] = 0.333;
					self.pers["bots"]["skill"]["seenTime"] = 4000;
				break;
				case 5:
					self.pers["bots"]["skill"]["viewDis"] = 6000.0;
					self.pers["bots"]["skill"]["aimSpeed"] = 3;
					self.pers["bots"]["skill"]["acc"] = 2;
					self.pers["bots"]["skill"]["spawnWait"] = 0.25;
					self.pers["bots"]["skill"]["shootDelay"] = 0.1;
					self.pers["bots"]["skill"]["perfView"] = 0.6;
					self.pers["bots"]["skill"]["newTarg"] = 0.25;
					self.pers["bots"]["skill"]["seenTime"] = 5000;
				break;
				case 6://hard
					self.pers["bots"]["skill"]["viewDis"] = 9999.9;
					self.pers["bots"]["skill"]["aimSpeed"] = 2;
					self.pers["bots"]["skill"]["acc"] = 1;
					self.pers["bots"]["skill"]["spawnWait"] = 0.05;
					self.pers["bots"]["skill"]["shootDelay"] = 0.0;
					self.pers["bots"]["skill"]["perfView"] = 0.55;
					self.pers["bots"]["skill"]["newTarg"] = 0.0;
					self.pers["bots"]["skill"]["seenTime"] = 6666;
				break;
			}
		}
		
		wait 1.5;
	}
}

bots_doBotSpawn()
{
	self endon("bot_reset");
	self endon("death");
	
	self thread bots_claymoreFix();
	self thread bots_UseRunThink();
	self thread bots_onReload();
	self thread bots_onWeapChange();
	
	self botStop();
	self freezecontrols(true);
	while(level.inPrematchPeriod)
		bots_waitFrame();
	self freezecontrols(true);
	
	wait self.pers["bots"]["skill"]["spawnWait"];
	// Bots now move through real usercmd input, so unfreeze controls once active.
	self freezeControls(false);

	if(self.pers["bots"]["trait"]["asshole"] && self.pers["bots"]["trait"]["asshole_type"] == 2)
		self setMoveSpeedScale(1.2);
	
	self thread bots_ThinkToRun();
	self thread bots\bots_aim::bots_MainAimbot();
	self thread bots\bots_killstreak::bots_watchUseKillStreak();
	self thread bots\bots_anim::bots_useAnims();
	self thread bots\bots_walk::bots_getObj();
	self thread bots\bots_walk::bots_doMovement();
	self thread bots\bots_walk::bots_dostuck();
	self thread bots_throwback();
	self thread bots_speedPerkFeetSound();
}

bots_UseRunThink()
{
	self endon("death");
	self endon("bot_reset");
	for(;;)
	{
		if(self.bots_running)
		{
			if(self hasPerk("specialty_longersprint"))
				self.bots_runTime = self.bots_runTime - 0.025;
			else
				self.bots_runTime = self.bots_runTime - 0.05;
		}
		else
		{
			if(self.bots_runTime < getdvarfloat("scr_player_sprinttime"))
				self.bots_runTime = self.bots_runTime + 0.05;
		}
		wait 0.05;
	}
}

bots_claymoreFix()
{
	self endon("bot_reset");
	self endon("death");
	for(;;)
	{
		if(self.bots_fMoveSpeed >= 0.25)
		{
			grenades = getEntArray( "grenade", "classname" );
			myEye = self bots_getEyePos();
			for(i = 0; i < grenades.size; i++)
			{
				grenade = grenades[i];

				if(!isDefined(grenade.weaponName) || grenade.weaponName != "claymore_mp")
					continue;
				if(isDefined(grenade.owner) && grenade.owner == self)
					continue;
				if(grenade.team == self.pers["team"] && level.teamBased)
					continue;
				if(distance(self.origin, grenade.origin) > level.claymoreDetonateRadius)
					continue;
				if(!bulletTracePassed(myEye, grenade.origin, false, grenade ))
					continue;
				if(!self maps\mp\gametypes\_weapons::shouldAffectClaymore( grenade ))
					continue;
				
				grenade thread bots_doCaboom();
			}
		}
		wait 1;
	}
}

bots_doCaboom()
{
	self endon("death");
	
	self playsound ("claymore_activated");
	
	wait level.claymoreDetectionGracePeriod;
	
	self maps\mp\_entityheadicons::setEntityHeadIcon("none");
	self detonate();
}

bots_doReload(weap)
{
	self endon("bot_reset");
	self endon("death");
	self.bots_doing = "reload";
	
	self botAction("+reload");
	wait 0.2;
	self botAction("-reload");
	
	// Wait for reload to actually finish (anim time)
	while(self bots_getCurrentWeapon() == weap && self hasWeapon(weap) && !self bots_getWeaponAmmoClip(weap) && self bots_getWeaponAmmoStock(weap))
	{
		bots_waitFrame();
	}
	
	self.bots_doing = "none";
	
	self bots\bots_aim::bots_stopShooting();
}

bots_speedPerkFeetSound()
{
	self endon("bot_reset");
	self endon("death");
	for(;;)
	{
		currentWeapon = self bots_getCurrentWeapon();
		weapClass = weaponClass(currentWeapon);
		
		acc = self.pers["bots"]["skill"]["acc"];
		
		switch(weapClass)
		{
			case "sniper":
				if((acc - 2) > 0)
					acc = acc - 2;
				else
					acc = 1;
			break;
			case "spread":
				acc = acc + 2;
			break;
		}
		self setspreadoverride(acc);
		
		if(self bots_doingNothing() && currentWeapon != "" && currentWeapon != "none" && !isDefined(level.bots_devWalk[currentWeapon]) && !self bots_getWeaponAmmoClip(currentWeapon) && self bots_getWeaponAmmoStock(currentWeapon))
		{
			self thread bots_doReload(currentWeapon);
		}
		
		if(isDefined( self.lastStand ))
		{
			self.bots_fMoveSpeed = 0.0;
			if(weapClass != "pistol")
			{
				self.bots_doing = "switch";
				
				sec = self bots_tryGetGoodWeap(self bots_getSecondariesName());
				if(!isDefined(sec) || weaponClass(sec) != "pistol")
				{
					self bots_setSpawnWeapon("beretta_mp");
				}
				else
				{
					self bots_setSpawnWeapon(sec);
				}
				self bots\bots_aim::bots_stopShooting();
				
				wait 1;
				self.bots_doing = "none";
			}
		}
		else
		{
			if(self.bots_camping)
			{
				self botAction("+gocrouch");
			}
			else
			{
				if(!isDefined(level.waypoints[self.bots_currentStaticWp]) || level.waypoints[self.bots_currentStaticWp].type == "stand")
				{
					switch(randomint(20))
					{
						case 0:
							if(!self.bots_running)
								self botAction("+gocrouch");
						break;
						case 1:
							if(!self.bots_running)
								self botAction("+gocrouch");
						break;
						/*case 0:
							if(isdefined(self.bots_RealSeen) && self.bots_traitRandom == 1 && self.pers["bots"]["skill"]["base"] >= 2)
							{
								self botAction("+goprone");//drop shot
								self.bots_fMoveSpeed = 0.0;
								wait 1.5;
							}
							else
							{
								self botAction("+gostand");
							}
						break;*/
						default:
							self.bots_stance = "stand";
						break;
					}
				}
				else
				{
					if(level.waypoints[self.bots_currentStaticWp].type == "crouch")
						self.bots_stance = "crouch";
					else if(level.waypoints[self.bots_currentStaticWp].type == "prone")
						self.bots_stance = "prone";
					else
						self.bots_stance = "stand";
				}
			}
			
			if(!self bots\bots_walk::bots_CanMove())
			{
				self.bots_fMoveSpeed = 0.0;
			}
			else
			{
				canMakeFootSound = (!self hasPerk("specialty_quieter") && level.bots_varPlayFoot);
				trace = undefined;
				if(canMakeFootSound)
				{
					myOg = self getOrigin();
					trace = bullettrace( myOg, myOg + (0.0, 0.0, -5.0), false, self );
					
					// These are deliberately synthesized footstep sounds, so only play
					// them when the game physics reports actual bot movement.
					if(trace[ "surfacetype" ] == "none" || self.bots_fMoveSpeed < 0.05 || lengthsquared(self getVelocity()) < 100)
						canMakeFootSound = false;
				}
				
				if(self bots\bots_aim::bots_isClimbing())
				{
					self.bots_fMoveSpeed = 4.0;
					
					if(canMakeFootSound)
						self playSound( "step_run_metal" );
				}
				else
				{
					if(self bots\bots_aim::bots_IsStunned() || self bots\bots_aim::bots_isArtShocked())
					{
						switch( self.bots_stance )
						{
							case "stand":
								self.bots_fMoveSpeed = 2.5;
							break;
							case "crouch":
								self.bots_fMoveSpeed = 1.0;
							break;
							case "prone":
								self.bots_fMoveSpeed = 0.5;
							break;
						}
					}
					else
					{
						switch( self.bots_stance )
						{
							case "stand":
								if(self.bots_running)
								{
									self.bots_fMoveSpeed = 15.0;
									if(canMakeFootSound)
									{
										self playSound( "step_sprint_" + trace[ "surfacetype" ] );
										self thread bots_playSprintSound( "step_sprint_" + trace[ "surfacetype" ] );
									}
								}
								else
								{
									self.bots_fMoveSpeed = 10.0;
									if(canMakeFootSound)
										self playSound( "step_run_" + trace[ "surfacetype" ] );
								}
							break;
							case "crouch":
								self.bots_fMoveSpeed = 5.0;
								if(canMakeFootSound)
									self playSound( "step_walk_" + trace[ "surfacetype" ] );
							break;
							case "prone":
								self.bots_fMoveSpeed = 2.5;
								if(canMakeFootSound)
									self playSound( "step_prone_" + trace[ "surfacetype" ] );
							break;
						}
					}
				}
				
				if(self.bots_firing)
					self.bots_fMoveSpeed *= 0.5;
				
				self.bots_fMoveSpeed = self.bots_fMoveSpeed*(getdvarfloat("g_speed")/190.0);
				self.bots_fMoveSpeed = self bots_UpdateSpeed(weapClass);
				self.bots_fMoveSpeed = self.bots_fMoveSpeed*level.bots_moveSpeedBase;
			}
		}
		
		wait 0.333;
	}
}

bots_UpdateSpeed(weapClass)
{
	switch ( weapClass )
	{
		case "rifle":
			return self.bots_fMoveSpeed*0.95;
		case "pistol":
			return self.bots_fMoveSpeed;
		case "mg":
			return self.bots_fMoveSpeed*0.875;
		case "smg":
			return self.bots_fMoveSpeed;
		case "spread":
			return self.bots_fMoveSpeed;
		default:
			return self.bots_fMoveSpeed;
	}
}

bots_playSprintSound(sound)
{
	self endon("bot_reset");
	self endon("death");
	
	wait 0.1665;
	self playSound( sound );
}

bots_ThinkToRun()
{
	self endon("death");
	self endon("bot_reset");
	for(;;)
	{
		if(self.bots_running && self.bots_runDelay)
		{
			if(self bots_botFoundTarget() || self.bots_runTime <= 0 || self.bots_camping || !self bots_doingNothing() || bots_randomInt(self.pers["bots"]["trait"]["run"]) == 149 || self.bots_stance != "stand" || isDefined( self.lastStand ) || self bots\bots_aim::bots_isShellShocked())
			{
				self.bots_running = false;
				wait 0.5;
				self.bots_runDelay = false;
			}
		}
		else
		{
			if(level.bots_varPlayRun && self.bots_runTime > 1.5 && bots_randomInt(int(self.pers["bots"]["trait"]["run"]/2)) == 2 && !self bots_botFoundTarget() && !self.bots_camping && self bots_doingNothing() && self.bots_stance == "stand" && !isDefined( self.lastStand ) && !self bots\bots_aim::bots_isShellShocked())
			{
				self.bots_running = true;
				self.bots_runDelay = true;
			}
		}
		bots_waitFrame();
	}
}

bots_throwback()
{
	self endon("bot_reset");
	self endon("death");
	for(;;)
	{
		if(level.bots_varLoadoutNade && level.bots_varPlayTB && level.bots_fragList.size && self bots\bots_aim::bots_canSwitch())
		{
			myEye = self bots_getEyePos();
			for(i = 0; i < level.bots_fragList.size; i++)
			{
				frag = level.bots_fragList[i];
				
				if(isDefined(frag.bots_throwback))
					continue;
				if(!isDefined(frag.nade))
					continue;
				if(isDefined(frag.owner) && frag.owner == self)
					continue;
				if(self.pers["team"] == frag.team && level.teamBased)
					continue;
				if(distance(self.origin, frag.nade.origin) > 100.0)
					continue;
				if(!bulletTracePassed( myEye, frag.nade.origin, false, frag.nade ))
					continue;
				
				self bots_doThrowback(frag);
				break;
			}
		}
		wait 1;
	}
}

bots_doThrowback(frag)
{
	self endon("bot_kill_nade");
	
	self.bots_doing = "nade_fire";
	lastWeapon = self bots_getCurrentWeapon();
	
	frag.bots_throwback = true;
	
	self thread bots\talk::bots_throwBack(frag);
	
	hadFrag = self bots_getAmmoCount("frag_grenade_mp");

	self bots_setWeaponAmmoClip("frag_grenade_mp", 1);
	
	self bots_setspawnweapon("frag_grenade_mp");
	
	self thread bots_freeNadeOnDeath(frag);
	self thread bots_doNoneOnFragFire(lastWeapon, hadFrag, frag);
	self thread bots\bots_aim::bots_forceGNadeFire();
	
	for(i=0;i<9;i++)
	{
		wait 0.5;
		
		if(self bots_getCurrentWeapon() != "frag_grenade_mp")
			self bots_setspawnweapon("frag_grenade_mp");
	}
	
	self bots_setWeaponAmmoClip("frag_grenade_mp", hadFrag);
	
	self bots_setspawnweapon(lastWeapon);
	frag.bots_throwback = undefined;
	
	self.bots_doing = "none";
	self notify("bot_kill_nade");
}

bots_doNoneOnFragFire(lastWeapon, hadFrag, frag)
{
	self endon("bot_kill_nade");
	self endon("bot_reset");
	
	self waittill("grenade_fire", grenade, weapname);
	if(isSubStr(weapname, "frag_"))
	{
		alive = isAlive(self);
		if(alive && isDefined(frag.nade) && distance(self.origin, frag.nade.origin) <= 100.0)
		{
			grenade.owner = self;
			grenade.threwBack = true;
			grenade thread maps\mp\gametypes\_shellshock::grenade_earthQuake();
			grenade.originalOwner = frag.owner;
			
			self bots_setWeaponAmmoClip("frag_grenade_mp", hadFrag);
			
			self bots_setspawnweapon(lastWeapon);
			self thread bots\talk::bots_thrownBack(frag);
			frag.nade delete();
			self.bots_doing = "none";
		}
		else
		{
			if(isDefined(frag))
				frag.bots_throwback = undefined;
			grenade delete();
			
			if(alive)
			{
				self bots_setWeaponAmmoClip("frag_grenade_mp", hadFrag);
				
				self.bots_doing = "none";
				self bots_setspawnweapon(lastWeapon);
			}
		}
	}
	
	self notify("bot_kill_nade");
}

bots_freeNadeOnDeath(frag)
{
	self endon("bot_kill_nade");
	self bots_waittill_either("bot_reset", "death");
	frag.bots_throwback = undefined;
	
	wait 1;
	self notify("bot_kill_nade");
}

bots_onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);
		
		DvarGUID = getDvar("bots_main_GUIDs");
		DvarName = getDvar("bots_main_Names");
		
		if(!isDefined(player.pers["bots_isHost"]))
			player.pers["bots_isHost"] = false;
		
		result = false;
		if(DvarGUID != "")
		{
			GUIDs = strtok(DvarGUID, ",");
			for(i = 0; i < GUIDs.size; i++)
			{
				guid = GUIDs[i];
				if(player getGuid() == guid)//pb is dead so no guids
					result = true;
			}
		}
		if(DvarName != "")
		{
			Names = strtok(DvarName, ",");
			for(i = 0; i < Names.size; i++)
			{
				name = Names[i];
				if(player.name == name)
					result = true;
			}
		}
		
		if(result)
			player.pers["bots_isHost"] = true;
		
		if(!isDefined(game["bots_firstHost"]) && !player bots_playerIsABot())//iw3 has no isHost()
		{
			if(getDVarInt("bots_main_firstIsHost"))
				player.pers["bots_isHost"] = true;
			
			game["bots_firstHost"] = true;
		}
		player thread bots\menu::playerConnected();
		
		player thread bots_watchFireGun();
		player thread bots_watchNade();
		player thread bots_onDamage();
		player thread bots_onDeath();
		
		if(player bots_playerIsABot())
		{
			player.pers["isBot"] = undefined;
			player.pers["isBotWarfare"] = true;
			
			if(!isDefined(player.bots_fixOnce))
			{
				player.bots_fixOnce = 1;
				player notify("bot_reset");
				player thread bots_watchDisconnect();
				player thread bots_StartBots();
			}
		}
	}
}

bots_onDeath()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill ( "death" );
		
		self.attackersTimes = [];
		self.lastDeathPos = self.origin;
		wait 0.05;//so lastAttacker gets updated
		if(isDefined(self.lastAttacker))
			self.lastAttacker notify("killed_enemy");
	}
}

bots_onDamage()
{
	self endon("disconnect");
	
	self.attackersTimes = [];
	for(;;)
	{
		self waittill ( "damage", damage, eInflictor );
		if(isDefined(eInflictor.owner))
			attacker = eInflictor.owner;
		else
			attacker = eInflictor;
		
		if(isDefined(attacker) && isPlayer(attacker))
		{
			attacker.lastKilledPlayer = self;
			self.lastAttacker = attacker;
			
			sumTime = getTime();
			if(isAlive(self) && isPlayer(eInflictor) && (!isDefined(self.explosiveInfo["damageTime"]) || (sumTime != self.explosiveInfo["damageTime"] + 50)))
				self.attackersTimes[attacker getEntityNumber()] = sumTime;
		}
	}
}

bots_watchNade()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill ( "grenade_fire", grenade, weaponName );
		if(weaponName == "smoke_grenade_mp")
		{
			grenade thread bots_AddToSmokeList();
		}
		else if(isSubStr(weaponName, "frag_"))
		{
			grenade thread bots_AddToFragList(self);
		}
		else if(isSubStr(weaponName, "c4_") || isSubStr(weaponName, "claymore_"))
		{
			grenade.weaponName = weaponName;
			grenade.team = self.team;
			grenade.owner = self;
		}
	}
}

bots_AddToFragList(owner)
{
	index = level.bots_fragList.size;
	level.bots_fragList[index] = spawnstruct();
	level.bots_fragList[index].nade = self;
	level.bots_fragList[index].throwback = undefined;
	level.bots_fragList[index].owner = owner;
	level.bots_fragList[index].team = owner.team;
	level.bots_fragList[index] thread bots_thinkFrag();
}

bots_thinkFrag()
{
	while(isDefined(self.nade))
		bots_waitFrame();
	bots_removeFragNade(self);
}

bots_SmokeTrace(start, end, rad)
{
	if(level.bots_smokeList.size)
	{
		for(i = 0; i < level.bots_smokeList.size; i++)
		{
			nade = level.bots_smokeList[i];
			if(nade.state != "smoking")
				continue;
			if(!bots_RaySphereIntersect(start, end, nade.origin, rad))
				continue;
			
			return false;
		}
	}
	return true;
}

bots_AddToSmokeList()
{
	index = level.bots_smokeList.size;
	level.bots_smokeList[index] = spawnstruct();
	level.bots_smokeList[index].origin = self getOrigin();
	level.bots_smokeList[index].state = "moving";
	level.bots_smokeList[index] thread bots_thinkSmoke(self);
}

bots_thinkSmoke(gnade)
{
	while(isDefined(gnade))
	{
		self.origin = gnade getOrigin();
		self.state = "moving";
		bots_waitFrame();
	}
	self.state = "smoking";
	wait 11.5;
	
	bots_removeSmokeNade(self);
}

bots_removeSmokeNade(nade)
{
	for ( entry = 0; entry < level.bots_smokeList.size; entry++ )
	{
		if ( level.bots_smokeList[entry] == nade )
		{
			while ( entry < level.bots_smokeList.size-1 )
			{
				level.bots_smokeList[entry] = level.bots_smokeList[entry+1];
				entry++;
			}
			level.bots_smokeList[entry] = undefined;
			break;
		}
	}
}

bots_removeFragNade(nade)
{
	for ( entry = 0; entry < level.bots_fragList.size; entry++ )
	{
		if ( level.bots_fragList[entry] == nade )
		{
			while ( entry < level.bots_fragList.size-1 )
			{
				level.bots_fragList[entry] = level.bots_fragList[entry+1];
				entry++;
			}
			level.bots_fragList[entry] = undefined;
			break;
		}
	}
}

bots_RaySphereIntersect(start, end, spherePos, radius)
{
   dp = end - start;
   a = dp[0] * dp[0] + dp[1] * dp[1] + dp[2] * dp[2];
   b = 2 * (dp[0] * (start[0] - spherePos[0]) + dp[1] * (start[1] - spherePos[1]) + dp[2] * (start[2] - spherePos[2]));
   c = spherePos[0] * spherePos[0] + spherePos[1] * spherePos[1] + spherePos[2] * spherePos[2];
   c += start[0] * start[0] + start[1] * start[1] + start[2] * start[2];
   c -= 2.0 * (spherePos[0] * start[0] + spherePos[1] * start[1] + spherePos[2] * start[2]);
   c -= radius * radius;
   bb4ac = b * b - 4.0 * a * c;
//   if(ABS(a) < 0.0001 || bb4ac < 0) 
   if(bb4ac < 0) 
   {
//      *mu1 = 0;
//      *mu2 = 0;
     return false;
   }

//   *mu1 = (-b + sqrt(bb4ac)) / (2 * a);
//   *mu2 = (-b - sqrt(bb4ac)) / (2 * a);

   return true;
}

bots_onUAVAxis()
{
	for(;;)
	{
		level waittill( "radar_timer_kill_axis" );
		level thread bots_doUAV("axis");
	}
}

bots_onUAVAllies()
{
	for(;;)
	{
		level waittill( "radar_timer_kill_allies" );
		level thread bots_doUAV("allies");
	}
}

bots_doUAV(team)
{
	level endon("radar_timer_kill_" + team);
	
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		
		if(player.team == team)
		{
			player.hasRadar = true;
		}
	}
	
	wait level.radarViewTime;
	
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		
		if(player.team == team)
		{
			player.hasRadar = false;
		}
	}
}

bots_watchFireGun()
{
	self endon("disconnect");
	self.bots_firing = false;
	for(;;)
	{
		self waittill( "weapon_fired" );
		self thread bots_doFiringThread();
	}
}

bots_doFiringThread()
{
	self endon("disconnect");
	self endon("weapon_fired");
	self.bots_firing = true;
	wait 1;
	self.bots_firing = false;
}