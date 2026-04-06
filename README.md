# KP Agency OS — Control Room

Knaepen Partners automated agency operating system. Live control room for approving content, monitoring agents, and managing leads.

**Live dashboard:** Deploy to Vercel → instant URL

## Architecture

```
Intelligence layer (6:30am daily)
  └── Perplexity Sonar × 4 queries → Supabase intelligence_briefs

Content agent (Monday 7:00am)
  └── Claude + briefs + brand guide → post_requests (needs_review)

Control room (this repo → Vercel)
  └── Live dashboard → approve/reject → n8n approval webhook

Daily poster (4:00pm weekdays)
  └── Approved posts → Instagram via Composio

Lead agent (9:00am daily)
  └── Google Maps → score → Supabase leads
```

## Stack

| Layer | Tool |
|-------|------|
| Orchestration | n8n (dynamorate.com) |
| Intelligence | Perplexity Sonar API |
| Generation | Anthropic Claude API |
| Database | Supabase |
| Publishing | Composio (Instagram, LinkedIn) |
| Control room | This repo → Vercel |
| Leads | Google Maps Places API |

## n8n Workflows

| # | Name | ID | Schedule |
|---|------|----|----------|
| 1 | Daily Intelligence Brief | CoHWTpkKPQbLJpDa | 6:30am daily |
| 2 | Content Agent | HSlxWIx93jgb2CVA | Monday 7:00am |
| 3 | Approval Webhook | Xb27TZi3qayi0B0V | Always on |
| 4 | Daily Poster | Str8XUcpf9liotNc | 4:00pm weekdays |
| 5 | Lead Agent | GJ0aREUFHI3JkkUh | 9:00am daily |

## Deploy to Vercel

1. Go to [vercel.com](https://vercel.com) → New Project
2. Import `Dynamorate/Controlroom` from GitHub
3. Framework: **Other** (static)
4. Root directory: `/` (leave as is)
5. Click Deploy → done

## Supabase setup

Run `docs/supabase-setup.sql` in Supabase SQL editor once.

## Daily routine

Open your Vercel URL → scan approval queue → approve posts → 10 min/day.
