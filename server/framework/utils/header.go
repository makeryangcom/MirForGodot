package Utils

import "strings"

func CheckUserAgent(userAgent string) bool {
	Status := false

	if strings.Contains(userAgent, "GodotEngine") {
		Status = true
	}

	return Status
}

func CheckGame(token string) (int, int, bool) {
	Status := false
	GameId := 0
	GameAccountId := 0

	if token != "" {
		tokenMap, _ := DecodeId(128, token)
		if len(tokenMap) == 2 {
			GameId = tokenMap[0]
			GameAccountId = tokenMap[1]
			Status = true
		}
	}

	if GameId == 0 || GameAccountId == 0 {
		Status = false
	}

	return GameId, GameAccountId, Status
}

func CheckUser(token string) (int, bool) {
	Status := false
	Uid := 0

	if token != "" {
		tokenMap, _ := DecodeId(32, token)
		if len(tokenMap) == 3 {
			Uid = tokenMap[0]
			Status = true
		}
	}

	return Uid, Status
}
