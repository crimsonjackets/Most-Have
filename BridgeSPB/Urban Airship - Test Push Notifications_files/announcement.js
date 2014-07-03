define(function(require) {
  $(".announcement_mark_read a").click(function (e) {
    e.preventDefault();
    var toHide = $(this).closest("div.announcement");
    $.getJSON($(this).attr("href"), function (data) {
      if (data.ok) {
        toHide.hide();
      }
    });
  });
})
