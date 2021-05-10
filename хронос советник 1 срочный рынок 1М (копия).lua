-- 57 ������ ��� ����� ������ � �������� ������������

-- ������ �������� 1 �������� ��� �������� ����� / ����
-- ������ 1.2 �� 06 05 2021
-- ���� �������� (�� ������� ����� ����� ��������� ������ ����)

-- �� ���������: ���������� �� ������� �������� �� ��������
-- ������� �������� �� ������������ ������, ���� ��� �������������� (��� �������� ������)
-- ����������� �� ������ ���� � ������� �� 2 ������� �����/���� , ���� ������������ �� �����

-- � ��� ������ ����� �������� ����� �� ������������ ������ � ������ �� ������ ����������� onTrade �� ����������

function OnInit()
		
	-- �������� ����������	
	account="SPBFUT000vu"
	mtiker="RIM1"
	mytrade=0
	mPosition=0
	mPos=0
	robotInfo="������ ������ 1.2: �� 6 ��� 2021. 1� ������� �����"
	rIS="��1.2: "
	finResult=0 -- ������ ���������� ��� ��������
	Sch=0
	vol1=0
	vol2=0
	Price=0
	Price2=0
	starttime=1000
	finishtime=2330
	ctime=0
	TLine=1
	
	message("[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]")
	message("[ "..robotInfo.." ]")
	message("[ ------------  ��������� ����������:  ------------ ]")
	
	if m_t==nil then
		m_t=AllocTable()
		AddColumn(m_t, 1, "���������", true, QTABLE_STRING_TYPE, 20)
		AddColumn(m_t, 2, "��������", true, QTABLE_STRING_TYPE, 18)
		CreateWindow(m_t)
		SetWindowPos(m_t,0,428,341,390)
		SetWindowCaption(m_t, rIS.."FUT RIM1 1M")
		for n=1,17 do
			InsertRow(m_t,-1)
		end
		SetCell(m_t, 1, 1, "�������: ")
		SetCell(m_t, 2, 1, "���������� ���������: ")
		SetCell(m_t, 1, 2, tostring(finResult))

	end

	
		local main_info = {"TRADEDATE", "SERVERTIME", "SERVER", "USERID", "LOCALTIME"} 

 
		local main_comments = {'���� ������ ' , '����� ������� ' , '������ ' , 'ID ������������ ' , '������� ����� '}

	for key, nm in pairs(main_info) do
		local c=getInfoParam(nm)
		message("[ "..tostring(main_comments[key])..": "..c.." ]")

	end
		
	message("[ --- ��������� ������ ������� --- ]")	
	
end


function OnTrade(trd) 
	if trd['account'] and trd['account']==account and trd['trade_num']>mytrade and trd['sec_code']==mtiker  then 
		
		if bit.band(tonumber(trd['flags']),4)>0 then 
			mPosition=mPosition-1
			Price2=trd.price
			vol2=trd.value
			
			-- message("vol2="..vol2)			
			SetCell(m_t, 4, 1, "����� "..Sch.." :")
			SetCell(m_t, 5, 1, "����� "..Sch.." :")
		else
			mPosition=mPosition+1
			Price=trd.price
			vol1=trd.value
			-- message("vol1="..vol1)
			Sch=Sch+1
			
			_, TLine=math.modf(tonumber(Sch)/5) 
			TLine=tonumber(TLine*5)
			 
		end
		mytrade=trd['trade_num'] 
		message(rIS.."--> �������="..mPosition.." ������� Sch="..Sch.." ����� ������:"..trd.order_num.." ����� ������:"..trd.trade_num)
	end	
end

function mrealtime()

	cTimeH=os.sysdate().hour
	cTimeMin=os.sysdate().min
	if tonumber(cTimeH)<10 then cTimeH="0"..cTimeH end
	if cTimeMin<10 then cTimeMin="0"..cTimeMin end
	return tonumber(cTimeH..cTimeMin)
end


