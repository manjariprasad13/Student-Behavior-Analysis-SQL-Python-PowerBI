create database student_db;

use student_db;

create table student(
student_id int primary key,
country	varchar(50), 
development_level varchar(50),
poverty_rate_percent float,	
internet_infrastructure_index float,	
average_internet_speed_mbps float,
age int,
gender varchar(50),
urban_rural varchar(50),
family_income_level varchar(50),
device_access varchar(50),
internet_access_hours float,
education_level varchar(50),
field_of_study varchar(50),
academic_motivation float,
online_learning_hours float,
social_media_hours float,
sessions_per_day float,
average_session_length_minutes float,
late_night_usage varchar(50),
education_content_hours float,
short_video_hours float,
entertainment_content_hours float,
news_content_hours float,
likes_given_per_day float,
comments_written_per_day float,
posts_created_per_week float,
late_night_score int, 
brain_rot_index	float,
brain_rot_level varchar(50),
attention_span_minutes float,
study_hours_per_week float,
class_attendance_rate float,
productivity_score float,
sleep_hours float,
stress_level float,
anxiety_score float,
depression_score float,
ads_viewed_per_day float,
ads_clicked_per_week float,
impulse_purchase_score float,
digital_spending_per_month float,
cyberbullying_exposure varchar(50),
adult_content_exposure varchar(50), 
digital_addiction_score float,
wellbeing_index float,
academic_risk_score int,
financial_risk_score float);

#ENABLE FILE IMPORT:
SET GLOBAL local_infile = 1;
LOAD DATA LOCAL INFILE 'C:\Users\Manjari Prasad\OneDrive\Desktop\student_data_analysis_project\global_student_digital_behavior_dataset.csv'
INTO table student
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from student limit 20;
show columns from student;

#1.TOTAL DEVELOPED COUNTRIES:
select development_level, urban_rural , count( distinct country) as number_of_countries 
from student
group by development_level, urban_rural;

#2.WHICH COUNTRIES ARE DEVELOPED:
select distinct(country), development_level,urban_rural
from student
where development_level='Developed';
 
#3.AVG INTERNET SPEED VS COUNTRY:
select distinct country, average_internet_speed_mbps
from student
order by country;

#4.SPEED CATEGORISATION:
select distinct country , case
when average_internet_speed_mbps<50 then 'Low Speed' 
when average_internet_speed_mbps>100 then 'High Speed'
else 'Medium Speed' 
end as internet_speed_catgerozation
from student
order by internet_speed_catgerozation;

#5.AVERAGE INTERNET ACCESS BY SOCIAL MEDIA USAGE:
select internet_access_hours
from student;

#6.INTERNET ACCESS HOURS VS SOCIAL MEDIA HOURS:
select round(avg(internet_access_hours),2) as avg_int_acc_hrs, avg_social_media_usage, 
case when avg(internet_access_hours)<3 then 'Low Access'
when avg(internet_access_hours) between 3 and 6  then 'Moderate Access'
else 'High Access'
end as internet_access_category from
(select internet_access_hours, 
case when social_media_hours<3 then 'Low Social Media'                 
when social_media_hours between 3 and 6  then 'Low Social Media' 
else 'High Social Media' 
end as avg_social_media_usage
from student) as t 
group by  avg_social_media_usage;

#7.GENDER DISTRIBUTION ACROSS EDUCATION LEVEL AND FIELD OF STUDY:
select distinct education_level,  field_of_study,                                   
count(case when gender= 'Female' then 1 end) over(partition by education_level, field_of_study) as total_females_per_grp,
count(case when gender='Male' then 1 end) over(partition by education_level, field_of_study) as total_males_per_grp,
round(count(case when gender= 'Female' then 1 end) over(partition by education_level, field_of_study)*100/count(*) over(partition by education_level, field_of_study),2) as female_percentage,
round(count(case when gender= 'Male' then 1 end) over(partition by education_level, field_of_study)*100/count(*) over(partition by education_level, field_of_study),2) as male_percentage
from student;

#8.WHICH FIELD HAS HIGHEST MOTIVATION?
select field_of_study,  round(avg(academic_motivation),2) as Average_motivation
from student 
where field_of_study<> 'None'
group by field_of_study
order by Average_motivation desc;

#9.WHICH FIELD HAS HIGHEST SOCIAL MEDIA HOURS AND ACCORDINGLY ACADEMIC RISK?
select field_of_study, round(avg(social_media_hours),2) as average_time_spent_on_socials, round(avg(academic_risk_score),2) as avg_academic_risk, round(avg(class_attendance_rate),2) as avg_attendance_rate
from student
where field_of_study<>'None'
group by field_of_study
order by average_time_spent_on_socials desc
limit 1;

#10.SLEEP VS INTERNET:
select round(avg(sleep_hours),2) as Average_sleep_hours, round(avg(internet_access_hours),2) as Average_internet_access_hours,
round(avg(sleep_hours)/(avg(sleep_hours)+avg(internet_access_hours))*100,2) as Sleep_percentage,
round(avg(internet_access_hours)/(avg(sleep_hours)+avg(internet_access_hours))*100,2) as Internet_percentage
from student;

