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

  // 月と日をそれぞれ取得
  const month = now.getMonth() + 1; // getMonth() は 0 ベースなので +1
  const day = now.getDate();
  const weekdayOptions = { weekday: "short" };
  const currentWeekday = now.toLocaleDateString("ja-JP", weekdayOptions);

  // HTML要素を取得
  const dateElement = document.querySelector(".date");
  const weekdayElement = document.querySelector(".weekday");

  // 要素が存在する場合のみ表示を更新
  if (dateElement && weekdayElement) {
    dateElement.textContent = `${month}月${day}日`; // 月日部分
    weekdayElement.textContent = `(${currentWeekday})`; // 曜日部分
  }
}
