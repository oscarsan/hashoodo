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


#get id of product.template model
idsptemplate = models.execute_kw(db, uid, password,
    'ir.model', 'search',
    [[['model', '=', 'product.template']]])

puts idsptemplate

#show the model product.template
producttemplate =  models.execute_kw(db, uid, password,
    'ir.model', 'read',
    [idsptemplate])

puts producttemplate

option = gets

puts producttemplate[0]["id"]

option = gets
#get all fields from product.template names
fields = models.execute_kw(db, uid, password,
    'ir.model.fields', 'read',
    [producttemplate[0]["field_id"]], {'fields': ['model', 'name']})

puts fields



#add field to model, at the moment this is a bit of a problem as you can create
#infinite times this field in the model
#puts  models.execute_kw(
#        db, uid, password,
#        'ir.model.fields', 'create', [{
#            model_id: idsptemplate.first, #this is the id of the produt.product model
#            name: "x_test",
#            ttype: "char",
#            state: "manual",
#            required: false
#        }])