function mB() --myBye / �������
	
	message(rIS.."�������") 
	
		transaction={
						-- ������������ ���� ��� ��������� �����
			["TRANS_ID"]=tostring(1),
			["ACTION"]="NEW_ORDER",
			["CLASSCODE"]="SPBFUT",
			["SECCODE"]=tostring(mtiker),
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
	
	sleep(1000)
		
	message(rIS.."���� ����� ("..Sch..") = "..Price)
	mPos=1
	
	SetCell(m_t, 1, 2, tostring(mPos.." ("..Sch..")"))
	
	SetCell(m_t, 3*TLine, 1, "���� "..Sch.." :")
	SetCell(m_t, 3*TLine+1, 1, " ")
	SetCell(m_t, 3*TLine+2, 1, " ")
	
	SetCell(m_t, 3*TLine, 2, tostring(vol1.." ("..Price..")"))
	SetCell(m_t, 3*TLine+1, 2, " ")
	SetCell(m_t, 3*TLine+2, 2, " ")
		
end



function mS() --mySell / �������
	
	message(rIS.."�������") 
	
		transaction={
						-- ������������ ���� ��� ��������� �����
			["TRANS_ID"]=tostring(1),
			["ACTION"]="NEW_ORDER",
			["CLASSCODE"]="SPBFUT",
			["SECCODE"]=tostring(mtiker),
			["OPERATION"]="S",
			["QUANTITY"]=tostring(1),
			["TYPE"]="M",
			["PRICE"]=tostring(0),
			["ACCOUNT"]=tostring("SPBFUT000vu"),
			["CLIENT_CODE"]=rIS.."�������",	 
			["EXECUTION_CONDITION"]="PUT_IN_QUEUE",	 
		}
		
		res=sendTransaction(transaction)  -- ������� QLUA ���������� ���������� �� ������ ������� (�����) ���������� ��� ������ ������ "", ���� ��� �� ��� ������ � �������
		if res~="" then
			message("----------> ����� �������:"..res)
		else 
			message("-> ������ ������� ���������")
		end
	
	sleep(2000)
	
	message(rIS.."���� �������� ("..Sch..") = "..Price2)
	finTrade=(vol2-vol1)
	finTrade=finTrade-finTrade%0.01
	message(rIS.."���� �� ����� ("..Sch..") = ( "..vol2.. " ("..Price2.." ) - "..vol1.." ("..Price.." ) = "..finTrade)
	finResult=finResult+finTrade
	message(rIS.."����� ���������="..finResult)
	
	mPos=0
	
	SetCell(m_t, 3*TLine+1, 2, tostring(vol2.." ("..Price2..")"))
	SetCell(m_t, 3*TLine+2, 2, tostring(finTrade))
	
	
end


function OnStop()
	message(rIS.."��������� ����������")	
	tRun=false
	
			if mPos==1 and mPosition==1 then mS() end
			 
	message(rIS.."--> ����������]")	
end


function totalSBERPrice (dPos)
	qt=getQuoteLevel2("SPBFUT", mtiker)
 
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
	ctime=tonumber(mrealtime())
	-- message(" "..ctime)
	
	tRun=true
	
	while tRun do
	

	if ctime<starttime then
			message (rIS.."<10:00 ����� �� ��������, ��� 10:00")
			
			while ctime<starttime do
				ctime=tonumber(mrealtime())
				sleep(10000)
				message (rIS.."��� start time")
			end
		end
		
		 if ctime>=finishtime then
			 message (rIS.."-->18:30. ������������� ����� �� finish time")
			OnStop()
			return
			
	end
	
	cTimeH=os.sysdate().hour
	cTimeMin=os.sysdate().min
	
	tM, tmin=math.modf(tonumber(cTimeMin)/10) 
	tmin=tonumber(tmin*10)
	realmin=cTimeMin-tM*10
 
	
	-- �������� ����� ����������� �������
		if cTimeH>=10 and cTimeH<=23 and mPos==0 and tonumber(realmin)==1 then 
			mB()
		end
	
		if cTimeH>=10 and cTimeH<=23 and mPos==0 and tonumber(realmin)==3 then 
			mB()
		end
		
		if cTimeH>=10 and cTimeH<=23 and mPos==0 and tonumber(realmin)==5 then 
			mB()
		end
	
		if cTimeH>=10 and cTimeH<=23 and mPos==0 and tonumber(realmin)==7 then 
			mB()
		end
	
		if cTimeH>=10 and cTimeH<=23 and mPos==0 and tonumber(realmin)==9 then 
			mB()
		end
	
	
		if cTimeH>=10 and cTimeH<=23 and mPos==1 and tonumber(realmin)==2 then mS() end
	
		if cTimeH>=10 and cTimeH<=23 and mPos==1 and tonumber(realmin)==4 then mS() end
		
		if cTimeH>=10 and cTimeH<=23 and mPos==1 and tonumber(realmin)==6 then mS() end
		
		if cTimeH>=10 and cTimeH<=23 and mPos==1 and tonumber(realmin)==8 then mS() end
		
		if cTimeH>=10 and cTimeH<=23 and mPos==1 and tonumber(realmin)==0 then mS() end
	
		-- if tonumber(realmin)==3 and mPos==0 then 
			-- message(rIS.."�������") 
			-- Price=totalSBERPrice(mPos)
			-- mB(Price)
			-- message(rIS.."���� �����="..Price)
			-- mPos=1
		-- end
		  
		-- if tonumber(realmin)==4 and mPos==1 then 
			-- message(rIS.."�������") 
			-- Price2=totalSBERPrice(mPos)
			-- mS(Price2)
			-- message(rIS.."���� ��������="..Price2)
			-- finTrade=Price2-Price
			-- finTrade=finTrade-finTrade%0.01
			-- message(rIS.."���� �� �����="..Price2.." - "..Price.." = "..finTrade)
			-- finResult=finResult+finTrade
			-- message(rIS.."����� ���������="..finResult)
			-- mPos=0
		-- end
		  
		-- if tonumber(realmin)==5 and mPos==0 then 
			-- message(rIS.."�������") 
			-- Price=totalSBERPrice(mPos)
			-- mB(Price)
			-- message(rIS.."���� �����="..Price)
			-- mPos=1
		-- end
		  
		-- if tonumber(realmin)==6 and mPos==1 then 
			-- message(rIS.."�������") 
			-- Price2=totalSBERPrice(mPos)
			-- mS(Price2)
			-- message(rIS.." ���� ��������="..Price2)
			-- finTrade=Price2-Price
			-- finTrade=finTrade-finTrade%0.01
			-- message(rIS.."���� �� �����="..Price2.." - "..Price.." = "..finTrade)
			-- finResult=finResult+finTrade
			-- message(rIS.."����� ���������="..finResult)
			-- mPos=0
		-- end
		  
		-- if tonumber(realmin)==7 and mPos==0 then 
			-- message(rIS.."�������") 
			-- Price=totalSBERPrice(mPos)
			-- mB(Price)
			-- message(rIS.."���� �����="..Price)
			-- mPos=1
		-- end
		  
		  -- if tonumber(realmin)==8 and mPos==1 then 
			-- message(rIS.."�������") 
			-- Price2=totalSBERPrice(mPos)
			-- mS(Price2)
			-- message(rIS.."���� ��������="..Price2)
			-- finTrade=Price2-Price
			-- finTrade=finTrade-finTrade%0.01
			-- message(rIS.."���� �� �����="..Price2.." - "..Price.." = "..finTrade)
			-- finResult=finResult+finTrade
			-- message(rIS.."����� ���������="..finResult)
			-- mPos=0
		  -- end
		  
		  -- if tonumber(realmin)==9 and mPos==0 then 
			-- message(rIS.."�������")
			-- Price=totalSBERPrice(mPos)
			-- mB(Price)
			-- message(rIS.."���� �����="..Price)
			-- mPos=1			
		  -- end
		  
		-- if tonumber(realmin)==0 and mPos==1 then 
			-- message(rIS.."�������") 
			-- Price2=totalSBERPrice(mPos)
			-- mS(Price2)
			-- message(rIS.."���� ��������="..Price2)
			-- finTrade=Price2-Price
			-- finTrade=finTrade-finTrade%0.01
			-- message(rIS.."���� �� �����="..Price2.." - "..Price.." = "..finTrade)
			-- finResult=finResult+finTrade
			-- message(rIS.."����� ���������="..finResult)
			-- mPos=0
		-- end
		
		sleep(1000)
		-- � �������� ������ ��������� �� 1-2
	end
end 