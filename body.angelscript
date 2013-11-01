#include "pawn.angelscript"
#include "Button.angelscript"

class body : pawn
{
	private int m_allegiance = 0;

	//private int base;

	private bool m_menu_bool = false;//if we have triggered the menu to display
	private float m_menu_timer = 5;//how long we have with the mouse not over the menu

	private int m_being_harvested = 0;//if we are being harvested, value will be greater than 0
	private int[] m_minerids;//array to hold the index of the miner from the character array

	private Button@[] m_buttons;//hold buttons
	private string[] m_buttons_neutral = {"harvest","build base"};
	private string[] m_buttons_ally = {"defend","harvest"};
	private string[] m_buttons_enemy = {"attack"};

	//string m_action = "none";//this is the action we should take, //set from pressing a button

	body(const string &in entityName, const vector2 pos){
		super(entityName,pos);

		m_rp = 10.0f;
		m_rpmax = m_rp;

		@m_rbar = progressbar("resources",m_rp,0.0f,m_rpmax,m_pos);
	}

	void update(){

		m_action = "none";
		pawn::update();

		vector2 pos = get_relative_position();
		vector2 pos2 = pos+vector2(0.0f,14.0f);
		
		//string team = 'neutral';


		if(m_mouseover){//if the mouse if over us
			//if(m_menu_bool == false){//and the menu has not been triggered
				//first clear out the button array
				for(uint t = 0; t<m_buttons.length(); t++){
					m_buttons.removeLast();
				}
				//here we trigger the utton menus, and set the button array to have them in it
				vector2 stack_start = vector2(0.0f,14.0f);//here to start the menu relative to the body
				if(m_allegiance!=0){
					if(m_allegiance>0){
						//string team = 'ally';
						if(m_mouseover){
							DrawText( pos2+vector2(0.0f,14.0f) , 'defend' , m_font, m_white);
						}
					}else{
						//string team = 'enemy';
						if(m_mouseover){ 
							DrawText( pos2+vector2(0.0f,14.0f) , 'attack' , m_font, m_white);
						}
					}
				}else{
					if(m_mouseover){
						uint c = 0;
						for (uint t=0; t<m_buttons_neutral.length(); t++){
		   	 				m_buttons.insertLast( Button( m_buttons_neutral[t], pos2+(stack_start*(t+1))) );
		   	 				c = t;
						}
						if(m_being_harvested>0){
							m_buttons.insertLast( Button( 'collect miner', pos2+(stack_start*(c+2))) );	
						}
						//DrawText( pos2+vector2(0.0f,14.0f) , 'harvest' , m_font, m_white);
						//DrawText( pos2+vector2(0.0f,28.0f) , 'build base' , m_font, m_white);
					}
				}
				m_menu_bool = true;
				for (uint t=0; t<m_buttons.length(); t++){
		   	 		m_buttons[t].update();
				}
			//}else{
				//meu has already been set, just keep drawing it, until timer runs out
			//	for (uint t=0; t<m_buttons.length(); t++){
		   	 //		m_buttons[t].update();
				//}
			//}
		}
		DrawText( pos , m_label, m_font, m_white);		
		DrawText( pos2 , m_being_harvested+"" , m_font, m_white);
		//m_rbar.set_value(m_rbar.get_value()-0.01f);
		m_rbar.set_value(m_rp);
		m_rbar.update();

		

		//--------------

		//now check if any button has been pressed, and if so set our action
		for (uint t=0; t<m_buttons.length(); t++){
			if(m_buttons[t].is_pressed()){
				m_action = m_buttons[t].get_label();
			}
		}
		//------set the action

	}

	void add_miner(const uint id){//we are adding a miner
		m_minerids.insertLast(id);
		m_being_harvested+=1;
	}
	uint subtract_miner(){//removes a miner and returns the id so that it can be removed from the main array in the character object
		uint id = m_minerids[m_minerids.length-1];
		m_minerids.removeLast();//remove the last element
		m_being_harvested-=1;
		return id;
	}
	
}
