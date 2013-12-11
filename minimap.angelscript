#include "obj.angelscript"
#include "actor.angelscript"
#include "camera.angelscript"

class minimap : obj
{
	//this class will be a minimap in the corner of he screen. It will allow us to move the camera around indipendant of the character
	//as well as giving us an option to zoom in and out 

	private float m_format = 100.0f;//this is the height of the map at the corner
	private float m_aspect;
	private vector2 m_ss;//screen size, to draw the camera area on the map

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

	private actor@[] m_plottable_actors;
	private camera@ m_plottable_camera;

	minimap(){
		set_format(m_format);
		clear_plottable();
	}

	void set_format(const float f){
		m_ss = GetScreenSize();
		m_format = f;
		m_aspect = m_ss.x/m_ss.y;
		m_size = vector2(f*m_aspect,f);

		m_tl = vector2( m_ss.x-(m_size.x+m_extmargin), m_ss.y-(m_size.y+m_extmargin) );
		m_br = vector2( m_ss.x-m_extmargin, m_ss.y-m_extmargin );

		m_tr = vector2(m_br.x,m_tl.y);
		m_bl = vector2(m_tl.x,m_br.y);

	}

	void plottable(const vector2 p){//positions and color
		
		m_plottable_positions.insertLast(p);
		//m_plottable_colors.inserLast(c);

	}
	void plottable(actor@ a){//positions and color
		
		m_plottable_actors.insertLast(a);

	}
	void plottable(camera@ c){//positions and color
		
		@m_plottable_camera = c;

	}
	void clear_plottable(){
		for(uint t = 0; t < m_plottable_positions.length(); t++){
			m_plottable_positions.removeLast();
		}
	}

