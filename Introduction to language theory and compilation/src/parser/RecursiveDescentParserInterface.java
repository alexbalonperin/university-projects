package parser;


public interface RecursiveDescentParserInterface {
	public void parsingCode() ;
	public void program() ;
	public void functionlist() ;
	public boolean function() ;
	public void ftype() ;
	public void args() ;
	public void arglist() ;
	public void nextarg() ;
	public boolean type() ;
	public void body() ;
	public void vardecl() ;
	public boolean varline() ;
	public void idlist() ;
	public void nextid() ;
	public void main() ;
	public void statementlist() ;
	public void nextstatement() ;
	public boolean statement() ;
	public boolean simplestmt() ;
	public boolean simplestmttail() ;
	public boolean compoundstmt() ;
	public boolean if_() ;
	public void iftail() ;
	public boolean while_() ;
	public boolean screencommand() ;
	public void callargs() ;
	public void exprlist() ;
	public void nextexpr() ;
	public char expression() ;
	public boolean t() ;
	public char exp1() ;
	public boolean t1() ;
	public char exp2() ;
	public boolean t2(char type) ;
	public char exp3() ;
	public boolean t3() ;
	public char exp4() ;
	public boolean t4() ;
	public char exp5() ;
	public char exp6() ;
	public char exp6tail() ;
}
