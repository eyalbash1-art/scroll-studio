-- ===== SCROLL STUDIO DATABASE SETUP =====

-- License keys table
CREATE TABLE license_keys (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  key TEXT UNIQUE NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('TFILA', 'SHEM')),
  event_name TEXT NOT NULL,
  client_name TEXT DEFAULT '',
  start_date TIMESTAMPTZ NOT NULL,
  end_date TIMESTAMPTZ NOT NULL,
  duration_hours INTEGER NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Print logs table
CREATE TABLE print_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  license_key TEXT NOT NULL,
  event_name TEXT NOT NULL,
  printed_name TEXT NOT NULL,
  gender TEXT NOT NULL,
  category TEXT NOT NULL,
  topic TEXT DEFAULT '',
  event_line TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Admin users table
CREATE TABLE admin_users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Insert default admin user (username: admin, password: tfila2026)
INSERT INTO admin_users (username, password_hash) 
VALUES ('admin', 'tfila2026');

-- Enable realtime for print_logs
ALTER PUBLICATION supabase_realtime ADD TABLE print_logs;
ALTER PUBLICATION supabase_realtime ADD TABLE license_keys;

-- Row Level Security (allow all for now - anon key)
ALTER TABLE license_keys ENABLE ROW LEVEL SECURITY;
ALTER TABLE print_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all on license_keys" ON license_keys FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all on print_logs" ON print_logs FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all on admin_users" ON admin_users FOR ALL USING (true) WITH CHECK (true);
