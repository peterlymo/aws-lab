$(document).ready(function(){
  var filters = $('nav .filter-container');

  if (filters.length) {
    filters.pushpin({ top: filters.offset().top });
    var $links = filters.find('li');
    $links.each(function() {
      var $link = $(this);
      $link.on('click', function() {
        $links.removeClass('active');
        $link.addClass('active');
        var hash = $link.find('a').first()[0].hash.substr(1);
        var $postItems = $('.post .post-item');
        $postItems.stop().addClass('post-filter').fadeIn(100);
        if (hash !== 'all') {
          var $postFilteredOut = $postItems.not('.' + hash).not('.all');
          $postFilteredOut.removeClass('post-filter').hide();
        }
        $masonry.masonry({
          transitionDuration: '.3s'
        });
        $masonry.one( 'layoutComplete', function( event, items ) {
          $masonry.masonry({
            transitionDuration: 0
          });
        });
        setTimeout(function() {
          $masonry.masonry('layout');
        }, 500);
      });
    });
  }
  var $masonry = $('.post');
  $masonry.masonry({
    itemSelector: '.post-filter',
    columnWidth: '.post-filter',
    transitionDuration: 0
  });
  $masonry.imagesLoaded(function() {
    $masonry.masonry('layout');
  });
  $('a.filter').click(function (e) {
    e.preventDefault();
  });
});
