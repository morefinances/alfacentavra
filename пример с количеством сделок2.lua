-- ���������� ������

message("����� -->")
message("[========]")

function main()
	n=getNumberOf("trades")
	message("���������� ������="..n)
	for i=n-5, n-1 do
		ord=getItem("orders", i)
		message("��� �����������="..ord.sec_code)
		message("����="..ord.price)
		message("�����="..ord.qty)
		message("�����="..ord.value)
		message("�����="..tostring(ord.activation_time))
		message("ID="..ord.userid)
		message("����� ������="..ord.order_num)
		message("����="..ord.account)
		message("��� �������="..ord.brokerref)
		message("- - - - - - - - - - - - - - - - - - ")
	end
	
	message("--> �������� �����")
end

