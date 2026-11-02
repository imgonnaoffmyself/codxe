#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

bots_loadWaypoints()
{
	level.waypoints = [];
	
	mapname = getDvar("mapname");
	switch(mapname)//structs are not persistant in iw3...
	{
		case "mp_convoy":
			level.waypoints = bots\waypoints\Ambush::Ambush();
		break;
		case "mp_backlot":
			level.waypoints = bots\waypoints\Backlot::Backlot();
		break;
		case "mp_bloc":
			level.waypoints = bots\waypoints\Bloc::Bloc();
		break;
		case "mp_bog":
			level.waypoints = bots\waypoints\Bog::Bog();
		break;
		case "mp_countdown":
			level.waypoints = bots\waypoints\Countdown::Countdown();
		break;
		case "mp_crash":
		case "mp_crash_snow":
			level.waypoints = bots\waypoints\Crash::Crash();
		break;
		case "mp_crossfire":
			level.waypoints = bots\waypoints\Crossfire::Crossfire();
		break;
		case "mp_citystreets":
			level.waypoints = bots\waypoints\District::District();
		break;
		case "mp_farm":
			level.waypoints = bots\waypoints\Downpour::Downpour();
		break;
		case "mp_overgrown":
			level.waypoints = bots\waypoints\Overgrown::Overgrown();
		break;
		case "mp_pipeline":
			level.waypoints = bots\waypoints\Pipeline::Pipeline();
		break;
		case "mp_shipment":
			level.waypoints = bots\waypoints\Shipment::Shipment();
		break;
		case "mp_showdown":
			level.waypoints = bots\waypoints\Showdown::Showdown();
		break;
		case "mp_strike":
			level.waypoints = bots\waypoints\Strike::Strike();
		break;
		case "mp_vacant":
			level.waypoints = bots\waypoints\Vacant::Vacant();
		break;
		case "mp_cargoship":
			level.waypoints = bots\waypoints\Wetwork::Wetwork();
		break;
		
		case "mp_broadcast":
			level.waypoints = bots\waypoints\Broadcast::Broadcast();
		break;
		case "mp_creek":
			level.waypoints = bots\waypoints\Creek::Creek();
		break;
		case "mp_carentan":
			level.waypoints = bots\waypoints\Chinatown::Chinatown();
		break;
		case "mp_killhouse":
			level.waypoints = bots\waypoints\Killhouse::Killhouse();
		break;
		
		default:
			bots\waypoints\_custom_map::main(mapname);
		break;
	}
	
	level.waypointCount = level.waypoints.size;
}

bots_getMapName(map)
{
	switch(map)
	{
		case "mp_convoy":
			return "Ambush";
		case "mp_backlot":
			return "Backlot";
		case "mp_bloc":
			return "Bloc";
		case "mp_bog":
			return "Bog";
		case "mp_countdown":
			return "Countdown";
		case "mp_crash":
			return "Crash";
		case "mp_crash_snow":
			return "Winter Crash";
		case "mp_crossfire":
			return "Crossfire";
		case "mp_citystreets":
			return "District";
		case "mp_farm":
			return "Downpour";
		case "mp_overgrown":
			return "Overgrown";
		case "mp_pipeline":
			return "Pipeline";
		case "mp_shipment":
			return "Shipment";
		case "mp_showdown":
			return "Showdown";
		case "mp_strike":
			return "Strike";
		case "mp_vacant":
			return "Vacant";
		case "mp_cargoship":
			return "Wetwork";
		case "mp_broadcast":
			return "Broadcast";
		case "mp_creek":
			return "Creek";
		case "mp_carentan":
			return "Chinatown";
		case "mp_killhouse":
			return "Killhouse";
	}
	
	return map;
}

