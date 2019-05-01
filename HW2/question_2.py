import urllib.request
import re
from collections import Counter
import matplotlib.pyplot as plt
import numpy as np
from operator import methodcaller
import math

input_name = input("Input Author: ")
name_cut = input_name.split()
author = name_cut[0]
for i in range(1, len(name_cut)):
	author += "+"+name_cut[i]

url = "https://arxiv.org/search/?query=" + author + "&searchtype=author"
content = urllib.request.urlopen(url)
html_str = content.read().decode('utf-8')
pattern = "Authors:[\s\S]*?</p>"
result = re.findall(pattern, html_str)

if(len(result)>0):
	pattern = "title is-clearfix[\s\S]*?results"
	result = re.findall(pattern,html_str)
	temp = result[0].split("of")[1]
	total = float(re.findall("\d+",temp)[0])
	pages = math.ceil(total/50)
	start = 0
	co_author = []
	for i in range(pages):
		url = "https://arxiv.org/search/?query=" + author + "&searchtype=author&start=" + str(start)
		content = urllib.request.urlopen(url)
		html_str = content.read().decode('utf-8')
		pattern = "Authors:[\s\S]*?</p>"
		result = re.findall(pattern, html_str)
		check = False
		temp_list = []
		pattern = "a href=\"[\s\S]*?\">[\s\S]*?</a>"
		for r in result:
			name_result = re.findall(pattern,r)
			for n in name_result:
				name = n.split("\">")[1].split("</a>")[0].strip()
				temp_list.append(name)
				if(name.lower()==input_name.lower()):
					check = True
			if(check==True):
				for t in temp_list:
					co_author.append(t)
			check = False
			temp_list = []
		start += 50
	
	co_author = [x for x in co_author if x.lower()!=input_name.lower()]
	co_list = sorted(co_author,key=methodcaller('casefold'))
	
	if(len(co_author)>0):
		co_name, times = zip(*Counter(co_list).items())
		for i in range(len(co_name)):
			print("["+co_name[i]+"]: ",times[i]," times")
	else:
		print("No co-author")

else:
	print("Sorry, your query for author produced no results.")
