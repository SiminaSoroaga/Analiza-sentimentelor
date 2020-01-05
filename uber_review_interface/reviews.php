<?php

require 'conectare.php';
?>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<link rel="stylesheet" href="style.css" type="text/css" charset="utf-8" />
<title>UBER RIDE REVIEWS</title>
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
    <br><br><br>

    <table align="center" style="margin-top:50px" >
        <tr>
            <th>Id</th>
            <th>Review</th>
            <th>Rating</th>
        </tr>
   <?php
   $sql="SELECT * FROM reviews";
   $result=$conectare->query($sql);
   if($result->num_rows>0){
       while($row=$result->fetch_assoc()){
           echo"<tr><td>".$row["id"]."</td><td>".$row["review"]."</td><td><br>".$row["rating"]."</td></tr>";
       }
       echo "</table>";
   }
   else{
       echo "0 result";
   }
   
?>   
      
</body>

</html>
