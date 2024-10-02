/************************************/
/* デジタル時計のコード（ゼロパディングあり）*/
/***********************************/

displayTime();
//1秒ごとに関数を呼び出す。
setInterval(displayTime, 1000);

function displayTime() {
  //ゼロパディングして2桁にする
  const padZero = (value) => value.toString().padStart(2, "0");
  //現在日時を持つnowという名前のオブジェクトを作る。
  const now = new Date();
  //現在の時、分、秒を取得して変数に格納する。
  const hour = padZero(now.getHours());
  const minute = padZero(now.getMinutes());
  const second = padZero(now.getSeconds());

  //現在時刻を文字列として変数に格納する。
  const currentTime = `${hour}:${minute}:${second}`;
  //HTML要素を取得し現在時刻を表示する。
  document.querySelector(".clock").textContent = currentTime;
}
