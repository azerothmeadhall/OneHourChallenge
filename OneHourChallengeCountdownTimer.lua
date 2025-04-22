-- Timer duration in seconds (1 hour)
local TIMER_DURATION = 3600
local remainingTime = TIMER_DURATION
local OneHourCountdownTicker

-- Predeclare variables for UI elements
local notificationText, startButton

-- Create the main frame
local frame = CreateFrame("Frame", "OneHourTimerFrame", UIParent, "BackdropTemplate")
frame:SetSize(250, 150)
frame:SetPoint("CENTER", 0, 0)

-- Set the backdrop programmatically
frame:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 },
})
frame:SetBackdropColor(0, 0, 0, 0.8)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

-- Countdown Timer Text
local timerText = frame:CreateFontString("OneHourTimerText", "OVERLAY", "GameFontNormal")
timerText:SetPoint("TOP", frame, "TOP", 0, -20)
timerText:SetText("Time Remaining: 60:00")

-- YouTube Handle
local youtubeHandleText = frame:CreateFontString("YouTubeHandleText", "OVERLAY", "GameFontHighlight")
youtubeHandleText:SetPoint("BOTTOM", frame, "BOTTOM", 0, 40)
youtubeHandleText:SetText("@AzerothMeadhall")

-- Challenge Title
local challengeTitleText = frame:CreateFontString("ChallengeTitleText", "OVERLAY", "GameFontHighlight")
challengeTitleText:SetPoint("BOTTOM", frame, "BOTTOM", 0, 20)
challengeTitleText:SetText("Challenge: One Hour WoW")

-- Create the Start Button
startButton = CreateFrame("Button", "OneHourTimerStartButton", frame, "UIPanelButtonTemplate")
startButton:SetSize(80, 22)
startButton:SetPoint("BOTTOM", frame, "BOTTOM", 0, -20)
startButton:SetText("Start")
startButton:SetScript("OnClick", function()
    if not OneHourCountdownTicker then
        StartCountdown()
        startButton:Hide() -- Hide the Start button after being clicked
    else
        print("Timer is already running!")
    end
end)

-- Create Notification Text
notificationText = frame:CreateFontString("NotificationText", "OVERLAY", "GameFontNormalLarge")
notificationText:SetPoint("CENTER", frame, "CENTER", 0, 0)
notificationText:SetText("")
notificationText:Hide() -- Initially hidden

-- Update Timer Functionality
local function UpdateUITimerText()
    local minutes = math.floor(remainingTime / 60)
    local seconds = remainingTime % 60
    timerText:SetText(string.format("Time Remaining: %02d:%02d", minutes, seconds))
end

local function OnCountdownEnd()
    print("Time's up! Hearthstone or Exit!")
    timerText:SetText("Time Remaining: 00:00")
    notificationText:SetText("Time's up! Hearthstone or Exit!")
    notificationText:Show()
    C_Timer.After(20, function()
        notificationText:Hide() -- Hide notification after 20 seconds
    end)
end

function StartCountdown()
    print("Starting OneHourChallengeCountdownTimer...")
    UpdateUITimerText()

    OneHourCountdownTicker = C_Timer.NewTicker(1, function()
        remainingTime = remainingTime - 1
        if remainingTime <= 0 then
            OneHourCountdownTicker:Cancel()
            OneHourCountdownTicker = nil
            OnCountdownEnd()
        else
            UpdateUITimerText()
        end
    end, TIMER_DURATION)
end
