var img;
var osc, osc2, osc3;
var interval = 10,
    timer = 0;
var row = 1;
var debug = true;

var violet, indigo, blue, green, yellow, orange, red, colors;
var Bb3, C4, D4, Eb4, F4, G4, A4, Bb4;
var Bb3Chord, C4Chord, D4Chord, Eb4Chord, F4Chord, G4Chord, A4Chord;
var chords;
var notes;
var vid;

function preload() {
    // What image are we using?
    // vid = createVideo("assets/vid.mp4");
    // img = loadImage("assets/mountains.jpg");
    img = loadImage("assets/rainbow.png");

    // Load notes
    Bb3 = loadSound("assets/Bb3.mp3");
    C4 = loadSound("assets/C4.mp3");
    D4 = loadSound("assets/D4.mp3");
    Eb4 = loadSound("assets/Eb4.mp3");
    F4 = loadSound("assets/F4.mp3");
    G4 = loadSound("assets/G4.mp3");
    A4 = loadSound("assets/A4.mp3");

    // Load chords
    Bb3Chord = loadSound("assets/Bb3Chord.mp3");
    C4Chord = loadSound("assets/C4Chord.mp3");
    D4Chord = loadSound("assets/D4Chord.mp3");
    Eb4Chord = loadSound("assets/Eb4Chord.mp3");
    F4Chord = loadSound("assets/F4Chord.mp3");
    G4Chord = loadSound("assets/G4Chord.mp3");
    A4Chord = loadSound("assets/A4Chord.mp3");

    // Notes in array
    notes = [Bb3, C4, D4, Eb4, F4, G4, A4, Bb4];
    // Chords in array
    chords = [Bb3Chord, C4Chord, D4Chord, Eb4Chord, F4Chord, G4Chord, A4Chord];

    // Load colors
    violet = [238, 130, 238];
    indigo = [75, 0, 130];
    blue = [0, 0, 255];
    green = [0, 128, 0];
    yellow = [255, 255, 0];
    orange = [255, 165, 0];
    red = [255, 0, 0];

    // Colors in array
    colors = [red, orange, yellow, green, blue, indigo, violet];
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

        var nextIndex = mapToSound(colVal);
        // Add random chance to play chord for now (maybe 1 in 3?)
        var guess = floor(random() * 5);
        if (guess == 1) {
            console.log("CHOOOOOORD");
            chords[nextIndex].play();
        } else {
            notes[nextIndex].play();

        }
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
