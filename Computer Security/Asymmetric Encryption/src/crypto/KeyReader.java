package crypto;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

public class KeyReader {
	
	public PrivateKey readPrivateKey(String filename){
		
		
		File f = new File(filename);
	    FileInputStream fis;
		try {
			fis = new FileInputStream(f);
			DataInputStream dis = new DataInputStream(fis);
		    byte[] keyBytes = new byte[(int)f.length()];
		    dis.readFully(keyBytes);
		    dis.close();

		    PKCS8EncodedKeySpec spec =
		      new PKCS8EncodedKeySpec(keyBytes);
		    KeyFactory kf = KeyFactory.getInstance("RSA");
		    PrivateKey privateKey = kf.generatePrivate(spec);
		    return privateKey;
		    
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvalidKeySpecException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	    
	}
	
	public PublicKey readPublicKey(String filename){
		File f = new File(filename);
	    FileInputStream fis;
		try {
		
		    fis = new FileInputStream(f);
		    DataInputStream dis = new DataInputStream(fis);
		    byte[] keyBytes = new byte[(int)f.length()];
		    dis.readFully(keyBytes);
		    dis.close();

		    X509EncodedKeySpec spec =
		      new X509EncodedKeySpec(keyBytes);
		    KeyFactory kf = KeyFactory.getInstance("RSA");
		    PublicKey publicKey =  kf.generatePublic(spec);
		    return publicKey;
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvalidKeySpecException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
}
