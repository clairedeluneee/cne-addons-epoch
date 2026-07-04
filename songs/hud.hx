import source.ClefUtils;
import source.Judge;
import source.Wife;
import flixel.util.FlxStringUtil;

var life:Float = 50;
var dp:Dynamic = {total: 0, current: 0, ratio: 1};
var wife:Dynamic = {total: 0, score: 0};

var ep_camera = ClefUtils.makeCamera(true);

var ep_accuracy   = ClefUtils.makeText(16, 350 - 24, "100.00%", 32, "left", true);
var ep_judgeStats = ClefUtils.makeText(16, 350, "", 16, "left", true);
var ep_judge      = ClefUtils.makeText(16, 150, "", 24, "center", true);
var ep_songDetail = ClefUtils.makeText(16, 16, "", 16, "left", true);

var ep_judgeProgress = 0;

function postCreate() {
    for (i in [ep_accuracy, ep_judgeStats, ep_judge, ep_songDetail]) {
        i.font = Paths.font("Perfect DOS VGA 437 Win.ttf");
        add(i).camera = ep_camera;
    }

    ep_songDetail.text = (PlayState.SONG.meta.displayName ?? PlayState.SONG.meta.name) + "\nW3 J4 L4";
    ep_songDetail.y = ep_camera.height - 16 - ep_songDetail.height;
}

var judgeList:Map<String, Int> = [
    "Marvelous" => 0,
    "Perfect" => 0,
    "Great" => 0,
    "Good" => 0,
    "Bad" => 0,
    "Miss" => 0,
    ];

function onPlayerHit(e) {
    e.healthGain = 0;
    if (e.note.isSustainNote) return;

    reeval(e.note.strumTime, false);

    FlxG.sound.play(Paths.sound("editors/charter/hitsound"));
}

function postUpdate(delta) {
    for (i in player.members) {
        i.scrollSpeed = 3.5;
    }

    if (ep_judgeProgress < 1) ep_judgeProgress += delta * 2;
    ep_judge.scale.x = ep_judge.scale.y = 1.25 - FlxEase.quintOut(ep_judgeProgress) * 0.25;
    ep_judge.alpha = 1 -  FlxEase.quintIn(ep_judgeProgress);

    var centerpoint = 0;
    var sum = 0;

    for (i in player.members) {
        sum += i.x + i.width / 2;
    }

    centerpoint = sum / player.members.length;
    ep_judge.x = centerpoint - ep_judge.width / 2;

    health = life / 50;

    ep_accuracy.text = FlxStringUtil.formatMoney(wife.total == 0 ? 0 : wife.score / wife.total * 100) + "%";

    ep_judgeStats.text = "";
    ep_judgeStats.text += "\nMA    " + judgeList["Marvelous"];
    ep_judgeStats.text += "\nPR    " + judgeList["Perfect"];
    ep_judgeStats.text += "\nGR    " + judgeList["Great"];
    ep_judgeStats.text += "\nGD    " + judgeList["Good"];
    ep_judgeStats.text += "\nBD    " + judgeList["Bad"];
    ep_judgeStats.text += "\nMS    " + judgeList["Miss"];
    ep_judgeStats.text += "\n";
    ep_judgeStats.text += "\nMA    " + FlxStringUtil.formatMoney(judgeList["Perfect"] > 0 ? judgeList["Marvelous"] / judgeList["Perfect"] : 0);
    ep_judgeStats.text += "\nPA    " + FlxStringUtil.formatMoney(judgeList["Great"] > 0 ? judgeList["Perfect"] / judgeList["Great"] : 0);
}

function onNoteMiss(e) {
    reeval(e.note.strumTime + 10000, true);

    judgeList["Miss"]++;
}

function reeval(deviation, isMiss) {
    var obj:Dynamic = Judge.evaluateHit(Conductor.songPosition - deviation, 4);

    var wifescore = Wife.getWifescoreAt(Math.abs(Conductor.songPosition - deviation));

    life += obj.life;
    dp.total += 2;
    dp.current += obj.dp;
    dp.ratio = dp.current / dp.total;

    wife.total += 2;
    wife.score += isMiss ? -2.75 : wifescore;

    judgeList[obj.judge]++;

    ep_judgeProgress = 0;
    ep_judge.text =  obj.judge + "\n"+ FlxStringUtil.formatMoney(obj.delta) + "ms\n" + FlxStringUtil.formatMoney(wifescore / 2 * 100);
}
