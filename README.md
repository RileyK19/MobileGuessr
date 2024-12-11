# MobileGuessr
Change++ Challenge Solution

## Instructions
- Create a file 'API_KEY.swift'
- Add a string variable called 'API_KEY' with your Google API key
- Use the app freely!

## Showcase
<img src="https://github.com/ChangePlusPlusVandy/change-coding-challenge-2024-RileyK19/blob/main/Change%2B%2BChallenge/Change%2B%2BChallenge/Examples/Light_Main_Menu.png" alt="Image 1" width="200"/> <img src="https://github.com/ChangePlusPlusVandy/change-coding-challenge-2024-RileyK19/blob/main/Change%2B%2BChallenge/Change%2B%2BChallenge/Examples/Light_Guess_Screen.png" alt="Image 2" width="200"/> 
<img src="https://github.com/ChangePlusPlusVandy/change-coding-challenge-2024-RileyK19/blob/main/Change%2B%2BChallenge/Change%2B%2BChallenge/Examples/Light_Map.png" alt="Image 3" width="200"/>

Mobile alternative to GeoGuessr 

- Quick 15 minute games

- Includes timer, high score, images from around the world, dark mode support, and more

- Powered by Apple MapKit and Google Static StreetView, created with SwiftUI

## Dark Mode Support

<img src="https://github.com/ChangePlusPlusVandy/change-coding-challenge-2024-RileyK19/blob/main/Change%2B%2BChallenge/Change%2B%2BChallenge/Examples/Dark_Main_Menu.png" alt="Image 1" width="200"/> <img src="https://github.com/ChangePlusPlusVandy/change-coding-challenge-2024-RileyK19/blob/main/Change%2B%2BChallenge/Change%2B%2BChallenge/Examples/Dark_Guess_Screen.png" alt="Image 2" width="200"/> 
<img src="https://github.com/ChangePlusPlusVandy/change-coding-challenge-2024-RileyK19/blob/main/Change%2B%2BChallenge/Change%2B%2BChallenge/Examples/Dark_Map.png" alt="Image 3" width="200"/>

## Backend Documentation

```Swift
// Creates a new question and generates a random StreetView url location
var question: Question = Question()
```

Question functions:
```Swift
// Returns the metadata of the url, including date, location, status, and StreetView ID
// Metadata struct only has error message and status currently
question.getMetadata()

// Generates a random Coordinate pair (not always a location in StreetView)
question.generate()

// Generates a random place likely in StreetView (excludes oceans and places with little coverage)
// Uses api.3geonames.org
question.getRandom()

// Calculates distance between user's answer and correct answer
question.calcDist()

// Sets the user answer to the given Coordinate
question.setUserAnswer(coordinates: Coordinate)
```

Other functions:
```Swift
// Generates a StreetView static url from the given latitude and longitude
makeUrl(latitude: Int, longitude: Int)

// Gets data from api.3geonames.org url and parses into latitude, longitude, and location name (City, Country)
parseUrl(url: URL)

// Takes url and turns it into a parsable string for parseUrl()
urlToStr(url: URL)

// Translates degrees of latitude, longitude coordinates into kilometers
degToKm(coordinates: Coordinate)

// Calculates the score from a given distance in kilometers
calcScore(distance: Double)
```


## Information

Riley Koo

riley.koo@vanderbilt.edu
- Run / simulate iOS app with Xcode. Tested and built with iPhone 15 Pro simulator
- I wanted to write an ios app because I have some experience in ios and I found that that would fit the challenge better then a website. The person who needs a game on the train would find it more convenient than a website. So I made a quick 10-15 minute geoguessr-like game for him to play.
- The backend is in the swift file called 'File' and the frontend is in the 'ContentView'.

### License

```
MIT License

Copyright (c) 2024 R. Koo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

