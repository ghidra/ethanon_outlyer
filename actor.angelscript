#include "obj.angelscript"
//#include "FrameTimer.angelscript"
//#include "isPointInRect.angelscript"

class actor : obj
{
	ETHEntity@ m_entity;

	private float m_spd=1.5;//the speed this character can travel
	private float m_spd_ups;//speed in units per second
	private float m_turnspd=1.5;
	private float m_turnspd_ups; 

	private float m_tspd;//var to use as a timer
	private float m_tspd_ups;
	private float m_timer;//this will be the actual timer

	private vector2 m_destination;//where the player is going
	private vector2 m_destination_past;//where the player was
	private float m_destination_distance_init;//the distance it will take to get to current destination
	private float m_destination_distance;
	private float m_distance_travelled;//the distance covered so far
	private vector2 m_destination_direction;//the direction to get to the distance

	private uint m_directionline = 0;
	private FrameTimer m_frametimer;
	private uint m_currentframe;

	private int m_hp=3;//everything has hit points
	private int m_hpmax=3;//everything has hit points
	private int m_exp=0;//experience
	private int8 m_lvl=0;
	
	private float m_rp=0.0f;//resource points
	private float m_rpmax=0.0f;

	string m_action = "none";// what the pawn should be trying to do
	//obj@ m_target;//this holds a target that we can talk to for specific purposes
	//-----------------

	actor(const string &in entityName, const vector2 pos){
		obj::update();
		AddEntity(entityName, vector3(pos, 0.0f), m_entity);
		m_size = m_entity.GetSize();
		m_pos=pos;
		//get_position();
	}

	void update(){
		obj::update();

		/*if (direction.length() != 0.0f){
			m_frametimer.update(0, 3, 150);
		}else{
			m_frametimer.update(0, 0, 150);
		}

		const uint m_currentframe = m_frametimer.getCurrentFrame();
		*/

		m_spd_ups = UnitsPerSecond(m_spd);
		m_tspd_ups = UnitsPerSecond(m_tspd);
	}
	///--------
	vector2 get_position(){
		vector3 pos = m_entity.GetPosition();
		m_pos = vector2(pos.x,pos.y);
		return m_pos;
	}
	void set_scale(const float s){
		m_entity.Scale(s);
	}
	vector2 get_scale(){
		return m_entity.GetScale();
	}
	float get_rp(){//get the resource points for an object
		return m_rp;
	}
	void set_rp(const float value){//set the resource points
		m_rp = max(0,min(value,m_rpmax));
	}
	float get_rpmax(){//get the resource points for an object
		return m_rpmax;
	}
	void set_rpmax(const float value){//set the resource points
		m_rpmax = value;
	}
	//-----------

	//----
	void set_destination(const vector2 destination){
		m_destination = destination;
		m_destination_direction = destination-get_position();
		m_destination_distance = length(m_destination_direction);
	}
	void move(const vector2 direction){
		if (direction.length() != 0.0f)
			m_frametimer.update(0, 3, 150);
		else
			m_frametimer.update(0, 0, 150);

		// update entity
		const uint currentFrame = m_frametimer.getCurrentFrame();
		m_entity.AddToPositionXY(normalize(direction) * m_spd);
		m_entity.SetFrame(currentFrame, m_directionline);

		get_position();
	}
	//-------
	void delete_entity(){//removes the entity
		DeleteEntity(m_entity);
	}
}