bots_getGoodMapAmount()
{
	switch(getDvar("mapname"))
	{
		case "mp_crash":
		case "mp_crash_snow":
		case "mp_countdown":
		case "mp_carentan":
		case "mp_creek":
		case "mp_broadcast":
		case "mp_cargoship":
		case "mp_pipeline":
		case "mp_overgrown":
		case "mp_strike":
		case "mp_farm":
		case "mp_crossfire":
		case "mp_backlot":
		case "mp_convoy":
		case "mp_bloc":
			if(level.teamBased)
				return 14;
			else
				return 9;
			
		case "mp_vacant":
		case "mp_showdown":
		case "mp_citystreets":
		case "mp_bog":
			if(level.teamBased)
				return 12;
			else
				return 8;
			
		case "mp_killhouse":
		case "mp_shipment":
			if(level.teamBased)
				return 8;
			else
				return 4;
	}
	
	return 2;
}

bots_getEyePos()
{
	//pez
	return (self getEye() + (0,0,20));
}

bots_playerIsABot()
{
	return ((isDefined(self.pers["isBot"]) && self.pers["isBot"]) || (isDefined(self.pers["isBotWarfare"]) && self.pers["isBotWarfare"]));
}

bots_clearStructs()
{
	self.bots_devwalk = [];
}

bots_changeToTeam(team)
{
	self notify("bot_team");
	self endon("bot_team");
	
	while(!isdefined(self.pers["team"]))
		wait .05;
	
	wait 0.05;
	self notify("menuresponse", game["menu_team"], team);
	if(!level.oldschool)
	{
		wait 0.5;
		self notify("menuresponse", "changeclass", "custom1");
	}
}

bots_changeToTeamThread(team)
{
	self endon("bot_reset");
	
	self bots_changeToTeam(team);
}

bots_doAmmo()
{
	weapon = self getcurrentweapon();
	if(isDefined(self.bots_devwalk[weapon]) && self.bots_devwalk[weapon].isEmpty)
	{
		self.bots_devwalk[weapon].isEmpty = false;
		self setWeaponAmmoClip( weapon, self.bots_devwalk[weapon].clip );
	}
}

bots_noAmmo()
{
	weapon = self getcurrentweapon();
	
	if(!isDefined(self.bots_devWalk[weapon]))
	{
		self.bots_devwalk[weapon] = spawnstruct();
		self.bots_devwalk[weapon].isEmpty = false;
		self.bots_devwalk[weapon].clip = self GetWeaponAmmoClip(weapon);
		self.bots_devwalk[weapon].stock = self GetWeaponAmmoStock(weapon);
		self.bots_devWalk[weapon].isReload = isDefined(level.bots_devWalk[weapon]);
		
		if(!self.bots_devWalk[weapon].isReload)
			self setWeaponAmmoStock(weapon, 0);
	}
	
	if(isDefined(self.bots_devwalk[weapon]) && !self.bots_devwalk[weapon].isEmpty)
	{
		self.bots_devwalk[weapon].isEmpty = true;
		self.bots_devwalk[weapon].clip = self GetWeaponAmmoClip(weapon);
		self setWeaponAmmoClip( weapon, 0 );
	}
}

bots_freezeControls(what)
{
	if(what)
	{
		self botAction("-fire");
		self bots_noAmmo(); // Keep this if we still want to hide ammo counts
	}
	else
	{
		self botAction("+fire");
		self bots_doAmmo();
	}
}

bots_getAmmoCount(what)
{
	return self bots_getWeaponAmmoClip(what) + self bots_getWeaponAmmoStock(what);
}

bots_getWeaponAmmoClip(what)
{
	if(isDefined(self.bots_devWalk[what]) && self.bots_devWalk[what].isEmpty)
		return self.bots_devWalk[what].clip;
	else
		return self getWeaponAmmoClip(what);
}

bots_getWeaponAmmoStock(what)
{
	if(isDefined(self.bots_devWalk[what]) && !self.bots_devWalk[what].isReload)
		return self.bots_devWalk[what].stock;
	else
		return self getWeaponAmmoStock(what);
}

bots_setWeaponAmmoClip(what, to)
{
	if(isDefined(self.bots_devWalk[what]) && self.bots_devWalk[what].isEmpty)
		self.bots_devWalk[what].clip = to;
	else
		self setWeaponAmmoClip(what, to);
}

bots_setWeaponAmmoStock(what, to)
{
	if(isDefined(self.bots_devWalk[what]) && !self.bots_devWalk[what].isReload)
		self.bots_devWalk[what].stock = to;
	else
		self setWeaponAmmoStock(what, to);
}

