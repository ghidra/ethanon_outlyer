#include "pawn.angelscript"

class body : pawn
{
	private int m_allegiance = 0;

	//private int base;

	private int m_being_harvested = 0;//if we are being harvested, value will be greater than 0
	private int[] m_minerids;//array to hold the index of the miner from the character array

	private string[] m_buttons_neutral = {"harvest","build base"};
	private string[] m_buttons_ally = {"defend","harvest"};
	private string[] m_buttons_enemy = {"attack"};

	//string m_action = "none";//this is the action we should take, //set from pressing a button

	body(const string &in entityName, const vector2 pos, const string &in label = "unknown"){
		super(entityName,pos,label);

		m_rp = 10.0f;
		m_rpmax = m_rp;

		//@m_rbar = progressbar("resources",m_rp,0.0f,m_rpmax,m_pos);
		@m_rbar = progressbar("resources",m_rp,0.0f,m_rpmax,vector2(),vector2(),m_guibarsize,m_guibardir,1,0,0);
		@m_button_menu = button_menu(m_label,m_pos,m_buttons_neutral);//set the initial button menu data
	}

	void update(){

		m_action = "none";
		pawn::update();

		//vector2 pos = get_relative_position();
		vector2 pos = get_screen_position();
		vector2 pos2 = pos+vector2(0.0f,14.0f);
		
		//string team = 'neutral';


		//logic to build the proper button menu based on what state this body is in
		//--------
		if(m_mouseover){//if the mouse if over us
			if(m_input.GetLeftClickState()==KS_HIT && !m_button_menu.is_open() ){
				//string[] b;
				if(m_allegiance!=0){
					//not used at the moment
					if(m_allegiance>0){
						//m_button_menu.set_buttons();
					}
				}else{
					if(m_being_harvested>0){
						string[] b = {"harvest","collect miner"};
						m_button_menu.set_buttons(b);
					}else{
						string[] b = {"harvest"};
						m_button_menu.set_buttons(b);
					}
				}
				m_pressed=true;
				m_button_menu.open(m_mousepos);
			}
		}
		if(m_button_menu.is_open()){
			//m_button_menu.set_position(m_mousepos);
			m_button_menu.update();
		}
			//if(m_menu_bool == false){//and the menu has not been triggered
				//first clear out the button array
				/*for(uint t = 0; t<m_buttons.length(); t++){
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
						DrawText( pos2+vector2(0.0f,14.0f) , 'harvest' , m_font, m_white);
						DrawText( pos2+vector2(0.0f,28.0f) , 'build base' , m_font, m_white);
					}
				}
				m_menu_bool = true;
				for (uint t=0; t<m_buttons.length(); t++){
		   	 		m_buttons[t].update();
				}*/
			//}else{
				//meu has already been set, just keep drawing it, until timer runs out
			//	for (uint t=0; t<m_buttons.length(); t++){
		   	 //		m_buttons[t].update();
				//}
			//}
		//}
		if(m_onscreen){
			//DrawText( pos , m_label, m_font, m_white);		
			//DrawText( pos2 , m_being_harvested+"" , m_font, m_white);
			//DrawText( pos, (m_pos.x*(1/GetScale()))+"" , m_font, m_white);
			//DrawText( pos2, (m_pos.y*(1/GetScale()))+"" , m_font, m_white);
			m_rbar.set_value(m_rp);

			const vector2 scl = get_scale();
			m_rbar.set_position(get_screen_position()+vector2(m_size.x*scl.x*0.6f,m_guibarwidth/2.0f));
			//m_rbar.set_position(pos);
			m_rbar.update();
		}
		//m_rbar.set_value(m_rbar.get_value()-0.01f);

		

		//--------------

		//now check if any button has been pressed, and if so set our action
		set_button_action();
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
