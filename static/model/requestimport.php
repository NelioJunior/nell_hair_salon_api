<?php	
    date_default_timezone_set('America/Sao_Paulo');	
	
	$matriz =  explode("/", dirname($_SERVER['PHP_SELF']));
	$folder = $matriz[count($matriz)-1];

    file_put_contents('../fila/importstatus.txt', 'started '.$folder);
	file_put_contents('../fila/requestimport.txt', date('Y-m-d H:i:s').' '.$folder);	
?>