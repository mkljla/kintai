/************************************/
/* デジタル時計のコード */
/***********************************/

// 初期表示
displayTime();

// 1秒ごとに関数を呼び出す。
setInterval(displayTime, 1000);

// 時間を表示する関数
function displayTime() {
  // ゼロパディングして2桁にする
  const padZero = (value) => value.toString().padStart(2, "0");
  // 現在日時を持つnowという名前のオブジェクトを作る。
  const now = new Date();
  // 現在の時、分、秒を取得して変数に格納する。
  const hour = padZero(now.getHours());
  const minute = padZero(now.getMinutes());
  const second = padZero(now.getSeconds());

  // 現在時刻を文字列として変数に格納する。
  const currentTime = `${hour}:${minute}:${second}`;

  // HTML要素を取得
  const clockElement = document.querySelector(".clock");

  // .clock が存在する場合のみ時間を表示する
  if (clockElement) {
    clockElement.textContent = currentTime;
  }
}
