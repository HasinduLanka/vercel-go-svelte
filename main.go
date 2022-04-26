package main

import (
	"log"
	"net/http"

	"github.com/HasinduLanka/vercel-go-svelte/api"
)

// This source file is only intended to be run locally. It will not work on Vercel.

func main() {

	multiplexer := &http.ServeMux{}

	// serve static files
	multiplexer.Handle("/", http.FileServer(http.Dir("./frontend/public")))

	multiplexer.HandleFunc("/api/hello", api.HelloEndpoint)

	log.Println("Listening on port 20000. Visit http://localhost:20000 if you're running this locally.")

	// Blocks until the program is terminated
	serveErr := http.ListenAndServe(":20000", multiplexer)

	// serveErr is always non nil
	log.Println(serveErr.Error())

}
