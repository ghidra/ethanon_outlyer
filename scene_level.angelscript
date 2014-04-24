#include "Button.angelscript"
#include "Character.angelscript"
#include "body.angelscript"
#include "enemy.angelscript"
#include "enemy_boss.angelscript"
#include "camera.angelscript"
#include "minimap.angelscript"
#include "global.angelscript"

#include "button_dialogue.angelscript"

#include "grid_map.angelscript"

class scene_level : Scene
{
	private global@ m_global;

	private camera@ m_camera;
	private minimap@ m_minimap;

	private Button@ m_exitButton;
	private Character@ m_character;

	private body@[] m_bodies;

	private enemy@[] m_enemies;//array to hold all the enemies
	private enemy_boss@ m_boss;

	private bool m_body_explanation = false;
	private bool m_enemy_explanation = false;
	private bool m_boss_explanation = false;

	private bool m_button_dialogue_open = false;
	private button_dialogue@ m_button_dialogue;//hold our dialouge object when we have one open

	private grid_map@ m_grid;

	scene_level()
	{
		const string sceneName = "empty";
		super(sceneName);
	}

	void onCreated()
	{
		Scene::onCreated();
		
		@m_global = global();
		@m_exitButton = Button("menu", vector2(0.0f, 0.0f), vector2(0.0f, 0.0f));

		const vector2 screenMiddle(GetScreenSize() * 0.5f);

		@m_minimap = minimap();
		m_global.set_minimap(m_minimap);

		@m_character = Character("hero.ent", vector2(0.0f,0.0f));
		m_character.set_global_object(m_global);

		@m_camera = camera();
		m_camera.set_target(m_character);
		m_camera.set_position(m_character.get_position());
		m_minimap.plottable(m_camera);//give it the camera to plot

		for (uint t = 0; t < 23; t++)
    	{
			const float rx = (randF(1)-0.5)*1000;
			const float ry = (randF(1)-0.8)*5000;
			const vector2 put(rx,ry);
			const string nm = t+""+randF(t)*1000;

			m_bodies.insertLast( body("simple_light.ent",put,nm) );//http://www.angelcode.com/angelscript/sdk/docs/manual/doc_datatypes_arrays.html
			m_bodies[t].set_global_object(m_global);
		}

		@m_boss = enemy_boss("boss_0101.ent", vector2(0.0f,-500.0f),m_character);
		m_boss.set_global_object(m_global);

		@m_grid = grid_map();
		//m_grid.set_global_object(m_global);
		SetScaleFactor(0.5);
	}

	void onUpdate()
	{	
		m_grid.update();

		m_exitButton.update();
		if (m_exitButton.is_pressed())
		{
			g_sceneManager.setCurrentScene(MainMenuScene());
		}

		for (uint t=0; t<m_bodies.length(); t++){
   	 		m_bodies[t].update();
   	 		if( m_bodies[t].is_pressed() && !m_body_explanation && !m_button_dialogue_open ){
   	 			@m_button_dialogue = button_dialogue('tell me about the bodies',m_global);
   	 			m_button_dialogue_open=true;
   	 			m_body_explanation=true;
   	 		}
   	 		if(m_bodies[t].is_pressed()){//if this has been pressed, lets pass it the character so it can calculate some values
   	 			m_bodies[t].set_target(m_character);
   	 		}
   	 		if(m_bodies[t].get_action() != "none" && m_bodies[t].get_action() != "pressed header"){
   	 			m_character.set_action( m_bodies[t].m_action , m_bodies[t] );
   	 		}
		}

		m_boss.update();
		if(m_boss.get_action() != "none") m_character.set_attack( m_boss.m_action , m_boss );
		//now lets update the character
		m_character.update();
		m_camera.update();

		//m_minimap.plottable(m_character.get_position());

		m_minimap.update();
		//-----------------
		if(m_button_dialogue_open){
				m_button_dialogue.update();
			m_button_dialogue_open=m_button_dialogue.is_open();
		}
		
		DrawText(vector2(0,224), "fps:"+GetFPSRate()+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText(vector2(0,244), "time:"+m_global.time_multiplier()+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));

	}

	float debug(const vector2 &in p) const
	{
		return p.x;
	}
}
