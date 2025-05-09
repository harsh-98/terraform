# check
```
(select count(*), 'debt' from debts) union (select count(*), 'price' from price_feeds) union (select count(*), 'tvl' from tvl_snapshots);
```


# delete nth
```
delete from tvl_snapshots where block_num not in (select block_num from (SELECT block_num, ROW_NUMBER() OVER (ORDER BY block_num) AS rn
    FROM tvl_snapshots ) p where rn %5 =0);
```