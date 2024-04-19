<?php	
	/*
		America/Sao_Paulo Problemas provavelmente devido ao cancelamento do horário de verão 
	*/ 
	
    date_default_timezone_set('America/Buenos_Aires');	
   
	$matriz =  explode("/", dirname($_SERVER['PHP_SELF']));
	$folder = $matriz[count($matriz)-1];

	file_put_contents('../fila/responseqrcode.txt', '');
	file_put_contents('../fila/requestqrcode.txt', date('Y-m-d H:i:s').' '.$folder);	
?>