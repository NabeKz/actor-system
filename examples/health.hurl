GET http://localhost:5000/health
HTTP 200
[Asserts]
jsonpath "$.status" == "ok"
