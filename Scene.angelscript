class Scene
{
	private uint m_white = ARGB(255,255,255,255);
	private uint m_grey = ARGB(180,180,180,180);
	private uint m_red = ARGB(255,255,0,0);
	
	Scene(const string &in sceneFileName)
	{
		LoadScene(sceneFileName, "onSceneCreated", "onSceneUpdate");
	}

	void onCreated()
	{
		SetPositionRoundUp(true);
	}

	void onUpdate()
	{
	}
}
