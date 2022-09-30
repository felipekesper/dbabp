#!/bin/bash

# Script usado para fazer Hot Backups.

ORACLE_SID=prod
ORACLE_HOME=/u01/app/oracle/database
PATH=$PATH:$ORACLE_HOME/bin
#
sqlplus -s <<HERE
/ as sysdba
set head off pages0 lines 132 verify off feed off trimsp on
define hbdir=/bak
spo hotback.sql
select 'spo &&hbdir/hotlog.txt' from dual;
select 'select max(sequence#) from v\$log;' from dual;
select 'alter database begin backup;' from dual;
select '!cp ' || name || ' ' || '&&hbdir' from v\$datafile;
select 'alter database end backup;' from dual;
select 'alter database backup controlfile to ' || '''' || '&&hbdir'
|| '/controlbk.ctl' || '''' || ' reuse;' from dual;
select 'alter system archive log current;' from dual;
select 'select max(sequence#) from v\$log;' from dual;
select 'select member from v\$logfile;' from dual;
select 'spo off;' from dual;
spo off;
@@hotback.sql
HERE

