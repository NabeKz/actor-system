GET http://localhost:5000/account/nonexistent
HTTP 404
[Asserts]
jsonpath "$.error" exists
