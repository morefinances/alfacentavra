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
		SetCell(m_t, 1, 2, "0")

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
	
	if TLine==1 then
		for i=0,2 do
			SetColor(m_t, 15+i, 1, RGB(255,255,255), RGB(0,0,0), RGB(255,255,255), RGB(0,0,0)) -- ���, �����, ��� ���������� ������, ����� ���������� ������
			SetColor(m_t, 15+i, 2, RGB(255,255,255), RGB(0,0,0), RGB(255,255,255), RGB(0,0,0))
		end
	else
		for i=0,2 do
			SetColor(m_t, 3*(TLine-1)+i, 1, RGB(255,255,255), RGB(0,0,0), RGB(255,255,255), RGB(0,0,0))
			SetColor(m_t, 3*(TLine-1)+i, 2, RGB(255,255,255), RGB(0,0,0), RGB(255,255,255), RGB(0,0,0))
		end

	end
	
	SetCell(m_t, 1, 2, tostring(mPos.." ("..Sch..")"))
	
	SetCell(m_t, 3*TLine, 1, "���� "..Sch.." :")
	SetColor(m_t, 3*TLine, 1, RGB(240,240,0), RGB(0,0,0), RGB(240,240,0), RGB(0,0,0))
	SetCell(m_t, 3*TLine+1, 1, " ")
	SetCell(m_t, 3*TLine+2, 1, " ")
	
	SetCell(m_t, 3*TLine, 2, tostring(vol1.." ("..Price..")"))
	SetColor(m_t, 3*TLine, 2, RGB(240,240,0), RGB(0,0,0), RGB(240,240,0), RGB(0,0,0))
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
	
	SetCell(m_t, 3*TLine+1, 1, "����� ("..Sch..") :")
	SetColor(m_t, 3*TLine+1, 1, RGB(240,240,0), RGB(0,0,0), RGB(240,240,0), RGB(0,0,0))
	SetCell(m_t, 3*TLine+2, 1, "����� ("..Sch..") :")
	SetColor(m_t, 3*TLine+2, 1, RGB(240,240,0), RGB(0,0,0), RGB(240,240,0), RGB(0,0,0))
	
	SetCell(m_t, 3*TLine+1, 2, tostring(vol2.." ("..Price2..")"))
	SetColor(m_t, 3*TLine+1, 1, RGB(240,240,0), RGB(0,0,0), RGB(240,240,0), RGB(0,0,0))
	SetCell(m_t, 3*TLine+2, 2, tostring(finTrade))
	SetColor(m_t, 3*TLine+2, 1, RGB(240,240,0), RGB(0,0,0), RGB(240,240,0), RGB(0,0,0))
	
end


function OnStop()
	message(rIS.."��������� ����������")	
	tRun=false
	
			if mPos==1 and mPosition==1 then mS() end
			 
	message(rIS.."--> ����������]")	
end


function currentmin()
	cTimeMin=os.sysdate().min
	tM, tmin=math.modf(tonumber(cTimeMin)/10) 
	tmin=tonumber(tmin*10)
	return tonumber(cTimeMin-tM*10)
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
	tRun=true
	
	while tRun do
	ctime=tonumber(mrealtime())

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
	
	--cTimeH=os.sysdate().hour
	-- cTimeMin=os.sysdate().min
	
	-- tM, tmin=math.modf(tonumber(cTimeMin)/10) 
	-- tmin=tonumber(tmin*10)
	-- realmin=cTimeMin-tM*10
 
	
	-- �������� ����� ����������� �������
	
	
		if ctime>=starttime and ctime<finishtime and mPos==0 then 
		
			realmin=currentmin() 
			message("current min="..realmin)
			
			if tonumber(realmin)==1 or tonumber(realmin)==3 or tonumber(realmin)==5 or tonumber(realmin)==7 or tonumber(realmin)==9 then mB() end

			sleep(1000)
		end
		
		
		if ctime>=starttime and ctime<finishtime and mPos==1 then 
		
			realmin=currentmin() 
			message("current min="..realmin)
			
			if tonumber(realmin)==2 or tonumber(realmin)==4 or tonumber(realmin)==6 or tonumber(realmin)==8 or tonumber(realmin)==0 then mS() end
			
			sleep(1000)
			
		end
		


		
		sleep(1000)
		-- � �������� ������ ��������� �� 1-2
	end
end 