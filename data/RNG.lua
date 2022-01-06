--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- __________.__                                ________                          __               .__.__  __      __  .__    .__           _____.__.__              
-- \______   |  |   ____ _____    ______ ____   \______ \   ____     ____   _____/  |_    ____   __| _|___/  |_  _/  |_|  |__ |__| ______ _/ ____|__|  |   ____      
--  |     ___|  | _/ __ \\__  \  /  ____/ __ \   |    |  \ /  _ \   /    \ /  _ \   __\ _/ __ \ / __ ||  \   __\ \   __|  |  \|  |/  ___/ \   __\|  |  | _/ __ \     
--  |    |   |  |_\  ___/ / __ \_\___ \\  ___/   |    `   (  <_> ) |   |  (  <_> |  |   \  ___// /_/ ||  ||  |    |  | |   Y  |  |\___ \   |  |  |  |  |_\  ___/     
--  |____|   |____/\___  (____  /____  >\___  > /_______  /\____/  |___|  /\____/|__|    \___  \____ ||__||__|    |__| |___|  |__/____  >  |__|  |__|____/\___  > /\ 
--                     \/     \/     \/     \/          \/              \/                   \/     \/                      \/        \/                      \/  \/ 
--
--	Please do not edit this file!							Please do not edit this file!							Please do not edit this file!
--
--	Editing this file will cause you to be unable to use Github Desktop to update!
--
--	Any changes you wish to make in this file you should be able to make by overloading. That is Re-Defining the same variables or functions in another file, by copying and
--	pasting them to a file that is loaded after the original file, all of my library files, and then job files are loaded first.
--	The last files to load are the ones unique to you. User-Globals, Charactername-Globals, Charactername_Job_Gear, in that order, so these changes will take precedence.
--
--	You may wish to "hook" into existing functions, to add functionality without losing access to updates or fixes I make, for example, instead of copying and editing
--	status_change(), you can instead use the function user_status_change() in the same manner, which is called by status_change() if it exists, most of the important 
--  gearswap functions work like this in my files, and if it's unique to a specific job, user_job_status_change() would be appropriate instead.
--
--  Variables and tables can be easily redefined just by defining them in one of the later loaded files: autofood = 'Miso Ramen' for example.
--  States can be redefined as well: state.HybridMode:options('Normal','PDT') though most of these are already redefined in the gear files for editing there.
--	Commands can be added easily with: user_self_command(commandArgs, eventArgs) or user_job_self_command(commandArgs, eventArgs)
--
--	If you're not sure where is appropriate to copy and paste variables, tables and functions to make changes or add them:
--		User-Globals.lua - 			This file loads with all characters, all jobs, so it's ideal for settings and rules you want to be the same no matter what.
--		Charactername-Globals.lua -	This file loads with one character, all jobs, so it's ideal for gear settings that are usable on all jobs, but unique to this character.
--		Charactername_Job_Gear.lua-	This file loads only on one character, one job, so it's ideal for things that are specific only to that job and character.
--
--
--	If you still need help, feel free to contact me on discord or ask in my chat for help: https://discord.gg/ug6xtvQ
--  !Please do NOT message me in game about anything third party related, though you're welcome to message me there and ask me to talk on another medium.
--
--  Please do not edit this file!							Please do not edit this file!							Please do not edit this file!
-- __________.__                                ________                          __               .__.__  __      __  .__    .__           _____.__.__              
-- \______   |  |   ____ _____    ______ ____   \______ \   ____     ____   _____/  |_    ____   __| _|___/  |_  _/  |_|  |__ |__| ______ _/ ____|__|  |   ____      
--  |     ___|  | _/ __ \\__  \  /  ____/ __ \   |    |  \ /  _ \   /    \ /  _ \   __\ _/ __ \ / __ ||  \   __\ \   __|  |  \|  |/  ___/ \   __\|  |  | _/ __ \     
--  |    |   |  |_\  ___/ / __ \_\___ \\  ___/   |    `   (  <_> ) |   |  (  <_> |  |   \  ___// /_/ ||  ||  |    |  | |   Y  |  |\___ \   |  |  |  |  |_\  ___/     
--  |____|   |____/\___  (____  /____  >\___  > /_______  /\____/  |___|  /\____/|__|    \___  \____ ||__||__|    |__| |___|  |__/____  >  |__|  |__|____/\___  > /\ 
--                     \/     \/     \/     \/          \/              \/                   \/     \/                      \/        \/                      \/  \/ 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
	-- Load and initialize the include file.
	include('Sel-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()

	state.AutoAmmoMode = M(true,'Auto Ammo Mode')
	state.UseDefaultAmmo = M(true,'Use Default Ammo')
	state.Buff.Barrage = buffactive.Barrage or false
	state.Buff.Camouflage = buffactive.Camouflage or false
	state.Buff['Double Shot'] = buffactive['Double Shot'] or false
	state.Buff['Unlimited Shot'] = buffactive['Unlimited Shot'] or false
	state.Buff['Velocity Shot'] = buffactive['Velocity Shot'] or false
	
	autows = "Last Stand"
	rangedautows = "Last Stand"
	autofood = 'Soy Ramen'
	statusammo = nil
	ammostock = 198
	
	WeaponType =  {['Yoichinoyumi'] = "Bow",
				   ['Gandiva'] = "Bow",
                   ['Fail-Not'] = "Bow",
                   ['Accipiter'] = "Bow",
                   ['Annihilator'] = "Gun",
                   ['Armageddon'] = "Gun",
                   ['Fomalhaut'] = "Gun",
				   ['Ataktos'] = "Gun",
                   ['Gastraphetes'] = "Crossbow",
                   }
	
	DefaultAmmo = {
		['Bow']  = {['Default'] = "Chrono Arrow",
					['WS'] = "Chrono Arrow",
					['Acc'] = "Chrono Arrow",
					['Magic'] = "Chrono Arrow",
					['MagicAcc'] = "Chrono Arrow",
					['Unlimited'] = "Hauksbok Arrow",
					['MagicUnlimited'] ="Hauksbok Arrow",
					['MagicAccUnlimited'] ="Hauksbok Arrow"},
					
		['Gun']  = {['Default'] = "Chrono Bullet",
					['WS'] = "Chrono Bullet",
					['Acc'] = "Eradicating Bullet",
					['Magic'] = "Devastating Bullet",
					['MagicAcc'] = "Devastating Bullet",
					['Unlimited'] = "Hauksbok Bullet",
					['MagicUnlimited'] = "Hauksbok Bullet",
					['MagicAccUnlimited'] ="Animikii Bullet"},
					
		['Crossbow'] = {['Default'] = "Quelling Bolt",
						['WS'] = "Quelling Bolt",
						['Acc'] = "Quelling Bolt",
						['Magic'] = "Quelling Bolt",
						['MagicAcc'] = "Quelling Bolt",
						['Unlimited'] = "Hauksbok Bolt",
						['MagicUnlimited'] = "Hauksbok Bolt",
						['MagicAccUnlimited'] ="Hauksbok Bolt"}
	}
	
	init_job_states({"Capacity","AutoRuneMode","AutoTrustMode","AutoWSMode","AutoShadowMode","AutoFoodMode","RngHelper","AutoStunMode","AutoDefenseMode",},{"AutoBuffMode","AutoSambaMode","Weapons","OffenseMode","RangedMode","WeaponskillMode","IdleMode","Passive","RuneElement","TreasureMode",})
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------
-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
-- Set eventArgs.useMidcastGear to true if we want midcast gear equipped on precast.

function job_filtered_action(spell, eventArgs)

end

function job_pretarget(spell, spellMap, eventArgs)

end

function job_precast(spell, spellMap, eventArgs)
	if spell.action_type == 'Ranged Attack' then
		state.CombatWeapon:set(player.equipment.range)
	end

	if spell.action_type == 'Ranged Attack' or spell.name == 'Bounty Shot' or spell.name == 'Shadowbind' or (spell.type == 'WeaponSkill' and (spell.skill == 'Marksmanship' or spell.skill == 'Archery')) then
		check_ammo_precast(spell, action, spellMap, eventArgs)
	end
end

function job_post_precast(spell, spellMap, eventArgs)
	if spell.type == 'WeaponSkill' then
		if not (spell.skill == 'Marksmanship' or spell.skill == 'Archery') and WeaponType[player.equipment.range] == 'Bow' and item_available('Hauksbok Arrow') then
			equip({ammo="Hauksbok Arrow"})
		end
	
		local WSset = standardize_set(get_precast_set(spell, spellMap))
		local wsacc = check_ws_acc()
		
		if (WSset.ear1 == "Moonshade Earring" or WSset.ear2 == "Moonshade Earring") then
			-- Replace Moonshade Earring if we're at cap TP
			if get_effective_player_tp(spell, WSset) > 3200 then
				if data.weaponskills.elemental:contains(spell.english) then
					if wsacc:contains('Acc') and sets.MagicalAccMaxTP then
						equip(sets.MagicalAccMaxTP[spell.english] or sets.MagicalAccMaxTP)
					elseif sets.MagicalMaxTP then
						equip(sets.MagicalMaxTP[spell.english] or sets.MagicalMaxTP)
					else
					end
				elseif S{25,26}:contains(spell.skill) then
					if wsacc:contains('Acc') and sets.RangedAccMaxTP then
						equip(sets.RangedAccMaxTP[spell.english] or sets.RangedAccMaxTP)
					elseif sets.RangedMaxTP then
						equip(sets.RangedMaxTP[spell.english] or sets.RangedMaxTP)
					else
					end
				else
					if wsacc:contains('Acc') and not buffactive['Sneak Attack'] and sets.AccMaxTP then
						equip(sets.AccMaxTP[spell.english] or sets.AccMaxTP)
					elseif sets.MaxTP then
						equip(sets.MaxTP[spell.english] or sets.MaxTP)
					else
					end
				end
			end
		end
	elseif spell.action_type == 'Ranged Attack' then
		if buffactive.Flurry then
			if lastflurry == 1 then
				if sets.precast.RA[state.Weapons.value] and sets.precast.RA[state.Weapons.value].Flurry then
					equip(sets.precast.RA[state.Weapons.value].Flurry)
				elseif sets.precast.RA.Flurry then
					equip(sets.precast.RA.Flurry)
				end
			elseif lastflurry == 2 then
				if sets.precast.RA[state.Weapons.value] and sets.precast.RA[state.Weapons.value].Flurry2 then
					equip(sets.precast.RA[state.Weapons.value].Flurry2)
				elseif sets.precast.RA.Flurry2 then
					equip(sets.precast.RA.Flurry2)
				end
			end
		end

		if statusammo then
			equip({ammo=statusammo})
		end
	end
end

function job_self_command(commandArgs, eventArgs)
    if commandArgs[1]:lower() == 'statusammo' then
		if commandArgs[2] then
			statusammo = table.concat(commandArgs, ' ', 2)
		else
			statusammo = nil
		end
		if state.DisplayMode.value then update_job_states()	end
	end
end

-- Set eventArgs.handled to true if we don't want any automatic gear equipping to be done.
function job_post_midcast(spell, spellMap, eventArgs)
    if spell.action_type == 'Ranged Attack' then
        if state.Buff['Camouflage'] and sets.buff.Camouflage then
            if sets.buff['Camouflage'][state.RangedMode.value] then
                equip(sets.buff['Camouflage'][state.RangedMode.value])
            else
                equip(sets.buff['Camouflage'])
            end
        end
        if state.Buff['Double Shot'] and sets.buff['Double Shot'] then
            if classes.CustomRangedGroups:contains('AM') then
				if sets.buff['Double Shot'][state.Weapons.value] then
					if sets.buff['Double Shot'][state.Weapons.value][state.RangedMode.value] then
						if sets.buff['Double Shot'][state.Weapons.value][state.RangedMode.value].AM then
							equip(sets.buff['Double Shot'][state.Weapons.value][state.RangedMode.value].AM)
						else
							equip(sets.buff['Double Shot'][state.Weapons.value][state.RangedMode.value])
						end
					elseif sets.buff['Double Shot'][state.Weapons.value].AM then
						equip(sets.buff['Double Shot'][state.Weapons.value].AM)
					else
						equip(sets.buff['Double Shot'][state.Weapons.value])
					end
				elseif sets.buff['Double Shot'][state.RangedMode.value] then
					if sets.buff['Double Shot'][state.RangedMode.value].AM then
						equip(sets.buff['Double Shot'][state.RangedMode.value].AM)
					else
						equip(sets.buff['Double Shot'][state.RangedMode.value])
					end
				elseif sets.buff['Double Shot'].AM then
					equip(sets.buff['Double Shot'])
				else
					equip(sets.buff['Double Shot'])
				end
            else
				if sets.buff['Double Shot'][state.Weapons.value] then
					if sets.buff['Double Shot'][state.Weapons.value][state.RangedMode.value] then
						equip(sets.buff['Double Shot'][state.Weapons.value][state.RangedMode.value])
					else
						equip(sets.buff['Double Shot'][state.Weapons.value])
					end
				elseif sets.buff['Double Shot'][state.RangedMode.value] then
					equip(sets.buff['Double Shot'][state.RangedMode.value])
				else
					equip(sets.buff['Double Shot'])
				end
            end
        end
        if state.Buff.Barrage and sets.buff.Barrage then
            equip(sets.buff.Barrage)
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
	if buff:contains('Aftermath') then
		classes.CustomRangedGroups:clear()
		if player.equipment.range then
			if (player.equipment.range == 'Armageddon' and (buffactive['Aftermath: Lv.1'] or buffactive['Aftermath: Lv.2'] or buffactive['Aftermath: Lv.3']))
			or (player.equipment.range == 'Gandiva' and (buffactive['Aftermath: Lv.1'] or buffactive['Aftermath: Lv.2'] or buffactive['Aftermath: Lv.3']))
			or (player.equipment.range == "Gastraphetes" and state.Buff['Aftermath: Lv.3'])
			or (player.equipment.range == "Annihilator" and state.Buff['Aftermath'])
			or (player.equipment.range == "Yoichinoyumi" and state.Buff['Aftermath']) then
				classes.CustomRangedGroups:append('AM')
			end
		end
	end
end

-- Called by the 'update' self-command.
function job_update(cmdParams, eventArgs)
    if cmdParams[1] == 'user' and not data.areas.cities:contains(world.area) then
        if not buffactive['Velocity Shot'] then
            send_command('@input /ja "Velocity Shot" <me>')
        end
    end
end

-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)

end

-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------
-- Check for proper ammo when shooting or weaponskilling
function check_ammo_precast(spell, action, spellMap, eventArgs)
	-- Filter ammo checks depending on Unlimited Shot
	if state.Buff['Unlimited Shot'] and spell.type == 'WeaponSkill' then
		if data.weaponskills.elemental:contains(spell.name) then
			if check_ws_acc():contains('Acc') then
				equip({ammo=DefaultAmmo[WeaponType[player.equipment.range]].MagicAccUnlimited})
			else
				equip({ammo=DefaultAmmo[WeaponType[player.equipment.range]].MagicUnlimited})
			end
		else
			equip({ammo=DefaultAmmo[WeaponType[player.equipment.range]].Unlimited})
		end
		return
	elseif player.equipment.ammo:startswith('Hauksbok') or player.equipment.ammo == "Animikii Bullet" then
		cancel_spell()
		eventArgs.cancel = true
		enable('ammo')
		if sets.weapons[state.Weapons.value].ammo and item_available(sets.weapons[state.Weapons.value].ammo) then
			equip({ammo=sets.weapons[state.Weapons.value].ammo})
			disable('ammo')
		elseif item_available(DefaultAmmo[WeaponType[player.equipment.range]].Default) then
			equip({ammo=DefaultAmmo[WeaponType[player.equipment.range]].Default})
		else
			equip({ammo=empty})
		end
		add_to_chat(123,"Abort: Don't shoot your good ammo!")
		return
	elseif not state.UseDefaultAmmo.value then
	elseif spell.name == 'Shadowbind' then
		equip({ammo=DefaultAmmo[WeaponType[player.equipment.range]].Default})
	elseif spell.action_type == 'Ranged Attack' then
		if state.RangedMode.value:contains('Acc') then
			equip({ammo=DefaultAmmo[WeaponType[player.equipment.range]].Acc})
		else
			equip({ammo=DefaultAmmo[WeaponType[player.equipment.range]].Default})
		end
	elseif spell.type == 'WeaponSkill' then
		if data.weaponskills.elemental:contains(spell.name) then
			if check_ws_acc():contains('Acc') then
				equip({ammo=DefaultAmmo[WeaponType[player.equipment.range]].MagicAcc})
			else
				equip({ammo=DefaultAmmo[WeaponType[player.equipment.range]].Magic})
			end
		else
			if check_ws_acc():contains('Acc') then
				equip({ammo=DefaultAmmo[WeaponType[player.equipment.range]].Acc})
			else
				equip({ammo=DefaultAmmo[WeaponType[player.equipment.range]].WS})
			end			
		end
			
	end

	if count_available_ammo(player.equipment.ammo) < 15 then
		add_to_chat(122,"Ammo '"..player.equipment.ammo.."' running low: ("..count_available_ammo(player.equipment.ammo)..") remaining.")
	end
end

function job_midcast(spell, action, spellMap, eventArgs)
	--Probably overkill but better safe than sorry.
	if spell.action_type == 'Ranged Attack' then
		if player.equipment.ammo:startswith('Hauksbok') or player.equipment.ammo == "Animikii Bullet" then
			enable('ammo')
			equip({ammo=empty})
			add_to_chat(123,"Abort Ranged Attack: Don't shoot your good ammo!")
			return
		end
	end
end

function job_aftercast(spell, spellMap, eventArgs)
	if state.UseDefaultAmmo.value and player.equipment.range and DefaultAmmo[WeaponType[player.equipment.range]].Default then
		equip({ammo=DefaultAmmo[WeaponType[player.equipment.range]].Default})
	end
end

function job_tick()
	if check_ammo() then return true end
	return false
end