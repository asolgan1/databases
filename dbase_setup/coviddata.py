#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Apr  3 20:27:45 2021

@author: jamiehuang
"""

import csv


with open('owid-covid-data.csv', 'r', encoding = 'latin-1') as f:
    reader = csv.reader(f, delimiter=',')
    countries = []
    total_cases = []
    total_deaths = []
    dates = []
    next(reader)
    for row in reader:
        countries.append(row[2])
        dates.append(row[3][0: 7])
        total_cases.append(row[4])
        total_deaths.append(row[7])
    

total_cases_from_may = []
total_deaths_from_may = []
total_dates_from_may = []
countries_from_may = []
for i in range(len(dates)):
    if (dates[i] != '2020-01' and dates[i] != '2020-02' and dates[i] != '2020-03' and dates[i] != '2020-04' and dates[i] != '2021-04'):
        total_cases_from_may.append(total_cases[i])
        total_deaths_from_may.append(total_deaths[i])
        total_dates_from_may.append(dates[i])
        countries_from_may.append(countries[i])

        
total_dates_from_may_no_dup = []
countries_from_may_no_dup = []
for i in range(len(countries_from_may)-1):
    if (total_dates_from_may[i] != total_dates_from_may[i+1]):
        total_dates_from_may_no_dup.append(total_dates_from_may[i])
        countries_from_may_no_dup.append(countries_from_may[i])
    

monthly_cases = []
monthly_deaths = []
i = 0
while i < len(countries_from_may)-31:
    while (countries_from_may[i] == countries_from_may[i+1]) and (total_dates_from_may[i] == total_dates_from_may[i+1]):
        i += 1
    monthly_cases.append(total_cases_from_may[i])
    monthly_deaths.append(total_deaths_from_may[i])
    i += 1

file1 = open('coviddata.txt', "w")
for i in range(len(countries_from_may_no_dup)):
    file1.write(countries_from_may_no_dup[i])
    file1.write(", ")
    file1.write(total_dates_from_may_no_dup[i])
    file1.write(", ")
    file1.write(monthly_cases[i])
    file1.write(", ")
    file1.write(monthly_deaths[i])
    file1.write("\n")
    
file1.close()
