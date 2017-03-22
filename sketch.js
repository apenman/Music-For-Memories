var img;
var osc, osc2, osc3;
var interval = 10,
    timer = 0;
var row = 1;
var debug = true;

// Colors
var violet = [238, 130, 238];
var indigo = [75, 0, 130];
var blue = [0, 0, 255];
var green = [0, 128, 0];
var yellow = [255, 255, 0];
var orange = [255, 165, 0];
var red = [255, 0, 0];
var colors = [red, orange, yellow, green, blue, indigo, violet];
var Bb3, C4, D4, Eb4, F4, G4, A4, Bb4;
var Bb3Chord;
var C4Chord = [1, 3, 5];
var D4Chord = [2, 4, 6];
var Eb4Chord = [];
var F4Chord = [];
var G4Chord = [];
var A4Chord = [];
var chords = [Bb3Chord, C4Chord, D4Chord];
var notes;
var vid;

function preload() {
    // vid = createVideo("assets/vid.mp4");
    // img = loadImage("assets/mountains.jpg");
    img = loadImage("assets/rainbow.png");
    Bb3 = loadSound("assets/Bb3.mp3");
    C4 = loadSound("assets/C4.mp3");
    D4 = loadSound("assets/D4.mp3");
    Eb4 = loadSound("assets/Eb4.mp3");
    F4 = loadSound("assets/F4.mp3");
    G4 = loadSound("assets/G4.mp3");
    A4 = loadSound("assets/A4.mp3");
    // Bb4 = loadSound("assets/Bb4.mp3");

    // Load chords
    Bb3Chord = loadSound("assets/Bb3Chord.mp3");

    // Notes in array
    notes = [Bb3Chord, C4, D4, Eb4, F4, G4, A4, Bb4];
}

function setup() {
    createCanvas(windowWidth, windowHeight);
    image(img, 0, 0);
    //vid.volume(0);
    //vid.play();
    // var c = get(90, 90);
    // var avgCol = getAverageRGBSquare(random(img.width), random(img.height));
    // fill(avgCol[0], avgCol[1], avgCol[2]);
    // noStroke();
    // rect(windowWidth - 75, windowHeight - 75, 50, 50);
    // osc = new p5.Oscillator();
    // osc.setType('sine');
    // osc.amp(0.5);
    // osc2 = new p5.Oscillator();
    // osc2.setType('sine');
    // osc2.amp(0.5);
    // osc3 = new p5.Oscillator();
    // osc3.setType('sine');
    // osc3.amp(0.5);
    // osc.start();
    // osc2.start();
    // osc3.start();
}

function getAverageRGBSquare(xVal, yVal) {
    var avgR = avgG = avgB = 0;

    for (var i = -5; i <= 5; i++) {
        for (var j = -5; j <= 5; j++) {
            var test = get(xVal + i, yVal + j);
            avgR += test[0];
            avgG += test[1];
            avgB += test[2];
        }
    }
    avgR = floor(avgR / 121);
    avgG = floor(avgG / 121);
    avgB = floor(avgB / 121);

    return [avgR, avgG, avgB];
}

function getAverageRGBStrip(xVal) {
    var avgR = avgG = avgB = 0;
    for (var i = 0; i < img.height / 10; i++) {
        var test = get(xVal, i * 10);
        avgR += test[0];
        avgG += test[1];
        avgB += test[2];
    }
    avgR = floor(avgR / (img.height / 10));
    avgG = floor(avgG / (img.height / 10));
    avgB = floor(avgB / (img.height / 10));
    // console.log("R: " + avgR);
    // console.log("G: " + avgG);
    // console.log("B: " + avgB);

    return [avgR, avgG, avgB];
}

function mapToSound(col) {
    // Use offset to change attack and release??
    var r = col[0];
    var g = col[1];
    var b = col[2];

    var chosenIndex;
    var maxOffset = 999;
    // For every color
    for (var i = 0; i < colors.length; i++) {
        var offset = 0;
        // For r,g,b
        for (var j = 0; j < 3; j++) {
            offset += abs(colors[i][j] - col[j]);
        }
        if (offset < maxOffset) {
            chosenIndex = i;
            maxOffset = offset;
        }
    }

    // Add random chance to play chord for now (maybe 1 in 3?)
    // var guess = floor(random() * 2);
    // if (guess == 1 && chosenIndex < 3) {
    //     return chords[chosenIndex];
    // }

    // If this chosenIndex is the same as last chosen index
    // Return the next note in chord instead??
    // Repeats don't sound that good
    return chosenIndex;
}

function playChord(base) {


}

function draw() {
    // background(255);
    // image(vid, 0, 0); // draw a second copy to canvas

    if (timer < interval) {
        timer++;
    } else {
        image(img, 0, 0);
        // var colVal = getAverageRGBStrip(row);
        var xRand = random(img.width - 40);
        var yRand = random(img.height - 40);
        var colVal = getAverageRGBSquare(xRand, yRand);
        console.log("R: " + colVal[0]);
        console.log("G: " + colVal[1]);
        console.log("B: " + colVal[2]);
        // var toPlay = mapToSound(colVal);
        // for (var i = 0; i < toPlay.length; i++) {
        //     // console.log(" PLAYING NOTESSSS + " + i);
        //     notes[toPlay[i]].play();
        // }
        notes[mapToSound(colVal)].play();
        // osc.freq(colVal[0]);
        // osc2.freq(colVal[1]);
        // osc3.freq(colVal[2]);
        timer = 0;
        row += 10;
        interval = random(10, 100);

        if (debug) {
            stroke(color(255, 223, 0));
            fill(colVal[0], colVal[1], colVal[2]);
            // console.log("AT " + row + " : " + img.height);
            // line(row, img.height, row, img.height + 20);
            rect(xRand, yRand, 10, 10);
            rect(windowWidth - 75, windowHeight - 75, 50, 50);
        }
    }

}
