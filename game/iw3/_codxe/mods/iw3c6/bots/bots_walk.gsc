#include bots\bots_funcs;

bots_doStuck()
{
	self endon("bot_reset");
	self endon("death");
	stuck = 0;
	for(;;)
	{
		before = self getorigin();
		wait 3;
		if(before == self getorigin() && self bots_CanMove())
		{
			wait 2;
			if(before == self getorigin() && self bots_CanMove())
			{
				self botStop();
				self notify( "BotMovementComplete" );
				self notify("BotMovementCompleteDyn");
				self.bots_lastStaticWP = self.bots_currentStaticWp;
				self.bots_currentStaticWp = bots_GetNearestStaticWaypoint(self.origin);
				wait 2.5;
				if(before == self getorigin() && self bots_CanMove())
				{
					if(getDvarInt("bots_main_debug"))
						level iprintln("Map violation: " + self.name + ", Killpoint " + self.origin + ", wp " + self.bots_currentStaticWp + ", doing "+ self.bots_objDoing + ", obj " + self.bots_vObjectivePos);
					if(stuck > 4)
					{
						stuck = 0;
						if(level.bots_varPlayStuck)
							self suicide();
					}
					else
					{
						stuck++;
						self thread bots\talk::bots_doStuckTalk();
						self thread bots_restartWalk();
					}
				}
			}
		}
	}
}

