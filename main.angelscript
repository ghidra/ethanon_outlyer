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
starting on enemy pawn. basic ai

-i have weapons now, need to look at using different ones
-weapon projectile need to explode on impact and remove hit pints
-weapon projectile can help me debug my destination set function
-weapon projectile needs to exlode after max range reached

look into a smaller font potentially.
then build base on planet

weapon type classes
	missles that cost resources, and cause more damage
	phasers that cost no resources, but cause little damage
*/
