#include "obj.angelscript"
#include "enemy.angelscript"
#include "pawn.angelscript"

class enemy_factory : obj
{
	private enemy@[] m_enemies;
	private pawn@ m_character;// whom or what to attack---i need to use the lower level object, since that is what the enemies use anyway

	enemy_factory(actor@ character,const string &in label = "unknown"){
		set_label(label);
		@m_character = cast<pawn>(character);
	}


	void update(){
		for (uint t=0; t<m_enemies.length(); t++){
   	 		m_enemies[t].update();
   	 		//if we have been given an action based on button press, we need to pass it to the character
   	 		if(m_enemies[t].get_action() != "none"){
   	 			m_character.set_attack( m_enemies[t].m_action , m_enemies[t] );
   	 		}
		}
	}

	void spawn(enemy@ enemy){
		m_enemies.insertLast( enemy );
		//m_enemies_plotted.insertLast( false );
		//return m_enemies[m_enemies.length()-1];//return it so that we can add it to the mini map
		m_enemies[m_enemies.length()-1].set_global_object(m_global);
	}

	uint num_spawns(){
		return m_enemies.length();
	}
}
