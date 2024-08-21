# Errors
- router version in the partial liquidator is limited to 300-310. if the latest version is more than 310, we can't get it. change the code in deployment.go:GetLatestVersion. Another way is used in full_liquidator: GetRouter() , which gets the latst router from store.
- core.GetExtraBytes was failing on anvil, due to block_num specified in past. Use the block_num as 0 , if possible , the calls in past can fail on anvil.
- 532e7bb6 -- 
- 234b893b -- InsufficientNumberOfUniqueSigners(uint256,uint256)
- arithmetic underflow or overflow
- i have fixed the “block height is x but requested y” error. When sending an impersonate tx, i wasn’t waiting for it to be minted. As a result,  sometimes, after the revert that tx was minted and block height was different. 


## how to get debug the failing tx.
* use `cast run`
* use `cast tx`.
* `cast call`.