-- хронос советник 5 cбербанк, только лонг / демо
-- версия 5.1 от 08 05 2021
-- вход рыночную (на срочном рынке может требовать худшую цену)

-- из доработок: завершение по времени проверка по закрытию
-- сделать проверку на срабатывание сделки, если нет перевыставлять (для лимитных заявок)
-- выставление по лучшей цене в стакане на 2 позиции вверх/вниз , пока выставляется по рынку


function OnInit()
		
	-- основные переменные	
	account="L01+00000F00"
	
	
	mPos=0
	robotInfo="Хронос Версия 1.5: от 6 мая 2021. 5М SBER"
	rIS="Х.В5.0: "
	finResult=0 -- расчет результата без комиссий
	mytrade=0
	mtiker="SBER"
	mPosition=0
	vol1=0
	vol2=0
	Price=0
	Price2=0
	
	message("[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]")
	message("[ "..robotInfo.." ]")
	message("[ -----------  системная информация:  ----------- ]")
	
	
	if m_t==nil then
		m_t=AllocTable()
		AddColumn(m_t, 1, "Параметры", true, QTABLE_STRING_TYPE, 23)
		AddColumn(m_t, 2, "Значения", true, QTABLE_STRING_TYPE, 12)
		CreateWindow(m_t)
		SetWindowPos(m_t,0,428,341,160)
		SetWindowCaption(m_t, rIS.."SBER 5M")
		for n=1,5 do
			InsertRow(m_t,-1)
		end
		SetCell(m_t, 1, 1, "Позиция: ")
		SetCell(m_t, 2, 1, "Финансовый результат: ")
		SetCell(m_t, 1, 2, tostring(finResult))
		SetCell(m_t, 3, 1, "Вход:")
		SetCell(m_t, 4, 1, "Выход:")
		SetCell(m_t, 5, 1, "Трейд:")
	end

	
		local main_info = {"TRADEDATE", "SERVERTIME", "SERVER", "USERID", "LOCALTIME"} 

 
		local main_comments = {'Дата торгов ' , 'Время сервера ' , 'Сервер ' , 'ID пользователя ' , 'Текущее время '}

	for key, nm in pairs(main_info) do
		local c=getInfoParam(nm)
		message("[ "..tostring(main_comments[key])..": "..c.." ]")

	end
		
	message("[ --- инициация прошла успешно --- ]")	
	
end


function OnTrade(trd) -- пришла сделка 
	if trd['account'] and trd['account']==account and trd['trade_num']>mytrade and trd['sec_code']==tostring(mtiker)  then -- фильтры
		-- подсчет позиции
		if bit.band(tonumber(trd['flags']),4)>0 then --  bit.band(tonumber(trd['flags']),4)>0 флаг 4 больше нуля - продажа 
			mPosition=mPosition-tonumber(trd['qty']) -- продажа 
			Price2=trd.price
			vol2=trd.value
		else 
			mPosition=mPosition+tonumber(trd['qty']) -- покупка 
			Price=trd.price
			vol1=trd.value
		end
		mytrade=trd['trade_num']  
		message(rIS.."--> Позиция="..mPosition.." счетчик mytrade="..mytrade.." номер заявки:"..trd.order_num.." номер сделки:"..trd.trade_num)
		message(rIS.."--> Цена="..trd.price.." Объем="..trd.value)

	end	
end



function mB(Pri)
	transaction={
		["TRANS_ID"]=tostring(1),
		["ACTION"]="NEW_ORDER",
		["CLASSCODE"]="TQBR",
		["SECCODE"]=tostring(mtiker),
		["OPERATION"]="B",
		["QUANTITY"]=tostring(1),
		["TYPE"]="M",
		["PRICE"]=tostring(0),
		["ACCOUNT"]=tostring(account),
		["CLIENT_CODE"]=rIS.."покупка",	 
		["EXECUTION_CONDITION"]="PUT_IN_QUEUE",	 
	}
	
	res=sendTransaction(transaction)   
	if res~="" then
		message("----------> ответ системы:"..res)
	else 
		message("-> заявка успешно исполнена")
	end
	
	SetCell(m_t, 1, 2, "1")
end

function mS(Pri)
	transaction={
		["TRANS_ID"]=tostring(1),
		["ACTION"]="NEW_ORDER",
		["CLASSCODE"]="TQBR",
		["SECCODE"]=tostring(mtiker),
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
	
	SetCell(m_t, 1, 2, "00")
end


function OnStop()
	tRun=false
	message(rIS.."Инициация завершения")	
			if mPos==1 and mPosition==1 then 
				mS() 
				sleep(1000)
				message(rIS.."цена закрытия="..Price2)
				finTrade=(vol2-vol1)
				finTrade=finTrade-finTrade%0.1
				message(rIS.."итог за трейд= ("..vol1.." - "..vol2..") = "..finTrade)
				finResult=finResult+finTrade
				SetCell(m_t, 4, 2, tostring(Price2))
				SetCell(m_t, 5, 2, tostring(finTrade))
				
				message(rIS.."общий результат="..finResult)
				SetCell(m_t, 2, 2, tostring(finResult))
			end
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
			 return
		 end
		
		if cTimeH>=19 then
			 message (rIS..">18:30. Торги завершаем")
			 OnStop()
			 return
		 end
	
	
	
	t5M, tmin=math.modf(tonumber(cTimeMin)/10) 
	tmin=tonumber(tmin*10)
	realmin=cTimeMin-t5M*10

	
		if tonumber(realmin)==5 and mPos==0 and cTimeH>10 then 
			message(rIS.."покупка") 
			-- Price=totalSBERPrice(mPos)
			mB()
			sleep(2000)
			message(rIS.."цена входа="..Price)
			mPos=1
			
			SetCell(m_t, 3, 2, tostring(Price))
			SetCell(m_t, 4, 2, " ")
			SetCell(m_t, 5, 2, " ")
		end
		  
	
		if tonumber(realmin)==0 and mPos==1 and cTimeH>10 then 
			message(rIS.."продажа") 
			-- Price2=totalSBERPrice(mPos)
			mS()
			sleep(3000)
			message(rIS.."цена закрытия="..Price2)
			finTrade=(vol2-vol1)
			finTrade=finTrade-finTrade%0.1
			message(rIS.."итог за трейд= ("..vol1.." - "..vol2..") = "..finTrade)
			finResult=finResult+finTrade
			SetCell(m_t, 4, 2, tostring(Price2))
			SetCell(m_t, 5, 2, tostring(finTrade))
			
			message(rIS.."общий результат="..finResult)
			mPos=0
			SetCell(m_t, 2, 2, tostring(finResult))
		end
		
		sleep(3000)
		-- к реальным счетам уменьшить до 1-2
	end
end 