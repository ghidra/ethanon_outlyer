#include "actor.angelscript"
#include "projectile.angelscript"
#include "progressbar.angelscript"

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
		if(m_timer>=1){
			set_timer(0.0f);
			fire();
		}else{
			update_timer();
			m_tbar.set_value(get_timer());
		}

		for(uint t=0; t<m_projectiles.length(); t++){
			m_projectiles[t].update();
		}
	}

	void draw_tbar(){
		//i need to have this thing placed specifically before drawing it anyway 
		m_tbar.update();
	}

	void fire(){//fire projectile
		m_projectiles.insertLast( projectile("random.ent", vector2(100.0f,100.0f), m_destination) ) ;
	}
}
