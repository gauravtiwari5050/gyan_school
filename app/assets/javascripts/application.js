//= require jquery  
//= require jquery-ui  
//= require jquery_ujs 
//= require tinymce-jquery
//= require jquery.colorbox-min
//= require_self  
//= require_tree .  
  

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function load_file(id,key) {
  var scribd_doc = scribd.Document.getDoc( id, key );

  var oniPaperReady = function(e){
  // scribd_doc.api.setPage(3);
  }

  scribd_doc.addParam( 'jsapi_version', 1 );
  scribd_doc.addEventListener( 'iPaperReady', oniPaperReady );
  scribd_doc.write( 'embedded_flash' );
}

jQuery.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader("Accept", "text/javascript");
  }
});

jQuery(document).ready(function() {
    // put all your jQuery goodness in here.
  jQuery(".user-search").keyup(function() {
    $(".loading-image").show(); 
    jQuery.read(
     '/search/students',
    {username:jQuery(this).val()},
    function (response) {
      var html = '<h3> No users found with that name </h3>';
      if(response.length != 0) {
         html = '<table class=\'table table-striped\'>';
         html += '<tr><th>User Name</th> <th>Collect Fees</th> </tr>';
        for(var i = 0;i<response.length;i++) {
         var link_to_user = '<a href="/users/'+ response[i].id +'/profile">' + response[i].first_name +' ' + response[i].middle_name + response[i].last_name + '(' + response[i].email + ')' + ' </a>';
         html += '<td>' + link_to_user+ '</td>';
         var collect_fees_link = '<a class=\'btn btn-primary\' href="/fees/collect/'+ response[i].id +'">' + 'Collect Fees'  +' </a>';
         html += '<td>' + collect_fees_link+ '</td> </tr>';
        }
         html += '</table>';
      }
    jQuery("#user-search-results").html(html);
    $(".loading-image").hide(); 

    }

);
  });


  jQuery(".teacher-search").keyup(function() {
    $(".loading-image").show(); 
    jQuery.read(
     '/search/teachers',
    {username:jQuery(this).val()},
    function (response) {
      var html = '<h3> No users found with that name </h3>';
      if(response.length != 0) {
         html = '<table class=\'table table-striped\'>';
         html += '<tr><th>User Name</th> </tr>';
        for(var i = 0;i<response.length;i++) {
         html += '<tr>';
         var link_to_user = '<a href="/users/'+ response[i].id +'/profile">' + response[i].first_name +' ' + response[i].last_name + '(' + response[i].email + ')' + ' </a>';
         html += '<td>' + link_to_user+ '</td>';
         html += '</tr>';
        }
         html += '</table>';
      }
    jQuery("#user-search-results").html(html);
    $(".loading-image").hide(); 

    }

);
  });


});

jQuery(document).ready(function() {
    // put all your jQuery goodness in here.
  jQuery(".user-message").keyup(function() {
    jQuery.read(
     '/search/users',
    {username:jQuery(this).val()},
    function (response) {
      var html = '<h3> No users found with that name </h3>';
      if(response.length != 0) {
         html = '<table>';
         html += '<tr><th>User Name</th> <th>email</th> </tr>';
        for(var i = 0;i<response.length;i++) {
         var link_to_user = '<a href="#"  onclick = "modal_message_create(\''+ response[i].user.username +'\',\''+ response[i].user.id +'\');return false;" >' + response[i].user.username  +' </a>'
         html += '<tr><td>' + link_to_user + '</td> <td>' + response[i].user.email + '</td> </tr>';
        }
         html += '</table>';
      }
    jQuery("#user-search-results").html(html);

    }

);
  });


});

$(function() {
  $( ".datetimepicker" ).datetimepicker({ dateFormat: 'yy-mm-dd' });
  $( ".timepicker" ).timepicker({
   hourGrid: 4,
   minuteGrid: 15 
  });
});

$(function() {
    $( ".datepicker" ).datepicker({
                          dateFormat: 'yy-mm-dd',
                          changeMonth:true,
                          changeYear:true
                          });
});

$(function(){
  $(".iframe").colorbox({iframe:true, width:"80%", height:"80%",
                        onComplete : function() { 
                                 }
                        });
});
