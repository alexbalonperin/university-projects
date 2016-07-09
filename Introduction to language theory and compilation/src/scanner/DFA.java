package scanner;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Vector;

import exception.IndentationException;

public class DFA implements DFAInterface {

	private String filePath; 
	private FileInputStream fis; 
	private Vector<String> values = new Vector<String>();
	private Vector<Character> vect = new Vector<Character>();
	private Vector<Integer> tokens = new Vector<Integer>();
	private String fileContent;
	private int dedentc;
	private int indentc;
	
	private int iterator;
	
	public DFA (String fp){
		this.filePath = fp;
		this.dedentc = 0;
		this.indentc = 0;
		this.iterator = 0;
	}
	
	public void scan(){
		//lecture du contenu du fichier
		fileContent = readTxtFile();
		
		//lecture du fichier carcatere par caractere
		findvalues();
	}
	

	private String readTxtFile(){
		String result="";
		try {
			fis = new FileInputStream(filePath);
			File file = new File(filePath);
			
			int length = (int) file.length();
			int incr = 0;
			int read = 0;
			byte[] b = new byte[length];
			
			while ((read=fis.read()) != -1){
				b[incr] = (byte) read;
				incr++;
			}
			result = new String(b);
			
		  } catch (IOException e) {
		   e.printStackTrace();
		  }
		return result;
	}
	
