	transaction={
					-- обязательные поля для фондового рынка
		["TRANS_ID"]=tostring(1),
		["ACTION"]="NEW_ORDER",
		["CLASSCODE"]="SPBFUT",
		["SECCODE"]="RIM1",
		["OPERATION"]="B",
		["QUANTITY"]=tostring(1),
		["TYPE"]="M",
		["PRICE"]=tostring(0),
		["ACCOUNT"]=tostring("SPBFUT000vu"),
		
					-- необязательные поля  для фондового рынка
		["CLIENT_CODE"]="текст1",	-- для фондового рынка это Комментарий к заявке. Сервер автоматически подставляет для алготранзакций код клиента и два или один слеш //	
		["EXECUTION_CONDITION"]="PUT_IN_QUEUE",	-- тип заявки рыночная, лимитная и тп
	}
	
	res=sendTransaction(transaction)  -- функция QLUA отправляет транзакцию на сервер брокера (биржу) возвращяет или пустую строку "", если все ок или строку с ошибкой
	if res~="" then
		message("----------> ответ системы:"..res)
	else 
		message("-> с заявкой всё")
	end