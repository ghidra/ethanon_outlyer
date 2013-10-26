#include "SceneManager.angelscript"
#include "MainMenuScene.angelscript"
#include "GameScene.angelscript"
//#include "TestScene.angelscript"

void main()
{
	g_sceneManager.setCurrentScene(MainMenuScene());
}
/*
------------
notes
------------
-left off at
------------
miner deposited
i have almost got it to orbit the planet.
after that I would like to start sucking resources

give character a read out to show how many resources we have.
as well as how many miners we have deployed (that can be a slider)
look into a smaller font potentially.

then build base on planet

then comes the attack part
*/