	void update(){
		//here is where we draw the maps data, starting with the edges
		draw_line( m_tl, m_tr, m_white, m_white, 1.0f );//top
		draw_line( m_tr, m_br, m_white, m_white, 1.0f );//right
		draw_line( m_bl, m_br, m_white, m_white, 1.0f );//bottom
		draw_line( m_tl, m_bl, m_white, m_white, 1.0f );//left

		m_center = vector2( m_tl.x+(fdistance(m_tl.x,m_tr.x)/2), m_tl.y+(fdistance(m_tl.y,m_bl.y)/2) );

		if(m_type==0){//loop objects so I can determine map size, this is adaptive style
			
			//bounding box info
			vector2 atl;
			vector2 abr;
			vector2 adime;
			vector2 acenter;
			float aaspect;
			float aexpand;//the value that we will need to expand by
			
			//camera info
			//vector2 acampos;
			vector2 acamtl;
			vector2 acambr;
			vector2 acambl;
			vector2 acamtr;

			//translation info
			float ascale;
			vector2 azerotrans;//the vector to move eerything to 0,0 from center
			vector2 amaptrans;//the vector to get it back in the map space

			const float mult =1.0f/GetScale();//offest by global scale

			for(uint t = 0; t < m_plottable_actors.length(); t++){//get the bounding box around the main plottable objects
				const vector2 scalled_pos = vector2(m_plottable_actors[t].get_position()* mult) ;
				if(t==0){
					atl = vector2(scalled_pos);
					abr = vector2(scalled_pos);
				}else{
					if(scalled_pos.x<atl.x){
						atl.x=scalled_pos.x;
					}
					if(scalled_pos.y<atl.y){
						atl.y=scalled_pos.y;
					}
					if(scalled_pos.x>abr.x){
						abr.x=scalled_pos.x;
					}
					if(scalled_pos.y>abr.y){
						abr.y=scalled_pos.y;
					}
				}

			}
			//now we know the bounding points add in some margins
			atl-=vector2(m_intmargin,m_intmargin);
			abr+=vector2(m_intmargin,m_intmargin);

			//now we need to get the aspect of bounding points, so that we can expand the bounding poitns to
			//match the aspect of the screen
			adime = vector2(abs(abr.x-atl.x),abs(abr.y-atl.y));
			aaspect = adime.x/adime.y;
			
			if(m_aspect>aaspect){//we need to expant the left and right edges
				aexpand = expand(m_aspect,aaspect, fdistance(abr.x,atl.x) );//abs((((m_aspect/aaspect)*ad)-ad)/2);
				atl.x-=aexpand;
				abr.x+=aexpand;
			}else{
				aexpand = expand(m_aspect,aaspect, fdistance(abr.y,atl.y) ); //abs((((m_aspect/aaspect)*ad)-ad)/2);
				atl.y-=aexpand;
				abr.y+=aexpand;
			}
			
			//now that they bounding points have been expanded, we need to look at 
			//getting the center point of the boundin points
			adime = vector2(abs(abr.x-atl.x),abs(abr.y-atl.y));
			aaspect = adime.x/adime.y;	
			acenter = vector2( atl.x+(fdistance(atl.x,abr.x)/2), atl.y+(fdistance(atl.y,abr.y)/2) );

			//figure out how much to scale the plot points
			ascale = m_format/adime.y;//this is how much to scale it to fit into the minimap
			//get the direction of the center of the object to 0,0
			azerotrans = vector2()-acenter;
			amaptrans = m_center-vector2();
			
			//now move all the points by this vector
			for(uint t = 0; t < m_plottable_actors.length(); t++){
				vector2 scalled_pos = vector2(m_plottable_actors[t].get_position()*mult);
				scalled_pos += azerotrans;//translate them toward center
				scalled_pos *= ascale;//scale them fuckers
				scalled_pos += amaptrans;//move it to map space

				DrawShapedSprite("sprites/pixel_white.png", scalled_pos-vector2(1,1), vector2(2, 2), m_white,0.0);
			}

			//now I want to draw the camera data
			acamtl =vector2( m_plottable_camera.get_position()*mult );
			acambr =vector2( acamtl.x+(m_ss.x*mult), acamtl.y+(m_ss.y*mult) ); 
			
			acamtl+=azerotrans;
			acamtl*=ascale;
			acamtl+=amaptrans;

			acambr+=azerotrans;
			acambr*=ascale;
			acambr+=amaptrans;

			if(acamtl.x < m_tl.x) acamtl.x = m_tl.x;
			if(acamtl.y < m_tl.y) acamtl.y = m_tl.y;
			if(acambr.x > m_br.x) acambr.x = m_br.x;
			if(acambr.y > m_br.y) acambr.y = m_br.y;

			acamtr = vector2(acambr.x,acamtl.y);
			acambl = vector2(acamtl.x,acambr.y);

			draw_line( acamtl, acamtr, m_white, m_white, 1.0f );//top
			draw_line( acamtr, acambr, m_white, m_white, 1.0f );//right
			draw_line( acambl, acambr, m_white, m_white, 1.0f );//bottom
			draw_line( acamtl, acambl, m_white, m_white, 1.0f );//left

			//DrawShapedSprite("sprites/pixel_white.png", acamtl-vector2(4,4), vector2(8, 8), m_red,0.0);
			//DrawShapedSprite("sprites/pixel_white.png", acambr+vector2(4,4), vector2(8, 8), m_red,0.0);

			//const vector2 temp = vector2( m_plottable_camera.get_position() );

			//DrawShapedSprite("sprites/pixel_white.png", m_center, vector2(6, 6), m_red,0.0);
			//now I need to force it into my screen ratio, so that I can scale all the positins down to fit where I need them to fit in the map
			
			//DrawText(vector2(0,80), "camera x:"+temp.x+"/y:"+temp.y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			//DrawText(vector2(0,100), "abr x:"+abr.x+"/y:"+abr.y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			//DrawText(vector2(0,120), "mult:"+mult+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			//DrawText(vector2(0,140), "plotaspect:"+aaspect+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			//DrawText(vector2(0,160), "sreen aspect:"+m_aspect+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
			//DrawText(vector2(0,180), "actors:"+temp+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		}

	}

	float fdistance(const float a, const float b){//get the distance between to 1 dimensinal floats
		return abs(b - a);
	}
	float expand(const float sa,const float ma,const float fd){//screen aspect, map aspect, float distance
		return abs((((sa/ma)*fd)-fd)/2);//this get the amount that we need to expand the bounding box divided by to to be applied to each point equally
	}
	
}
