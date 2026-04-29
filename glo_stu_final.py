import numpy as np
import pandas as pd

pd.set_option('display.max_columns', None)
student=pd.read_csv('C:/Users/Manjari Prasad/Downloads/archive/global_student_digital_behavior_dataset.csv')

student["usage_category"]=np.where(student["social_media_hours"]<3, "Low",
                                       np.where(student["social_media_hours"]<=6, "Moderate",
                                                "High"))

student["academic_risk_category"]=np.where(student["academic_risk_score"]<=7, "Low",
                                           np.where(student["academic_risk_score"]<=13, "Moderate",
                                                    "High"))

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

student.to_csv("C:/Users/Manjari Prasad/Downloads/archive/glo_stu_final.csv", index=False) 
print("successfull")