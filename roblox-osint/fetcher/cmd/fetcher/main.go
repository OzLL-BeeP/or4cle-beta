package main

import (
"encoding/json"
"flag"
"fmt"
"os"

"github.com/roblox-osint/fetcher/internal/api"
)

func main() {
userID := flag.Int("id", 0, "Roblox user ID")
username := flag.String("user", "", "Roblox username")
flag.Parse()

client := api.New()

if *username != "" {
// Resolve username to ID
var lookup struct {
Data []struct {
ID int `json:"id"`
} `json:"data"`
}
payload := map[string]interface{}{
"usernames":          []string{*username},
"excludeBannedUsers": false,
}
if err := client.Post("https://users.roblox.com/v1/usernames/users", payload, &lookup); err != nil {
outputErr(err)
return
}
if len(lookup.Data) == 0 {
outputErr(fmt.Errorf("user not found"))
return
}
*userID = lookup.Data[0].ID
}

if *userID == 0 {
outputErr(fmt.Errorf("provide --id or --user"))
return
}

data := client.FetchAll(*userID)
out, _ := json.MarshalIndent(data, "", "  ")
fmt.Println(string(out))
}

func outputErr(err error) {
out, _ := json.Marshal(map[string]string{"error": err.Error()})
fmt.Fprintln(os.Stderr, string(out))
os.Exit(1)
}
