-- хронос советник 1 минутный для срочного рынка / демо
-- версия 1.2 от 06 05 2021
-- вход рыночную (на срочном рынке может требовать худшую цену)



function OnInit()
		
	-- основные переменные	
	mPos=0
	robotInfo="Хронос В1.3: от 6 мая 2021. 5М срочный рынок"
	rIS="Х.В3.0: "
	finResult=0 -- расчет результата без комиссий
	
	
	message("[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]")
	message("[ "..robotInfo.." ]")
	message("[ ------------  системная информация:  ------------ ]")
	
	 
		local main_info = {"TRADEDATE", "SERVERTIME", "SERVER", "USERID", "LOCALTIME"} 

 
		local main_comments = {'Дата торгов ' , 'Время сервера ' , 'Сервер ' , 'ID пользователя ' , 'Текущее время '}

	for key, nm in pairs(main_info) do
		local c=getInfoParam(nm)
		message("[ "..tostring(main_comments[key])..": "..c.." ]")

	end
		
	message("[ --- инициация прошла успешно --- ]")	
	
end

function mB(Pri)
	transaction={
					-- обязательные поля для фондового рынка
		["TRANS_ID"]=tostring(1),
		["ACTION"]="NEW_ORDER",
		["CLASSCODE"]="SPBFUT",
		["SECCODE"]="RIM1",
		["OPERATION"]="B",
		["QUANTITY"]=tostring(1),
		["TYPE"]="M",
		["PRICE"]=tostring(0),
		["ACCOUNT"]=tostring("SPBFUT000vu"),
		["CLIENT_CODE"]=rIS.."покупка",	 
		["EXECUTION_CONDITION"]="PUT_IN_QUEUE",	 
	}
	
	res=sendTransaction(transaction)  -- функция QLUA отправляет транзакцию на сервер брокера (биржу) возвращяет или пустую строку "", если все ок или строку с ошибкой
	if res~="" then
		message("----------> ответ системы:"..res)
	else 
		message("-> заявка успешно исполнена")
	end
end

function mS(Pri)
	transaction={
					-- обязательные поля для фондового рынка
		["TRANS_ID"]=tostring(1),
		["ACTION"]="NEW_ORDER",
		["CLASSCODE"]="SPBFUT",
		["SECCODE"]="RIM1",
		["OPERATION"]="S",
		["QUANTITY"]=tostring(1),
		["TYPE"]="M",
		["PRICE"]=tostring(0),
		["ACCOUNT"]=tostring("SPBFUT000vu"),
		["CLIENT_CODE"]=rIS.."продажа",	 
		["EXECUTION_CONDITION"]="PUT_IN_QUEUE",	 
	}
	
	res=sendTransaction(transaction)  -- функция QLUA отправляет транзакцию на сервер брокера (биржу) возвращяет или пустую строку "", если все ок или строку с ошибкой
	if res~="" then
		message("----------> ответ системы:"..res)
	else 
		message("-> заявка успешно исполнена")
	end
end


function OnStop()
	tRun=false
	message(rIS.."--> Завершение]")	
end


function totalSBERPrice (dPos)
	qt=getQuoteLevel2("SPBFUT", "RIM1")
 
		if dPos==0 then
			if qt.offer then
				offer=tonumber(qt.offer[1].price)
				--message(rIS.."цена предложения="..offer)
				return offer
			else
				return -1
			end
		end

		if dPos==1 then
			if qt.bid then
				bid=tonumber(qt.bid[tonumber(qt.bid_count)].price)
				-- message(rIS.."цена спроса="..bid)
				return bid
			else
				return -1
			end
		end
end

function main()
	message(rIS.."[--> Старт")
	tRun=true
	
	while tRun do

	cTimeMin=os.sysdate().min
	-- message(tostring(cTimeMin))
	
	t5M, tmin=math.modf(tonumber(cTimeMin)/10) 
	tmin=tonumber(tmin*10)
	realmin=cTimeMin-t5M*10
	--message(t5M.."  "..tmin.." "..realmin)
	
	-- if tmin<5 then 
		-- message("AAA")
	-- else
		-- message("BBB")
	-- end
		if tonumber(realmin)==5 and mPos==0 then 
			message(rIS.."покупка") 
			Price=totalSBERPrice(mPos)
			mB(Price)
			message(rIS.."цена входа="..Price)
			mPos=1
		end
		  
	
		if tonumber(realmin)==0 and mPos==1 then 
			message(rIS.."продажа") 
			Price2=totalSBERPrice(mPos)
			mS(Price2)
			message(rIS.."цена закрытия="..Price2)
			finTrade=Price2-Price
			finTrade=finTrade-finTrade%0.01
			message(rIS.."итог за трейд="..Price2.." - "..Price.." = "..finTrade)
			finResult=finResult+finTrade
			message(rIS.."общий результат="..finResult)
			mPos=0
		end
		
		sleep(3000)
		-- к реальным счетам уменьшить до 1-2
	end
end 