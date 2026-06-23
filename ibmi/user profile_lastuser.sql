## List user prfiles by last use data descending
select *
from qsys2.user_info
where previous_signon is not null
order by previous_signon desc;
