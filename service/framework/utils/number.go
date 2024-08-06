/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package Utils

import (
	"fmt"
	"strings"
)

func FormatKUnit(number int) string {
	if number < 1000 {
		return fmt.Sprintf("%d", number)
	}
	kValue := float64(number) / 1000.0
	return fmt.Sprintf("%.1fK", kValue)
}

func FormatCurrency(amount int) string {
	amountStr := fmt.Sprintf("%d", amount)

	runes := []rune(amountStr)
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	revStr := string(runes)

	var result strings.Builder
	for i, r := range revStr {
		if i > 0 && i%3 == 0 {
			result.WriteRune(',')
		}
		result.WriteRune(r)
	}

	runes = []rune(result.String())
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	return string(runes)
}
