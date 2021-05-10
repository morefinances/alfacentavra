-- количество сделок

message("Старт -->")
message("[========]")

function main()
	n=getNumberOf("trades")
	message("количество сделок="..n)
	for i=n-5, n-1 do
		ord=getItem("orders", i)
		message("Код инструмента="..ord.sec_code)
		message("Цена="..ord.price)
		message("Лотов="..ord.qty)
		message("Объем="..ord.value)
		message("Время="..tostring(ord.activation_time))
		message("ID="..ord.userid)
		message("Номер ордера="..ord.order_num)
		message("Счет="..ord.account)
		message("Код клиента="..ord.brokerref)
		message("- - - - - - - - - - - - - - - - - - ")
	end
	
	message("--> Успешный финиш")
end

