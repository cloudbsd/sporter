// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require jquery.ui.datepicker-zh-CN
//- require jquery-ui-timepicker-addon
//- require jquery-ui-timepicker-zh-CN
//= require turbolinks
//= require bootstrap
//= require_tree .


window.setTimeout(function() {
  $("div.alert").fadeTo(500, 0).slideUp(500, function() {
    $(this).remove();
  });
}, 2000);

function isVisible(obj) {
  return obj.offsetWidth > 0 && obj.offsetHeight > 0;
}
