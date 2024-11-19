package router

import (
	"log"

	"github.com/Thanoraj/movie-suggester/backend/controllers"
	"github.com/Thanoraj/movie-suggester/backend/middlewares"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
)

func InitApp() {

	app := fiber.New()

	app.Use(
		cors.New(
			cors.Config{
				AllowCredentials: true,
				AllowOrigins:     "http://localhost:8000",
			},
		),
	) // List allowed origins here

	createRoutes(app)

	log.Fatal(app.Listen(":8000"))

}

func createRoutes(app *fiber.App) {
	app.Get("/", controllers.Home)

	api := app.Group("/api/v1")
	api.Post("/register", controllers.RegisterUser)
	api.Post("/send-verification", controllers.SendVerificationEmail)
	api.Get("/verify-email", controllers.VerifyEmail)
	api.Post("/verification-status", controllers.GetVerificationStatus)
	api.Post("/login", controllers.LoginUser)
	api.Post("/logout", controllers.LogoutUser)
	api.Post("/delete-user-email", controllers.DeleteUserWithEmail)

	userRoutes := api.Group("/user")
	userRoutes.Use(middlewares.AuthMiddleware)
	userRoutes.Get("/", controllers.GetUser)
	userRoutes.Post("/delete-user", controllers.DeleteUser)
	userRoutes.Get("/preferences", controllers.Preference)
	userRoutes.Post("/update-preferences", controllers.UpdatePreferences)

	dataRoutes := api.Group("/data")
	dataRoutes.Use(middlewares.AuthMiddleware)
	dataRoutes.Get("/genres", controllers.GetGenreData)
	dataRoutes.Get("/languages", controllers.GetLanguageData)
	dataRoutes.Get("/genres-and-languages", controllers.GetGenreLanguageData)

}
