#include "actor.angelscript"
#include "progressbar.angelscript"

class pawn : actor{
	//-----------------
	//-----------------
	//-----------------
	//this.attributes = {};
	//this.attributes_base={};
	//this.attributes_max={};
	//this.attributes_visualized={};

	
	//private float m_ap=0;//attack points
	//private float m_dp=0;//defence points
	//private float m_accp=0;//acuracy
	//private float m_evap=0;//evade points

	//private float m_eqweapon=0;
	//private float m_eqshield=0;
	//private float m_inweapin=0;
	//private float m_inshield=0;

	//private float m_miners=0;
	//private float m_bases=0;

	//private string m_label="unlabeled";

	//this.location = new game.vector2(0,0);
	//private bool m_destination_set = false;

	//string 

	private progressbar@ m_rbar;//progress bar to hold resource read out

	//timers
	

	private int m_state = 0;//
	//obj@ m_target;
	actor@ m_target;

	pawn(const string &in entityName, const vector2 pos){
		super(entityName,pos);
	}

	void update(){
		actor::update();
		if(m_mouseover){
			vector2 pos = get_relative_position();
			DrawText( pos , m_label, m_font, m_white);
		}
		
	}
	//------
	//resource points getter and setters
	
	//----
	//void set_target(obj@ target){
	//	@m_target = target;
	//}
	void set_target(actor@ target){
		//m_atarget.removeAt(0);
		//m_atarget.insertLast(target);
		@m_target = target;
	}
}
