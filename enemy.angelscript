#include "pawn.angelscript"

class enemy : pawn
{
	pawn@ m_targetpawn;//the body that we are targeting, the main character
	//body@[]@ m_targetbodies;//bodies that are targetable

	enemy(const string &in entityName, const vector2 pos, pawn @targetpawn){
		super(entityName,pos);
		
		m_spd = 1.0f;

		m_rp = 10.0f;
		m_rpmax = 50.0f;

		@m_targetpawn = targetpawn;
		//@m_targetbodies = targetbodies;

		//@m_rbar = progressbar("resources",m_rp,0.0f,m_rpmax,m_pos);
		m_action="attack pawn";
	}

	void update(){

		pawn::update();

		vector2 direction(0, 0);
		float dist = 0.0f;

		if(m_targetpawn !is null){
			if(m_action!="none"){
				if(m_action=="attack pawn"){
					set_destination(m_targetpawn.get_position());
					
					if( m_destination_distance > length(m_targetpawn.get_size()) ){
						move(m_destination_direction);
					}else{
						m_action = "none";
					}
				}
			}
		}

	}

	//void set_targetbody(pawn@ target){
	//	@m_targetpawn = target;
	//}
}
