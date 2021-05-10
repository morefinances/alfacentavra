-- хронос советник 5 cбербанк, только лонг / демо
-- версия 5.1 от 08 05 2021
-- вход рыночную (на срочном рынке может требовать худшую цену)

-- из доработок: завершение по времени проверка по закрытию
-- сделать проверку на срабатывание сделки, если нет перевыставлять (для лимитных заявок)
-- выставление по лучшей цене в стакане на 2 позиции вверх/вниз , пока выставляется по рынку


function OnInit()
		
	-- основные переменные	
	account="L01+00000F00"
	mtiker="SBER"
	
	mPos=0
	robotInfo="Хронос Версия 1.5: от 6 мая 2021. 5М SBER"
	rIS="Х.В5.0: "
	finResult=0 -- расчет результата без комиссий
	
	
	message("[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]")
	message("[ "..robotInfo.." ]")
	message("[ -----------  системная информация:  ----------- ]")
	
	 
		local main_info = {"TRADEDATE", "SERVERTIME", "SERVER", "USERID", "LOCALTIME"} 

 
		local main_comments = {'Дата торгов ' , 'Время сервера ' , 'Сервер ' , 'ID пользователя ' , 'Текущее время '}

	for key, nm in pairs(main_info) do
		local c=getInfoParam(nm)
		message("[ "..tostring(main_comments[key])..": "..c.." ]")

	end
		
	message("[ --- инициация прошла успешно --- ]")	
	
end


function OnTrade(trd) 
	if trd['account'] and trd['account']==account and trd['trade_num']>mytrade and trd['sec_code']==mtiker  then 
		
		if bit.band(tonumber(trd['flags']),4)>0 then 
			mPosition=mPosition-1
		else
			mPosition=mPosition+1
		end
		mytrade=trd['trade_num'] 
		message(rIS.."--> Позиция="..mPosition.." счетчик mytrade="..mytrade)
		
		-- далее удалить
	end	
end



function mB(Pri)
	transaction={
					-- обязательные поля для фондового рынка
		["TRANS_ID"]=tostring(1),
		["ACTION"]="NEW_ORDER",
		["CLASSCODE"]="TQBR",
		["SECCODE"]=mtiker,
		["OPERATION"]="B",
		["QUANTITY"]=tostring(1),
		["TYPE"]="M",
		["PRICE"]=tostring(0),
		["ACCOUNT"]=tostring(account),
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
		["CLASSCODE"]="TQBR",
		["SECCODE"]=mtiker,
		["OPERATION"]="S",
		["QUANTITY"]=tostring(1),
		["TYPE"]="M",
		["PRICE"]=tostring(0),
		["ACCOUNT"]=tostring(account),
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
	qt=getQuoteLevel2("TQBR", "SBER")
 
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
	
	cTimeH=os.sysdate().hour
	cTimeMin=os.sysdate().min
	-- message(tostring(cTimeMin))
	
	
	
		if cTimeH<10 then
			message (rIS.."<10:00 Торги не начались, ждём 10:00")
		end
		
		 if cTimeH>=18 and cTimeMin>=30 then
			 message (rIS..">18:30. Торги завершаем")
			 OnStop()
			 if mPos=1 and mPosition=1 then mS() end
			 return
		 end
	
	t5M, tmin=math.modf(tonumber(cTimeMin)/10) 
	tmin=tonumber(tmin*10)
	realmin=cTimeMin-t5M*10
 
		if tonumber(realmin)==5 and mPos==0 then 
			message(rIS.."покупка") 
			Price=totalSBERPrice(totalSBERPrice())
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