package main

import (
  "github.com/transparencytoolkit/indeedscraper"
  "encoding/json"
  "fmt"
  "io/ioutil"
  "bufio"
  "os"
  "os/exec"
  "strings"
)


// Scrape all data for terms specified from indeed.com
// Limitations: Only resumes, only search terms (no locations)
func main(){
  // Get file
  fmt.Println("File with search terms:")
  cread := bufio.NewReader(os.Stdin)
  filepath, _ := cread.ReadString('\n')
  file, _ := ioutil.ReadFile(strings.TrimSpace(filepath))

  // Load search terms into JSON
  var jsondata []map[string]string
  json.Unmarshal(file, &jsondata)

  
  // Get results dir
  fmt.Println("Folder to store results:")
  dread := bufio.NewReader(os.Stdin)
  resultspath, _ := dread.ReadString('\n')
  
  // Make dir if it doesn't exist
  if _, err := os.Stat(strings.TrimSpace(resultspath)); os.IsNotExist(err){
    os.Mkdir(strings.TrimSpace(resultspath), 0777)
  }

  // Go through all 
  for _, item := range jsondata {
    termfile := strings.TrimSpace(resultspath)+"/"+
      strings.Replace(strings.Replace(item["Search Term"], "/", "-", -1), " ", "_", -1)+".json"

    // Only scrape if results don't exist already
    if _, err := os.Stat(termfile); os.IsNotExist(err){
      results := []byte(indeedscraper.GetResumes(item["Search Term"], ""))
      ioutil.WriteFile(termfile, results, 0644)

      // Make CSV too
      cmd := exec.Command("json2csv", termfile)
      stdout, _ := cmd.Output()
      ioutil.WriteFile(strings.Replace(termfile, ".json", ".csv", -1), stdout, 0644)
    }
  }
}