#11.PRODUCTIVITY IMPACT:
select case when internet_access_hours<4 then 'Low' 
when internet_access_hours between 4 and 7 then 'Medium' 
else 'High' end as Social_Media_Usage, 
round(avg(productivity_score),2) as Average_productivity
from student
group by Social_Media_Usage;

#12.MENTAL HEALTH ANALYSIS:
select case when internet_access_hours<4 then 'Low' 
when internet_access_hours between 4 and 7 then 'Medium' 
else 'High'
end as Social_Media_Usage,
round(avg(anxiety_score),2) as Average_anxiety_score , round(avg(depression_score),2) as Average_depression_score
from student
group by Social_Media_Usage
order by Average_anxiety_score, Average_depression_score;

#13.TOP AND BOTTOM PERFORMERS:
select * from(
select student_id, internet_access_hours, productivity_score ,
case when internet_access_hours<4 then 'Low' 
when internet_access_hours between 4 and 7 then 'Medium' 
else 'High'
end as Social_media_usage_category, 
'Top Performer' as performance 
from student
order by productivity_score desc
limit 5) t1
union 
select * from (
select student_id, internet_access_hours, productivity_score ,
case when internet_access_hours<4 then 'Low' 
when internet_access_hours between 4 and 7 then 'Medium' 
else 'High'
end as Social_media_usage_category, 
'Bottom Performer' as performance 
from student
order by productivity_score asc
limit 5) t2;

#14.CYBERBULLYING PATTERNS:
select country, development_level, count(cyberbullying_exposure) as Cyberbullying_pattern
from student
group by country,development_level
order by country;

#15.URBAN AND RURAL ANALYSIS:
select urban_rural,
case when social_media_hours<3 then 'Low'
when social_media_hours between 3 and 6 then 'Medium'
else 'High'
end as social_media_usage , 
round(avg(anxiety_score),2) as Average_anxiety_score , round(avg(depression_score),2) Average_depression_score 
from student
group by urban_rural, social_media_usage
order by urban_rural, social_media_usage;

#16.FIELD OF STUDY ANALYSIS:
select field_of_study, round(avg(academic_motivation), 2) as Average_ac_motivation
from student
where field_of_study <> 'None'
group by field_of_study
order by field_of_study desc;

#17.ATTENDANCE VS INTERNET USAGE:
select 
case when digital_addiction_score<15 then 'Low score'
when digital_addiction_score between 15 and 20 then 'Medium score'
else 'High score'
end as digital_addiction_category
, round(avg(class_attendance_rate),2) as Average_attendance_rate
from student
group by digital_addiction_category
order by Average_attendance_rate;

#18.ENGAGEMENT ANALYSIS:
select
case when(likes_given_per_day+comments_written_per_day+ads_viewed_per_day)<10 then 'Less Engagement'
when (likes_given_per_day+comments_written_per_day+ads_viewed_per_day) between 10 and 15 then 'Moderate Engagement'
else 'High Engagement'
end as engagement_level,
round(avg(productivity_score),2) as average_productivity
from student
group by engagement_level
order by average_productivity asc;

#19.RISK GROUP IDENTIFICATION:
select round(avg(hours_spent),2) as avg_hours_spent, stress_level_category  from
(select round((sleep_hours+social_media_hours),2) as hours_spent, 
case when stress_level between 3.8 and 5.8 then 'Normal'
else 'Abnormal'
end as stress_level_category
from student) as t
group by stress_level_category
order by avg_hours_spent desc; 

#20.RANKING WITHIN GROUPS:
select *, count(t.student_id) over(partition by t.social_media_usage) as total_students from
(select student_id, case when social_media_hours<3 then 'Low'
when social_media_hours between 3 and 6 then 'Medium'
else 'High'
end as social_media_usage
from student) as t;

#21.ABOVE/BELOW AVERAGE STUDENTS:
select student_id, productivity_score, avg(productivity_score) over () as overall_avg,
case when productivity_score>avg(productivity_score) over () then 'Above Average'
when productivity_score<avg(productivity_score) over () then 'Below Average'
else 'Equal to Average'
end as perforamnce_category
from student;

#22.TARGET VS ACTUAL KPI:
select count(student_id) as total_students ,case when social_media_hours<3 then 'Less than 3 hours'
else 'Higher than 3 hours'
end as target_social_hours_usage
from student
group by target_social_hours_usage;
 
 select * from student limit 20;

#23.CORRELATION-TYPE INSIGHT:
select case when social_media_hours<3 then 'Low'
when social_media_hours between 3 and 6 then 'Medium'
else 'High'
end as social_media_usage, 
case when(likes_given_per_day+comments_written_per_day+ads_viewed_per_day)<10 then 'Less Engagement'
when (likes_given_per_day+comments_written_per_day+ads_viewed_per_day) between 10 and 15 then 'Moderate Engagement'
else 'High Engagement'
end as engagement_level,
case when sleep_hours<4 then 'Low Sleep'
when sleep_hours between 4 and 7 then 'Moderate Sleep' 
when sleep_hours=8 then 'Normal Sleep'
else 'High Sleep'
end as sleep_hours_category,
round(avg(productivity_score),2) as avg_prod_score
from student
group by social_media_usage, engagement_level, sleep_hours_category
order by social_media_usage,engagement_level,sleep_hours_category;