bots_doObj()
{
	self notify("bot_obj_override");
	self endon("bot_obj_override");
	
	switch(level.gametype)
	{
		case "war":
		case "dm":
			wps = bots_getWaypointsNear(level.bots_goalPoint.origin, level.bots_goalRad);
			wp = undefined;
			if(wps.size > 0)
			{
				wp = wps[randomint(wps.size)];
			}
			if(isDefined(wp) && self.bots_traitRandom != 3)
			{
				self bots_goToLoc(level.waypoints[wp].origin, ::bots_nullFunc, 0, 0, 0);
			}
			else
			{
				self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_nullFunc, 0, 0, 0);
			}
		break;
		case "dom":
			if(isDefined(level.flags))
			{
				ownedFlags = [];
				unownedFlags = [];
				for(i = 0; i < level.flags.size; i++)
				{
					flag = level.flags[i];
					
					if(flag.useObj.ownerTeam == self.team)
						ownedFlags[ownedFlags.size] = flag;
					else
						unownedFlags[unownedFlags.size] = flag;
				}
				
				targetFlag = undefined;
				
				if(!self.bots_traitRandom || ownedFlags.size < 2)//unsatififed with current flags
				{
					if(unownedFlags.size)
					{
						if(randomInt(4))
							targetFlag = bots_getNearestEnt(unownedFlags);
						else
							targetFlag = unownedFlags[randomint(unownedFlags.size)];
					}
					
					if(isDefined(targetFlag))//cap the flag
					{
						self thread bots\talk::bots_dom_capFlag(targetFlag);
						self.bots_objDoing = "domflag";
						self bots_campAtEnt(targetFlag, false, ::bots_capDomFlag, targetFlag, 0, 0);
						self.bots_objDoing = "none";
						self thread bots\talk::bots_dom_cappedFlag(targetFlag);
					}
					else
					{
						self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_patrolDomFlags, ownedFlags, false, 0);
					}
				}
				else//satififed with current flags
				{
					underAttackFlags = [];
					for(i = 0; i < ownedFlags.size; i++)
					{
						flag = ownedFlags[i];
						
						if(flag.useObj.objPoints[self.team].isFlashing)
							underAttackFlags[underAttackFlags.size] = flag;
					}
					
					if(underAttackFlags.size)
					{
						if(randomInt(4))
							targetFlag = bots_getNearestEnt(underAttackFlags);
						else
							targetFlag = underAttackFlags[randomint(underAttackFlags.size)];
					}
					
					if(isDefined(targetFlag))//go check out the flag
					{
						self thread bots\talk::bots_dom_lookFlag(targetFlag);
						self bots_goToLoc(targetFlag.origin, ::bots_nullFunc, 0, 0, 0);
						self thread bots\talk::bots_dom_lookFlagDone(targetFlag);
					}
					else//patrol the enemy spawn
					{
						if(isDefined(unownedFlags[0]))
							wps = bots_getWaypointsNear(unownedFlags[0].origin, randomFloatRange(500,2500));
						else
							wps = [];
						wp = undefined;
						if(wps.size > 0)
						{
							wp = wps[randomint(wps.size)];
						}
						if(isDefined(wp))
						{
							self thread bots\talk::bots_dom_spawnKill(unownedFlags[0]);
							
							self bots_goToLoc(level.waypoints[wp].origin, ::bots_patrolDomFlags, ownedFlags, true, 0);
						}
						else
						{
							self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_patrolDomFlags, ownedFlags, true, 0);
						}
					}
				}
			}
		break;
		case "koth":
			if(isDefined(level.radioObject))//if hq is available
			{
				if(level.radioObject.ownerTeam != self.pers["team"])//if netural or enemy has it capped
				{
					if(level.radioObject.interactTeam == "none" && self.bots_traitRandom)//waiting for it to be active
					{
						wps = bots_getWaypointsNear(level.radioObject.trigger.origin, randomFloatRange(100,1000));
						wp = undefined;
						if(wps.size > 0)
						{
							wp = wps[randomint(wps.size)];
						}
						if(isDefined(wp))
						{
							self thread bots\talk::bots_koth_waitCap();
							
							self bots_goToLoc(level.waypoints[wp].origin, ::bots_waitCapHQ, 0, 0, 0);
						}
						else
						{
							self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_waitCapHQ, 0, 0, 0);
						}
					}
					else//ready to be capped
					{
						self.bots_objDoing = "hq";
						self thread bots\talk::bots_koth();
						self bots_campAtEnt(level.radioObject.trigger, false, ::bots_capHQ, 0, 0, 0);
						self.bots_objDoing = "none";
					}
				}
				else//we own it
				{
					if(!self.bots_traitRandom)
					{
						self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_protectHQ, 0, 0, 0);
					}
					else//hang around the area of the hq
					{
						if(level.radioObject.objPoints[self.team].isFlashing)//underattack
						{
							self thread bots\talk::bots_koth_protectEnemy();
							
							self bots_goToLoc(level.radioObject.trigger.origin, ::bots_protectHQ, 0, 0, 0);
						}
						else//patrol area
						{
							wps = bots_getWaypointsNear(level.radioObject.trigger.origin, randomFloatRange(100,1000));
							wp = undefined;
							if(wps.size > 0)
							{
								wp = wps[randomint(wps.size)];
							}
							if(isDefined(wp))
							{
								self thread bots\talk::bots_koth_protect();
								
								self bots_goToLoc(level.waypoints[wp].origin, ::bots_protectHQEnemy, 0, 0, 0);
							}
							else
							{
								self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_protectHQEnemy, 0, 0, 0);
							}
						}
					}
				}
			}
			else//wait for it
			{
				self thread bots\talk::bots_koth_wait();
				self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_waitHQ, 0, 0, 0);
			}
		break;
		case "sd":
			if(isdefined(level.bombZones) && (isdefined(level.sdBomb) || level.multiBomb))
			{
				if(self.pers["team"] == game["attackers"])//if planter team
				{
					if(level.bombPlanted)//if job is done
					{
						if(isDefined(level.defuseObject))
						{
							defusers = bots_getDefusers();
							if(!defusers.size)//if no one defusing
							{
								wps = bots_getWaypointsNear(level.defuseObject.trigger.origin, randomFloatRange(100,1000));
								wp = undefined;
								if(wps.size > 0)
								{
									wp = wps[randomint(wps.size)];
								}
								if(isDefined(wp))//patrol the area
								{
									self thread bots\talk::bots_sd_protectPlant();
									
									self bots_goToLoc(level.waypoints[wp].origin, ::bots_protectBombPlantSD, 0, 0, 0);
								}
								else
								{
									self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_protectBombPlantSD, 0, 0, 0);
								}
							}
							else//go check out the bomb
							{
								self thread bots\talk::bots_sd_protectPlantDefuser(defusers);
								
								self bots_goToLoc(level.defuseObject.trigger.origin, ::bots_nullFunc, 0, 0, 0);
								
								self thread bots\talk::bots_sd_protectPlantDefuserFinish();
							}
						}
					}
					else
					{
						if((isdefined(self.isBombCarrier) && self.isBombCarrier) || level.multiBomb)//has bomb
						{
							timeLeft = maps\mp\gametypes\_globallogic::getTimeRemaining() / 1000;
							if(timeLeft <= 60 || !self.bots_traitRandom)//it is good to go plant
							{
								targetBombsite = undefined;
								
								if(randomInt(4))
								{
									for(i = 0; i < level.bombZones.size; i++)
									{
										bombsite = level.bombZones[i];
										
										if(!isDefined(targetBombsite) || closer(self.origin, bombsite.trigger.origin, targetBombsite.trigger.origin))
											targetBombsite = bombsite;
									}
								}
								else
								{
									targetBombsite = level.bombZones[randomInt(level.bombZones.size)];
								}
								
								if(isDefined(targetBombsite))//go plant
								{
									self.bots_objDoing = "plant";
									
									self thread bots\talk::bots_sd_goPlantBomb(targetBombsite);
									
									self bots_goToLoc(targetBombsite.trigger.origin, ::bots_nullFunc, 0, 0, 0);
									
									planters = bots_getPlanters();
									if(self bots_doingNothing() && !isDefined(self.lastStand) && distance(targetBombsite.trigger.origin, self.origin) <= level.bots_useNear && !planters.size)
									{
										self thread bots_doSiteBeginUse(targetBombsite);
										self thread bots_clearDoingOnObj("bomb");
										
										self thread bots\talk::bots_sd_plantingBomb(targetBombsite);
										
										weap1 = targetBombsite.useWeapon;
										lastWeap = self bots_getCurrentWeapon();
										self giveWeapon(weap1);
										self bots_setSpawnWeapon(weap1);
										
										wait(getdvarfloat("scr_sd_planttime") + 0.25);
										
										planters = bots_getPlanters();
										if(self.bots_doing == "bomb" && !isDefined(self.lastStand) && distance(targetBombsite.trigger.origin, self.origin) <= level.bots_useNear && planters.size == 1 && !level.bombPlanted)
										{
											self thread bots\talk::bots_sd_plantedBomb(targetBombsite);
											targetBombsite [[targetBombsite.onUse]](self);
										}
										
										self bots_setSpawnWeapon(lastWeap);
										self takeWeapon(weap1);
										
										self notify("bot_clear_doing_obj");
										self notify("bot_kill_bomb");
									}
									
									self.bots_objDoing = "none";
								}
							}
							else
							{
								self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_nullFunc, 0, 0, 0);
							}
						}
						else//dont got bomb
						{
							timeLeft = maps\mp\gametypes\_globallogic::getTimeRemaining() / 1000;
							if((timeLeft <= 60 || self.bots_traitRandom) && !level.multiBomb)//feels like doing obj
							{
								if(!isDefined(level.sdBomb.carrier))//if no one has bomb
								{
									self.bots_objDoing = "bomb";//it must be on the ground so go get it
									self thread bots\talk::bots_sd_getBomb();
									self bots_goToLoc(level.sdBomb.trigger.origin, ::bots_protectBombSD, 0, 0, 0);
									if(isdefined(self.isBombCarrier) && self.isBombCarrier)
										self thread bots\talk::bots_sd_gotBomb();
									self.bots_objDoing = "none";
								}
								else
								{
									if(timeLeft <= 60 || self.bots_traitRandom == 2)//protect the carrier
									{
										self thread bots\talk::bots_sd_protectBombCarry(level.sdBomb.carrier);
										self bots_goFollow(level.sdBomb.carrier, 30, false);
									}
									else
									{
										self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_nullFunc, 0, 0, 0);
									}
								}
							}
							else
							{
								self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_nullFunc, 0, 0, 0);
							}
						}
					}
				}
				else//is defuser
				{
					if(level.bombPlanted)//bomb is planted, must go defuse
					{
						if(isDefined(level.defuseObject))
						{
							self.bots_objDoing = "defuse";
							
							self thread bots\talk::bots_sd_goDefuseBomb(level.defuseObject);
							
							self bots_goToLoc(level.defuseObject.trigger.origin, ::bots_nullFunc, 0, 0, 0);
							
							defusers = bots_getDefusers();
							if(self bots_doingNothing() && !isDefined(self.lastStand) && distance(level.defuseObject.trigger.origin, self.origin) <= level.bots_useNear && !defusers.size)
							{
								self thread bots_doSiteBeginUse(level.defuseObject);
								self thread bots_clearDoingOnObj("bomb");
								
								self thread bots\talk::bots_sd_defuseBomb(level.defuseObject);
								
								weap1 = level.defuseObject.useWeapon;
								lastWeap = self bots_getCurrentWeapon();
								self giveWeapon(weap1);
								self bots_setSpawnWeapon(weap1);
								
								wait(getdvarfloat("scr_sd_defusetime") + 0.25);
								
								defusers = bots_getDefusers();
								if(self.bots_doing == "bomb" && !isDefined(self.lastStand) && distance(level.defuseObject.trigger.origin, self.origin) <= level.bots_useNear && defusers.size == 1 && level.bombPlanted)
								{
									self thread bots\talk::bots_sd_defusedBomb(level.defuseObject);
									level.defuseObject [[level.defuseObject.onUse]](self);
								}
								
								self bots_setSpawnWeapon(lastWeap);
								self takeWeapon(weap1);
								
								self notify("bot_clear_doing_obj");
								self notify("bot_kill_bomb");
							}
							
							self.bots_objDoing = "none";
						}
					}
					else
					{
						timeLeft = maps\mp\gametypes\_globallogic::getTimeRemaining() / 1000;
						if(timeLeft <= 60 || self.bots_traitRandom)//feels like protecting
						{
							if(self.bots_traitRandom == 2 && !level.multiBomb)//wants to camp bomb or carrier
							{
								if(isDefined(level.sdBomb.carrier))//someone has bomb
								{
									self thread bots\talk::bots_sd_killBombCarry(level.sdBomb.carrier);
									self bots_goFollow(level.sdBomb.carrier, 30, false);
								}
								else//camp the bomb
								{
									if(level.bots_varPlayCamp)
									{
										self thread bots\talk::bots_sd_protectBomb();
										self bots_campAtEnt(level.sdBomb.trigger, true, ::bots_protectBombSD, 0, 0, 0);
									}
									else
									{
										self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_protectBombSiteSD, 0, 0, 0);
									}
								}
							}
							else//wants to protect bombzones
							{
								targetBombsite = undefined;
								
								if(self.bots_traitRandom != 3 && randomInt(4))
								{
									for(i = 0; i < level.bombZones.size; i++)
									{
										bombsite = level.bombZones[i];
										
										if(!isDefined(targetBombsite) || closer(self.origin, bombsite.trigger.origin, targetBombsite.trigger.origin))
											targetBombsite = bombsite;
									}
								}
								else
								{
									targetBombsite = level.bombZones[randomInt(level.bombZones.size)];
								}
								
								if(isDefined(targetBombsite))//protect bombzones
								{
									wps = bots_getWaypointsNear(targetBombsite.trigger.origin, randomFloatRange(100,1000));
									wp = undefined;
									if(wps.size > 0)
									{
										wp = wps[randomint(wps.size)];
									}
									if(isDefined(wp))//patrol the area
									{
										self thread bots\talk::bots_sd_protectBombsite(targetBombsite);
										
										self bots_goToLoc(level.waypoints[wp].origin, ::bots_protectBombsiteSD, 0, 0, 0);
									}
									else
									{
										self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_protectBombPlantSD, 0, 0, 0);
									}
								}
							}
						}
						else
						{
							self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_protectBombSiteSD, 0, 0, 0);
						}
					}
				}
			}
		break;
		case "sab":
			if(isDefined(level.sabBomb) && isDefined(level.bombZones))
			{
				otherTeam = "axis";
				if(self.pers["team"] == "axis")
					otherTeam = "allies";
				
				if(self.pers["team"] == level.sabBomb.ownerTeam)//we own the bomb
				{
					if(level.bombPlanted)//bomb is planted
					{
						defusers = bots_getDefusers();
						
						if(defusers.size)//someone is defusing
						{
							self thread bots\talk::bots_sab_killDefuser(defusers);
							
							self bots_goToLoc(level.bombZones[otherTeam].trigger.origin, ::bots_nullFunc, 0, 0, 0);
							
							self thread bots\talk::bots_sab_killDefuserFinish();
						}
						else//no one is defusing
						{
							wps = bots_getWaypointsNear(level.bombZones[otherTeam].trigger.origin, randomFloatRange(100,1000));
							wp = undefined;
							if(wps.size > 0)
							{
								wp = wps[randomint(wps.size)];
							}
							if(isDefined(wp))//patrol the area
							{
								self thread bots\talk::bots_sab_protectPlant();
								
								self bots_goToLoc(level.waypoints[wp].origin, ::bots_protectSabPlant, 0, 0, 0);
							}
							else
							{
								self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_protectSabPlant, 0, 0, 0);
							}
						}
					}
					else//bomb not planted
					{
						if(isdefined(self.isBombCarrier) && self.isBombCarrier)//gots bomb
						{
							self.bots_objDoing = "plant";
								
							self thread bots\talk::bots_sab_goPlantBomb();
							
							self bots_goToLoc(level.bombZones[otherTeam].trigger.origin, ::bots_nullFunc, 0, 0, 0);
							
							planters = bots_getPlanters();
							if(self bots_doingNothing() && !isDefined(self.lastStand) && distance(level.bombZones[otherTeam].trigger.origin, self.origin) <= level.bots_useNear && !planters.size)
							{
								self thread bots_doSiteBeginUse(level.bombZones[otherTeam]);
								self thread bots_clearDoingOnObj("bomb");
								
								self thread bots\talk::bots_sab_plantingBomb();
								
								weap1 = level.bombZones[otherTeam].useWeapon;
								lastWeap = self bots_getCurrentWeapon();
								self giveWeapon(weap1);
								self bots_setSpawnWeapon(weap1);
								
								wait(getdvarfloat("scr_sab_planttime") + 0.25);
								
								planters = bots_getPlanters();
								if(self.bots_doing == "bomb" && !isDefined(self.lastStand) && distance(level.bombZones[otherTeam].trigger.origin, self.origin) <= level.bots_useNear && planters.size == 1 && !level.bombPlanted)
								{
									self thread bots\talk::bots_sab_plantedBomb();
									level.bombZones[otherTeam] [[level.bombZones[otherTeam].onUse]](self);
								}
								
								self bots_setSpawnWeapon(lastWeap);
								self takeWeapon(weap1);
								
								self notify("bot_clear_doing_obj");
								self notify("bot_kill_bomb");
							}
							
							self.bots_objDoing = "none";
						}
						else//not got bomb
						{
							if(self.bots_traitRandom && isDefined(level.sabBomb.carrier))
							{
								self thread bots\talk::bots_sab_protectBombCarry(level.sabBomb.carrier);
								self bots_goFollow(level.sabBomb.carrier, 30, false);
							}
							else
							{
								self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_nullFunc, 0, 0, 0);
							}
						}
					}
				}
				else if(otherTeam == level.sabBomb.ownerTeam)//they own the bomb
				{
					if(level.bombPlanted)//bomb is planted
					{
						self.bots_objDoing = "defuse";
							
						self thread bots\talk::bots_sab_goDefuseBomb();
						
						self bots_goToLoc(level.bombZones[self.team].trigger.origin, ::bots_nullFunc, 0, 0, 0);
						
						defusers = bots_getDefusers();
						if(self bots_doingNothing() && !isDefined(self.lastStand) && distance(level.bombZones[self.team].trigger.origin, self.origin) <= level.bots_useNear && !defusers.size)
						{
							self thread bots_doSiteBeginUse(level.bombZones[self.team]);
							self thread bots_clearDoingOnObj("bomb");
							
							self thread bots\talk::bots_sab_defuseBomb();
							
							weap1 = level.bombZones[self.team].useWeapon;
							lastWeap = self bots_getCurrentWeapon();
							self giveWeapon(weap1);
							self bots_setSpawnWeapon(weap1);
							
							wait(getdvarfloat("scr_sab_defusetime") + 0.25);
							
							defusers = bots_getDefusers();
							if(self.bots_doing == "bomb" && !isDefined(self.lastStand) && distance(level.bombZones[self.team].trigger.origin, self.origin) <= level.bots_useNear && defusers.size == 1 && level.bombPlanted)
							{
								self thread bots\talk::bots_sab_defusedBomb();
								level.bombZones[self.team] [[level.bombZones[self.team].onUse]](self);
							}
							
							self bots_setSpawnWeapon(lastWeap);
							self takeWeapon(weap1);
							
							self notify("bot_clear_doing_obj");
							self notify("bot_kill_bomb");
						}
						
						self.bots_objDoing = "none";
					}
					else//bomb is not planted
					{
						if(self.bots_traitRandom < 3 && isDefined(level.sabBomb.carrier))
						{
							self thread bots\talk::bots_sab_killBombCarry(level.sabBomb.carrier);
							self bots_goFollow(level.sabBomb.carrier, 30, false);
						}
						else
						{
							wps = bots_getWaypointsNear(level.bombZones[self.team].trigger.origin, randomFloatRange(100,1000));
							wp = undefined;
							if(wps.size > 0)
							{
								wp = wps[randomint(wps.size)];
							}
							if(isDefined(wp))//patrol the area
							{
								self thread bots\talk::bots_sab_protectbombSite();
								
								self bots_goToLoc(level.waypoints[wp].origin, ::bots_protectSabSite, 0, 0, 0);
							}
							else
							{
								self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_protectSabSite, 0, 0, 0);
							}
						}
					}
				}
				else//bomb is on ground
				{
					self.bots_objDoing = "bomb";
					self thread bots\talk::bots_sab_getBomb();
					self bots_goToLoc(level.sabBomb.trigger.origin, ::bots_sabBomb, 0, 0, 0);
					if(isdefined(self.isBombCarrier) && self.isBombCarrier)
						self thread bots\talk::bots_sab_gotBomb();
					self.bots_objDoing = "none";
				}
			}
		break;
		default:
			self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_nullFunc, 0, 0, 0);
		break;
	}
}

