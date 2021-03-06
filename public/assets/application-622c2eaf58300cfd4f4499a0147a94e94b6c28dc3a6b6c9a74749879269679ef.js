// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
;
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
;
var queue = [];
var match_queue = [];
var t_position = 0;
var m_position = 0;
var online = false;

$(document).ready(function(){
  checkOnline();
  restoreAll();
  window.setInterval(checkOnline, 10000);
});

function increment(id) {
  var current = parseInt($("#" + id).val());
  $("#" + id).val(current + 1);
  $("#" + id + "_disp").html(current + 1);
}

function decrement(id) {
  var current = parseInt($("#" + id).val());
  if(current > 0) {
    $("#" + id).val(current - 1);
    $("#" + id + "_disp").html(current - 1);
  }
}

function nextMatch() {
  if(m_position > -1 && (m_position + 1) < match_queue.length) {
    var mid = match_queue[m_position].competition_stage + '_' + match_queue[m_position].set_number + '_' + match_queue[m_position].match_number;
    var nmid = match_queue[m_position + 1].competition_stage + '_' + match_queue[m_position + 1].set_number + '_' + match_queue[m_position + 1].match_number;
    var current_id = 'match_' + mid;
    var next_id = 'match_' + nmid;
    m_position++;

    $("#" + current_id).hide();
    $("#" + next_id).show();

    if((m_position + 1) == match_queue.length) {
      $("#next_btn").hide();
    }
    if(m_position == 1) {
      $("#prev_btn").show();
    }

    $(".id-pos").html(m_position + 1);
    $(".id-total").html(match_queue.length);
  }
}

function prevMatch() {
  if(m_position > -1 && m_position < match_queue.length) {
    var mid = match_queue[m_position].competition_stage + '_' + match_queue[m_position].set_number + '_' + match_queue[m_position].match_number;
    var pmid = match_queue[m_position - 1].competition_stage + '_' + match_queue[m_position - 1].set_number + '_' + match_queue[m_position - 1].match_number;
    var current_id = 'match_' + mid;
    var prev_id = 'match_' + pmid;
    m_position--;

    $("#" + current_id).hide();
    $("#" + prev_id).show();

    if(m_position == 0) {
      $("#prev_btn").hide();
    }
    if((m_position + 2) == queue.length) {
      $("#next_btn").show();
    }

    $(".id-pos").html(m_position + 1);
    $(".id-total").html(match_queue.length);
  }
}

function nextTeam() {
  if(t_position > -1 && (t_position + 1) < queue.length) {
    var current_id = 'team_' + queue[t_position].number;
    var next_id = 'team_' + queue[t_position + 1].number;
    t_position++;

    $("#" + current_id).hide();
    $("#" + next_id).show();

    if((t_position + 1) == queue.length) {
      $("#next_btn").hide();
    }
    if(t_position == 1) {
      $("#prev_btn").show();
    }

    $(".id-pos").html(t_position + 1);
    $(".id-total").html(queue.length);
  }
}

function prevTeam() {
  if((t_position - 1) > -1 && t_position < queue.length) {
    var current_id = 'team_' + queue[t_position].number;
    var prev_id = 'team_' + queue[t_position - 1].number;
    t_position--;

    $("#" + current_id).hide();
    $("#" + prev_id).show();

    if(t_position == 0) {
      $("#prev_btn").hide();
    }
    if((t_position + 2) == queue.length) {
      $("#next_btn").show();
    }

    $(".id-pos").html(t_position + 1);
    $(".id-total").html(queue.length);
  }
}

function checkOnline() {
  $.get('/ping.json')
  .done(function() {
    online = true;
    $("#conn_status").html("Online").removeClass('label-danger').addClass('label-success');
    $(".online-submit").removeClass('disabled').prop('disabled', false);
  })
  .fail(function() {
    online = false;
    $("#conn_status").html("Offline").removeClass('label-success').addClass('label-danger');
    $(".online-submit").addClass('disabled').prop('disabled', true);
  });
}

function saveMatch(mid) {
  localStorage.setItem('match_' + mid, JSON.stringify($('#matchform_' + mid).serializeArray()));
  $("#saved_" + mid).fadeIn();
  window.setTimeout(function(){ $("#saved_" + mid).fadeOut(); }, 2000);
}

function saveTeam(number) {
  localStorage.setItem('team_' + number, JSON.stringify($('#teamform_' + number).serializeArray()));
  $("#saved_" + number).fadeIn();
  window.setTimeout(function(){ $("#saved_" + number).fadeOut(); }, 2000);
}

function clearTeam(number) {
  localStorage.removeItem('team_'+ number)
}

function restoreMatch(mid) {
  var data = localStorage.getItem('match_' + mid);
  if (data != null) {
    var array = JSON.parse(data);
    for(var i = 0; i < array.length; i++) {
      var value = array[i];
      var id = value.name.replace(new RegExp('\\[','g'),'_').replace(new RegExp('\\]', 'g'),'')
      if (value.name.includes('_select')) {
        $('#' + id + '_' + value.value).prop('checked', true);
      } else if(value.name.includes('_check')) {
        $('#' + id).prop('checked', true);
      } else if(value.name.includes('_counter')) {
        $('#' + id).val(value.value);
        $('#' + id + '_disp').html(value.value);
      } else {
        $('#' + id).val(value.value);
      }
    }
  }
}

function restoreTeam(number) {
  var data = localStorage.getItem('team_' + number);
  if (data != null) {
    var array = JSON.parse(data);
    for(var i = 0; i < array.length; i++) {
      var value = array[i];
      var id = value.name.replace(new RegExp('\\[','g'),'_').replace(new RegExp('\\]', 'g'),'');
      if (value.name.includes('_select')) {
        $('#' + id + '_' + value.value).prop('checked', true);
      } else if(value.name.includes('_check')) {
        $('#' + id).prop('checked', true);
      } else {
        $('#' + id).val(value.value);
      }
    }
  }
}

function restoreAllMatches() {
  for(var index = 0; index < match_queue.length; index++) {
    var mid = match_queue[index].competition_stage + '_' + match_queue[index].set_number + '_' + match_queue[index].match_number
    restoreMatch(mid);
  }
}

function restoreAll() {
  for(var index = 0; index < queue.length; index++) {
    restoreTeam(queue[index].number);
  }
}

function getMousePos(canvas, evt) {
    var rect = canvas.getBoundingClientRect();
    return {
      x: evt.clientX - rect.left,
      y: evt.clientY - rect.top
    };
}

function processDraw(e, id) {
  var canvas = document.getElementById(id);
  var context = canvas.getContext("2d");
  var pos = getMousePos(canvas, e);
  var posx = pos.x;
  var posy = pos.y;
  context.clearRect(0, 0, canvas.width, canvas.height);
  context.fillStyle = "red";
  context.beginPath();
  context.arc(posx, posy, 5, 0, 2*Math.PI);
  context.fill();

  $("#" + id.replace('_pic','_y')).val(posy);
  $("#" + id.replace('_pic','_x')).val(posx);
}
;
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

;
