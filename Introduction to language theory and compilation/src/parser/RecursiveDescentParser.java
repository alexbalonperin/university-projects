package parser;
import java.util.Vector;

import exception.TokenException;
import exception.TypeException;
import exception.VariableException;

import scanner.DFAInterface;
import scanner.DFA;
import scanner.Tokens;
import generator.Generator;
import generator.GeneratorInterface;

public class RecursiveDescentParser implements RecursiveDescentParserInterface{
	
	private DFAInterface scanner ;
	private GeneratorInterface generator;
	private boolean typedFunction;
	private int address = 0;
	private char type;
	private Vector<Integer> numbArgs = new Vector<Integer> ();
	private boolean fromFunction;
	private String nameFunction;
	private boolean hasElse;
	private boolean isGlobal;
	private AddressTableInterface tableMain;
	private int addressID;
	private Vector<Integer> MPMemory = new Vector<Integer>();
	private int mst = 0;
	private SymbolTableInterface symbolTable = new SymbolTable();
	private Function function;
	private int iterator = 1;
	private Vector<Boolean> calling = new Vector<Boolean>();
	private Vector<String> nameFunctionCall = new Vector<String>();

	
	public RecursiveDescentParser(String filePath) {
		scanner = new DFA(filePath);
		scanner.scan();
		generator = new Generator();
		typedFunction = false;
		isGlobal = true;
		nameFunction = "" ;
		tableMain = new AddressTable();
		MPMemory.add(0);
	}
	
	public void parsingCode() {
		program();
		symbolTable.print();
	}
	
	public void program() {
		vardecl();
		isGlobal = false;
		generator.jumpToMain();
		functionlist();
		generator.defineMain();
		MPMemory.clear();
		MPMemory.add(0);
		main();
		generator.stop();
	}

	public void functionlist() {
		if(function()){   
			MPMemory.remove(MPMemory.size()-1);
			functionlist();
		}
	}

	public boolean function() {
		fromFunction = true;
		generator.endl();
		while (scanner.getToken() == Tokens.ENDL)
			match(Tokens.ENDL);
		switch(scanner.getToken()){ 
			case Tokens.DEF :	
								match(Tokens.DEF);
								ftype();
								generator.defineFunctionID(scanner.getCorrespondingValue());
								tableMain.addMP(scanner.getCorrespondingValue(), tableMain.getSizeOfStack());
								MPMemory.add(tableMain.getMP(scanner.getCorrespondingValue())); 
								for (int i = 0 ; i<5 ; i++ )
									tableMain.addVariable("" +  mst++ , tableMain.getSizeOfStack()  , isGlobal);
								nameFunction = scanner.getCorrespondingValue();
								function = new Function(nameFunction, type);
								MPMemory.add(tableMain.getMP(nameFunction));
								match(Tokens.ID);
								match(Tokens.LPAR);
								args();
								symbolTable.addFunction(function);
								match(Tokens.RPAR);
								match(Tokens.COLON);
								body();
								generator.endOfScope(typedFunction);
								return true;
			default : return false;
		}
	}

	public void ftype() {
		if (type())
			typedFunction = true;
		else{
			typedFunction = false;
			type='.';
			}
	}

	public void args() {
		arglist();
	}

	public void arglist() {
		if(type()){
			switch (scanner.getToken()){
				case Tokens.ID : tableMain.addArg(scanner.getCorrespondingValue());
								 tableMain.addVariable(scanner.getCorrespondingValue(),tableMain.getSizeOfStack() , isGlobal);
								 function.addArg(scanner.getCorrespondingValue(),type);
								 match(Tokens.ID);
								 nextarg();
			}
		}
	}

	public void nextarg() {
		switch(scanner.getToken()){
			case Tokens.COMMA : match(Tokens.COMMA);
								arglist();
				break;
		}
	}

	public boolean type()  {
		while (scanner.getToken() == Tokens.ENDL)
			match (Tokens.ENDL);
		switch (scanner.getToken()){
			
			case Tokens.INT: 	match(Tokens.INT) ;
								type = 'i';
								return true;
			case Tokens.BOOL:	match(Tokens.BOOL);
								type = 'b';
								return true;
			default :			return false;
		}
	}

