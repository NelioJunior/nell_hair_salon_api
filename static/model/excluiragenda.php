<?php

	//python 
	$codigo = file_get_contents("php://input");

	//php  
        if (isset($_POST["id_agenda"])) {
            $codigo = $_POST['id_agenda'];
        }	

        require('acesso.php');	

        $sql = "call prc_deletar_agenda('$codigo');" ;

        $result = $conn->query($sql);

        if(!$result) {
           echo(mysqli_error($conn));
           return;
        }
					
        $conn->close();
		
?>
