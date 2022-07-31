-- Quick scriptz improve this hannah geeeeeeez
local ReplicatedStorage = game:GetService('ReplicatedStorage');
-----
local Events = ReplicatedStorage:WaitForChild('Events');
local SendRequest = Events.Remote:WaitForChild('SendRequest');
-----
local Blue = Color3.fromRGB(33, 148, 197);
local Grey = Color3.fromRGB(106, 106, 106);
Matching = {
	['Up'] = 'N',
	['Left'] = 'W',
	['Right'] = 'E',
	['Down'] = 'S'
};
-----
local Gui = script.Parent;
local Frame = Gui:WaitForChild('Frame');
local Debounce = true;

for _,ButtonFrame in pairs(Frame:GetChildren()) do
	ButtonFrame:WaitForChild('TextButton').MouseButton1Click:connect(function()
		print(Debounce)
		if Debounce then 
			SendRequest:FireServer(Matching[ButtonFrame.Name])
			ButtonFrame.BackgroundColor3 = Grey;
			Debounce = false;
			wait(10);
			Debounce = true;
			ButtonFrame.BackgroundColor3 = Blue;
		else
			ButtonFrame.BackgroundColor3 = Grey;
		end
	end)
end