	public void body() {
		switch(scanner.getToken()){
			case Tokens.ENDL : 	match(Tokens.ENDL);
								while (scanner.getToken() == Tokens.ENDL)
									match(Tokens.ENDL);
								match(Tokens.INDENT);
								vardecl();
								statementlist();
								match(Tokens.DEDENT);
				break;
			case Tokens.INDENT : match(Tokens.INDENT);
								vardecl();
								statementlist();
								match(Tokens.DEDENT);
				break;
		}
	}

	public void vardecl() {
		if(varline()){
			vardecl();
		}
	}

	public boolean varline() {
		if(!type())
			return false;
		idlist();
		return true;
	}

	public void idlist() {
		while (scanner.getToken() == Tokens.ENDL){
			match (Tokens.ENDL);
		}
		switch(scanner.getToken()){
			case Tokens.ID :	String name = scanner.getCorrespondingValue();
								try{
								if (fromFunction){
									if (tableMain.contains(name)){
										if (tableMain.getGlobal(name)){
											throw new VariableException(name + " is a Global Variable, don't reuse it");
										}
									}
								}
								}
								catch(VariableException e){
									System.err.println("EXCEPTION THROWN : " + e.getMessage() ) ;
									System.exit(0);
								}
								symbolTable.addVariable(name, type);
								match(Tokens.ID);
								generator.defineID(0,type);
								tableMain.addVariable(name, tableMain.getSizeOfStack(), isGlobal);
								address++;
								if(scanner.getToken() == Tokens.LPAR)
									try {
										throw new TokenException("Mauvaise dŽclaration");
									} catch (TokenException e) {
										System.err.println("EXCEPTION THROWN : " + e.getMessage());
										System.exit(0);
									}
								nextid();
				break;
				default : syntaxError();
		}

	}

	public void nextid() {
		switch(scanner.getToken()){
			case Tokens.COMMA : 	match(Tokens.COMMA);
									idlist();
		} 
	
	}

	public void main() {
		fromFunction = false;
		vardecl();
		statementlist();
	}

	public void statementlist() {
			if(statement())
				nextstatement();
	}

	public void nextstatement() {
		statementlist();
	}

	public boolean statement() {
		if (compoundstmt()){
			return true;
		}
		else if(simplestmt()){
			while(scanner.getToken() == Tokens.ENDL)
				match(Tokens.ENDL);
			return true;
		}
		return false;
	}

	public boolean simplestmt() {
		while (scanner.getToken() == Tokens.ENDL)
			match(Tokens.ENDL);
		switch (scanner.getToken()){
			case Tokens.ID : match(Tokens.ID);
							 return simplestmttail();

			case Tokens.READ :	match(Tokens.READ);
								match(Tokens.LPAR);
								address = tableMain.getAddress(scanner.getCorrespondingValue()) - MPMemory.lastElement();
								char type = symbolTable.getType(scanner.getCorrespondingValue()); 
								match(Tokens.ID);
								match(Tokens.RPAR);
								generator.read(address, type);
								return true;
			case Tokens.PRINT : match(Tokens.PRINT);
								match(Tokens.LPAR);
								expression();
								match(Tokens.RPAR);
								generator.print();
								return true;
			case Tokens.RETURN : match (Tokens.RETURN);
								matchType(expression(),symbolTable.getFunctionType(nameFunction));
								generator.returnValue(symbolTable.getFunctionType(nameFunction)); // CHANGER TYPE ADDRESS
								return false;
			case Tokens.PASS :	match (Tokens.PASS);
								generator.pass();
								return true;
			default :			 
					return screencommand();
		}
	}

