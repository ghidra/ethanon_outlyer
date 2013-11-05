#include "pawn.angelscript"
#include "weapon.angelscript"

class enemy : pawn
{
	pawn@ m_targetpawn;//the body that we are targeting, the main character
	private weapon@ m_weapon;
	private uint m_attacktype;//0 is do not attack, 1 basic 2 strong etc, potentially -1 is defend
	//body@[]@ m_targetbodies;//bodies that are targetable

	//private progressbar@ m_mbar;//miners bar

	enemy(const string &in entityName, const vector2 pos, pawn @targetpawn){
		super(entityName,pos);
		
		m_spd = 1.0f;

		m_rp = 10.0f;
		m_rpmax = 50.0f;

		init_inventory();
		m_inventory.add_weapon( weapon("random.ent", get_position()) );//now we have a weapon in the inventory
		@m_weapon = m_inventory.get_weapon(0);//go ahead and equip the weapon just created
		//m_weapon.set_destination(targetpawn.get_position());

		@m_targetpawn = targetpawn;
		//@m_targetbodies = targetbodies;

		//@m_rbar = progressbar("resources",m_rp,0.0f,m_rpmax,m_pos);
		m_action="attack pawn";
		m_attacktype=0;
	}

	void update(){

		pawn::update();

		vector2 direction(0, 0);
		float dist = 0.0f;

		//vector2 temp = m_targetpawn.get_position();
		//DrawText(m_pos+vector2(20.0f,-20.0f),temp.x+":"+temp.y,m_font, m_red);

		if(m_targetpawn !is null){
			if(m_action!="none"){
				if(m_action=="attack pawn"){
					if(m_attacktype!=0){//we are ready to attack something
						m_weapon.set_destination(m_targetpawn.get_position());
						m_weapon.update();
						m_weapon.draw_tbar();
					}else{//we do now know how to attaack yet, decide how to attack
						m_attacktype = 1;//just make it try anything right now
					}

					/*set_destination(m_targetpawn.get_position());
					
					if( m_destination_distance > length(m_targetpawn.get_size()) ){
						move(m_destination_direction);
					}else{
						m_action = "none";
					}
					*/
				}
			}
		}

	}

	//void set_targetbody(pawn@ target){
	//	@m_targetpawn = target;
	//}
}
