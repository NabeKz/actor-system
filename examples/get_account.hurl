GET http://localhost:5000/account/{{account_id}}
HTTP 200
[Asserts]
jsonpath "$.account_id" == {{account_id}}
jsonpath "$.balance" exists
