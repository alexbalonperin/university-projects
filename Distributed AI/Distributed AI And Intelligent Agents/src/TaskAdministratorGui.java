package BalonPerinKristoffersen.DistributedSolver;

import jade.core.AID;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

/*
	 * This code is almost identical to the BookSellerGui example written by: Giovanni Caire - TILAB
 */
class TaskAdministratorGui extends JFrame {	
	private TaskAdministrator myAgent;
	
	private JTextField expressionField;
	
	TaskAdministratorGui(TaskAdministrator a) {
		super(a.getLocalName());
		
		myAgent = a;
		
		JPanel p = new JPanel();
		p.add(new JLabel("Expression:"));
		expressionField = new JTextField(30);
		p.add(expressionField);
		getContentPane().add(p, BorderLayout.CENTER);
		
		JButton addButton = new JButton("Compute!");
		addButton.addActionListener( new ActionListener() {
			public void actionPerformed(ActionEvent ev) {
				try {
					String expression = expressionField.getText().trim();
					myAgent.setExpression(expression);
					expressionField.setText("");
				}
				catch (Exception e) {
					JOptionPane.showMessageDialog(TaskAdministratorGui.this, "Invalid values. "+e.getMessage(), "Error", JOptionPane.ERROR_MESSAGE); 
				}
			}
		} );
		p = new JPanel();
		p.add(addButton);
		getContentPane().add(p, BorderLayout.SOUTH);
		
		// Make the agent terminate when the user closes 
		// the GUI using the button on the upper right corner	
		addWindowListener(new	WindowAdapter() {
			public void windowClosing(WindowEvent e) {
				myAgent.doDelete();
			}
		} );
		
		setResizable(false);
	}
	
	public void showGui() {
		pack();
		Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
		int centerX = (int)screenSize.getWidth() / 2;
		int centerY = (int)screenSize.getHeight() / 2;
		setLocation(centerX - getWidth() / 2, centerY - getHeight() / 2);
		super.setVisible(true);
	}	
}