	public boolean simplestmttail() {
		while (scanner.getToken() == Tokens.ENDL)
			match(Tokens.ENDL);
		switch(scanner.getToken()){
			case Tokens.ASSIGNOP : 
								try{
									if (!tableMain.contains(scanner.getPreviousValue()))
										throw new VariableException (scanner.getPreviousValue() + " has not been declared");
								} catch(VariableException e){
									System.err.println("EXCEPTION THROWN : " + e.getMessage());
									System.exit(0);
								}
								if (tableMain.getGlobal(scanner.getPreviousValue()))
									addressID= tableMain.getAddress(scanner.getPreviousValue()) ;
								else
									addressID = tableMain.getAddress(scanner.getPreviousValue()) - MPMemory.lastElement();
								char type = symbolTable.getType(scanner.getPreviousValue());
								boolean glob = tableMain.getGlobal(scanner.getPreviousValue());
								match(Tokens.ASSIGNOP);
								matchType(expression(), type);
								
								generator.assignValue(addressID, type,glob); 

								return true;
			case Tokens.LPAR :	String tempname = scanner.getPreviousValue();
								match (Tokens.LPAR);
								nameFunctionCall.add(tempname);
								callargs();
								match (Tokens.RPAR);
								generator.functionCall(fromFunction, numbArgs.lastElement(), nameFunctionCall.lastElement());
								numbArgs.remove(numbArgs.size()-1);
								nameFunctionCall.remove(nameFunctionCall.size()-1);
								return true;

		}
		return false;
	}

	public boolean compoundstmt() {
		if (while_())
			return true;
		else
			if (if_())
				return true;
		return false;
	}

	public boolean if_() {
		while (scanner.getToken() == Tokens.ENDL)
			match (Tokens.ENDL);
		switch (scanner.getToken()){
			case Tokens.IF : match(Tokens.IF);
							expression();
							hasElse = true;
							generator.else_(hasElse);
							match(Tokens.COLON);
							body();
							generator.jumpAfterIf();
							iftail();
							generator.endl();
							generator.afterIf();
							return true;
		}
		return false;
	}

	public void iftail() {
		hasElse = false;
		switch (scanner.getToken()){
			case Tokens.ENDL :	match(Tokens.ENDL);
				break;
			case Tokens.ELSE :	match(Tokens.ELSE);
							hasElse=true;
							match(Tokens.COLON);
							generator.endl();
							generator.defineElse();
							body();
			break;
			default :		generator.endl();
							generator.defineElse();
				break;
		}
	}

	public boolean while_() {
		while (scanner.getToken() == Tokens.ENDL)
			match(Tokens.ENDL);
		switch (scanner.getToken()){
			case Tokens.WHILE :	match(Tokens.WHILE);
								generator.defineWhile();
								expression();
								generator.while_();
								generator.endl();
								match(Tokens.COLON);
								body();
								generator.loopWhile();
								generator.endl();
								generator.afterWhile();
								return true;
		}
		return false;
	}

	public boolean screencommand()  { 
		switch (scanner.getToken()){
			case Tokens.PUT :	match(Tokens.PUT);
								match(Tokens.LPAR);
								expression();
								match(Tokens.COMMA);
								expression();
								match(Tokens.COMMA);
								expression();
								match(Tokens.RPAR);
								generator.put();
								return true;
			case Tokens.PUTR :	match(Tokens.PUTR);
								match(Tokens.LPAR);
								expression();
								match(Tokens.COMMA);
								expression();
								match(Tokens.RPAR);
								generator.putr();
								return true;
			case Tokens.GET :	match(Tokens.GET);
								match(Tokens.LPAR);
								expression();
								match(Tokens.COMMA);
								expression();
								match(Tokens.RPAR);
								generator.get();
								return true;
			case Tokens.HOLD : 	match(Tokens.HOLD);
								generator.hold();
								return true;
			case Tokens.RELEASE : match (Tokens.RELEASE);
									generator.release();
									return true;
			case Tokens.RESET : match(Tokens.RESET);
								generator.reset();
								return true;		
		}
		return false;
	}

	public void callargs() {
		generator.createStackFrame(fromFunction);
		calling.add(true);
		numbArgs.add(0);
		exprlist();
		if (numbArgs.lastElement() != symbolTable.getArgsNumber(nameFunctionCall.lastElement()))
		{
			System.err.println("Not right amount of parameters");
			System.exit(0);
		}
		calling.remove(calling.size()-1);
	}

