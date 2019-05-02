import urllib.request
import re
from collections import Counter
import matplotlib.pyplot as plt
import numpy as np
from operator import methodcaller
import math

input_name = input("Input Author: ")	# Ask user to input author's name

# Split the input name into several words and add "+" between them
name_cut = input_name.split()
author = name_cut[0]
for i in range(1, len(name_cut)):
	author += "+"+name_cut[i]

url = "https://arxiv.org/search/?query=" + author + "&searchtype=author"	# Compose the string of URL
content = urllib.request.urlopen(url)	# Access the website of search result of the author's name
html_str = content.read().decode('utf-8')	# Read HTML of the website and decode them in UTF-8

# Find parts of authors' names in search results  
pattern = "Authors:[\s\S]*?</p>"	
result = re.findall(pattern, html_str)

if(len(result)>0):	# Ensure there are some search results in the website
	# Get the total number of search results to know how many pages we should parse
	pattern = "title is-clearfix[\s\S]*?results"
	result = re.findall(pattern,html_str)
	temp = result[0].split("of")[1]
	total = float(re.findall("\d+",temp)[0])	# total number of search results
	pages = math.ceil(total/50)	# Compute pages
	start = 0	# page1
	co_author = []	# list for storing co-authors

	for i in range(pages):
		url = "https://arxiv.org/search/?query=" + author + "&searchtype=author&start=" + str(start)	# Composr the URL of the page
		content = urllib.request.urlopen(url)
		html_str = content.read().decode('utf-8')
		pattern = "Authors:[\s\S]*?</p>"	# Find the part of author's name in every search result
		result = re.findall(pattern, html_str)
		check = False
		temp_list = []	# temporary list for storing authors of every paper

		pattern = "a href=\"[\s\S]*?\">[\s\S]*?</a>"
		for r in result:
			# Get every author's name in each paper and check whether the input author is one of them
			name_result = re.findall(pattern,r)
			for n in name_result:
				name = n.split("\">")[1].split("</a>")[0].strip()	# Get name
				temp_list.append(name)	# Append into the temporary list of co-authors
				if(name.lower()==input_name.lower()):
					check = True	# Check whether the input author's name is really in the result
			# If the input author is actually one of the authors of the paper, then append all authors in temporary list into the list of co-authors;
			# if not, abort those names
			if(check==True):
				for t in temp_list:
					co_author.append(t)

			check = False	# Reset the boolean
			temp_list = []	# Clear the temporary list for next iteration

		start += 50	# Turn to next page
	 
	# Remove those names which are identical to input from co-author list, and the comparison is case-insensitive
	co_author = [x for x in co_author if x.lower()!=input_name.lower()]

	# Sort the list according to the alphabet
	co_list = sorted(co_author,key=methodcaller('casefold'))
	
	if(len(co_author)>0):	# If there are some co-authors in the final list
		co_name, times = zip(*Counter(co_list).items())	# Count times of each co-author, and then pack names and times into tuples
		for i in range(len(co_name)):	
			print("["+co_name[i]+"]:",times[i],"times")	# Print each co-author's name and the times that it appears
	else:	# Didn't find any co-author
		print("No co-author")

else:	# There is no search result on the website
	print("Sorry, your query for author produced no results.")
