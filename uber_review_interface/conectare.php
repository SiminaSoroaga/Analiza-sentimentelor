<?php
$conectare= mysqli_connect("localhost","root","","uber_reviews");

if(!$conectare){
    die('Conectarea la baza de date nu a reusit');
}
