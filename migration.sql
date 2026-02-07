CREATE TABLE IF NOT EXISTS account_events (
  id SERIAL PRIMARY KEY,
  account_id TEXT NOT NULL,
  event_type TEXT NOT NULL,
  payload TEXT NOT NULL,
  timestamp BIGINT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_account_events_account_id ON account_events(account_id);
