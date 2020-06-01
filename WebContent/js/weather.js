const weather = document.getElementsByClassName("js-weather")[0];
const API_KEY = "9455d02e5afa781db91771de070c7271";
const COORDS = "coords";

function getWeather(lat, lon) {
    fetch(
        `https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${API_KEY}&units=metric`
    ).then(function (response) {
        // console.log(response.json());
        return response.json();
    }).then(function (json) {
        console.log(json);
        const temperature = json.main.temp;
        const place = json.name;
        const description = json.weather[0].description;
        weather.innerHTML = `${Math.round(temperature)} ℃ @ ${place} <br> ${description}`;
    });
}

function saveCoords(coordsObj) {
    localStorage.setItem(COORDS, JSON.stringify(coordsObj));
};

function handleGeoSucces(position) {
    console.log(position);

    const latitude = position.coords.latitude;
    const longitude = position.coords.longitude;

    console.log(latitude, longitude);

    const coordsObj = {
        latitude,   // latitude: latitude
        longitude   // longitude: longitude
    };
    saveCoords(coordsObj);
    getWeather(latitude, longitude);
}

function handleGeoError() {
    console.log("위치정보를 불러올 수 없음");
}

function askForCoords() {
    navigator.geolocation.getCurrentPosition(handleGeoSucces, handleGeoError)
}

function loadCoords() {
    const loadedCoords = localStorage.getItem(COORDS);
    if (loadedCoords === null) {
        askForCoords();
    } else {
        // get weather
        const parseCoords = JSON.parse(loadedCoords);
        console.log(parseCoords)
        getWeather(parseCoords.latitude, parseCoords.longitude);
    }


}

function init() {
    loadCoords();

}
init();