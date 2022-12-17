# -*- coding: utf-8 -*-
"""
Created on Sat Dec 17 21:49:47 2022

@author: 路奈爾
"""


import youtube_comment_scraper_python
import requests
import bot_studio


from youtube_comment_scraper_python import *
import pandas as pd
import time

url=input("Enter the video URL=")
file=input("Enter the Output file name=")

youtube.open(url)
fullcomments=[]
for i in range(0,1):
    result=youtube.video_comments()
    data=result['body']
    fullcomments.extend(data)
    
dataframe=pd.DataFrame(fullcomments)
print(dataframe)
time.sleep(5)
dataframe.to_csv(file)


link = "https://youtu.be/1EwMAiqLUhM"

#use the share link button, not the 



"
other codes

import time
from selenium.webdriver import Chrome
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


data= []

youtube_video_url= "https://youtu.be/1EwMAiqLUhM"

 
#browser = webdriver.Chrome("C:/Users/User/Downloads/chromedriver.exe", chrome_options=options)


with Chrome(executable_path=r'C:/Users/User/Downloads/chromedriver_win32_latest/chromedriver.exe') as driver:
    wait = WebDriverWait(driver,15)
    driver.get(youtube_video_url)
    for item in range(200):
        wait.until(EC.visibility_of_element_located((By.TAG_NAME, "body"))).send_keys(Keys.END)
        time.sleep(15)
    for comment in wait.until(EC.presence_of_all_elements_located((By.CSS_SELECTOR, "#content"))):
        data.append(comment.text)


import pandas as pd 

df = pd.DataFrame(data, columns=['comment'])

df.head()

