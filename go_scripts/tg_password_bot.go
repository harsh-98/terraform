package main

import (
	"fmt"
	"os"
	"strconv"
	"sync"
	"time"

	tgbotapi "github.com/go-telegram-bot-api/telegram-bot-api"
	"github.com/joho/godotenv"
)

func _main() {
	godotenv.Load(".env")
	token := os.Getenv("TG_TOKEN")
	bot, err := tgbotapi.NewBotAPI(token)
	if err != nil {
		fmt.Println(err)
	}
	user, err := strconv.ParseInt(os.Getenv("USER_ID"), 10, 64)
	if err != nil {
		fmt.Println(err)
	}
	bI := &BotI{Users: []int64{user}, bot: bot, Ts: time.Now().Unix()}
	wg := &sync.WaitGroup{}
	wg.Add(1)
	go bI.listen(wg)
	// bI.startCommand(bI.Users[0])

	sendMsg(bI.bot, passwordStr, user)
	wg.Wait()
}

func containsInt(users []int64, value int64) bool {
	for _, user := range users {
		if user == value {
			return true
		}
	}
	return false
}

func (b *BotI) listen(wg *sync.WaitGroup) {
	u := tgbotapi.NewUpdate(0)
	u.Timeout = 60
	updates, err := b.bot.GetUpdatesChan(u)
	if err != nil {
		fmt.Println(err)
		return
	}

	for update := range updates {
		if update.Message != nil {
			if !containsInt(b.Users, int64(update.Message.From.ID)) {
				continue
			}
			if update.Message.ReplyToMessage != nil && update.Message.Date > int(b.Ts) {

				b.replyReceived(update.Message)
			}
		}
		// if update.CallbackQuery != nil {
		// 	b.callbackQueryReceived(update.CallbackQuery)
		// }
	}
	wg.Done()
}

func (bot *BotI) callbackQueryReceived(cb *tgbotapi.CallbackQuery) {
	if cb.Data == "Give password" {
		fmt.Println(cb.Message.Text)
		os.Exit(0)
	}
}

var passwordStr string = "Give password"

type BotI struct {
	Ts    int64
	bot   *tgbotapi.BotAPI
	Users []int64
}

func (b *BotI) replyReceived(message *tgbotapi.Message) {
	if message.ReplyToMessage.Text == passwordStr {
		fmt.Println(message.Text)
		b.bot.StopReceivingUpdates()
		os.Exit(0)
	}
}

func sendMsg(bot *tgbotapi.BotAPI, text string, userId int64) {
	msg := tgbotapi.NewMessage(userId, text)
	_, err := bot.Send(msg)
	if err != nil {
		msg = tgbotapi.NewMessage(userId, err.Error())
		bot.Send(msg)
	}
}
