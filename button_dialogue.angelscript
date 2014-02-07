#include "Button.angelscript"

class button_dialogue : Button{

	//private Button@[] m_buttons;
	//private string[] m_labels;//hold the labels to the buttons
	private string m_action="none";

	private bool m_open = false;//wether this thing is open
	private float m_timer = 0.0f;//the timer to start counting if it is open, so we can close it afterward
	private float m_timer_duration = 2.0f;//how long to keep the menu open
	private float m_tspd = 1.0f;// the timer speed

	private float m_width = 0.0f;//this is the overall width, incase we want to keep it all consistent, which seems only right
	private float m_height = 0.0f;//this will the the height of everything, all the buttons etc

	//private vector2 m_bgpos;
	//private vector2 m_bgsize;

	button_dialogue(const string _label, global@ _g, const vector2 &in _pos = vector2(0.0f,0.0f), const vector2 &in _origin = vector2(0.0f, 0.0f))
	{
		super(_label,_pos,_origin);//i have to do this, cause the base class does not have a constructor

		m_width = m_size.x;//get the width of the main button, to start off the size.

		set_global_object(_g);

		open();
	}

	void update()
	{
		//Button::update();
		obj::update();
		//ETHInput@ input = GetInputHandle();

		m_pressed=false;
		//m_screensize = GetScreenSize();
		vector2 bgpos = vector2(0.0f, (m_screensize.y/2)-(m_size.y/2) ) ;
		vector2 bgsize = vector2(m_screensize.x,m_size.y);
		//center text
		vector2 tpos = vector2( (bgsize.x/2)-(m_size.x/2), bgpos.y );
		// check if any touch (or mouse) input is pressing the button
		const uint touchCount = m_input.GetMaxTouchCount();
		for (uint t = 0; t < touchCount; t++)
		{
			if (m_input.GetTouchState(t) == KS_HIT && m_timer>0.0f)
			{
				//if (isPointInButton(input.GetTouchPos(t)))
				//if (is_point_in_bb(m_input.GetTouchPos(t)))
				//{
					m_pressed = true;
				//}
			}
		}
		//m_timer+=UnitsPerSecond(m_tspd);
		m_timer+=1.0f;
		///---draw
		/*if( this.is_point_in_bb(m_input.GetCursorPos()) ){
			DrawShapedSprite("sprites/pixel_white.png", m_pos-m_offset, m_size, m_white);
		}else{
			DrawShapedSprite("sprites/pixel_white.png", m_pos-m_offset, m_size, m_grey);
		}*/
		DrawShapedSprite("sprites/pixel_white.png",bgpos,bgsize,m_grey);
		DrawText( tpos , m_label + m_pressed, m_font, m_white);
		
		/*for (uint t =0; t<m_buttons.length(); t++){
			m_buttons[t].update();
		}

		//use the timer to determine how long I can be open, and set it to not open when timer is up
		m_timer+=UnitsPerSecond(m_tspd);
		DrawText( m_pos+vector2(0.0f,m_height+m_margin.y) , decimal(m_timer_duration - m_timer,10)+"", m_font, m_white);
		if(m_timer>=m_timer_duration){
			m_open=false;
		}*/
		if(m_pressed){
			m_open=false;
			if(m_global !is null){
				m_global.set_time_multiplier(1.0f);
			}
		}
		
	}

	//setting the position, also nees to set the position of all the buttons under neith this
	//this will also take the position, and center justify, to bottom right left position it, off the given position
	void set_position(const vector2 pos){
		Button::set_position(pos+m_margin);
		//now loop the buttons
		/*for (uint t =0; t<m_buttons.length(); t++){
			const vector2 size = m_buttons[t].get_size();
			m_buttons[t].set_position( m_pos+vector2(0.0f,(size.y+m_margin.y)*(t+1)) );
		}*/
	}

	bool is_open(){//return if we are open already or not
		return m_open;
	}

	void open(){//when we trigger to open the menu, we need to set some values
		m_open=true;
		m_timer=0.0f;

		if(m_global !is null){
			m_global.set_time_multiplier(0.0f);
		}
		//set_position(pos);
	}

	//bool is_point_in_bb(const vector2 &in p) const{
	//	return (isPointInRect(p, m_pos, m_size, m_origin));
	//}
	//this loop through the available buttons and see which one is pressed and return the label of that button
	string get_action(){
		/*m_action="none";
		for (uint t=0; t<m_buttons.length(); t++){
			if(m_buttons[t].is_pressed()){
				m_action = m_buttons[t].get_label();
				m_timer = m_timer_duration;//just advanec the timer so that it closes the menu
				//m_open=false;
			}
		}
		//now check the header button, maybe if we care
		if(is_pressed()){
			m_action = "pressed header";
			m_timer = m_timer_duration;
			//m_open=false;
		}
		*/
		return m_action;
	}
}

