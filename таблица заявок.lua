-- ���������� ������ v2


function OnInit()
	message("����� -->")
	message("[========]")
	tt= {"��� �����������",
		"����",
		"�����",
		"ID",
		"����� ������",
		"����",
		"��� �������"
		}

end



function main()

	
	n=getNumberOf("orders")
	-- message("���������� ������="..n)
	
		if m_t==nil then
		m_t=AllocTable()
		for m=1, #tt do
			AddColumn(m_t, m, tostring(tt[m]), true, QTABLE_STRING_TYPE, 25)
		end
		
	CreateWindow(m_t)
	SetWindowPos(m_t,100,100,1000,200)
	SetWindowCaption(m_t, "������� 1")
		for i=1, n do
			InsertRow(m_t,-1)
		end
	end
	
	
		
		for i=0, n-1 do
		ord=getItem("orders", i)
		SetCell(m_t, i+1, 1, tostring(ord.sec_code))
		SetCell(m_t, i+1, 2, tostring(ord.price))
		SetCell(m_t, i+1, 3, tostring(ord.value))
		SetCell(m_t, i+1, 4, tostring(ord.userid))
		SetCell(m_t, i+1, 5, tostring(ord.order_num))
		SetCell(m_t, i+1, 6, tostring(ord.account))
		SetCell(m_t, i+1, 7, tostring(ord.brokerref))

		-- message("��� �����������="..ord.sec_code)
		-- message("����="..ord.price)
		-- message("�����="..ord.qty)
		-- message("�����="..ord.value)
		-- message("ID="..ord.userid)
		-- message("����� ������="..ord.order_num)
		-- message("����="..ord.account)
		-- message("��� �������="..ord.brokerref)
		
		
	end
	
	-- 
	
	message("--> �������� �����")
end

