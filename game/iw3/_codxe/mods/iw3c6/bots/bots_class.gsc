#include bots\bots_funcs;

Weapon_AK47()
{
	weapon = "ak47";
	
	switch(randomInt(5))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
		case 1:
			weapon = weapon + "_gl";
		break;
		case 2:
			weapon = weapon + "_reflex";
		break;
		case 3:
			weapon = weapon + "_silencer";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_G3()
{
	weapon = "g3";
	
	switch(randomInt(5))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
		case 1:
			weapon = weapon + "_gl";
		break;
		case 2:
			weapon = weapon + "_reflex";
		break;
		case 3:
			weapon = weapon + "_silencer";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_G36C()
{
	weapon = "g36c";
	
	switch(randomInt(5))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
		case 1:
			weapon = weapon + "_gl";
		break;
		case 2:
			weapon = weapon + "_reflex";
		break;
		case 3:
			weapon = weapon + "_silencer";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_M4()
{
	weapon = "m4";
	
	switch(randomInt(5))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
		case 1:
			weapon = weapon + "_gl";
		break;
		case 2:
			weapon = weapon + "_reflex";
		break;
		case 3:
			weapon = weapon + "_silencer";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_M14()
{
	weapon = "m14";
	
	switch(randomInt(5))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
		case 1:
			weapon = weapon + "_gl";
		break;
		case 2:
			weapon = weapon + "_reflex";
		break;
		case 3:
			weapon = weapon + "_silencer";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_M16()
{
	weapon = "m16";
	
	switch(randomInt(5))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
		case 1:
			weapon = weapon + "_gl";
		break;
		case 2:
			weapon = weapon + "_reflex";
		break;
		case 3:
			weapon = weapon + "_silencer";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_MP44()
{
	return "mp44_mp";
}

Weapon_AK74U()
{
	weapon = "ak74u";
	
	switch(randomInt(4))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
		case 1:
			weapon = weapon + "_reflex";
		break;
		case 2:
			weapon = weapon + "_silencer";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_MP5()
{
	weapon = "mp5";
	
	switch(randomInt(4))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
		case 1:
			weapon = weapon + "_reflex";
		break;
		case 2:
			weapon = weapon + "_silencer";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_P90()
{
	weapon = "p90";
	
	switch(randomInt(4))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
		case 1:
			weapon = weapon + "_reflex";
		break;
		case 2:
			weapon = weapon + "_silencer";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_Skorpion()
{
	weapon = "skorpion";
	
	switch(randomInt(4))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
		case 1:
			weapon = weapon + "_reflex";
		break;
		case 2:
			weapon = weapon + "_silencer";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_UZI()
{
	weapon = "uzi";
	
	switch(randomInt(4))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
		case 1:
			weapon = weapon + "_reflex";
		break;
		case 2:
			weapon = weapon + "_silencer";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_M1014()
{
	weapon = "m1014";
	
	switch(randomInt(3))
	{
		case 0:
			weapon = weapon + "_grip";
		break;
		case 1:
			weapon = weapon + "_reflex";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_Winchester1200()
{
	weapon = "winchester1200";
	
	switch(randomInt(3))
	{
		case 0:
			weapon = weapon + "_grip";
		break;
		case 1:
			weapon = weapon + "_reflex";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_Barrett()
{
	weapon = "barrett";
	
	switch(randomInt(2))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_Dragunov()
{
	weapon = "dragunov";
	
	switch(randomInt(2))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_M21()
{
	weapon = "m21";
	
	switch(randomInt(2))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_M40A3()
{
	weapon = "m40a3";
	
	switch(randomInt(2))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_Remington700()
{
	weapon = "remington700";
	
	switch(randomInt(2))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_M60E4()
{
	weapon = "m60e4";
	
	switch(randomInt(4))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
		case 1:
			weapon = weapon + "_reflex";
		break;
		case 2:
			weapon = weapon + "_grip";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_RPD()
{
	weapon = "rpd";
	
	switch(randomInt(4))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
		case 1:
			weapon = weapon + "_reflex";
		break;
		case 2:
			weapon = weapon + "_grip";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_SAW()
{
	weapon = "saw";
	
	switch(randomInt(4))
	{
		case 0:
			weapon = weapon + "_acog";
		break;
		case 1:
			weapon = weapon + "_reflex";
		break;
		case 2:
			weapon = weapon + "_grip";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_Beretta()
{
	weapon = "beretta";
	
	switch(randomInt(2))
	{
		case 0:
			weapon = weapon + "_silencer";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_Colt45()
{
	weapon = "colt45";
	
	switch(randomInt(2))
	{
		case 0:
			weapon = weapon + "_silencer";
		break;
	}
	
	return weapon + "_mp";
}

Weapon_DesertEagle()
{
	return "deserteagle_mp";
}

Weapon_DesertEagleGold()
{
	return "deserteaglegold_mp";
}

Weapon_USP()
{
	weapon = "usp";
	
	switch(randomInt(2))
	{
		case 0:
			weapon = weapon + "_silencer";
		break;
	}
	
	return weapon + "_mp";
}

bots_setupClass()
{
	if(!self.pers["bots"]["class"]["set"] && ((level.bots_varLoadoutChange && bots_randomint(self.pers["bots"]["trait"]["change"]) == 1) || !level.bots_varLoadoutRem || self.pers["bots"]["class"]["primary"] == ""))
	{
		self.pers["bots"]["class"]["primary"] = "";
		self.pers["bots"]["class"]["primaryCamo"] = 0;
		self.pers["bots"]["class"]["secondary"] = "";
		self.pers["bots"]["class"]["perk1"] = "";
		self.pers["bots"]["class"]["perk2"] = "";
		self.pers["bots"]["class"]["perk3"] = "";
		self.pers["bots"]["class"]["offhand"] = "";

		if(self.pers["bots"]["trait"]["asshole"])
		{
			type = self.pers["bots"]["trait"]["asshole_type"];
			switch(type)
			{
				case 1: // The Tuber
					self.pers["bots"]["class"]["primary"] = "m16_gl_mp";
					self.pers["bots"]["class"]["secondary"] = "deserteaglegold_mp";
					self.pers["bots"]["class"]["perk2"] = "specialty_explosivedamage";
					self.pers["bots"]["class"]["perk3"] = "specialty_grenadepulldeath";
					self.pers["bots"]["trait"]["run"] = 250;
					self.pers["bots"]["trait"]["vengeful"] = 2;
				break;
				case 2: // The Tank
				case 4: // The Nigger
					self.pers["bots"]["class"]["primary"] = "m1014_grip_mp";
					self.pers["bots"]["class"]["secondary"] = "deserteaglegold_mp";
					self.pers["bots"]["class"]["perk2"] = "specialty_armorvest";
					self.pers["bots"]["class"]["perk3"] = "specialty_quieter";
					if(type == 2)
					{
						self.pers["bots"]["trait"]["run"] = 250;
						self.pers["bots"]["trait"]["camp"] = 0;
					}
					else
					{
						self.pers["bots"]["trait"]["run"] = 0;
						self.pers["bots"]["trait"]["camp"] = 1500;
					}
				break;
				case 3: // The Bomberman
					self.pers["bots"]["class"]["primary"] = "m40a3_acog_mp";
					self.pers["bots"]["class"]["secondary"] = "deserteaglegold_mp";
					self.pers["bots"]["class"]["perk1"] = "specialty_weapon_rpg";
					self.pers["bots"]["class"]["perk2"] = "specialty_bulletdamage";
					self.pers["bots"]["class"]["perk3"] = "specialty_bulletpenetration";
					self.pers["bots"]["trait"]["run"] = 250;
					self.pers["bots"]["trait"]["vengeful"] = 2;
				break;
			}
			return;
		}
		switch(level.bots_varLoadout)
		{
			case "default":
				switch(randomint(4))
				{
					case 0:
						if(!randomint(5))
							self.pers["bots"]["class"]["primary"] = "m40a3_mp";
						else if(!randomInt(5))
							self.pers["bots"]["class"]["primary"] = "barrett_mp";
						else if(!randomInt(5))
							self.pers["bots"]["class"]["primary"] = "remington700_mp";
						else
							self.pers["bots"]["class"]["primary"] = "m40a3_acog_mp";
					
						if(randomInt(2))
							self.pers["bots"]["class"]["perk1"] = "specialty_specialgrenade";
						else
							self.pers["bots"]["class"]["perk1"] = "specialty_extraammo";
						
						self.pers["bots"]["class"]["perk2"] = "specialty_bulletdamage";
						
						switch(randomInt(4))
						{
							case 0:
								self.pers["bots"]["class"]["perk3"] = "specialty_longersprint";
							break;
							case 1:
								self.pers["bots"]["class"]["perk3"] = "specialty_bulletaccuracy";
							break;
							case 2:
								self.pers["bots"]["class"]["perk3"] = "specialty_bulletpenetration";
							break;
							case 3:
								self.pers["bots"]["class"]["perk3"] = "specialty_quieter";
							break;
						}
						
						self.pers["bots"]["class"]["offhand"] = "concussion_grenade_mp";
						
						switch(randomInt(5))
						{
							case 0:
								self.pers["bots"]["class"]["secondary"] = "beretta_mp";
							break;
							case 1:
								self.pers["bots"]["class"]["secondary"] = Weapon_Colt45();
							break;
							case 2:
								self.pers["bots"]["class"]["secondary"] = Weapon_DesertEagle();
							break;
							case 3:
								self.pers["bots"]["class"]["secondary"] = Weapon_DesertEagleGold();
							break;
							case 4:
								self.pers["bots"]["class"]["secondary"] = "usp_mp";
							break;
						}
					break;
					case 1:
						if(!randomint(8))
							self.pers["bots"]["class"]["primary"] = "mp44_mp";
						else if(!randomInt(7))
							self.pers["bots"]["class"]["primary"] = "m4_reflex_mp";
						else if(!randomInt(6))
							self.pers["bots"]["class"]["primary"] = "g36c_reflex_mp";
						else if(!randomInt(7))
							self.pers["bots"]["class"]["primary"] = "g3_reflex_mp";
						else if(randomInt(4))
							self.pers["bots"]["class"]["primary"] = "m16_reflex_mp";
						else if(!randomInt(3))
							self.pers["bots"]["class"]["primary"] = "ak47_gl_mp";
						else
							self.pers["bots"]["class"]["primary"] = "ak47_mp";
						
						if(!isSubStr(self.pers["bots"]["class"]["primary"], "gl_"))
						{
							switch(randomInt(4))
							{
								case 0:
									self.pers["bots"]["class"]["perk1"] = "specialty_weapon_rpg";
								break;
								case 1:
									self.pers["bots"]["class"]["perk1"] = "specialty_weapon_claymore";
								break;
								case 2:
									self.pers["bots"]["class"]["perk1"] = "specialty_fraggrenade";
								break;
								case 3:
									self.pers["bots"]["class"]["perk1"] = "specialty_extraammo";
								break;
							}
						}
						
						self.pers["bots"]["class"]["perk2"] = "specialty_bulletdamage";
						
						switch(randomInt(4))
						{
							case 0:
								self.pers["bots"]["class"]["perk3"] = "specialty_bulletaccuracy";
							break;
							case 1:
								self.pers["bots"]["class"]["perk3"] = "specialty_grenadepulldeath";
							break;
							case 2:
								self.pers["bots"]["class"]["perk3"] = "specialty_bulletpenetration";
							break;
							case 3:
								self.pers["bots"]["class"]["perk3"] = "specialty_quieter";
							break;
						}
						
						if(!randomInt(3))
							self.pers["bots"]["class"]["offhand"] = "flash_grenade_mp";
						else
							self.pers["bots"]["class"]["offhand"] = "concussion_grenade_mp";
						
						switch(randomInt(5))
						{
							case 0:
								self.pers["bots"]["class"]["secondary"] = Weapon_Beretta();
							break;
							case 1:
								self.pers["bots"]["class"]["secondary"] = Weapon_Colt45();
							break;
							case 2:
								self.pers["bots"]["class"]["secondary"] = Weapon_DesertEagle();
							break;
							case 3:
								self.pers["bots"]["class"]["secondary"] = Weapon_DesertEagleGold();
							break;
							case 4:
								self.pers["bots"]["class"]["secondary"] = "usp_mp";
							break;
						}
					break;
					case 2:
						if(randomInt(5))
						{
							switch(randomInt(9))
							{
								case 0:
								case 4:
								case 7:
									self.pers["bots"]["class"]["primary"] = "ak74u_mp";
								break;
								case 1:
								case 5:
								case 8:
									if(!randomInt(3))
										self.pers["bots"]["class"]["primary"] = "mp5_mp";
									else if(randomInt(3))
										self.pers["bots"]["class"]["primary"] = "mp5_reflex_mp";
									else
										self.pers["bots"]["class"]["primary"] = "mp5_silencer_mp";
								break;
								case 2:
								case 6:
									if(!randomInt(3))
										self.pers["bots"]["class"]["primary"] = "p90_mp";
									else if(randomInt(2))
										self.pers["bots"]["class"]["primary"] = "p90_reflex_mp";
									else
										self.pers["bots"]["class"]["primary"] = "p90_silencer_mp";
								break;
								case 3:
									if(randomInt(2))
										self.pers["bots"]["class"]["primary"] = "skorpion_mp";
									else
										self.pers["bots"]["class"]["primary"] = "skorpion_reflex_mp";
								break;
							}
						}
						else
						{
							if(randomInt(2))
								self.pers["bots"]["class"]["primary"] = "m4_silencer_mp";
							else
								self.pers["bots"]["class"]["primary"] = "g36c_silencer_mp";
						}
						
						switch(randomInt(10))
						{
							case 0:
								self.pers["bots"]["class"]["perk1"] = "specialty_specialgrenade";
							break;
							case 1:
								self.pers["bots"]["class"]["perk1"] = "specialty_weapon_rpg";
							break;
							case 2:
								self.pers["bots"]["class"]["perk1"] = "specialty_weapon_claymore";
							break;
							case 3:
								self.pers["bots"]["class"]["perk1"] = "specialty_fraggrenade";
							break;
							case 4:
							case 6:
							case 7:
							case 8:
							case 9:
								self.pers["bots"]["class"]["perk1"] = "specialty_extraammo";
							break;
							case 5:
								self.pers["bots"]["class"]["perk1"] = "specialty_detectexplosive";
							break;
						}
						
						if(isSubStr(self.pers["bots"]["class"]["primary"], "silencer_") && randomInt(2))
							self.pers["bots"]["class"]["perk2"] = "specialty_gpsjammer";
						else if(isSubStr(self.pers["bots"]["class"]["primary"], "skorpion_") && randomInt(2))
						{
							if(randomInt(2))
								self.pers["bots"]["class"]["perk2"] = "specialty_fastreload";
							else
								self.pers["bots"]["class"]["perk2"] = "specialty_rof";
						}
						else if(!randomInt(3))
							self.pers["bots"]["class"]["perk2"] = "specialty_armorvest";
						else
							self.pers["bots"]["class"]["perk2"] = "specialty_bulletdamage";
						
						switch(randomInt(5))
						{
							case 0:
								self.pers["bots"]["class"]["perk3"] = "specialty_longersprint";
							break;
							case 1:
								self.pers["bots"]["class"]["perk3"] = "specialty_bulletaccuracy";
							break;
							case 2:
								self.pers["bots"]["class"]["perk3"] = "specialty_pistoldeath";
							break;
							case 3:
								self.pers["bots"]["class"]["perk3"] = "specialty_grenadepulldeath";
							break;
							case 4:
								self.pers["bots"]["class"]["perk3"] = "specialty_quieter";
							break;
						}
						
						if(!randomInt(3))
							self.pers["bots"]["class"]["offhand"] = "flash_grenade_mp";
						else
							self.pers["bots"]["class"]["offhand"] = "concussion_grenade_mp";
						
						switch(randomInt(5))
						{
							case 0:
								self.pers["bots"]["class"]["secondary"] = Weapon_Beretta();
							break;
							case 1:
								self.pers["bots"]["class"]["secondary"] = Weapon_Colt45();
							break;
							case 2:
								self.pers["bots"]["class"]["secondary"] = Weapon_DesertEagle();
							break;
							case 3:
								self.pers["bots"]["class"]["secondary"] = Weapon_DesertEagleGold();
							break;
							case 4:
								self.pers["bots"]["class"]["secondary"] = "usp_mp";
							break;
						}
					break;
					case 3:
						if(randomInt(2))
							self.pers["bots"]["class"]["primary"] = "rpd_reflex_mp";
						else if(randomInt(2))
							self.pers["bots"]["class"]["primary"] = "m60e4_reflex_mp";
						else if(randomInt(3))
							self.pers["bots"]["class"]["primary"] = "m14_reflex_mp";
						else if(!randomInt(3))
							self.pers["bots"]["class"]["primary"] = "saw_grip_mp";
						else
							self.pers["bots"]["class"]["primary"] = "m14_gl_mp";
						
						if(!isSubStr(self.pers["bots"]["class"]["primary"], "gl_") || !isSubStr(self.pers["bots"]["class"]["primary"], "grip_"))
						{
							switch(randomInt(3))
							{
								case 0:
									self.pers["bots"]["class"]["perk1"] = "specialty_weapon_rpg";
								break;
								case 1:
									self.pers["bots"]["class"]["perk1"] = "specialty_fraggrenade";
								break;
								case 2:
									self.pers["bots"]["class"]["perk1"] = "specialty_extraammo";
								break;
							}
						}
						
						if(isSubStr(self.pers["bots"]["class"]["primary"], "rpd_"))
							self.pers["bots"]["class"]["perk2"] = "specialty_bulletdamage";
						else if(isSubStr(self.pers["bots"]["class"]["primary"], "m60e4_") && randomInt(2))
							self.pers["bots"]["class"]["perk2"] = "specialty_rof";
						else if(!randomInt(3))
							self.pers["bots"]["class"]["perk2"] = "specialty_twoprimaries";
						else if((isSubStr(self.pers["bots"]["class"]["primary"], "gl_") || self.pers["bots"]["class"]["perk1"] == "specialty_fraggrenade" || self.pers["bots"]["class"]["perk1"] == "specialty_weapon_rpg") && !randomInt(3))
							self.pers["bots"]["class"]["perk2"] = "specialty_explosivedamage";
						else
							self.pers["bots"]["class"]["perk2"] = "specialty_armorvest";
						
						switch(randomInt(4))
						{
							case 0:
								self.pers["bots"]["class"]["perk3"] = "specialty_bulletaccuracy";
							break;
							case 1:
								self.pers["bots"]["class"]["perk3"] = "specialty_pistoldeath";
							break;
							case 2:
								self.pers["bots"]["class"]["perk3"] = "specialty_grenadepulldeath";
							break;
							case 3:
								self.pers["bots"]["class"]["perk3"] = "specialty_bulletpenetration";
							break;
						}
						
						if(self.pers["bots"]["class"]["perk2"] != "specialty_twoprimaries")
						{
							switch(randomInt(5))
							{
								case 0:
									self.pers["bots"]["class"]["secondary"] = Weapon_Beretta();
								break;
								case 1:
									self.pers["bots"]["class"]["secondary"] = Weapon_Colt45();
								break;
								case 2:
									self.pers["bots"]["class"]["secondary"] = Weapon_DesertEagle();
								break;
								case 3:
									self.pers["bots"]["class"]["secondary"] = Weapon_DesertEagleGold();
								break;
								case 4:
									self.pers["bots"]["class"]["secondary"] = "usp_mp";
								break;
							}
						}
						else
						{
							switch(randomInt(6))
							{
								case 0:
									self.pers["bots"]["class"]["secondary"] = "m1014_mp";
								break;
								case 1:
									self.pers["bots"]["class"]["secondary"] = "winchester1200_mp";
								break;
								case 2:
									self.pers["bots"]["class"]["secondary"] = "skorpion_mp";
								break;
								case 3:
									self.pers["bots"]["class"]["secondary"] = "ak47_gl_mp";
								break;
								case 4:
									if(randomInt(2))
										self.pers["bots"]["class"]["secondary"] = "m4_gl_mp";
									else
										self.pers["bots"]["class"]["secondary"] = "g36c_gl_mp";
								break;
								case 5:
									if(!randomInt(4))
										self.pers["bots"]["class"]["secondary"] = "g36c_mp";
									else if(randomInt(2))
										self.pers["bots"]["class"]["secondary"] = "g36c_reflex_mp";
									else
										self.pers["bots"]["class"]["secondary"] = "g36c_silencer_mp";
								break;
							}
						}
					break;
				}
			break;
			case "random":
				switch(randomInt(22))
				{
					case 0:
						self.pers["bots"]["class"]["primary"] = Weapon_AK47();
					break;
					case 1:
						self.pers["bots"]["class"]["primary"] = Weapon_AK74U();
					break;
					case 2:
						self.pers["bots"]["class"]["primary"] = Weapon_Barrett();
					break;
					case 3:
						self.pers["bots"]["class"]["primary"] = Weapon_Dragunov();
					break;
					case 4:
						self.pers["bots"]["class"]["primary"] = Weapon_G3();
					break;
					case 5:
						self.pers["bots"]["class"]["primary"] = Weapon_G36C();
					break;
					case 6:
						self.pers["bots"]["class"]["primary"] = Weapon_M1014();
					break;
					case 7:
						self.pers["bots"]["class"]["primary"] = Weapon_M14();
					break;
					case 8:
						self.pers["bots"]["class"]["primary"] = Weapon_M16();
					break;
					case 9:
						self.pers["bots"]["class"]["primary"] = Weapon_M21();
					break;
					case 10:
						self.pers["bots"]["class"]["primary"] = Weapon_M4();
					break;
					case 11:
						self.pers["bots"]["class"]["primary"] = Weapon_M40A3();
					break;
					case 12:
						self.pers["bots"]["class"]["primary"] = Weapon_M60E4();
					break;
					case 13:
						self.pers["bots"]["class"]["primary"] = Weapon_MP44();
					break;
					case 14:
						self.pers["bots"]["class"]["primary"] = Weapon_MP5();
					break;
					case 15:
						self.pers["bots"]["class"]["primary"] = Weapon_P90();
					break;
					case 16:
						self.pers["bots"]["class"]["primary"] = Weapon_RPD();
					break;
					case 17:
						self.pers["bots"]["class"]["primary"] = Weapon_SAW();
					break;
					case 18:
						self.pers["bots"]["class"]["primary"] = Weapon_Skorpion();
					break;
					case 19:
						self.pers["bots"]["class"]["primary"] = Weapon_UZI();
					break;
					case 20:
						self.pers["bots"]["class"]["primary"] = Weapon_Winchester1200();
					break;
					case 21:
						self.pers["bots"]["class"]["primary"] = Weapon_Remington700();
					break;
				}
				weapToks = strTok(self.pers["bots"]["class"]["primary"], "_");
				switch(randomInt(7))
				{
					case 0:
						self.pers["bots"]["class"]["perk2"] = "specialty_bulletdamage";
					break;
					case 1:
						self.pers["bots"]["class"]["perk2"] = "specialty_armorvest";
					break;
					case 2:
						self.pers["bots"]["class"]["perk2"] = "specialty_fastreload";
					break;
					case 3:
						self.pers["bots"]["class"]["perk2"] = "specialty_rof";
					break;
					case 4:
						self.pers["bots"]["class"]["perk2"] = "specialty_twoprimaries";
					break;
					case 5:
						self.pers["bots"]["class"]["perk2"] = "specialty_gpsjammer";
					break;
					case 6:
						self.pers["bots"]["class"]["perk2"] = "specialty_explosivedamage";
					break;
				}
				switch(randomInt(8))
				{
					case 0:
						self.pers["bots"]["class"]["perk3"] = "specialty_longersprint";
					break;
					case 1:
						self.pers["bots"]["class"]["perk3"] = "specialty_bulletaccuracy";
					break;
					case 2:
						self.pers["bots"]["class"]["perk3"] = "specialty_pistoldeath";
					break;
					case 3:
						self.pers["bots"]["class"]["perk3"] = "specialty_grenadepulldeath";
					break;
					case 4:
						self.pers["bots"]["class"]["perk3"] = "specialty_bulletpenetration";
					break;
					case 5:
						self.pers["bots"]["class"]["perk3"] = "specialty_holdbreath";
					break;
					case 6:
						self.pers["bots"]["class"]["perk3"] = "specialty_quieter";
					break;
					case 7:
						self.pers["bots"]["class"]["perk3"] = "specialty_parabolic";
					break;
				}
				if(self.pers["bots"]["class"]["perk2"] != "specialty_twoprimaries")
				{
					switch(randomInt(5))
					{
						case 0:
							self.pers["bots"]["class"]["secondary"] = Weapon_Beretta();
						break;
						case 1:
							self.pers["bots"]["class"]["secondary"] = Weapon_Colt45();
						break;
						case 2:
							self.pers["bots"]["class"]["secondary"] = Weapon_DesertEagle();
						break;
						case 3:
							self.pers["bots"]["class"]["secondary"] = Weapon_DesertEagleGold();
						break;
						case 4:
							self.pers["bots"]["class"]["secondary"] = Weapon_USP();
						break;
					}
				}
				else
				{
					weapToks2 = strTok(self.pers["bots"]["class"]["secondary"], "_");
					while(!weapToks2.size || weapToks2[0] == weapToks[0])
					{
						switch(randomInt(22))
						{
							case 0:
								self.pers["bots"]["class"]["secondary"] = Weapon_AK47();
							break;
							case 1:
								self.pers["bots"]["class"]["secondary"] = Weapon_AK74U();
							break;
							case 2:
								self.pers["bots"]["class"]["secondary"] = Weapon_Barrett();
							break;
							case 3:
								self.pers["bots"]["class"]["secondary"] = Weapon_Dragunov();
							break;
							case 4:
								self.pers["bots"]["class"]["secondary"] = Weapon_G3();
							break;
							case 5:
								self.pers["bots"]["class"]["secondary"] = Weapon_G36C();
							break;
							case 6:
								self.pers["bots"]["class"]["secondary"] = Weapon_M1014();
							break;
							case 7:
								self.pers["bots"]["class"]["secondary"] = Weapon_M14();
							break;
							case 8:
								self.pers["bots"]["class"]["secondary"] = Weapon_M16();
							break;
							case 9:
								self.pers["bots"]["class"]["secondary"] = Weapon_M21();
							break;
							case 10:
								self.pers["bots"]["class"]["secondary"] = Weapon_M4();
							break;
							case 11:
								self.pers["bots"]["class"]["secondary"] = Weapon_M40A3();
							break;
							case 12:
								self.pers["bots"]["class"]["secondary"] = Weapon_M60E4();
							break;
							case 13:
								self.pers["bots"]["class"]["secondary"] = Weapon_MP44();
							break;
							case 14:
								self.pers["bots"]["class"]["secondary"] = Weapon_MP5();
							break;
							case 15:
								self.pers["bots"]["class"]["secondary"] = Weapon_P90();
							break;
							case 16:
								self.pers["bots"]["class"]["secondary"] = Weapon_RPD();
							break;
							case 17:
								self.pers["bots"]["class"]["secondary"] = Weapon_SAW();
							break;
							case 18:
								self.pers["bots"]["class"]["secondary"] = Weapon_Skorpion();
							break;
							case 19:
								self.pers["bots"]["class"]["secondary"] = Weapon_UZI();
							break;
							case 20:
								self.pers["bots"]["class"]["secondary"] = Weapon_Winchester1200();
							break;
							case 21:
								self.pers["bots"]["class"]["secondary"] = Weapon_Remington700();
							break;
						}
						weapToks2 = strTok(self.pers["bots"]["class"]["secondary"], "_");
					}
				}
				weapToks2 = strTok(self.pers["bots"]["class"]["secondary"], "_");
				if(weapToks[1] != "grip" && weapToks[1] != "gl" && weapToks2[1] != "grip" && weapToks2[1] != "gl")
				{
					switch(randomInt(7))
					{
						case 0:
							self.pers["bots"]["class"]["perk1"] = "specialty_specialgrenade";
						break;
						case 1:
							self.pers["bots"]["class"]["perk1"] = "specialty_weapon_rpg";
						break;
						case 2:
							self.pers["bots"]["class"]["perk1"] = "specialty_weapon_claymore";
						break;
						case 3:
							self.pers["bots"]["class"]["perk1"] = "specialty_fraggrenade";
						break;
						case 4:
							self.pers["bots"]["class"]["perk1"] = "specialty_extraammo";
						break;
						case 5:
							self.pers["bots"]["class"]["perk1"] = "specialty_detectexplosive";
						break;
						case 6:
							self.pers["bots"]["class"]["perk1"] = "specialty_weapon_c4";
						break;
					}
				}
				switch(randomInt(3))
				{
					case 0:
						self.pers["bots"]["class"]["offhand"] = "flash_grenade_mp";
					break;
					case 1:
						self.pers["bots"]["class"]["offhand"] = "concussion_grenade_mp";
					break;
					case 2:
						if(self.pers["bots"]["class"]["perk1"] != "specialty_specialgrenade")
							self.pers["bots"]["class"]["offhand"] = "smoke_grenade_mp";
						else
							self.pers["bots"]["class"]["offhand"] = "concussion_grenade_mp";
					break;
				}
			break;
			case "snipe":
				if(!randomint(5))
					self.pers["bots"]["class"]["primary"] = "m40a3_mp";
				else if(!randomInt(5))
					self.pers["bots"]["class"]["primary"] = "barrett_mp";
				else if(!randomInt(5))
					self.pers["bots"]["class"]["primary"] = "remington700_mp";
				else
					self.pers["bots"]["class"]["primary"] = "m40a3_acog_mp";
			
				if(randomInt(2))
					self.pers["bots"]["class"]["perk1"] = "specialty_specialgrenade";
				else
					self.pers["bots"]["class"]["perk1"] = "specialty_extraammo";
				
				self.pers["bots"]["class"]["perk2"] = "specialty_bulletdamage";
				
				switch(randomInt(4))
				{
					case 0:
						self.pers["bots"]["class"]["perk3"] = "specialty_longersprint";
					break;
					case 1:
						self.pers["bots"]["class"]["perk3"] = "specialty_bulletaccuracy";
					break;
					case 2:
						self.pers["bots"]["class"]["perk3"] = "specialty_bulletpenetration";
					break;
					case 3:
						self.pers["bots"]["class"]["perk3"] = "specialty_quieter";
					break;
				}
				
				self.pers["bots"]["class"]["offhand"] = "concussion_grenade_mp";
				
				switch(randomInt(5))
				{
					case 0:
						self.pers["bots"]["class"]["secondary"] = "beretta_mp";
					break;
					case 1:
						self.pers["bots"]["class"]["secondary"] = Weapon_Colt45();
					break;
					case 2:
						self.pers["bots"]["class"]["secondary"] = Weapon_DesertEagle();
					break;
					case 3:
						self.pers["bots"]["class"]["secondary"] = Weapon_DesertEagleGold();
					break;
					case 4:
						self.pers["bots"]["class"]["secondary"] = "usp_mp";
					break;
				}
			break;
			case "tube":
				self.pers["bots"]["class"]["primary"] = "ak47_gl_mp";
				self.pers["bots"]["class"]["secondary"] = "m16_gl_mp";
				self.pers["bots"]["class"]["offhand"] = "concussion_grenade_mp";
				self.pers["bots"]["class"]["perk1"] = "specialty_fraggrenade";
				self.pers["bots"]["class"]["perk2"] = "specialty_explosivedamage";
				self.pers["bots"]["class"]["perk3"] = "specialty_grenadepulldeath";
				self.pers["bots"]["trait"]["nade"] = 10;
			break;
			case "fmj":
				self.pers["bots"]["class"]["primary"] = "m60e4_reflex_mp";
				self.pers["bots"]["class"]["secondary"] = "m60e4_grip_mp";
				self.pers["bots"]["class"]["offhand"] = "concussion_grenade_mp";
				self.pers["bots"]["class"]["perk1"] = "specialty_armorvest";
				self.pers["bots"]["class"]["perk2"] = "specialty_bulletdamage";
				self.pers["bots"]["class"]["perk3"] = "specialty_bulletpenetration";
			break;
			case "level":
				rankID = self maps\mp\gametypes\_rank::getRankForXp( self getStat( int(tableLookup( "mp/playerStatsTable.csv", 1, "rankxp", 0 )) ) ) + 1;
				if(rankID >= 4)
				{
					while(self.pers["bots"]["class"]["primary"] == "")
					{
						switch(randomInt(22))
						{
							case 0:
								if(bots_isItemUnlocked("ak47", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_AK47();
							break;
							case 1:
								if(bots_isItemUnlocked("ak74u", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_AK74U();
							break;
							case 2:
								if(bots_isItemUnlocked("barrett", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_Barrett();
							break;
							case 3:
								if(bots_isItemUnlocked("dragunov", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_Dragunov();
							break;
							case 4:
								if(bots_isItemUnlocked("g3", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_G3();
							break;
							case 5:
								if(bots_isItemUnlocked("g36c", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_G36C();
							break;
							case 6:
								if(bots_isItemUnlocked("m1014", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_M1014();
							break;
							case 7:
								if(bots_isItemUnlocked("m14", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_M14();
							break;
							case 8:
								if(bots_isItemUnlocked("m16", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_M16();
							break;
							case 9:
								if(bots_isItemUnlocked("m21", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_M21();
							break;
							case 10:
								if(bots_isItemUnlocked("m4", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_M4();
							break;
							case 11:
								if(bots_isItemUnlocked("m40a3", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_M40A3();
							break;
							case 12:
								if(bots_isItemUnlocked("m60e4", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_M60E4();
							break;
							case 13:
								if(bots_isItemUnlocked("mp44", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_MP44();
							break;
							case 14:
								if(bots_isItemUnlocked("mp5", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_MP5();
							break;
							case 15:
								if(bots_isItemUnlocked("p90", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_P90();
							break;
							case 16:
								if(bots_isItemUnlocked("rpd", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_RPD();
							break;
							case 17:
								if(bots_isItemUnlocked("saw", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_SAW();
							break;
							case 18:
								if(bots_isItemUnlocked("skorpion", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_Skorpion();
							break;
							case 19:
								if(bots_isItemUnlocked("uzi", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_UZI();
							break;
							case 20:
								if(bots_isItemUnlocked("winchester1200", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_Winchester1200();
							break;
							case 21:
								if(bots_isItemUnlocked("remington700", rankID))
									self.pers["bots"]["class"]["primary"] = Weapon_Remington700();
							break;
						}
					}
					weapToks = strTok(self.pers["bots"]["class"]["primary"], "_");
					
					while(self.pers["bots"]["class"]["perk2"] == "")
					{
						switch(randomInt(7))
						{
							case 0:
								if(bots_isItemUnlocked("specialty_bulletdamage", rankID))
									self.pers["bots"]["class"]["perk2"] = "specialty_bulletdamage";
							break;
							case 1:
								if(bots_isItemUnlocked("specialty_armorvest", rankID))
									self.pers["bots"]["class"]["perk2"] = "specialty_armorvest";
							break;
							case 2:
								if(bots_isItemUnlocked("specialty_fastreload", rankID))
									self.pers["bots"]["class"]["perk2"] = "specialty_fastreload";
							break;
							case 3:
								if(bots_isItemUnlocked("specialty_rof", rankID))
									self.pers["bots"]["class"]["perk2"] = "specialty_rof";
							break;
							case 4:
								if(bots_isItemUnlocked("specialty_twoprimaries", rankID))
									self.pers["bots"]["class"]["perk2"] = "specialty_twoprimaries";
							break;
							case 5:
								if(bots_isItemUnlocked("specialty_gpsjammer", rankID))
									self.pers["bots"]["class"]["perk2"] = "specialty_gpsjammer";
							break;
							case 6:
								if(bots_isItemUnlocked("specialty_explosivedamage", rankID))
									self.pers["bots"]["class"]["perk2"] = "specialty_explosivedamage";
							break;
						}
					}
					
					while(self.pers["bots"]["class"]["perk3"] == "")
					{
						switch(randomInt(8))
						{
							case 0:
								if(bots_isItemUnlocked("specialty_longersprint", rankID))
									self.pers["bots"]["class"]["perk3"] = "specialty_longersprint";
							break;
							case 1:
								if(bots_isItemUnlocked("specialty_bulletaccuracy", rankID))
									self.pers["bots"]["class"]["perk3"] = "specialty_bulletaccuracy";
							break;
							case 2:
								if(bots_isItemUnlocked("specialty_pistoldeath", rankID))
									self.pers["bots"]["class"]["perk3"] = "specialty_pistoldeath";
							break;
							case 3:
								if(bots_isItemUnlocked("specialty_grenadepulldeath", rankID))
									self.pers["bots"]["class"]["perk3"] = "specialty_grenadepulldeath";
							break;
							case 4:
								if(bots_isItemUnlocked("specialty_bulletpenetration", rankID))
									self.pers["bots"]["class"]["perk3"] = "specialty_bulletpenetration";
							break;
							case 5:
								if(bots_isItemUnlocked("specialty_holdbreath", rankID))
									self.pers["bots"]["class"]["perk3"] = "specialty_holdbreath";
							break;
							case 6:
								if(bots_isItemUnlocked("specialty_quieter", rankID))
									self.pers["bots"]["class"]["perk3"] = "specialty_quieter";
							break;
							case 7:
								if(bots_isItemUnlocked("specialty_parabolic", rankID))
									self.pers["bots"]["class"]["perk3"] = "specialty_parabolic";
							break;
						}
					}
					
					if(self.pers["bots"]["class"]["perk2"] != "specialty_twoprimaries")
					{
						while(self.pers["bots"]["class"]["secondary"] == "")
						{
							switch(randomInt(5))
							{
								case 0:
									if(bots_isItemUnlocked("beretta", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_Beretta();
								break;
								case 1:
									if(bots_isItemUnlocked("colt45", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_Colt45();
								break;
								case 2:
									if(bots_isItemUnlocked("deserteagle", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_DesertEagle();
								break;
								case 3:
									if(bots_isItemUnlocked("deserteaglegold", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_DesertEagleGold();
								break;
								case 4:
									if(bots_isItemUnlocked("usp", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_USP();
								break;
							}
						}
					}
					else
					{
						weapToks2 = strTok(self.pers["bots"]["class"]["secondary"], "_");
						while(!weapToks2.size || weapToks2[0] == weapToks[0])
						{
							switch(randomInt(22))
							{
								case 0:
									if(bots_isItemUnlocked("ak47", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_AK47();
								break;
								case 1:
									if(bots_isItemUnlocked("ak74u", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_AK74U();
								break;
								case 2:
									if(bots_isItemUnlocked("barrett", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_Barrett();
								break;
								case 3:
									if(bots_isItemUnlocked("dragunov", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_Dragunov();
								break;
								case 4:
									if(bots_isItemUnlocked("g3", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_G3();
								break;
								case 5:
									if(bots_isItemUnlocked("g36c", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_G36C();
								break;
								case 6:
									if(bots_isItemUnlocked("m1014", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_M1014();
								break;
								case 7:
									if(bots_isItemUnlocked("m14", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_M14();
								break;
								case 8:
									if(bots_isItemUnlocked("m16", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_M16();
								break;
								case 9:
									if(bots_isItemUnlocked("m21", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_M21();
								break;
								case 10:
									if(bots_isItemUnlocked("m4", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_M4();
								break;
								case 11:
									if(bots_isItemUnlocked("m40a3", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_M40A3();
								break;
								case 12:
									if(bots_isItemUnlocked("m60e4", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_M60E4();
								break;
								case 13:
									if(bots_isItemUnlocked("mp44", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_MP44();
								break;
								case 14:
									if(bots_isItemUnlocked("mp5", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_MP5();
								break;
								case 15:
									if(bots_isItemUnlocked("p90", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_P90();
								break;
								case 16:
									if(bots_isItemUnlocked("rpd", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_RPD();
								break;
								case 17:
									if(bots_isItemUnlocked("saw", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_SAW();
								break;
								case 18:
									if(bots_isItemUnlocked("skorpion", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_Skorpion();
								break;
								case 19:
									if(bots_isItemUnlocked("uzi", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_UZI();
								break;
								case 20:
									if(bots_isItemUnlocked("winchester1200", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_Winchester1200();
								break;
								case 21:
									if(bots_isItemUnlocked("remington700", rankID))
										self.pers["bots"]["class"]["secondary"] = Weapon_Remington700();
								break;
							}
							weapToks2 = strTok(self.pers["bots"]["class"]["secondary"], "_");
						}
					}
					weapToks2 = strTok(self.pers["bots"]["class"]["secondary"], "_");
					
					if(weapToks[1] != "grip" && weapToks[1] != "gl" && weapToks2[1] != "grip" && weapToks2[1] != "gl")
					{
						while(self.pers["bots"]["class"]["perk1"] == "")
						{
							switch(randomInt(7))
							{
								case 0:
									if(bots_isItemUnlocked("specialty_specialgrenade", rankID))
										self.pers["bots"]["class"]["perk1"] = "specialty_specialgrenade";
								break;
								case 1:
									if(bots_isItemUnlocked("specialty_weapon_rpg", rankID))
										self.pers["bots"]["class"]["perk1"] = "specialty_weapon_rpg";
								break;
								case 2:
									if(bots_isItemUnlocked("specialty_weapon_claymore", rankID))
										self.pers["bots"]["class"]["perk1"] = "specialty_weapon_claymore";
								break;
								case 3:
									if(bots_isItemUnlocked("specialty_fraggrenade", rankID))
										self.pers["bots"]["class"]["perk1"] = "specialty_fraggrenade";
								break;
								case 4:
									if(bots_isItemUnlocked("specialty_extraammo", rankID))
										self.pers["bots"]["class"]["perk1"] = "specialty_extraammo";
								break;
								case 5:
									if(bots_isItemUnlocked("specialty_detectexplosive", rankID))
										self.pers["bots"]["class"]["perk1"] = "specialty_detectexplosive";
								break;
								case 6:
									if(bots_isItemUnlocked("specialty_weapon_c4", rankID))
										self.pers["bots"]["class"]["perk1"] = "specialty_weapon_c4";
								break;
							}
						}
					}
					
					switch(randomInt(3))
					{
						case 0:
							self.pers["bots"]["class"]["offhand"] = "flash_grenade_mp";
						break;
						case 1:
							self.pers["bots"]["class"]["offhand"] = "concussion_grenade_mp";
						break;
						case 2:
							if(self.pers["bots"]["class"]["perk1"] != "specialty_specialgrenade")
								self.pers["bots"]["class"]["offhand"] = "smoke_grenade_mp";
							else
								self.pers["bots"]["class"]["offhand"] = "concussion_grenade_mp";
						break;
					}
				}
				else
				{
					_class = "";
					while(_class == "")
					{
						switch(randomInt(5))
						{
							case 0:
								_class = "CLASS_ASSAULT";
							break;
							case 1:
								_class = "CLASS_SPECOPS";
							break;
							case 2:
								_class = "CLASS_HEAVYGUNNER";
							break;
							case 3:
								if(rankID >= 2)
									_class = "CLASS_DEMOLITIONS";
							break;
							case 4:
								if(rankID >= 3)
									_class = "CLASS_SNIPER";
							break;
						}
					}
					
					self.pers["bots"]["class"]["primary"] = level.classWeapons["axis"][_class][0];
					self.pers["bots"]["class"]["primaryCamo"] = 0;
					self.pers["bots"]["class"]["secondary"] = level.classSidearm["axis"][_class];
					self.pers["bots"]["class"]["perk1"] = level.default_perk[_class][0];
					self.pers["bots"]["class"]["perk2"] = level.default_perk[_class][1];
					self.pers["bots"]["class"]["perk3"] = level.default_perk[_class][2];
					self.pers["bots"]["class"]["offhand"] = level.classGrenades[_class]["secondary"]["type"];
				}
			break;
		}
	}
}

bots_doClass()
{
	self endon("bot_reset");
	self endon("death");
	
	self bots_setupClass();
	if(level.bots_varLoadout != "mod" && !level.oldschool)
	{
		self clearPerks();
		self takeAllWeapons();
		self.specialty = [];
		self.detectExplosives = false;
		
		primary = self.pers["bots"]["class"]["primary"];
		camo = self.pers["bots"]["class"]["primaryCamo"];
		secondary = self.pers["bots"]["class"]["secondary"];
		offhand = self.pers["bots"]["class"]["offhand"];
		perk1 = self.pers["bots"]["class"]["perk1"];
		perk2 = self.pers["bots"]["class"]["perk2"];
		perk3 = self.pers["bots"]["class"]["perk3"];
		
		if(!level.bots_varLoadoutLS && perk3 == "specialty_pistoldeath")
			perk3 = "specialty_quieter";
		
		if(!level.bots_varLoadoutNade && perk3 == "specialty_grenadepulldeath")
			perk3 = "specialty_quieter";
		
		if(!level.bots_varLoadoutTube)
		{
			if(isSubStr(primary, "_gl_"))
				primary = "ak47_mp";
			if(isSubStr(secondary, "_gl_"))
				secondary = "ak47_mp";
			if(perk1 == "specialty_weapon_rpg")
				perk1 = "specialty_extraammo";
		}
		
		if(!level.bots_varLoadoutSniper)
		{
			if(isSubStr(primary, "m21_") || isSubStr(primary, "m40a3_") || isSubStr(primary, "barrett_") || isSubStr(primary, "dragunov_") || isSubStr(primary, "remington700_"))
				primary = "ak47_mp";
			if(isSubStr(secondary, "m21_") || isSubStr(secondary, "m40a3_") || isSubStr(secondary, "barrett_") || isSubStr(secondary, "dragunov_") || isSubStr(secondary, "remington700_"))
				secondary = "ak47_mp";
		}
		
		if(!level.bots_varLoadoutJug && perk2 == "specialty_armorvest")
			perk2 = "specialty_fastreload";
		
		if(!level.bots_varLoadoutShotgun)
		{
			if(isSubStr(primary, "winchester1200_") || isSubStr(primary, "m1014_"))
				primary = "ak47_mp";
			if(isSubStr(secondary, "winchester1200_") || isSubStr(secondary, "m1014_"))
				secondary = "ak47_mp";
		}
		
		if ( perk1 != "specialty_null" && perk1 != "specialty_none" && perk1 != "" )
		{
			self.custom_class[self.class_num]["specialty1"] = perk1;
			self.specialty[self.specialty.size] = perk1;
			if(!isSubStr( perk1, "specialty_weapon_" ))
				self setPerk(perk1);
		}
		
		if ( perk2 != "specialty_null" && perk2 != "specialty_none" &&  perk2 != "" )
		{
			self.custom_class[self.class_num]["specialty2"] = perk2;
			self.specialty[self.specialty.size] = perk2;
			self setPerk(perk2);
		}
		
		if ( perk3 != "specialty_null" && perk3 != "specialty_none" &&  perk3 != "" )
		{
			self.custom_class[self.class_num]["specialty3"] = perk3;
			self.specialty[self.specialty.size] = perk3;
			self setPerk(perk3);
		}
		
		self.custom_class[self.class_num]["camo_num"] = camo;
		
		self GiveWeapon( secondary );
		if ( self hasPerk( "specialty_extraammo" ) )
			self giveMaxAmmo( secondary );
		
		primaryTokens = strtok( primary, "_" );
		self.pers["primaryWeapon"] = primaryTokens[0];
		
		self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers["primaryWeapon"] );
		
		self GiveWeapon( primary, camo );
		if ( self hasPerk( "specialty_extraammo" ) )
			self giveMaxAmmo( primary );
		self setSpawnWeapon( primary );
		self.bots_weap = primary;
		
		self GiveWeapon( "frag_grenade_mp" );
		self SetWeaponAmmoClip( "frag_grenade_mp", 1 );
		self SwitchToOffhand( "frag_grenade_mp" );
		
		self GiveWeapon( offhand );
		self SetWeaponAmmoClip( offhand, 1 );
		if ( offhand == level.weapons["flash"])
			self setOffhandSecondaryClass("flash");
		else
			self setOffhandSecondaryClass("smoke");
		
		self SetActionSlot( 3, "altMode" );
		if(isSubStr( perk1, "specialty_weapon_" ))
		{
			perk1toks = strTok(perk1, "_");
			weap = perk1toks[2] + "_mp";
			
			self GiveWeapon( weap );
			
			self maps\mp\gametypes\_class::setWeaponAmmoOverall(weap, 2);
			
			self SetActionSlot( 3, "weapon", weap );
		}
		else if(isSubStr( perk1, "grenade" ))
		{
			if(isSubStr( perk1, "fraggrenade" ))
				self SetWeaponAmmoClip( "frag_grenade_mp", 3 );
			else
				self SetWeaponAmmoClip( offhand, 3 );
		}
		else if( perk1 == "specialty_detectexplosive" )
		{
			self.detectExplosives = true;
			maps\mp\gametypes\_weapons::setupBombSquad();
		}
		
		self.lastDroppableWeapon = primary;
	}
	
	if(level.bots_varPlayAnim == 2)
		self setMoveSpeedScale( 0.25 );
	else
		self setMoveSpeedScale( 0.0 );
	
	weaponsList = self GetWeaponsList();
	self.bots_devWalk = [];
	for(i = 0; i < weaponsList.size; i++)
	{
		weap = weaponsList[i];
		self.bots_devwalk[weap] = spawnstruct();
		self.bots_devwalk[weap].isEmpty = false;
		self.bots_devwalk[weap].clip = self GetWeaponAmmoClip(weap);
		self.bots_devwalk[weap].stock = self GetWeaponAmmoStock(weap);
		self.bots_devWalk[weap].isReload = isDefined(level.bots_devWalk[weap]);
		
		if(!self.bots_devWalk[weap].isReload)
			self setWeaponAmmoStock(weap, 0);
	}
}