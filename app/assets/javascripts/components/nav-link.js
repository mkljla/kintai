$(document).ready(function () {
  // 現在のページのURLパスを取得
  const currentPath = window.location.pathname;

  // 各リンクをチェックしてクラスを追加
  $(".nav-link").each(function () {
    const linkPath = $(this).attr("href"); // リンクのhref属性を取得
    if (linkPath === currentPath) {
      $(this).addClass("current"); // クラスを追加
    }
  });
});