bots_waitFrame()
{
	wait 0.05;
}

bots_setspawnweapon(weap)
{
	if(!isSubStr(weap, level.bots_animWeapSubStr))
		self.bots_weap = weap;
	self setspawnweapon(weap);
}

bots_getCurrentWeapon()
{
	if(isDefined(self.bots_weap))
		return self.bots_weap;
	else
		return self getCurrentWeapon();
}

bots_GetCurrentWeaponClipAmmo()
{
	weap = self bots_getCurrentWeapon();
	return self bots_GetWeaponAmmoClip(weap);
}

bots_GetCursorPosition()
{
	return BulletTrace( self getTagOrigin("tag_eye"), bots_vector_Scale(anglestoforward(self getPlayerAngles()),1000000.0), false, self )[ "position" ];
}

bots_vector_scale(vec, scale)
{
	return (vec[0] * scale, vec[1] * scale, vec[2] * scale);
}

bots_doingNothing()
{
	return (isDefined(level.bots_doingNothing[self.bots_doing]));
}

bots_TalkAll(rate, message)
{
	if(level.bots_varPlayTalk > 0.0 && isDefined(self))
	{
		if(level.bots_varPlayTalk >= 50.0 || !rate || bots_randomInt(int((rate + self.pers["bots"]["trait"]["talk"]) * (1 / level.bots_varPlayTalk))) == 2)
		{
			self sayall(message);
		}
	}
}

bots_botFoundTarget()
{
	return ( isDefined( self.bots_realSeen ) || isDefined( self.bots_realEqu ) || isDefined( self.bots_realTarKS ) );
}

bots_getNearestEnt(ents)
{
	_ent = undefined;
	for(i = 0; i < ents.size; i++)
	{
		ent = ents[i];
		if(!isDefined(_ent) || closer( self.origin, ent.origin, _ent.origin ))
		{
			_ent = ent;
		}
	}
	return _ent;
}

bots_IsFacingAtTarget(target, dotCheck)
{
	dot = bots_getConeDot(target.origin);
    if(dot > dotCheck)
        return true;
	else
		return false;
}

bots_getConeDot(pos)
{
    dirToTarget = VectorNormalize(pos-self.origin);
    forward = AnglesToForward(self GetPlayerAngles());
    return vectordot(dirToTarget, forward);
}

bots_randomInt(arg1, arg2)
{
	isDef = isDefined(arg2);
	if(arg1 <= 0 && !isDef)
		return -1;
	
	if(!isDef)
		return randomInt(arg1);
	else
		return randomIntRange(arg1, arg2);
}

bots_tryGetGoodWeap(weaps)
{
	if(weaps.size)
	{
		goodWeaps = [];
		for(i = 0; i < weaps.size; i++)
		{
			weap = weaps[i];
			
			if(self bots_getAmmoCount(weap))
				goodWeaps[goodWeaps.size] = weap;
		}
		
		if(goodWeaps.size)
			return goodWeaps[randomint(goodWeaps.size)];
		else
			return weaps[randomInt(weaps.size)];
	}
	
	return undefined;
}

bots_getWeaponsGL()
{
	weaponsList = self GetWeaponsList();
	primaries = [];
	for(i = 0; i < weaponsList.size; i++)
	{
		weapon = weaponsList[i];
		
		if(bots_getBaseWeaponName(weapon) == "gl")
		{
			primaries[primaries.size] = weapon;
		}
	}
	return primaries;
}

bots_getOffhandsName()
{
	weaponsList = self GetWeaponsList();
	grenades = [];
	for(i = 0; i < weaponsList.size; i++)
	{
		weapon = weaponsList[i];
		
		if(self bots_isValidOffhand(bots_getBaseWeaponName(weapon)+"_grenade"))
		{
			grenades[grenades.size] = weapon;
		}
	}
	return grenades;
}

bots_getPrimariesName()
{
	weaponsList = self GetWeaponsList();
	primaries = [];
	for(i = 0; i < weaponsList.size; i++)
	{
		weapon = weaponsList[i];
		
		if(self bots_isValidPrimary(bots_getBaseWeaponName(weapon)) && !isSubStr(weapon, level.bots_animWeapSubStr))
		{
			primaries[primaries.size] = weapon;
		}
	}
	return primaries;
}

