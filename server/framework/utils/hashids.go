package Utils

import (
	"Game/framework/config"
	"github.com/speps/go-hashids"
)

func EncodeId(len int, id ...int) string {
	hd := hashids.NewData()
	hd.Salt = Config.Get.Hash.Salt
	hd.MinLength = len
	h := hashids.NewWithData(hd)
	e, _ := h.Encode(id)
	return e
}

func DecodeId(len int, encodedId string) ([]int, error) {
	hd := hashids.NewData()
	hd.Salt = Config.Get.Hash.Salt
	hd.MinLength = len
	h := hashids.NewWithData(hd)
	d, err := h.DecodeWithError(encodedId)
	if err != nil {
		return nil, err
	}
	return d, nil
}