bots_randomObjs()
{
	self notify("bot_obj_override");
	self endon("bot_obj_override");
	
	if(bots_randomint(int(self.pers["bots"]["trait"]["nade"]/8)) == 2)
	{
		self bots_doWPGrenade(randomint(5));
	}
	if(bots_randomint(int(self.pers["bots"]["trait"]["nade"]/8)) == 2)
	{
		self bots_doWPTube(randomint(5));
	}
	if(bots_randomint(int(self.pers["bots"]["trait"]["camp"]/8)) == 2)
	{
		self bots_goCamp(randomint(2), self.pers["bots"]["trait"]["cfTime"], true);
	}
	if(bots_randomint(int(self.pers["bots"]["trait"]["follow"]/8)) == 2)
	{
		self bots_goFollow(undefined, self.pers["bots"]["trait"]["cfTime"], true);
	}
}

bots_getObj()
{
	self endon("bot_reset");
	self endon("death");
	self endon("kill_bot_walk");
	self thread bots_watchPlayers();
	
	for(;;)
	{
		if(self bots_shouldGetObj())
		{
			if(self.pers["bots"]["trait"]["asshole"] && self.pers["bots"]["trait"]["asshole_type"] == 4)
			{
				self bots_goCamp(randomint(2), 60, true);
				bots_waitFrame();
				continue;
			}
			
			self bots_randomObjs();
			
			if(level.waypointCount && self bots_shouldGetObj())
			{
				if(level.bots_varPlayObj)
				{
					self bots_doObj();
				}
				else
				{
					self bots_goToLoc(level.waypoints[randomint(level.waypointCount)].origin, ::bots_nullFunc, 0, 0, 0);
				}
			}
		}
		bots_waitFrame();
	}
}

bots_doEqu(equ)
{
	self.bots_objDoing = "equ";
	
	self notify("bot_obj_override");
	self endon("bot_obj_override");
	
	self thread bots\talk::bots_goToEqu(equ);
	self bots_goToLoc(equ.origin, ::bots_isDefined, equ, 0, 0);
	
	self.bots_objDoing = "none";
}

bots_doTargetObj(target)
{
	self.bots_objDoing = "player";
	
	self notify("bot_obj_override");
	self endon("bot_obj_override");
	
	self thread bots\talk::bots_playerWatch(target);
	self bots_goToLoc(target getOrigin(), ::bots_nullFunc, 0, 0, 0);
	self.bots_objDoing = "none";
	self thread bots\talk::bots_playerWent(target);
}

bots_doDeathLoc()
{
	self.bots_objDoing = "deathloc";
	
	self notify("bot_obj_override");
	self endon("bot_obj_override");
	
	self thread bots\talk::bots_deathloc();
	self bots_goToLoc(self.lastDeathPos, ::bots_nullFunc, 0, 0, 0);
	if(distance(self.origin, self.lastDeathPos) < 100.0)
		self.bots_atDeathLoc = true;
	self.bots_objDoing = "none";
	self thread bots\talk::bots_wentDeathloc();
}

