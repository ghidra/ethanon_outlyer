#include "pawn.angelscript"
#include "miner.angelscript"

class Character : pawn
{

	private miner@[] m_miners;//my array of miners
	private int m_maxminers = 3;//at first you can only have 3 miners, maybe later you can have some more
	body@ m_targetbody;//the body that we are targeting

	Character(const string &in entityName, const vector2 pos){
		super(entityName,pos);
		
		m_spd = 1.0f;

		m_rp = 10.0f;
		m_rpmax = 50.0f;

		@m_rbar = progressbar("resources",m_rp,0.0f,m_rpmax,m_pos);
	}

	void update(){

		pawn::update();

		vector2 direction(0, 0);
		float dist = 0.0f;

		if(m_targetbody !is null){
			if(m_action!="none"){
				if(m_action=="harvest"){
					m_destination = m_targetbody.get_position();
					direction = m_targetbody.get_position()-get_position();
					dist = length(direction);
					if( dist > length(m_targetbody.get_size()) ){
						move(direction);
					}else{
						deposit_miner(m_targetbody);
						//deposit_miner(m_atarget[0]);
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
		m_rbar.set_position(m_pos);
		m_rbar.update();

		/*ETHInput@ input = GetInputHandle();
		vector2 direction(0, 0);
		//float speed = UnitsPerSecond(m_spd);

		// find current move direction based on keyboard keys
		if (input.KeyDown(K_DOWN))
		{
			m_directionLine = 0;
			direction += (vector2(0, 1)*m_spd_ups);
			//direction += vector2(0, 1);
		}
		if (input.KeyDown(K_LEFT))
		{
			m_directionLine = 1;
			direction += (vector2(-1, 0)*m_spd_ups);
			//direction += vector2(-1, 0);
		}
		if (input.KeyDown(K_RIGHT))
		{
			m_directionLine = 2;
			direction += (vector2(1, 0)*m_spd_ups);
			//direction += vector2(1, 0);
		}
		if (input.KeyDown(K_UP))
		{
			m_directionLine = 3;
			direction += (vector2(0,-1)*m_spd_ups);
			//direction += vector2(0,-1);
		}

		// if there's movement, update animation
		move(direction);
		*/
	}
	void deposit_miner(body@ target){//put a minor on the target
		if(target !is null){
			if(m_rp>3.0f){
				vector2 target_pos = target.get_position();
				vector2 target_size = target.get_size()*0.75f;
				vector2 drop_dir = normalize(get_position()-target.get_position());
				vector2 drop_zone = target_pos+(drop_dir*target_size);
				int len = m_miners.length;
				if(len<m_maxminers){
					m_miners.insertLast( miner("random.ent", drop_zone, target) );
					m_miners[len].set_scale(0.25f);
					set_rp(get_rp()-3.0f);
					target.add_miner();
				}

			}else{
				//warn that you do not have enough funds
			}
		}
	}
	/*void deposit_miner(actor@ target){//put a minor on the target
		if(target !is null){
			vector2 target_pos = target.get_position();
			vector2 target_size = target.get_size()*0.75f;
			vector2 drop_dir = normalize(get_position()-target.get_position());
			vector2 drop_zone = target_pos+(drop_dir*target_size);
			int len = m_miners.length;
			if(len<m_maxminers){
				m_miners.insertLast( miner("random.ent", drop_zone, target) );
				m_miners[len].set_scale(0.25f);
			}
		}
	}*/
	void set_targetbody(body@ target){
		@m_targetbody = target;
	}
}
