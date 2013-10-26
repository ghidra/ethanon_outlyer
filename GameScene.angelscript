#include "Button.angelscript"
#include "Character.angelscript"
#include "body.angelscript"

class GameScene : Scene
{
	private Button@ m_exitButton;
	private Character@ m_character;

	//private actor@ m_light;
	//private ETHEntityArray m_lights;
	private body@[] m_lights;
	private string[] m_names = { 'drb78','jrg711','ckg31','jqg525','x'};
	
	private string temp;

	//ETHEntity@ light;

	GameScene()
	{
		const string sceneName = "empty";
		super(sceneName);
	}

	void onCreated()
	{
		@m_exitButton = Button("menu", vector2(0.0f, 0.0f), vector2(0.0f, 0.0f));

		const vector2 screenMiddle(GetScreenSize() * 0.5f);
		//@m_character = Character("witch.ent", screenMiddle);
		@m_character = Character("random.ent", screenMiddle);

		//temp = "";
		//-----making random lights
		for (uint t = 0; t < 5; t++)
    	{
			const float rx=randF(1);
			const float ry=randF(1);
			const vector2 put(rx*(screenMiddle.x*2),ry*(screenMiddle.y*2));
			
			m_lights.insertLast( body("simple_light.ent",put) );//http://www.angelcode.com/angelscript/sdk/docs/manual/doc_datatypes_arrays.html
			m_lights[t].set_label(m_names[t]);
		}

	}

	void onUpdate()
	{
		
		for (uint t=0; t<m_lights.length(); t++){
   	 		m_lights[t].update();
   	 		//if we have been given an action based on button press, we need to pass it to the character
   	 		if(m_lights[t].m_action != "none"){
   	 			m_character.m_action = m_lights[t].m_action;
   	 			//m_character.set_target( m_lights[t] );
   	 			m_character.set_targetbody( m_lights[t] );
   	 			//m_character.set_atarget( m_lights[t] );
   	 		}
		}

		//m_exitButton.putButton();
		m_exitButton.update();
		if (m_exitButton.is_pressed())
		{
			g_sceneManager.setCurrentScene(MainMenuScene());
		}

		//now lets update the character
		m_character.update();

		//-----------------
		//-----------------

		ETHInput@ input = GetInputHandle();
		const uint RED = 0xFFFF0000;
		const uint WHITE = 0xFFFFFFFF;

		vector2 mp = input.GetCursorPos();
		//float db = this.debug(mp);
		DrawText(vector2(0,200), "x"+mp.x+" y:"+mp.y, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText(vector2(0,212), "iter:"+temp, "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText(vector2(0,224), GetFPSRate()+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
		DrawText(vector2(0,234), m_character.m_action+"", "Verdana14_shadow.fnt", ARGB(250,255,255,255));
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

		if( m_character.is_point_in_bb(input.GetCursorPos()) ){
			DrawShapedSprite("sprites/pixel_white.png", vector2(100,200), vector2(20,20), RED);
		}else{
			DrawShapedSprite("sprites/pixel_white.png", vector2(100,200), vector2(20,20), WHITE);
		}

		//for (int t = 0; t < m_lights.length(); t++){
		//	if()m_lights[t].m_mousedown
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
