package services

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/Thanoraj/movie-suggester/backend/database"
	"github.com/Thanoraj/movie-suggester/backend/models"
)

func GetCachedResults(query string) (*models.CacheEntry, error) {

	var searchCache models.SearchCache
	result := models.CacheEntry{}

	err := database.GetSearchCache(query, &searchCache)

	if err != nil {
		fmt.Println("Here error")
		fmt.Println(err.Error())
		return &result, nil
	}

	fmt.Println("Here not an error")
	fmt.Println(searchCache)

	var results []models.OMDBSearchResultMovie
	if err := json.Unmarshal([]byte(searchCache.Results), &results); err != nil {
		return nil, err
	}
	result.Query = query
	result.Results = results
	result.CreatedAt = searchCache.CreatedAt
	return &result, nil
}

func SaveResultsToCache(query string, results []models.OMDBSearchResultMovie) error {
	resultsJSON, err := json.Marshal(results)
	if err != nil {
		return err
	}

	searchCache := models.SearchCache{
		Query:     query,
		Results:   string(resultsJSON),
		CreatedAt: time.Now(),
	}
	err = database.SaveCacheResult(searchCache)

	return err
}
