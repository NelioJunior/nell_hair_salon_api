<?php

	require('acesso.php');
	$getParam =  json_decode($_POST['id']);
		
	$query  = "call prc_buscar_valor('$getParam');" ;
			
	try {	
		$result = $conn->query($query);
		
		if($result->num_rows > 0) {
		    $num_linha = 0;	
			          
		    $retorno = '[';
		    while($row = $result->fetch_assoc()) {
		    		    	
		       $retorno .=  '{"valor":"'.$row['VALOR'].'"}';
	       
		       $num_linha++;
		       if ($result->num_rows > $num_linha)  {
		       	   $retorno .=  ','; 	
		       }		       
		    }
		    $retorno .= ']'; 
            echo utf8_encode($retorno); 
		    		    
		}	
	
	} catch (PDOException $e){
		echo $e->getMessage();
	}
				
	$conn->close();
	
?>