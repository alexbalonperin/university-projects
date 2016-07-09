package BalonPerinKristoffersen.DistributedSolver;

import jade.core.Agent;
import jade.core.AID;
import jade.core.behaviours.*;
import jade.lang.acl.ACLMessage;
import jade.lang.acl.MessageTemplate;
import jade.domain.DFService;
import jade.domain.FIPAException;
import jade.domain.FIPAAgentManagement.DFAgentDescription;
import jade.domain.FIPAAgentManagement.ServiceDescription;

/*
 * This code is largly based on the BookBuyerAgent example provided by JADE.
 * The Task Administrator receives an expression from the GUI, calls the Parser
 * and distribute sub-expressions, until the solution is reached.
 */
public class TaskAdministrator extends Agent {
	private AID[] computeAgents; // List of known agents relevant for the task
	private TaskAdministratorGui myGui;
	// We do not have an expression queue, so we need a lock to only handle one at the time
	private boolean isWorking = false;
	private Parser parser = new Parser();

	protected void setup() {
		myGui = new TaskAdministratorGui(this);
		myGui.showGui();
		System.out.println("TaskAdministrator "+getAID().getName()+" is up and running!");
	}

	protected void takeDown() {
		myGui.dispose();
		System.out.println("TaskAdministrator "+getAID().getName()+" terminating.");
	}

	private void recurse(Node n){
		System.out.println(n.getValue()+" "+n.getOperator());
		if(n.getLeft() != null)
			recurse(n.getLeft());
		if(n.getRight() != null)
			recurse(n.getRight());
	}

	public void setExpression(final String expression) {
		if(isWorking){
			System.out.println("Task administrator is busy. New task ignored.");
			return;
		}
		isWorking = true;
		System.out.println("Expression to compute: " +expression);
		
		try{
			parser.parseExpression(expression);
		}catch(Exception e){
			System.out.println("Invalid expression");
			isWorking = false;
			return;
		}

		addBehaviour(new RequestPerformer());
		
	}
	
	private class RequestPerformer extends Behaviour {
		
		private AID bestComputer; // The agent who provides the best offer 
		private int bestCost;  // The best offered computational cost
		private int repliesCnt = 0; // The counter of replies from agents
		private MessageTemplate mt; // The template to receive replies
		private int step = 0;  // Current step of processing a sub-expression
		private Node current_node;
		private String award_content = "";
		private int totalCost = 0;
		private int result;
		
		public void action() {
			switch (step) {
			case 0:
				// Get the next expression to be computed (if NULL we are done)
				current_node = parser.getNextNode();

				if(current_node != null){
					award_content = ""+current_node.getLeft().getValue() +current_node.getOperator()+current_node.getRight().getValue();
					System.out.println("Current sub-expression: "+award_content);

					// Update the list of appropriate compute agents
					String type = "compute"+current_node.getOperator();
					DFAgentDescription template = new DFAgentDescription();
					ServiceDescription sd = new ServiceDescription();
					sd.setType(type);
					template.addServices(sd);
					try {
						DFAgentDescription[] result = DFService.search(myAgent, template); 
						System.out.println("Found the following agents:");
						computeAgents = new AID[result.length];
						for (int i = 0; i < result.length; ++i) {
							computeAgents[i] = result[i].getName();
							System.out.println(computeAgents[i].getName());
						}
					}
					catch (FIPAException fe) {
						fe.printStackTrace();
					}
				}
				step = 1;
				break;
			case 1:
				System.out.println("Sending cfp...");
				// Send the cfp to all relevant agents
				ACLMessage cfp = new ACLMessage(ACLMessage.CFP);
				for (int i = 0; i < computeAgents.length; ++i) {
					cfp.addReceiver(computeAgents[i]);
				} 
				cfp.setContent(""+current_node.getOperator());
				cfp.setConversationId("computation");
				cfp.setReplyWith("cfp"+System.currentTimeMillis()); // Unique value
				myAgent.send(cfp);
				// Prepare the template to get proposals
				mt = MessageTemplate.and(MessageTemplate.MatchConversationId("computation"),
						MessageTemplate.MatchInReplyTo(cfp.getReplyWith()));
				step = 2;
				break;
			case 2:
				// Receive all proposals/refusals from agents
				ACLMessage reply = myAgent.receive(mt);
				if (reply != null) {
					System.out.println("Receiving proposal...");
					// Reply received
					if (reply.getPerformative() == ACLMessage.PROPOSE) {
						// This is an offer 
						int cost = Integer.parseInt(reply.getContent());
						if (bestComputer == null || cost < bestCost) {
							// This is the best offer at present
							bestCost = cost;
							bestComputer = reply.getSender();
						}
					}
					repliesCnt++;
					if (repliesCnt >= computeAgents.length ) {
						// We received all replies
						step = 3; 
					}
				}
				else {
					block();
				}
				break;
			case 3:
				System.out.println("Sending accept proposal...");
				totalCost += bestCost;
				// Send the purchase order to the agent that provided the best offer
				ACLMessage order = new ACLMessage(ACLMessage.ACCEPT_PROPOSAL);
				order.addReceiver(bestComputer);
				order.setContent(award_content);
				order.setConversationId("computation");
				order.setReplyWith("order"+System.currentTimeMillis());
				myAgent.send(order);
				// Prepare the template to get the computation order reply
				mt = MessageTemplate.and(MessageTemplate.MatchConversationId("computation"),
						MessageTemplate.MatchInReplyTo(order.getReplyWith()));
				step = 4;
				break;
			case 4:     
				// Receive the computation order reply
				reply = myAgent.receive(mt);
				if (reply != null) {
			 		System.out.println("Receiving result...");
					// Computation order reply received
					if (reply.getPerformative() == ACLMessage.INFORM) {
						// Computation successful. Prepare to go to step 0.
						System.out.println(award_content+" = "+reply.getContent()+" successfully computed by agent "+reply.getSender().getName()+ " Cost = "+bestCost);
						result = Integer.parseInt(reply.getContent());
						current_node.setValue(Integer.parseInt(reply.getContent()));
						current_node.setLeft(null);
						current_node.setRight(null);

						step = 0;
					}
					else {
						// Computation failed. Prepare to terminate.
						System.out.println("Agent "+reply.getSender().getName()+" failed to compute " + award_content + "\n"+reply.getContent());
						step = -1; 
					}

					bestComputer = null;
					repliesCnt = 0;

				}
				else {
					block();
				}
				break;
			}       
		}

		public boolean done() {
			if ( step == -1)
			{
				System.out.println("Failed to compute expression");
				isWorking = false;
				return true;
			}
			if((step == 3 && bestComputer == null) || current_node == null){
				isWorking = false;
				System.out.println("Final result = "+ result +" (Total cost: "+totalCost+")");
				return true;
			}
			return false;
		}
	}  // End of inner class RequestPerformer
}
