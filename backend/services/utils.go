package services

import "strings"

func ToTitleCase(input string) string {
	// Split the input string into words
	words := strings.Fields(input)

	// Map each word to its title-cased version
	for i, word := range words {
		if len(word) > 0 {
			// Capitalize the first letter and make the rest lowercase
			words[i] = strings.ToUpper(string(word[0])) + strings.ToLower(word[1:])
		}
	}

	// Join the words back into a single string
	return strings.Join(words, " ")
}
