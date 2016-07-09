package main;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;


public class Treatment {

	
	public static void toTxt(byte[] message, String addressO){
		//ecriture dans le fichier
		FileOutputStream fos;
		
		try {
			fos = new FileOutputStream(addressO);
			fos.write(message);
			fos.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public static byte[] convertIntToByte (int integer){
		
		byte [] result = new byte[4];
		result[0] = (byte) ((integer & 0xff000000) >>> 24);
		result[1] = (byte) ((integer & 0x00ff0000) >>> 16);
		result[2] = (byte) ((integer & 0x0000ff00) >>> 8);
		result[3] = (byte) ((integer & 0x000000ff));
//		System.out.print(result[0] + " " + result[1] + " " + result[2] + " " + result[3] + "\n");
		return result;
		
	}
	public static byte[] readTxtFile (String address){
		
		byte [] result = null ;
		FileInputStream fis;
		File file;
		try {
			file = new File(address);
			fis = new FileInputStream(file);

			int length = (int) file.length();
			result = new byte[length];
			
			int read = 0;
			int incr = 0;
			while ((read=fis.read()) != -1){
				result[incr] = (byte)read;
				incr++;
			}

		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
	public static byte [] concatenate (byte[] byteArray1, byte[] byteArray2){
		
		int length = byteArray1.length + byteArray2.length;
		byte[] result = new byte[length];
		
		for (int incr = 0 ; incr < length ; incr++){
			if (incr < byteArray1.length)
				result[incr] = byteArray1[incr];
			else
				result[incr] = byteArray2[incr-byteArray1.length];
		}
		
		return result;
	}
	
	public static byte[] cutByteArray (byte[] byteArray, int startIndex, int endIndex){
		byte[] result = new byte [endIndex-startIndex];
		for (int incr = startIndex ; incr < endIndex ; incr++)
			result[incr-startIndex] = byteArray[incr];
		return result;
	}
	

}
