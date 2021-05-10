-- ������ �������� 1 �������� ��� �������� ����� / ����
-- ������ 1.2 �� 06 05 2021
-- ���� �������� (�� ������� ����� ����� ��������� ������ ����)



function OnInit()
		
	-- �������� ����������	
	mPos=0
	robotInfo="������ �1.3: �� 6 ��� 2021. 5� ������� �����"
	rIS="�.�3.0: "
	finResult=0 -- ������ ���������� ��� ��������
	
	
	message("[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ]")
	message("[ "..robotInfo.." ]")
	message("[ ------------  ��������� ����������:  ------------ ]")
	
	 
		local main_info = {"TRADEDATE", "SERVERTIME", "SERVER", "USERID", "LOCALTIME"} 

 
		local main_comments = {'���� ������ ' , '����� ������� ' , '������ ' , 'ID ������������ ' , '������� ����� '}

	for key, nm in pairs(main_info) do
		local c=getInfoParam(nm)
		message("[ "..tostring(main_comments[key])..": "..c.." ]")

	end
		
	message("[ --- ��������� ������ ������� --- ]")	
	
end

function mB(Pri)
	transaction={
					-- ������������ ���� ��� ��������� �����
		["TRANS_ID"]=tostring(1),
		["ACTION"]="NEW_ORDER",
		["CLASSCODE"]="SPBFUT",
		["SECCODE"]="RIM1",
		["OPERATION"]="B",
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
end

function mS(Pri)
	transaction={
					-- ������������ ���� ��� ��������� �����
		["TRANS_ID"]=tostring(1),
		["ACTION"]="NEW_ORDER",
		["CLASSCODE"]="SPBFUT",
		["SECCODE"]="RIM1",
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
end


function OnStop()
	tRun=false
	message(rIS.."--> ����������]")	
end


function totalSBERPrice (dPos)
	qt=getQuoteLevel2("SPBFUT", "RIM1")
 
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