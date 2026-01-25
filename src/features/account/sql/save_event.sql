INSERT INTO account_events (account_id, event_type, payload, timestamp)
VALUES ($1, $2, $3, $4)
RETURNING id, created_at
