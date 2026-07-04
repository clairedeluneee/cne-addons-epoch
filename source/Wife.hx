package source;

public class Wife {
    public static function getWifescoreAt(deviation:Float):Float {
        var wifescore:Float = 0;
        // Curve shaping
        var curveStart:Float       = 18;        // When the curve starts in milliseconds.
        var curveEnd:Float         = 150;       // When the curve ends in milliseconds.
        var linearStrength:Float   = 9.5;       // Dictates how fast should the curve plummets.
        var exponentStrength:Float = 2;         // Dictates how sharp the curve plummets.
        // Hit shaping
        var maxScore:Float         = 2;         // Maximum points to provide. Automatically given if the deviation falls before the curve (before the curve start).
        var minScore:Float         = -7.5;      // Minimum points to provide. Automatically given if the deviation falls after the curve  (past the end of the curve).
        // Actual curve function.
        wifescore = maxScore - (linearStrength * Math.pow((deviation - curveStart) / (curveEnd - curveStart), exponentStrength));
        if (deviation < curveStart) wifescore = maxScore;
        if (wifescore < minScore)   wifescore = minScore;
        return wifescore;
    }
}
