#include "obj.angelscript"
#include "global.angelscript"
//#include "FrameTimer.angelscript"
//#include "isPointInRect.angelscript"

class actor : obj
{
	ETHEntity@ m_entity;

	//private float TIME_DIALATION = 1.0f;//this will allow me to build in my own paue function, and slwo ans speed up time

	private float m_spd=100.0f;//the speed this character can travel
	private float m_spd_ups;//speed in units per second
	private float m_turnspd=1.5f;
	private float m_turnspd_ups; 

	private float m_tspd = 0.5f;//var to use as a timer
	private float m_tspd_ups;
	private float m_timer = 0.0f;//this will be the actual timer, 1 will be the cap

	private vector2 m_destination;//where the player is going
	private vector2 m_destination_past = vector2(0.0f,0.0f);//where the player was
	private float m_destination_distance_init;//the distance it will take to get to current destination
	private float m_destination_distance;
	private float m_distance_travelled;//the distance covered so far
	private vector2 m_destination_direction;//the direction to get to the distance

	private float m_travel_cost_per_unit = 0.01f;//the cost per unit to travel
	private float m_travel_cost = 0.0f;

	private uint m_directionline = 0;
	private FrameTimer m_frametimer;
	private uint m_currentframe;

	private float m_hp=3.0f;//everything has hit points
	private float m_hpmax=10.0f;//everything has hit points
	private int m_exp=0;//experience
	private int m_lvl=0;
	
	private float m_rp=0.0f;//resource points
	private float m_rpmax=0.0f;

	//moving variables
	private vector2 m_movingdirection;
	private float m_movingangle;
	private float m_angleframes = 360.0f/16.0f;//how many frames we have for each angle

	string m_action = "none";// what the pawn should be trying to do
	//bool m_dying = false;
	bool m_died = false;
	//private string m_actionlocal = "none";//this is a variable that is useful to do local actions
	//m_action is used for the main character to determine if we need to act on it, from the users perspective
	//obj@ m_target;//this holds a target that we can talk to for specific purposes
	//-----------------

	actor(const string &in entityName, const vector2 pos, const string &in label = "unknown" ){
		//super(label);
		set_label(label);
		/*obj::update();
		AddEntity(entityName, vector3(pos, 0.0f), m_entity);
		m_size = m_entity.GetSize();
		m_pos=pos;*/
		init_entity(entityName,pos);
		//get_position();
	}
	void init_entity(const string &in entityName, const vector2 pos){
		obj::update();
		AddEntity(entityName, vector3(pos, 0.0f), m_entity);
		m_size = m_entity.GetSize();
		m_pos=pos;
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
		if(m_entity !is null){
			m_pos = m_entity.GetPositionXY();//this is so that the global scale hands the xy value to the object here
		}
		float t_mult = 1.0f;//time multipler  
		if(m_global !is null){
			t_mult = m_global.time_multiplier();
		}
		m_spd_ups = UnitsPerSecond(m_spd)*t_mult;// * TIME_DIALATION;
		m_tspd_ups = UnitsPerSecond(m_tspd)*t_mult;// * TIME_DIALATION;

		update_destination_distance();
	}
	///--------
	vector2 get_position(){
		//vector3 pos = m_entity.GetPosition();
		//m_pos = vector2(pos.x,pos.y);
		//m_pos = m_entity.GetPositionXY();
		return vector2(m_pos);
	}
	//z
	void set_z(const float z){
		if(m_entity !is null){
			m_entity.SetPositionZ(z);
		}
	}
	//scale
	void set_scale(const float s){
		if(m_entity !is null){
			m_entity.Scale(s);
		}
	}
	vector2 get_scale(){
		vector2 scl = vector2(1.0f);
		if(m_entity !is null){
			scl = m_entity.GetScale();
		}
		return scl;
	}
	//resource points
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
	//timer
	float get_timer(){
		return m_timer;
	}
	void set_timer(const float value){
		m_timer = max(0.0f,min(value,1.0f));
	}
	void update_timer(){
		m_timer = max(0.0f,min( m_timer+(m_tspd*m_tspd_ups), 1.0f));
	}

	//-----------
	//----
	void set_destination(const vector2 destination){
		//set the past information
		float diff = length( destination - m_destination_past);
		if(diff > 0.01f){//we can set the past destination and other info since we have new destination
			m_destination_past = m_destination;
		}
		//now set the new destination information
		m_destination = destination;
		m_destination_direction = destination-get_position();
		m_destination_distance_init = length(m_destination_direction);
		//m_destination_distance = length(m_destination_direction);
		update_destination_distance();
	}
	void update_destination_distance(){
		vector2 dir = m_destination-get_position();
		float dp = dot(m_destination_direction,normalize(dir));
		m_destination_distance = 0;
		if(dp>0){
			m_destination_distance = length(dir);
		}
		//m_destination_distance_init = length(m_destination_direction);
	}
	void clear_destination(){

	}
	//------
	void set_action(const string action){
		m_action = action;
	}
	string get_action(){
		return m_action;
	}
	/*void set_action_local(const string action){
		m_actionlocal = action;
	}
	string get_action_local(){
		return m_actionlocal;
	}*/
	/*vector2 get_destination(){
		return m_destination;
	}*/
	void move(const vector2 direction){
		if (direction.length() != 0.0f)
			m_frametimer.update(0, 3, 150);
		else
			m_frametimer.update(0, 0, 150);

		//update moving variables
		m_movingdirection = normalize(direction);
		m_movingangle = draw_angle(m_movingdirection);
		if(m_movingangle<0){//i need to correct the value given to me by draw angle
			m_movingangle=360-abs(m_movingangle);
		}
		//if the angle is negative we need to add the abs value to 180.

		// update entity
		//const uint currentFrame = m_frametimer.getCurrentFrame();
		m_entity.AddToPositionXY(m_movingdirection * m_spd_ups);

		//frame 0 is pointing to the right
		//frame 4 is pointing up
		//frame 8 is poiting left
		//frame 12 is pointing down
		//frame 16 is almost pointg right again

		//m_entity.SetFrame(currentFrame, m_directionline);
		uint f = m_movingangle/m_angleframes;
		m_entity.SetFrame( f );

		get_position();//this also sets the position variable
		update_destination_distance();
	}
	float get_travel_cost(const vector2 dest){
		float dist = length(m_pos - dest);
		return dist * m_travel_cost_per_unit;
	}
	//-------
	void take_damage(const float amount){
		m_hp = max(0.0f,min(m_hp-amount,m_hpmax));
		if(m_hp<=0.0f){
			die();
		}
	}
	void spend_resources(const float amount){
		m_rp = max(0.0f,min(m_rp-amount,m_rpmax));
	}

	void die(){//start the dying process
		delete_entity();
		m_died = true;
		//init_entity("explosion_01.ent",m_pos);
	}
	bool has_died(){
		return m_died;
	}

	//-------
	void delete_entity(){//removes the entity
		if(m_entity !is null){
			@m_entity = DeleteEntity(m_entity);

		}
	}
}
