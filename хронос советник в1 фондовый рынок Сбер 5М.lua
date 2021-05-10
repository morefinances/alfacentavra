-- ������ �������� 5 c�������, ������ ���� / ����
-- ������ 5.1 �� 08 05 2021
-- ���� �������� (�� ������� ����� ����� ��������� ������ ����)

-- �� ���������: ���������� �� ������� �������� �� ��������
-- ������� �������� �� ������������ ������, ���� ��� �������������� (��� �������� ������)
-- ����������� �� ������ ���� � ������� �� 2 ������� �����/���� , ���� ������������ �� �����


function OnInit()
		
	-- �������� ����������	
	account="L01+00000F00"
	
	
	mPos=0
	robotInfo="������ ������ 1.5: �� 6 ��� 2021. 5� SBER"
	rIS="�.�5.0: "
	finResult=0 -- ������ ���������� ��� ��������
	mytrade=0
	mtiker="SBER"
	mPosition=0
	vol1=0
	vol2=0
	Price=0
	Price2=0
	
	message("[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]")
	message("[ "..robotInfo.." ]")
	message("[ -----------  ��������� ����������:  ----------- ]")
	
	
	if m_t==nil then
		m_t=AllocTable()
		AddColumn(m_t, 1, "���������", true, QTABLE_STRING_TYPE, 23)
		AddColumn(m_t, 2, "��������", true, QTABLE_STRING_TYPE, 12)
		CreateWindow(m_t)
		SetWindowPos(m_t,0,428,341,160)
		SetWindowCaption(m_t, rIS.."SBER 5M")
		for n=1,5 do
			InsertRow(m_t,-1)
		end
		SetCell(m_t, 1, 1, "�������: ")
		SetCell(m_t, 2, 1, "���������� ���������: ")
		SetCell(m_t, 1, 2, tostring(finResult))
		SetCell(m_t, 3, 1, "����:")
		SetCell(m_t, 4, 1, "�����:")
		SetCell(m_t, 5, 1, "�����:")
	end

	
		local main_info = {"TRADEDATE", "SERVERTIME", "SERVER", "USERID", "LOCALTIME"} 

 
		local main_comments = {'���� ������ ' , '����� ������� ' , '������ ' , 'ID ������������ ' , '������� ����� '}

	for key, nm in pairs(main_info) do
		local c=getInfoParam(nm)
		message("[ "..tostring(main_comments[key])..": "..c.." ]")

	end
		
	message("[ --- ��������� ������ ������� --- ]")	
	
end


function OnTrade(trd) -- ������ ������ 
	if trd['account'] and trd['account']==account and trd['trade_num']>mytrade and trd['sec_code']==tostring(mtiker)  then -- �������
		-- ������� �������
		if bit.band(tonumber(trd['flags']),4)>0 then --  bit.band(tonumber(trd['flags']),4)>0 ���� 4 ������ ���� - ������� 
			mPosition=mPosition-tonumber(trd['qty']) -- ������� 
			Price2=trd.price
			vol2=trd.value
		else 
			mPosition=mPosition+tonumber(trd['qty']) -- ������� 
			Price=trd.price
			vol1=trd.value
		end
		mytrade=trd['trade_num']  
		message(rIS.."--> �������="..mPosition.." ������� mytrade="..mytrade.." ����� ������:"..trd.order_num.." ����� ������:"..trd.trade_num)
		message(rIS.."--> ����="..trd.price.." �����="..trd.value)

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
		["CLIENT_CODE"]=rIS.."�������",	 
		["EXECUTION_CONDITION"]="PUT_IN_QUEUE",	 
	}
	
	res=sendTransaction(transaction)   
	if res~="" then
		message("----------> ����� �������:"..res)
	else 
		message("-> ������ ������� ���������")
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
		["CLIENT_CODE"]=rIS.."�������",	 
		["EXECUTION_CONDITION"]="PUT_IN_QUEUE",	 
	}
	
	res=sendTransaction(transaction)  -- ������� QLUA ���������� ���������� �� ������ ������� (�����) ���������� ��� ������ ������ "", ���� ��� �� ��� ������ � �������
	if res~="" then
		message("----------> ����� �������:"..res)
	else 
		message("-> ������ ������� ���������")
	end
	
	SetCell(m_t, 1, 2, "00")
end


function OnStop()
	tRun=false
	message(rIS.."��������� ����������")	
			if mPos==1 and mPosition==1 then 
				mS() 
				sleep(1000)
				message(rIS.."���� ��������="..Price2)
				finTrade=(vol2-vol1)
				finTrade=finTrade-finTrade%0.1
				message(rIS.."���� �� �����= ("..vol1.." - "..vol2..") = "..finTrade)
				finResult=finResult+finTrade
				SetCell(m_t, 4, 2, tostring(Price2))
				SetCell(m_t, 5, 2, tostring(finTrade))
				
				message(rIS.."����� ���������="..finResult)
				SetCell(m_t, 2, 2, tostring(finResult))
			end
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
		
		if cTimeH>=19 then
			 message (rIS..">18:30. ����� ���������")
			 OnStop()
			 return
		 end
	
	
	
	t5M, tmin=math.modf(tonumber(cTimeMin)/10) 
	tmin=tonumber(tmin*10)
	realmin=cTimeMin-t5M*10

	
		if tonumber(realmin)==5 and mPos==0 and cTimeH>10 then 
			message(rIS.."�������") 
			-- Price=totalSBERPrice(mPos)
			mB()
			sleep(2000)
			message(rIS.."���� �����="..Price)
			mPos=1
			
			SetCell(m_t, 3, 2, tostring(Price))
			SetCell(m_t, 4, 2, " ")
			SetCell(m_t, 5, 2, " ")
		end
		  
	
		if tonumber(realmin)==0 and mPos==1 and cTimeH>10 then 
			message(rIS.."�������") 
			-- Price2=totalSBERPrice(mPos)
			mS()
			sleep(3000)
			message(rIS.."���� ��������="..Price2)
			finTrade=(vol2-vol1)
			finTrade=finTrade-finTrade%0.1
			message(rIS.."���� �� �����= ("..vol1.." - "..vol2..") = "..finTrade)
			finResult=finResult+finTrade
			SetCell(m_t, 4, 2, tostring(Price2))
			SetCell(m_t, 5, 2, tostring(finTrade))
			
			message(rIS.."����� ���������="..finResult)
			mPos=0
			SetCell(m_t, 2, 2, tostring(finResult))
		end
		
		sleep(3000)
		-- � �������� ������ ��������� �� 1-2
	end
end 