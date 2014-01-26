#include "enemy.angelscript"

class enemy_boss : enemy
{
	
	//body@[]@ m_targetbodies;//bodies that are targetable
	//private actor@ m_atarget;//cast down from pawn to actor

	//private progressbar@ m_mbar;//miners bar

	enemy_boss(const string &in entityName, const vector2 pos, pawn @targetpawn, const string &in label = "unknown"){
		super(entityName,pos,targetpawn,label);
		
		set_scale(4.0f);
		/*m_spd = 1.0f;

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
		}*/

	}

	void update(){
		enemy::update();
		/*m_action="none";

		pawn::update();

		vector2 direction(0, 0);
		float dist = 0.0f;

		//attack
		//----------------------
		if(attack_ready()){
			pawn@ target = m_attcontroller.get_target_pawn();
			attack(target);
		}
		update_weapon();
		//------------------------
		//-----------------------


		m_hbar.set_value(m_hp);
		//m_hbar.set_position(m_pos);
		m_hbar.set_position(get_screen_position());

		//button drawing
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

		set_button_action();
		*/
	}

	//void set_targetbody(pawn@ target){
	//	@m_targetpawn = target;
	//}
}
