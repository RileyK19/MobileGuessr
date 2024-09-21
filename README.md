# MobileGuessr
Change++ Challenge Solution

## Showcase
<img src="https://github.com/ChangePlusPlusVandy/change-coding-challenge-2024-RileyK19/blob/main/Change%2B%2BChallenge/Change%2B%2BChallenge/Examples/Image_1.png" alt="Image 1" width="200"/> <img src="https://github.com/ChangePlusPlusVandy/change-coding-challenge-2024-RileyK19/blob/main/Change%2B%2BChallenge/Change%2B%2BChallenge/Examples/Image_2.png" alt="Image 2" width="200"/> 
<img src="https://github.com/ChangePlusPlusVandy/change-coding-challenge-2024-RileyK19/blob/main/Change%2B%2BChallenge/Change%2B%2BChallenge/Examples/Image_3.png" alt="Image 3" width="200"/>

Mobile alternative to GeoGuessr 

- Quick 15 minute games

- Includes timer, high score, images from around the world, and more

- Used Apple MapKit and Google Static StreetView, created with SwiftUI

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
question.dist()
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
```


## Information

Riley Koo

riley.koo@vanderbilt.edu
- ios app, so run through xcode
- I wanted to write an ios app because I have some experience in ios and 
  I found that that would fit the challenge better then a website. The 
  person who needs a game on the train would find it more convenient
  than a website. I also made a quick 10-15 minute geoguessr-like
  game for him to play. The backend is in the swift file called 'File'
  and the frontend is in the 'ContentView'. 

