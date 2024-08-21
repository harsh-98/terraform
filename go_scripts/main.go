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
	if len(os.Args) < 3 {
		log.Fatal("Usage: go run main.go <private_key> <address>")
	}
	fmt.Fprintln(os.Stderr, "Give passwords:")
	password, err := gopass.GetPasswd()
	log.CheckFatal(err)
	if len(os.Args) == 4 && "encrypt" == os.Args[3] {
		prvKey := utils.Encrypt(os.Args[1], string(password))
		fmt.Println(prvKey)
		return
	}
	prvKey := utils.Decrypt(os.Args[1], password)
	if len(prvKey) == 66 {
		prvKey = prvKey[2:]
	}
	wallet := core.GetWallet(prvKey)
	if wallet.Address != common.HexToAddress(os.Args[2]) {
		log.Fatal("Wrong prvKey", os.Args[1], string(password),wallet.Address)
	}
	fmt.Println(fmt.Sprintf("PRIVATE_KEY=\"%s\"", prvKey))
}
