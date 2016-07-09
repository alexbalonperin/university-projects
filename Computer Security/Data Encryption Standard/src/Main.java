
import java.security.NoSuchAlgorithmException;

import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import crypto.Attack;
import crypto.DES2;

public class Main {

	/**
	 * @param args
	 */

	public static void main(String[] args) {
		
		//initiate variables
		DES2 des2 = new DES2();
		String IV = "00000000";
		String address1 = "./tmp/x1.txt";
		String address2 = "./tmp/x2.txt";
        String address3 = "./tmp/y1.txt";
        String address4 = "./tmp/y2.txt";
        
		try {
        	//generate keys for DES-2
			KeyGenerator keygen = KeyGenerator.getInstance("DES");
			keygen.init(56);
			SecretKey k1 = keygen.generateKey();
		    SecretKey k2 = keygen.generateKey();
		    
		    // affichage des clés
		    System.out.print("key 1 : " + new String(k1.getEncoded())+ "   " );

		    System.out.print("k1 :  ") ;
		    for ( int iBytes = 0; iBytes < 8; iBytes++){
		    	System.out.print(k1.getEncoded()[iBytes] + " ");
		    }
		    System.out.println("");

		    System.out.print("key 2 : " + new String(k2.getEncoded())+ "   ");
		    System.out.print("k2 :  ") ;
		    for ( int iBytes = 0; iBytes < 8; iBytes++){
		    	System.out.print(k2.getEncoded()[iBytes] + " ");
		    } 
		    System.out.println("");
		    
		    // mise a zero des bits de poids fort
		    byte [] bArray = k1.getEncoded();
		    byte [] bArray2 = k2.getEncoded();
		    
		    for(int iByte = 0; iByte < k1.getEncoded().length; iByte++){
		    	if (iByte < 6){
		    		bArray[iByte] = (byte) (0);//&0xff);
		    		bArray2[iByte] = (byte) (0);//&0xff);
		    	}
		    }
		    System.out.println("key 1 : " +new String(bArray) + "  key 2 : " + new String(bArray2));

		    //reecriture des nouvelles clés a 16 bits variables
		    SecretKey key1 = new SecretKeySpec(bArray,"DES");
		    SecretKey key2 = new SecretKeySpec(bArray2,"DES");
		    
		    System.out.print("key1 :  ") ;
		    for ( int iBytes = 0; iBytes < 8; iBytes++){
		    	System.out.print(key1.getEncoded()[iBytes] + " ");
		    }
		    System.out.println(new String(key1.getEncoded()));
		    System.out.print("key2 :  ") ;
		    for ( int iBytes = 0; iBytes < 8; iBytes++){
		    	System.out.print(key2.getEncoded()[iBytes] + " ");
		    } 
		    System.out.println(new String(key2.getEncoded()));
		    
		  	
		    //initiate ciphers
			des2.init(key1, key2, IV);
			
			//Algorithms to encrypt or decrypt messages
			 des2.encrypt(address1,address3);
			 des2.encrypt(address2, address4);
			 
			 des2.decrypt(address3);

			 Attack attack2 = new Attack();
			 attack2.listing();
			 System.out.println("done");
		} catch (NoSuchAlgorithmException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
