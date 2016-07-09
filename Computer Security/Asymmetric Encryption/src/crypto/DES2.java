package crypto;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.InvalidAlgorithmParameterException;

import javax.crypto.Cipher;
import javax.crypto.CipherInputStream;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;

public class DES2 {
	
	Cipher ecipher1;
	Cipher ecipher2;
    Cipher dcipher1;
    Cipher dcipher2;
    CipherInputStream cis;
    
    public DES2() {
       
    }
   
	public void init(SecretKey k1, SecretKey k2, String IVstr){
		 try {
			 
			 //Instance the ciphers
			 ecipher1 = Cipher.getInstance("DES/CBC/PKCS5Padding");
	         dcipher1 = Cipher.getInstance("DES/CBC/PKCS5Padding");
	         ecipher2 = Cipher.getInstance("DES/CBC/PKCS5Padding");
	         dcipher2 = Cipher.getInstance("DES/CBC/PKCS5Padding");
	        
	         // Transform IV String --> byte
	         byte[] ivBytes = IVstr.getBytes();
//	         byte[] ivBytes = new byte[]{
//	                 (byte)0x8E, 0x12, 0x39, (byte)0x9C,
//	                 0x07, 0x72, 0x6F, 0x5A
//	             };
	         IvParameterSpec IV = new IvParameterSpec(ivBytes);
	         
	         // initiate the ciphers
	         ecipher1.init(Cipher.ENCRYPT_MODE, k1,IV);
	         dcipher1.init(Cipher.DECRYPT_MODE, k1,IV);
	         ecipher2.init(Cipher.ENCRYPT_MODE, k2,IV);
	         dcipher2.init(Cipher.DECRYPT_MODE, k2,IV);
	         
	     } catch (javax.crypto.NoSuchPaddingException e) {
				e.printStackTrace();
	     } catch (java.security.NoSuchAlgorithmException e) {
				e.printStackTrace();
	     } catch (java.security.InvalidKeyException e) {
			e.printStackTrace();
		} catch (InvalidAlgorithmParameterException e) {
			e.printStackTrace();
		}
	}
	
	//crypte le message avec l'algorithme DES2
   public void encrypt(String addressI, String addressO) {

			String cipherTextMiddle = "./tmp/cipherTextMiddle.txt";
			streams(addressI, cipherTextMiddle, ecipher1);
			streams(cipherTextMiddle, addressO, ecipher2);
    }
   
	
	//décrypte le message 
	public void decrypt(String address) {
        
		String clearTextMiddle = "./tmp/clearTextMiddle.txt";
		String clearTextFinal = "./tmp/clearTextFinal.txt";
		
	    streams(address, clearTextMiddle, dcipher2);
		streams(clearTextMiddle, clearTextFinal,dcipher1);
    }

	//Gestion des fichiers à crypter et cryptés
	private void streams(String addressI,String addressO, Cipher cipher){
		
		FileInputStream fis;
		FileOutputStream fos;
		
		try {
			fis = new FileInputStream(addressI);
			cis = new CipherInputStream(fis, cipher);
			fos = new FileOutputStream(addressO);
			
			byte[] b = new byte[1];
			try {
				int i = cis.read(b);
				while (i != -1) {
			    	fos.write(b, 0, i);
			    	i = cis.read(b);	    
			    }
			    fos.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
		
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}