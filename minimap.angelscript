#include "obj.angelscript"
class minimap : obj
{
	//this class will be a minimap in the corner of he screen. It will allow us to move the camera around indipendant of the character
	//as well as giving us an option to zoom in and out 

	private float m_format = 100.0f;//this is the height of the map at the corner
	private float m_aspect;

	private int m_type = 0;//0 = adaptive 1 = camera centered

	private float m_intmargin = 400.0f;//this is the margin to the interior edge of the map, so that nothing lives on the very edge, in world size
	private float m_extmargin = 20.0f;//the margin of this to the edge of the screen

	private vector2 m_tl;//top left vector position
	private vector2 m_br;//bottom right position
	private vector2 m_tr;//top right
	private vector2 m_bl;//bottom left

	private vector2 m_center;//the center of the mini map

	private float m_zoom = 4;//this is the zoom factor, 1, is one to one, what is on screen, higher numbers zoomz out, lower than one might make it zoom in

	private vector2[] m_plottable_positions;//positions
	private uint[] m_plottable_colors;//colors

	minimap(){
		set_format(m_format);
	}

	void set_format(const float f){
		const vector2 ss = GetScreenSize();
		m_format = f;
		m_aspect = ss.x/ss.y;
		m_size = vector2(f*m_aspect,f);

		m_tl = vector2( ss.x-(m_size.x+m_extmargin), ss.y-(m_size.y+m_extmargin) );
		m_br = vector2( ss.x-m_extmargin, ss.y-m_extmargin );

		m_tr = vector2(m_br.x,m_tl.y);
		m_bl = vector2(m_tl.x,m_br.y);

	}

	void plottable(const vector2 p){//positions and color
		
		m_plottable_positions.insertLast(p);
		//m_plottable_colors.inserLast(c);

	}

	void update(){
		//here is where we draw the maps data, starting with the edges
		draw_line( m_tl, m_tr, m_white, m_white, 1.0f );//top
		draw_line( m_tr, m_br, m_white, m_white, 1.0f );//right
		draw_line( m_bl, m_br, m_white, m_white, 1.0f );//bottom
		draw_line( m_tl, m_bl, m_white, m_white, 1.0f );//left

		m_center = vector2( m_tl.x+(fdistance(m_tl.x,m_tr.x))/2, m_tl.y+(fdistance(m_tl.y,m_bl.y))/2 );


		//after everything, empty the arrays
		//m_plottable_positions = vector2[];
		if(m_type==0){//loop objects so I can determine map size, this is adaptive style
			
			vector2 atl;
			vector2 abr;
			vector2 adime;
			vector2 acenter;
			float aaspect;
			float aexpand;//the value that we will need to expand by
			float ascale;

			uint temp;

			vector2 azerotrans;//the vector to move eerything to 0,0 from center
			vector2 amaptrans;//the vector to get it back in the map space
			//float ad;

			for(uint t = 0; t < m_plottable_positions.length(); t++){//loop plottable objects
				//uint i = m_plottable_positions.length()-(t+1);//use this to go backwards, so that we remove them from the end first
				if(t==0){
					atl = vector2(m_plottable_positions[t]);
					abr = vector2(m_plottable_positions[t]);
				}else{
					if(m_plottable_positions[t].x<atl.x){
						atl.x=m_plottable_positions[t].x;
					}
					if(m_plottable_positions[t].y<atl.y){
						atl.y=m_plottable_positions[t].y;
					}
					if(m_plottable_positions[t].x>abr.x){
						abr.x=m_plottable_positions[t].x;
					}
					if(m_plottable_positions[t].y>abr.y){
						abr.y=m_plottable_positions[t].y;
					}
				}
				//now remove the positions from the array
				//m_plottable_positions.removeLast();

			}

			//now we need to get the aspect of bounding points, so that we can expand the bounding poitns to
			//match the aspect of the screen
			adime = vector2(abs(abr.x-atl.x),abs(abr.y-atl.y));
			aaspect = adime.x/adime.y;

			/*if(m_aspect<aaspect){//we need to expant the left and right edges
				//ad = fdistance(abr.x,atl.x);//this is the width of the layout
				aexpand = expand(m_aspect,aaspect, fdistance(abr.x,atl.x) );//abs((((m_aspect/aaspect)*ad)-ad)/2);
				atl.x-aexpand;
				abr.x+aexpand;
			}else{
				//ad = abs(abr.y - atl.y);
				aexpand = expand(m_aspect,aaspect, fdistance(abr.y,atl.y) ); //abs((((m_aspect/aaspect)*ad)-ad)/2);
				atl.y-aexpand;
				abr.y+aexpand;
			}*/
			//now we know the bounding points add in some margins
			atl+=vector2(-m_intmargin,-m_intmargin);
			abr+=vector2(m_intmargin,m_intmargin);

			//now that they bounding points have been expanded, we need to look at 
			//getting the center point of the boundin points
			adime = vector2(abs(abr.x-atl.x),abs(abr.y-atl.y));
			aaspect = adime.x/adime.y;
			acenter = vector2( fdistance(atl.x,abr.x)/2, fdistance(atl.y,abr.y)/2 );

			//figure out how much to scale the plot points
			ascale = m_format/adime.y;//this is how much to scale it to fit into the minimap
			//get the direction of the center of the object to 0,0
			azerotrans = vector2()-acenter;
			amaptrans = m_center-vector2();

			//now move all the points by this vector
			temp = m_plottable_positions.length();
			for(uint t = 0; t < m_plottable_positions.length(); t++){
				uint i = m_plottable_positions.length()-1;//go inrevers because we will remove them from the array now as well
				m_plottable_positions[i] += azerotrans;//translate them toward center
				m_plottable_positions[i] *= ascale;//scale them fuckers
				m_plottable_positions[i] += amaptrans;//move it to map space

				//now we can draw the point
				DrawShapedSprite("sprites/pixel_white.png", m_plottable_positions[i], vector2(2, 2), m_white,0.0);

				//once we are done, remove those fuckers
				m_plottable_positions.removeLast();
			}

			//now I need to force it into my screen ratio, so that I can scale all the positins down to fit where I need them to fit in the map

			//DrawText(vector2(0,80), "map x:"+aformat.x+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			DrawText(vector2(0,100), "plottable:"+temp+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			DrawText(vector2(0,120), "map scale:"+ascale+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		}

	}

	float fdistance(const float a, const float b){//get the distance between to 1 dimensinal floats
		return abs(b - a);
	}
	float expand(const float sa,const float ma,const float fd){//screen aspect, map aspect, float distance
		return abs((((sa/ma)*fd)-fd)/2);//this get the amount that we need to expand the bounding box divided by to to be applied to each point equally
	}
	
}
