package Utils

import (
	"math/rand"
	"time"
)

func CreateOrderNum() string {
	str := "0123456789"
	bytes := []byte(str)
	result := make([]byte, 0)
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	for i := 0; i < 8; i++ {
		result = append(result, bytes[r.Intn(len(bytes))])
	}
	order := time.Now().Format("20060102150405") + string(result)
	return order
}
