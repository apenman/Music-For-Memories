import processing.sound.*;
import processing.video.*;

Movie myMovie;
float x;
float y;
float r, g, b, radius;
int timer, interval;
ArrayList<Blip> blips;
SoundFile bb3, c4, d4, eb4, f4, g4, a4, bb4;
SoundFile bb3Chord, c4Chord, d4Chord, eb4Chord, f4Chord, g4Chord, a4Chord;
color colVal;
PGraphics topLayer;
color[] colors;
color red,orange,yellow,green,blue,indigo,violet;
int lastNote = 0;
SoundFile[] notes,chords;
int counter = 0;
int nativeWidth, nativeHeight;

void setup()
{
  nativeWidth = 720;
  nativeHeight = 540;
   fullScreen(0); // Change 0 to 2 to move to second display
  //size(720, 540);
  noStroke();
  myMovie = new Movie(this, "nature.mp4");
  myMovie.loop();
  topLayer = createGraphics(width, height);
  frame.setBackground(new java.awt.Color(0,0,0));
  blips = new ArrayList<Blip>();

  violet = color(0, 130, 255);
  indigo = color(120, 75, 255);
  blue = color(0, 0, 255);
  green = color(0, 128, 0);
  yellow = color(255, 255, 0);
  orange = color(0, 165, 175);
  red = color(75, 200, 75);
  colors = new int[]{red, orange, yellow, green, blue, indigo, violet};

  // Load notes
  bb3 = new SoundFile(this, "Bb3.mp3");
  c4 = new SoundFile(this, "C4.mp3");
  d4 = new SoundFile(this, "D4.mp3");
  eb4 = new SoundFile(this, "Eb4.mp3");
  f4 = new SoundFile(this, "F4.mp3");
  g4 = new SoundFile(this, "G4.mp3");
  a4 = new SoundFile(this, "A4.mp3");
  bb4 = new SoundFile(this, "Bb4.mp3");

  // Load chords
  bb3Chord = new SoundFile(this, "Bb3Chord.mp3");
  c4Chord = new SoundFile(this, "C4Chord.mp3");
  d4Chord = new SoundFile(this, "D4Chord.mp3");
  eb4Chord = new SoundFile(this, "Eb4Chord.mp3");
  f4Chord = new SoundFile(this, "F4Chord.mp3");
  g4Chord = new SoundFile(this, "G4Chord.mp3");
  a4Chord = new SoundFile(this, "A4Chord.mp3");

  // Notes in array
  notes = new SoundFile[]{bb3, c4, d4, eb4, f4, g4, a4, bb4};
  // Chords in array
  chords = new SoundFile[]{bb3Chord, c4Chord, d4Chord, eb4Chord, f4Chord, g4Chord, a4Chord, a4Chord};
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
 m.read();
}

void draw()
{
  background(0);
  image(myMovie, 0, 0, nativeWidth, nativeHeight);
  println("DRAWING ____" + counter++);
  drawBlips();

  // If it's still not time to play a note...increment timer
  if (timer < interval) {
      timer++;
  }
  // Let's play a note!
  else {
      // Sample random location on image
      colVal = sampleRandomPoint();

      // Play the next note
      playNote(colVal);

      // Set the time until next note
      //interval = getNextNoteLength();
      interval = Math.round(random(20, 100));

      // Reset timer between notes
      timer = 0;
  }
}

void drawBlips() {
    topLayer.beginDraw();
    for (int i = blips.size() - 1; i >= 0; i--) {
        Blip blip = blips.get(i);
        blip.grow();
        if (blip.isAlive()) {
            // console.log("BLIP " + i + " IS ALIVE");
            blip.draw();
        } else {
            blips.remove(i);
        }
    }
    topLayer.endDraw();
    image( topLayer, 0, 0 );
}

class Blip {
  int x,y,rad,alpha;
  color colVal;

  Blip(int x, int y, color colVal) {
    this.x = x;
    this.y = y;
    this.colVal = colVal;
    this.alpha = 255;
    this.rad = 10;
  }

  void draw() {
    fill(255, 255, 255, alpha);
    ellipse(x, y, rad, rad);
    fill(colVal, alpha);
    ellipse(x, y, rad / 1.5, rad / 1.5);
  }

  void grow() {
    rad += 3;
    alpha -= 2;
  }

  boolean isAlive() {
    return alpha > 0;
  }
}

