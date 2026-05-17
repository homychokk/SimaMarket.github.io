create extension if not exists "pgcrypto";
create extension if not exists pg_trgm;

-- =====================
-- PROFILES
-- =====================
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  username text not null,
  avatar_url text,
  phone text,
  city text,
  bio text
);

alter table public.profiles disable row level security;

create index if not exists profiles_username_idx on public.profiles using gin (username gin_trgm_ops);

-- =====================
-- ITEMS
-- =====================
drop table if exists public.items;

create table public.items (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  title text not null,
  description text not null,
  price numeric not null check (price >= 0),
  category text not null,
  image_url text,
  user_id uuid not null references auth.users(id) on delete cascade
);

alter table public.items disable row level security;

create index items_title_idx    on public.items using gin (title gin_trgm_ops);
create index items_category_idx on public.items (category);
create index items_user_id_idx  on public.items (user_id);
create index items_created_at_idx on public.items (created_at desc);
