import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.ButtonGroup;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JTextField;


public class DialogInitPool extends JDialog {

	private static final long serialVersionUID = 1L;
	
	private InfoDialogInitPool initPool;
	private JLabel namePlayer1, namePlayer2;
	private JRadioButton snooker, billard;
	private JTextField name1, name2;
	
	DialogInitPool(Dimension dimInitPool){
		super(null, "Démarrage du Jeu", JDialog.DEFAULT_MODALITY_TYPE);
		this.setSize(dimInitPool);
		this.setLocationRelativeTo(null);
		this.setResizable(false);
		this.initComponents();
	}
	
	public InfoDialogInitPool getInfo(){
		this.setVisible(true);
		return this.initPool;
	}
	
	private void initComponents(){
		
		// Nom joueur 1 :
		JPanel namePl1 = new JPanel();
		namePl1.setBackground(Color.LIGHT_GRAY);
		namePl1.setPreferredSize(new Dimension(220, 60));
		namePl1.setBorder(BorderFactory.createTitledBorder("Nom du joueur 1"));
		name1 = new JTextField();
		name1.setPreferredSize(new Dimension(100, 25));
		namePlayer1 = new JLabel("Saisir un nom :");
		namePl1.add(namePlayer1);
		namePl1.add(name1);
		
		// Nom joueur 2 :
		JPanel namePl2 = new JPanel();
		namePl2.setBackground(Color.LIGHT_GRAY);
		namePl2.setPreferredSize(new Dimension(220, 60));
		namePl2.setBorder(BorderFactory.createTitledBorder("Nom du joueur 2"));
		name2 = new JTextField();
		name2.setPreferredSize(new Dimension(100, 25));
		namePlayer2 = new JLabel("Saisir un nom :");
		namePl2.add(namePlayer2);
		namePl2.add(name2);

		// Type de billard
		JPanel panPoolType = new JPanel();
		panPoolType.setBackground(Color.LIGHT_GRAY);
		panPoolType.setBorder(BorderFactory.createTitledBorder("Type de billard"));
		panPoolType.setPreferredSize(new Dimension(440, 60));
		snooker = new JRadioButton("Snooker");
		snooker.setSelected(true);
		billard = new JRadioButton("Billard");
		billard.setEnabled(false);
		ButtonGroup bg = new ButtonGroup();
		bg.add(snooker);
		bg.add(billard);
		panPoolType.add(snooker);
		panPoolType.add(billard);
		
		
		JPanel content = new JPanel();
		content.setBackground(Color.LIGHT_GRAY);
		content.add(namePl1);
		content.add(namePl2);
		content.add(panPoolType);
		
		JPanel control = new JPanel();
		control.setBackground(Color.LIGHT_GRAY);
		JButton ok = new JButton("OK");
		
		ok.addActionListener(new ActionListener(){
			public void actionPerformed(ActionEvent arg0) {				
				initPool = new InfoDialogInitPool(name1.getText(), name2.getText(), getPoolType());
				setVisible(false);
			}
			public int getPoolType(){
				return 0;
			}
					
		});
		
		JButton cancelBouton = new JButton("Annuler");
		cancelBouton.addActionListener(new ActionListener(){
			public void actionPerformed(ActionEvent arg0) {
				setVisible(false);
			}			
		});
		
		control.add(ok);
		control.add(cancelBouton);
		
		this.getContentPane().add(content, BorderLayout.CENTER);
		this.getContentPane().add(control, BorderLayout.SOUTH);


	}
	
}