bots_getSecondariesName()
{
	weaponsList = self GetWeaponsList();
	secondaries = [];
	for(i = 0; i < weaponsList.size; i++)
	{
		weapon = weaponsList[i];
		
		if(self bots_isValidSecondary(bots_getBaseWeaponName(weapon)))
		{
			secondaries[secondaries.size] = weapon;
		}
	}
	return secondaries;
}

bots_isValidPrimary(weap)
{
	switch(weap)
	{
		case "ak47":
		case "ak74u":
		case "barrett":
		case "dragunov":
		case "g3":
		case "g36c":
		case "m1014":
		case "m14":
		case "m16":
		case "m21":
		case "m4":
		case "m40a3":
		case "m60e4":
		case "mp44":
		case "mp5":
		case "p90":
		case "rpd":
		case "saw":
		case "skorpion":
		case "uzi":
		case "winchester1200":
		case "remington700":
			return true;
	}
	return false;
}

bots_isValidSecondary(weap)
{
	switch(weap)
	{
		case "beretta":
		case "colt45":
		case "deserteagle":
		case "deserteaglegold":
		case "usp":
			return true;
	}
	return false;
}

bots_isValidOffhand(weap)
{
	switch(weap)
	{
		case "smoke_grenade":
		case "flash_grenade":
		case "concussion_grenade":
			return true;
	}
	return false;
}

bots_getAHost()
{
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		
		if(!isDefined(player.pers["bots_isHost"]) || !player.pers["bots_isHost"])
			continue;
		
		return player;
	}
	
	if(level.players.size)
		return level.players[0];
	
	return undefined;
}

bots_isItemUnlocked(what, lvl)
{
	switch(what)
	{
		case "ak47":
			return true;
		case "ak74u":
			return (lvl >= 28);
		case "barrett":
			return (lvl >= 49);
		case "dragunov":
			return (lvl >= 22);
		case "g3":
			return (lvl >= 25);
		case "g36c":
			return (lvl >= 37);
		case "m1014":
			return (lvl >= 31);
		case "m14":
			return (lvl >= 46);
		case "m16":
			return true;
		case "m21":
			return (lvl >= 7);
		case "m4":
			return (lvl >= 10);
		case "m40a3":
			return true;
		case "m60e4":
			return (lvl >= 19);
		case "mp44":
			return (lvl >= 52);
		case "mp5":
			return true;
		case "p90":
			return (lvl >= 40);
		case "rpd":
			return true;
		case "saw":
			return true;
		case "skorpion":
			return true;
		case "uzi":
			return (lvl >= 13);
		case "winchester1200":
			return true;
		case "remington700":
			return (lvl >= 34);
		case "beretta":
			return true;
		case "colt45":
			return (lvl >= 16);
		case "deserteagle":
			return (lvl >= 43);
		case "deserteaglegold":
			return (lvl >= 55);
		case "usp":
			return true;
		case "specialty_bulletdamage":
			return true;
		case "specialty_armorvest":
			return true;
		case "specialty_fastreload":
			return (lvl >= 20);
		case "specialty_rof":
			return (lvl >= 29);
		case "specialty_twoprimaries":
			return (lvl >= 38);
		case "specialty_gpsjammer":
			return (lvl >= 11);
		case "specialty_explosivedamage":
			return true;
		case "specialty_longersprint":
			return true;
		case "specialty_bulletaccuracy":
			return true;
		case "specialty_pistoldeath":
			return (lvl >= 8);
		case "specialty_grenadepulldeath":
			return (lvl >= 17);
		case "specialty_bulletpenetration":
			return true;
		case "specialty_holdbreath":
			return (lvl >= 26);
		case "specialty_quieter":
			return (lvl >= 44);
		case "specialty_parabolic":
			return (lvl >= 35);
		case "specialty_specialgrenade":
			return true;
		case "specialty_weapon_rpg":
			return true;
		case "specialty_weapon_claymore":
			return (lvl >= 23);
		case "specialty_fraggrenade":
			return (lvl >= 41);
		case "specialty_extraammo":
			return (lvl >= 32);
		case "specialty_detectexplosive":
			return (lvl >= 14);
		case "specialty_weapon_c4":
			return true;
		default:
			return true;
	}
}

