/************************************/
/* 現在の日付表示のコード */
/***********************************/

// 初期表示
displayDate();

// 1秒ごとに関数を呼び出す
setInterval(displayDate, 1000);

// 日付を表示する関数
function displayDate() {
  const now = new Date();

  // 日本の表記で日付と曜日をそれぞれ取得
  const dateOptions = { year: "numeric", month: "2-digit", day: "2-digit" };
  const weekdayOptions = { weekday: "short" };
  const currentDate = now.toLocaleDateString("ja-JP", dateOptions);
  const currentWeekday = now.toLocaleDateString("ja-JP", weekdayOptions);

  // HTML要素を取得
  const dateElement = document.querySelector(".date");
  const weekdayElement = document.querySelector(".weekday");

  // 要素が存在する場合のみ表示を更新
  if (dateElement && weekdayElement) {
    dateElement.textContent = currentDate; // 日付部分
    weekdayElement.textContent = `(${currentWeekday})`; // 曜日部分
  }
}
