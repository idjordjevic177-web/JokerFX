-- Joker FX community, run once in a new Supabase project.
begin;
create table public.jf_profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 display_name text not null default 'Član' check(char_length(trim(display_name)) between 2 and 40),
 bio text not null default '' check(char_length(bio)<=300),
 created_at timestamptz not null default now()
);
create table public.jf_posts (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references public.jf_profiles(id) on delete cascade,
 category text not null check(category in ('analize','strategije','trgovanje','psihologija','pitanja')),
 title text not null check(char_length(trim(title)) between 3 and 120),
 body text not null check(char_length(trim(body)) between 3 and 4000),
 chart_url text check(chart_url is null or (chart_url like 'https://%' and char_length(chart_url)<=500)),
 created_at timestamptz not null default now()
);
create table public.jf_comments (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references public.jf_profiles(id) on delete cascade,
 post_id uuid not null references public.jf_posts(id) on delete cascade,
 body text not null check(char_length(trim(body)) between 1 and 2000),
 created_at timestamptz not null default now()
);
create table public.jf_messages (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references public.jf_profiles(id) on delete cascade,
 room text not null check(room in ('general','forex','gold','help')),
 body text not null check(char_length(trim(body)) between 1 and 1000),
 created_at timestamptz not null default now()
);
create index jf_posts_category_date on public.jf_posts(category,created_at desc);
create index jf_posts_date on public.jf_posts(created_at desc);
create index jf_comments_post_date on public.jf_comments(post_id,created_at);
create index jf_messages_room_date on public.jf_messages(room,created_at desc);
create function public.jf_new_profile() returns trigger language plpgsql security definer set search_path='' as $$
begin
 insert into public.jf_profiles(id,display_name) values(new.id,'Član '||left(new.id::text,6)) on conflict(id) do nothing;
 return new;
end; $$;
revoke all on function public.jf_new_profile() from public,anon,authenticated;
create trigger jf_on_new_user after insert on auth.users for each row execute function public.jf_new_profile();
insert into public.jf_profiles(id,display_name) select id,'Član '||left(id::text,6) from auth.users on conflict(id) do nothing;
alter table public.jf_profiles enable row level security;
alter table public.jf_posts enable row level security;
alter table public.jf_comments enable row level security;
alter table public.jf_messages enable row level security;
revoke all on public.jf_profiles,public.jf_posts,public.jf_comments,public.jf_messages from anon,authenticated;
grant select on public.jf_profiles,public.jf_posts,public.jf_comments,public.jf_messages to authenticated;
grant update(display_name,bio) on public.jf_profiles to authenticated;
grant insert(user_id,category,title,body,chart_url),delete on public.jf_posts to authenticated;
grant insert(user_id,post_id,body) on public.jf_comments to authenticated;
grant insert(user_id,room,body) on public.jf_messages to authenticated;
create policy jf_profiles_read on public.jf_profiles for select to authenticated using(true);
create policy jf_profiles_self_update on public.jf_profiles for update to authenticated using((select auth.uid())=id) with check((select auth.uid())=id);
create policy jf_posts_read on public.jf_posts for select to authenticated using(true);
create policy jf_posts_insert on public.jf_posts for insert to authenticated with check((select auth.uid())=user_id);
create policy jf_posts_delete on public.jf_posts for delete to authenticated using((select auth.uid())=user_id);
create policy jf_comments_read on public.jf_comments for select to authenticated using(true);
create policy jf_comments_insert on public.jf_comments for insert to authenticated with check((select auth.uid())=user_id);
create policy jf_messages_read on public.jf_messages for select to authenticated using(true);
create policy jf_messages_insert on public.jf_messages for insert to authenticated with check((select auth.uid())=user_id);
alter publication supabase_realtime add table public.jf_posts,public.jf_comments,public.jf_messages;
commit;
