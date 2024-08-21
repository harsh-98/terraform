create view aaa as (select  distinct on (token) token, oracle, feed, block_num, 300 "version", feed_type, reserve  from token_oracle where token in ('0x090185f2135308BaD17527004364eBcC2D37e5F6','0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0','0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B','0x5f98805A4E8be255a32880FDeC7F6728C6568bA0','0x853d955aCEf822Db058eb8505911ED77F175b99e','0x99D8a9C45b2ecA8864373A26D1459e3Dff1e17F3','0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48','0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F','0xD533a949740bb3306d119CC777fa900bA034cd52','0xdAC17F958D2ee523a2206206994597C13D831ec7') order by token, block_num desc);



-- check
select details,jsonb_set(details, concat('{mergedPFVersion,',(select * from jsonb_object_keys(details->'mergedPFVersion')limit 1 )::text,',2}')::text[], '{"mergedPFVersion": 0, "blockNum": 20464407}'::jsonb, true) from sync_adapters  where address in  (select distinct on (token) feed from token_oracle where token in ('0x090185f2135308BaD17527004364eBcC2D37e5F6','0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0','0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B','0x5f98805A4E8be255a32880FDeC7F6728C6568bA0','0x853d955aCEf822Db058eb8505911ED77F175b99e','0x99D8a9C45b2ecA8864373A26D1459e3Dff1e17F3','0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48','0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F','0xD533a949740bb3306d119CC777fa900bA034cd52','0xdAC17F958D2ee523a2206206994597C13D831ec7') and "version"=300 and reserve='f' order by token, block_num desc);

update sync_adapters set details=jsonb_set(details, concat('{mergedPFVersion,',(select * from jsonb_object_keys(details->'mergedPFVersion')limit 1 )::text,',2}')::text[], '{"mergedPFVersion": 0, "blockNum": 20464407}'::jsonb, true)  where address in  (select distinct on (token) feed from token_oracle where token in ('0x090185f2135308BaD17527004364eBcC2D37e5F6','0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0','0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B','0x5f98805A4E8be255a32880FDeC7F6728C6568bA0','0x853d955aCEf822Db058eb8505911ED77F175b99e','0x99D8a9C45b2ecA8864373A26D1459e3Dff1e17F3','0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48','0xC011a73ee8576Fb46F5E1c5751cA3B9Fe0af2a6F','0xD533a949740bb3306d119CC777fa900bA034cd52','0xdAC17F958D2ee523a2206206994597C13D831ec7') and "version"=300 and reserve='f' order by token, block_num desc);



select  details, jsonb_set(details, concat('{mergedPFVersion,',(select * from jsonb_object_keys(details->'mergedPFVersion')limit 1 )::text,',0,mergedPFVersion}')::text[], '4'::jsonb, false) from sync_adapters where address in  (select feed from aaa);
-- 
update sync_adapters set details=jsonb_set(details, concat('{mergedPFVersion,',(select * from jsonb_object_keys(details->'mergedPFVersion')limit 1 )::text,',0,mergedPFVersion}')::text[], '4'::jsonb, false), "version"=300 where address in  (select feed from aaa);


delete from price_feeds where token in (select token from aaa) and merged_pf_version=4 and block_num>=20464407 ;
update  price_feeds set merged_pf_version=4 where token in (select token from aaa) and merged_pf_version=2 and block_num>=20428700 ;

insert into token_oracle(token, oracle, feed, block_num,  "version", feed_type, reserve)  select * from aaa;
-- # check
select * from token_oracle where token in (select token from aaa) and block_num >= 20428700;