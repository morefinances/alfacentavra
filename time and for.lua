-- пример с циклом и системным временем
for i=1, 20 do
	tsec=os.sysdate().sec
	sleep(120)
	message(" "..tostring(tsec))
end