bots_watchPlayers()
{
	self endon("bot_reset");
	self endon("death");
	self endon("kill_bot_walk");
	for(;;)
	{
		if(self bots_shouldGetObj())
		{
			equ = self.bots_realEqu;
			if(isDefined(equ))
			{
				self bots_doEqu(equ);
			}
			else
			{
				if (level.splitScreen)
				{
					target = self bots_getGoToPlayer();
					if(isDefined(target))
					{
						self bots_doTargetObj(target);
					}
				}
				else if(self.pers["bots"]["skill"]["base"])
				{
					if(self.pers["bots"]["trait"]["killsOverObj"])
						target = self bots_getGoToPlayer();
					else
						target = undefined;
					if(isDefined(target))
					{
						self bots_doTargetObj(target);
					}
					else
					{
						if(!self.bots_atDeathLoc && self.pers["bots"]["trait"]["vengeful"] == 2 && isDefined(self.lastDeathPos))
						{
							self bots_doDeathLoc();
						}
					}
				}
			}
		}
		wait 1;
	}
}

bots_restartWalk()
{
	self endon("bot_reset");
	self endon("death");
	self notify("kill_bot_walk");
								
	self.bots_currentStaticWp = -1;
	self.bots_tempwp = (0.0, 0.0, 0.0);
	self.bots_vObjectivePos = (0.0, 0.0, 0.0);
	self.bots_fMoveSpeed = 0.0;
	self.bots_stance = "stand";
	self.bots_lastStaticWP = -1;
	self.bots_targetWpIdx = -1;
	self.bots_secondNextWp = -1;
	
	self.bots_camping = false;
	self.bots_campingAngles = undefined;
	self.bots_doing = "none";
	self.bots_objDoing = "none";
	
	self thread bots_doMovement();
	self thread bots_getObj();
}

bots_getGoToPlayer()
{
	if (level.splitScreen)
	{
		closest = undefined;
		closestDist = 999999;
		
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			
			if(!isDefined(player.pers["team"]))
				continue;
			if(!level.bots_varTargetHost && player.pers["bots_isHost"])
				continue;
			if(player == self)
				continue;
			if(self.pers["team"] == player.pers["team"] && level.teamBased)
				continue;
			if(player.sessionstate != "playing")
				continue;
			if(!isAlive(player))
				continue;
				
			dist = distance(self.origin, player.origin);
			if (dist < closestDist)
			{
				closestDist = dist;
				closest = player;
			}
		}
		return closest;
	}

	if(!level.bots_varTarget.size)
	{
		if(isDefined(self.bots_realSeen))
			return self.bots_realSeen;
		
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			
			if(!isDefined(player.pers["team"]))
				continue;
			if(!level.bots_varTargetHost && player.pers["bots_isHost"])
				continue;
			if(player == self)
				continue;
			if(self.pers["team"] == player.pers["team"] && level.teamBased)
				continue;
			if(player.sessionstate != "playing")
				continue;
			if(!isAlive(player))
				continue;
			if(distance(self.origin, player.origin) > self.pers["bots"]["skill"]["viewDis"])
				continue;
			if(!self bots\bots_aim::bots_getTurned(player))
				continue;
			
			return player;
		}
	}
	else
	{
		for(i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			
			if(!isSubStr(player.name, level.bots_varTarget))
				continue;
			
			return player;
		}
	}
	return undefined;
}

bots_isDefined(ent, parm2, parm3)
{
	return (isDefined(ent));
}

bots_nullFunc(parm1, parm2, parm3)
{
	return true;
}

bots_shouldGetObj()
{
	return (isDefined(level.bots_shouldObj[self.bots_objDoing]));
}

bots_capDomFlag(flag, parm2, parm3)
{
	return (flag.useObj.ownerTeam != self.team);
}

bots_patrolDomFlags(ownedflags, underattackcheck, parm3)
{
	for(i = 0; i < ownedflags.size; i++)
	{
		flag = ownedFlags[i];
		
		if(flag.useObj.ownerTeam != self.team || (underattackcheck && flag.useObj.objPoints[self.team].isFlashing))
			return false;
	}
	
	return true;
}

bots_protectSabSite(parm1, parm2, parm3)
{
	return (!level.bombPlanted && self.pers["team"] != level.sabBomb.ownerTeam);
}

bots_protectSabPlant(parm1, parm2, parm3)
{
	defusers = bots_getDefusers();
	
	return (level.bombPlanted && self.pers["team"] == level.sabBomb.ownerTeam && !defusers.size);
}

bots_sabBomb(parm1, parm2, parm3)
{
	return (level.sabBomb.ownerTeam == "neutral");
}

bots_waitHQ(parm1, parm2, parm3)
{
	return (!isDefined(level.radioObject));
}

bots_capHQ(parm1, parm2, parm3)
{
	return (isDefined(level.radioObject) && level.radioObject.ownerTeam != self.pers["team"]);
}

bots_WaitCapHQ(parm1, parm2, parm3)
{
	return (isDefined(level.radioObject) && level.radioObject.interactTeam == "none");
}

bots_protectHQ(parm1, parm2, parm3)
{
	return (isDefined(level.radioObject) && level.radioObject.ownerTeam == self.pers["team"]);
}

bots_protectHQEnemy(parm1, parm2, parm3)
{
	return (isDefined(level.radioObject) && level.radioObject.ownerTeam == self.pers["team"] && !level.radioObject.objPoints[self.team].isFlashing);
}

bots_protectBombSD(parm1, parm2, parm3)
{
	return (!level.bombPlanted && !isDefined(level.sdBomb.carrier));
}

bots_protectBombSiteSD(parm1, parm2, parm3)
{
	return (!level.bombPlanted);
}

bots_protectBombPlantSD(parm1, parm2, parm3)
{
	defusers = bots_getDefusers();
	
	return (!defusers.size);
}

bots_doSiteBeginUse(bombsite)
{
	bombsite [[bombsite.onBeginUse]](self);
	
	self endon("bot_kill_bomb");
	self thread bots_doSiteBeginUse2(bombsite);
	self bots_waittill_any("death", "bot_reset", "kill_bot_walk");
	
	bombsite [[bombsite.onEndUse]](self.pers["team"], self, false);
}

bots_doSiteBeginUse2(bombsite)
{
	self endon("death");
	self endon("bot_reset");
	self endon("kill_bot_walk");
	self waittill("bot_kill_bomb");
	
	bombsite [[bombsite.onEndUse]](self.pers["team"], self, true);
}

bots_clearDoingOnObj(doing)
{
	self endon("death");
	self endon("bot_reset");
	self endon("kill_bot_walk");
	self.bots_doing = doing;
	self bots_waittill_either("bot_obj_override", "bot_clear_doing_obj");
	self.bots_doing = "none";
}

bots_getDefusers()
{
	players = [];
	
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		
		if(!isAlive(player))
			continue;
		if(isDefined(player.isDefusing) && player.isDefusing)
			players[players.size] = player;
	}
	
	return players;
}

bots_getPlanters()
{
	players = [];
	
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		
		if(!isAlive(player))
			continue;
		if(isDefined(player.isPlanting) && player.isPlanting)
			players[players.size] = player;
	}
	
	return players;
}

bots_watchUnreach()
{
	self endon("bot_walk_overlap");
	self endon("bot_walk_unreachloc");
	self endon("death");
	self endon("bot_reset");
	self endon("kill_bot_walk");
	
	self waittill("BotMovementCompleteDyn");
	self waittill("BotMovementCompleteDyn");
	self waittill("BotMovementCompleteDyn");
	
	self notify("bot_walk_unreachloc");
}

bots_goToLoc(where, func, parm1, parm2, parm3)
{
	if(!isDefined(where))
		return;
	
	self notify("bot_walk_overlap");
	self endon("bot_walk_overlap");
	
	self endon("bot_walk_unreachloc");
	self thread bots_watchUnreach();
	
	while(self [[func]](parm1, parm2, parm3) && distance(self.origin, where) > level.bots_objNear)
	{
		self.bots_vObjectivePos = where;
		bots_waitFrame();
	}
	
	self notify("bot_walk_unreachloc");
}

bots_doNoneOnCampOverlap()
{
	self endon("bot_reset");
	self endon("kill_bot_walk");
	self endon("death");
	self endon("bot_kill_camp");
	self bots_waittill_either("bot_walk_overlap", "bot_obj_override");
	self.bots_camping = false;
	self.bots_campingAngles = undefined;
}

