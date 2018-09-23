document.addEventListener('turbolinks:load', () => {
  $('#project_description').froalaEditor();
});

setInterval(function(){
  document.getElementById('notification').style.opacity = '0';
  document.getElementById('notification').style.transition = 'opacity 1s, height 0 1s';
}, 3000);

