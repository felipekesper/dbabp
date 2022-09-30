#!/bin/bash

export ORACLE_HOME='/u01/app/oracle/database'
export PATH='/u01/app/oracle/database/bin:/u01/app/oracle/database/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin'
export ORACLE_SID='prod'

i=`shuf -i 1-1000 -n 1`

echo `date '+%d_%m_%Y-%H_%M'`_${i} >> /home/oracle/qtinserted.txt

echo "Downloading values..."

urlp="https://api.mockaroo.com/api/e89b45b0?count=${i}&key=ab17d350"
urlc="https://api.mockaroo.com/api/25696190?count=${i}&key=ab17d350"
urlj="https://api.mockaroo.com/api/277eea10?count=${i}&key=ab17d350"

filep=people_`date '+%d_%m_%Y-%H_%M'`.sql
filec=cars_`date '+%d_%m_%Y-%H_%M'`.sql
filej=jobs_`date '+%d_%m_%Y-%H_%M'`.sql

curl -s $urlp > "/home/oracle/people/${filep}"
curl -s $urlc > "/home/oracle/cars/${filec}"
curl -s $urlj > "/home/oracle/jobs/${filej}"

#@/home/oracle/cars/${filec}
#@/home/oracle/people/${filep}

/u01/app/oracle/database/bin/sqlplus -S felipe/password << HERE	
	!echo "Inserting into people2..."
	!sleep 1
	@/home/oracle/people/${filep}
	!echo "Inserting into jobs2..."
        !sleep 1
	@/home/oracle/jobs/${filej}
	!echo "Inserting into cars2..."
	!sleep 1
	@/home/oracle/cars/${filec}
HERE
echo "Completed."
