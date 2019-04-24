import urllib.request
import re
from collections import Counter
import matplotlib.pyplot as plt
import numpy as np
import math

input_name = input("Input Author: ")
name_cut = input_name.split()
author = name_cut[0]
for i in range(1, len(name_cut)):
	author += "+"+name_cut[i]

url = "https://arxiv.org/search/?query=" + author + "&searchtype=author"
content = urllib.request.urlopen(url)
html_str = content.read().decode('utf-8')
pattern = "originally announced[\s\S]*?</p>"
result = re.findall(pattern, html_str)
if(len(result)>0):
	pattern = "title is-clearfix[\s\S]*?results"
	result = re.findall(pattern,html_str)
	temp = result[0].split("of")[1]
	total = float(re.findall("\d+",temp)[0])
	pages = math.ceil(total/50)
	start = 0
	all_year = []
	for i in range(pages):
		url = "https://arxiv.org/search/?query=" + author + "&searchtype=author&start=" + str(start)
		content = urllib.request.urlopen(url)
		html_str = content.read().decode('utf-8')
		pattern = "Authors:[\s\S]*?originally announced[\s\S]*?</p>"
		#pattern = "originally announced[\s\S]*?</p>"
		result = re.findall(pattern, html_str)
		check = False
		for r in result:
			pattern = "a href=\"[\s\S]*?\">[\s\S]*?</a>"
			name_result = re.findall(pattern,r)
			for n in name_result:
				name = n.split("\">")[1].split("</a>")[0].strip()
				if(name==input_name):
					check = True
			if(check==True):
				pattern = "originally announced[\s\S]*?</p>"
				announce = re.findall(pattern,r)
				pattern = "\d+"
				for a in announce:
					year = int(re.findall(pattern,a)[0])
					all_year.append(year)
			check = False	
		start += 50
		
	# Plot bar graph
	if(len(all_year)>0):
		label, value = zip(*Counter(all_year).items())
		plt.yticks(np.arange(min(value),max(value)+1))
		plt.bar(label,value)
		plt.show()

else:
	print("Sorry, your query for author produced no results.")

