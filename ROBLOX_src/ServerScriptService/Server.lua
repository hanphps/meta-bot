-----
local ReplicatedStorage = game:GetService('ReplicatedStorage');
local Players = game:GetService('Players');
local GSettings = require(ReplicatedStorage.Settings);
local DataManager = require(script.Data);
-------
local _OnEnter = function(Player)
	warn(Player.Name..' joined the game')
	DataManager:Add(Player)
	DataManager:Award(Player,'Visits',1)
	print(DataManager:Get(Player))
end


local _OnLeave = function(Player)
	DataManager:Remove(Player)
end
-------
local Events = ReplicatedStorage:WaitForChild('Events')
local SendRequest = Events.Remote:WaitForChild('SendRequest')
SendRequest.OnServerEvent:connect(function(Player,Dir) DataManager:CreateRequest(Dir,Player,tick())end)
-------
Players.PlayerAdded:connect(function(Player)
	_OnEnter(Player)
	wait(5)
	--DataManager:CreateRequest('N',Player,tick())
end)
Players.PlayerRemoving:Connect(_OnLeave)
game:BindToClose(function()
	for _,Player in pairs(Players:GetChildren())do
		_OnLeave(Player)
	end
end)