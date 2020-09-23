/*
SQL Query that used to create web traffic by day
of categorized pageviews and events
with a 2 week lag to join to Covid data
*/

SELECT
  DATE_ADD(date, INTERVAL 14 DAY) date, --modified date to join to covid dataset
  SUM(pageviews) AS pageViews,
  SUM(doc_profile_pv) AS doc_profile_pv,
  SUM(req_app_successful_form_submit) AS req_app_successful_form_submit,
  SUM(covid_page) AS covid_page,
  SUM(FAD_general) AS fad_general,
  SUM(wait_time) AS wait_time,
  SUM(doc_care_loc) AS doc_care_loc,
  SUM(fad_req_app) AS fad_req_app,
  SUM(contact_link_click) AS contact_link_click,
  SUM(click_to_call) AS click_to_call,
  SUM(visitation_page) AS visitation_page,
  SUM(go_health_visit) AS go_health_visit,
  SUM(hospital_loc) AS hospital_loc,
  SUM(get_directions) AS get_directions,
  SUM(feinstein_visit) AS feinstein_visit,
  SUM(doc_care_loc_clinics) AS doc_care_loc_clinics
FROM (
  SELECT
    PARSE_DATE("%Y%m%d",
      date) date,
    (CASE
        WHEN type = 'PAGE' THEN 1
      ELSE
      0
    END
      ) AS pageviews,
    (CASE
        WHEN page.pagePath LIKE '/find-care/find-a-doctor%' AND page.pagePath NOT LIKE '%?%' AND h.type = 'PAGE' THEN 1
      ELSE
      0
    END
      ) AS doc_profile_pv,
    (CASE
        WHEN h.eventInfo.eventCategory = 'request an appointment'AND h.eventInfo.eventAction ='successful submission' AND type = 'EVENT' THEN 1
      ELSE
      0
    END
      ) AS req_app_successful_form_submit,
    (CASE
        WHEN (page.pagePath LIKE '%covid%' OR page.pagePath LIKE '%corona%') AND page.pagePath NOT LIKE '%employee%' AND h.type = 'PAGE' THEN 1
      ELSE
      0
    END
      ) AS covid_page,
    (CASE
        WHEN (page.pagePath LIKE '%covid%' OR page.pagePath LIKE '%corona%') AND page.pagePath NOT LIKE '%employee%' AND page.pagePath LIKE '%news%' AND h.type = 'PAGE' THEN 1
      ELSE
      0
    END
      ) AS covid_news_page,
    (CASE
        WHEN page.pagepath LIKE '/find-care/find-a-doctor%' AND type = 'PAGE' THEN 1
      ELSE
      0
    END
      ) AS fad_general,
    (CASE
        WHEN page.pagepath LIKE '/wait-times%' AND type = 'PAGE' THEN 1
      ELSE
      0
    END
      ) AS wait_time,
    (CASE
        WHEN page.pagepath LIKE '/doctors-and-care/locations%' AND type = 'PAGE' THEN 1
      ELSE
      0
    END
      ) AS doc_care_loc,
    (CASE
        WHEN page.pagepath LIKE '/doctors-and-care/locations?type=hospitals%' AND type = 'PAGE' THEN 1
      ELSE
      0
    END
      ) AS hospital_loc,
    (CASE
        WHEN page.pagepath LIKE '/doctors-and-care/locations?type=urgent-care-walk-in-clinics%' AND type = 'PAGE' THEN 1
      ELSE
      0
    END
      ) AS doc_care_loc_clinics,
    (CASE
        WHEN h.eventInfo.eventCategory = 'find a doctor' AND h.eventInfo.eventAction LIKE 'request an appointment' AND type = 'EVENT' THEN 1
      ELSE
      0
    END
      ) AS fad_req_app,
    (CASE
        WHEN h.eventInfo.eventCategory = 'contact link click' AND type = 'EVENT' THEN 1
      ELSE
      0
    END
      ) AS contact_link_click,
    (CASE
        WHEN h.eventInfo.eventCategory = 'click to call' AND type = 'EVENT' THEN 1
      ELSE
      0
    END
      ) AS click_to_call,
    (CASE
        WHEN h.type = 'EVENT' AND h.eventInfo.eventCategory = 'external link - non northwell.edu links' AND h.eventInfo.eventAction = "click on external link" AND h.eventInfo.eventLabel = "https://www.gohealthuc.com/nyc" THEN 1
      ELSE
      0
    END
      ) AS go_health_visit,
    (CASE
        WHEN page.pagepath LIKE '%visitation%' OR page.pagepath LIKE '%visitor%' AND type = 'PAGE' THEN 1
      ELSE
      0
    END
      ) AS visitation_page,
    (CASE
        WHEN h.eventInfo.EventCategory = 'get directions' AND type = 'EVENT' THEN 1
      ELSE
      0
    END
      ) AS get_directions,
    (CASE
        WHEN h.page.hostname = 'www.northwell.edu' AND (LEAD(h.page.hostname) OVER (PARTITION BY fullVisitorId, visitStartTime ORDER BY h.hitNumber)) = 'feinstein.northwell.edu' AND type = 'PAGE' THEN 1
      ELSE
      0
    END
      ) AS feinstein_visit
  FROM
    `northwell-health-ga-2019.189952954`.`ga_sessions_*`,
    UNNEST(hits) h
  WHERE
    _TABLE_SUFFIX BETWEEN '20200201' AND'
 FORMAT_DATE('%Y%m%d',DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))'
 )
GROUP BY
  date
ORDER BY
  date ASC