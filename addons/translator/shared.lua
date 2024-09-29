if SERVER then
    -- AddCSLuaFile("cl_init.lua")

    alien_players = alien_players or {}

end

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Author = "inkydinkystinky"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.IconLetter = ""
SWEP.PrintName = "Datapad"
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "[SR] Utilities"
SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.UseHands = true;
SWEP.ViewModel = Model("models/drover/baton.mdl");
SWEP.WorldModel = Model("models/drover/w_baton.mdl");

