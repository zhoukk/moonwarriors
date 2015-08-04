local pixel = require "pixel"
local ui = require "ui"


local text = [[
Cocos2d-html5版: 
#[green]Shengxiang Chen (陈升想) #[stop]
#[blue]Dingping Lv (吕定平) #[stop]
#[yellow]Effects animation: Hao Wu(吴昊) #[stop]
Quality Assurance:  Sean Lin(林顺) 

pixel移植版：
#[green]zhoukk#[stop]

源代码下载地址：
https://github.com/zhoukk
]]


local m = {}

local obj = pixel.sprite("warrior", "about")
obj.btn_back.message = true
obj.btn_back.text_back.text = "#[red]Go Back#[stop]"
obj.text_about.text = text

ui:button("ui.about.btn_back", function()
	audio.play("asset/wav/buttonEffet_new.wav")
	ui:show("ui.loading")
end)

m.obj = obj
return m