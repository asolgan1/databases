#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Apr  4 16:37:30 2021

@author: Alex
"""
import csv
from bs4 import BeautifulSoup
import requests
import get_countries


oecd_countries = []
public_hc = []

URL = 'https://www.oecd.org/about/members-and-partners/'
page = requests.get(URL)
soup = BeautifulSoup(page.content, 'html.parser')

results = soup.find_all('div', class_ = 'country-list__content')
for result in results:
    if result.find('a', class_="country-list__country") is not None:
        oecd_countries.append(result.find('a', class_="country-list__country").text)
    
oecd_countries = oecd_countries[:37]     

oecd_countries[len(oecd_countries)-1] = 'United States of America'
#print(oecd_countries)   


URL = 'https://en.wikipedia.org/wiki/List_of_countries_with_universal_health_care'
page = requests.get(URL)
soup = BeautifulSoup(page.content, 'html.parser')
    
results = soup.find_all('h3')

for result in results:
    if result.find('span', class_="mw-headline") is not None:
        public_hc.append(result.find('span', class_="mw-headline").text)
        
index = public_hc.index('Russia')
public_hc[index] = 'Russian Federation'
        

#print(public_hc)

with open('Country_migration.csv', 'r', encoding = 'latin-1') as f:
    reader = csv.reader(f, delimiter=',')
    countries = []
    migration_stock = []
    next(reader)
    for row in reader:
        countries.append(row[0])
        migration_stock.append(row[1])
        
for i in range(len(countries)):
    countries[i] = countries[i].strip()
    if countries[i][len(countries[i]) - 1] == '*':
        countries[i] = countries[i][:len(countries[i])-1]
        
  

file1 = open("country1.txt","w")

"""
file1.write('COUNTRY NAME')
for i in range(40 - len('Country name')):
        file1.write(' ')   
file1.write('MIGRATION STOCK %')  
for i in range(25 - len('MIGRATION STOCK %')):
        file1.write(' ')    
file1.write('STIMULUS %')  
for i in range(25 - len('STIMULUS %')):
        file1.write(' ') 
file1.write('OECD')   
for i in range(25 - len('OECD')):
        file1.write(' ') 
file1.write('PUBLIC HEALTHCARE')        
        
       
file1.write('\n')
"""

for i in range(len(countries)):
    file1.write(countries[i])
    file1.write(',')
    
    length = len(countries[i])
    for x in range(40 - length):
        file1.write(' ')   
        
    file1.write(migration_stock[i])  
    file1.write(',')
          
    if (countries[i] == 'Argentina'):
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ') 
        file1.write('6')
        file1.write(',')
        for x in range(24):
            file1.write(' ')
    elif (countries[i] == 'Australia'):
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ')  
        file1.write('19.05')
        file1.write(',')
        for x in range(20):
            file1.write(' ')
    elif (countries[i] == 'Brazil'):
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ')  
        file1.write('12')
        file1.write(',')
        for x in range(23):
            file1.write(' ')
    elif (countries[i] == "Canada"):
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ') 
        file1.write('18.55')
        file1.write(',')
        for x in range(20):
            file1.write(' ')
    elif (countries[i] == "China"):
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ') 
        file1.write('4.7') 
        file1.write(',')
        for x in range(22):
            file1.write(' ')
    elif (countries[i] == "France"):
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ') 
        file1.write('12.06') 
        file1.write(',')
        for x in range(20):
            file1.write(' ')
    elif (countries[i] == "Germany"):
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ') 
        file1.write('35.87')  
        file1.write(',')
        for x in range(20):
            file1.write(' ')
    elif (countries[i] == "India"):
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ') 
        file1.write('3.2') 
        file1.write(',')
        for x in range(22):
            file1.write(' ')
    elif (countries[i] == "Indonesia"):
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ') 
        file1.write('7.88')
        file1.write(',')
        for x in range(21):
            file1.write(' ')
    elif (countries[i] == "Italy"):
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ') 
        file1.write('28.49') 
        file1.write(',')
        for x in range(20):
            file1.write(' ')
    elif (countries[i] == "Japan"):
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ') 
        file1.write('54.53') 
        file1.write(',')
        for x in range(20):
            file1.write(' ')
    elif (countries[i] == "Mexico"):
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ') 
        file1.write('1.9')  
        file1.write(',')
        for x in range(22):
            file1.write(' ')
    elif (countries[i] == "Russian Federation"):
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ') 
        file1.write('4.5') 
        file1.write(',')
        for x in range(22):
            file1.write(' ')
    elif (countries[i] == "United Kingdom"):
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ') 
        file1.write('17.82') 
        file1.write(',')
        for x in range(20):
            file1.write(' ')
    elif (countries[i] == "Saudi Arabia"):
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ') 
        file1.write('2.8')   
        file1.write(',')
        for x in range(22):
            file1.write(' ')
    elif (countries[i] == "Turkey"):
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ') 
        file1.write('10.19')  
        file1.write(',')
        for x in range(20):
            file1.write(' ')
    elif (countries[i] == "United States of America"):
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ') 
        file1.write('26.45') 
        file1.write(',')
        for x in range(20):
            file1.write(' ')
    else:
        for x in range(25 - len(migration_stock[i])):
            file1.write(' ') 
        file1.write('0')    
        file1.write(',')
        for x in range(24):
            file1.write(' ') 
            
        
    if countries[i] in oecd_countries:
        file1.write('1')
        file1.write(',')
        for x in range(24):
            file1.write(' ')
    else:
        file1.write('0')
        file1.write(',')
        for x in range(24):
            file1.write(' ')
        
    if countries[i] in public_hc:   
        file1.write('1')
    else:
        file1.write('0') 
        
    file1.write('\n')
file1.close()   

    
file1 = open("country1.txt","r")    
countries = []
for x in file1:
    country = x.split(", ")[0]
    if country in get_countries.countries:
        countries.append(country)
file1.close()   
       
        
file1 = open("country1.txt","a")        
for country in get_countries.countries:    
    if country not in countries:
        # Countryname 
        file1.write(country);
        file1.write(', ');
        # Migration stock
        file1.write(', ');
        # Stimulus
        file1.write('0, ');
        # in_oecd
        file1.write('0, ');
        #Public healthcare dont need to put anything
        file1.write('\n');
 
file1.close()   
    
 


"""
gdp_growth = []
inflation = []
unemployment_rate = []
gov_net = []
i = 0;
while (i < len(econ_info)):
    gdp_growth.append(econ_info[i])
    inflation.append(econ_info[i+1])
    unemployment_rate.append(econ_info[i+2])
    gov_net.append(econ_info[i+3])
    i += 4
print(gdp_growth)
print(inflation)
print(unemployment_rate)
print(gov_net)
#print(gdp_growth)
"""
