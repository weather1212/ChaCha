const greeting = document.getElementsByClassName("js-greetings")[0];

const memberID = $('#session_id').val();

console.log("memberID = " + memberID);

function paintGreeting(text) {
	greeting.style.display = "block";
	greeting.innerHTML = "Hello " + text;
	console.log("paintGreeting 실행");
}

function loadName() {
	const currentUser = memberID
	if (currentUser === null) {
		console.log("저장된 유저 없음");
	} else {
		console.log("유저 있음");
		paintGreeting(currentUser);
	}

}

function init() {
	loadName();
}
init();