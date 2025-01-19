package models

import "time"

type CacheEntry struct {
	Query     string
	Results   []OMDBSearchResultMovie
	CreatedAt time.Time
}
