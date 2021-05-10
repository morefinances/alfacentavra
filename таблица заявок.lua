-- количество заявок v2


function OnInit()
	message("Старт -->")
	message("[========]")
	tt= {"Код инструмента",
		"Цена",
		"Объем",
		"ID",
		"Номер ордера",
		"Счет",
		"Код клиента"
		}

end



function main()

	
	n=getNumberOf("orders")
	-- message("количество заявок="..n)
	
		if m_t==nil then
		m_t=AllocTable()
		for m=1, #tt do
			AddColumn(m_t, m, tostring(tt[m]), true, QTABLE_STRING_TYPE, 25)
		end
		
	CreateWindow(m_t)
	SetWindowPos(m_t,100,100,1000,200)
	SetWindowCaption(m_t, "Таблица 1")
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

		-- message("Код инструмента="..ord.sec_code)
		-- message("Цена="..ord.price)
		-- message("Лотов="..ord.qty)
		-- message("Объем="..ord.value)
		-- message("ID="..ord.userid)
		-- message("Номер ордера="..ord.order_num)
		-- message("Счет="..ord.account)
		-- message("Код клиента="..ord.brokerref)
		
		
	end
	
	-- 
	
	message("--> Успешный финиш")
end

