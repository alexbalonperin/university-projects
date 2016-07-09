package parser;

public interface AddressTableInterface {
	
		public int getAddress(String variable);
		public void addVariable(String variable, int address, boolean global);
		public void removeVariable(String variable);
		public void print();
		public boolean getGlobal(String variable);
		public boolean contains(String variable);
		public void addArg(String variable);
		public void removeArgs();
		public int getArgNumber(String variable);
		public boolean containsArg(String variable);
		public int getNumberOfArgs();
		public int getSizeOfStack();
		public void addMP(String variable, int address);
		public int getMP(String variable);
}
