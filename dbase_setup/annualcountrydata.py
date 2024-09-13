#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Apr  4 22:14:32 2021

@author: Alex
"""

import csv

with open('WPP2019_TotalPopulationBySex.csv', 'r', encoding = 'latin-1') as f:
    reader = csv.reader(f, delimiter=',')
    countries = []
    loc_id = []
    population =[]
    pop_density = []
    year = []
    variant = []
    next(reader)
    for row in reader:
        loc_id.append(int(row[0]))
        countries.append(row[1])
        variant.append(row[3])
        year.append(int(row[4]))
        population.append(row[8])
        pop_density.append(row[9])
              
        
file1 = open("annualcountrydata.txt","w")        
        
for i in range(len(countries)):
    if loc_id[i] <= 894:
        if variant[i] == 'Medium':
            if year[i] == 2018 or year[i] == 2019 or year[i] == 2020:
                
                file1.write(countries[i])
                file1.write(',') 
                for x in range(35 - len(countries[i])):
                    file1.write(' ') 
                year[i] = str(year[i])    
                file1.write(year[i])
                
                file1.write(',') 
                for x in range(15):
                    file1.write(' ')
                file1.write(population[i])    
                file1.write(',') 
                for x in range(20 - len(population[i])):
                    file1.write(' ')
                file1.write(pop_density[i]) 
                file1.write('\n')
     
file1.close()        
        
    
    
    
