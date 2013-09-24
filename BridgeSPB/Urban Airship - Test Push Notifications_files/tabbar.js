$(document).ready(function() {

    var check_tab_hash = function(hash) {
        hash = hash.split("#")[1];
        return $("#tab-" + hash + "-content").is(".tab-content");
    }

    $('.tabbar a').bind('click', function(e) {
      e.preventDefault();
      $('.tabbar a').removeClass("on");
      $(this).addClass("on");
      $('.tab-content').hide();
      document.location.hash = this.id.split("tab-")[1];
      $("#" + this.id + "-content").show();
    });

    if ((document.location.hash.length > 0) && check_tab_hash(document.location.hash)) {
      var hash = document.location.hash.split("#")[1];
      $('.tabbar a').removeClass("on");
      $("#tab-" + hash).addClass("on");
      $('.tab-content').hide();
      $("#tab-" + hash + "-content").show();
    } else if (document.location.hash.length == 0) {
      $('.tabbar > a:first-child').addClass('on');
      $('.tab-content:first-child').show();
    };

})
