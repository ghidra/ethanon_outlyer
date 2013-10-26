#include "Button.angelscript"

class MainMenuScene : Scene
{
	private Button@ m_startGameButton;

	MainMenuScene()
	{
		const string sceneName = "empty";
		super(sceneName);
	}

	void onCreated()
	{
		const vector2 screenMiddle(GetScreenSize() * 0.5f);

		@m_startGameButton = Button("start", screenMiddle);

		//AddEntity("background.ent", vector3(screenMiddle, 0.0f));

	}

	void onUpdate()
	{
		//m_startGameButton.putButton();
		m_startGameButton.update();

		if (m_startGameButton.is_pressed())
		{
			g_sceneManager.setCurrentScene(GameScene());
		}
	}
}
