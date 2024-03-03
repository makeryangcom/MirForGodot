package Utils

import (
	"regexp"
	"strings"
)

func FilterMarkdown(input string) string {
	quoteBlockRegex := regexp.MustCompile(`^\s*>[ \t]*(.*)$`)
	lines := strings.Split(input, "\n")
	var quoteLines []string
	for _, line := range lines {
		if quoteBlockRegex.MatchString(line) {
			match := quoteBlockRegex.FindStringSubmatch(line)
			quoteLines = append(quoteLines, match[1])
		}
	}
	return strings.Join(quoteLines, "")
}

func FilterSummary(input string, maxLength int) string {
	text := strings.TrimSpace(input)
	if len(text) <= maxLength {
		return text
	}
	return text[:maxLength]
}
