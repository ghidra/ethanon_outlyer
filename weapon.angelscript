#include "actor.angelscript"
#include "projectile.angelscript"
#include "progressbar.angelscript"
#include "pawn.angelscript"
#include "enemy.angelscript"
//s#include "explosion.angelscript"

class weapon : actor
{

	private projectile@[] m_projectiles;//the projectile that we will be using
	private progressbar@ m_tbar;//time bar bar

	weapon(const string &in entityName, const vector2 &in pos = vector2(0.0f,0.0f) ){
		super(entityName,pos);

		@m_tbar = progressbar("attack",m_timer,0.0f,1.0f,pos);

		//@m_projectile = projectile("random.ent");
	}

	void update(){
		actor::update();
		//update our attach bar so that we can see how soon it will attach
		//if(m_action!="none"){
			if(m_timer>=1){
				set_timer(0.0f);
				//m_action = "none";
				fire();
			}else{
				update_timer();
				m_tbar.set_value(get_timer());
				//m_action = "attack";
			}
		//}

		for(uint t=0; t<m_projectiles.length(); t++){
			m_projectiles[t].update();
		}
	}

	void draw_tbar(){
		//i need to have this thing placed specifically before drawing it anyway 
		m_tbar.update();
	}

	void fire(){//fire projectile
		m_projectiles.insertLast( projectile("random.ent", m_pos, m_destination) ) ;
	}
	//----
	void check_projectiles_hit_target(pawn@ target){

		vector2 tpos = target.get_position();
		float tsize = length(target.get_size())/3;
		
		manage_projectiles(tpos,tsize);
		/*for(uint t=0; t<m_projectiles.length(); t++){//loop all the projectiles in the array
			vector2 ppos = m_projectiles[t].get_position();//get projectile position
			if (!m_projectiles[t].get_hit() ){//, the projectile has not hit something yet
				if(length(tpos-ppos)<=tsize){//deterime hit
					m_projectiles[t].set_hit();//we have hit
				}
				
			}else{//otherwise we have hit
				if(m_projectiles[t].get_explosion_done()){//if the animation is done playing, we can remove it finally
					m_projectiles[t].delete_entity();
					m_projectiles.removeAt(t);
				}

			}
		}*/

	}
	//this is leterally a duplicate function, because of the type it expects 
	void check_projectiles_hit_target(enemy@ target){

		vector2 tpos = target.get_position();
		float tsize = length(target.get_size())/3;

		manage_projectiles(tpos,tsize);

		/*for(uint t=0; t<m_projectiles.length(); t++){
			vector2 ppos = m_projectiles[t].get_position();
			if (length(tpos-ppos)<=tsize){
				//we have hit
				m_projectiles[t].delete_entity();
				m_projectiles.removeAt(t);
			}
		}*/
	}
	void manage_projectiles(const vector2 pos, const float size){

		for(uint t=0; t<m_projectiles.length(); t++){//loop all the projectiles in the array
			vector2 ppos = m_projectiles[t].get_position();//get projectile position
			if (!m_projectiles[t].get_hit() ){//, the projectile has not hit something yet
				if(length(pos-ppos)<=size){//deterime hit
					m_projectiles[t].set_hit();//we have hit
				}
				
			}else{//otherwise we have hit
				if(m_projectiles[t].get_explosion_done()){//if the animation is done playing, we can remove it finally
					m_projectiles[t].delete_entity();
					m_projectiles.removeAt(t);
				}

			}
		}

	}
}
