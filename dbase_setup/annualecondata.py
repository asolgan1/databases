#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Apr 3 19:54:05 2021

@author: jamiehuang
"""

import csv

with open('WEO_Data.csv', 'r', encoding = 'latin-1') as f:
    reader = csv.reader(f, delimiter=',')
    countries = []
    econ_info_2020 = []
    econ_info_2021 = []
    next(reader)
    for row in reader:
        countries.append(row[0])
        econ_info_2020.append(row[7])
        econ_info_2021.append(row[8])
        #gdp_growth.append(float(row[3]))

countries_no_dup = []

for i in range(len(countries)):
    if (i % 2 == 0):
        countries_no_dup.append(countries[i])

dates = []
for i in range(len(countries_no_dup)):
    if (i%2 == 0):
        dates.append('2020')
    else:
        dates.append('2021')

gdp_growth_2020 = []
inflation_2020 = []
unemployment_rate_2020 = []
gov_net_2020 = []

gdp_growth_2021 = []
inflation_2021 = []
unemployment_rate_2021 = []
gov_net_2021 = []
i = 0;
while (i < len(econ_info_2021)):
    gdp_growth_2020.append(econ_info_2020[i])
    inflation_2020.append(econ_info_2020[i+1])
    unemployment_rate_2020.append(econ_info_2020[i+2])
    gov_net_2020.append(econ_info_2020[i+3])
    
    gdp_growth_2021.append(econ_info_2021[i])
    inflation_2021.append(econ_info_2021[i+1])
    unemployment_rate_2021.append(econ_info_2021[i+2])
    gov_net_2021.append(econ_info_2021[i+3])
    i += 4
    
gdp_growth = []
inflation = []
unemployment_rate = []
gov_net = []

i = 0
while i < len(gdp_growth_2020):
    gdp_growth.append(gdp_growth_2020[i])
    gdp_growth.append(gdp_growth_2021[i])
    inflation.append(inflation_2020[i])
    inflation.append(inflation_2021[i])
    unemployment_rate.append(unemployment_rate_2020[i])
    unemployment_rate.append(unemployment_rate_2021[i])
    gov_net.append(gov_net_2020[i])
    gov_net.append(gov_net_2021[i])
    i += 1
    
for i in range(len(gdp_growth)):
    if (gdp_growth[i].find(',') != -1):
        gdp_growth[i] = gdp_growth[i].replace(',', '')
    if (inflation[i].find(',') != -1):
        inflation[i] = inflation[i].replace(',', '')
    if (unemployment_rate[i].find(',') != -1):
        unemployment_rate[i] = unemployment_rate[i].replace(',', '')
    if (gdp_growth[i].find(',') != -1):
        gov_net[i] = gov_net[i].replace(',', '')

#print(countries_no_dup)
#print(gdp_growth)
#print(inflation)
#print(unemployment_rate)
#print(gov_net)


file1 = open('annualecondata.txt', "w")
for i in range(len(countries_no_dup)):
    file1.write(countries_no_dup[i])
    file1.write(", ")
    file1.write(dates[i])
    file1.write(", ")
    file1.write(gdp_growth[i])
    file1.write(", ")
    file1.write(inflation[i])
    file1.write(", ")
    file1.write(unemployment_rate[i])
    file1.write(", ")
    file1.write(gov_net[i])
    file1.write("\n")
file1.close()
