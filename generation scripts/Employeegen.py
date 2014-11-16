""" 
Database Employee Generator
Stuart Bradley
6-3-2014
"""
content = []
data_strings = []
with open('Employee_list.txt') as f:
    content = f.readlines()

for employee in content:
	employee = employee.strip()
	employee_email = employee.replace(" ", ".",1) + '@lanzatech.com'
	print employee_email
	data_strings.append('Employee.create!({:name => "'+ employee +'", :email => "'+ employee_email +'"})')

print data_strings
with open('seed.txt', 'w') as f:
    for s in data_strings:
        f.write(s + '\n')