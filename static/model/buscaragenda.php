<?php 
	/*
	
		Teste:  	
				http://localhost/mysite/ClientesParceirosNell/gestorPai_SalaoConsultorioMVC/model/buscaragenda.php?dtPesquisa=2021-03-22			
	
	*/
	
	header('Content-Type: text/html; charset=utf-8'); 

	require('acesso.php');	

	$conn->set_charset("utf8");
	
	$dtPesquisa = $_GET["dtPesquisa"];
	
	$query = "call prc_buscar_agenda('$dtPesquisa');";
			
	try {	

		$result = mysqli_query($conn, $query);
			
		$rows = array();
			
		while($each = mysqli_fetch_assoc($result)){
			$rows[] = $each;
		}
						
		echo json_encode($rows); 
	
	} catch (PDOException $e){
		echo $e->getMessage();
	}
				
	$conn->close();
		
?>