<?php
 	$qrcodesrc = file_get_contents("php://input");	
    	
    file_put_contents('../fila/responseqrcode.txt', $qrcodesrc);				
?>