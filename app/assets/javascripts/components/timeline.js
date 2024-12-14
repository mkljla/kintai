
$(document).ready(function() {
    const body = $('body');
    const controller = body.data('controller');  // data-controller 属性取得
    const action = body.data('action');          // data-action 属性取得

    // 指定したコントローラーとアクションでのみ実行
    if (controller === 'works' && action === 'show') {
        const user_id = $('#app').data('user-id'); // データ属性から取得
        const work_id = $('#app').data('work-id'); // データ属性から取得


        // 非同期でタイムラインデータを取得
        $.ajax({
            url: `/users/${user_id}/works/${work_id}/get_timeline_data`,  // APIエンドポイント
            method: 'GET',                    // リクエストのメソッド
            dataType: 'json',                 // 期待するレスポンス形式

            success: function(data) {
            // console.log("取得成功")
            // 取得したデータを処理する
            createTimeline(data);
            },

            error: function(xhr, status, error) {
            console.error('Error fetching timeline data:', error);
            // console.log("失敗")
            }
        });
    };
});


function createTimeline(data) {
    if (!data || !data.start_time) {
        return; // dataが欠けている場合、処理を停止
    }
    google.charts.load("current", { packages: ["timeline"] });
    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {
        var container = document.getElementById('timeline');
        var chart = new google.visualization.Timeline(container);
        var dataTable = new google.visualization.DataTable();
        dataTable.addColumn({ type: 'string', id: 'Position' });
        dataTable.addColumn({ type: 'string', id: 'Name' });
        dataTable.addColumn({ type: 'date', id: 'Start' });
        dataTable.addColumn({ type: 'date', id: 'End' });

        // 勤務時間データを追加
        var workStart = new Date(data.start_time);
        var workEnd = data.end_time ? new Date(data.end_time) : new Date();

        // 休憩データが存在する場合に処理
        if (data.breaks && data.breaks.length > 0) {
            var previousEnd = workStart;

            // 休憩時間をそのままタイムラインに追加
            data.breaks.forEach(function (break_time) {
                var breakStart = new Date(break_time.start_time);
                var breakEnd = break_time.end_time ? new Date(break_time.end_time) : new Date();

                // 勤務時間を休憩前に分ける
                if (previousEnd < breakStart) {
                    dataTable.addRow(['勤務', '勤務', previousEnd, breakStart]);
                }

                // 休憩時間を追加
                dataTable.addRow(['休憩', '休憩', breakStart, breakEnd]);

                // 休憩終了後の勤務時間
                previousEnd = breakEnd;
            });

            // 最後の勤務時間を追加
            if (previousEnd < workEnd) {
                dataTable.addRow(['勤務', '勤務', previousEnd, workEnd]);
            }

        } else {
            // 休憩がない場合はそのまま勤務時間を追加
            dataTable.addRow(['勤務', '勤務', workStart, workEnd]);
        }

        // data.start_timeの日付を基にその日の6:00と22:00を設定
        var startOfDay = new Date(data.start_time);
        startOfDay.setHours(5, 0, 0, 0);

        var endOfDay = new Date(data.start_time);
        endOfDay.setHours(23, 0, 0, 0);

        // タイムラインのオプションを設定
        var options = {
            alternatingRowStyle: false, // 背景色を交互に変更
            timeline: {
                colorByRowLabel: false,  // 行ラベルごとに色を分ける
                alternatingRowStyle: false,  // 行を交互に色分け
                showRowLabels: false,  // 行ラベルの表示有無
                groupByRowLabel: true, // グループ化（休憩と勤務でグループ化）
            },
            hAxis: {
                minValue: startOfDay,  // data.start_timeの日付の6:00
                maxValue: endOfDay,  // もし現在時刻が22:00を超えていれば、現在時刻を最大値として設定
                format: 'H:mm',        // ゼロなしの24時間形式で表示
            }
        };

        // チャートを描画
        chart.draw(dataTable, options);
    }
}

// "HH:mm" 形式にフォーマット
function formatTime(date) {
    var d = new Date(date);
    return d.getHours().toString().padStart(2, '0') + ":" + d.getMinutes().toString().padStart(2, '0');
}