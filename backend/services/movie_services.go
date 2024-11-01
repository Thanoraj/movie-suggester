package services

import "github.com/Thanoraj/movie-suggester/backend/models"

func GetSuggestion(watchList []string) ([]*models.OMDBMovie, error) {
	suggestedMovies, err := getGeminiAISuggestion(watchList)

	if err != nil {
		return nil, err
	}

	var moviesData []*models.OMDBMovie

	for _, movie := range suggestedMovies {
		movie, err := getMovieDataFromOMDB(movie.Title, movie.Year)
		if err == nil {
			moviesData = append(moviesData, movie)
		}
	}

	return moviesData, nil
}

func GetMovieData(title string, year string) (*models.OMDBMovie, error) {
	return getMovieDataFromOMDB(title, year)

}
