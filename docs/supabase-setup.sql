-- KP Agency OS — Supabase setup
-- Run this once in the Supabase SQL editor

-- Intelligence briefs (daily Perplexity output)
CREATE TABLE IF NOT EXISTS intelligence_briefs (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at timestamptz DEFAULT now(),
  date date NOT NULL,
  category text NOT NULL,
  summary text NOT NULL,
  raw_data text,
  model_used text DEFAULT 'sonar'
);
CREATE INDEX IF NOT EXISTS idx_briefs_date ON intelligence_briefs(date DESC);

-- Leads (scored prospects from Google Maps)
CREATE TABLE IF NOT EXISTS leads (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at timestamptz DEFAULT now(),
  business_name text NOT NULL,
  business_type text,
  location text,
  address text,
  phone text,
  website text,
  google_rating numeric,
  google_review_count integer,
  instagram_handle text,
  score integer,
  score_reasons text,
  outreach_message_nl text,
  outreach_message_fr text,
  status text DEFAULT 'pending',
  linkedin_profile_url text,
  notes text
);
CREATE INDEX IF NOT EXISTS idx_leads_status ON leads(status);
CREATE INDEX IF NOT EXISTS idx_leads_score ON leads(score DESC);

-- RLS: Enable on all tables
ALTER TABLE intelligence_briefs ENABLE ROW LEVEL SECURITY;
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;

-- Allow anon (dashboard) to READ all tables
-- The dashboard uses the public anon key - safe for read-only access
CREATE POLICY "anon can read briefs" ON intelligence_briefs FOR SELECT TO anon USING (true);
CREATE POLICY "anon can read leads" ON leads FOR SELECT TO anon USING (true);

-- Allow anon to UPDATE leads status (for approve/reject in dashboard)
CREATE POLICY "anon can update leads" ON leads FOR UPDATE TO anon USING (true);

-- Allow anon to UPDATE post_requests status (for approve/reject)
-- post_requests table already exists - add policy
CREATE POLICY "anon can update posts" ON post_requests FOR UPDATE TO anon USING (true);
CREATE POLICY "anon can read posts" ON post_requests FOR SELECT TO anon USING (true);
CREATE POLICY "anon can read clients" ON clients FOR SELECT TO anon USING (true);

-- Note: INSERT/DELETE on all tables requires service_role key
-- Only n8n workflows (server-side) use the service_role key
-- The dashboard (browser) only needs anon key for read + status updates
