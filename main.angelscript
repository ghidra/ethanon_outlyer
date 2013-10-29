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
give logic to collect miner
starting on enemy pawn. basic ai

give character a read out to show how many resources we have.
as well as how many miners we have deployed (that can be a slider)
look into a smaller font potentially.

then build base on planet

then comes the attack part
weapon type classes
	missles that cost resources, and cause more damage
	phasers that cost no resources, but cause little damage
*/
