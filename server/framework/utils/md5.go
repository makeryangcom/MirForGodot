/**
 ******************************************************************************
 * @file    md5.go
 * @author  MakerYang
 ******************************************************************************
 */

package Utils

import (
	"crypto/md5"
	"encoding/hex"
)

func MD5Hash(text string) string {
	hash := md5.Sum([]byte(text))
	return hex.EncodeToString(hash[:])
}

func VerifyPassword(storedPassword, inputPassword string) bool {
	return MD5Hash(inputPassword) == storedPassword
}