bots_campAtEnt(ent, campCheck, func, parm1, parm2, parm3)
{
	if(!level.bots_varPlayCamp && campCheck)
		return;
	
	self notify("bot_walk_overlap");
	self endon("bot_walk_overlap");
	
	firstRun = true;
	while(self [[func]](parm1, parm2, parm3) && isDefined(ent))
	{
		if(distance(self.origin, ent.origin) > level.bots_objNear)
		{
			self.bots_camping = false;
			self.bots_campingAngles = undefined;
		}
		else
		{
			if(firstRun)
			{
				firstRun = false;
				self thread bots_doNoneOnCampOverlap();
			}
			self.bots_camping = true;
			self.bots_campingAngles = VectorToAngles((ent.origin-self.origin)-anglesToForward(self getplayerangles()));
		}
		self.bots_vObjectivePos = ent.origin;
		bots_waitFrame();
	}
	
	self.bots_camping = false;
	self.bots_campingAngles = undefined;
	self notify("bot_kill_camp");
}

bots_doNothingOnCampTime(time, talk, campSpot)
{
	self endon("bot_reset");
	self endon("kill_bot_walk");
	self endon("death");
	self endon("bot_walk_overlap");
	self endon("bot_kill_camp");
	wait time;
	if(talk)
		self thread bots\talk::bots_CampDone(time, campSpot);
	self.bots_camping = false;
	self.bots_campingAngles = undefined;
	self notify("bot_kill_camp");
}

bots_goCamp(nearest, time, talk)
{
	if(!level.bots_varPlayCamp)
		return;
	
	self notify("bot_walk_overlap");
	self endon("bot_walk_overlap");
	self endon("bot_kill_camp");
	
	if(nearest)
		campSpot = bots_getNearestCampSpot();
	else
		campSpot = bots_getRandomCampSpot();
	
	if(campSpot != -1)
	{
		if(talk)
			self thread bots\talk::bots_CampInit(campSpot, time);
		
		virgin = true;
		for(;;)
		{
			if(distance(level.waypoints[campSpot].origin, self.origin) <= level.bots_objNear)
			{
				if(virgin)
				{
					virgin = false;//:(
					if(talk)
						self thread bots\talk::bots_Camping(campSpot, time);
					self thread bots_doNothingOnCampTime(time, talk, campSpot);
					self thread bots_doNoneOnCampOverlap();
				}
				self.bots_camping = true;
				self.bots_campingAngles = level.waypoints[campSpot].angles;
			}
			else
			{
				self.bots_camping = false;
				self.bots_campingAngles = undefined;
			}
			self.bots_vObjectivePos = level.waypoints[campSpot].origin;
			if(isDefined(self.bots_realSeen) && talk && bots_randomint(int(self.pers["bots"]["trait"]["camp"]/4)) == 2)
			{
				self.bots_camping = false;
				self.bots_campingAngles = undefined;
				self notify("bot_kill_camp");
			}
			bots_waitFrame();
		}
	}
}

bots_doNoneWPTube(weap, wp)
{
	self endon("bot_reset");
	self endon("death");
	self endon("kill_bot_walk");
	self endon("bot_walk_overlap");
	self waittill("bot_kill_nade");
	self thread bots\talk::bots_tubethrew(weap, wp);
	self.bots_camping = false;
	self.bots_campingAngles = undefined;
	self notify("bot_kill_camp");
}

bots_doTubeStuff(weap, wp)
{
	self endon("bot_kill_nade");
	
	if(!level.bots_varLoadoutTube || !self bots\bots_aim::bots_canSwitch())
		return;
	
	self thread bots_doNoneOnCampOverlap();
	self thread bots_doNoneWPTube(weap, wp);
	self.bots_camping = true;
	self.bots_campingAngles = level.waypoints[wp].angles;
	wait 1;//wait for aim to take place
	
	if(!level.bots_varLoadoutTube || !self bots\bots_aim::bots_canSwitch())
	{
		self notify("bot_kill_nade");
		return;
	}
	
	self.bots_Doing = "ftube";
	lastWeapon = self bots_getCurrentWeapon();
	self bots_setspawnweapon(weap);
	self thread bots\bots_aim::bots_doNoneOnGNadeAmmoTube(weap, lastWeapon);
	
	self thread bots\bots_aim::bots_forceGNadeFire();
	
	wait 5.5;
		
	self bots_setspawnweapon(lastWeapon);
	if(self.bots_doing != "climb")
		self.bots_Doing = "none";
	self bots\bots_aim::bots_stopShooting();
	self notify("bot_kill_nade");
}

bots_doWPTube(nearest)
{
	if(!level.bots_varLoadoutTube || !self bots\bots_aim::bots_canSwitch())
		return;
	
	self notify("bot_walk_overlap");
	self endon("bot_walk_overlap");
	
	weap = self bots_tryGetGoodWeap(self bots_getWeaponsGL());
	wp = undefined;
	wps = [];
	
	if(isDefined(weap))
	{
		if(self bots_getammoCount(weap))
		{
			wps = bots_getTubeWaypointArray();
			if(wps.size)
			{
				if(nearest)
				{
					for(i = 0; i < wps.size; i++)
					{
						_wp = wps[i];
						if(isDefined(wp))
						{
							if(distance(self.origin, level.waypoints[_wp].origin) < distance(self.origin, level.waypoints[wp].origin))
								wp = _wp;
						}
						else
						{
							wp = _wp;
						}
					}
				}
				else
				{
					wp = wps[randomint(wps.size)];
				}
			}
			if(isDefined(wp))
			{
				self thread bots\talk::bots_tubego(weap, wp);
				while(distance(level.waypoints[wp].origin, self.origin) > level.bots_objNear)
				{
					self.bots_vObjectivePos = level.waypoints[wp].origin;
					bots_waitFrame();
				}
				self bots_doTubeStuff(weap, wp);
			}
		}
	}
}

bots_doNoneWPGnade(nade, wp)
{
	self endon("bot_reset");
	self endon("death");
	self endon("kill_bot_walk");
	self endon("bot_walk_overlap");
	self waittill("bot_kill_nade");
	self thread bots\talk::bots_gnadethrew(nade, wp);
	self.bots_camping = false;
	self.bots_campingAngles = undefined;
	self notify("bot_kill_camp");
}

bots_doNadeStuff(nade, wp)
{
	self endon("bot_kill_nade");
	
	if(!level.bots_varLoadoutNade || !self bots\bots_aim::bots_canSwitch())
		return;
	
	self thread bots_doNoneOnCampOverlap();
	self thread bots_doNoneWPGnade(nade, wp);
	self.bots_camping = true;
	self.bots_campingAngles = level.waypoints[wp].angles;
	wait 1;//wait for aim to take place
	
	if(!level.bots_varLoadoutNade || !self bots\bots_aim::bots_canSwitch())
	{
		self notify("bot_kill_nade");
		return;
	}
	
	self.bots_Doing = "nade_fire";
	lastWeapon = self bots_getCurrentWeapon();
	self bots_setspawnweapon(nade);
	
	self thread bots\bots_aim::bots_doNoneOnGNadeAmmo(nade, lastWeapon);
	self thread bots\bots_aim::bots_watchGNadeFire(lastWeapon);
	
	self thread bots\bots_aim::bots_forceGNadeFire();
	
	wait 3;
	self bots_setspawnweapon(lastWeapon);
	self.bots_doing = "none";
	self bots\bots_aim::bots_stopShooting();
	self notify("bot_kill_nade");
}

bots_doWPGrenade(nearest)
{
	if(!level.bots_varLoadoutNade || !self bots\bots_aim::bots_canSwitch())
		return;
	
	self notify("bot_walk_overlap");
	self endon("bot_walk_overlap");
	
	hasClaymore = self bots_getAmmoCount("claymore_mp");
	hasFrag = self bots_getAmmoCount("frag_grenade_mp");
	secNade = self bots_tryGetGoodWeap(self bots_getOffhandsName());
	hasSec = (isDefined(secNade) && self bots_getAmmoCount(secnade));
	wp = undefined;
	wps = [];
	nade = undefined;
	
	if(hasClaymore || hasFrag || hasSec)
	{
		while(!isDefined(nade))
		{
			switch(randomInt(3))
			{
				case 0:
					if(hasClaymore)
						nade = "claymore_mp";
				break;
				case 1:
					if(hasFrag)
						nade = "frag_grenade_mp";
				break;
				case 2:
					if(hasSec)
						nade = secNade;
				break;
			}
		}
	}
	
	if(isDefined(nade))
	{
		if(nade == "claymore_mp")
			wps = bots_getClaymoreWaypointArray();
		else
			wps = bots_getGrenadeWaypointArray();
	}
	
	if(wps.size)
	{
		if(nearest)
		{
			for(i = 0; i < wps.size; i++)
			{
				_wp = wps[i];
				if(isDefined(wp))
				{
					if(distance(self.origin, level.waypoints[_wp].origin) < distance(self.origin, level.waypoints[wp].origin))
						wp = _wp;
				}
				else
				{
					wp = _wp;
				}
			}
		}
		else
		{
			wp = wps[randomint(wps.size)];
		}
	}
	
	if(isDefined(wp))
	{
		self thread bots\talk::bots_gnadego(nade, wp);
		while(distance(level.waypoints[wp].origin, self.origin) > level.bots_objNear)
		{
			self.bots_vObjectivePos = level.waypoints[wp].origin;
			bots_waitFrame();
		}
		self bots_doNadeStuff(nade, wp);
	}
}

