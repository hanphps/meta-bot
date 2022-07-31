-----
-- Uses MXKhronos Firebase Lib
-----
local AUTOSAVE = 300;
-----
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GSettings = require(ReplicatedStorage.Settings);
local HttpService = game:GetService("HttpService");
local FirebaseService = require(script.FirebaseService);
-----
local Manager = {};
local Session = {};
local PlayerData = FirebaseService:GetFirebase("PlayerData");
local RequestsData = FirebaseService:GetFirebase("Requests");
-----
local NewPlayerData = {
	Visits = 0,
	PlayTimes = {},
	Requests = {},
}
-----

local function Encode(Data)
	return HttpService:JSONEncode(Data);
end

local function Decode(Data)
	return HttpService:JSONDecode(Data)
end

--[[
--- Localized Functions
--]]
local function GetLength(Table)
	local Count = 0;
	for _,_ in pairs(Table) do
		Count = Count + 1;
	end
	return Count;
end

local function Save(Player)
	local Id = tostring(Player.UserId);
	local Name = Player.Name;

	local Success,Error
	warn("Attempting to save data for "..Name.."...");

	if Session[Id] then
		warn("Saving data for "..Name);
		local Tries = 0
		repeat
			Tries = Tries + 1;
			Success,Error = pcall(function()
				PlayerData:SetAsync(Id,Encode(Session[Id].Stats));
			end)
		until Success or Tries == 3

		if not Success then
			warn("Error saving player data for "..Name)
			warn(Error)
		else
			warn("Saved data for "..Name)
		end
	else
		warn("Data table not found")
	end

end

local function Verify(Player)
	local Id = tostring(Player.UserId);
	local Name = Player.Name;
	if Session[Id] then
		if Session[Id].Stats.Visits ~= nil then
			warn("Save verification passed");
			return true
		end
	end
	warn(Name.."'s data is not ready to save");
	return false
end

local function Load(Player)
	print("Creating data entry");
	local Id = tostring(Player.UserId);
	local Name = Player.Name;
	Session[Id] = {};
	Session[Id].Player = Player;
	Session[Id].Stats = {};

	local Success,Data = pcall(function()
		return PlayerData:GetAsync(Id);
	end)

	if Success then

		if Data ~= nil then
			warn("Save data found for "..Name)
			
			Session[Id].Stats = Decode(Data);
		else
			warn("Save data not found for "..Name)
			Session[Id].Stats = NewPlayerData;
			--Save(Player);
		end

	end

	Session[Id].StartTime = tick();
	--print(Session[Id])
end 

local function Remove(Player)
	local Id = tostring(Player.UserId)
	if Session[Id] then
		Session[Id] = nil
	end
end

local function Get(Player)
	local Id = tostring(Player.UserId)
	if Session[Id] then
		return Session[Id].Stats
	end
end

local function AutoSave()
	while wait(AUTOSAVE) do
		for _,stats in pairs(Session) do
			warn("Autosaving")
			if Verify(stats.Player) then
				Save(stats.Player)
			end
		end
	end
end

local function IndexRequest(Player,Request)
	local Id = tostring(Player.UserId)
	--print(Session[Id].Stats);
	if Session[Id] and Session[Id].Stats then
		
		local Success,Error = pcall(function()
			return Session[Id].Stats.Requests
			--if Session[Id].Stats.Requests then
				--return true;
			--end
		end)
		
		--print(Success)

		if Success then
			table.insert(Session[Id].Stats.Requests,Request)
		else
			Session[Id].Stats.Requests = {};
			table.insert(Session[Id].Stats.Requests,Request);
			Save(Player);
		end

			--
			--print(Session[Id].Stats.Requests);
			--
	end
end

local function NewRequest(Dir,Player,Date)
	local Id = tostring(Player.UserId)
	local Name = Player.Name

	warn("Attempting to create new request for "..Name.."to go "..Dir);

	if Session[Id] then
		warn("Creating request...")
		local Request = {
			Direction = Dir,
			Sender = Id,
			Time = Date,
			Complete = false,
			Name = ''
		}
		local Total = 1; -- Default first request
		local Result,Error = pcall(function()
			return Session[Id].Stats.Requests
		end)
		
		if Result then
			Total = GetLength(Session[Id].Stats.Requests);
		end
		--print(Total);
		
		Request.Name = Id.."Request"..Total;
		RequestsData:SetAsync(Id.."Request"..Total,Encode(Request));
		
		IndexRequest(Player,Request);

		warn("Sent request to Firebase");

	end 

end

local function Award(Player,Stat,Value)
	local Id = tostring(Player.UserId)
	if Session[Id] and Session[Id].Stats[Stat] then
		Session[Id].Stats[Stat] = Session[Id].Stats[Stat] + Value
	end
end

-----

function Manager:Add(Player)
	Load(Player);
end

function Manager:Remove(Player)
	local Id = tostring(Player.UserId);
	if Verify(Player) then
		local Time = tick()-Session[Id].StartTime;
		table.insert(Session[Id].Stats.PlayTimes,Time);
		--print(Session[Id])
		Save(Player);
	end
	Remove(Player);
end

function Manager:Award(Player,Stat,Value)
	Award(Player,Stat,Value)
end

function Manager:Get(Player)
	return Get(Player);
end

function Manager:CreateRequest(Dir,Player,Data)
	NewRequest(Dir,Player,Data);
end 

-----

spawn(AutoSave);
return Manager;

-----