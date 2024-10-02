/************************************/
/* 表示中のメニューにactivクラスを付与するスクリプト */
/***********************************/

$(document).ready(function () {
  const links = $(".nav__item > a");

  // 現在のページURLを取得
  const currentUrl = window.location.href;

  links.each(function () {
    // 各リンクの href と現在の URL を比較
    if (this.href === currentUrl || currentUrl.includes(this.href)) {
      $(this).addClass("active");
    }
  });

  // もしどのリンクも一致しない場合（例：単に「#」のリンクなど）、最初のリンクをアクティブにする
  if ($(".nav__item > a.active").length === 0) {
    $(".nav__item > a").first().addClass("active");
  }

  // クリックイベント時にactiveクラスを更新
  links.on("click", function (e) {
    // すべてのリンクからactiveクラスを削除
    links.removeClass("active");

    // クリックされたリンクにactiveクラスを付与
    $(this).addClass("active");
  });
});
