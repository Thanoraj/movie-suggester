package router

import (
	"log"

	"github.com/Thanoraj/movie-suggester/backend/controllers"
	"github.com/gofiber/fiber/v2"
)

func InitApp()  {

	app := fiber.New()

	createRoutes(app)

	log.Fatal(app.Listen(":8000"))
	
}

func createRoutes(app *fiber.App) {
	app.Get("/", controllers.Home)
	app.Post("/api/v1/register", controllers.RegisterUser)
	app.Post("/api/v1/login", controllers.LoginUser)
}
