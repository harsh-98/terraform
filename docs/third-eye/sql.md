- update field in json body
```
update account_operations  SET args = args || jsonb_build_object('userFunds',args->>'amount') where action like 'OpenCreditAccount%';
```

- serialize json into key/value and build again.
```
update credit_sessions set close_transfers=transfers FROM 
    (select id, jsonb_object(ARRAY_AGG(k), ARRAY_AGG(v->>'F')) transfers FROM 
        (select id, k,v from credit_sessions, jsonb_each(balances) arr(k,v) where version=2 and status=1) tmp group by id) tmp2
        where tmp2.id=credit_sessions.id;
```


```
update last_snaps  SET state = state::jsonb || jsonb_build_object('HrlyRateStartTs',1719493200) ;
```


# benchmarking
fatest to slow
```
explain analyze select * from blocks where id=(SELECT MAX(id) block_num  from blocks);
Execution Time: 0.095 ms
```

```
explain analyze SELECT MAX(id) block_num, max(timestamp) ts from blocks;
Execution Time: 58.665 ms
```

```
explain analyze select distinct on (id) id, timestamp from blocks order by id desc;
Execution Time: 313.660 ms
```

```
explain analyze SELECT DISTINCT ON (pool) pool,available_liquidity from pool_stats order by pool, block_num desc;
Execution Time: 104.789 ms
```


```
explain analyze select * from pool_stats where (block_num, pool) in (select max(block_num), pool from pool_stats group by pool);
Execution Time: 14.036 ms
```