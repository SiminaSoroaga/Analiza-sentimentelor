<?php
require "conectare.php";
$review=$_POST['review'];
$rating=$_POST['rating'];
$sql="INSERT INTO reviews(review,rating) VALUES ('$review','$rating')";
   $result=$conectare->query($sql);

header("Location: reviews.php");