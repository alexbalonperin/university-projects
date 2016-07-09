package BalonPerinKristoffersen.DistributedSolver;

public class DivisionSolver extends ComputeAgent{
	
	public DivisionSolver(){
		super("compute/");
	}
	
	protected int compute(String operation){
		int[] result = getOperands(operation);
		return result[0]/result[1];
	}
}
