#include "pawn.angelscript"
#include "miner.angelscript"
#include "enemy.angelscript"
#include "body.angelscript"

class Character : pawn
{

	private miner@[] m_miners;//my array of miners
	private uint m_minerscount=0;//this counte the miners, so that I can give them a unique id, so when i go to delete them, i delete the right one
	private uint m_minersmax = 3;//at first you can only have 3 miners, maybe later you can have some more

	//body@ m_targetbody;//the body that we are targeting
	enemy@ m_targetenemy;//the body that we are targeting

	private vector2 m_guipos;
	private vector2 m_guibarsize = vector2(20.0f,20.0f);//size of the bar
	private vector2 m_guibardir = vector2(-0.5f,-0.5f);//size of the bar
	private float m_guimargin = 20.0f;


	private progressbar@ m_mbar;//miners bar

	private bool m_moving = false;//set when I am manually setting a destination with a mouse drag out

	Character(const string &in entityName, const vector2 pos){
		super(entityName,pos);
		
		m_spd = 1.0f;

		m_hp = 100.0f;

		m_rp = 10.0f;
		m_rpmax = 50.0f;

		m_guipos = vector2(GetScreenSize() * vector2(0.1f,0.8f) );

		//@m_rbar = progressbar("resources",m_rp,0.0f,m_rpmax,m_guipos);
		@m_rbar = progressbar("resources",m_rp,0.0f,m_rpmax,m_guipos,vector2(),m_guibarsize,m_guibardir,1);
		//@m_mbar = progressbar("miners",m_minerscount,0.0f,m_minersmax,m_guipos+vector2(0.0f,26.0f));
		@m_mbar = progressbar("miners",m_minerscount,0.0f,m_minersmax,m_guipos+vector2(0.0f,26.0f),vector2(),m_guibarsize,m_guibardir,1);
		m_hbar.set_position(m_guipos+vector2(0.0f,52.0f));

		//weapons
		//init_inventory();
		m_inventory.add_weapon( weapon("random.ent", get_position()) );//now we have a weapon in the inventory
		@m_weapon = m_inventory.get_weapon(0);//go ahead and equip the weapon just created
	}