bots_goFollow(_player, time, talk)
{
	self notify("bot_walk_overlap");
	self endon("bot_walk_overlap");
	self endon("kill_bot_follow");
	
	if(isDefined(_player) || level.teambased)
	{
		if(!isDefined(_player))
		{
			_players = [];
			for(i=0;i<level.players.size;i++)
			{
				player = level.players[i];
				
				if(!isDefined(player.pers["team"]))
					continue;
				if(player == self)
					continue;
				if(self.pers["team"] != player.pers["team"])
					continue;
				if(player.sessionstate != "playing")
					continue;
				if(!isAlive(player))
					continue;
				
				_players[_players.size] = player;
			}
			
			if(_players.size)
			{
				if(randomint(2))
					_player = _players[randomint(_players.size)];
				else
					_player = self bots_getNearestEnt(_players);
			}
		}
		if(isDefined(_player))
		{
			if(talk)
				self thread bots\talk::bots_follow(_player, time);
			self thread bots_doNothingOnFollowTime(time, talk, _player);
			firstTime = true;
			for(;;)
			{
				if(isDefined(_player) && isAlive(_player))
				{
					if(distance(_player.origin, self.origin) > level.bots_objNear)
					{
						self.bots_camping = false;
						self.bots_campingAngles = undefined;
					}
					else
					{
						if(firstTime)
						{
							firstTime = false;
							self thread bots_doNoneOnCampOverlap();
						}
						self.bots_camping = true;
						self.bots_campingAngles = VectorToAngles((_player.origin-self.origin)-anglesToForward(self getplayerangles()));
					}
					self.bots_vObjectivePos = _player.origin;
				}
				else
				{
					self.bots_camping = false;
					self.bots_campingAngles = undefined;
					self notify("bot_kill_camp");
					self notify("kill_bot_follow");
				}
				if(isDefined(self.bots_realSeen) && bots_randomint(int(self.pers["bots"]["trait"]["follow"]/4)) == 2)
				{
					self.bots_camping = false;
					self.bots_campingAngles = undefined;
					self notify("bot_kill_camp");
					self notify("kill_bot_follow");
				}
				bots_waitFrame();
			}
		}
	}
}

bots_doNothingOnFollowTime(time, talk, player)
{
	self endon("bot_reset");
	self endon("kill_bot_walk");
	self endon("death");
	self endon("kill_bot_follow");
	self endon("bot_walk_overlap");
	wait time;
	if(talk)
		self thread bots\talk::bots_followend(player, time);
	self.bots_camping = false;
	self.bots_campingAngles = undefined;
	self notify("bot_kill_camp");
	self notify("kill_bot_follow");
}

bots_goToLocAndTBag(where)//meant to be threaded
{
	self endon("bot_reset");
	self endon("death");
	self endon("kill_bot_walk");
	
	self.bots_objDoing = "tbag";
	
	self notify("bot_obj_override");
	self endon("bot_obj_override");
	
	self thread bots\talk::bots_goingTBag(where);
	
	self bots_goToLoc(where, ::bots_nullFunc, 0, 0, 0);
	
	self notify("bot_walk_overlap");
	self endon("bot_walk_overlap");
	
	if(distance(self.origin, where) <= level.bots_objNear)
	{
		self thread bots_doNoneOnCampOverlap();
		
		self.bots_camping = true;
		self.bots_campingAngles = VectorToAngles(((where+(0, 0, -200))-self.origin)-anglesToForward(self getplayerangles()));
		
		self thread bots\talk::bots_doTBag(where);
		
		for(i=0;i<3;i++)
		{
			tim = getTime();
			while((getTime() - tim) < 500)
			{
				self.bots_stance = "crouch";
				bots_waitFrame();
			}
			tim = getTime();
			while((getTime() - tim) < 500)
			{
				self.bots_stance = "stand";
				bots_waitFrame();
			}
		}

		self thread bots\talk::bots_doTBagdone(where);
	}
	
	self.bots_objDoing = "none";
	self.bots_camping = false;
	self.bots_campingAngles = undefined;
	self notify("bot_kill_camp");
}

bots_getClaymoreWaypointArray()
{
  campingWaypoints = [];
   for(i = 0; i < level.waypointCount; i++)
   {
		if(level.waypoints[i].type == "claymore")
			campingWaypoints[campingWaypoints.size] = i;
   }
  
  return campingWaypoints;
}

bots_getGrenadeWaypointArray()
{
  campingWaypoints = [];
   for(i = 0; i < level.waypointCount; i++)
   {
		if(level.waypoints[i].type == "grenade")
			campingWaypoints[campingWaypoints.size] = i;
   }
  
  return campingWaypoints;
}

bots_getTubeWaypointArray()
{
  campingWaypoints = [];
   for(i = 0; i < level.waypointCount; i++)
   {
		if(level.waypoints[i].type == "tube")
			campingWaypoints[campingWaypoints.size] = i;
   }
  
  return campingWaypoints;
}

bots_getNearestCampSpot()
{
	campPoints = bots_getCampingWaypointArray();
	campSpot = -1;
	if(campPoints.size){
		for(i=0;i<campPoints.size;i++)
		{
			point = campPoints[i];
			if(campSpot == -1)
			{
				campSpot = point;
			}
			else
			{
				if(distance(self.origin, level.waypoints[point].origin) < distance(self.origin, level.waypoints[campSpot].origin))
					campSpot = point;
			}
		}
	}
	return campSpot;
}

bots_getRandomCampSpot()
{
	campPoints = bots_getCampingWaypointArray();
	campSpot = -1;
	
	if(campPoints.size)
		campSpot = campPoints[randomint(campPoints.size)];
	
	return campSpot;
}

bots_getCampingWaypointArray()
{
  campingWaypoints = [];
   for(i = 0; i < level.waypointCount; i++)
   {
		if(level.waypoints[i].childCount == 1 && level.waypoints[i].type == "crouch")
			campingWaypoints[campingWaypoints.size] = i;
   }
  
  return campingWaypoints;
}

bots_getWaypointsNear(Loc, Rad)
{
	campingWaypoints = [];
	
	for(i = 0; i < level.waypointCount; i++)
	{
		if(distance(level.waypoints[i].origin, Loc) <= Rad)
			campingWaypoints[campingWaypoints.size] = i;
	}
  
  return campingWaypoints;
}

bots_AnyWaypointCloser(pos, wpIndex)
{
	nearestWaypoint = wpIndex;
	nearestDistance = Distance(pos, level.waypoints[wpIndex].origin);
	for(i = 0; i < level.waypointCount; i++)
	{
		distance = Distance(pos, level.waypoints[i].origin); 
		if(distance < nearestDistance)
		{
			nearestDistance = distance;
			nearestWaypoint = i;
		}
	}
	//  Print3d(level.waypoints[nearestWaypoint].origin, "CLOSEST", (1,0,0), 3);
	return (nearestWaypoint != wpIndex);
}

bots_GetNearestStaticWaypoint(pos)
{
  nearestWaypoint = -1;
  nearestDistance = 9999999999.0;
  for(i = 0; i < level.waypointCount; i++)
  {
    distance = Distance(pos, level.waypoints[i].origin);
    if(distance < nearestDistance )
    {
     	 	nearestDistance = distance;
      		nearestWaypoint = i;
    }
  }
  
  return nearestWaypoint;
}

bots_CanMove()
{
	if(isDefined(self.lastStand))
		return false;
	
	if( !level.bots_varPlayMove )
		return false;
	
	if( self.bots_camping )
		return false;
	
	if( isDefined( level.bots_canMove[ self.bots_doing ] ) )
		return false;
	
	if( self bots_botFoundTarget() )
		return false;
	
	return true;
}

