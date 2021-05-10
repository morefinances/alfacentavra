-- подпорченная версия, промежуточная

-- хронос советник 5 минутный
-- версия 1.1 от 06 05 2021


function OnInit()
	
	account="L01+00000F00"
	mtiker="SBER"
	
	mPos=0
	robotInfo="Хронос В1.1: от 6 мая 2021. 5M"
	rIS="Х.В1.0: "
	finResult=0
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
	message("[ "..robotInfo.." ]")
	message(rIS.."--> Старт")
	tRun=true
	
	while tRun do


	cTimeMin=os.sysdate().min
	message(tostring(cTimeH))
	
	t5M, tmin=math.modf(tonumber(cTimeMin)/10) 
	tmin=tonumber(tmin*10)
	realmin=cTimeMin-t5M*10

		
		
		
		if tonumber(realmin)==5 and mPos==0 then 
			message(rIS.."покупка") 
			Price=totalSBERPrice(mPos)
			message(rIS.."цена входа="..Price)
			mPos=1
		end
		  
		  
		if tonumber(realmin)==0 and mPos==1 then 
			message(rIS.."продажа") 
			Price2=totalSBERPrice(mPos)
			message(rIS.."цена закрытия="..Price2)
			finTrade=Price2-Price
			finTrade=finTrade-finTrade%0.01
			message(rIS.."итог за трейд="..Price2.." - "..Price.." = "..finTrade)
			finResult=finResult+finTrade
			message(rIS.."общий результат="..finResult)
			mPos=0
		end
		
		sleep(3000)
		-- к реальным счетам уменьшить до 1-3
	end
end 