	void update(){

		pawn::update();

		vector2 direction(0, 0);
		float dist = 0.0f;

		if(m_controller.has_actions()){//if our controller has actions to give us
			
			const string action = m_controller.get_action();//this gets the action we need to try and perform

			if(action == "harvest" || action == "collect miner"){
				
				body@ target = m_controller.get_target_body();//since i only harvest bodies, I have to assume that I am trying to get a body object
				set_destination(target.get_position());

				if( m_destination_distance > length(target.get_size())*m_gscale ){
					//m_moving=true;
					move(m_destination_direction);
				}else{
					if(action == "harvest"){
						deposit_miner(target);
					}
					if(action == "collect miner"){
						collect_miner(target);
					}
					//now remove the action from the list
					m_controller.remove_action();
					m_moving=false;
				}
			}
		
		}else{//if we have no actions we are allowed to get directions
		//Determine if we are trying to drag out a direction for travel
		////////////
		//m_pressed = false;
		//const uint touchCount = m_input.GetMaxTouchCount();
		//for (uint t = 0; t < touchCount; t++)
		//{
			/*if (m_input.GetTouchState(t) == KS_HIT)
			{
				//if (isPointInButton(input.GetTouchPos(t)))
				if (m_mouseover)
				{
					m_pressed = true;
				}
			}*/
			if (m_mouseover){
				if(m_input.GetLeftClickState()==KS_HIT && !m_pressed && !m_moving){
					m_pressed=true;
				}
			}
			if(m_input.GetLeftClickState()==KS_DOWN && m_pressed){
				draw_line(m_pos-m_camerapos,m_mousepos,m_white,m_white,1.0f);
				//m_scalefactor = (mousepos.x-m_scalestartpos)*m_scaledragmultiplier;//mp.x-m_scalestart;
				//m_scale = m_scaleprevious+m_scalefactor;
				//SetScaleFactor(m_scale);
			}
			if(m_input.GetLeftClickState()==KS_RELEASE && m_pressed){
				//set the destination
				set_destination(m_relativemousepos);
				m_moving=true;
				m_pressed=false;
			}

			//-------
			//now if we are flagged to m_moving, move it to the destination

			if( m_destination_distance >  m_spd*2 && m_moving){
				move(m_destination_direction);
			}else{
				m_moving=false;
			}

		//}
		}

		//need to update the weapons positions, so they dont hover in air and not move
		m_weapon.set_position(m_pos);

		/////////////
		//attack
		if(attack_ready()){
			enemy@ target = m_attcontroller.get_target_enemy();
			attack(target);
		}
		update_weapon();
		////////////


		DrawText(vector2(0,280), "destination distance:"+m_destination_distance+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		////////////

		for (uint t=0; t<m_miners.length(); t++){
			m_miners[t].update();
 
			this.set_rp( m_rp+m_miners[t].get_rp() );
		}

		m_rbar.set_value(m_rp);
		m_rbar.update();

		m_mbar.set_value(m_minerscount);
		m_mbar.update();

		m_hbar.set_value(m_hp);
		m_hbar.update();

		DrawText(vector2(0,300), "actions:"+m_controller.print_actions()+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText(vector2(0,310), "attactions:"+m_attcontroller.print_actions()+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));



		/*ETHInput@ input = GetInputHandleuint t=0; t<m_miners.length(); t++();
		vector2 direction(0, 0);
		//float speed = UnitsPerSecond(m_spd);

		// find current move direction based on keyboard keys
		if (input.KeyDown(K_DOWN))
		{
			m_directionLine = 0;
			direction += (vector2(0, 1)*m_spd_ups);
			//direction += vector2(0, 1);
		}
		if (input.KeyDown(K_LEFT))
		{
			m_directionLine = 1;
			direction += (vector2(-1, 0)*m_spd_ups);
			//direction += vector2(-1, 0);
		}
		if (input.KeyDown(K_RIGHT))
		{
			m_directionLine = 2;
			direction += (vector2(1, 0)*m_spd_ups);
			//direction += vector2(1, 0);
		}
		if (input.KeyDown(K_UP))
		{
			m_directionLine = 3;
			direction += (vector2(0,-1)*m_spd_ups);
			//direction += vector2(0,-1);
		}

		// if there's movement, update animation
		move(direction);
		*/
	}
	//this function overrides the default pawn one, cause I Need to specifically check enimy objects
	//void check_weapon_projectiles(){//loop through the projectiles and find out if they have hit our target
	//	m_weapon.check_projectiles_hit_target(m_targetenemy);
	//}
	void deposit_miner(body@ target){//put a minor on the target
		if(target !is null){
			if(m_rp>3.0f){
				vector2 target_pos = target.get_position();
				vector2 target_size = target.get_size()*0.75f;
				vector2 drop_dir = normalize(get_position()-target.get_position());
				vector2 drop_zone = target_pos+(drop_dir*(target_size*m_gscale));
				uint len = m_miners.length;
				if(len<m_minersmax){
					m_miners.insertLast( miner("random.ent", drop_zone, target, m_minerscount) );
					m_miners[len].set_scale(0.25f);
					set_rp(get_rp()-3.0f);
					target.add_miner(m_minerscount);
					m_minerscount+=1;
				}

			}else{
				//warn that you do not have enough funds
			}
		}
	}
	void collect_miner(body@ target){
		if(target !is null){
			uint remove_uid = target.subtract_miner();//m_miner+=1;
			uint remove_id;
			for(uint t=0; t<m_miners.length(); t++){
				uint candidate = m_miners[t].get_uid();
				if (candidate == remove_uid){
					remove_id = t;
				}
			}
			m_miners[remove_id].delete_entity();
			m_miners.removeAt(remove_id);
			set_rp(get_rp()+0.5f);//get a little resources back
			m_minerscount-=1;
		}
	}
	/*void set_targetbody(body@ target){
		@m_targetbody = target;
	}
	void set_targetenemy(enemy@ target){
		@m_targetenemy = target;
	}*/
}
