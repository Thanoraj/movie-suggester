package router

import (
	"log"

	"github.com/Thanoraj/movie-suggester/backend/controllers"
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
	app.Post("/api/v1/register", controllers.RegisterUser)
	app.Post("/api/v1/login", controllers.LoginUser)
	app.Get("/api/v1/user", controllers.GetUser)
}