bots_getBaseWeaponName(weap)
{
	weapToks = strTok(weap, "_");
	return weapToks[0];
}

bots_getRandomBot()
{
	_players = [];
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		if(player bots_playerIsABot())
			_players[_players.size] = player;
	}
	if(_players.size)
		return _players[randomInt(_players.size)];
	else
		return undefined;
}

bots_waittill_notify_or_timeout(not, tim)
{
	self endon(not);
	wait tim;
}

bots_waittill_either(not, not1)
{
	self endon(not);
	self waittill(not1);
}

bots_waittill_any( string1, string2, string3, string4, string5, string6, string7, string8 )
{
	if ( isdefined( string2 ) )
		self endon( string2 );

	if ( isdefined( string3 ) )
		self endon( string3 );

	if ( isdefined( string4 ) )
		self endon( string4 );

	if ( isdefined( string5 ) )
		self endon( string5 );

	if ( isdefined( string6 ) )
		self endon( string6 );
		
	if ( isdefined( string7 ) )
		self endon( string7 );
		
	if ( isdefined( string8 ) )
		self endon( string8 );

	self waittill( string1 );
}

bots_array_remove( ents, remover )
{
	newents = [];
	for(i = 0; i < ents.size; i++)
	{
		index = ents[i];
		
		if ( index != remover )
			newents[ newents.size ] = index;
	}

	return newents;
}

/*self thread bots_say_on_notify("bot_reset");
	self thread bots_say_on_notify("BotMovementComplete");
	self thread bots_say_on_notify("kill_bot_walk");
	self thread bots_say_on_notify("bot_clear_doing_obj");
	self thread bots_say_on_notify("bot_kill_bomb");
	self thread bots_say_on_notify("bot_obj_override");
	self thread bots_say_on_notify("BotMovementCompleteDyn");
	self thread bots_say_on_notify("bot_walk_unreachloc");
	self thread bots_say_on_notify("bot_kill_nade");
	self thread bots_say_on_notify("bot_walk_overlap");
	self thread bots_say_on_notify("kill_bot_follow");
	self thread bots_say_on_notify("bot_kill_camp");*/
bots_say_on_notify(not)
{
	for(;;)
	{
		self waittill(not);
		self sayall(not + " @ " + getTime());
	}
}

bots_onUsePlantObjectFix( player )
{
	// planted the bomb
	if ( !self maps\mp\gametypes\_gameobjects::isFriendlyTeam( player.pers["team"] ) )
	{
		level thread bots_bombPlanted( self, player );
		player logString( "bomb planted: " + self.label );
		
		// disable all bomb zones except this one
		for ( index = 0; index < level.bombZones.size; index++ )
		{
			if ( level.bombZones[index] == self )
				continue;
				
			level.bombZones[index] maps\mp\gametypes\_gameobjects::disableObject();
		}
		
		player playSound( "mp_bomb_plant" );
		player notify ( "bomb_planted" );
		if ( !level.hardcoreMode )
			iPrintLn( &"MP_EXPLOSIVES_PLANTED_BY", player );
		maps\mp\gametypes\_globallogic::leaderDialog( "bomb_planted" );

		maps\mp\gametypes\_globallogic::givePlayerScore( "plant", player );
		player thread [[level.onXPEvent]]( "plant" );
	}
}

