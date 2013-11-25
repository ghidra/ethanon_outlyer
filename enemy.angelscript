#include "pawn.angelscript"

class enemy : pawn
{
	
	//body@[]@ m_targetbodies;//bodies that are targetable

	//private progressbar@ m_mbar;//miners bar

	enemy(const string &in entityName, const vector2 pos, pawn @targetpawn){
		super(entityName,pos);
		
		m_spd = 1.0f;

		m_rp = 10.0f;
		m_rpmax = 50.0f;

		//init_inventory();
		m_inventory.add_weapon( weapon("random.ent", get_position()) );//now we have a weapon in the inventory
		@m_weapon = m_inventory.get_weapon(0);//go ahead and equip the weapon just created
		//m_weapon.set_destination(targetpawn.get_position());

		@m_targetpawn = targetpawn;
		//@m_targetbodies = targetbodies;

		//@m_rbar = progressbar("resources",m_rp,0.0f,m_rpmax,m_pos);
		//m_actionlocal="attack pawn";
		m_attacktype=0;
	}

	void update(){

		m_action="none";

		pawn::update();

		vector2 direction(0, 0);
		float dist = 0.0f;

		//vector2 temp = m_targetpawn.get_position();
		//DrawText(m_pos+vector2(20.0f,-20.0f),temp.x+":"+temp.y,m_font, m_red);

		/*if(m_targetpawn !is null){
			if(m_actionlocal!="none"){
				if(m_actionlocal=="attack pawn"){
					if(m_attacktype!=0){//we are ready to attack something
						m_weapon.set_destination(m_targetpawn.get_position());
						m_weapon.update();
						m_weapon.draw_tbar();
					}else{//we do now know how to attaack yet, decide how to attack
						m_attacktype = 1;//just make it try anything right now
						//m_weapon.m_action="attack";
					}
		*/

					/*set_destination(m_targetpawn.get_position());
					
					if( m_destination_distance > length(m_targetpawn.get_size()) ){
						move(m_destination_direction);
					}else{
						m_action = "none";
					}
					*/
		/*
				}
			}
			check_weapon_projectiles();
		}
		*/

		//button drawing
		if(m_mouseover){//if the mouse if over us
			//first clear out the button array
			for(uint t = 0; t<m_buttons.length(); t++){
				m_buttons.removeLast();
			}
			//here we trigger the button menus, and set the button array to have them in it
			vector2 stack_start = vector2(0.0f,14.0f);//here to start the menu relative to the body
			
			if(m_mouseover){
   	 			m_buttons.insertLast( Button( 'attack', get_relative_position()+(stack_start)) );
			}

			m_menu_bool = true;
			for (uint t=0; t<m_buttons.length(); t++){
	   	 		m_buttons[t].update();
			}
		}

		set_button_action();

	}

	//void set_targetbody(pawn@ target){
	//	@m_targetpawn = target;
	//}
}
