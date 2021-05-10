-- ������ �������� 1 �������� ��� �������� ����� / ����
-- ������ 1.2 �� 06 05 2021
-- ���� �������� (�� ������� ����� ����� ��������� ������ ����)



function OnInit()
		
	-- �������� ����������	
	account="L01+00000F00"
	
	
	mPos=0
	robotInfo="������ ������ 1.5: �� 6 ��� 2021. 5� SBER"
	rIS="�.�5.0: "
	finResult=0 -- ������ ���������� ��� ��������
	
	
	message("[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]")
	message("[ "..robotInfo.." ]")
	message("[ -----------  ��������� ����������:  ----------- ]")
	
	 
		local main_info = {"TRADEDATE", "SERVERTIME", "SERVER", "USERID", "LOCALTIME"} 

 
		local main_comments = {'���� ������ ' , '����� ������� ' , '������ ' , 'ID ������������ ' , '������� ����� '}

	for key, nm in pairs(main_info) do
		local c=getInfoParam(nm)
		message("[ "..tostring(main_comments[key])..": "..c.." ]")

	end
		
	message("[ --- ��������� ������ ������� --- ]")	
	
end


function OnTrade(trd) -- ������ ������ 
	if trd['account'] and trd['account']==account and trd['trade_num']>untrade and trd['sec_code']==sec  then -- �������
		-- ������� �������
		if bit.band(tonumber(trd['flags']),4)>0 then --  bit.band(tonumber(trd['flags']),4)>0 ���� 4 ������ ���� - ������� 
			Position=Position-tonumber(trd['qty']) -- ������� 
		else 
			Position=Position+tonumber(trd['qty']) -- ������� 
		end
		message(trz_comment.." >> OnTrade. Position="..Position)
		untrade=trd['trade_num'] -- ����� ����������� �� ������� ������ ���� ��� 
	end	
end



function mB(Pri)
	transaction={
					-- ������������ ���� ��� ��������� �����
		["TRANS_ID"]=tostring(1),
		["ACTION"]="NEW_ORDER",
		["CLASSCODE"]="TQBR",
		["SECCODE"]="SBER",
		["OPERATION"]="B",
		["QUANTITY"]=tostring(1),
		["TYPE"]="M",
		["PRICE"]=tostring(0),
		["ACCOUNT"]=tostring(account),
		["CLIENT_CODE"]=rIS.."�������",	 
		["EXECUTION_CONDITION"]="PUT_IN_QUEUE",	 
	}
	
	res=sendTransaction(transaction)  -- ������� QLUA ���������� ���������� �� ������ ������� (�����) ���������� ��� ������ ������ "", ���� ��� �� ��� ������ � �������
	if res~="" then
		message("----------> ����� �������:"..res)
	else 
		message("-> ������ ������� ���������")
	end
end

function mS(Pri)
	transaction={
					-- ������������ ���� ��� ��������� �����
		["TRANS_ID"]=tostring(1),
		["ACTION"]="NEW_ORDER",
		["CLASSCODE"]="TQBR",
		["SECCODE"]="SBER",
		["OPERATION"]="S",
		["QUANTITY"]=tostring(1),
		["TYPE"]="M",
		["PRICE"]=tostring(0),
		["ACCOUNT"]=tostring(account),
		["CLIENT_CODE"]=rIS.."�������",	 
		["EXECUTION_CONDITION"]="PUT_IN_QUEUE",	 
	}
	
	res=sendTransaction(transaction)  -- ������� QLUA ���������� ���������� �� ������ ������� (�����) ���������� ��� ������ ������ "", ���� ��� �� ��� ������ � �������
	if res~="" then
		message("----------> ����� �������:"..res)
	else 
		message("-> ������ ������� ���������")
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
	message(rIS.."[--> �����")
	tRun=true
	
	while tRun do
	
	cTimeH=os.sysdate().hour
	cTimeMin=os.sysdate().min
	-- message(tostring(cTimeMin))
	
	
	
		if cTimeH<10 then
			message (rIS.."<10:00 ����� �� ��������, ��� 10:00")
		end
		
		 if cTimeH>=18 and cTimeMin>=30 then
			 message (rIS..">18:30. ����� ���������")
			 OnStop()
			 
			 return
		 end
	
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
			message(rIS.."�������") 
			Price=totalSBERPrice(mPos)
			mB(Price)
			message(rIS.."���� �����="..Price)
			mPos=1
		end
		  
	
		if tonumber(realmin)==0 and mPos==1 then 
			message(rIS.."�������") 
			Price2=totalSBERPrice(mPos)
			mS(Price2)
			message(rIS.."���� ��������="..Price2)
			finTrade=Price2-Price
			finTrade=finTrade-finTrade%0.01
			message(rIS.."���� �� �����="..Price2.." - "..Price.." = "..finTrade)
			finResult=finResult+finTrade
			message(rIS.."����� ���������="..finResult)
			mPos=0
		end
		
		sleep(3000)
		-- � �������� ������ ��������� �� 1-2
	end
end 