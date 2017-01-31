require "xmlrpc/client"
require "json"


url = "http://localhost:8069"
db = "test"
username = "oscarsanhueza@gmail.com"
password = "oscar"


common = XMLRPC::Client.new2("#{url}/xmlrpc/2/common")
puts common.call('version')

uid = common.call('authenticate', db, username, password, {})

puts uid

models = XMLRPC::Client.new2("#{url}/xmlrpc/2/object").proxy


#get all sales orders ids
ids = models.execute_kw(db, uid, password,
    'stock.pack.operation', 'search',
    [[]])

puts "#{ids} it was with size #{ids.size}"

#get all product names
orders = models.execute_kw(db, uid, password,
    'stock.pack.operation', 'read',
    [ids], {'fields': ['name', 'state', 'display_name']})

puts orders

#get all product names
orders = models.execute_kw(db, uid, password,
    'stock.pack.operation', 'read',
    [ids.last])

puts orders.to_json
