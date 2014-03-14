﻿#include "Button.angelscript"
#include "Character.angelscript"
#include "body.angelscript"
#include "enemy.angelscript"
#include "enemy_boss.angelscript"
#include "camera.angelscript"
#include "minimap.angelscript"
#include "global.angelscript"

#include "button_dialogue.angelscript"

class GameScene : Scene
{
	private global@ m_global;

	private camera@ m_camera;
	private minimap@ m_minimap;

	private Button@ m_exitButton;
	private Character@ m_character;

	//private actor@ m_light;
	//private ETHEntityArray m_bodies;
	private body@[] m_bodies;
	//private string[] m_names = { 'drb78','jrg711','ckg31','jqg525','x'};

	private enemy@[] m_enemies;//array to hold all the enemies
	private enemy_boss@ m_boss;

	//variables to hold boolesn for dialogue windows, so that we only open them once.
	private bool m_body_explanation = false;
	private bool m_enemy_explanation = false;
	private bool m_boss_explanation = false;

	private bool m_button_dialogue_open = false;
	private button_dialogue@ m_button_dialogue;//hold our dialouge object when we have one open
	
	private string temp;

	//ETHEntity@ light;

	GameScene()
	{
		const string sceneName = "empty";
		super(sceneName);
	}

	void onCreated()
	{
		Scene::onCreated();
		//SetPositionRoundUp(true);//this is supposed to do pixel style rendering, but needs images to be power of 2
		
		@m_global = global();
		@m_exitButton = Button("menu", vector2(0.0f, 0.0f), vector2(0.0f, 0.0f));

		const vector2 screenMiddle(GetScreenSize() * 0.5f);

		@m_minimap = minimap();
		m_global.set_minimap(m_minimap);

		//@m_character = Character("witch.ent", screenMiddle);
		@m_character = Character("hero.ent", vector2(0.0f,0.0f));
		m_character.set_global_object(m_global);
		//m_minimap.plottable(m_character);

		@m_camera = camera();
		//m_camera.set_global_object(m_global);
		m_camera.set_target(m_character);
		m_camera.set_position(m_character.get_position());
		m_minimap.plottable(m_camera);//give it the camera to plot

		//temp = "";
		//-----making random bodies
		for (uint t = 0; t < 23; t++)
    	{
			const float rx = (randF(1)-0.5)*1000;
			const float ry = (randF(1)-0.8)*5000;
			const vector2 put(rx,ry);
			const string nm = t+""+randF(t)*1000;

			m_bodies.insertLast( body("simple_light.ent",put,nm) );//http://www.angelcode.com/angelscript/sdk/docs/manual/doc_datatypes_arrays.html
			//m_bodies[t].set_label(nm);
			m_bodies[t].set_global_object(m_global);
			//m_minimap.plottable(m_bodies[t]);
		}

		//m_enemies.insertLast( enemy("random.ent", vector2(200.0f,200.0f),m_character) );
		//m_minimap.plottable(m_enemies[m_enemies.length()-1]);

		//place a boss
		@m_boss = enemy_boss("random.ent", vector2(0.0f,-500.0f),m_character);
		m_boss.set_global_object(m_global);
		//m_boss.m_factory.spawn( enemy("random.ent", vector2(200.0f,200.0f),m_targetpawn) );
		//m_minimap.plottable(m_boss);
	}

