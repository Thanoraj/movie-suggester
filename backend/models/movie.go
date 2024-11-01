package models

type GeminiAIMovie struct {
	Title string   `json:"title"`
	Year  string   `json:"year"`
	Genre []string `json:"genre"`
}
