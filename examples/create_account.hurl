POST http://localhost:5000/account
Content-Type: application/json
{"initial_balance": 1000}
HTTP 201
[Asserts]
jsonpath "$.account_id" exists
jsonpath "$.balance" == 1000
