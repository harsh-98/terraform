package main

import (
	"fmt"
	"os"

	"github.com/Gearbox-protocol/sdk-go/core"
	"github.com/Gearbox-protocol/sdk-go/log"
	"github.com/Gearbox-protocol/sdk-go/utils"
	"github.com/ethereum/go-ethereum/common"
	"github.com/howeyc/gopass"
)

func main() {
	fmt.Fprintln(os.Stderr, "Give passwords:")
	password, err := gopass.GetPasswd()
	log.CheckFatal(err)
	prvKey := utils.Decrypt(os.Args[1], password)
	wallet := core.GetWallet(prvKey)
	if wallet.Address != common.HexToAddress(os.Args[2]) {
		log.Fatal("Wrong prvKey", os.Args[1], password)
	}
	fmt.Println(fmt.Sprintf("PRIVATE_KEY=\"%s\"", prvKey))
}
