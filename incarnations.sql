
-- incarnations.sql
-- show database incarnations
-- show little_endian version of hex_change# for Intel
--

set line 200 trimspool on
set pagesize 60
col resetlogs_change# format 99999999999999
col hex_change# format a8 head 'HEX CHG#'
col little_endian format a11 head 'LITTLE|ENDIAN'


with data as (
select status
	, incarnation#
	, resetlogs_change#
	, lpad(ltrim(to_char(resetlogs_change#,'XXXXXXXX')),8,'0') hex_change#
	, to_char(resetlogs_time,'yyyy-mm-dd hh24:mi:ss') resetlogs_time
	, to_char(prior_resetlogs_time,'yyyy-mm-dd hh24:mi:ss') prior_resetlogs_time
from v$database_incarnation
)
select status
	, incarnation#
	, resetlogs_change#
	,hex_change#
	-- 0EC07ABE
	-- match little-endian
	-- display as BE 7A CO 0E
	, substr(hex_change#,7,2)
	|| ' ' || substr(hex_change#,5,2)
	|| ' ' || substr(hex_change#,3,2)
	|| ' ' || substr(hex_change#,1,2) little_endian
	, resetlogs_time
	, prior_resetlogs_time
from data
order by incarnation#
/


