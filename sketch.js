var img;
var interval = 10,
    timer = 0;
var violet, indigo, blue, green, yellow, orange, red, colors;
var Bb3, C4, D4, Eb4, F4, G4, A4, Bb4;
var Bb3Chord, C4Chord, D4Chord, Eb4Chord, F4Chord, G4Chord, A4Chord;
var chords;
var notes;
var vid;
var lastNote;

function preload() {
    // What image are we using?
    // vid = createVideo("assets/vid.mp4");
    img = loadImage("assets/mountains.jpg");
    // img = loadImage("assets/rainbow.png");

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

    // Load base map colors
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

    // For image
    image(img, 0, 0);

    // For video
    //vid.volume(0);
    //vid.play();
}

// Takes a pixel's coordinate and samples a 5x5 grid around it
// Returns the average RGB value of the grid as an array
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

// Samples an entire column given an x coordinate
// Returns the average RGB value of the column as an array
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

    return [avgR, avgG, avgB];
}

// Map an RGB value (as an array) to its nearest note on the scale
// Red is root note; violet is seventh note
// Mapping is done by taking an aggregate of how far off each RGB value is
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
            // Find how far away value is from one of the set colors
            offset += abs(colors[i][j] - col[j]);
        }
        // If it is closer than the current closest
        if (offset < maxOffset) {
            // This will be our new note to return
            chosenIndex = i;
            maxOffset = offset;
        }
    }

    return chosenIndex;
}

// Function to handle repeated notes if wanted
function repeatVariation(indexToPlay) {
    // if note is a repeat of last note
    if (lastNote && lastNote == indexToPlay) {

        var ran = floor(random() * 3);
        // 1/3 chance to play same note again
        if (ran == 1) {
            return indexToPlay;
        }
        // 2/3 chance to play adjacent note in chord
        else {
            // 1/2 chance to play up 1/2 chance to play down
            if (ran = floor(random() * 2)) {

            } else {

            }
        }
    }

    return indexToPlay;
}

// Function to play chords if wanted
function chordVariation(indexToPlay) {
    // 1/5 chance to play as chord (with note as root note)
    var guess = floor(random() * 5);
    if (guess == 1) {
        chords[indexToPlay].play();
    } else {
        notes[indexToPlay].play();
    }
}

// Handles all logic around finding and playing next sound file
function playNote(colVal) {
    var indexToPlay = mapToSound(colVal);

    indexToPlay = repeatVariation(indexToPlay);

    // notes[indexToPlay].play();
    // Play note with chance to play as chord
    chordVariation(indexToPlay);

    lastNote = indexToPlay;
}

// Handle finding the length of the next note
function getNextNoteLength() {
    // interval --> BPM = 60
    // quarter note = 100;
    // half note = 200;
    // whole note = 400;
    // eigth note = 50;
    // var guess = floor(random() * 3);
    // if (guess == 1) {
    //     interval = 50;
    // } else {
    //     interval = 100;
    // }
}

// Highlights a square in gold around sampled pixel
function highlightNote(colVal, xRand, yRand) {
    stroke(color(255, 223, 0));
    fill(colVal[0], colVal[1], colVal[2]);
    rect(xRand, yRand, 10, 10);
    rect(windowWidth - 75, windowHeight - 75, 50, 50);
}

// Handles sampling a random points and drawing
function sampleRandomPoint() {
    var xRand = random(img.width - 40);
    var yRand = random(img.height - 40);

    // Get the average RGB values around pixel
    var colVal = getAverageRGBSquare(xRand, yRand);

    // Highlight the note on the image
    highlightNote(colVal, xRand, yRand);

    return colVal;
}

function draw() {
    // background(255);
    // image(vid, 0, 0); // draw a second copy to canvas

    // If it's still not time to play a note...increment timer
    if (timer < interval) {
        timer++;
    }
    // Let's play a note!
    else {
        // Redraw image to cover up old highlights
        image(img, 0, 0);

        // Sample random location on image
        colVal = sampleRandomPoint();

        // Play the next note
        playNote(colVal);

        // Set the time until next note
        //interval = getNextNoteLength();
        interval = random(20, 100);

        // Reset timer between notes
        timer = 0;
    }
}
