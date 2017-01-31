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
    'stock.picking', 'search',
    [[['picking_type_code','=','outgoing']]])

puts "#{ids} it was with size #{ids.size}"

#get all product names
orders = models.execute_kw(db, uid, password,
    'stock.picking', 'read',
    [ids])#, {'fields': ['name', 'state', 'display_name', 'origin', 'pack_operation_ids']})

puts orders.last.to_json

#gets the stock operation of the last order
stockoperation = models.execute_kw(db, uid, password,
    'stock.pack.operation', 'read',
    [orders.last["pack_operation_ids"]])#, {'fields': ['picking_id', 'qty_done']})

puts stockoperation

#puts models.execute_kw(db, uid, password,
#    'stock.picking', 'read',
#    [ids.last]).to_json
#get all product names
#orders = models.execute_kw(db, uid, password,
#    'stock.picking', 'read',
#    [ids.last])
