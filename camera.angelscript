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

	//scene scale information
	private float m_scale = 1.0f;

	private bool m_scalepressed = false;
	private float m_scalestartpos;//this will be set based on where the press was started, x or y, to begin the scalling
	private float m_scalefactor = 0.0f;//the amount to add to the scale
	private float m_scaledragmultiplier = 0.001;//the amount to multiply the drag by to add to the scale
	private float m_scaleprevious;//this hold the previous scale value, so we dont get a weird pop everytime we try this

	//dragging variables
	private bool m_dragpressed = false;//used to determine if we have started the drag
	private bool m_drag = false;//we are told that we can drag this from another class
	private vector2 m_dragstart;//where we started the drag in camera space
	private vector2 m_relativedragstart;//where we started the drag in screen space
	private vector2 m_relativemousepos;
	private vector2 m_pos;//where we are

	camera(){

	}

	void update(){

		//-------------------------------
		//-------------------------------
		//scale to simulate zooming in and out

		//this only uses the mouse currently, and no use of touch commands
		ETHInput@ input = GetInputHandle();
		const vector2 mousepos = input.GetCursorPos();

		//const uint touchCount = input.GetMaxTouchCount();
		//for (uint t = 0; t < touchCount; t++)
		//{
			//const vector2 mp = input.GetTouchPos(t); 
			//if (input.GetTouchState(t) == KS_HIT)
			if(input.GetRightClickState()==KS_HIT && !m_scalepressed)
			{
				m_scalestartpos = mousepos.x;//mp.x;
				m_scaleprevious = m_scale;
				m_scalepressed=true;
				//temp = "hit";
			}
			if(input.GetRightClickState()==KS_DOWN && m_scalepressed){
				m_scalefactor = (mousepos.x-m_scalestartpos)*m_scaledragmultiplier;//mp.x-m_scalestart;
				m_scale = m_scaleprevious+m_scalefactor;
				SetScaleFactor(m_scale);
			}
			if(input.GetRightClickState()==KS_RELEASE && m_scalepressed){
				m_scalepressed=false;
			}
			//DrawText(vector2(0,200), "camera scale:"+m_scale+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		//}
			//dragging
			if(input.GetLeftClickState()==KS_HIT && !m_dragpressed && m_drag){
				m_dragpressed=true;
				m_relativedragstart = mousepos+m_pos;//mousepos+(m_pos*(1/GetScale()));
			}
			if(input.GetLeftClickState()==KS_DOWN && m_dragpressed && m_drag){
				//draw_line(m_pos-m_camerapos,m_mousepos,m_white,m_white,1.0f);

				//keep the camera on the mouse
				/*m_relativemousepos = mousepos - GetCameraPos();

				const vector2 target = m_relativemousepos; //m_target_actor.get_position();
				const vector2 screenMiddle(GetScreenSize() * 0.5f);
				set_position(target-screenMiddle);*/

				//const vector2 campos = GetCameraPos();
				const vector2 dragged = m_relativedragstart-mousepos;
				const vector2 place = m_dragstart+dragged;

				set_position(place);
				DrawText(vector2(0,24), "m_pos:"+mousepos.x+","+mousepos.y+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			}
			if(input.GetLeftClickState()==KS_RELEASE && m_dragpressed && m_drag){
				//set the destination
				//set_destination(m_relativemousepos);
				//m_moving=true;
				m_dragpressed=false;
				m_drag=false;
			}
		//-------------------------------
		//-------------------------------

		//now track the target
		if(m_track_target){
			const vector2 target = m_target_actor.get_position();
			const vector2 screenMiddle(GetScreenSize() * 0.5f);
			set_position(target-screenMiddle);
		}
	}

	void set_position(const vector2 pos){
		SetCameraPos(pos);
		m_pos=pos;
	}
	vector2 get_position(){
		return vector2(GetCameraPos());
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
	bool get_drag(){
		return m_drag;
	}
	void set_drag(const bool d = true){
		m_drag=d;
	}

}
