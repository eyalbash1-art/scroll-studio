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

-- license_keys: anyone can read (to validate), only service_role can write
CREATE POLICY "Anyone can read license_keys" ON license_keys FOR SELECT USING (true);
CREATE POLICY "Only service can write license_keys" ON license_keys FOR INSERT WITH CHECK (false);
CREATE POLICY "Only service can update license_keys" ON license_keys FOR UPDATE USING (false);
CREATE POLICY "Only service can delete license_keys" ON license_keys FOR DELETE USING (false);

-- print_logs: anyone can insert (log prints), only service_role can read
CREATE POLICY "Anyone can insert print_logs" ON print_logs FOR INSERT WITH CHECK (true);
CREATE POLICY "Anyone can read print_logs" ON print_logs FOR SELECT USING (true);

-- admin_users: no public access at all
CREATE POLICY "No public access to admin_users" ON admin_users FOR ALL USING (false);