	private void findvalues(){
		fileContent = fileContent + "\n ";
		for (int i=0 ; i < fileContent.length(); i++){

			switch (fileContent.charAt(i)){
				// reconnaissance commentaire
				case '#' : 
					do{
						i++;
					}
					while(fileContent.charAt(i+1) != '\n' && i < fileContent.length()-1);
					break;
				case '"' : 	i++;
							if (fileContent.charAt(i) == '"'){
								i++;
								if(fileContent.charAt(i) == '"'){
									i++;
									while (fileContent.charAt(i) != '"')
										i++;
										if (fileContent.charAt(i) == '"'){
											i++;
											if (fileContent.charAt(i) == '"'){
												i++;
												if (fileContent.charAt(i) == '"');
											}
										}
											
								}
							}
					break;
				case 'a' :	vect.add(fileContent.charAt(i));
							if (fileContent.charAt(i+1) == 'n'){
								i++;
								vect.add(fileContent.charAt(i));
								if (fileContent.charAt(i+1) == 'd'){
									i++;

									vect.add(fileContent.charAt(i));
									if (fileContent.charAt(i+1) == ' ' ){
										saveToken();
										tokens.add(Tokens.AND);

									}
								}
							}
					break;
				case 'b' : 	vect.add(fileContent.charAt(i));
							if (fileContent.charAt(i+1) == 'o'){
								i++;
								vect.add(fileContent.charAt(i));
								if (fileContent.charAt(i+1) == 'o'){
									i++;
									vect.add(fileContent.charAt(i));
									if (fileContent.charAt(i+1) == 'l'){
										i++;
										vect.add(fileContent.charAt(i));
										if (fileContent.charAt(i+1) == ' '){
										saveToken();
										tokens.add(Tokens.BOOL);
										}
									}
								}
							}
					break;
				case 'd' : 	vect.add(fileContent.charAt(i));
							if (fileContent.charAt(i+1) == 'e'){
								i++;
								vect.add(fileContent.charAt(i));
								if (fileContent.charAt(i+1) == 'f'){
									i++;
									vect.add(fileContent.charAt(i));
									if (fileContent.charAt(i+1) == ' '){
										saveToken();
										tokens.add(Tokens.DEF);
									}
								}
							}
					break;
				case 'e' : 	vect.add(fileContent.charAt(i));
							if (fileContent.charAt(i+1) == 'l'){
								i++;
								vect.add(fileContent.charAt(i));
								if (fileContent.charAt(i+1) == 's'){
									i++;
									vect.add(fileContent.charAt(i));
									if (fileContent.charAt(i+1) == 'e'){
										i++;
										vect.add(fileContent.charAt(i));
										if (fileContent.charAt(i+1) == ':'){
											saveToken();
											tokens.add(Tokens.ELSE);
										}
									}
									
								}
							}
					break;
				case 'F' : 	vect.add(fileContent.charAt(i));
							if (fileContent.charAt(i+1) == 'a'){
								i++;
								vect.add(fileContent.charAt(i));
								if (fileContent.charAt(i+1) == 'l'){
									i++;
									vect.add(fileContent.charAt(i));
									if (fileContent.charAt(i+1) == 's'){
										i++;
										vect.add(fileContent.charAt(i));
										if (fileContent.charAt(i+1) == 'e'){
											i++;
											vect.add(fileContent.charAt(i));
											if (fileContent.charAt(i+1) == ' ' || fileContent.charAt(i+1) == ':' || fileContent.charAt(i+1) == '\t' || fileContent.charAt(i+1) == '\n'){
												saveToken();
												tokens.add(Tokens.BOOLEAN_LITERAL);
											}
										}
									}
								}
							}
					break;
				case 'g' : 	vect.add(fileContent.charAt(i));
							if (fileContent.charAt(i+1) == 'e'){
								i++;
								vect.add(fileContent.charAt(i));
								if (fileContent.charAt(i+1) == 't'){
									i++;
									vect.add(fileContent.charAt(i));
									if (fileContent.charAt(i+1) == ' ' || fileContent.charAt(i+1) == '('){
										saveToken();
										tokens.add(Tokens.GET);
									}
									
								}
							}
					break;
				case 'h' : vect.add(fileContent.charAt(i));
							if (fileContent.charAt(i+1) == 'o'){
								i++;
								vect.add(fileContent.charAt(i));
								if (fileContent.charAt(i+1) == 'l'){
									i++;
									vect.add(fileContent.charAt(i));
									if (fileContent.charAt(i+1) == 'd'){
										i++;
										vect.add(fileContent.charAt(i));
										if (fileContent.charAt(i+1) == ' ' || fileContent.charAt(i+1) == '\t' || fileContent.charAt(i+1) == '\n'){
											saveToken();
											tokens.add(Tokens.HOLD);
										}
									}
								}
							}
						break;
				case 'i' : 	vect.add(fileContent.charAt(i));
				if (fileContent.charAt(i+1) == 'n'){
					i++;
					vect.add(fileContent.charAt(i));
					if (fileContent.charAt(i+1) == 't'){
						i++;
						vect.add(fileContent.charAt(i));
						if (fileContent.charAt(i+1) == ' '){
							saveToken();
							tokens.add(Tokens.INT);
						}
					}
				}
				else if (fileContent.charAt(i+1) == 'f'){
					i++;
					vect.add(fileContent.charAt(i));
					if (fileContent.charAt(i+1) == ' ' || fileContent.charAt(i+1) == '('){
						saveToken();
						tokens.add(Tokens.IF);
					}
				}
					break;
				case 'n' : 	vect.add(fileContent.charAt(i));
							if (fileContent.charAt(i+1) == 'o'){
								i++;
								vect.add(fileContent.charAt(i));
								if (fileContent.charAt(i+1) == 't'){
									i++;
									vect.add(fileContent.charAt(i));
									if (fileContent.charAt(i+1) == ' '){
										saveToken();
										tokens.add(Tokens.NOT);
									}
								}
							}
					break;
				case 'o' : 	vect.add(fileContent.charAt(i));
							if (fileContent.charAt(i+1) == 'r'){
								i++;
								vect.add(fileContent.charAt(i));
								if (fileContent.charAt(i+1) == ' '){
									saveToken();
									tokens.add(Tokens.OR);
								}
							}
					break;
				case 'p' : 	vect.add(fileContent.charAt(i));
							if (fileContent.charAt(i+1) == 'a'){
								i++;
								vect.add(fileContent.charAt(i));
								if (fileContent.charAt(i+1) == 's'){
									i++;
									vect.add(fileContent.charAt(i));
									if (fileContent.charAt(i+1) == 's'){
										i++;
										vect.add(fileContent.charAt(i));
										if (fileContent.charAt(i+1) == ' ' || fileContent.charAt(i+1) == '\n' || fileContent.charAt(i+1) == '\t'){
											saveToken();
											tokens.add(Tokens.PASS);
										}
									}
								}
							}
							else if (fileContent.charAt(i+1) == 'r'){
								i++;
								vect.add(fileContent.charAt(i));
								if (fileContent.charAt(i+1) == 'i'){
									i++;
									vect.add(fileContent.charAt(i));
									if (fileContent.charAt(i+1) == 'n'){
										i++;
										vect.add(fileContent.charAt(i));
										if (fileContent.charAt(i+1) == 't'){
											i++;
											vect.add(fileContent.charAt(i));
											if (fileContent.charAt(i+1) == '(' || fileContent.charAt(i+1) == ' '){
												saveToken();
												tokens.add(Tokens.PRINT);
												
											}
										}
									}
									
								}
							}
							else if (fileContent.charAt(i+1) == 'u'){
								i++;
								vect.add(fileContent.charAt(i));
								if (fileContent.charAt(i+1) == 't'){
									i++;
									vect.add(fileContent.charAt(i));
									if (fileContent.charAt(i+1) == ' ' || fileContent.charAt(i+1) == '('){
										saveToken();
										tokens.add(Tokens.PUT);
									}
									else if (fileContent.charAt(i+1) == 'r'){
										i++;
										vect.add(fileContent.charAt(i));
										if (fileContent.charAt(i+1) == ' ' || fileContent.charAt(i+1) == '('){
											saveToken();
											tokens.add(Tokens.PUTR);
										}
									}
								}
							}
						break;
				case 'r' : vect.add(fileContent.charAt(i));
							if (fileContent.charAt(i+1) == 'e'){
								i++;
								vect.add(fileContent.charAt(i));
								if (fileContent.charAt(i+1) == 'a'){
									i++;
									vect.add(fileContent.charAt(i));
									if (fileContent.charAt(i+1) == 'd'){
										i++;
										vect.add(fileContent.charAt(i));
										if (fileContent.charAt(i+1) == '(' || fileContent.charAt(i+1) == ' '){
											saveToken();
											tokens.add(Tokens.READ);
										}
									}
								}
								else if (fileContent.charAt(i+1) == 'l'){
									i++;
									vect.add(fileContent.charAt(i));
									if (fileContent.charAt(i+1) == 'e'){
										i++;
										vect.add(fileContent.charAt(i));
										if (fileContent.charAt(i+1) == 'a'){
											i++;
											vect.add(fileContent.charAt(i));
											if (fileContent.charAt(i+1) == 's'){
												i++;
												vect.add(fileContent.charAt(i));
												if (fileContent.charAt(i+1) == 'e'){
													i++;
													vect.add(fileContent.charAt(i));
													if (fileContent.charAt(i+1) == ' ' || fileContent.charAt(i+1) == '\n'){
														saveToken();
														tokens.add(Tokens.RELEASE);
													}
												}
											}
										}
									}
								}
								else if (fileContent.charAt(i+1) == 's'){
									i++;
									vect.add(fileContent.charAt(i));
									if (fileContent.charAt(i+1) == 'e'){
										i++;
										vect.add(fileContent.charAt(i));
										if (fileContent.charAt(i+1) == 't'){
											i++;
											vect.add(fileContent.charAt(i));
											if (fileContent.charAt(i+1) == ' ' || fileContent.charAt(i+1) == '\n'){
												saveToken();
												tokens.add(Tokens.RESET);
											}
										}
									}
								}
								else if (fileContent.charAt(i+1) == 't'){
									i++;
									vect.add(fileContent.charAt(i));
									if (fileContent.charAt(i+1) == 'u'){
										i++;
										vect.add(fileContent.charAt(i));
										if (fileContent.charAt(i+1) == 'r'){
											i++;
											vect.add(fileContent.charAt(i));
											if (fileContent.charAt(i+1) == 'n'){
												i++;
												vect.add(fileContent.charAt(i));
												if (fileContent.charAt(i+1) == ' ' ){
													saveToken();
													tokens.add(Tokens.RETURN);
												}
											}
										}
									}
								}
							}
					break;
				case 'T' : 	vect.add(fileContent.charAt(i));
							if (fileContent.charAt(i+1) == 'r'){
								i++;
								vect.add(fileContent.charAt(i));
								if (fileContent.charAt(i+1) == 'u'){
									i++;
									vect.add(fileContent.charAt(i));
									if (fileContent.charAt(i+1) == 'e'){
										i++;
										vect.add(fileContent.charAt(i));
										if (fileContent.charAt(i+1) == ' ' || fileContent.charAt(i+1) == ':' || fileContent.charAt(i+1) == '\t' || fileContent.charAt(i+1) == '\n' || fileContent.charAt(i+1) == ')'){
											saveToken();
											tokens.add(Tokens.BOOLEAN_LITERAL);
										}
									}
								}
							}
					break;
				case 'w' : 	vect.add(fileContent.charAt(i));
							if (fileContent.charAt(i+1) == 'h'){
								i++;
								vect.add(fileContent.charAt(i));
								if (fileContent.charAt(i+1) == 'i'){
									i++;
									vect.add(fileContent.charAt(i));
									if (fileContent.charAt(i+1) == 'l'){
										i++;
										vect.add(fileContent.charAt(i));
										if (fileContent.charAt(i+1) == 'e'){
											i++;
											vect.add(fileContent.charAt(i));
											if (fileContent.charAt(i+1) == ' '){
												saveToken();
												tokens.add(Tokens.WHILE);
											}
										}
									}
								}
							}	
					break;
				case ' '  : if (vect.size() != 0){
								tokens.add(Tokens.ID);
							}
							saveToken();			
						break;
				case '\n' : if (vect.size() != 0){
									tokens.add(Tokens.ID);
								}saveToken();
								values.add("ENDL");
								tokens.add(Tokens.ENDL);
								i = indentation(i);
						break;
				case ',' : 	if (vect.size() != 0){
								tokens.add(Tokens.ID);
							}saveToken();
							vect.add(fileContent.charAt(i));
							saveToken();
							tokens.add(Tokens.COMMA);
					break;
				case '(' : 	if (vect.size() != 0){
								tokens.add(Tokens.ID);
							}saveToken();
							vect.add(fileContent.charAt(i));
							saveToken();
							tokens.add(Tokens.LPAR);
					break;
				case ')' : 	if (vect.size() != 0){
								tokens.add(Tokens.ID);
							}
							saveToken();
							vect.add(fileContent.charAt(i));
							saveToken();
							tokens.add(Tokens.RPAR);
					break;
				case ':' : 	if (vect.size() != 0){
								tokens.add(Tokens.ID);
							}
							saveToken();
							vect.add(fileContent.charAt(i));
							saveToken();
							tokens.add(Tokens.COLON);
					break;
				case '+' : 	if (vect.size() != 0){
								tokens.add(Tokens.ID);
							}saveToken();
							vect.add(fileContent.charAt(i));
							saveToken();
							tokens.add(Tokens.ADD);
					break;
				case '-' : 	if (vect.size() != 0){
								tokens.add(Tokens.ID);
							}saveToken();
							vect.add(fileContent.charAt(i));
							saveToken();
							tokens.add(Tokens.MIN);
					break;
				case '*' : 	if (vect.size() != 0){
									tokens.add(Tokens.ID);
							}saveToken();
							vect.add(fileContent.charAt(i));
							saveToken();
							tokens.add(Tokens.MUL);
					break;
				case '/' : 	if (vect.size() != 0){
								tokens.add(Tokens.ID);
							}saveToken();
							vect.add(fileContent.charAt(i));
							saveToken();
							tokens.add(Tokens.DIV);
					break;
				case '=' :	if (vect.size() != 0){
								tokens.add(Tokens.ID);
							}saveToken();
							vect.add(fileContent.charAt(i));
							if (fileContent.charAt(i+1) == '='){
								i++;
								vect.add(fileContent.charAt(i));
								tokens.add(Tokens.EQUAL);
							}
							else
								tokens.add(Tokens.ASSIGNOP);
							saveToken();
					break;
				case '<' : 	if (vect.size() != 0){
								tokens.add(Tokens.ID);
							}saveToken();
							vect.add(fileContent.charAt(i));
							if (fileContent.charAt(i+1) == '='){
								i++;
								vect.add(fileContent.charAt(i));
								tokens.add(Tokens.LEQ);
							}
							else
								tokens.add(Tokens.LESS);
							saveToken();
					break;
				case '>' : 	if (vect.size() != 0){
								tokens.add(Tokens.ID);
							}saveToken();
							vect.add(fileContent.charAt(i));
							if (fileContent.charAt(i+1) == '='){
								i++;
								vect.add(fileContent.charAt(i));
								tokens.add(Tokens.GEQ);
							}
							else
								tokens.add(Tokens.GRT);
							saveToken();
					break;
				case '!' : 	if (vect.size() != 0){
								tokens.add(Tokens.ID);
							}saveToken();
							vect.add(fileContent.charAt(i));
							if (fileContent.charAt(i+1) == '='){
								i++;
								vect.add(fileContent.charAt(i));
								tokens.add(Tokens.DIFF);
							} saveToken();
							break;
				default :	if (fileContent.charAt(i) != ' ')
								vect.add(fileContent.charAt(i));
							
							if (isANumber(vect.get(0))){
								while ( isANumber(fileContent.charAt(i+1))){
									i++;

									vect.add(fileContent.charAt(i));

								}
								tokens.add(Tokens.INTEGER_LITERAL);
								saveToken();
							}
					break;
			}
		}
		if (!vect.isEmpty())
			saveToken();
		tokens.add(Tokens.EOF);
		print();
	}
	
