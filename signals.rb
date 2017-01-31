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

#get all invoices ids
ids = models.execute_kw(db, uid, password,
    'account.invoice', 'search',
    [[['state', '=', 'open']]])

puts "invoices ids are#{ids}"

puts ids

#read the first invoices
#get all product names
invoice = models.execute_kw(db, uid, password,
    'account.invoice', 'read',
    [ids[0]])

puts invoice.to_json



puts models.exec_workflow(
        db, uid, password,
        'account.invoice', 'invoice_open', ids[0])
