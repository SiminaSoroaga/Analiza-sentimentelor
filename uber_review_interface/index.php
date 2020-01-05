<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<link rel="stylesheet" href="style.css" type="text/css" charset="utf-8" />
<title>UBER RIDE REVIEWS</title>
</head>
<body>
<div id="wrapper">
  <div id="header">
    </div>  
    
  
  
 <div id="nav"> 
  <a href="index.php">Give a review</a> 
  <a href="reviews.php">Reviews</a>
<a class="lastchild" href="contact.php">Contact</a> 
    <br><br>
     </div>         
    <br><br>

         
  
  

    <form align=center  style="margin-top:50px" action="inserare.php" method="POST"> 
        <textarea name="review"  rows="10" cols="40">Write a review....</textarea><br><br>
                <div> Rating<br><br>
                    <label for="1">1</label>
          <input type="radio" name="rating" class="fa fa-star" aria-hidden="true" id="1" value="1"><br><br>
                      </div>
                <div>
                    <label for="2">2</label>
          <input type="radio" name="rating" id="2" value="2"><br><br>
                </div>
                 <div>
                    <label for="3">3</label>
          <input type="radio" name="rating" id="3" value="3"><br><br>
                </div>
                <div>
                    <label for="4">4</label>
          <input type="radio" name="rating" id="4" value="4"><br><br>
                </div>
                <div>
                    <label for="5">5</label>
          <input type="radio" name="rating" id="5" value="5"><br><br>
                </div>
                                <input type="submit" name="trimite" value="Send"><br>
                                        </form>
