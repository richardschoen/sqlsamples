## List IBM i user profiles by last use data descending
We list by last used date and filter ourt where previous signon = null   
```
select *
from qsys2.user_info
where previous_signon is not null
order by previous_signon desc;
```

