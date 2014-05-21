//https://github.com/caseman/noise/blob/master/perlin.py
class perlin_base{

	vector3[] _GRAD3 = {vector3(1,1,0),vector3(-1,1,0),vector3(1,-1,0),vector3(-1,-1,0),
		vector3(1,0,1),vector3(-1,0,1),vector3(1,0,-1),vector3(-1,0,-1),
		vector3(0,1,1),vector3(0,-1,1),vector3(0,1,-1),vector3(0,-1,-1),
		vector3(1,1,0),vector3(0,-1,1),vector3(-1,1,0),vector3(0,-1,-1)};

	int[] permutation = {151,160,137,91,90,15,
		131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
		190,6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
		88,237,149,56,87,174,20,125,136,171,168,68,175,74,165,71,134,139,48,27,166,
		77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
		102,143,54,65,25,63,161,1,216,80,73,209,76,132,187,208,89,18,169,200,196,
		135,130,116,188,159,86,164,100,109,198,173,186,3,64,52,217,226,250,124,123,
		5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
		223,183,170,213,119,248,152,2,44,154,163,70,221,153,101,155,167,43,172,9,
		129,22,39,253,9,98,108,110,79,113,224,232,178,185,112,104,218,246,97,228,
		251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
		49,192,214,31,181,199,106,157,184,84,204,176,115,121,50,45,127,4,150,254,
		138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180};

	uint period = permutation.length();
	//permutation = permutation * 2
	float _F2 = 0.5f * (sqrt(3.0f) - 1.0f);
	float _G2 = (3.0f - sqrt(3.0f)) / 6.0f;
	float _F3 = 1.0f / 3.0f;
	float _G3 = 1.0f / 6.0f;

	perlin_base(){}

	void init( const uint _period=0, const array<int> _permutation_table={} ){
		//if (_period > 0 && _permutation_table > 0){
			
		if (_period >0){
			randomize(_period);
		}else if(_permutation_table.length() > 0){
			permutation = _permutation_table;
			period = _permutation_table.length();
		}
		//}
	}

	void randomize(const uint p = 0){
		/*Randomize the permutation table used by the noise functions. This
		makes them generate a different noise pattern for the same inputs.
		*/
		if (p > 0)
			period = p;
		int[] perm = array<int>(period);
		int perm_right = period - 1;
		for (uint i=0; i< period;i++){
			uint j = rand(0, perm_right);
			perm[j]=perm[i];
			perm[i]=perm[j];
			//perm[i], perm[j] = perm[j], perm[i];
		}
		permutation = perm;
	}
}


class perlin: perlin_base{	

	perlin(){}

	float noise2(const float x, const float y){
		/*2D Perlin simplex noise.
		Return a floating point value from -1 to 1 for the given x, y coordinate.
		The same value is always returned for a given x, y pair unless the
		permutation table changes (see randomize above).
		*/
		//Skew input space to determine which simplex (triangle) we are in
		float s = (x + y) * _F2;
		int i = floor(x + s);
		int j = floor(y + s);
		float t = (i + j) * _G2;
		float x0 = x - (i - t); // "Unskewed" distances from cell origin
		float y0 = y - (j - t);

		float i1 = 0; 
		float j1 = 1; // Upper triangle, YX order: (0,0)->(0,1)->(1,1)
		if (x0 > y0){
			i1 = 1; 
			j1 = 0; // Lower triangle, XY order: (0,0)->(1,0)->(1,1)
		}

		float x1 = x0 - i1 + _G2; // Offsets for middle corner in (x,y) unskewed coords
		float y1 = y0 - j1 + _G2;
		float x2 = x0 + _G2 * 2.0f - 1.0f; // Offsets for last corner in (x,y) unskewed coords
		float y2 = y0 + _G2 * 2.0f - 1.0f;

		//# Determine hashed gradient indices of the three simplex corners
		int[] perm = permutation;
		int ii = int(i) % period;
		int jj = int(j) % period;
		int gi0 = perm[ii + perm[jj]] % 12;
		int gi1 = perm[ii + i1 + perm[jj + j1]] % 12;
		int gi2 = perm[ii + 1 + perm[jj + 1]] % 12;

		// Calculate the contribution from the three corners
		float tt = 0.5f - x0*x0 - y0*y0;
		float noise = 0.0f;
		vector3 g = _GRAD3[0];
		if (tt > 0){
			g = _GRAD3[gi0];
			noise = pow(tt,4) * (g.x * x0 + g.y * y0);
		}
		tt = 0.5 - x1*x1 - y1*y1;
		if (tt > 0){
			g = _GRAD3[gi1];
			noise += pow(tt,4) * (g.x * x1 + g.y * y1);
		}
		tt = 0.5 - x2*x2 - y2*y2;
		if (tt > 0){
			g = _GRAD3[gi2];
			noise += pow(tt,4) * (g.x * x2 + g.y * y2);
		}

		//float noise = 0.0f;
		return noise * 70.0f; // scale noise to [-1, 1]
	}

}