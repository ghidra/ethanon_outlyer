#include "pawn.angelscript"

class enemy : pawn
{
	
	//body@[]@ m_targetbodies;//bodies that are targetable
	//private actor@ m_atarget;//cast down from pawn to actor

	//private progressbar@ m_mbar;//miners bar

	private string[] m_buttons_neutral = {"attack"};

	enemy(const string &in entityName, const vector2 pos, pawn @targetpawn, const string &in label = "unknown"){
		super(entityName,pos,label);
		
		m_spd = 100.0f;

		m_rp = 10.0f;
		m_rpmax = 50.0f;

		//init_inventory();
		m_inventory.add_weapon( weapon("random.ent", get_position()) );//now we have a weapon in the inventory
		@m_weapon = m_inventory.get_weapon(0);//go ahead and equip the weapon just created
		//m_weapon.set_destination(targetpawn.get_position());

		@m_targetpawn = targetpawn;
		//@m_atarget = m_targetpawn;//cast down
		//@m_targetbodies = targetbodies;

		//@m_rbar = progressbar("resources",m_rp,0.0f,m_rpmax,m_pos);
		//m_actionlocal="attack pawn";
		m_attacktype=0;

		for(uint t = 0; t < 11; t++){
			set_attack( "attack",m_targetpawn);
		}

		@m_button_menu = button_menu(m_label,m_pos,m_buttons_neutral);

	}

	void update(){

		m_action="none";

		pawn::update();

		vector2 direction(0, 0);
		float dist = 0.0f;

		//attack
		//----------------------
		if(attack_ready()){
			actor@ target = m_attcontroller.get_target_actor();
			//pawn@ target = m_attcontroller.get_target_pawn();
			attack(target);
		}

		const vector2 scl = get_scale();//i need to know how large this thing is. hopefully i never scale non uniformly
		const vector2 bpos = get_screen_position()+vector2(m_size.x*scl.x*0.6f,m_guibarwidth/2.0f);

		m_weapon.set_bar_position(bpos);
		update_weapon();
		//------------------------
		//-----------------------


		m_hbar.set_value(m_hp);
		//m_hbar.set_position(m_pos);
		m_hbar.set_position(bpos+vector2(m_guibarmargin+(m_guibarwidth/2.0f)));

		//button drawing
		if(m_mouseover){//if the mouse if over us
			if(m_input.GetLeftClickState()==KS_HIT && !m_button_menu.is_open() ){
				//string[] b = {"harvest","collect miner"};
				m_button_menu.set_buttons(m_buttons_neutral);

				m_pressed=true;
				m_button_menu.open(m_mousepos);
			}
		}
		if(m_button_menu.is_open()){
			m_button_menu.update();
		}
		/*
		if(m_mouseover){//if the mouse if over us
			//first clear out the button array
			for(uint t = 0; t<m_buttons.length(); t++){
				m_buttons.removeLast();
			}
			//here we trigger the button menus, and set the button array to have them in it
			vector2 stack_start = vector2(0.0f,14.0f);//here to start the menu relative to the body
			
			if(m_mouseover){
   	 			//m_buttons.insertLast( Button( 'attack', get_relative_position()+(stack_start)) );
   	 			m_buttons.insertLast( Button( 'attack', get_screen_position()+(stack_start)) );
			}

			m_menu_bool = true;
			for (uint t=0; t<m_buttons.length(); t++){
	   	 		m_buttons[t].update();
			}

			m_hbar.update();

		}
		*/

		set_button_action();

	}

	//void set_targetbody(pawn@ target){
	//	@m_targetpawn = target;
	//}
}