// Handles sampling a random points and drawing
color sampleRandomPoint() {
    int xRand = Math.round(random(myMovie.width - 40));
    int yRand = Math.round(random(myMovie.height - 40));

    // Get the average RGB values around pixel
    color colVal = getAverageRGBSquare(xRand, yRand);

    // Highlight the note on the image
    // highlightNote(colVal, xRand, yRand);
    // Create blips
    blips.add(new Blip(xRand, yRand, colVal));

    return colVal;
}

// Takes a pixel's coordinate and samples a 5x5 grid around it
// Returns the average RGB value of the grid as an array
color getAverageRGBSquare(int xVal, int yVal) {

    // for (var i = -5; i <= 5; i++) {
    //     for (var j = -5; j <= 5; j++) {
    //         var test = get(xVal + i, yVal + j);
    //         avgR += test[0];
    //         avgG += test[1];
    //         avgB += test[2];
    //     }
    // }
    // avgR = floor(avgR / 121);
    // avgG = floor(avgG / 121);
    // avgB = floor(avgB / 121);
    //
    // console.log("R: " + avgR + " G: " + avgG + " B: " + avgB);
    //
    //
    // return [avgR, avgG, avgB];
    color test = get(xVal, yVal);
    return test;
    // loadPixels();
    // var r = pixels[4];
    // var g = pixels[5];
    // var b = pixels[6];
    // var a = pixels[7];
    // console.log("GOT -- " + a);
    // return [r, g, b];
}

void playNote(color colVal) {
  int indexToPlay = mapToSound(colVal);
  indexToPlay = repeatVariation(indexToPlay);
  chordVariation(indexToPlay);

  lastNote = indexToPlay;
}

// Map an RGB value (as an array) to its nearest note on the scale
// Red is root note; violet is seventh note
// Mapping is done by taking an aggregate of how far off each RGB value is
int mapToSound(color col) {
    // Use offset to change attack and release??
    int chosenIndex = 0;
    int maxOffset = 999;
    // For every color
    for (int i = 0; i < colors.length; i++) {
        float offset = 0;
        // For rgb, calculate offset
        offset += abs(red(colors[i]) - red(col));
        offset += abs(green(colors[i]) - green(col));
        offset += abs(blue(colors[i]) - blue(col));

        // If it is closer than the current closest
        if (offset < maxOffset) {
            // This will be our new note to return
            chosenIndex = i;
            maxOffset = Math.round(offset);
        }
    }
    println("CHOSEN INDEX -- " + chosenIndex);
    return chosenIndex;
}

// Function to handle repeated notes if wanted
int repeatVariation(int indexToPlay) {
    // if note is a repeat of last note
    if (lastNote == indexToPlay) {
        int ran = Math.round(random(4));
        // 1/4 chance to play same note again
        if (ran != 1) {
            ran = Math.round(random(2));
            // 1/2 chance to play up 1/2 chance to play down
            if (ran != 1) {
                if (notes.length - 1 > indexToPlay) {
                    indexToPlay++;
                } else {
                    indexToPlay--;
                }
            } else {
                if (indexToPlay > 0) {
                    indexToPlay--;
                } else {
                    indexToPlay++;
                }
            }
        }
    }

    if (indexToPlay == 3) {
        int ran = Math.round(random(6));
        if (ran <= 1) {
            indexToPlay = 5;
        } else if (ran <= 3) {
            indexToPlay = 7;
        } else if (ran == 4) {
            indexToPlay = 4;
        }
    }

    // Using array of lastNotes
    // if (lastNotes.indexOf(indexToPlay) >= 0) {
    //     var count = 0;
    //     for (var i = 0; i < lastNotes.length - 1; i++) {
    //         if (lastNotes[i] == indexToPlay)
    //             count++;
    //     }
    //     if (count >= 1) {
    //         console.log("REPEATING !!!");
    //         var latest = lastNotes[lastNotes.length - 1];
    //         if (indexToPlay > notes.length - 1) {
    //             // At the end
    //             indexToPlay = latest - 1;
    //         } else if (indexToPlay < 1) {
    //             // At the beg
    //             indexToPlay = latest + 1;
    //         } else {
    //             var past = lastNotes[lastNotesMax - 1];
    //             if (latest < past) {
    //                 indexToPlay++;
    //             } else {
    //                 indexToPlay--;
    //             }
    //         }
    //     }
    // }
    println("UPDATED TO -- " + indexToPlay);
    return indexToPlay;
}

// Function to play chords if wanted
void chordVariation(int indexToPlay) {
    // 1/5 chance to play as chord (with note as root note)
    int guess = Math.round(random(5));
    if (guess <= 1) {
        chords[indexToPlay].play();
    } else {
        notes[indexToPlay].play();
    }
}