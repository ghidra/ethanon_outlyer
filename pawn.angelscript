#include "actor.angelscript"
#include "inventory.angelscript"
#include "progressbar.angelscript"
#include "weapon.angelscript"
#include "Button.angelscript"
#include "button_menu.angelscript"
#include "controller.angelscript"
#include "enemy.angelscript"
#include "body.angelscript"

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
	private progressbar@ m_hbar;//hip point bar

	private inventory@ m_inventory;

	private Button@[] m_buttons;//hold buttons
	private button_menu@ m_button_menu;

	private bool m_menu_bool = false;//if we have triggered the menu to display
	private float m_menu_timer = 5;//how long we have with the mouse not over the menu

	private int m_state = 0;//
	//obj@ m_target;
	//actor@ m_target;

	//----
	//pawn@ m_targetpawn;//the body that we are targeting, the main character
	actor@ m_target;
	private weapon@ m_weapon;
	private uint m_attacktype;//0 is do not attack, 1 basic 2 strong etc, potentially -1 is defend
	private string m_actionweapon = "none";//this is a variable to manage weapon actions

	private controller@ m_controller;//the movement controller of this thing
	private controller@ m_attcontroller;//the attack controller of this thing

	private vector2 m_guibarsize = vector2(20.0f,20.0f);//size of the bar
	private vector2 m_guibardir = vector2(-0.5f,-0.5f);//size of the bar
	private float m_guibarwidth;//this will be the pythagorean width if i need it, for stacking shit
	private float m_guibarmargin = 4.0f;
	private float m_guimargin = 20.0f;

	pawn(const string &in entityName, const vector2 pos, const string &in label = "unknown"){
		super(entityName,pos,label);
		@m_controller = controller();
		@m_attcontroller = controller();
		@m_inventory = inventory();

		@m_hbar = progressbar("hit points",m_hp,0.0f,m_hpmax,vector2(),vector2(),m_guibarsize,m_guibardir,1,0,0);
		m_guibarwidth = pythagorean(m_guibarsize.x,m_guibarsize.y);
	}

	void update(){
		if(!has_died()) actor::update();//if we have died, there is no reason to update this stuff anymore
		//if(m_mouseover){
		//	vector2 pos = get_relative_position();
		//	DrawText( pos , m_label, m_font, m_white);
		//}
		
	}

	void set_target(actor@ target){
		@m_target = target;
	}

	/*void init_inventory(){//call this to initialize the inventory
		@m_inventory = inventory();
	}*/

	//------weapons functions
	//void check_weapon_projectiles(){//loop through the projectiles and find out if they have hit our target
	//	m_weapon.check_projectiles_hit_target(m_targetpawn);
	//}
	//------
	void set_global_object(global@ g){
		@m_global = g;
		if(m_weapon !is null){
			m_weapon.set_global_object(g);
		}
		if(m_global.has_minimap()){//if the global object has the minimap, lets plot us!
			m_global.plottable(@this);
		}
	}

	void set_action_weapon(const string action){
		m_actionweapon = action;//this sets the weapon specific action
	}
	string get_action_weapon(){
		return m_actionweapon;
	}
	//-----
	void set_button_action(){//this sets m_action based on button use
		
		if(m_button_menu !is null){
			//if we even have a button menu, use this command, if not use the hopefully soon to obsolete m_buttons array
			m_action = m_button_menu.get_action();
		}else{
			//this should soon be removed once all parties use the button menu
			//-----
			for (uint t=0; t<m_buttons.length(); t++){
				if(m_buttons[t].is_pressed()){
					m_action = m_buttons[t].get_label();
				}
			}
			///
			////
		}
	}
	//setting the action with the target of the action
	void set_action(const string action, actor@ target){
		//actor::set_action(action);
		if(!has_died()) m_controller.set_action(action,target);
	}
	/*void set_action(const string action, pawn@ target){
		//actor::set_action(action);
		if(!has_died()) m_controller.set_action(action,target);
	}
	void set_action(const string action, body@ target){
		//actor::set_action(action);
		if(!has_died()) m_controller.set_action(action,target);
	}
	void set_action(const string action, enemy@ target){
		//actor::set_action(action);
		if(!has_died()) m_controller.set_action(action,target);
	}*/
	//-----
	void set_attack(const string action, actor@ target){
		//actor::set_action(action);
		if(!has_died()) m_attcontroller.set_action(action,target);
	}
	/*void set_attack(const string action, pawn@ target){
		//actor::set_action(action);
		if(!has_died()) m_attcontroller.set_action(action,target);
	}
	void set_attack(const string action, body@ target){
		//actor::set_action(action);
		if(!has_died()) m_attcontroller.set_action(action,target);
	}
	void set_attack(const string action, enemy@ target){
		//actor::set_action(action);
		if(!has_died()) m_attcontroller.set_action(action,target);
	}*/
	//----

	//----
	//these functions are called on every update, to determine if we need to attack, and if so, handle the attacking

	bool attack_ready(){
		bool attack = false;
		if(m_attcontroller.has_actions() && !has_died()){//if our attack controller has actions to give us
			const string action = m_attcontroller.get_action();//this gets the action we need to try and perform
			if(action == "attack"){
				if(m_weapon.get_action() == "none"){//if the weapon is trying to fire
					attack = true;//we are go with starting another attack
				}
			}
		}
		return attack;
	}

	void attack(actor@ target){
		if(!has_died()){
			m_weapon.set_target(target);
			//attack_start();
			m_weapon.set_action( "attack" );
			m_attcontroller.remove_action();
		}
	}
	/*void attack(pawn@ target){
		if(!has_died()){
			m_weapon.set_target(target);
			attack_start();
		}
	}
	void attack(body@ target){
		if(!has_died()){
			m_weapon.set_target(target);
			attack_start();
		}
	}
	void attack(enemy@ target){
		if(!has_died()){
			m_weapon.set_target(target);
			attack_start();
		}
	}*/
	//---
	/*void attack_start(){
		if(!has_died()){
			m_weapon.set_action( "attack" );
			m_attcontroller.remove_action();
		}
	}*/
	void update_weapon(){
		if( m_weapon.should_update() ){
			if(has_died()) m_weapon.set_action("none");//make sure we dont fire again after we are dead
			m_weapon.update();
		}
	}
	//-----------------
	//-----------------
	void die(){
		if(m_weapon !is null){
			m_weapon.die();
		}
		actor::die();
	}
}
