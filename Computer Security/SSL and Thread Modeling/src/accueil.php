<!-- PAGE DE DEMARRAGE -->
<?php
	
	session_start();
	
	include("protection.php");
	//connexion à la bdd
	$con = mysql_connect("localhost","root","root");
	mysql_select_db("secu3",$con);

	$connexion = false;
			
	//test si l'email et le password existent		
	if(isset($_POST['email']) AND isset($_POST['password']))
	{
		//utilise la fonction blindage pour se proteger des injections sql et javascript
		$email = blindage($_POST['email']);
		//hash le password avec md5 en plus de se proteger des injections 
		$password = md5(blindage($_POST['password']));
		
		$sql = "SELECT * FROM utilisateur WHERE email='".$email."' AND motdepasse='".$password."'";
		$result = mysql_query($sql,$con)or die(mysql_error());
		$counter = 0;
		while($data = mysql_fetch_array($result))
			$counter++;
			
		//si au moins un utilisateur dans la bdd possède l'email et le password entrés on le connecte
		if ($counter > 0){
		 	$connexion = true;
		 	$_SESSION['email'] = $email;
		 }
	}	
	mysql_close();
	
	if( $connexion )
	{
		
?>
<!-- PAGE VISIBLE PAR UN UTILISATEUR CONNECTE -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" >
   <head>
       <title>SQL injection</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	   <link rel="stylesheet" media="screen" type="text/css" title="Design" href="accueil.css" />
   </head>
   <body>
   		<!-- Page d'accueil -->
   		<p>vous etes connecté, <?php echo $email ?></p>
   <a href="https://localhost/~utilisateur/edit.php" > Editer votre profil</a>
	</body>
</html> 	
<?php
}
else
{
?>
<!-- PAGE DE LOGIN -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" >
   <head>
       <title>SQL injection</title>
       <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	   <link rel="stylesheet" media="screen" type="text/css" title="Design" href="accueil.css" />
   </head>
   <body>
   		<!-- Formulaire de login -->
	   <form action="https://localhost/~utilisateur/accueil.php" method="post">
		   <label for="email" >Email</label> : <br/><input type="text" name="email" id="email" value="<?php echo $_POST['email'] ?>" /><br/><br/>
		   <label for="password">Mot de passe</label> : <br/><input type="password" name="password" id="password" value="<?php echo $_POST['mdp'] ?>" /><br/><br/>
			<input type="submit" value="valider"/>  
	   </form>
	   <form action="https://localhost/~utilisateur/inscription.php" method="post">
	   
			<input type="submit" value="s'incrire"/><br/> 
	  
	   </form>
	   <a href="https://localhost/~utilisateur/accueil.php">Passez en mode sécurisé</a>
    </body>
</html>  

<?php
}

?>
	