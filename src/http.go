package main

import (
	"fmt"
	"net/http"
)

func ping(w http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(w, "Pong!\n")
}

func main() {
	http.HandleFunc("/", ping)
	http.ListenAndServe(":8001", nil)
}