	public void exprlist() {
		expression();
		nextexpr();
	}

	public void nextexpr() {
		
		if (scanner.getToken() == Tokens.COMMA){
			match(Tokens.COMMA);
			exprlist();
			
		}
	}

	public char expression() {
		while (scanner.getToken() == Tokens.ENDL)
			match(Tokens.ENDL);
		char result;
		result = exp1();
		if(t()){
			matchType(result,'b');
			return 'b';
		}
		return result;
	}

	public boolean t()  {
		while (scanner.getToken() == Tokens.ENDL)
			match(Tokens.ENDL);
		switch(scanner.getToken()){
			case Tokens.OR: match(Tokens.OR);
							matchType(exp1(),'b');
							generator.or();
							t();
							return true;
		}
		return false;
	}

	public char exp1() {
		while (scanner.getToken() == Tokens.ENDL)
			match(Tokens.ENDL);
		char result;
		result = exp2();
		if(t1()){
			matchType(result,'b');
			return 'b';
		}
			
		return result;
	}

	public boolean t1() {
		while (scanner.getToken() == Tokens.ENDL)
			match(Tokens.ENDL);
		switch(scanner.getToken()){
		case Tokens.AND: match(Tokens.AND);
						matchType(exp2(),'b');
						generator.and();
						t1();
						return true;
		}
		return false;
	}

	public char exp2() {
		while (scanner.getToken() == Tokens.ENDL)
			match(Tokens.ENDL);
		char result;
		result = exp3();
		if(t2(result)){
			return 'b';
		}
		return result;
	}

	public boolean t2(char type) {
		while (scanner.getToken() == Tokens.ENDL)
			match(Tokens.ENDL);
		switch(scanner.getToken()){
			case Tokens.GRT: match(Tokens.GRT);
							matchType(exp3(),'i');
							generator.grt();
							return true;
			case Tokens.GEQ: match(Tokens.GEQ);
							matchType(exp3(),'i');
							generator.geq();
							return true;
			case Tokens.LESS: match(Tokens.LESS);
							matchType(exp3(),'i');
							generator.less();
							return true;
			case Tokens.LEQ: match(Tokens.LEQ);
							matchType(exp3(),'i');
							generator.leq();
							return true;
			case Tokens.EQUAL: match(Tokens.EQUAL);
								matchType(type,exp3());
								generator.equal(type);
								return true;
			case Tokens.DIFF: match(Tokens.DIFF);
								matchType(type,exp3());
							  generator.diff(type);
							  return true;
		}
		return false;
	}

	public char exp3() {
		while (scanner.getToken() == Tokens.ENDL)
			match(Tokens.ENDL);
		char result;
		result = exp4();
		if(t3()){
			matchType(result, 'i');
			return 'i';
		}
		return result;
	}

	public boolean t3() {
		while (scanner.getToken() == Tokens.ENDL)
			match(Tokens.ENDL);
		switch(scanner.getToken()){
			case Tokens.ADD: match(Tokens.ADD);
							matchType(exp4(),'i');
							generator.add();
							t3();
							return true;
			case Tokens.MIN: match(Tokens.MIN);
							matchType(exp4(),'i');
							generator.sub();
							t3();
							return true;
		}
		return false;
	}

	public char exp4() {
		while (scanner.getToken() == Tokens.ENDL)
			match(Tokens.ENDL);
		char result;
		result = exp5();
		if(t4()){
			matchType(result, 'i');
			return 'i';
			}
		return result;
	}

	public boolean t4() {
		while (scanner.getToken() == Tokens.ENDL)
			match(Tokens.ENDL);
		switch(scanner.getToken()){
			case Tokens.MUL: match(Tokens.MUL);
							matchType(exp5(),'i');
							generator.mul();
							t4();
							return true;
			case Tokens.DIV: match(Tokens.DIV);
							matchType(exp5(),'i');
							generator.div();
							t4();
							return true;
		}
		return false;
	}

