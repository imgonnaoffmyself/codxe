#include bots\bots_funcs;

bots_useAnims()
{
	self endon("bot_reset");
	self endon("death");
	
	lastWeap = "";
	
	for(;;)
	{
		if(level.bots_varPlayAnim == 1)
		{
			curWeap = self getCurrentWeapon();
			isAnim = isSubStr(curWeap, level.bots_animWeapSubStr);
			
			if(isAnim)
			{
				if(self.bots_isAttached != self.bots_weap)
				{
					if(self.bots_isAttached != "")
						self detach(getWeaponModel(self.bots_isAttached), "TAG_WEAPON_RIGHT", true);
					
					self attach(getWeaponModel(self.bots_weap), "TAG_WEAPON_RIGHT", true);
					self.bots_isAttached = self.bots_weap;
				}
			}
			else
			{
				if(self.bots_isAttached != "")
				{
					self detach(getWeaponModel(self.bots_isAttached), "TAG_WEAPON_RIGHT", true);
					self.bots_isAttached = "";
				}
			}
			
			weap = undefined;
			if(isDefined(level.bots_animNone[self.bots_doing]))
			{
				if(self bots\bots_walk::bots_CanMove() && !self bots\bots_aim::bots_IsStunned() && !self bots\bots_aim::bots_isArtShocked() && self.bots_fMoveSpeed >= 0.05)
				{
					switch(self.bots_stance)
					{
						case "stand":
							if(self.bots_running)
								weap = level.bots_animWeapStandRun;
							else
								weap = level.bots_animWeapStandWalk;
							
							self freezeControls(false);
						break;
						case "crouch":
							weap = level.bots_animWeapCrouch;
							self freezeControls(false);
						break;
					}
				}
			}
			else if(isDefined(level.bots_animClimb[self.bots_doing]))
			{
				weap = level.bots_animWeapClimb;
			}
			else if(isDefined(level.bots_animKnife[self.bots_doing]))
			{
				weap = "";//handled by bots_melee
				self freezeControls(false);
			}
			
			if(isDefined(weap))
			{
				if(weap != "")
				{
					if(curWeap != weap)
					{
						if(lastWeap != weap)
							self takeWeapon(lastWeap);
						
						self GiveWeapon(weap);
						self SetWeaponAmmoClip(weap, 0);
						self SetWeaponAmmoStock(weap, 0);
						self setspawnweapon(weap);
						
						lastWeap = weap;
						
						self freezeControls(false);
					}
				}
			}
			else if(isAnim)
			{
				self takeWeapon(curWeap);
				self setspawnweapon(self.bots_weap);
			}
		}
		bots_waitFrame();
	}
}