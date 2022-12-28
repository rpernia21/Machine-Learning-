# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

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



#other codes: the correct one

import time
from selenium.webdriver import Chrome
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import pandas as pd 



data= []

youtube_video_url= "https://youtu.be/1EwMAiqLUhM"

 
#browser = webdriver.Chrome("C:/Users/User/Downloads/chromedriver.exe", chrome_options=options)
#C:\Users\ipsas\Documents\Ronald Files\Python\Python Scripts

with Chrome(executable_path=r'C:/Users/ipsas/Documents/Ronald Files/Python/Python Scripts/chromedriver.exe') as driver:
    wait = WebDriverWait(driver,15)
    driver.get(youtube_video_url)
    for item in range(200):
        wait.until(EC.visibility_of_element_located((By.TAG_NAME, "body"))).send_keys(Keys.END)
        time.sleep(15)
    for comment in wait.until(EC.presence_of_all_elements_located((By.CSS_SELECTOR, "#content"))):
        data.append(comment.text)


df = pd.DataFrame(data, columns=['comment'])

df.head()

print(df)



# saving
 df.to_csv('marcos_youtube_comments.csv', index=False)


#=====the end of the code - as of Dec 12#


#other coding

import pandas as pd
import re
import time
from bs4 import BeautifulSoup
import unicodecsv as csv

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys



# open chrome drive
options = webdriver.ChromeOptions()
#options.add_argument("headless") # headless option
options.add_argument("--start-maximized")
browser = webdriver.Chrome("C:/Users/ipsas/Documents/Ronald Files/Python/Python Scripts/chromedriver.exe", chrome_options=options)
time.sleep(10)



with open("Marcos.csv", "wb") as fa:
    my_writer1 = csv.DictWriter(fa, fieldnames=("title", "url"))
    my_writer1.writeheader()

    for i in range(1,11):
        link = "https://www.inquirer.net/search/?q=populism#gsc.tab=0&gsc.q=populism&gsc.sort=&gsc.page=" + str(i)
        print("*****", i, "*****")
        
        browser.get(link)
        time.sleep(5)
        
        page = browser.execute_script("return document.body.innerHTML")
        soup = BeautifulSoup(page, "lxml")
        
        articles = soup.find_all("div", {"class":"gsc-webResult gsc-result"})
        len(articles)
        
        for ar in articles:
            title = ar.find_all("div", {"class":"gs-title"})[0].text
            url = ar.find_all("div", {"class":"gs-title"})[0].find_all("a")[0].get("href")
            print(title)
            
            my_writer1.writerow({"title":title, "url":url})
    
