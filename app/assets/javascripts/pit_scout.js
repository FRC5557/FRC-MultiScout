var queue = [];
var position = 0;
var online = false;

$(document).ready(function(){
  checkOnline();
  restoreAll();
  window.setInterval(checkOnline, 10000);
});

function nextTeam() {
  if(position > -1 && (position + 1) < queue.length) {
    var current_id = 'team_' + queue[position].number;
    var next_id = 'team_' + queue[position + 1].number;
    position++;

    $("#" + current_id).hide();
    $("#" + next_id).show();

    if((position + 1) == queue.length) {
      $("#next_btn").hide();
    }
    if(position == 1) {
      $("#prev_btn").show();
    }

    $(".id-pos").html(position + 1);
    $(".id-total").html(queue.length);
  }
}

function prevTeam() {
  if((position - 1) > -1 && position < queue.length) {
    var current_id = 'team_' + queue[position].number;
    var prev_id = 'team_' + queue[position - 1].number;
    position--;

    $("#" + current_id).hide();
    $("#" + prev_id).show();

    if(position == 0) {
      $("#prev_btn").hide();
    }
    if((position + 2) == queue.length) {
      $("#next_btn").show();
    }

    $(".id-pos").html(position + 1);
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

function save(number) {
  localStorage.setItem('team_' + number, JSON.stringify($('#teamform_' + number).serializeArray()));
  $("#saved_" + number).fadeIn();
  window.setTimeout(function(){ $("#saved_" + number).fadeOut(); }, 2000);
}

function restore(number) {
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
    restore(queue[index].number);
  }
}
