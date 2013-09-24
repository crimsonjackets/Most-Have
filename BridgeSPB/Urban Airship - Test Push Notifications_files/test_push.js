$(document).ready(function() {

    var write_it = function(json, selector) {
        $(selector).val($.toJSON(json));
    }

    function get_badge_value(badge_value) {
        var autobadge = false;
        if (badge_value == "auto") {
            autobadge = true;
        } else if (badge_value.indexOf("+") == 0) {
            autobadge = true;
        } else if (badge_value.indexOf("-") == 0) {
            autobadge = true;
        } else if (badge_value.indexOf("a") == 0) {
            // this allows them to type 'auto' without seeing 'NaN'
            autobadge = true;
        }
        if (autobadge) {
            return badge_value;
        } else {
            return parseInt(badge_value);
        }
    }

    var get_ios_payload = function() {
        payload = {"aps": {}}
        var dt = $("#id_device_token").val();
        if (dt) {
            payload["device_tokens"] = [dt]
        }
        var alias = $("#id_alias").val();
        if (alias) {
            payload["aliases"] = [alias]
        }
        var badge = $("#id_badge").val();
        if (badge) {
            payload["aps"]["badge"] = get_badge_value(badge);
        }
        var ios_alert = $("#id_alert").val();
        if (ios_alert) {
            payload["aps"]["alert"] = ios_alert;
        }
        var sound = $("#id_sound").val();
        if (sound) {
            payload["aps"]["sound"] = sound;
        }
        write_it(payload, "#id_payload");
    }

    var get_android_payload = function() {
    payload = {"android": {}}
    var apid = $("#apt_apid").val();
    if (apid) {
        payload["apids"] = [apid];
    }
    var adk_alert = $("#apt_alert").val();
    if (adk_alert) {
        payload["android"]["alert"] = adk_alert;
    }
    var extra_key = $("#apt_extra_key").val();
    var extra_value = $("#apt_extra_value").val();
    if (extra_key) {
        payload["android"]["extra"] = {}
        payload["android"]["extra"][extra_key] = extra_value;
    }
    write_it(payload, "#apt_payload")
    }

    var get_bb_payload = function() {
    payload = {"blackberry": {}}
    var device_pin = $("#bb_device_pin").val();
    if (device_pin) {
        payload["device_pins"] = [device_pin];
    }
    var content_type = $("#bb_content_type").val();
    if (content_type) {
        payload["blackberry"]["content-type"] = content_type;
    }
    var body = $("#bb_body").val();
    if (body) {
        payload["blackberry"]["body"] = body;
    }
    write_it(payload, "#bb_payload")
    }

    var get_win_he_payload = function() {
      var payload = {"notification": {"windows7": {}}}
        , apid = $("#win_apid").val()
        , win_alert = $("#win_alert").val()
        , extra_key = $("#win_extra_key").val()
        , extra_value = $("#win_extra_value").val()
        , win_he_payload = payload.notification.windows7

      if(apid) {
        payload.windows7 = [apid]
      }
      if(win_alert) {
        win_he_payload.alert = win_alert
      }
      if(extra_key) {
        win_he_payload.extra = {}
        win_he_payload.extra[extra_key] = extra_value
      }
      write_it(payload, "#win_payload")
    }

    var get_wns_payload = function() {
      var payload = {"notification": {"wns": {"toast": {"binding": {"template": "ToastText01", "text": []}}, "type": "toast"}}, 'device_types': ['wns']}
        , apid = $("#wns_apid").val()
        , wns_alert = $("#wns_alert").val()
        , wns_payload = payload.notification.wns

      if(apid) {
        payload.wns = [apid]
      }
      if(wns_alert) {
        wns_payload.toast.binding.text = [wns_alert]
      }
      write_it(payload, "#wns_payload")
    }

    var get_mpns_payload = function() {
      var payload = {"notification": {"mpns": {"toast": {"text2": ""}, "type": "toast"}}, 'device_types': ['mpns']}
        , apid = $("#mpns_apid").val()
        , mpns_alert = $("#mpns_alert").val()
        , mpns_payload = payload.notification.mpns

      if(apid) {
        payload.mpns = [apid]
      }
      if(mpns_alert) {
        mpns_payload.toast.text2 = mpns_alert
      }
      write_it(payload, "#mpns_payload")
    }

    get_ios_payload()
    get_android_payload()
    get_bb_payload()
    get_win_he_payload()
    get_wns_payload()
    get_mpns_payload()
    $('#tab-ios-content input').keyup(get_ios_payload)
    $('#ios-broadcast input').keyup(get_ios_payload)
    $('#tab-android-content input').keyup(get_android_payload)
    $('#tab-blackberry-content input').keyup(get_bb_payload)
    $('#tab-win_he-content input').keyup(get_win_he_payload)
    $('#tab-wns-content input').keyup(get_wns_payload)
    $('#tab-mpns-content input').keyup(get_mpns_payload)
});
