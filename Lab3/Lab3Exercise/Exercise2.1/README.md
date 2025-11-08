## Task 2.1: Weather Dashboard (15 points)

## 🎯 Real-World Application
Weather apps on your phone, weather widgets on news sites, smart home displays - they all fetch real-time data from weather APIs. Companies like The Weather Channel and AccuWeather serve billions of API requests daily. In this task, you'll build a professional weather dashboard that fetches real data from a weather API.

Results
![alt text](assets/image/Result.png)

## 🧠 JavaScript Logic

### Search Weather
![alt text](assets/image/SeachWeather.png)
- Handle when user click enter or right click on the search button whehter the name of city correct or not then present the error

- If city is valid simultaneously call api of forecast and weather in paralel

### Fetch Weather and Fetch Forecast
![alt text](assets/image/FetchWeather.png)
![alt text](assets/image/FetchForecast.png)

- Call api and receive data in the envelope under name response so we need transform response to json file.

### Display Weather and Forecase
![alt text](assets/image/DisplayWeather.png)
![alt text](assets/image/DisplayWeatherForecast.png)
- When we get the data add the data into the html structure by using innerHTML

### Save & Load Recent Search
![alt text](assets/image/SaveRecentSearch.png)
- Store my recent in json format name recentSearches and store in the user hard drive when browrse need to retrived data come to that place.