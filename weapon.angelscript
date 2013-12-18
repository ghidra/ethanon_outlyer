#include "actor.angelscript"
#include "projectile.angelscript"
#include "progressbar.angelscript"
#include "pawn.angelscript"
#include "enemy.angelscript"
#include "body.angelscript"
//s#include "explosion.angelscript"

class weapon : actor
{

	private projectile@[] m_projectiles;//the projectile that we will be using
	private progressbar@ m_tbar;//time bar bar

	private body@ m_target_body;//variables to hold the target of the actions
	private enemy@ m_target_enemy;
	private pawn@ m_target_pawn;
	private actor@ m_target_actor;

	private string m_target_type;

	weapon(const string &in entityName, const vector2 &in pos = vector2(0.0f,0.0f) ){
		super(entityName,pos);

		@m_tbar = progressbar("attack",m_timer,0.0f,1.0f,pos);

		//@m_projectile = projectile("random.ent");
	}

	void update(){
		actor::update();
		//update our attach bar so that we can see how soon it will attach
		if(m_action!="none"){
			if(m_timer>=1){
				set_timer(0.0f);
				m_action = "none";
				fire();
			}else{
				update_timer();
				m_tbar.set_value(get_timer());
				draw_tbar();
				//m_action = "attack";
			}
		}

		//loop the projectiles and update them, then check if they finished thier job, goin to target and detonating
		for(uint t=0; t<m_projectiles.length(); t++){
			m_projectiles[t].update();

			if (m_projectiles[t].get_hit() && m_projectiles[t].get_explosion_done()){//, the projectile hit something and finished exploding
				//if the animation is done playing, we can remove it finally
				m_projectiles[t].delete_entity();
				m_projectiles.removeAt(t);
				

			}

		}

		//manage_projectiles();
	}

	void set_position(const vector2 pos){
		//need this, cause I need to put the entity graphic in place, not moving it or whatever, just place that sucker
		actor::set_position(pos);
		if(m_entity !is null){
			m_entity.SetPosition(vector3(pos,0.0f));
		}
	}

	void draw_tbar(){
		//i need to have this thing placed specifically before drawing it anyway 
		m_tbar.set_position(get_screen_position());
		m_tbar.update();
	}
	//-------
	void set_target(actor@ target){
		set_destination(target.get_position());
		@m_target_actor = target;
		m_target_type = "actor";
	}
	void set_target(pawn@ target){
		set_destination(target.get_position());
		@m_target_pawn = target;
		m_target_type = "pawn";
	}
	void set_target(body@ target){
		set_destination(target.get_position());
		@m_target_body = target;
		m_target_type = "body";
	}
	void set_target(enemy@ target){
		set_destination(target.get_position());
		@m_target_enemy = target;
		m_target_type = "enemy";
	}
	//-------

	void fire(){//fire projectile
		m_projectiles.insertLast( projectile("random.ent", m_pos, m_destination) ) ;

		if(m_target_type == "actor"){
			m_projectiles[m_projectiles.length()-1].set_target(m_target_actor);
		}
		if(m_target_type == "pawn"){
			m_projectiles[m_projectiles.length()-1].set_target(m_target_pawn);
		}
		if(m_target_type == "body"){
			m_projectiles[m_projectiles.length()-1].set_target(m_target_body);
		}
		if(m_target_type == "enemy"){
			m_projectiles[m_projectiles.length()-1].set_target(m_target_enemy);
		}
	}

	//----
	//return weather or not we have shots in the air
	bool shots_fired(){
		return m_projectiles.length()>0;
	}
	bool shots_charging(){
		return m_action != "none";
	}
	bool should_update(){
		return ( shots_fired() || shots_charging() ) ;
	}
}
