package api

import (
"encoding/json"
"fmt"
"io"
"net/http"
"sync"
"time"
)

const (
BaseUsers    = "https://users.roblox.com"
BaseFriends  = "https://friends.roblox.com"
BaseGroups   = "https://groups.roblox.com"
BaseGames    = "https://games.roblox.com"
BaseBadges   = "https://badges.roblox.com"
BaseAvatar   = "https://avatar.roblox.com"
BasePresence = "https://presence.roblox.com"
)

type Client struct {
HTTP   *http.Client
Header http.Header
}

func New() *Client {
return &Client{
HTTP: &http.Client{Timeout: 15 * time.Second},
Header: http.Header{
"User-Agent": []string{"Mozilla/5.0 (Windows NT 10.0; Win64; x64)"},
"Accept":     []string{"application/json"},
},
}
}

func (c *Client) get(url string, out interface{}) error {
req, err := http.NewRequest("GET", url, nil)
if err != nil {
return err
}
for k, v := range c.Header {
req.Header[k] = v
}
resp, err := c.HTTP.Do(req)
if err != nil {
return err
}
defer resp.Body.Close()
if resp.StatusCode != 200 {
return fmt.Errorf("HTTP %d", resp.StatusCode)
}
body, err := io.ReadAll(resp.Body)
if err != nil {
return err
}
return json.Unmarshal(body, out)
}

func (c *Client) post(url string, payload interface{}, out interface{}) error {
body, _ := json.Marshal(payload)
req, err := http.NewRequest("POST", url, bytesReader(body))
if err != nil {
return err
}
req.Header.Set("Content-Type", "application/json")
for k, v := range c.Header {
req.Header[k] = v
}
resp, err := c.HTTP.Do(req)
if err != nil {
return err
}
defer resp.Body.Close()
if resp.StatusCode != 200 {
return fmt.Errorf("HTTP %d", resp.StatusCode)
}
return json.NewDecoder(resp.Body).Decode(out)
}

// FetchAll — concurrent fetch semua endpoint
func (c *Client) FetchAll(userID int) map[string]interface{} {
result := make(map[string]interface{})
var mu sync.Mutex
var wg sync.WaitGroup

fetch := func(key, url string, out interface{}) {
defer wg.Done()
if err := c.get(url, out); err != nil {
mu.Lock()
result[key] = map[string]string{"error": err.Error()}
mu.Unlock()
return
}
mu.Lock()
result[key] = out
mu.Unlock()
}

// Type definitions inline
var userInfo map[string]interface{}
var friendCount map[string]int
var groups struct {
Data []map[string]interface{} `json:"data"`
}
var games struct {
Data []map[string]interface{} `json:"data"`
}
var badges struct {
Data []map[string]interface{} `json:"data"`
}
var avatar map[string]interface{}

wg.Add(6)
go fetch("user", fmt.Sprintf("%s/v1/users/%d", BaseUsers, userID), &userInfo)
go fetch("friends_count", fmt.Sprintf("%s/v1/users/%d/friends/count", BaseFriends, userID), &friendCount)
go fetch("groups", fmt.Sprintf("%s/v2/users/%d/groups/roles", BaseGroups, userID), &groups)
go fetch("games", fmt.Sprintf("%s/v2/users/%d/games?limit=50", BaseGames, userID), &games)
go fetch("badges", fmt.Sprintf("%s/v1/users/%d/badges?limit=100", BaseBadges, userID), &badges)
go fetch("avatar", fmt.Sprintf("%s/v1/users/%d/avatar", BaseAvatar, userID), &avatar)

wg.Wait()

result["groups"] = groups.Data
result["games"] = games.Data
result["badges"] = badges.Data

return result
}

// helper — avoid extra import
func bytesReader(b []byte) io.Reader {
return &byteReader{b: b}
}

type byteReader struct {
b []byte
i int
}

func (r *byteReader) Read(p []byte) (int, error) {
if r.i >= len(r.b) {
return 0, io.EOF
}
n := copy(p, r.b[r.i:])
r.i += n
return n, nil
}

// Public Post wrapper
func (c *Client) Post(url string, payload interface{}, out interface{}) error {
	return c.post(url, payload, out)
}