	private boolean isANumber(char c){
		boolean result = false;
		if (c == '0' || c == '1' || c == '2' || c == '3' || c == '4' || c == '5' || c == '6' || c == '7' || c == '8' || c == '9')
			result = true;
		return result;
	}
	
	private void saveToken(){
		if (vect.size() >0){
			char [] c = new char[vect.size()];
			for (int incr = 0 ; incr < vect.size() ; incr ++)
				c[incr] = vect.get(incr);
			values.add(new String(c));
			if (new String(c).equals("def")){
				indentc = 0;
				dedentc = 0;
			}
			vect.removeAllElements();
		}
	}
	
	private int indentation( int index){
		int tabs = 0;
		try{
		while (fileContent.charAt(index+1) == '\t'){
			index++;
			tabs++;
		}

		if (dedentc > 0){
			dedentc = dedentc-1;
			values.add(new String("DEDENT"));
			tokens.add(Tokens.DEDENT);
		}
		else{
			if (tabs == indentc+1){
				indentc = indentc + 1;
				values.add(new String("INDENT"));
				tokens.add(Tokens.INDENT);
			}
			else if (tabs < indentc){
				dedentc = indentc-tabs-1;
				indentc = tabs;
				values.add(new String("DEDENT"));
				tokens.add(Tokens.DEDENT);
			}
			else if (tabs == indentc){
				
			}
			else {
				throw new IndentationException ("you have not respected the indentation rules");
			}
		}
		}
		catch(IndentationException e){
			System.err.println("EXCEPTION THROWN : "  +e.getMessage());
			System.exit(0);
		}
		return index;
	}
	
	
	public int getNumberOfTokens(){
		return values.size();
	}
	
	public String getCorrespondingValue(){
		String result = values.get(iterator);
		return result;
	}

	public int getTokenAndGoToNext() {
		int result = tokens.get(iterator);
		if (iterator < tokens.size()-1 && tokens.get(iterator) != Tokens.EOF)
			iterator++;
		return result;
	}

	public int getToken() {
		return tokens.get(iterator);
	}
	
	public String getPreviousValue(){
		return values.get(iterator-1);
	}
	
	private void print(){
		for (int i = 0 ; i < tokens.size()-1 ; i ++){
			System.out.println(tokens.get(i) + " : " + values.get(i) );
		}
	}
	
}