	public char exp5() {
		char result;
		while(scanner.getToken() == Tokens.ENDL)
			match(Tokens.ENDL);
		switch(scanner.getToken()){
			case Tokens.NOT: match(Tokens.NOT);
							result = exp5();
							matchType(result, 'b');
							generator.not();
							return result;
			case Tokens.NEG: match(Tokens.NEG);
							result = exp5();
							matchType(result,'i');
							generator.neg();
							return result;
			default: return exp6();
		}
	}

	public char exp6() {
		
		char result;
		while (scanner.getToken() == Tokens.ENDL)
			match(Tokens.ENDL);
		switch(scanner.getToken()){
			case Tokens.LPAR: match(Tokens.LPAR);
							result =  expression();
							match(Tokens.RPAR);
							return result;
			case Tokens.ID: match(Tokens.ID);
							return exp6tail();
			case Tokens.INTEGER_LITERAL: match(Tokens.INTEGER_LITERAL);
							generator.INTEGER_LITERAL(scanner.getPreviousValue());
							return 'i';
			case Tokens.BOOLEAN_LITERAL: match(Tokens.BOOLEAN_LITERAL);
							generator.BOOLEAN_LITERAL(scanner.getPreviousValue());
							return 'b';
			case Tokens.GET :	match(Tokens.GET);
								match(Tokens.LPAR);
								expression();
								match(Tokens.COMMA);
								expression();
								match(Tokens.RPAR);
								generator.get();
								return 'i';
		}
		
		return '.';
	}

	public char exp6tail() {
		switch(scanner.getToken()){
			case Tokens.LPAR: 	String tempname = scanner.getPreviousValue(); 
								
							char ftype = symbolTable.getFunctionType(tempname);
							match(Tokens.LPAR);
							nameFunctionCall.add(tempname);

							callargs();
							if(calling.size() != 0){
								numbArgs.set( numbArgs.size()-2, numbArgs.get(numbArgs.size()-2)+1);
								char fcttype = symbolTable.getFunctionType(tempname);
								matchType(fcttype, symbolTable.getArgType(nameFunctionCall.get(nameFunctionCall.size()-2),numbArgs.get(numbArgs.size()-2) -1));
							}
							match(Tokens.RPAR);
								generator.functionCall(fromFunction, numbArgs.lastElement(), nameFunctionCall.lastElement());
							numbArgs.remove(numbArgs.size()-1);
							nameFunctionCall.remove(nameFunctionCall.size()-1);
							return ftype;
			default:		if(calling.size() != 0){
									char argType = symbolTable.getArgType(nameFunctionCall.lastElement(),numbArgs.lastElement());
									matchType(argType, symbolTable.getType(scanner.getPreviousValue()));
									numbArgs.set( numbArgs.size()-1, numbArgs.lastElement()+1);
								}
								char type = symbolTable.getType(scanner.getPreviousValue());
								int addressToReach;
								if (tableMain.getGlobal(scanner.getPreviousValue()))
										addressToReach = tableMain.getAddress(scanner.getPreviousValue()) ;
								else
									addressToReach = tableMain.getAddress(scanner.getPreviousValue()) - MPMemory.lastElement();
								boolean global = tableMain.getGlobal(scanner.getPreviousValue());
								generator.getIDValue(addressToReach, type, global);
								return type;
		}
	}

	private void match(int token) {
		if (token == Tokens.ENDL)
			iterator++;
		try{
			if( (token != scanner.getTokenAndGoToNext()) )
			throw new TokenException("expected  : " + token + " instead of :  " +  scanner.getPreviousValue() + " at line : " + iterator);
		} catch (TokenException e){
			System.err.println("EXCEPTION THROWN : " + e.getMessage());
			System.exit(0);
		}
	}

	private void matchType(char type1, char type2) {
		try{
			if (type1 != type2)
				throw new TypeException ("bad type checking");
		} catch(TypeException e){
			System.err.println("EXCEPTION THROWN : " + e.getMessage());
			System.exit(0);
		}
	}
	
	private void syntaxError(){
		try{
			throw new TokenException("you did not respect the syntax");
		}
		catch (TokenException e){
			System.err.println("EXCEPTION THROWN : "  + e.getMessage());
			System.exit(0);
		}
	}

}
