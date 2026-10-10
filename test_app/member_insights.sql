create table public.member_notifications (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 submission_id uuid references public.submissions(id) on delete cascade,
 kind text not null check(kind in ('welcome','approved','rejected')),
 title text not null, body text not null,
 created_at timestamptz not null default now(), read_at timestamptz
);
create unique index member_notifications_welcome on public.member_notifications(user_id) where kind='welcome';
create unique index member_notifications_outcome on public.member_notifications(submission_id,kind) where submission_id is not null;
create index member_notifications_inbox on public.member_notifications(user_id,created_at desc);
alter table public.member_notifications enable row level security;
revoke all on public.member_notifications from anon,authenticated;
grant select on public.member_notifications to authenticated;
grant update(read_at) on public.member_notifications to authenticated;
create policy own_notifications_read on public.member_notifications for select to authenticated using(user_id=(select auth.uid()));
create policy own_notifications_mark_read on public.member_notifications for update to authenticated using(user_id=(select auth.uid())) with check(user_id=(select auth.uid()));
create function private.member_welcome_notification() returns trigger language plpgsql security definer set search_path='' as $$
begin
 insert into public.member_notifications(user_id,kind,title,body,created_at) values(new.id,'welcome','Your member account is ready','Welcome to Christmas Ideas NZ! You can save boards, recommend lights and submit Christmas finds. Submission outcomes appear here.',new.created_at) on conflict do nothing;
 return new;
end; $$;
revoke all on function private.member_welcome_notification() from public,anon,authenticated;
create trigger member_welcome_notification after insert on public.profiles for each row execute function private.member_welcome_notification();
create function private.member_submission_notification() returns trigger language plpgsql security definer set search_path='' as $$
begin
 if new.status in ('approved','rejected') and new.status is distinct from old.status then
 insert into public.member_notifications(user_id,submission_id,kind,title,body)
 values(new.user_id,new.id,new.status,case when new.status='approved' then 'Your find was approved' else 'Your find was declined' end,
 case when new.status='approved' then '“'||new.title||'” has been approved and published. Thank you for sharing it!' else '“'||new.title||'” was reviewed and will not be published. You can contact us if you have questions.' end) on conflict do nothing;
 end if; return new;
end; $$;
revoke all on function private.member_submission_notification() from public,anon,authenticated;
create trigger member_submission_notification after update of status on public.submissions for each row execute function private.member_submission_notification();
insert into public.member_notifications(user_id,kind,title,body,created_at)
 select id,'welcome','Your member account is ready','Welcome to Christmas Ideas NZ! You can save boards, recommend lights and submit Christmas finds. Submission outcomes appear here.',created_at from public.profiles on conflict do nothing;
insert into public.member_notifications(user_id,submission_id,kind,title,body,created_at)
 select user_id,id,status,case when status='approved' then 'Your find was approved' else 'Your find was declined' end,
 case when status='approved' then '“'||title||'” has been approved and published. Thank you for sharing it!' else '“'||title||'” was reviewed and will not be published. You can contact us if you have questions.' end,coalesce(reviewed_at,created_at)
 from public.submissions where status in ('approved','rejected') on conflict do nothing;
create table public.member_visit_days (
 user_id uuid not null references auth.users(id) on delete cascade,
 visit_day date not null, sessions integer not null default 0 check(sessions>=0),
 last_seen_at timestamptz not null default now(), primary key(user_id,visit_day)
);
alter table public.member_visit_days enable row level security;
revoke all on public.member_visit_days from public,anon,authenticated;
create function public.record_member_visit() returns void language plpgsql security definer set search_path='' as $$
declare u uuid=auth.uid(); previous timestamptz; today date=(now() at time zone 'Pacific/Auckland')::date;
begin
 if u is null then raise exception 'Sign in required' using errcode='42501'; end if;
 perform pg_advisory_xact_lock(hashtextextended(u::text,0));
 select max(last_seen_at) into previous from public.member_visit_days where user_id=u;
 insert into public.member_visit_days(user_id,visit_day,sessions,last_seen_at)
 values(u,today,case when previous is null or previous<now()-interval '30 minutes' then 1 else 0 end,now())
 on conflict(user_id,visit_day) do update set sessions=public.member_visit_days.sessions+excluded.sessions,last_seen_at=excluded.last_seen_at;
end; $$;
revoke all on function public.record_member_visit() from public,anon;
grant execute on function public.record_member_visit() to authenticated;
create function public.member_usage_statistics() returns jsonb language plpgsql security definer set search_path='' as $$
declare today date=(now() at time zone 'Pacific/Auckland')::date; result jsonb;
begin
 if auth.uid() is null or not private.is_admin() then raise exception 'Admin access required' using errcode='42501'; end if;
 with members as (select u.id,u.created_at from auth.users u left join public.profiles p on p.id=u.id where coalesce(p.role,'member') not in ('admin','editor')),
 usage as (select d.* from public.member_visit_days d join members m on m.id=d.user_id),
 per_member as (select user_id,count(*) days from usage where visit_day>=today-29 group by user_id)
 select jsonb_build_object(
 'Accounts',(select count(*) from auth.users),
 'Admins / editors',(select count(*) from public.profiles where role in ('admin','editor')),
 'Members',(select count(*) from members),
 'New members today',(select count(*) from members where (created_at at time zone 'Pacific/Auckland')::date=today),
 'New members (7 days)',(select count(*) from members where (created_at at time zone 'Pacific/Auckland')::date>=today-6),
 'Active members today',(select count(distinct user_id) from usage where visit_day=today),
 'Active members (7 days)',(select count(distinct user_id) from usage where visit_day>=today-6),
 'Active members (30 days)',(select count(distinct user_id) from usage where visit_day>=today-29),
 'Returning members (30 days)',(select count(*) from per_member where days>=2),
 'Visits (30 days)',(select coalesce(sum(sessions),0) from usage where visit_day>=today-29),
 'Average active days (30 days)',(select coalesce(round(avg(days),1),0) from per_member),
 'Member boards',(select count(*) from public.boards b join members m on m.id=b.user_id),
 'Member saved items',(select count(*) from public.board_items i join public.boards b on b.id=i.board_id join members m on m.id=b.user_id),
 'Member submissions',(select count(*) from public.submissions s join members m on m.id=s.user_id),
 'Daily activity',coalesce((select jsonb_agg(jsonb_build_object('day',activity_date,'active_members',active,'visits',visits) order by activity_date desc) from (select visit_day as activity_date,count(*) active,sum(sessions) visits from usage where visit_day>=today-29 group by visit_day) x),'[]'::jsonb),
 'Tracking started',(select min(visit_day) from public.member_visit_days)
 ) into result; return result;
end; $$;
revoke all on function public.member_usage_statistics() from public,anon;
grant execute on function public.member_usage_statistics() to authenticated;
