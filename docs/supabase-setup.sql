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

-- Enable RLS
ALTER TABLE intelligence_briefs ENABLE ROW LEVEL SECURITY;
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Service role full access briefs" ON intelligence_briefs FOR ALL USING (true);
CREATE POLICY "Service role full access leads" ON leads FOR ALL USING (true);
