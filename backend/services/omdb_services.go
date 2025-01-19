package services

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"

	"github.com/Thanoraj/movie-suggester/backend/config"
	"github.com/Thanoraj/movie-suggester/backend/models"
)

func getMovieDataFromOMDB(name string, year string) (*models.OMDBMovie, error) {
	url := fmt.Sprintf("https://www.omdbapi.com/?apikey=%s&t=%s&y=%s", config.OMDB_API_KEY, name, year)
	var movie models.OMDBMovie

	// Make the GET request
	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	// Check the status code
	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to get the movie data")
	}

	// Read and print the response body
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, errors.New("failed to get the movie data")
	}

	if err := json.Unmarshal(body, &movie); err != nil {
		return nil, errors.New("failed to unmarshal the movie data")
	}

	return &movie, nil
}

func SearchMovie(name string) (*[]models.OMDBSearchResultMovie, error) {

	url := fmt.Sprintf("https://www.omdbapi.com/?apikey=%s&s=%s", config.OMDB_API_KEY, name)
	var movie models.OMDBSearchResult

	// Make the GET request
	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	// Check the status code
	if resp.StatusCode != http.StatusOK {
		return nil, errors.New("failed to get the movie data")
	}

	// Read and print the response body
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, errors.New("failed to get the movie data")
	}
	fmt.Println(body)

	if err := json.Unmarshal(body, &movie); err != nil {
		return nil, errors.New("failed to unmarshal the movie data")
	}

	return &movie.Search, nil

}
