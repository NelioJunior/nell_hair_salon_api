<?php	
	$matriz =  explode("/", dirname($_SERVER['PHP_SELF']));
	$folder = $matriz[count($matriz)-1];

    file_put_contents('../fila/importstatus.txt', 'done '.$folder);
?>