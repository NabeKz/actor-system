# Health Check
GET http://localhost:5000/health
HTTP 200
[Asserts]
jsonpath "$.status" == "ok"

# Create Account
POST http://localhost:5000/account
Content-Type: application/json
{"initial_balance": 1000}
HTTP 201
[Asserts]
jsonpath "$.account_id" exists
jsonpath "$.balance" == 1000
[Captures]
account_id: jsonpath "$.account_id"

# Get Account (created above)
GET http://localhost:5000/account/{{account_id}}
HTTP 200
[Asserts]
jsonpath "$.account_id" == {{account_id}}
jsonpath "$.balance" == 1000

# Get Account Not Found
GET http://localhost:5000/account/nonexistent
HTTP 404
[Asserts]
jsonpath "$.error" exists
