	transaction={
					-- ������������ ���� ��� ��������� �����
		["TRANS_ID"]=tostring(1),
		["ACTION"]="NEW_ORDER",
		["CLASSCODE"]="SPBFUT",
		["SECCODE"]="RIM1",
		["OPERATION"]="S",
		["QUANTITY"]=tostring(1),
		["PRICE"]=tostring(152900),--toPrice(security,price,class),
		["ACCOUNT"]=tostring("SPBFUT000vu"),
		
					-- �������������� ����  ��� ��������� �����
		["CLIENT_CODE"]="�����1",	-- ��� ��������� ����� ��� ����������� � ������. ������ ������������� ����������� ��� �������������� ��� ������� � ��� ��� ���� ���� //	
		["EXECUTION_CONDITION"]="PUT_IN_QUEUE",	-- ��� ������ ��������, �������� � ��
	}
	
	res=sendTransaction(transaction)  -- ������� QLUA ���������� ���������� �� ������ ������� (�����) ���������� ��� ������ ������ "", ���� ��� �� ��� ������ � �������
	if res~="" then
		message(" >> res= "..res)
	else 
		message(" >> sendTransaction -> ok!")
	end