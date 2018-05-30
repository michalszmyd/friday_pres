// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require_tree .
//= require jquery3
//= require popper
//= require bootstrap-sprockets

$(document).ready(function(){
  $('#new_comment').on('submit', function(e) {
    e.preventDefault();

    form        = $(this);
    commentBody = form.find('input[name="comment[body]"]').val();
    postId      = form.data('post-id');
    authenticityToken = $('meta[name=csrf-token]').attr('content');

    $.ajax({
      url: '/posts/' + postId + '/comments',
      method: 'POST',
      dataType: 'JSON',
      data: { comment: { body: commentBody }, authenticity_token: authenticityToken },
      success: function(comment) {
        $('.post-comments').prepend(renderComment(comment));
        form.find('input[name="comment[body]"]').val('');
        form.find('input[type="submit"]').prop('disabled', false);
      },
      error: function(e) {
        alert('oops');
      }
    })
  });

  $('.reaction-button').on('click', function(e) {
    reaction     = $(this);
    reactionType = reaction.data('type');
    postId       = reaction.data('post-id');
    authenticityToken = $('meta[name=csrf-token]').attr('content');

    $.ajax({
      url: '/posts/' + postId + '/reactions',
      method: 'POST',
      dataType: 'JSON',
      data: { reaction: { name: reactionType }, authenticity_token: authenticityToken },
      success: function(comment) {
        buttons = $('.btn-info');
        buttons.addClass('btn-primary');
        buttons.removeClass('btn-info');
        reaction.addClass('btn-info');
      },
      error: function(e) {
        alert('oops');
      }
    })
  });

  $('.like-button').on('click', function(e) {
    e.preventDefault();

    like   = $(this);
    postId = like.data('post-id');
    likeMethod = like.data('method');
    authenticityToken = $('meta[name=csrf-token]').attr('content');

    $.ajax({
      url: '/posts/' + postId + '/likes',
      method: likeMethod,
      dataType: 'JSON',
      data: { authenticity_token: authenticityToken },
      success: function(comment) {
        if (likeMethod == 'post') {
          like.addClass('btn-info');
          like.html('Unlike');
          like.data('method', 'delete');
        }
        else {
          like.addClass('btn-info');
          like.html('Like');
          like.data('method', 'post');
        }
      },
      error: function(e) {
        alert('oops');
      }
    });
  });
});

function renderComment(comment) {
  return '<div class="comment">' +
    '<b>' + comment.user_email + '</b> said:' +
    '<p>' + comment.body + '</p>' +
  '</div>';
}
