-- ������������ ������, �������������

-- ������ �������� 5 ��������
-- ������ 1.1 �� 06 05 2021


function OnInit()
	
	account="L01+00000F00"
	mtiker="SBER"
	
	mPos=0
	robotInfo="������ �1.1: �� 6 ��� 2021. 5M"
	rIS="�.�1.0: "
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
		message(rIS.."--> �������="..mPosition.." ������� mytrade="..mytrade)
	end	
end



function OnStop()
	tRun=false
	message(rIS.."--> ����������]")	
end


function totalSBERPrice (dPos)
	qt=getQuoteLevel2("TQBR", "SBER")
 
		if dPos==0 then
			if qt.offer then
				offer=tonumber(qt.offer[1].price)
				--message(rIS.."���� �����������="..offer)
				return offer
			else
				return -1
			end
		end

		if dPos==1 then
			if qt.bid then
				bid=tonumber(qt.bid[tonumber(qt.bid_count)].price)
				-- message(rIS.."���� ������="..bid)
				return bid
			else
				return -1
			end
		end
end

function main()
	message("[ "..robotInfo.." ]")
	message(rIS.."--> �����")
	tRun=true
	
	while tRun do


	cTimeMin=os.sysdate().min
	message(tostring(cTimeH))
	
	t5M, tmin=math.modf(tonumber(cTimeMin)/10) 
	tmin=tonumber(tmin*10)
	realmin=cTimeMin-t5M*10

		
		
		
		if tonumber(realmin)==5 and mPos==0 then 
			message(rIS.."�������") 
			Price=totalSBERPrice(mPos)
			message(rIS.."���� �����="..Price)
			mPos=1
		end
		  
		  
		if tonumber(realmin)==0 and mPos==1 then 
			message(rIS.."�������") 
			Price2=totalSBERPrice(mPos)
			message(rIS.."���� ��������="..Price2)
			finTrade=Price2-Price
			finTrade=finTrade-finTrade%0.01
			message(rIS.."���� �� �����="..Price2.." - "..Price.." = "..finTrade)
			finResult=finResult+finTrade
			message(rIS.."����� ���������="..finResult)
			mPos=0
		end
		
		sleep(3000)
		-- � �������� ������ ��������� �� 1-3
	end
end 