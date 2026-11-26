-- Run after community-schema.sql, in SQL Editor as project owner.
begin;
create table public.jf_admins(user_id uuid primary key references auth.users(id) on delete cascade);
alter table public.jf_admins enable row level security;
revoke all on public.jf_admins from anon,authenticated;
create function public.jf_is_admin() returns boolean language sql stable security definer set search_path='' as $$
 select exists(select 1 from public.jf_admins where user_id=(select auth.uid()));
$$;
revoke all on function public.jf_is_admin() from public,anon,authenticated;
grant execute on function public.jf_is_admin() to authenticated;
create table public.jf_write_blocks(user_id uuid primary key references public.jf_profiles(id) on delete cascade,created_at timestamptz not null default now());
alter table public.jf_write_blocks enable row level security;
revoke all on public.jf_write_blocks from anon,authenticated;
grant select,delete on public.jf_write_blocks to authenticated;
grant insert(user_id) on public.jf_write_blocks to authenticated;
create policy jf_blocks_admin_select on public.jf_write_blocks for select to authenticated using((select public.jf_is_admin()));
create policy jf_blocks_admin_insert on public.jf_write_blocks for insert to authenticated with check((select public.jf_is_admin()) and user_id<>(select auth.uid()));
create policy jf_blocks_admin_delete on public.jf_write_blocks for delete to authenticated using((select public.jf_is_admin()));
create function public.jf_protect_admin_block() returns trigger language plpgsql security definer set search_path='' as $$
begin if exists(select 1 from public.jf_admins where user_id=new.user_id) then raise exception 'Cannot block an administrator'; end if; return new; end; $$;
revoke all on function public.jf_protect_admin_block() from public,anon,authenticated;
create trigger jf_protect_admin_block before insert on public.jf_write_blocks for each row execute function public.jf_protect_admin_block();
create function public.jf_can_write() returns boolean language sql stable security definer set search_path='' as $$
 select (select auth.uid()) is not null and not exists(select 1 from public.jf_write_blocks where user_id=(select auth.uid()));
$$;
revoke all on function public.jf_can_write() from public,anon,authenticated;
grant execute on function public.jf_can_write() to authenticated;
create policy jf_posts_not_blocked on public.jf_posts as restrictive for insert to authenticated with check((select public.jf_can_write()));
create policy jf_comments_not_blocked on public.jf_comments as restrictive for insert to authenticated with check((select public.jf_can_write()));
create policy jf_messages_not_blocked on public.jf_messages as restrictive for insert to authenticated with check((select public.jf_can_write()));
grant delete on public.jf_comments,public.jf_messages to authenticated;
create policy jf_posts_admin_delete on public.jf_posts for delete to authenticated using((select public.jf_is_admin()));
create policy jf_comments_admin_delete on public.jf_comments for delete to authenticated using((select public.jf_is_admin()));
create policy jf_messages_admin_delete on public.jf_messages for delete to authenticated using((select public.jf_is_admin()));
create table public.jf_content(
 id uuid primary key default gen_random_uuid(),
 kind text not null check(kind in ('analysis','news','education','webinar')),
 status text not null default 'draft' check(status in ('draft','published')),
 title text not null check(char_length(trim(title)) between 3 and 150),
 body text not null check(char_length(trim(body)) between 3 and 15000),
 link_url text check(link_url is null or (link_url like 'https://%' and char_length(link_url)<=500)),
 event_at timestamptz,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now(),
 check(kind<>'webinar' or status<>'published' or event_at is not null)
);
create function public.jf_content_touch() returns trigger language plpgsql set search_path='' as $$ begin new.updated_at=now(); return new; end; $$;
create trigger jf_content_touch before update on public.jf_content for each row execute function public.jf_content_touch();
create index jf_content_kind_status on public.jf_content(kind,status,updated_at desc);
alter table public.jf_content enable row level security;
revoke all on public.jf_content from anon,authenticated;
grant select on public.jf_content to anon,authenticated;
grant insert(kind,status,title,body,link_url,event_at),update(kind,status,title,body,link_url,event_at),delete on public.jf_content to authenticated;
create policy jf_content_public on public.jf_content for select to anon,authenticated using(status='published');
create policy jf_content_admin_read on public.jf_content for select to authenticated using((select public.jf_is_admin()));
create policy jf_content_admin_insert on public.jf_content for insert to authenticated with check((select public.jf_is_admin()));
create policy jf_content_admin_update on public.jf_content for update to authenticated using((select public.jf_is_admin())) with check((select public.jf_is_admin()));
create policy jf_content_admin_delete on public.jf_content for delete to authenticated using((select public.jf_is_admin()));
commit;
-- Assign the owner manually AFTER creating and verifying the account:
-- insert into public.jf_admins(user_id) values ('REPLACE_WITH_VERIFIED_OWNER_AUTH_UUID');
