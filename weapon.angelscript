#include "actor.angelscript"

class weapon : actor
{

	weapon(const vector2 pos, actor@ target){
		//super(entityName,pos);
		m_spd = 1.0f;
	}

	void update(){

		pawn::update();

		vector2 direction(0, 0);
		float dist = 0.0f;

		if(m_targetbody !is null){
			if(m_action!="none"){
				if(m_action=="harvest"){
					set_destination(m_targetbody.get_position());

					if( m_destination_distance > length(m_targetbody.get_size()) ){
						move(m_destination_direction);
					}else{
						deposit_miner(m_targetbody);
						//deposit_miner(m_atarget[0]);
						m_action = "none";
					}
				}
				if(m_action=="collect miner"){
					set_destination(m_targetbody.get_position());

					if( m_destination_distance > length(m_targetbody.get_size()) ){
						move(m_destination_direction);
					}else{
						collect_miner(m_targetbody);
						m_action = "none";
					}
				}
			}
		}

		for (uint t=0; t<m_miners.length(); t++){
			m_miners[t].update();
 
			this.set_rp( m_rp+m_miners[t].get_rp() );
		}

		m_rbar.set_value(m_rp);
		//m_rbar.set_position(m_pos);
		m_rbar.update();

		m_mbar.set_value(m_minerscount);
		m_mbar.update();

	}
}
