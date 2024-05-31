if SERVER then
 
	AddCSLuaFile ("shared.lua")
	SWEP.Weight = 1
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
 
elseif CLIENT then
 
	SWEP.PrintName = "Climber"
	SWEP.Slot = 1
	SWEP.SlotPos = 4
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

end
 
SWEP.Author = "Connor Bray"
-- SWEP.Contact = "Your Email Address"
SWEP.Purpose = "Grapple up walls."
SWEP.Instructions = "Left click to grapple."

SWEP.Category = "Utility"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
 
-- First Person
SWEP.ViewModel = ""
-- Third Person
SWEP.WorldModel = ""
 
 
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
 
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
 

local use_sound = Sound("physics/body/body_medium_impact_soft1.wav")
 
function SWEP:Reload()
end
 
function SWEP:Think()
end
 
 
function SWEP:PrimaryAttack()

    -- Get the eye trace
	local tr = self.Owner:GetEyeTrace()
 
    -- Play sound
	self:EmitSound(use_sound)
	self.BaseClass.ShootEffects(self)
 
	if (!SERVER) then return end

	print(self.Owner)
	self.Owner:SetVelocity(Vector(1,1,1))

end
 
function SWEP:SecondaryAttack()
end
 