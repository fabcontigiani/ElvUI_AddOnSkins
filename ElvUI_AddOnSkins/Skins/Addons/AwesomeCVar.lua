local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")
local AS = E:GetModule("AddOnSkins")

if not AS:IsAddonLODorEnabled("AwesomeCVar") then return end

S:AddCallbackForAddon("AwesomeCVar", "AwesomeCVar", function()
	if not E.private.addOnSkins.AwesomeCVar then return end

	local AwesomeCVarFrame = _G.AwesomeCVarFrame
	if AwesomeCVarFrame then
		AwesomeCVarFrame:StripTextures()
		AwesomeCVarFrame:SetTemplate("Transparent")
		for _, child in ipairs({AwesomeCVarFrame:GetChildren()}) do
			if child:IsObjectType("Button") and child:GetName() and string.match(child:GetName(), "^AwesomeCVar.*Button$") then
				S:HandleButton(child)
			end
		end
	end

	local AwesomeCVarReloadPopup = _G.AwesomeCVarReloadPopup
	if AwesomeCVarReloadPopup then
		AwesomeCVarReloadPopup:StripTextures()
		AwesomeCVarReloadPopup:SetTemplate("Transparent")
		for _, child in ipairs({AwesomeCVarReloadPopup:GetChildren()}) do
			if child:IsObjectType("Button") then
				S:HandleButton(child)
			end
		end
	end

	local AwesomeCVarDefaultConfirmationPopup = _G.AwesomeCVarDefaultConfirmationPopup
	if AwesomeCVarDefaultConfirmationPopup then
		AwesomeCVarDefaultConfirmationPopup:StripTextures()
		AwesomeCVarDefaultConfirmationPopup:SetTemplate("Transparent")
		for _, child in ipairs({AwesomeCVarDefaultConfirmationPopup:GetChildren()}) do
			if child:IsObjectType("Button") then
				S:HandleButton(child)
			end
		end
	end

	if _G.GameMenuButtonAwesomeCVar then
		S:HandleButton(_G.GameMenuButtonAwesomeCVar)
	end

	for key, obj in pairs(_G) do
		if type(key) == "string" and type(obj) == "table" and obj.IsObjectType and string.match(key, "^AwesomeCVar") then
			if obj:IsObjectType("ScrollFrame") and string.match(key, "ScrollFrame") then
				local scrollBar = _G[key .. "ScrollBar"]
				if scrollBar then
					S:HandleScrollBar(scrollBar)
				end
			elseif obj:IsObjectType("Frame") and string.match(key, "FramePanel_") then
				obj:SetBackdrop(nil)
				obj:SetTemplate("Transparent")
			elseif obj:IsObjectType("CheckButton") then
				if string.match(key, "Tab$") then
					S:HandleTab(obj)
					local text = obj:GetFontString()
					if text then
						text:ClearAllPoints()
						text:SetPoint("CENTER", obj, "CENTER", 0, 0)
					end
				elseif string.match(key, "Checkbox$") then
					S:HandleCheckBox(obj, true)
					obj:SetSize(16, 16)
					
					obj:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
					local check = obj:GetCheckedTexture()
					if check then
						check:SetDrawLayer("OVERLAY", 7)
						check:SetVertexColor(1, 1, 1, 1)
						check:ClearAllPoints()
						check:SetPoint("CENTER", obj, "CENTER", 0, 0)
						check:SetSize(18, 18)
					end
				elseif string.match(key, "Radio%d+$") then
					S:HandleCheckBox(obj, true)
					obj:SetSize(16, 16)
					
					obj:SetCheckedTexture("Interface\\Minimap\\UI-Minimap-Background")
					local check = obj:GetCheckedTexture()
					if check then
						check:SetDrawLayer("OVERLAY", 7)
						check:SetVertexColor(1, 0.8, 0, 1)
						check:ClearAllPoints()
						check:SetPoint("CENTER", obj, "CENTER", 0, 0)
						check:SetSize(8, 8)
					end
				end
			elseif obj:IsObjectType("Slider") and string.match(key, "Slider$") then
				S:HandleSliderFrame(obj)
			elseif obj:IsObjectType("Button") and string.match(key, "ResetButton$") then
				S:HandleButton(obj)
			elseif obj:IsObjectType("Frame") and string.match(key, "Dropdown$") then
				S:HandleDropDownBox(obj, 160)
				local bg = obj.backdrop or obj
				local button = _G[key.."Button"]
				
				if button then
					button:SetParent(obj)
					button:SetAlpha(0)
				end
				
				if not obj.visualArrow then
					local visual = CreateFrame("Frame", nil, obj)
					visual:SetSize(16, 16)
					visual:SetPoint("RIGHT", obj, "RIGHT", -10, 3)
					visual:SetFrameStrata("HIGH")
					visual:SetFrameLevel(99)
					visual:EnableMouse(false)
					
					local tex = visual:CreateTexture(nil, "OVERLAY")
					tex:SetTexture(E.Media.Textures.ArrowUp)
					tex:SetRotation(3.14)
					tex:SetAllPoints()
					
					if button and not button:IsEnabled() then
						tex:SetVertexColor(0.3, 0.3, 0.3, 1)
					else
						tex:SetVertexColor(1, 0.8, 0, 1)
					end
					
					visual.tex = tex
					obj.visualArrow = visual
					
					if button then
						button:HookScript("OnEnter", function(self)
							if self:IsEnabled() and visual.tex then visual.tex:SetVertexColor(1, 1, 1, 1) end
						end)
						button:HookScript("OnLeave", function(self)
							if self:IsEnabled() and visual.tex then visual.tex:SetVertexColor(1, 0.8, 0, 1) end
						end)
						hooksecurefunc(button, "Enable", function()
							if visual.tex then visual.tex:SetVertexColor(1, 0.8, 0, 1) end
						end)
						hooksecurefunc(button, "Disable", function()
							if visual.tex then visual.tex:SetVertexColor(0.3, 0.3, 0.3, 1) end
						end)
					end
				end
				local text = _G[key.."Text"]
				if text then
					text:SetParent(bg)
					text:Show()
					text:SetDrawLayer("OVERLAY", 7)
				end
			end
		end
	end
end)
