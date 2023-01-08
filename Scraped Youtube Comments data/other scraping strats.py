# -*- coding: utf-8 -*-
"""
Created on Sun Dec 18 11:54:38 2022

@author: ipsas
"""

from selenium import webdriver
from selenium.webdriver.firefox.options import Options

options = Options()
options.binary_location = r'C:\Program Files\Mozilla Firefox\firefox.exe'
driver = webdriver.Firefox(options=options)
driver.get('http://google.com/')



# pip install selenium
# pip install beautifulsoup4
# pip install webdriver-manager
from selenium import webdriver
from webdriver_manager.firefox import GeckoDriverManager
from bs4 import BeautifulSoup
import time


def ScrapComment(url):
    option = webdriver.FirefoxOptions()
    option.add_argument("--headless")
    driver = webdriver.Firefox(executable_path=GeckoDriverManager().install(), options=option)
    driver.get(url)
    prev_h = 0
    while True:
        height = driver.execute_script("""
                function getActualHeight() {
                    return Math.max(
                        Math.max(document.body.scrollHeight, document.documentElement.scrollHeight),
                        Math.max(document.body.offsetHeight, document.documentElement.offsetHeight),
                        Math.max(document.body.clientHeight, document.documentElement.clientHeight)
                    );
                }
                return getActualHeight();
            """)
        driver.execute_script(f"window.scrollTo({prev_h},{prev_h + 200})")
        # fix the time sleep value according to your network connection
        time.sleep(1)
        prev_h +=200  
        if prev_h >= height:
            break
    soup = BeautifulSoup(driver.page_source, 'html.parser')
    driver.quit()
    title_text_div = soup.select_one('#container h1')
    title = title_text_div and title_text_div.text
    comment_div = soup.select("#content #content-text")
    comment_list = [x.text for x in comment_div]
    print(title, comment_list)


if __name__ == "__main__":

    urls = "https://youtu.be/1EwMAiqLUhM"
    
    ScrapComment(urls[0])
    
    
    
    
# 2


from selenium import webdriver
from selenium.common import exceptions
import sys
import time


# function scraping details fromyoutube


def scrape(url):
    
    driver = webdriver.Chrome('chromedriver.exe')
    
    driver.get(url)
    
    driver.maximize_window()
    
    time.sleep(5)
    

if __name__ == "__main__":
    scrape(sys.argv[0])
    
    
    
    # 3

import time

from selenium import webdriver
from selenium.webdriver.common.by import By

driver = webdriver.Chrome()
driver.get("https://youtu.be/1EwMAiqLUhM")
time.sleep(3)
el = driver.find_element(By.XPATH, "content-text")
el.click()
time.sleep(3)
driver.quit()


from selenium import webdriver
import requests
driver = webdriver.Chrome(executable_path="C:/Users/ipsas/Documents/Ronald Files/Python/Python Scripts/chromedriver.exe")
url = "https://youtu.be/1EwMAiqLUhM"
driver.get(url)

elements = driver.find_elements(By.CLASS_NAME, 'style-scope ytd-comment-renderer')

for el in elements:
    print(el.text)
    print('---------')