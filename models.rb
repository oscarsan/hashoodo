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


#get all products ids
ids = models.execute_kw(db, uid, password,
    'ir.model', 'search',
    [[]])

puts "#{ids} it was"

#get all product names
products = models.execute_kw(db, uid, password,
    'ir.model', 'read',
    [ids], {'fields': ['model', 'name']})

puts products

#get id of product.product model
ids = models.execute_kw(db, uid, password,
    'ir.model', 'search',
    [[['model', '=', 'product.product']]])

puts ids

#show the mode product.product
puts models.execute_kw(db, uid, password,
    'ir.model', 'read',
    [ids])

option = gets
#add field to model
puts  models.execute_kw(
        db, uid, password,
        'ir.model.fields', 'create', [{
            model_id: ids.first, #this is the id of the produt.product model
            name: "x_test",
            ttype: "char",
            state: "manual",
            required: false
        }])
