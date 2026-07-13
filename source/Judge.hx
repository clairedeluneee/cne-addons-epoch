package source;

import source.Wife;

public class Judge {
    /**
        Gets the hit windows of a specific Judge.
        Returns Judge 4 by default.

        Boos / Bads are locked at 180ms at J4 and above.
    */
    public static function getWindows(judge:Int):Dynamic {
        switch(judge) {
            case 1:  return {marv: 33.75,  perf: 67.5,  great: 135,   good: 202,    bad: 270};
            case 2:  return {marv: 29.925, perf: 59.85, great: 119.7, good: 179.55, bad: 239.4};
            case 3:  return {marv: 26.1,   perf: 52.2,  great: 104.4, good: 156.6,  bad: 208.8};
            default: return {marv: 22.5,   perf: 45,    great: 90,    good: 135,    bad: 180};
            case 5:  return {marv: 18.9,   perf: 37.8,  great: 75.6,  good: 113.4,  bad: 180};
            case 6:  return {marv: 14.85,  perf: 29.7,  great: 59.4,  good: 89.1,   bad: 180};
            case 7:  return {marv: 11.25,  perf: 22.5,  great: 45,    good: 67.5,   bad: 180};
            case 8:  return {marv: 7.425,  perf: 14.85, great: 29.7,  good: 44.55,  bad: 180};
            case 9:  return {marv: 4.5,    perf: 9,     great: 18,    good: 27,     bad: 180};
        }
    }

    /**
        Gets the hit windows of a specific Judge as an array of floats.
        Returns Judge 4 by default.

        Boos / Bads are locked at 180ms at J4 and above.
    */
    public static function getWindowsArray(judge:Int):Array<Float> {
        switch(judge) {
            case 1:  return [33.75,  67.5,  135,   202,   270  ];
            case 2:  return [29.925, 59.85, 119.7, 179.55,239.4];
            case 3:  return [26.1,   52.2,  104.4, 156.6, 208.8];
            default: return [22.5,   45,    90,    135,   180  ];
            case 5:  return [18.9,   37.8,  75.6,  113.4, 180  ];
            case 6:  return [14.85,  29.7,  59.4,  89.1,  180  ];
            case 7:  return [11.25,  22.5,  45,    67.5,  180  ];
            case 8:  return [7.425,  14.85, 29.7,  44.55, 180  ];
            case 9:  return [4.5,    9,     18,    27,    180  ];
        }
    }

    /**
    Evaluates a hit based on its offset from the intended hit time.

    @param offset Amount of time from the time the note is supposed to be hit.
    @param judge Which Judge preset to use. Uses Judge 4 by default.
    */
    public static function evaluateHit(offset:Float, judge:Int = 4):Dynamic {
        var windows:Dynamic = getWindowsArray(judge);
        var delta:Float = Math.abs(offset);

        var hitIndex:Int = -1;

        for (i in windows) {
            if (Math.abs(delta) < i) hitIndex++;
        }

        var theThingToReturn:Dynamic = {judge: "", wifescore: Wife.getWifescoreAt(delta), life: 0, delta: offset, dp: 0};

        switch(hitIndex) {
            case 4:
                theThingToReturn.judge = "Marvelous";
                theThingToReturn.life = 0.8;
                theThingToReturn.dp = 2;

            case 3:
                theThingToReturn.judge = "Perfect";
                theThingToReturn.life = 0.8;
                theThingToReturn.dp = 1;

            case 2:
                theThingToReturn.judge = "Great";
                theThingToReturn.life = 0.4;

            case 1:
                theThingToReturn.judge = "Good";

            case 0:
                theThingToReturn.judge = "Bad";
                theThingToReturn.life = -4;

            case -1:
                theThingToReturn.judge = "Miss";
                theThingToReturn.life = -8;
        }

        return theThingToReturn;
    }

    /**
    Returns a clear type based on a map with the judgements.
    */
    public static function getClearType(judgeList:Map<String, Int>):String {
        var totalNotesHit:Int = 0;
        for (key in judgeList.keys()) totalNotesHit += judgeList[key];

        // No notes were hit so far.
        if (totalNotesHit == 0) return "N/A";

        // Miss checks
        if (judgeList["Miss"] >= 10) return "Clear";
        if (judgeList["Miss"] > 1) return "SDCB"; // Single Digit Combo Breaks.
        if (judgeList["Miss"] == 1) return "MF"; // Miss Flag.

        // FC checks
        var theBoys:Int = judgeList["Bad"] + judgeList["Good"];
        if (theBoys > 0 || judgeList["Great"] >= 10) return "FC"; // Full Combo.
        if (theBoys == 0 && judgeList["Great"] > 1) return "SDG"; // Single Digit Greats.
        if (theBoys == 0 && judgeList["Great"] == 1) return "BF"; // Black Flag.

        // MFC checks
        if (judgeList["Perfect"] >= 10) return "PFC"; // Perfect Full Combo.
        if (judgeList["Perfect"] > 1) return "SDP"; // Single Digit Perfects.
        if (judgeList["Perfect"] == 1) return "WF"; // White Flag.

        // At this point, there should only be Marvelous hits.
        return "MFC"; // Marvelous Full Combo
    }

    public static function getRatingAtAccuracy(accuracy:Float):String {
        var ranking:String = "";

        var wifeConditions:Array<Bool> = [
			accuracy >= 99.9935, // AAAAA
			accuracy >= 99.980, // AAAA:
			accuracy >= 99.970, // AAAA.
			accuracy >= 99.955, // AAAA
			accuracy >= 99.90, // AAA:
			accuracy >= 99.80, // AAA.
			accuracy >= 99.70, // AAA
			accuracy >= 99, // AA:
			accuracy >= 96.50, // AA.
			accuracy >= 93, // AA
			accuracy >= 90, // A:
			accuracy >= 85, // A.
			accuracy >= 80, // A
			accuracy >= 70, // B
			accuracy >= 60, // C
			accuracy < 60 // D
		];

		for (i in 0...wifeConditions.length)
		{
			var b = wifeConditions[i];
			if (b)
			{
				switch (i)
				{
					case 0:
						ranking += " AAAAA";
					case 1:
						ranking += " AAAA:";
					case 2:
						ranking += " AAAA.";
					case 3:
						ranking += " AAAA";
					case 4:
						ranking += " AAA:";
					case 5:
						ranking += " AAA.";
					case 6:
						ranking += " AAA";
					case 7:
						ranking += " AA:";
					case 8:
						ranking += " AA.";
					case 9:
						ranking += " AA";
					case 10:
						ranking += " A:";
					case 11:
						ranking += " A.";
					case 12:
						ranking += " A";
					case 13:
						ranking += " B";
					case 14:
						ranking += " C";
					case 15:
						ranking += " D";
				}
				break;
			}
		}


		return ranking;
	}
}
