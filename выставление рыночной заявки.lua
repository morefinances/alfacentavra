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
		
					-- �������������� ����  ��� ��������� �����
		["CLIENT_CODE"]="�����1",	-- ��� ��������� ����� ��� ����������� � ������. ������ ������������� ����������� ��� �������������� ��� ������� � ��� ��� ���� ���� //	
		["EXECUTION_CONDITION"]="PUT_IN_QUEUE",	-- ��� ������ ��������, �������� � ��
	}
	
	res=sendTransaction(transaction)  -- ������� QLUA ���������� ���������� �� ������ ������� (�����) ���������� ��� ������ ������ "", ���� ��� �� ��� ������ � �������
	if res~="" then
		message("----------> ����� �������:"..res)
	else 
		message("-> � ������� ��")
	end