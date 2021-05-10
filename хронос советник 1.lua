-- хронос советник 1 минутный для срочного рынка / демо
-- версия 1.2 от 06 05 2021

function OnInit()
	mPos=0
	robotInfo="Хронос В1.2: от 6 мая 2021. 2М срочный рынок"
	rIS="Х.В1.0: "
	finResult=0
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
	message("[ "..robotInfo.." ]")
	message(rIS.."--> Старт")
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
		if tonumber(realmin)==1 and mPos==0 then 
			message(rIS.."покупка") 
			Price=totalSBERPrice(mPos)
			message(rIS.."цена входа="..Price)
			mPos=1
		end
		
		if tonumber(realmin)==2 and mPos==1 then 
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
		
		if tonumber(realmin)==3 and mPos==0 then 
			message(rIS.."покупка") 
			Price=totalSBERPrice(mPos)
			message(rIS.."цена входа="..Price)
			mPos=1
		end
		  
		if tonumber(realmin)==4 and mPos==1 then 
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
		  
		if tonumber(realmin)==5 and mPos==0 then 
			message(rIS.."покупка") 
			Price=totalSBERPrice(mPos)
			message(rIS.."цена входа="..Price)
			mPos=1
		end
		  
		if tonumber(realmin)==6 and mPos==1 then 
			message(rIS.."продажа") 
			Price2=totalSBERPrice(mPos)
			message(rIS.." цена закрытия="..Price2)
			finTrade=Price2-Price
			finTrade=finTrade-finTrade%0.01
			message(rIS.."итог за трейд="..Price2.." - "..Price.." = "..finTrade)
			finResult=finResult+finTrade
			message(rIS.."общий результат="..finResult)
			mPos=0
		end
		  
		if tonumber(realmin)==7 and mPos==0 then 
			message(rIS.."покупка") 
			Price=totalSBERPrice(mPos)
			message(rIS.."цена входа="..Price)
			mPos=1
		end
		  
		  if tonumber(realmin)==8 and mPos==1 then 
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
		  
		  if tonumber(realmin)==9 and mPos==0 then 
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