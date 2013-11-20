//this class handles how inputs from buttons are treated. and keeping in order what actions to take, and possible have a
//que of actions in the future
class controller{

	private string[] m_actions;//an array of actions
	private uint m_max_actions = 0;//0 is infinite I guess

	private string[] m_targettypes;

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
		m_actors.insertLast( target );
		m_targettypes.insertLast("actor");
	}
	void set_action( const string action, pawn@ target){
		m_actions.insertLast( action );
		m_pawns.insertLast( target );
		m_targettypes.insertLast("pawn");
	}
	void set_action( const string action, body@ target){
		m_actions.insertLast( action );
		m_bodies.insertLast( target );
		m_targettypes.insertLast("body");
	}
	void set_action( const string action, enemy@ target){
		m_actions.insertLast( action );
		m_enemies.insertLast( target );
		m_targettypes.insertLast("enemy");
	}
	//-----------
	void finish_action(){//remove the latest action that was completed
		m_actions.removeAt(0);
	}
	//---utility function
	string print_actions(){
		string s="";
		for(uint t=0; t<m_actions.length(); t++){
			s+=m_actions[t]+",";
		}
		return s;
	}
}
