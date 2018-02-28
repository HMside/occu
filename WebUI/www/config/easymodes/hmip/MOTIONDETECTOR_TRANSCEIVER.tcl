#!/bin/tclsh

source [file join $env(DOCUMENT_ROOT) config/easymodes/em_common.tcl]
source [file join $env(DOCUMENT_ROOT) config/easymodes/EnterFreeValue.tcl]
source [file join $env(DOCUMENT_ROOT) config/easymodes/etc/uiElements.tcl]
source [file join $env(DOCUMENT_ROOT) config/easymodes/etc/hmipAlarmPanel.tcl]

set PROFILE_PNAME(A) "\${stringTableEventFilterNumber}"
set PROFILE_PNAME(B) "\${stringTableEventFilterPeriod}"
set PROFILE_PNAME(C) "\${stringTableMotionDetectorMinInterval}"
set PROFILE_PNAME(D) "\${stringTableBrightnessFilter}"
set PROFILE_PNAME(F) "\${motionDetectorSendMotionWithinDetectionSpan}"
set PROFILE_PNAME(G) "\${stringTablePirOperationMode}"
set PROFILE_PNAME(H) "\${stringTableCondThresholdLo}"
set PROFILE_PNAME(I) "\${stringTableMotionDetectorMotionActiveTime}"

proc getHelp {topic x y} {
  return "<img src=\"/ise/img/help.png\" style=\"cursor: pointer; width:18px; height:18px; position:relative; top:2px\" onclick=\"showParamHelp('$topic', '$x', '$y')\">"
}

