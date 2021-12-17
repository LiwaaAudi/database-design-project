set session my.number_of_sessions = '200000';
set session my.number_of_page_views = '500000';
set session my.start_date = '2019-01-01 00:00:00';
set session my.end_date = '2021-12-01 00:00:00';

create extension pgcrypto;

insert into website_sessions(created_at, customer_id, utm_source, utm_campaign, channel, device_type)
    select
        to_timestamp(start_date, 'YYYY-MM-DD HH24:MI:SS') + random()* (to_timestamp(end_date, 'YYYY-MM-DD HH24:MI:SS')- TO_TIMESTAMP(start_date, 'YYYY-MM-DD HH24:MI:SS')) as created_at,
        floor(random() * ('10'::int) + 1)::int as customer_id,
        (array['google', 'bsearch', 'facebook'])[floor(random() * 3 +1)] as utm_source,
        (array['brand', 'nonbrand', 'organic'])[floor(random() * 3 +1)] as utm_campaign,
        (array['search', 'organic', 'paid'])[floor(random() * 3 +1)] as channel,
        (array['desktop', 'mobile'])[floor(random() * 2 +1)] as device_type
from generate_series(1, current_setting('my.number_of_sessions')::int)
	, current_setting('my.start_date') as start_date
	, current_setting('my.end_date') as end_date;


insert into website_pageviews(website_session_id, pageview_url)
    select
        floor(random() * (number_of_sessions::int) + 1)::int as website_session_id,
        (array['/products', '/categories', '/profile'])[floor(random() * 3 +1)] as pageview_url
from generate_series(1, current_setting('my.number_of_page_views')::int)
	, current_setting('my.number_of_sessions') as number_of_sessions;

UPDATE website_pageviews
SET
    created_at = website_sessions.created_at
FROM
    website_sessions
WHERE
    website_pageviews.website_session_id = website_sessions.website_session_id;