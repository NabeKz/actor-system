SELECT id, account_id, event_type, payload, timestamp, created_at
FROM account_events
WHERE account_id = $1
ORDER BY id ASC
