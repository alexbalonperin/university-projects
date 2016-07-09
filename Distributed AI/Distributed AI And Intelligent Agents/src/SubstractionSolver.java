package BalonPerinKristoffersen.DistributedSolver;

public class SubstractionSolver extends ComputeAgent{
	
	public SubstractionSolver(){
		super("compute-");
	}
	
	protected int compute(String operation){
		int[] result = getOperands(operation);
		return result[0]-result[1];
	}
}
