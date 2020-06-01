const body = document.getElementsByTagName('body')[0];

const IMG_NUMBER = 7;

function paintImage(imgNumber) {
    const image = new Image();
//     image.src = `/ChaCha/images/${imgNumber}.jpg`;
    image.src = `/ChaCha/images/4.jpg`;
//    image.src = "../images/7.jpg";

    image.classList.add("bgImage");
    body.appendChild(image);
}

function genRandom(params) {
    const number = parseInt(Math.random()*IMG_NUMBER+1);
    return number;
}

function init(){
    const randomNumber = genRandom();
    paintImage(randomNumber);
}

init();
