define(function(require) {
  // Popover function
  (function ($) {
    var popmouse = false;
    $.fn.popover = function () {
      $(this).click(
        function (e) {
          e.preventDefault();
          var trigger = $(this);
          var popover = $(trigger).parent().find(".popover");
          if ($(popover).is(':visible')) {
            // close the popover if it's already showing
            $().clearpop();
          } else {
            // wipe existing popovers
            $().clearpop();
            // mark trigger active
            $(trigger).addClass("active");
            // on trigger click
            $(popover).fadeIn('fast',
                              function () {
                                // focus the first input if popover has any
                                if ($(this).find('input').length) {
                                  $('input:first').focus();
                                }
                              }).show().hover(function () {
                                                // on popover hover
                                                var popmouse = true;
                                              }, function () {
                                                // on popover hover out
                                                var popmouse = false;
                                              });

          }
        }).hover(function () {
                   // on trigger hover
                   var popmouse = true;
                 }, function () {
                   // on trigger hover out
                   var popmouse = false;
                 });

    };

    $.fn.clearpop = function () {
      if (!popmouse) {
        var popover = $(".popover");
        var trigger = $(popover).parent().find("a.active");
        $(trigger).removeClass("active");
        $(popover).fadeOut("fast");
      }
    };

    $.fn.addcommas = function () {
      var commatize = function (num) {
        num += '';
        if (isNaN(num)) {
          return $(this);
        }
        num_split = num.split('.');
        num_split_1 = num_split[0];
        num_split_2 = num_split.length > 1 ? '.' + num_split[1] : '';
        var rgx = /(\d+)(\d{3})/;
        while (rgx.test(num_split_1)) {
          num_split_1 = num_split_1.replace(rgx, '$1' + ',' + '$2');
        }
        return num_split_1 + num_split_2;
      };

      var raw_num = $(this).text();
      var nice_num = commatize(raw_num);
      return $(this).text(nice_num);
    };

  })(jQuery);

  $(document).ready(function () {
    // popover menus
    $("#account-popover, #support-popover, .appselect_button, .create-btn, .new-message").popover();
    // $(".inside, .footer").bind("mouseup", function () {
    //   $().clearpop();
    // });

    $(document).keydown(function (e) {
      // ESCAPE key pressed
      if (e.keyCode == 27) {
        $().clearpop();
      }
    });

  });
})