bots_bombPlanted( destroyedObj, player )
{
	maps\mp\gametypes\_globallogic::pauseTimer();
	level.bombPlanted = true;
	
	destroyedObj.visuals[0] thread maps\mp\gametypes\_globallogic::playTickingSound();
	level.tickingObject = destroyedObj.visuals[0];

	level.timeLimitOverride = true;
	setGameEndTime( int( gettime() + (level.bombTimer * 1000) ) );
	setDvar( "ui_bomb_timer", 1 );
	
	if ( !level.multiBomb )
	{
		level.sdBomb maps\mp\gametypes\_gameobjects::allowCarry( "none" );
		level.sdBomb maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
		level.sdBomb maps\mp\gametypes\_gameobjects::setDropped();
		level.sdBombModel = level.sdBomb.visuals[0];
	}
	else
	{
		
		for ( index = 0; index < level.players.size; index++ )
		{
			if ( isDefined( level.players[index].carryIcon ) )
				level.players[index].carryIcon destroyElem();
		}

		trace = bulletTrace( player.origin + (0,0,20), player.origin - (0,0,2000), false, player );
		
		tempAngle = randomfloat( 360 );
		forward = (cos( tempAngle ), sin( tempAngle ), 0);
		forward = vectornormalize( forward - vector_scale( trace["normal"], vectordot( forward, trace["normal"] ) ) );
		dropAngles = vectortoangles( forward );
		
		level.sdBombModel = spawn( "script_model", trace["position"] );
		level.sdBombModel.angles = dropAngles;
		level.sdBombModel setModel( "prop_suitcase_bomb" );
	}
	destroyedObj maps\mp\gametypes\_gameobjects::allowUse( "none" );
	destroyedObj maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	/*
	destroyedObj maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", undefined );
	destroyedObj maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", undefined );
	destroyedObj maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", undefined );
	destroyedObj maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", undefined );
	*/
	label = destroyedObj maps\mp\gametypes\_gameobjects::getLabel();
	
	// create a new object to defuse with.
	trigger = destroyedObj.bombDefuseTrig;
	trigger.origin = level.sdBombModel.origin;
	visuals = [];
	defuseObject = maps\mp\gametypes\_gameobjects::createUseObject( game["defenders"], trigger, visuals, (0,0,32) );
	defuseObject maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	defuseObject maps\mp\gametypes\_gameobjects::setUseTime( level.defuseTime );
	defuseObject maps\mp\gametypes\_gameobjects::setUseText( &"MP_DEFUSING_EXPLOSIVE" );
	defuseObject maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
	defuseObject maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	defuseObject maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defuse" + label );
	defuseObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_defend" + label );
	defuseObject maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defuse" + label );
	defuseObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_defend" + label );
	defuseObject.label = label;
	defuseObject.onBeginUse = maps\mp\gametypes\sd::onBeginUse;
	defuseObject.onEndUse = maps\mp\gametypes\sd::onEndUse;
	defuseObject.onUse = maps\mp\gametypes\sd::onUseDefuseObject;
	defuseObject.useWeapon = "briefcase_bomb_defuse_mp";
	
	level.defuseObject = defuseObject;
	
	maps\mp\gametypes\sd::BombTimerWait();
	setDvar( "ui_bomb_timer", 0 );
	
	destroyedObj.visuals[0] maps\mp\gametypes\_globallogic::stopTickingSound();
	
	if ( level.gameEnded || level.bombDefused )
		return;
	
	level.bombExploded = true;
	
	explosionOrigin = level.sdBombModel.origin;
	level.sdBombModel hide();
	
	if ( isdefined( player ) )
		destroyedObj.visuals[0] radiusDamage( explosionOrigin, 512, 200, 20, player );
	else
		destroyedObj.visuals[0] radiusDamage( explosionOrigin, 512, 200, 20 );
	
	rot = randomfloat(360);
	explosionEffect = spawnFx( level._effect["bombexplosion"], explosionOrigin + (0,0,50), (0,0,1), (cos(rot),sin(rot),0) );
	triggerFx( explosionEffect );
	
	thread maps\mp\gametypes\sd::playSoundinSpace( "exp_suitcase_bomb_main", explosionOrigin );
	
	if ( isDefined( destroyedObj.exploderIndex ) )
		exploder( destroyedObj.exploderIndex );
	
	for ( index = 0; index < level.bombZones.size; index++ )
		level.bombZones[index] maps\mp\gametypes\_gameobjects::disableObject();
	defuseObject maps\mp\gametypes\_gameobjects::disableObject();
	
	setGameEndTime( 0 );
	
	wait 3;
	
	maps\mp\gametypes\sd::sd_endGame( game["attackers"], game["strings"]["target_destroyed"] );
}