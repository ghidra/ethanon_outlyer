#include "actor.angelscript"
#include "body.angelscript"
#include "enemy.angelscript"
#include "pawn.angelscript"

class projectile : actor
{
	private float m_maxrange = 10.0f;//this is so that it dies at some point regarless of landing
	private bool m_exploding = false;//flag for weather this is has hit, or reached its max distance or sexploding or not
	private bool m_hit = false; //weather this hit a target set from the weapon

	private bool m_explosion_done = false;
	private uint m_explosion_frames = 15;

	private body@ m_target_body;//variables to hold the target of the actions
	private enemy@ m_target_enemy;
	private pawn@ m_target_pawn;
	private actor@ m_target_actor;

	private string m_target_type;

	//private ETHEntity@ m_explosion;//this will hold the explosion graphic

	projectile(const string &in entityName, const vector2 &in pos, const vector2 &in destination){
		super(entityName,pos);
		m_spd = 1.0f;
		set_scale(0.25f);
		set_z(1.0f);
		set_destination(destination);
	}

	void update(){
		actor::update();
		//DrawText( get_screen_position() , m_destination.x+":"+m_destination.y, m_font, m_red);

		if(!m_hit){//if we havent hit anything yet
			move(m_destination_direction);//move

			//now check again, so next time around we can do what we need to
			//collision testing against the target that was assigned
			vector2 tpos = vector2(0.0f,0.0f);
			float tsize = 0.0f;
			bool tdied = false; 
			if(m_target_type=="actor"){
				tpos = vector2(m_target_actor.get_position());
				tsize = length(m_target_actor.get_size())/3;
				tdied = m_target_actor.has_died();
			}
			if(m_target_type=="pawn"){
				tpos = vector2(m_target_pawn.get_position());
				tsize = length(m_target_pawn.get_size())/3;
				tdied = m_target_pawn.has_died();
			}
			if(m_target_type=="body"){
				tpos = vector2(m_target_body.get_position());
				tsize = length(m_target_body.get_size())/3;
				tdied = m_target_body.has_died();
			}
			if(m_target_type=="enemy"){
				tpos = vector2(m_target_enemy.get_position());
				tsize = length(m_target_enemy.get_size())/3;
				tdied = m_target_enemy.has_died();
			}

			if(!tdied){
				const float d = length( tpos - m_pos ); 
				if( d < tsize*m_gscale ){//deterime hit
					set_hit();//we have hit
				}
			}
			//if found, we set this to hit
			//

			//	vector2 tpos = target.get_position();
			//	float tsize = length(target.get_size())/3;
		}else{//if we have hit something
			if(!m_exploding){//then we need to check if we have initialized the exploding
				//remove projectile graphic, set explode graphic
				delete_entity();
				init_entity("explosion_01.ent",m_pos);
				set_z(1.0f);
				//m_entity.Scale(4.0f);
				m_exploding = true;
				//remove hit points from the target
				if(m_target_type=="actor"){
					m_target_actor.take_damage(1.0f);
				}
				if(m_target_type=="pawn"){
					m_target_pawn.take_damage(1.0f);
				}
				if(m_target_type=="body"){
					m_target_body.take_damage(1.0f);
				}
				if(m_target_type=="enemy"){
					m_target_enemy.take_damage(1.0f);
				}
			}else{//we did start the explosion, update the frames, until we reach the end, then remove it, and allow weapon class to remove us from its array
				m_frametimer.update(0, m_explosion_frames, 36);
				const uint frame = m_frametimer.getCurrentFrame(); 
				m_entity.SetFrame(frame);
				if(frame>=m_explosion_frames){
					m_explosion_done = true;
				}
			}
		}
	}
	//------
	void set_target(actor@ target){
		@m_target_actor = target; 
		m_target_type = "actor";
	}
	void set_target(pawn@ target){
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
	}
	//-----
	void set_hit(){//this is one way, if it hit something it hit something
		m_hit = true;
	}
	bool get_hit(){
		return m_hit;
	}
	bool get_explosion_done(){
		return m_explosion_done;
	}
	//bool get_exploding(){
	//	return m_exploding;
	//}
}
