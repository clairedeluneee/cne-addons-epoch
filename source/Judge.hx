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



    public static function evaluateHit(delta:Float, judge:Int = 4):Dynamic {
        var windows:Dynamic = getWindowsArray(judge);

        var hitIndex:Int = -1;

        for (i in windows) {
            if (Math.abs(delta) < i) hitIndex++;
        }

        var theThingToReturn:Dynamic = {judge: "", wifescore: Wife.getWifescoreAt(delta), life: 0, delta: delta, dp: 0};

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
}
