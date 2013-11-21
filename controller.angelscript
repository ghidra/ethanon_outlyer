//this class handles how inputs from buttons are treated. and keeping in order what actions to take, and possible have a
//que of actions in the future
#include "body.angelscript"
#include "enemy.angelscript"
#include "pawn.angelscript"
#include "actor.angelscript"

class controller{

	private string[] m_actions;//an array of actions
	private string[] m_targettypes;//an array that mirrors the m_actions array that knows which array to reference when it comes to getting the target
	private uint[] m_targetindex;//another mirroring array that knows where in the array to look.
	
	private uint m_max_actions = 0;//0 is infinite I guess

	private body@[] m_bodies;//arrays to hold the target of the actions
	private enemy@[] m_enemies;
	private pawn@[] m_pawns;
	private actor@[] m_actors;

	controller(){
		
	}

	void update(){
		
	}
	//-------
	void set_action( const string action, actor@ target){
		m_actions.insertLast( action );
		m_targettypes.insertLast("actor");
		m_targetindex.insertLast(m_actors.length());

		m_actors.insertLast( target );
	}
	void set_action( const string action, pawn@ target){
		m_actions.insertLast( action );
		m_targettypes.insertLast("pawn");
		m_targetindex.insertLast(m_pawns.length());

		m_pawns.insertLast( target );
	}
	void set_action( const string action, body@ target){
		m_actions.insertLast( action );
		m_targettypes.insertLast("body");
		m_targetindex.insertLast(m_bodies.length());

		m_bodies.insertLast( target );
	}
	void set_action( const string action, enemy@ target){
		m_actions.insertLast( action );
		m_targettypes.insertLast("enemy");
		m_targetindex.insertLast(m_enemies.length());

		m_enemies.insertLast( target );
	}
	//-----------
	bool has_actions(){
		return m_actions.length>0;
	}
	string get_action(){//returns the first action in the list
		return m_actions[0];
	}
	actor@ get_target_actor(const uint i = 0){
		return m_actors[i];
	}
	body@ get_target_body(const uint i = 0){
		return m_bodies[i];
	}
	enemy@ get_target_enemy(const uint i = 0){
		return m_enemies[i];
	}
	pawn@ get_target_pawn(const uint i = 0){
		return m_pawns[i];
	}
	//-----------
	void remove_action(const uint i = 0){//remove the latest action that was completed
		//get the data I will need to remove the right values at the right place in the right array
		const string target_type = m_targettypes[i]; 
		const uint target_index = m_targetindex[i];

		m_actions.removeAt(i);
		m_targettypes.removeAt(i);
		m_targetindex.removeAt(i);

		//i need to remove from the proper object array
		//and also update any index identifiers related to the array
		if(target_type == "actor"){
			m_actors.removeAt(target_index);
		}
		if(target_type == "pawn"){
			m_pawns.removeAt(target_index);	
		}
		if(target_type == "body"){
			m_bodies.removeAt(target_index);
		}
		if(target_type == "enemy"){
			m_enemies.removeAt(target_index);
		}

		for(uint t=0; t<m_targetindex.length(); t++){
			if(m_targettypes[t]==target_type){//if this index is related to the target type we removed, we need to check if the index  valus is above what we removes to fix it 
				if(m_targetindex[t]>target_index){//modify it if this is true
					m_targetindex[t]-=1;
				}
			}
		}
		//------
	}
	//---utility function
	string print_actions(){
		string s="";
		for(uint t=0; t<m_actions.length(); t++){
			s+=m_actions[t];
			if(m_actions.length()-1 != t){
				s+=",";
			}
		}
		return s;
	}
}
