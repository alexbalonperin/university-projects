package crypto;

import java.security.InvalidAlgorithmParameterException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.CipherInputStream;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;

public class DES2byte {
	
	Cipher ecipher1;
	Cipher ecipher2;
    Cipher dcipher1;
    Cipher dcipher2;
    CipherInputStream cis;
    
    public DES2byte() {
       
    }
   
	public void init(SecretKey k1, SecretKey k2, String IVstr){
		 try {
			 
			 //Instance the ciphers
			 ecipher1 = Cipher.getInstance("DES/CBC/PKCS5Padding");
	         ecipher2 = Cipher.getInstance("DES/CBC/PKCS5Padding");
			 dcipher1 = Cipher.getInstance("DES/CBC/PKCS5Padding");
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
   public byte[] encrypt(byte[] message) {

		byte[] result=null;
		
		try {
			result = ecipher1.doFinal(message);
			result = ecipher2.doFinal(result);

		} catch (IllegalBlockSizeException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (BadPaddingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return result;
}
	
	//décrypte le message 
	public byte[] decrypt(byte[] message) {
		
		byte[] result = null;
		try {
			result = dcipher2.doFinal(message);
			result = dcipher1.doFinal(result);

		} catch (IllegalBlockSizeException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (BadPaddingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
}

