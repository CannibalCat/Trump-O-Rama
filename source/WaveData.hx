package ;

enum MapStyle
{
	DAY;
	DUSK;
	OVERCAST;
	SUNSET;
}

class WaveData
{
	public var mapStyle:MapStyle;
	public var spawnFrequency:Float;
	public var Bankers:Int;
	public var Bimbos:Int;
	public var Laborers:Int;
	public var maxBanditos:Int;
	public var currentBanditos:Int;
	public var maxIMFGoons:Int;
	public var currentIMFGoons:Int;
	public var maxClerics:Int;
	public var currentClerics:Int;
	public var maxNiqabis:Int;
	public var currentNiqabis:Int;
	public var maxPanthers:Int;
	public var currentPanthers:Int;
	public var maxSuperPanthers:Int;
	public var currentSuperPanthers:Int;
	
	public function new(waveNumber:Int) 
	{
		loadData(waveNumber);
	}
	
	private function loadData(waveNumber:Int):Void
	{
		switch waveNumber
		{
			case 1:
				mapStyle = MapStyle.DAY;
				spawnFrequency = 4;
				Bankers = 8;
				Bimbos = 0;
				Laborers = 8;
				maxBanditos = 0;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 0;
				currentNiqabis = 0;
				maxPanthers = 4;
				currentPanthers = 0;
				maxSuperPanthers = 4;
				currentSuperPanthers = 0;				
				
			case 2:
				mapStyle = MapStyle.DAY;
				spawnFrequency = 4;
				Bankers = 8;
				Bimbos = 0;
				Laborers = 8;
				maxBanditos = 2;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 2;
				currentNiqabis = 0;
				maxPanthers = 2;
				currentPanthers = 0;
				maxSuperPanthers = 4;
				currentSuperPanthers = 0;
				
			case 3:
				mapStyle = MapStyle.DAY;
				spawnFrequency = 4;
				Bankers = 8;
				Bimbos = 0;
				Laborers = 8;
				maxBanditos = 4;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 2;
				currentNiqabis = 0;
				maxPanthers = 2;
				currentPanthers = 0;
				maxSuperPanthers = 4;
				currentSuperPanthers = 0;
				
			case 4:
				mapStyle = MapStyle.DAY;
				spawnFrequency = 4;
				Bankers = 0;
				Bimbos = 24;
				Laborers = 0;
				maxBanditos = 0;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 18;
				currentClerics = 0;
				maxNiqabis = 0;
				currentNiqabis = 0;
				maxPanthers = 0;
				currentPanthers = 0;
				maxSuperPanthers = 0;
				currentSuperPanthers = 0;
				
			case 5:
				mapStyle = MapStyle.DUSK;
				spawnFrequency = 3;
				Bankers = 10;
				Bimbos = 0;
				Laborers = 8;
				maxBanditos = 4;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 2;
				currentNiqabis = 0;
				maxPanthers = 4;
				currentPanthers = 0;
				maxSuperPanthers = 6;
				currentSuperPanthers = 0;
				
			case 6:
				mapStyle = MapStyle.DUSK;
				spawnFrequency = 3;
				Bankers = 10;
				Bimbos = 0;
				Laborers = 10;
				maxBanditos = 4;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 4;
				currentNiqabis = 0;
				maxPanthers = 4;
				currentPanthers = 0;
				maxSuperPanthers = 6;
				currentSuperPanthers = 0;
				
			case 7:
				mapStyle = MapStyle.DUSK;
				spawnFrequency = 3;
				Bankers = 8;
				Bimbos = 0;
				Laborers = 8;
				maxBanditos = 4;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 4;
				currentNiqabis = 0;
				maxPanthers = 4;
				currentPanthers = 0;
				maxSuperPanthers = 6;
				currentSuperPanthers = 0;
				
			case 8:
				mapStyle = MapStyle.DUSK;
				spawnFrequency = 3;
				Bankers = 0;
				Bimbos = 24;
				Laborers = 0;
				maxBanditos = 0;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 20;
				currentClerics = 0;
				maxNiqabis = 0;
				currentNiqabis = 0;
				maxPanthers = 0;
				currentPanthers = 0;
				maxSuperPanthers = 0;
				currentSuperPanthers = 0;
				
			case 9:
				mapStyle = MapStyle.OVERCAST;
				spawnFrequency = 2;
				Bankers = 10;
				Bimbos = 0;
				Laborers = 10;
				maxBanditos = 2;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 4;
				currentNiqabis = 0;
				maxPanthers = 6;
				currentPanthers = 0;
				maxSuperPanthers = 8;
				currentSuperPanthers = 0;
				
			case 10:
				mapStyle = MapStyle.OVERCAST;
				spawnFrequency = 2;
				Bankers = 12;
				Bimbos = 0;
				Laborers = 8;
				maxBanditos = 4;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 6;
				currentNiqabis = 0;
				maxPanthers = 6;
				currentPanthers = 0;
				maxSuperPanthers = 8;
				currentSuperPanthers = 0;
				
			case 11:
				mapStyle = MapStyle.OVERCAST;
				spawnFrequency = 2;
				Bankers = 10;
				Bimbos = 0;
				Laborers = 10;
				maxBanditos = 4;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 6;
				currentNiqabis = 0;
				maxPanthers = 6;
				currentPanthers = 0;
				maxSuperPanthers = 8;
				currentSuperPanthers = 0;
				
			case 12:
				mapStyle = MapStyle.OVERCAST;
				spawnFrequency = 2;
				Bankers = 0;
				Bimbos = 26;
				Laborers = 0;
				maxBanditos = 0;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 24;
				currentClerics = 0;
				maxNiqabis = 0;
				currentNiqabis = 0;
				maxPanthers = 0;
				currentPanthers = 0;
				maxSuperPanthers = 0;
				currentSuperPanthers = 0;
				
			case 13:
				mapStyle = MapStyle.DAY;
				spawnFrequency = 2;
				Bankers = 8;
				Bimbos = 0;
				Laborers = 8;
				maxBanditos = 4;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 6;
				currentNiqabis = 0;
				maxPanthers = 8;
				currentPanthers = 0;
				maxSuperPanthers = 10;
				currentSuperPanthers = 0;
				
			case 14:
				mapStyle = MapStyle.DAY;
				spawnFrequency = 2;
				Bankers = 10;
				Bimbos = 0;
				Laborers = 10;
				maxBanditos = 2;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 8;
				currentNiqabis = 0;
				maxPanthers = 8;
				currentPanthers = 0;
				maxSuperPanthers = 10;
				currentSuperPanthers = 0;
				
			case 15:
				mapStyle = MapStyle.DAY;
				spawnFrequency = 2;
				Bankers = 8;
				Bimbos = 0;
				Laborers = 8;
				maxBanditos = 4;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 8;
				currentNiqabis = 0;
				maxPanthers = 8;
				currentPanthers = 0;
				maxSuperPanthers = 10;
				currentSuperPanthers = 0;
				
			case 16:
				mapStyle = MapStyle.DAY;
				spawnFrequency = 2;
				Bankers = 0;
				Bimbos = 28;
				Laborers = 0;
				maxBanditos = 0;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 26;
				currentClerics = 0;
				maxNiqabis = 0;
				currentNiqabis = 0;
				maxPanthers = 0;
				currentPanthers = 0;
				maxSuperPanthers = 0;
				currentSuperPanthers = 0;
				
			case 17:
				mapStyle = MapStyle.DUSK;
				spawnFrequency = 1;
				Bankers = 8;
				Bimbos = 0;
				Laborers = 10;
				maxBanditos = 4;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 8;
				currentNiqabis = 0;
				maxPanthers = 10;
				currentPanthers = 0;
				maxSuperPanthers = 12;
				currentSuperPanthers = 0;
				
			case 18:
				mapStyle = MapStyle.DUSK;
				spawnFrequency = 1;
				Bankers = 10;
				Bimbos = 0;
				Laborers = 10;
				maxBanditos = 4;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 8;
				currentNiqabis = 0;
				maxPanthers = 10;
				currentPanthers = 0;
				maxSuperPanthers = 12;
				currentSuperPanthers = 0;			
				
			case 19:
				mapStyle = MapStyle.DUSK;
				spawnFrequency = 2;
				Bankers = 12;
				Bimbos = 0;
				Laborers = 10;
				maxBanditos = 4;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 8;
				currentNiqabis = 0;
				maxPanthers = 10;
				currentPanthers = 0;
				maxSuperPanthers = 12;
				currentSuperPanthers = 0;
				
			case 20:
				mapStyle = MapStyle.DUSK;
				spawnFrequency = 1;
				Bankers = 0;
				Bimbos = 30;
				Laborers = 0;
				maxBanditos = 0;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 28;
				currentClerics = 0;
				maxNiqabis = 0;
				currentNiqabis = 0;
				maxPanthers = 0;
				currentPanthers = 0;
				maxSuperPanthers = 0;
				currentSuperPanthers = 0;
				
			case 21:
				mapStyle = MapStyle.OVERCAST;
				spawnFrequency = 1;
				Bankers = 12;
				Bimbos = 0;
				Laborers = 12;
				maxBanditos = 4;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 8;
				currentNiqabis = 0;
				maxPanthers = 10;
				currentPanthers = 0;
				maxSuperPanthers = 12;
				currentSuperPanthers = 0;
				
			case 22:
				mapStyle = MapStyle.OVERCAST;
				spawnFrequency = 1;
				Bankers = 12;
				Bimbos = 0;
				Laborers = 12;
				maxBanditos = 4;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 8;
				currentNiqabis = 0;
				maxPanthers = 12;
				currentPanthers = 0;
				maxSuperPanthers = 14;
				currentSuperPanthers = 0;
				
			case 23:
				mapStyle = MapStyle.OVERCAST;
				spawnFrequency = 1;
				Bankers = 12;
				Bimbos = 0;
				Laborers = 12;
				maxBanditos = 4;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 8;
				currentNiqabis = 0;
				maxPanthers = 12;
				currentPanthers = 0;
				maxSuperPanthers = 14;
				currentSuperPanthers = 0;
				
			case 24:
				mapStyle = MapStyle.OVERCAST;
				spawnFrequency = 1;
				Bankers = 0;
				Bimbos = 30;
				Laborers = 0;
				maxBanditos = 0;
				currentBanditos = 0;
				maxIMFGoons = 0;
				currentIMFGoons = 0;
				maxClerics = 30;
				currentClerics = 0;
				maxNiqabis = 0;
				currentNiqabis = 0;
				maxPanthers = 0;
				currentPanthers = 0;
				maxSuperPanthers = 0;
				currentSuperPanthers = 0;
				
			case 25:
				mapStyle = MapStyle.SUNSET;
				spawnFrequency = 1;
				Bankers = 0;
				Bimbos = 25;
				Laborers = 0;
				maxBanditos = 0;
				currentBanditos = 0;
				maxIMFGoons = 16;
				currentIMFGoons = 0;
				maxClerics = 0;
				currentClerics = 0;
				maxNiqabis = 8;
				currentNiqabis = 0;
				maxPanthers = 0;
				currentPanthers = 0;
				maxSuperPanthers = 0;
				currentSuperPanthers = 0;
		}
	}
}