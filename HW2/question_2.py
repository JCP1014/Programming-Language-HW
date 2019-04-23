import urllib.request
import re
from collections import Counter
import matplotlib.pyplot as plt
import numpy as np
from operator import methodcaller
import math

name_cut = input("Input Author: ").split()
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

		pattern = "a href=\"[\s\S]*?\">[\s\S]*?</a>"
		for r in result:
			name_result = re.findall(pattern,r)
			for n in name_result:
				name = n.split("\">")[1].split("</a>")[0].strip()
				co_author.append(name)
		start += 50

	pattern = "[\s\S]*"
	for n in name_cut:
		pattern += n
		pattern += "[\s\S]*"

	for i in range(len(co_author)):
		if re.match(pattern,co_author[i],re.I):
			co_author[i] = None
	while None in co_author: co_author.remove(None)
	co_list = sorted(co_author,key=methodcaller('casefold'))

	if(len(co_author)>0):
		co_name, times = zip(*Counter(co_list).items())
		for i in range(len(co_name)):
			print("["+co_name[i]+"]: ",times[i]," times")
	else:
		print("No co-author")

else:
	print("Sorry, your query for author produced no results.")
