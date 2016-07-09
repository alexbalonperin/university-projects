package fileWriter;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

public class OutputCode implements OutputCodeInterface{
	private String filePath;
	
	public OutputCode(String fp){
		this.filePath = fp;
		
		try
		{
			FileWriter fw = new FileWriter(filePath);
			BufferedWriter output = new BufferedWriter(fw);
			output.write("");
			output.flush();
			output.close();
		}
		catch(IOException ioe){
			System.out.print("Erreur : ");
			ioe.printStackTrace();
			}
		
	}
	
	public void writeCode(String instruction){
		
	try
	{
		FileWriter fw = new FileWriter(filePath, true);
		BufferedWriter output = new BufferedWriter(fw);
		output.write(instruction);
		output.flush();
		output.close();
	}
	catch(IOException ioe){
		System.out.print("Erreur Fichier");
		ioe.printStackTrace();
		}
	

}

}
