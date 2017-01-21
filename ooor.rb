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


puts models.execute_kw(db, uid, password,
    'res.partner', 'check_access_rights',
    ['read'], {raise_exception: false})



#get one product id by name
ids = models.execute_kw(db, uid, password,
    'product.product', 'search',
    [[['name', '=', 'Cost-plus Contract']]])

puts "#{ids} it was"

#get all products ids
ids = models.execute_kw(db, uid, password,
    'product.product', 'search',
    [[]])

puts "#{ids} it was"

#get all product names
products = models.execute_kw(db, uid, password,
    'product.product', 'read',
    [ids], {'fields': ['name']})

puts products

#shows the product model
puts "lets show the model, in json"

prudctmodel = models.execute_kw(
    db, uid, password, 'product.product', 'fields_get',
    [],  {'attributes': ['string', 'help', 'type']}) #last cn be take out to show whole model

puts prudctmodel.to_json



puts "lets create a product"
id = 40
#models.execute_kw(db, uid, password, 'product.product', 'create', [{
#    'name': "iso keltainen takki",
#}])

puts id

puts models.execute_kw(db, uid, password, 'product.product', 'write', [[id], {
    name: "iso musta takki"
}])

puts models.execute_kw(db, uid, password,
    'product.product', 'read',
    [id], {'fields': ['name']})
