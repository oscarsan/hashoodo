require "xmlrpc/client"
require "json"


url = "http://localhost:8069"
db = "oscar"
username = "admin"
password = "admin"


common = XMLRPC::Client.new2("#{url}/xmlrpc/2/common")
puts common.call('version')

uid = common.call('authenticate', db, username, password, {})

puts uid

models = XMLRPC::Client.new2("#{url}/xmlrpc/2/object").proxy


#get all models ids
ids = models.execute_kw(db, uid, password,
    'ir.model.fields', 'search',
    [[['name', '=', 'x_test']]])

puts "#{ids} it was"

#get all product names
fields = models.execute_kw(db, uid, password,
    'ir.model.fields', 'read',
    [ids], {'fields': ['model', 'name']})

puts fields
