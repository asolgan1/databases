#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr  5 21:43:50 2021

@author: Alex
"""

countries = []

file1 = open("annualcountrydata.txt","r")
for x in file1:
    country = x.split(", ")[0]
    if country not in countries:
        countries.append(country)
        
file1.close() 
     

file1 = open("country.txt","r")
for x in file1:
    country = x.split(", ")[0]
    if country not in countries:
        countries.append(country)
        
file1.close()  


file1 = open("coviddata.txt","r")
for x in file1:
    country = x.split(", ")[0]
    if country not in countries:
        countries.append(country)
        
file1.close()  

file1 = open("vaccination.txt","r")
for x in file1:
    country = x.split(", ")[0]
    if country not in countries:
        countries.append(country)
        
file1.close()


file1 = open("annualecondata.txt","r")
for x in file1:
    country = x.split(", ")[0]
    if country not in countries:
        countries.append(country)
        
file1.close()  

file1 = open("countries_list.txt","w")
for x in countries:
    file1.write(x)
    file1.write('\n')
file1.close()
print(countries)        
        
        
 
        
    
