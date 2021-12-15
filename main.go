package main

import (
	"embed"
	"io/fs"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

//go:embed nextjs/dist
//go:embed nextjs/dist/_next
//go:embed nextjs/dist/_next/static/chunks/pages/*.js
//go:embed nextjs/dist/_next/static/*/*.js
var nextFS embed.FS

func main() {
	r := gin.Default()

	distFS, err := fs.Sub(nextFS, "nextjs/dist")
	if err != nil {
		log.Fatal(err)
	}
	http.Handle("/", http.FileServer(http.FS(distFS)))

	r.GET("/", func(c *gin.Context) {
		// Gather memory allocations profile.
		profile := "hello world!"
		c.String(http.StatusOK, profile)
	})

	log.Println("Starting HTTP server at http://localhost:8080 ...")
	r.Run()
}
