# -*- coding: utf-8 -*-
import pandas as pd
import re
import sys
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


#all links of news articles on a page
links = soup.find_all("div", {"class":"gsc-webResult gsc-result"}) #this is where all the articles in each page is embedded
print(len(links))


#start downloading
pagesToGet= 10

upperframe=[]  
for page in range(1,pagesToGet+1):
    print('processing page :', page)
    url = 'https://www.inquirer.net/search/?q=populism#gsc.tab=0&gsc.q=populism&gsc.sort=&gsc.page='+str(page)
    print(url)
    print(len(url))
    #an exception might be thrown, so the code should be in a try-except block
    try:
        #use the browser to get the url. This is suspicious command that might blow up.
        page=requests.get(url)                             # this might throw an exception if something goes wrong.
     
    except Exception as e:                                   # this describes what to do if an exception is thrown
        error_type, error_obj, error_info = sys.exc_info()      # get the exception information
        print ('ERROR FOR LINK:',url)                          #print the link that cause the problem
        print (error_type, 'Line:', error_info.tb_lineno)     #print error info and line that threw the exception
       # continue                                              #ignore this page. Abandon this and go back.
    time.sleep(2)   
    soup=BeautifulSoup(page.text,'html.parser')
    frame=[]
    links=soup.find_all('div', {'class':'gsc-webResult gsc-result'})
    print(len(links))
    
    
#writing to a file
filename="webScraped.csv"
    f=open(filename,"w", encoding = 'utf-8')
    headers="Contents,Link,Date, Source, Label\n"
    f.write(headers)
    
    for j in links:
        Title = j.find_all("div", attrs={"class":"gs-title"})[0].text
        Contents = j.find("div",attrs={'class':'m-statement__quote'}).text.strip()
        Link = "https://www.politifact.com"
        Link += j.find("div",attrs={'class':'m-statement__quote'}).find('a')['href'].strip()
        Date = j.find('div',attrs={'class':'m-statement__body'}).find('footer').text[-14:-1].strip()
        Source = j.find('div', attrs={'class':'m-statement__meta'}).find('a').text.strip()
        Label = j.find('div', attrs ={'class':'m-statement__content'}).find('img',attrs={'class':'c-image__original'}).get('alt').strip()
        frame.append((Title,Content,Link,Date,Source,Label))
        f.write(Content.replace(",","^")+","+Link+","+Date.replace(",","^")+","+Source.replace(",","^")+","+Label.replace(",","^")+"\n")
    upperframe.extend(frame)
f.close()
data=pd.DataFrame(upperframe, columns=['Statement','Link','Date','Source','Label'])
data.head(5)
 


# january 3 2023 version

with open("InquirerNet-2023version.csv", "wb") as fa:
    my_writer1 = csv.DictWriter(fa, fieldnames=("title", "url"))
    my_writer1.writeheader()

    for i in range(1,11):
        link = "https://www.inquirer.net/search/?q=populism#gsc.tab=0&gsc.q=populism&gsc.sort=&gsc.page=" + str(i)
        print("*****", i, "*****")
        
        browser.get(link)
        time.sleep(5)
        
        page = browser.execute_script("return document.body.innerHTML")
        soup = BeautifulSoup(page, "lxml")
        
        articles = soup.find_all("div", {"class":"gsc-webResult gsc-result"}) #this is where all the articles in each page is embedded
        len(articles)
        print(len(articles))
        
        for ar in articles:
            title = ar.find_all("div", {"class":"gs-title"})[0].text
            print(title)
            print(len(title))
            url = ar.find_all("div", {"class":"gs-title"})[0].find_all("a")[0].get("href")
            print(url)
            
        
            my_writer1.writerow({"title":title, "url":url})
    
#upload all the links and loop through it
df = pd.read_csv('InquirerNet-2023version.csv')
print(df, 5)
urls = df.loc[:,"url"] #only the url columns

for item in urls:
    title = item.find_all("div", attrs={"class":"gs-title"})[0].text
    

#writing to a file
filename="webScraped2.csv"
    f=open(filename,"w", encoding = 'utf-8')
    headers="Contents,Link,Date, Source, Label\n"
    f.write(headers)
    
    for j in links:
        Title = j.find_all("div", attrs={"class":"gs-title"})[0].text
        Contents = j.find("div",attrs={'class':'m-statement__quote'}).text.strip()
        Link = "https://www.politifact.com"
        Link += j.find("div",attrs={'class':'m-statement__quote'}).find('a')['href'].strip()
        Date = j.find('div',attrs={'class':'m-statement__body'}).find('footer').text[-14:-1].strip()
        Source = j.find('div', attrs={'class':'m-statement__meta'}).find('a').text.strip()
        Label = j.find('div', attrs ={'class':'m-statement__content'}).find('img',attrs={'class':'c-image__original'}).get('alt').strip()
        frame.append((Title,Content,Link,Date,Source,Label))
        f.write(Content.replace(",","^")+","+Link+","+Date.replace(",","^")+","+Source.replace(",","^")+","+Label.replace(",","^")+"\n")
    upperframe.extend(frame)
f.close()
data=pd.DataFrame(upperframe, columns=['Statement','Link','Date','Source','Label'])
data.head(5)


#from mons husband

import csv
from urllib.request import Request, urlopen as uReq
from bs4 import BeautifulSoup

with open('InquirerNet-2023version.csv') as file_obj:
    reader_obj = csv.reader(file_obj)

    for row in reader_obj:
        my_url = row[1]
        #print(len(my_url))
        req = Request(my_url, headers={'User-Agent': 'Mozilla/5.0'})
        uClient = uReq(req)
        parsed_html = BeautifulSoup(uClient.read())

        title = parsed_html.head.find('title')  # Article Title, needs cleanup
        author_date = parsed_html.body.find('div', attrs={'id': 'art_plat'}) # Author / Date, needs cleanup
        paragraphs = parsed_html.body.find('div', attrs={'id': 'article_content'}).find_all('p') # Get all htmls paragraphs, needs cleanup

        articles = ''  # Article
        for paragraph in paragraphs:
            """ Need to clean up the unneeded paragraphs (ads / unnecessary links) """
            is_text = len(paragraph.find_all('strong')) == 0
            if is_text:
                articles += f' {paragraph}'

        # TODO: Write these fields (title, author_date, articles) inside CSV

        time.sleep(5)



