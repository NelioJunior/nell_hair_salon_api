<?php 
	
	header('Content-Type: text/html; charset=utf-8'); 

	require('acesso.php');	

	$conn->set_charset("utf8");
	
	$id = $_POST["id"];
	
	$matriz =  explode("/", dirname($_SERVER['PHP_SELF']));
	$folder = $matriz[count($matriz)-1 ];
				
	$query  = "call prc_enviar_campanha('$id');" ;
			
	try {	

		$result = mysqli_query($conn, $query);
			
		$rows = array();
			
		while($each = mysqli_fetch_assoc($result)){
			$each['pasta'] = $folder;
			$rows[] = $each;			
		}
									
		file_put_contents('../fila/enviarPeloWhatsApp.json', json_encode($rows));		
	
	} catch (PDOException $e){
		echo $e->getMessage();
	}
				
	$conn->close();
		
	$fileNome = $_POST['fileNome'];
	if ($fileNome != "") {
		$img = $_POST['imgBase64'];
		$img = str_replace('data:image/png;base64,', '', $img);
		$img = str_replace(' ', '+', $img);
		$fileData = base64_decode($img);			
		$target_file = $fileNome;		
		file_put_contents($target_file, $fileData);			
	}		
		
?>