proc set_htmlParams {iface address pps pps_descr special_input_id peer_type} {

  puts "<script type=\"text/javascript\">load_JSFunc('/config/easymodes/js/ic_effects.js');</script>"
  puts "<script type=\"text/javascript\">load_JSFunc('/config/easymodes/MASTER_LANG/MOTION_DETECTOR.js');</script>"

  global iface_url global psDescr

  upvar HTML_PARAMS   HTML_PARAMS
  upvar PROFILE_PNAME PROFILE_PNAME
  upvar $pps          ps
  upvar $pps_descr  psDescr

  upvar #0 unit_sec s
  upvar #0 unit_min m

  set brightness "0"
  set chn [lindex [split $address :] 1]

  set url $iface_url($iface)
  array set dev_descr [xmlrpc $url getParamset [list string $address] MASTER]
  set capture_within_interval  $dev_descr(CAPTURE_WITHIN_INTERVAL)

  set help_txt "\${motionDetectorHelp}"
  set xmlCatchError [catch {set brightness [format "%.0f" [xmlrpc $iface_url($iface) getValue [list string $address] [list string ILLUMINATION]]]}]

  set hlpBoxWidth 450
  set hlpBoxHeight 80

###

  append HTML_PARAMS(separate_1) "<table class=\"ProfileTbl\">"
    append HTML_PARAMS(separate_1) "<tr><td><span class=\"stringtable_value\">$PROFILE_PNAME(A)</span></td><td id=\"Hm\">\${mdTrigger}"
    array_clear options

    set prn 1

    for {set i 1} {$i <= 15} {incr i} {
      set options($i) $i
    }

    append HTML_PARAMS(separate_1) [get_ComboBox options EVENT_FILTER_NUMBER separate_${special_input_id}_1 ps EVENT_FILTER_NUMBER "onchange=\"MD_init(\'separate_${special_input_id}_1\', 1, 15)\"" ]
    append HTML_PARAMS(separate_1) "<span class=\"event_filter_number\"> Sensor-Impulsen innerhalb <span>"
    append HTML_PARAMS(separate_1) "<script type=\"text/javascript\">MD_init(\'separate_${special_input_id}_$prn\', 1, 15)</script>"

    array_clear options
    set options(0.5) "0.5"
    set options(1.0) "1.0"
    set options(1.5) "1.5"
    set options(2.0) "2.0"
    set options(2.5) "2.5"
    set options(3.0) "3.0"
    set options(3.5) "3.5"
    set options(4.0) "4.0"
    set options(4.5) "4.5"
    set options(5.0) "5.0"
    set options(5.5) "5.5"
    set options(6.0) "6.0"
    set options(6.5) "6.5"
    set options(7.0) "7.0"
    set options(7.5) "7.5"

    incr prn; # 2
    append HTML_PARAMS(separate_1) [get_ComboBox options EVENT_FILTER_PERIOD separate_${special_input_id}_$prn ps EVENT_FILTER_PERIOD]
    append HTML_PARAMS(separate_1) "<span class=\"event_filter_number\">&nbsp;Sekunden</span></td></tr>"

     incr prn; #3
    append HTML_PARAMS(separate_1) "<tr><td><span class=\"stringtable_value\">$PROFILE_PNAME(C)</span></td><td>"
    array_clear options
    set options(0)  "15$s"
    set options(1)  "30$s"
    set options(2)  "1$m"
    set options(3)  "2$m"
    set options(4)  "4$m"
    set options(5)  "8$m"
    set options(6)  "16$m"

    append HTML_PARAMS(separate_1) "[get_ComboBox options MIN_INTERVAL separate_${special_input_id}_$prn ps MIN_INTERVAL ]&nbsp;[getHelp MIN_INTERVAL $hlpBoxWidth $hlpBoxHeight]"
    append HTML_PARAMS(separate_1) "</td></tr>"

    incr prn; #4
    append HTML_PARAMS(separate_1) "<tr><td colspan=\"2\"><span>$PROFILE_PNAME(F)</span>"
    if {$capture_within_interval == 1} {
      append HTML_PARAMS(separate_1) "<input type=\"checkbox\" id=\"separate\_${special_input_id}_$prn\" name=\"CAPTURE_WITHIN_INTERVAL\" checked=\"checked\"></td>"
    } else {
      append HTML_PARAMS(separate_1) "<input type=\"checkbox\" id=\"separate\_${special_input_id}_$prn\" name=\"CAPTURE_WITHIN_INTERVAL\"></td>"
    }


    incr prn; #5
    append HTML_PARAMS(separate_1) "<tr><td><span class=\"stringtable_value\">$PROFILE_PNAME(I)</span></td><td>"
    array_clear options
    set options(0)  "15$s"
    set options(1)  "30$s"
    set options(2)  "1$m"
    set options(3)  "2$m"
    set options(4)  "4$m"
    set options(5)  "8$m"
    set options(6)  "16$m"
    set options(7)  "32$m"

    append HTML_PARAMS(separate_1) [get_ComboBox options MOTION_ACTIVE_TIME separate_${special_input_id}_$prn ps MOTION_ACTIVE_TIME ]
    append HTML_PARAMS(separate_1) "</td></tr>"


    incr prn; #6
    append HTML_PARAMS(separate_1) "<tr><td><span class=\"stringtable_value\">$PROFILE_PNAME(D)</span></td><td>"
    array_clear  options

    for {set i 0} {$i <= 15} {incr i} {
      set options($i) [expr $i + 1]
    }

    append HTML_PARAMS(separate_1) [get_ComboBox options BRIGHTNESS_FILTER separate_${special_input_id}_$prn ps BRIGHTNESS_FILTER "onchange=\"MD_init(\'separate_${special_input_id}_$prn\', 0, 15)\""]
    append HTML_PARAMS(separate_1) " \${motionDetectorMinumumOfLastValuesA} <span class=\"brightness\">\${motionDetectorMinumumOfLastValuesB1} [expr $ps(BRIGHTNESS_FILTER) + 1] \${motionDetectorMinumumOfLastValuesC}</span> \${motionDetectorMinumumOfLastValuesD}</td></tr>"
    append HTML_PARAMS(separate_1) "<script type=\"text/javascript\">MD_init(\'separate_${special_input_id}_$prn\', 0, 15)</script>"

    incr prn; #7
    set param PIR_OPERATION_MODE
    append HTML_PARAMS(separate_1) "<tr>"
      append HTML_PARAMS(separate_1) "<td><span class=\"j_translate\">$PROFILE_PNAME(G)</span></td>"
      append HTML_PARAMS(separate_1) "<td>"
        array_clear options
        set options(0)  "\${pirOperationModeNormal}"
        set options(1)  "\${pirOperationModeEco}"
        # append HTML_PARAMS(separate_1) [get_ComboBox options $param separate_${special_input_id}_$prn ps $param "onchange=\"showEcoModeElement(this);\""] [getHelpIcon $param $hlpBoxWidth $hlpBoxHeight]
        append HTML_PARAMS(separate_1) [get_ComboBox options $param separate_${special_input_id}_$prn ps $param "onchange=\"showEcoModeElement(this);\""]
      append HTML_PARAMS(separate_1) "</td>"
    append HTML_PARAMS(separate_1) "</tr>"

    incr prn; #8
    set param COND_TX_THRESHOLD_LO
    append HTML_PARAMS(separate_1) "<tr id=\"txThresholdLo\" class=\"hidden\">"
      append HTML_PARAMS(separate_1) "<td>"
        append HTML_PARAMS(separate_1) "<span class=\"j_translate\">$PROFILE_PNAME(H)</span>"
      append HTML_PARAMS(separate_1) "</td>"
      append HTML_PARAMS(separate_1) "<td>"

        array_clear param_descr
        array set param_descr $psDescr($param)
        set minValue [format {%1.0f} $param_descr(MIN)]
        set maxValue [expr [format {%1.0f} $param_descr(MAX)] / 10]

        append HTML_PARAMS(separate_1) "<input id=\"_COND_TX_THRESHOLD_LO\_$prn\" size=\"5\" onblur=\"ProofAndSetValue(this.id, this.id, $minValue, $maxValue, 1); setCondLoValue($prn,this.value);\" >&nbsp;($minValue - $maxValue)"
        append HTML_PARAMS(separate_1) "[getTextField $param $ps($param) $chn $prn class=\"hidden\"]"
        append HTML_PARAMS(separate_1) "<script type=\"text/javascript\">window.setTimeout(function()\{jQuery(\"#_COND_TX_THRESHOLD_LO\_$prn\").val(parseInt($ps($param))/ 10);\},200);</script>"

        if {! $xmlCatchError} {
          set btnTxt "\${btnTakeCurrentBrightness}&nbsp;($brightness)"
          append HTML_PARAMS(separate_1) "[getButton getBrightness \"btnTakeCurrentBrightness\" setBrightness($prn);]"
          append HTML_PARAMS(separate_1) "<script type=\"text/javascript\">"
            append HTML_PARAMS(separate_1) "var elem = jQuery(\"#getBrightness\");"
            append HTML_PARAMS(separate_1) "if (elem) elem.val(elem.val() + \" ($brightness)\");"
          append HTML_PARAMS(separate_1) "</script>"
        }

      append HTML_PARAMS(separate_1) "</td>"
    append HTML_PARAMS(separate_1) "</tr>"

    # append HTML_PARAMS(separate_1) "[getAlarmPanel ps]"

  append HTML_PARAMS(separate_1) "</table>"

  append HTML_PARAMS(separate_1) "<table class=\"ProfileTbl\" id=\"md_ch_help\" style=\"display:none\">"
    append HTML_PARAMS(separate_1) "<tr><td id=\"helpText\">$help_txt</td></tr>"
  append HTML_PARAMS(separate_1) "</table>"

  append HTML_PARAMS(separate_1) "<script type=\"text/javascript\">"
    append HTML_PARAMS(separate_1) "st_setStringTableValues();"
    append HTML_PARAMS(separate_1) "jQuery(\"#md_help_button\").val(translateKey(\"genericBtnTxtHelp\"));"

    append HTML_PARAMS(separate_1) "showEcoModeElement = function(elm) \{"

      append HTML_PARAMS(separate_1) "var selVal = jQuery(elm).val(),"
      append HTML_PARAMS(separate_1) "txThresholdLoElm = jQuery(\"#txThresholdLo\");"

      append HTML_PARAMS(separate_1) "if (selVal == 0) {"
        append HTML_PARAMS(separate_1) "txThresholdLoElm.hide();"
      append HTML_PARAMS(separate_1) "} else {"
        append HTML_PARAMS(separate_1) "txThresholdLoElm.show();"
        append HTML_PARAMS(separate_1) "jQuery(txThresholdLoElm).get(0).scrollIntoView();"
      append HTML_PARAMS(separate_1) "}"

    append HTML_PARAMS(separate_1) "\};"

    append HTML_PARAMS(separate_1) "setCondLoValue = function(prn, value) \{"
      append HTML_PARAMS(separate_1) "jQuery(\"#separate_${special_input_id}_\"+prn).val(parseInt(value) * 10);"
    append HTML_PARAMS(separate_1) "\};"

    append HTML_PARAMS(separate_1) "setBrightness = function(prn) \{"
      append HTML_PARAMS(separate_1) "jQuery(\"#separate_${special_input_id}_\"+prn).val(parseInt($brightness) * 10);"
      append HTML_PARAMS(separate_1) "jQuery(\"#_COND_TX_THRESHOLD_LO_\"+prn).val(parseInt($brightness));"
    append HTML_PARAMS(separate_1) "\};"


    append HTML_PARAMS(separate_1) "showEcoModeElement(jQuery(\"\[name='PIR_OPERATION_MODE'\]\")\[0\]);"
  append HTML_PARAMS(separate_1) "</script>"
}
constructor
