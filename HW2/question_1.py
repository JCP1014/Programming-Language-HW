import urllib.request
import re
from collections import Counter
import matplotlib.pyplot as plt
import numpy as np
import math

name_cut = input("Input Author: ").split()
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
		pattern = "originally announced[\s\S]*?</p>"
		result = re.findall(pattern, html_str)
		pattern = "\d+"
		for r in result:
			year = int(re.findall(pattern,r)[0])
			all_year.append(year)
		start += 50

	# Plot bar graph
	if(len(all_year)>0):
		label, value = zip(*Counter(all_year).items())
		x = np.arange(min(all_year),max(all_year)+1)
		plt.yticks(np.arange(min(value),max(value)+1))
		plt.bar(x,value)
		plt.show()
else:
	print("Sorry, your query for author produced no results.")

