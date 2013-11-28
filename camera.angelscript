#include "actor.angelscript"
#include "pawn.angelscript"
#include "enemy.angelscript"
#include "body.angelscript"

class camera
{

	//the camera is a default object. All I am doing in this class is giving is a target and speed to keep it in focus.
	//just basic camera movement control.

	//private body@ m_target_body;//variables to hold the target of the actions
	//private enemy@ m_target_enemy;
	//private pawn@ m_target_pawn;
	private actor@ m_target_actor;

	//private string m_target_type;

	private bool m_track_target = true;

	camera(){

	}

	void update(){
		if(m_track_target){
			const vector2 target = m_target_actor.get_position();
			const vector2 screenMiddle(GetScreenSize() * 0.5f);
			set_position(target-screenMiddle);
		}
	}

	void set_position(const vector2 pos){
		SetCameraPos(pos);
	}
	//-------
	void set_track_target(const bool b){
		m_track_target=b;
	}
	bool get_track_target(){
		return m_track_target;
	}
	//-------
	void set_target(actor@ target){
		@m_target_actor = target;
		//m_target_type = "actor";
		//update();
	}
	/*void set_target(pawn@ target){
		@m_target_pawn = target;
		m_target_type = "pawn";
	}
	void set_target(body@ target){
		@m_target_body = target;
		m_target_type = "body";
	}
	void set_target(enemy@ target){
		@m_target_enemy = target;
		m_target_type = "enemy";
	}*/
}
