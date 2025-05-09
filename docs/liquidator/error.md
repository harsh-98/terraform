# Errors
- router version in the partial liquidator is limited to 300-310. if the latest version is more than 310, we can't get it. change the code in deployment.go:GetLatestVersion. Another way is used in full_liquidator: GetRouter() , which gets the latst router from store.
- core.GetExtraBytes was failing on anvil, due to block_num specified in past. Use the block_num as 0 , if possible , the calls in past can fail on anvil.
- 532e7bb6 -- 
- 234b893b -- CreditAccountNotLiquidatableException()
- arithmetic underflow or overflow
- i have fixed the “block height is x but requested y” error. When sending an impersonate tx, i wasn’t waiting for it to be minted. As a result,  sometimes, after the revert that tx was minted and block height was different. 

# New errors
- StalePriceException() 0x16dd0ffb, try with new anvil fork.
- 4f7bde1f PathNotFoundException(address,address)
- 532e7bb6 NotEnoughCollateralException in `fullCollateralCheck` `cd core-v3;  npx ts-node a.ts` , reason is that the borrowed amount is near min- borrowed amount, this error occurs on testnet only. as ilya created account with near min borrowed amount.
- 532e7bb6 if there are price update for 2 tokens. but only 1 price is updated. https://anvil.gearbox.foundation/optimist/tkhcTreLdC#0x2dd94ebdbabffed2bebd3ed039dd943334f55666_0x51fd3c00932e6959b3942870ec29aa06cc6cc26f . 
- CreditAccountNotLiquidatableException() 0x234b893b, reason for partial liquidator in optimistic mode, the new set lt for token is not low enough. change the lt from 9990/ 9960 to lower value .
- revert: 27 , need to use different partial contract for liquidating dola accounts.
- 0x4f7bde1f path not found in v310 due to Isenabled being true for all the tokens. Fixed in https://github.com/Gearbox-protocol/go-liquidator/commit/652a1c83c41fd378c6a645fc5d0205ae6c35ca01 
- RegisteredCreditManagerOnlyException() 0xbc6a488ad96f222e4e995d7736e44a0ec106b3d757732b5fca6bf6b09c5a946c
## how to get debug the failing tx.
* use `cast run`
* use `cast tx`.
* `cast call`.
* cast call 0x848c0614deda40b5e735e3d7980cea1feb018a5f --data 0x8c3b73620000000000