bots_CanClimb()
{
	if(isDefined(self.lastStand))
		return false;
	
	return (self bots_doingNothing() || isDefined(level.bots_canClimb[self.bots_doing]));
}

bots_doClimbing()
{
	self endon("bot_reset");
	self endon("death");
	self endon("kill_bot_walk");
	self.bots_doing = "climb";
	self waittill( "BotMovementComplete" );
	self.bots_doing = "none";
}

bots_Move(vMoveTarget, climbing)
{
	self notify ( "BotMovementComplete" );//cancel possible previous movement
	self endon ( "BotMovementComplete" );
	
	if(climbing)
	{
		if(!self bots_CanClimb())
			return;
		
		self thread bots_doClimbing();
		moveTarget = vMoveTarget;
	}
	else
		moveTarget = (vMoveTarget[0], vMoveTarget[1], self.origin[2]);
	
	for(;;)
	{
		if(!climbing)
		{
			self bots_ClampToGround();
			moveTarget = (vMoveTarget[0], vMoveTarget[1], self.origin[2]);
		}
		else
		{
			self.bots_doing = "climb";
			if(self bots\bots_aim::bots_CanStopShoot())
				self botStop();
			if(!isDefined(self.lastStand))
				self.bots_stance = "stand";
		}
		
		didMakeIt = (DistanceSquared(moveTarget, self.origin) <= (self.bots_fMoveSpeed*self.bots_fMoveSpeed));
		if(self.bots_fMoveSpeed < 0.05 || didMakeIt || (climbing && !self bots_CanClimb()))
		{
			if(didMakeIt)
				self setOrigin(moveTarget);
			
			self botStop();
			self notify( "BotMovementComplete" );
		}
		else
		{
			//move
			self SetOrigin(self.origin + (VectorNormalize(moveTarget-self.origin) * (self.bots_fMoveSpeed)));
			self bots_PushOutOfPlayers();
		}
		
		wait 0.05;
	}
}

bots_PushOutOfPlayers()
{
	if(level.bots_varPlayOFMW <= 0.0)
		return;
	
	for(i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		
		if(player == self)
			continue;
		if(!isAlive(player))
			continue;

		_distance = distance(player.origin, self.origin);
			
		if(_distance < level.bots_varPlayOFMW) //push out
		{
			pushOutDir = VectorNormalize((self.origin[0], self.origin[1], 0)-(player.origin[0], player.origin[1], 0));
			trace = bulletTrace(self.origin + (0,0,20), (self.origin + (0,0,20)) + (pushOutDir * ((level.bots_varPlayOFMW-_distance)+10)), false, self);
			//no collision, so push out
			if(trace["fraction"] == 1)
			{
				pushoutPos = self.origin + (pushOutDir * (level.bots_varPlayOFMW-_distance));
				self SetOrigin((pushoutPos[0], pushoutPos[1], self.origin[2])); 
			}
		}
	}
}

bots_ClampToGround()
{
	trace = physicsTrace(self.origin + (0.0,0.0,50.0), self.origin + (0.0,0.0,-40.0));

	if((trace[2] - (self.origin[2]-40.0)) > 0.0 && ((self.origin[2]+50.0) - trace[2]) > 0.0)
	{
		self SetOrigin(trace);
		return true;
	}
	return false;
}

bots_followDynWaypointsGoal()
{
	self notify("BotMovementCompleteDyn");
	self endon("BotMovementCompleteDyn");
	//build waypoint list
	bots_dynWaypointList = self bots_BuildDynWaypointList();
	bots_dynWaypointCount = bots_dynWaypointList.size;
	bots_currDynWaypoint = 0;
	
	if(!bots_dynWaypointCount)
		return;
	
	self.bots_secondNextWp = -1;
	
	for(;;)
	{
		bots_waitFrame();
		
		self.bots_tempWp = (bots_dynWaypointList[bots_currDynWaypoint][0], bots_dynWaypointList[bots_currDynWaypoint][1], self.origin[2]);
		
		self bots_Move(self.bots_tempWp, false);
		
		if(Distance(self.bots_tempWp, self.origin) <= level.bots_objNear)
		{
			if(bots_currDynWaypoint < bots_dynWaypointCount-1)
			{
				bots_currDynWaypoint++;
			}
			else
			{
				self notify("BotMovementCompleteDyn");
			}
		}
	}
}

bots_doMovement()
{
	self endon("bot_reset");
	self endon("death");
	self endon("kill_bot_walk");
	for(;;)
	{
		bots_waitFrame();
		
		if(!isDefined(self.bots_vObjectivePos) || self.bots_fMoveSpeed < 0.05)
			continue;
		
		//get waypoint nearest to ourselves  
		if(!isDefined(level.waypoints[self.bots_currentStaticWp]) || self.bots_lastStaticWP == self.bots_currentStaticWp)
		{
			self.bots_lastStaticWP = self.bots_currentStaticWp;
			self.bots_currentStaticWp = bots_GetNearestStaticWaypoint(self.origin);
		}
		
		//if there isn't any waypoint that is closer than our current waypoint then end our goal
		if(!isDefined(level.waypoints[self.bots_currentStaticWp]) || (self.bots_lastStaticWP == self.bots_currentStaticWp && !bots_AnyWaypointCloser(self.bots_vObjectivePos, self.bots_currentStaticWp)))
		{
			if(Distance(self.bots_vObjectivePos, self.origin) > level.bots_objNear)
				self bots_followDynWaypointsGoal();
		}
		else
		{
			//get waypoint pos
			self.bots_tempwp = level.waypoints[self.bots_currentStaticWp].origin;
			
			willClimb = (level.waypoints[self.bots_currentStaticWp].type == "climb");
			
			self bots_Move(self.bots_tempwp, willClimb);
			
			//clamp to xz plane    
			if(!willClimb)
				distToWp = Distance((self.bots_tempwp[0], self.bots_tempwp[1], self.origin[2]), self.origin);
			else
				distToWp = Distance(self.bots_tempwp, self.origin);
			
			//pick next waypoint or end
			if(distToWp <= level.bots_objNear)
			{
				if(abs(self.bots_tempwp[2] - self.origin[2]) > 50 && !willClimb)
					self setOrigin((self.origin[0], self.origin[1], self.bots_tempwp[2]));
				
				//get waypoint nearest our target
				if(!isDefined(self.bots_vObjectivePos))
					continue;
				
				self.bots_targetWpIdx = bots_GetNearestStaticWaypoint(self.bots_vObjectivePos);
				
				if(!isDefined(level.waypoints[self.bots_targetWpIdx]) || !isDefined(level.waypoints[self.bots_currentStaticWp]))
					continue;
				//find shortest path to our destination
				self.bots_lastStaticWP = self.bots_currentStaticWp;
				data = bots_AStarSearch(self.bots_lastStaticWP, self.bots_targetWpIdx);
				self.bots_currentStaticWp = data.nextWp;
				self.bots_secondNextWp = data.secondNextWp;
			}
		}
	}
}

