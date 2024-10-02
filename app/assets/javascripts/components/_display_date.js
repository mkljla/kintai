/************************************/
/* デジタル時計のコード（ゼロパディングあり）*/
/***********************************/

// 初期表示
displayDate();

//1秒ごとに関数を呼び出す。
setInterval(displayDate, 1000);

// 日付を表示する関数
function displayDate() {
  const now = new Date();
  const options = { year: "numeric", month: "long", day: "numeric", weekday: "long" };
  const currentDate = now.toLocaleDateString("ja-JP", options);
  document.querySelector(".date").textContent = currentDate;
}
