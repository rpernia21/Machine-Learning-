import csv
from urllib.request import Request, urlopen as uReq
from bs4 import BeautifulSoup

with open('new.csv') as file_obj:
    reader_obj = csv.reader(file_obj)

    for row in reader_obj:
        my_url = row[1]
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


