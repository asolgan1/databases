#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Apr  3 20:36:52 2021

@author: jamiehuang
"""

import csv 

with open('country_vaccinations.csv', 'r', encoding = 'latin-1') as f:
    reader = csv.reader(f, delimiter=',')
    countries = []
    vax_total_string = []
    vax_daily_string = []
    next(reader)
    for row in reader:
        countries.append(row[0])
        vax_total_string.append(row[3])
        vax_daily_string.append(row[7])
        #gdp_growth.append(float(row[3]))
countries_no_dup = []
for i in countries:
    if i not in countries_no_dup:
        countries_no_dup.append(i)

vax_daily = []
for i in range(len(vax_daily_string)):
    if (vax_daily_string[i] != ''):
        vax_daily.append(float(vax_daily_string[i]))
    else:
        vax_daily.append(0)

vax_total = []
for i in range(len(vax_total_string)):
    if (vax_total_string[i] != ''):
        vax_total.append(float(vax_total_string[i]))
    else:
        vax_total.append(0)

#print(vax_daily)

total_vaccinations = []
array_daily_vacc = []
i = 0
while i < len(countries)-44:
    sum_vax_country = []
    while countries[i] == countries[i+1]:
        sum_vax_country.append(vax_daily[i])
        i += 1
    total_vaccinations.append(vax_total[i])
    if (len(sum_vax_country) == 0):
        array_daily_vacc.append(0)
    else:
        array_daily_vacc.append(sum(sum_vax_country)/len(sum_vax_country))
    i += 1
total_vaccinations.append(124753.0)
array_daily_vacc.append(2162.1)

for i in range(len(total_vaccinations)):
    total_vaccinations[i] = str(total_vaccinations[i])
    array_daily_vacc[i] = str(array_daily_vacc[i])

file1 = open('vaccination.txt', "w")
for i in range(len(countries_no_dup)):
    file1.write(countries_no_dup[i])
    file1.write(", ")
    file1.write(total_vaccinations[i])
    file1.write(",")
    file1.write(array_daily_vacc[i])
    file1.write("\n")
file1.close()
