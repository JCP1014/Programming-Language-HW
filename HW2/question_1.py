import urllib.request
import re
from collections import Counter
import matplotlib.pyplot as plt
import numpy as np
import math

input_name = input("Input Author: ")	# Ask user to input author's name

# Split the input name into several words and add "+" between them
name_cut = input_name.split()	
author = name_cut[0]
for i in range(1, len(name_cut)):
	author += "+"+name_cut[i]

url = "https://arxiv.org/search/?query=" + author + "&searchtype=author"	# Compose the string of URL
content = urllib.request.urlopen(url)	# Access the website of search result of the author's name'
html_str = content.read().decode('utf-8')	# Read HTML of the website and decode them in UTF8

pattern = "originally announced[\s\S]*?</p>"
result = re.findall(pattern, html_str)

if(len(result)>0):	# Ensure there are some results in the website
	# Get the total number of search results to know how many pages we should parse 
	pattern = "title is-clearfix[\s\S]*?results"
	result = re.findall(pattern,html_str)
	temp = result[0].split("of")[1]
	total = float(re.findall("\d+",temp)[0])	# total number of search results
	pages = math.ceil(total/50)	# Compute pages
	start = 0	# page1
	all_year = []	# list for storing years when those paper was announced

	for i in range(pages):
		url = "https://arxiv.org/search/?query=" + author + "&searchtype=author&start=" + str(start)	# Compose the URL of the page
		content = urllib.request.urlopen(url)
		html_str = content.read().decode('utf-8')
		pattern = "Authors:[\s\S]*?originally announced[\s\S]*?</p>"	# Find the part of authors' names in every search result
		result = re.findall(pattern, html_str)
		check = False

		for r in result:
			# Get every author's name of each paper and check the input author is one of them
			pattern = "a href=\"[\s\S]*?\">[\s\S]*?</a>"	
			name_result = re.findall(pattern,r)
			for n in name_result:
				name = n.split("\">")[1].split("</a>")[0].strip()	# Get the name
				if(name.lower()==input_name.lower()):	 
					check = True	# Check whether the input author is really in the results

			# If the input author is one of authors of the paper, then get the year when it is announced
			if(check==True):
				pattern = "originally announced[\s\S]*?</p>"
				announce = re.findall(pattern,r)
				pattern = "\d+"	# Get the number pattern
				for a in announce:
					year = int(re.findall(pattern,a)[0])
					all_year.append(year)	# Append the year into list
			check = False	# Reset the boolean

		start += 50	# Turn to next page
		
	# Plot bar graph
	if(len(all_year)>0):
		label, value = zip(*Counter(all_year).items())	# Count years and then pack years and counts into tuples
		plt.yticks(np.arange(min(value),max(value)+1))	# Set graduation of y-axis
		plt.bar(label,value)
		plt.show()

else:	# There is no result of searching the input author's name
	print("Sorry, your query for author produced no results.")
