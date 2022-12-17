# -*- coding: utf-8 -*-
import pandas as pd
import re
import time
from bs4 import BeautifulSoup
# import unicodecsv as csv
import csv

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys


# open chrome drive
options = webdriver.ChromeOptions()
#options.add_argument("headless") # headless option
options.add_argument("--start-maximized")
browser = webdriver.Chrome("C:/Users/User/Downloads/chromedriver.exe", chrome_options=options)
time.sleep(10)


with open('new.csv') as file_obj:
    reader_obj = csv.reader(file_obj)
      
    for row in reader_obj:
        print(row)

with open("Article3.csv", "wb") as fa:
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
            text = ar.find_all()
            
            my_writer1.writerow({"title":title, "url":url})
    
    
# upload the csv file

df = pd.read_csv('Article3.csv')
print(df)

df.head()
df.iloc[0]
df.iloc[1]

df.columns

import http.client


Example using urlib and lxml.html:

import urllib
from lxml import html

req_url = urllib.request.urlopen("https://newsinfo.inquirer.net/730378/clinton-sanders-set-for-first-democratic-presidential-debate")
print(req_url.read())

from urllib.request import Request,urlopen as uReq
my_url = 'https://newsinfo.inquirer.net/730378/clinton-sanders-set-for-first-democratic-presidential-debate'
req=Request(my_url,headers={'User-Agent': 'Mozilla/5.0'})
uClient = uReq(req)
parsed_html = BeautifulSoup(uClient.read())
# print(parsed_html.body.find('div', attrs={'class':'container'}).text)
print(parsed_html.head.find('title')) # Article Title
print(parsed_html.body.find('div', attrs={'id': 'art_plat'})) # Author / Date
paragraphs = parsed_html.body.find('div', attrs={'id': 'article_content'}).find_all('p')

articles = '' # article
for paragraph in paragraphs:
    is_text = len(paragraph.find_all('strong')) == 0
    if is_text:
        articles += f' {paragraph}'

print(articles)