bots_BuildDynWaypointList()
{
	bots_dynWaypointCount = 0;

	from = self.origin + (0.0,0.0,30.0);
	
	if(!isDefined(self.bots_vObjectivePos))
		return [];
	
	objPos = self.bots_vObjectivePos;
	enemydirection = VectorNormalize(objPos - from);
	direction = enemydirection;
	distance = 30.0;
	bots_dynWaypointList = [];
	bCanTurnToTarget = true; // if true we can turn to try go towards our target
	maxWaypointCount = randomintrange(40, 60);
	lastWallDirection = (1.0,0.0,0.0);
	bValidLastWallDirection = false;

	while(bots_dynWaypointCount < maxWaypointCount)
	{
		//add a waypoint
		bots_dynWaypointList[bots_dynWaypointCount] = self bots_ClampWpToGround(from);
		bots_dynWaypointCount++;

		trace = bulletTrace(from, from + (direction * distance), false, self);

		enemydirection = VectorNormalize(objPos - from);

		//didnt hit keep moving
		if(trace["fraction"] == 1)
		{
			from = trace["position"];

			//add a waypoint
			bots_dynWaypointList[bots_dynWaypointCount] = self bots_ClampWpToGround(from);
			bots_dynWaypointCount++;

			//move towards target
			if(bCanTurnToTarget)
			{
				direction = enemydirection;
				bValidLastWallDirection = false;
			}
			else //see if we need to keep following wall
			{
				//try keep following wall
				if(bValidLastWallDirection)
				{
					//trace
					trace = bulletTrace(from, from + (lastWallDirection * distance * 2.0), false, self);

					//wall no longer there, head that way
					if(trace["fraction"] == 1)
					{
						direction = lastWallDirection;
						from = trace["position"];
						dot = vectorDot(enemydirection, direction);
						if(dot > 0.5)
						{
							bCanTurnToTarget = true;
						}
						bValidLastWallDirection = false;
					}
				}
				else //still next to wall keep going straight ahead
				{
					bCanTurnToTarget = false;
				}
			}
		}
		else // hit something, navigate around it
		{
			//dont turn to target we need to navigate around collision    
			bCanTurnToTarget = false;

			//get collision normal and position    
			colNormal = trace["normal"];
			colPos = trace["position"];

			//move out from collision
			//      from = colPos + (colNormal * 20.0);
			from = colPos + (VectorNormalize(bots_VectorSmooth(direction * -1.0, colNormal, 0.5)) * 20.0); //normals are dodgy, especially on corrigated iron, use a fake normal

			tanDirection = bots_VectorCross(direction * -1.0, (0.0,0.0,1.0));
			//tanDirection = bots_VectorCross(colNormal, (0,0,1));

			//we were already traveling along a wall, pick tangent direction that keeps us going forwards
			if(bValidLastWallDirection)
			{
				dot = vectordot(lastWallDirection * -1.0, tanDirection);

				if(dot < 0)
				{
					tanDirection = tanDirection * -1.0;
				}

				lastWallDirection = colNormal * -1.0;
				bValidLastWallDirection = true;
				direction = tanDirection;
			}
			else //choose direction that best matches target dir
			{
				dot = vectordot(enemydirection, tanDirection);

				if(dot < 0)
				{
					tanDirection = tanDirection * -1.0;
				}

				lastWallDirection = colNormal * -1.0;
				bValidLastWallDirection = true;
				direction = tanDirection;
			}
		}

		//end of waypoint list
		if(Distance(objPos, from) <= (distance+5.0))
		{
			return bots_dynWaypointList; 
		}
	}

	return bots_dynWaypointList;
}

bots_ClampWpToGround(wpPos)
{
	trace = bulletTrace(wpPos, wpPos + (0,0,-300), false, self);

	if(trace["fraction"] < 1)
	{
		return trace["position"] + (0,0,30);
	}
	else
	{
		//probably under the ground, trace up
		trace = bulletTrace(wpPos, wpPos + (0,0,20), false, self);
		if(trace["fraction"] < 1)
		{
			return trace["position"] + (0,0,30);
		}
		else
		{
			return wpPos;
		}
	}
}

bots_VectorCross( v1, v2 )
{
	return ( v1[1]*v2[2] - v1[2]*v2[1], v1[2]*v2[0] - v1[0]*v2[2], v1[0]*v2[1] - v1[1]*v2[0] );
}

bots_VectorSmooth(vA, vB, fFactor)
{
	fFactorRecip = 1.0-fFactor;

	vRVal = ((vA * fFactorRecip) + (vB * fFactor));

	return vRVal;
}

////////////////////////////////////////////////////////////
// AStarSearch, performs an astar search
///////////////////////////////////////////////////////////
/*

The best-established algorithm for the general searching of optimal paths is A* (pronounced “A-star”). 
This heuristic search ranks each node by an estimate of the best route that goes through that node. The typical formula is expressed as:

f(n) = g(n) + h(n)

where: f(n)is the score assigned to node n g(n)is the actual cheapest cost of arriving at n from the start h(n)is the heuristic 
estimate of the cost to the goal from n 

priorityqueue Open
list Closed


AStarSearch
   s.g = 0  // s is the start node
   s.h = GoalDistEstimate( s )
   s.f = s.g + s.h
   s.parent = null
   push s on Open
   while Open is not empty
      pop node n from Open  // n has the lowest f
      if n is a goal node 
         construct path 
         return success
      for each successor n' of n
         newg = n.g + cost(n,n')
         if n' is in Open or Closed,
          and n'.g < = newg
	       skip
         n'.parent = n
         n'.g = newg
         n'.h = GoalDistEstimate( n' )
         n'.f = n'.g + n'.h
         if n' is in Closed
            remove it from Closed
         if n' is not yet in Open
            push n' on Open
      push n onto Closed
   return failure // if no path found 
*/

bots_AStarSearch(startWp, goalWp)
{
	pQOpen = [];
	pQSize = 0;
	closedList = [];
	listSize = 0;
	
	closedListOpti = [];
	pQOpenOpti = [];
	
	s = spawnstruct();
	s.g = 0; //start node
	s.h = distance(level.waypoints[startWp].origin, level.waypoints[goalWp].origin);
	s.f = s.h;
	s.wpIdx = startWp;
	s.parent = undefined;//is the start node, has no parent.

	pQOpen[pQSize] = s; //push s on Open  
	pQSize++;
	pQOpenOpti[s.wpIdx] = s;
	
	result = spawnstruct();
	result.nextWp = -1;
	result.secondNextWp = -1;

	//while Open is not empty  
	while(pQSize)
	{
		//get lowest f'd node
		bestNode = -1;
		for(i = 0; i < pQSize; i++)
			if(!isDefined(pQOpen[bestNode]) || pQOpen[bestNode].f > pQOpen[i].f)
				bestNode = i;
			
		//bestNode cannot be -1 as pQSize must of been 0, which loop would break
		if(!isDefined(pQOpen[bestNode]))
			return result;
		
		n = pQOpen[bestNode];
		//remove n from open
		for(i = bestNode; i < pQSize-1; i++)
			pQOpen[i] = pQOpen[i+1];
		
		pQOpenOpti[n.wpIdx] = undefined;
		pQOpen[pQSize-1] = undefined;
		pQSize--;
		
		//if n is a goal node; construct path, return success
		if(n.wpIdx == goalWp)
		{
			for(i = 0; i < level.waypointCount; i++)//check for parent's of parents 1000 times, should be enough.
			{
				//if(isDefined(n.parent))
				//	line(level.waypoints[n.wpIdx].origin, level.waypoints[n.parent.wpIdx].origin, (0,1,0));
				
				if(!isDefined(n.parent) || !isDefined(n.parent.parent))//if is start node or next node after start node
				{
					result.nextWp = n.wpIdx;
					return result;
				}
				
				result.secondNextWp = n.wpIdx;
				n = n.parent;
			}
			
			return result;
		}

		//for each successor nc of n
		for(i = 0; i < level.waypoints[n.wpIdx].childCount; i++)
		{
			newg = n.g + distance(level.waypoints[n.wpIdx].origin, level.waypoints[level.waypoints[n.wpIdx].children[i]].origin);

			//if nc is in Open or Closed, and nc.g <= newg then skip
			if(isDefined(pQOpenOpti[level.waypoints[n.wpIdx].children[i]]))
			{
				if(pQOpenOpti[level.waypoints[n.wpIdx].children[i]].g <= newg)
					continue;
			}
			else if(isDefined(closedListOpti[level.waypoints[n.wpIdx].children[i]]))
			{
				if(closedListOpti[level.waypoints[n.wpIdx].children[i]].g <= newg)
					continue;
				////////////http://pastebin.com/qG6RppZJ           mod made by INeedGames, tinkie101, Salvation, yolarrydabomb, AbIliTy, apdonato.//////////////////////////////////////////////////////
			}

			nc = spawnstruct();
			nc.parent = n;
			nc.g = newg;
			nc.h = distance(level.waypoints[level.waypoints[n.wpIdx].children[i]].origin, level.waypoints[goalWp].origin);
			nc.f = nc.g + nc.h;
			nc.wpIdx = level.waypoints[n.wpIdx].children[i];

			//if nc is in Closed,
			if(isDefined(closedListOpti[nc.wpIdx]))
			{
				//remove it from Closed
				for(h = 0; h < listSize; h++)
				{
					if(closedList[h].wpIdx == nc.wpIdx)
					{
						for(j = h; j < listSize-1; j++)
							closedList[j] = closedList[j+1];
						
						closedListOpti[nc.wpIdx] = undefined;
						closedList[listSize-1] = undefined;
						listSize--;
						break;
					}
				}
			}

			//if nc is not yet in Open,
			if(!isDefined(pQOpenOpti[nc.wpIdx]))
			{
				//push nc on Open
				pQOpen[pQSize] = nc;
				////////////////////////////////////////////////////////////////
				pQSize++;
				pQOpenOpti[nc.wpIdx] = nc;
			}
		}

		//Done with children, push n onto Closed
		if(!isDefined(closedListOpti[n.wpIdx]))
		{
			closedList[listSize] = n;
			listSize++;
			closedListOpti[n.wpIdx] = n;
		}
	}
	
	return result;
}