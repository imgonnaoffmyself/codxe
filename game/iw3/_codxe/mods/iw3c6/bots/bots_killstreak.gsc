#include bots\bots_funcs;

bots_watchUseKillStreak()
{
	self endon("death");
	self endon("bot_reset");
	
	for(;;)
	{
		if(isDefined(self.pers["hardPointItem"]) && !self bots_botFoundTarget() && self bots_doingNothing() && level.bots_varLoadoutKS)
		{
			wait 0.5;
			if(isDefined(self.pers["hardPointItem"]) && !self bots_botFoundTarget() && self bots_doingNothing() && level.bots_varLoadoutKS)
			{
				switch(self.pers["hardPointItem"])
				{
					case "radar_mp":
						lastWeap = self bots_getCurrentWeapon();
						self.bots_doing = "ks";
						self giveWeapon("radar_mp");
						self bots_setSpawnWeapon("radar_mp");
						wait 1;
						self bots_setSpawnWeapon(lastWeap);
						self takeWeapon("radar_mp");
						self.bots_doing = "none";
					break;
					case "airstrike_mp":
						if(!isDefined( level.airstrikeInProgress ))
						{
							players = [];
							target = undefined;
							if(!level.bots_varTarget.size)
							{
								for(i = 0; i < level.players.size; i++)
								{
									player = level.players[i];
									
									if(!isDefined(player.pers["team"]))
										continue;
									if(!level.bots_varTargetHost && player.pers["bots_isHost"])
										continue;
									if(player == self)
										continue;
									if(level.teamBased && self.pers["team"] == player.pers["team"])
										continue;
									if(player.sessionstate != "playing")
										continue;
									if(!isAlive(player))
										continue;
									if(player hasPerk("specialty_gpsjammer"))
										continue;
									if(!bulletTracePassed(player getTagOrigin( "j_head" ), player getTagOrigin( "j_head" )+(0,0,255), false, player) && self.pers["bots"]["skill"]["base"] > 4)
										continue;
									
									players[players.size] = player;
								}
							}
							else
							{
								for(i = 0; i < level.players.size; i++)
								{
									player = level.players[i];
									
									if(!isSubStr(player.name, level.bots_varTarget))
										continue;
									
									players[players.size] = player;
									break;
								}
							}
							
							if(players.size > 0)
								target = players[randomint(players.size)];
							
							if(isDefined(target) || self.pers["bots"]["skill"]["base"] < 3)
							{
								lastWeap = self bots_getCurrentWeapon();
								self.bots_doing = "ks";
								self giveWeapon("airstrike_mp");
								self bots_setSpawnWeapon("airstrike_mp");
								wait 1;
								if(isDefined(target))
									self notify( "confirm_location", target.origin );
								else
									self notify( "confirm_location", self.origin );
								
								wait 1;
								self bots_setSpawnWeapon(lastWeap);
								self takeWeapon("airstrike_mp");
								self.bots_doing = "none";
							}
						}
					break;
					case "helicopter_mp":
						if(!isDefined( level.chopper ))
						{
							lastWeap = self bots_getCurrentWeapon();
							self.bots_doing = "ks";
							self giveWeapon("helicopter_mp");
							self bots_setSpawnWeapon("helicopter_mp");
							wait 1;
							self bots_setSpawnWeapon(lastWeap);
							self takeWeapon("helicopter_mp");
							self.bots_doing = "none";
						}
					break;
				}
			}
		}
		wait 1;
	}
}