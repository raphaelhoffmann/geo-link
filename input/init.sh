#!/usr/bin/env bash
# A script for loading reuters and wikidata into PostgreSQL database
set -eux
#cd "$(dirname "$0")"

#bzcat ./articles_dump.csv.bz2  | deepdive sql "COPY articles  FROM STDIN CSV"
#bzcat ./sentences_dump.csv.bz2 |
#if [[ -z ${SUBSAMPLE_NUM_SENTENCES:-} ]]; then cat; else head -n ${SUBSAMPLE_NUM_SENTENCES}; fi |
#deepdive sql "COPY sentences FROM STDIN CSV"

#!/bin/bash

cd $(dirname $0)/..

. ./env_local.sh


cd "$(dirname "$0")"

# article content
cat $(pwd)/converted.csv | deepdive sql "copy articles from STDIN csv"

# wiki data
cat `pwd`/names.tsv | deepdive sql "copy wikidata_names from STDIN CSV DELIMITER E'\t' QUOTE E'\1';"
cat `pwd`/coordinate-locations.tsv | deepdive sql "copy wikidata_coordinate_locations from STDIN;"
cat `pwd`/transitive.tsv | deepdive sql "copy wikidata_instanceof from STDIN;"

#import sentence parses
cat `pwd`/../data/sentences.tsv.gz | gunzip - | deepdive sql "COPY sentences from STDIN"

# intermediate view 
#TODO move this to app.ddlog
# use ":-" to create a view/table. Don't know if DISTINCT is supported
deepdive sql 'INSERT INTO v_mentions SELECT DISTINCT sentence_id, mention_num, w_from, w_to FROM locations'


# install psql extensions
deepdive sql "CREATE EXTENSION cube;"
deepdive sql "CREATE EXTENSION earthdistance;"
