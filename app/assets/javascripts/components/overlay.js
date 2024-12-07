$(document).ready(function () {
  console.log("ページが読み込まれました"); // デバッグ用

  $("#reset-demo-data-button").on("click", function () {
    if (!confirm("リセットした後はログアウトされます。実行しますか？")) {
      return; // 「キャンセル」時は処理を中断
    }

    $("#overlay").show(); // オーバーレイを表示

    // AJAXリクエストを送信
    $.ajax({
      url: "/reset_demo_data", // リセット処理のパス
      method: "POST",
      success: function (response) {
        // オーバーレイを非表示にし、フラッシュメッセージを表示
        $("#overlay").hide();
        alert("リセットが完了しました。再ログインしてください。");
        window.location.reload();
      },
      error: function () {
        console.log("リセット失敗");
        // オーバーレイを非表示にし、エラーメッセージを表示
        $("#overlay").hide();

        alert("リセットに失敗しました。再試行してください。");
      },
    });
  });
});
