#! /usr/bin/env python3

import os
import json 
import collections
import sys

BASE_DIR, throwaway = os.path.split(os.path.realpath(__file__))
BASE_DIR = os.path.realpath(BASE_DIR + "/..")
DATA_DIR = BASE_DIR + '/data'

# extract latitude and longitude

def parse_json(line, w):
  obj = json.loads(line)
  id = obj['id'][1:] # strip Q
  #typ = obj['type']

  if 'claims' in obj:
    claims = obj['claims']
    if 'P625' in claims:
      p625s = claims['P625']
      for p625 in p625s:
        try:
          latitude = p625['mainsnak']['datavalue']['value']['latitude']
          longitude = p625['mainsnak']['datavalue']['value']['longitude']
          print(id + '\t' + str(latitude) + '\t' + str(longitude), file=w)
        except KeyError:
          print('ignoring keyerror', file=sys.stderr) 

with open(DATA_DIR + '/wikidata/dump.json', 'r') as f, open(BASE_DIR + '/input/coordinate-locations.tsv', 'w') as w:
    for line in f:
        line = line.rstrip()
        if line == '[' or line == ']':
            continue
        # strip trailing commas
        line = line.rstrip(',')
        parse_json(line, w)
