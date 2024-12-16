$(document).ready(function () {
  // ページのロード後、bodyのコントローラーとアクションを確認
  const body = $("body");
  const controller = body.data("controller");
  const action = body.data("action");

  // コントローラーが"works"で、アクションが"show"の場合にタイムラインを初期化
  if (controller === "works" && action === "show") {
    initializeTimeline();
  }
});

// タイムラインの初期化関数
function initializeTimeline() {
  const appElement = $("#app");
  const userId = appElement.data("user-id"); // ユーザーIDを取得
  const workId = appElement.data("work-id"); // 作業IDを取得

  if (!userId || !workId) {
    console.error("Missing user ID or work ID."); // 必要なデータがない場合にエラーを表示
    return;
  }

  fetchTimelineData(userId, workId); // タイムラインデータの取得を実行
}

// タイムラインデータを非同期で取得
function fetchTimelineData(userId, workId) {
  $.ajax({
    url: `/users/${userId}/works/${workId}/get_timeline_data`, // APIエンドポイント
    method: "GET",
    dataType: "json",
    success: function (data) {
      console.log("Fetched timeline data:", data);
      if (validateTimelineData(data)) {
        renderTimelineChart(data); // データが有効ならタイムラインを描画
      }
    },
    error: function (xhr, status, error) {
      console.error("Error fetching timeline data:", error); // エラー発生時にログを出力
    },
  });
}

// 取得したタイムラインデータを検証
function validateTimelineData(data) {
  if (!data || !data.start_time) {
    console.error("Invalid timeline data:", data); // 無効なデータの場合エラーを表示
    return false;
  }
  return true;
}

// タイムラインチャートをレンダリング
function renderTimelineChart(data) {
  google.charts.load("current", { packages: ["timeline"] }); // Googleチャートをロード
  google.charts.setOnLoadCallback(() => drawTimelineChart(data)); // チャートの描画をコールバック
}

// タイムラインチャートを描画
function drawTimelineChart(data) {
  const container = document.getElementById("timeline"); // タイムラインのDOM要素を取得
  const chart = new google.visualization.Timeline(container); // タイムラインチャートを初期化
  const dataTable = prepareTimelineData(data); // データを準備

  // 開始時刻と終了時刻を指定
  const startOfDay = createSpecificTime(data.start_time, 5, 0); // 05:00
  const endOfDay = createSpecificTime(data.start_time, 23, 0); // 23:00

  // チャートのオプション設定
  const options = {
    alternatingRowStyle: false,
    timeline: {
      colorByRowLabel: false, // 行ラベルごとに色を分けない
      showRowLabels: false, // 行ラベルを非表示
      groupByRowLabel: true, // ラベルごとにグループ化
    },
    hAxis: {
      minValue: startOfDay, // チャートの開始時間
      maxValue: endOfDay, // チャートの終了時間
      format: "H:mm", // 時間形式
      textStyle: { bold: false }, // テキストスタイル設定
    },
  };

  chart.draw(dataTable, options); // チャートを描画
}

// タイムラインデータをGoogleチャート用に準備
function prepareTimelineData(data) {
  const dataTable = new google.visualization.DataTable();
  dataTable.addColumn({ type: "string", id: "Position" }); // 列: ポジション
  dataTable.addColumn({ type: "string", id: "Name" }); // 列: 名前
  dataTable.addColumn({ type: "date", id: "Start" }); // 列: 開始時刻
  dataTable.addColumn({ type: "date", id: "End" }); // 列: 終了時刻

  const workStart = new Date(data.start_time); // 勤務開始時刻
  const workEnd = data.end_time ? new Date(data.end_time) : new Date(); // 勤務終了時刻

  if (data.breaks && data.breaks.length > 0) {
    let previousEnd = workStart;

    // 休憩データを処理
    data.breaks.forEach((breakTime) => {
      const breakStart = new Date(breakTime.start_time);
      const breakEnd = breakTime.end_time
        ? new Date(breakTime.end_time)
        : new Date();

      // 勤務時間を休憩前に分けて追加
      if (previousEnd < breakStart) {
        dataTable.addRow(["勤務", "勤務", previousEnd, breakStart]);
      }

      // 休憩時間を追加
      dataTable.addRow(["休憩", "休憩", breakStart, breakEnd]);
      previousEnd = breakEnd;
    });

    // 最後の勤務時間を追加
    if (previousEnd < workEnd) {
      dataTable.addRow(["勤務", "勤務", previousEnd, workEnd]);
    }
  } else {
    // 休憩がない場合の勤務時間を追加
    dataTable.addRow(["勤務", "勤務", workStart, workEnd]);
  }

  return dataTable;
}

// 特定の時間を生成
function createSpecificTime(baseTime, hours, minutes) {
  const specificTime = new Date(baseTime);
  specificTime.setHours(hours, minutes, 0, 0);
  return specificTime;
}

// 日時を"HH:mm"形式にフォーマット
function formatTime(date) {
  const d = new Date(date);
  return (
    d.getHours().toString().padStart(2, "0") +
    ":" +
    d.getMinutes().toString().padStart(2, "0")
  );
}
