import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

pd.set_option('display.max_columns', None)
student=pd.read_csv("C:/Users/Manjari Prasad/OneDrive/Desktop/student_data_analysis_project/global_student_digital_behavior_dataset.csv")

print(student.sample())

print(student.columns)

print(student.describe()) 

print(student.isnull().sum()) 

student.fillna({
    "brain_rot_level": 0.00,
     "field_of_study": "N.A"
     },inplace=True)

print(student.isnull().sum()) 

print(student["social_media_hours"].isnull().sum())

print(student.nunique())

print(student.duplicated())
print(student.duplicated().sum())

print(student[student["brain_rot_index"]>50][["digital_addiction_score", "brain_rot_index"]])   

sns.boxplot(x=student["social_media_hours"])
plt.title("Distribution of Social Media Usage")
plt.xlabel("Hours per Day")
plt.show() 

sns.boxplot(x="gender", y="social_media_hours", data=student)
plt.title("Social Media Usage by Gender")
plt.xlabel("Gender")
plt.xlabel("Hours per Day")
plt.show()  

#1.WHICH EDUCATION LEVEL STUDENTS ARE HOW MUCH SOCIALLY ACTIVE?
student["usage_category"]=np.where(student["social_media_hours"]<3, "Low",
                                       np.where(student["social_media_hours"]<=6, "Moderate",
                                                "High"))
print(student.groupby(["education_level"])["usage_category"].value_counts())
#OR
print(student.pivot_table(index="education_level", columns="usage_category", aggfunc="size"))  

#2.BRAIN ROT INDEX:
print(student[["student_id", "brain_rot_index"]].sort_values("brain_rot_index", ascending=False).head(10))   

#3.WHICH COUNTRY STUDENTS ARE AT HIGH RISK ACADEMICALLY?
student["academic_risk_category"]=np.where(student["academic_risk_score"]<=7, "Low",
                                           np.where(student["academic_risk_score"]<=13, "Moderate",
                                                    "High")) 
student["aca_high_risk_students"]=student["academic_risk_category"]=="High"
print(student.groupby("country")["aca_high_risk_students"].count().sort_values(ascending=False).head())

#4.WHAT % OF STUDENTS FALL INTO HIGH RISK CLUSTER?
print((student[student["academic_risk_category"]=="High"].shape[0]/student["academic_risk_category"].shape[0])*100) 

#5.WHICH COUNTRY NEEDS MORE INTERVENTION PROGRAM?
student["anxiety_score_category"]=np.where(student["anxiety_score"]<=7, "Normal",
                                         np.where(student["anxiety_score"]<=14 ,"Moderate",
                                                  "Severe"))
student["sleep_hours_category"]=np.where(student["sleep_hours"]<=5, "Low Sleep",
                                         np.where(student["sleep_hours"]<=8, "Good Sleep",
                                                  "High Sleep"))
student["depression_score_category"]=np.where(student["depression_score"]<=12, "Mild",
                                              np.where(student["depression_score"]>=20, "Moderate",
                                                       "Severe"))  
student["high_risk"]=(student["academic_risk_score"]>7) | (student["anxiety_score"]>4) | (student["depression_score"]>7) | (student["sleep_hours"]<7)
student["high_risk_students"]=student["high_risk"]==True
print(student.pivot_table(index="high_risk", columns= "country", aggfunc="size"))
print(student.groupby("country")["high_risk_students"].sum().sort_values(ascending=False).head(3)) 

#6.SOCIAL MEDIA VS ATTENTION SPAN:
print(student.groupby("usage_category")["attention_span_minutes"].mean())

#7.SOCIAL MEDIA VS STUDY HOURS:
student["study_hours"]=student["study_hours_per_week"]*4
print(student.groupby("usage_category")["study_hours"].mean())   

#8.SOCIAL MEDIA VS STRESS LEVEL:
print(student.groupby("usage_category")["stress_level"].mean())    

#9.WHICH FACTORS INCREASE ACADEMIC RISK THE MOST?
print(student.groupby("academic_risk_category").agg({
    "social_media_hours": "mean",
    "sleep_hours":"mean",
    "entertainment_content_hours":"mean"}).round(2)) 

print(student["academic_risk_category"].value_counts())  

#10.COUNTRY LEVEL BEHAVIOUR:
print(student.groupby("country")["usage_category"].value_counts().sort_values(ascending=False))
print(student.groupby("country")["sleep_hours_category"].value_counts().sort_values(ascending=False))        
print(student.groupby("country")["cyberbullying_exposure"].value_counts()) 
print(student.groupby("country")["class_attendance_rate"].median().sort_values(ascending=False)) 
print(student.groupby("country")["stress_level"].median().sort_values(ascending=False))   

#11.GROUP COMPARISON:
print(student.groupby("academic_risk_category")[["social_media_hours", "sleep_hours",]].mean().round(2))  

#12.STUDENTS RANKS IN SOCIAL MEDIA HOURS:
student["usage_rank"]=student["social_media_hours"].rank(ascending=False).sort_values(ascending=False)

#13.STUDENTS RANK IN SOCIAL MEDIA USAGE CATEGORY I.E WITHIN LOW/MODERATE/HIGH"
student["rank_within_risk"]=student.groupby("academic_risk_category")["social_media_hours"].rank(ascending=False)
print(student.head(2))     

#14.RELATIONSHIP OF ACADEMIC RISK SCORE WITH EVERY NUMERIC COLUMNS:
corr=student.corr(numeric_only=True)
print(corr["academic_risk_score"].sort_values(ascending=False))  

#14.RELATIONSHIP OF SOCIAL MEDIA HOURS WITH EVERY NUMERIC COLUMNS:
corr=student.corr(numeric_only=True)
print(corr["social_media_hours"].sort_values(ascending=False))          #social media hours has slightly negative impact on students overall academic performance

#15.OUTLIER DETECTION:
print(student["social_media_hours"].agg(["mean","median"]))        #since mean>median,right-skewed ie there are heavy users.

#16.CONSISTENCY:
print(student[["sleep_hours","social_media_hours"]].std())         #stable sleep hoursbehaviour and variable social media hours behaviour 

#17.DO HIGH RISK STUDENTS USE MORE SOCIAL MEDIA THAN LOW RISK STUDENTS?
print(student["social_media_hours"].isna().sum())
from scipy.stats import ttest_ind 
from scipy.stats import shapiro
stat, p= shapiro(student["social_media_hours"])
print("Statistic:" , stat)
print("p-value:" , p)                 
#OR                               
student["social_media_hours"].plot(kind='kde')
plt.show()                                                                 #since not normally distributed, neither Z-test nor T-test can be done
sns.boxplot(data=student, x="academic_risk_category", y="social_media_hours")      #so boxplot is used
plt.show()

#18.WHICH COUNTRY STUDENTS ARE THE MOST SINCERE?
student["stu"]=(student["academic_risk_category"]=='Low') & (student["usage_category"]=='Low')
student["sinc_stu"]=student["stu"]==True
print(student.groupby("country")["sinc_stu"].sum().sort_values(ascending=False).head(3))  

