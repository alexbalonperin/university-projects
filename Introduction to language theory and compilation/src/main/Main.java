package main;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import parser.RecursiveDescentParser;
import parser.RecursiveDescentParserInterface;

public class Main {

	public static void main(String[] args) {
		 InputStreamReader isr = new InputStreamReader(System.in);
	      BufferedReader br = new BufferedReader(isr);
	      String filePath="";
		try {
			System.out.print("location of the source code : ");
			filePath = br.readLine();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
			RecursiveDescentParserInterface parser = new RecursiveDescentParser(filePath);
			parser.parsingCode();
	}

}
