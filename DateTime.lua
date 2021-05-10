
--[[ из мануала QLUA
Формат даты и времени, используемый таблицах

Описание формата даты и времени, используемого в некоторых таблицах: 

Параметр Тип Описание 
mcs  NUMBER  Микросекунды  
ms  NUMBER  Миллисекунды  
sec  NUMBER  Секунды   
min  NUMBER  Минуты  
hour  NUMBER  Часы  
day  NUMBER  День  
week_day  NUMBER  Номер дня недели  
month  NUMBER  Месяц  
year  NUMBER  Год  

Для корректного отображения даты и времени эти параметры должны быть заданы.
--]]

-- пришла таблица
-- date_time={
	-- sec=2,
	-- min=9,
	-- hour=12,
	-- day=3,
	-- month=2,
	-- year=2019
	-- }
	
-- Необходимо получить формат YYYYMMDDHHmmss 
function getYYYYMMDDHHmmss(t_Dat) -- принимаемт на вход табличку date_time - возвращает дату и время в формате YYYYMMDDHHmmss
	local Day=t_Dat.day
	if Day<10 then
		Day=tostring("0"..Day)
	end
	local Hour=t_Dat.hour
	if Hour<10 then
		Hour=tostring("0"..Hour)
	end
	local Min=t_Dat.min
	if Min<10 then
		Min=tostring("0"..Min)
	end
	local Sec=t_Dat.sec
	if Sec then
		if Sec<10 then
			Sec=tostring("0"..Sec)
		end	
	else
		Sec="00"
	end	
	local dde=tostring(Hour..Min..Sec)
	 
	local Mon=t_Dat.month
	if Mon<10 then
		Mon=tostring("0"..Mon)
	end
	local Year=t_Dat.year
	local ddd=tonumber(Year..Mon..Day)
	local ddd_dde=tonumber(ddd..dde)
    return ddd_dde  -- возвращает число формата YYYYMMDDHHmmss
end 

-- вызываем 
dt=getYYYYMMDDHHmmss(os.sysdate())
message("dt="..dt)










