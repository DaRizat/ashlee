var images = ["http://s3.amazonaws.com/ashlee/1_weddings_wedding_photo_3", "http://s3.amazonaws.com/ashlee/2_weddings_wedding_photo_4"]

var imageInId = '#main_image_0',
    imageOutId = '#main_image_1',
    activeImage = 0,
    imageCounter = 0,
    imageIndex = 0;

function animate(){
  $(imageInId).fadeIn(500);
  $(imageOutId).fadeOut(500);
}

function next(){
  imageCounter ++;
  activeImage ++;
  imageIndex = imageCounter % images.length;

  imageInId = "#main_image_" + (activeImage % 2);
  imageOutId = "#main_image_" + ((activeImage + 1) % 2);

  $(imageInId).attr("src", images[imageIndex]);
  animate();
}

setInterval(next, 7000)