	void onUpdate()
	{	
		//m_exitButton.putButton();
		m_exitButton.update();
		if (m_exitButton.is_pressed())
		{
			g_sceneManager.setCurrentScene(MainMenuScene());
		}

		for (uint t=0; t<m_bodies.length(); t++){
   	 		m_bodies[t].update();
   	 		//first we need to determine if we have pressed a body for the first time
   	 		//if so we can make out dialough box explaining them to the player
   	 		if( m_bodies[t].is_pressed() && !m_body_explanation && !m_button_dialogue_open ){
   	 			@m_button_dialogue = button_dialogue('tell me about the bodies',m_global);
   	 			//m_button_dialogue.set_global_object(m_global);
   	 			m_button_dialogue_open=true;
   	 			m_body_explanation=true;
   	 		}
   	 		//if we have been given an action based on button press, we need to pass it to the character
   	 		if(m_bodies[t].get_action() != "none" && m_bodies[t].get_action() != "pressed header"){
   	 			//m_character.set_action( m_bodies[t].m_action );
   	 			m_character.set_action( m_bodies[t].m_action , m_bodies[t] );
   	 			//m_character.set_targetbody( m_bodies[t] );
   	 		}
   	 		//if I want them on the minimap, I have to give the positions at least and a color to the minimap object
   	 		//m_minimap.plottable(m_bodies[t].get_position());
		}

		/*for (uint t=0; t<m_enemies.length(); t++){
   	 		m_enemies[t].update();
   	 		//if we have been given an action based on button press, we need to pass it to the character
   	 		if(m_enemies[t].get_action() != "none"){
   	 			m_character.set_attack( m_enemies[t].m_action , m_enemies[t] );
   	 			//m_character.set_action( m_enemies[t].m_action , m_enemies[t] );
   	 			//m_character.set_action_weapon( m_enemies[t].m_action );
   	 			//m_character.set_targetenemy( m_enemies[t] );
   	 		}
   	 		//the above breaks it because I am using m_action locally on the enemy to tell it what to do.
   	 		//chances are that I need to rethink that logic, since bodies may also want a specific actino to do later
			//m_minimap.plottable(m_enemies[t].get_position());
		}*/

		m_boss.update();
		if(m_boss.get_action() != "none") m_character.set_attack( m_boss.m_action , m_boss );
		//now lets update the character
		m_character.update();
		m_camera.update();

		//m_minimap.plottable(m_character.get_position());

		m_minimap.update();
		//-----------------
		//-----------------

		//now if we have a dialogue window open, we can take care of it here:
		//-----------------
		if(m_button_dialogue_open){
			//if(m_button_dialogue.is_open()){
				m_button_dialogue.update();
			//}
			m_button_dialogue_open=m_button_dialogue.is_open();
		}

		/*ETHInput@ input = GetInputHandle();
		const uint RED = 0xFFFF0000;
		const uint WHITE = 0xFFFFFFFF;

		vector2 mp = input.GetCursorPos();*/
		//float db = this.debug(mp);
		//DrawText(vector2(0,200), "x"+mp.x+" y:"+mp.y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		//DrawText(vector2(0,212), "iter:"+temp, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		
		DrawText(vector2(0,224), "fps:"+GetFPSRate()+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText(vector2(0,244), "time:"+m_global.time_multiplier()+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));

		//DrawText(vector2(0,244), "bodies:"+m_bodies.length()+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		//DrawText(vector2(0,264), "enemies:"+m_enemies.length()+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		
		//DrawText(vector2(0,234), m_character.m_action+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		//DrawText(vector2(0,244), m_character.m_target.get_label()+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		//DrawText(vector2(0,212), "over:"+m_character.isPointInBB(input.GetCursorPos()), "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		//DrawText(vector2(0,224), "debug:"+db, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		/*vector2 cp = m_character.posr();
		vector2 cp2 = m_character.posr2();
		DrawText(vector2(0,212), "character position:"+cp.x+":"+cp.y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText(vector2(0,224), "character position:"+cp2.x+":"+cp2.y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
`		*/
		/*const uint touchCount = input.GetMaxTouchCount();
		for (uint t = 0; t < touchCount; t++)
		{
			if (input.GetTouchState(t) == KS_HIT)
			{
				if(m_character.isPointInBB(input.GetTouchPos(t)))
				//if (isPointInButton(input.GetTouchPos(t)))
				{
					DrawShapedSprite("sprites/pixel_white.png", vector2(100,200), vector2(100,20), RED);
				}else{
					DrawShapedSprite("sprites/pixel_white.png", vector2(100,200), vector2(100,20), WHITE);
				}
			}
		}*/

		/*if( m_character.is_point_in_bb(input.GetCursorPos()) ){
			DrawShapedSprite("sprites/pixel_white.png", vector2(100,200), vector2(20,20), RED);
		}else{
			DrawShapedSprite("sprites/pixel_white.png", vector2(100,200), vector2(20,20), WHITE);
		}*/

		//for (int t = 0; t < m_bodies.length(); t++){
		//	if()m_bodies[t].m_mousedown
		//}

		/*const uint touchCount = input.GetMaxTouchCount();
		for (uint t = 0; t < touchCount; t++){
			if (input.GetTouchState(t) == KS_UP){

			}
		}*/

		//}

    	// adjusts the original bitmap to a 100x20 pixels area
   	 	//DrawShapedSprite("sprites/pixel_white.png", vector2(100,200), vector2(100,20), WHITE);
   	 	
   	 	//-----------------
   	 	//-----------------
   	 	
	}

	float debug(const vector2 &in p) const
	{
		return p.x;
	}
}
