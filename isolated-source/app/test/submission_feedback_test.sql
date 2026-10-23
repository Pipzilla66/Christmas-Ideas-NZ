-- Run against a development copy: all synthetic records are rolled back.
begin;
create temporary table feedback_test_ids as select
 gen_random_uuid() id,
 (select id from public.profiles where role='admin' limit 1) admin,
 (select id from public.profiles where role='user' limit 1) member;
grant select on feedback_test_ids to authenticated;
insert into public.submissions(id,user_id,submission_type,title,description)
 select id,member,'idea','Feedback rollback test','Synthetic test' from feedback_test_ids;
select set_config('request.jwt.claim.sub',(select member::text from feedback_test_ids),true);
set local role authenticated;
do $$ begin
 begin
  perform public.review_christmas_submission_with_feedback((select id from feedback_test_ids),false,'No');
  raise exception 'Member unexpectedly permitted';
 exception when insufficient_privilege then null;
 end;
end $$;
reset role;
select set_config('request.jwt.claim.sub',(select admin::text from feedback_test_ids),true);
set local role authenticated;
select public.review_christmas_submission_with_feedback((select id from feedback_test_ids),false,'  Please add the date and location.  ');
reset role;
do $$ begin
 if not exists(select 1 from public.member_notifications n join feedback_test_ids t on n.submission_id=t.id
   where n.user_id=t.member and n.body like E'%Feedback from Christmas Ideas NZ:\nPlease add the date and location.')
 then raise exception 'Feedback notification missing'; end if;
end $$;
select set_config('request.jwt.claim.sub',(select id::text from public.profiles where role='user' and id<>(select member from feedback_test_ids) limit 1),true);
set local role authenticated;
do $$ begin
 if exists(select 1 from public.member_notifications where submission_id=(select id from feedback_test_ids))
 then raise exception 'Feedback leaked to another member'; end if;
end $$;
reset role;
rollback;
