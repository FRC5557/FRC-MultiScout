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

function saveTeam(number) {
  localStorage.setItem('team_' + number, JSON.stringify($('#teamform_' + number).serializeArray()));
  $("#saved_" + number).fadeIn();
  window.setTimeout(function(){ $("#saved_" + number).fadeOut(); }, 2000);
}

function clearTeam(number) {
  localStorage.removeItem('team_'+ number)
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

function restoreAll() {
  for(var index = 0; index < queue.length; index++) {
    restoreTeam(queue[index].number);
  }
}
