/************************************/
/* 現在の日付表示のコード */
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

  // HTML要素を取得
  const dateElement = document.querySelector(".date");

  // .date が存在する場合のみ時間を表示する
  if (dateElement) {
    dateElement.textContent = currentDate;
  }
}
