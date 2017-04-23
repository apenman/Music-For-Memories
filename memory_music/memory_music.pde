import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import processing.sound.*;
import processing.video.*;

Movie myMovie;
float x, y, r, g, b, radius;
int timer, interval;
ArrayList<Blip> blips;
SoundFile bb3, c4, d4, eb4, f4, g4, a4, bb4;
SoundFile bb3Chord, c4Chord, d4Chord, eb4Chord, f4Chord, g4Chord, a4Chord;
AudioPlayer c4_flute, d4_flute, eb4_flute, f4_flute, g4_flute, a4_flute, bb4_flute;
PGraphics topLayer;
color[] colors;
color colVal, red, orange, yellow, green, blue, indigo, violet;
int lastNote, lastChordCount, counter;
SoundFile[] notes,chords;
AudioPlayer[] backing;
int nativeWidth, nativeHeight, frameWidthOffset, frameHeightOffset;
int currentBackingTrack, backingTimer;
int[] backingDurations;
Minim minim;


void setup() {
  noCursor();
  fullScreen(0); // Change 0 to 2 to move to second display
  //size(720, 540);
  nativeWidth = 720;
  nativeHeight = 540;
  frameWidthOffset = (width/2)-(nativeWidth/2);
  frameHeightOffset = (height/2)-(nativeHeight/2);
  counter = 0;
  lastChordCount = 0;
  lastNote = 0;
  currentBackingTrack = 0;
  backingTimer = 0;

  minim = new Minim(this);

  noStroke();
  myMovie = new Movie(this, "videos/nature.mp4");
  myMovie.loop();
  topLayer = createGraphics(width, height);
  frame.setBackground(new java.awt.Color(0,0,0));
  blips = new ArrayList<Blip>();

  initColors();
  initNotes();
  initChords();
  initBacking();

  // Start playing backing track before loop starts
  backing[currentBackingTrack].shiftGain(-50, -15, 2000);
  backing[currentBackingTrack].play();
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
 m.read();
}

void draw()
{
  background(0);
  image(myMovie, frameWidthOffset, frameHeightOffset, nativeWidth, nativeHeight);
  // image(myMovie, 0, 0, width, height);
  drawBlips();
  controlBackingMusic();

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
      interval = getNextNoteLength();
      // interval = Math.round(random(20, 100));

      // Reset timer between notes
      timer = 0;
  }
}

// Loads note files and stores in an array
void initNotes() {
  // Load notes
  bb3 = new SoundFile(this, "pianos/Bb3.mp3");
  c4 = new SoundFile(this, "pianos/C4.mp3");
  d4 = new SoundFile(this, "pianos/D4.mp3");
  eb4 = new SoundFile(this, "pianos/Eb4.mp3");
  f4 = new SoundFile(this, "pianos/F4.mp3");
  g4 = new SoundFile(this, "pianos/G4.mp3");
  a4 = new SoundFile(this, "pianos/A4.mp3");
  bb4 = new SoundFile(this, "pianos/Bb4.mp3");

  // Notes in array
  notes = new SoundFile[]{bb3, c4, d4, eb4, f4, g4, a4, bb4};
}

// Loads chord files and stores in an array
void initChords() {
  // Load chords
  bb3Chord = new SoundFile(this, "pianos/Bb3Chord.mp3");
  c4Chord = new SoundFile(this, "pianos/C4Chord.mp3");
  d4Chord = new SoundFile(this, "pianos/D4Chord.mp3");
  eb4Chord = new SoundFile(this, "pianos/Eb4Chord.mp3");
  f4Chord = new SoundFile(this, "pianos/F4Chord.mp3");
  g4Chord = new SoundFile(this, "pianos/G4Chord.mp3");
  a4Chord = new SoundFile(this, "pianos/A4Chord.mp3");

  // Chords in array
  chords = new SoundFile[]{bb3Chord, c4Chord, d4Chord, eb4Chord, f4Chord, g4Chord, a4Chord, a4Chord};
}

// Sets values for color maps and stores in an array
void initColors() {
  violet = color(0, 130, 255);
  indigo = color(120, 75, 255);
  blue = color(0, 0, 255);
  green = color(0, 128, 0);
  yellow = color(255, 255, 0);
  orange = color(0, 165, 175);
  red = color(75, 200, 75);
  colors = new int[]{red, orange, yellow, green, blue, indigo, violet};
}

void initBacking() {
  c4_flute = minim.loadFile("flutes/c4.mp3");
  d4_flute = minim.loadFile("flutes/d4.mp3");
  eb4_flute = minim.loadFile("flutes/eb4.mp3");
  f4_flute = minim.loadFile("flutes/f4.mp3");
  g4_flute = minim.loadFile("flutes/g4.mp3");
  a4_flute = minim.loadFile("flutes/a4.mp3");
  bb4_flute = minim.loadFile("flutes/bb4.mp3");

  backing = new AudioPlayer[]{d4_flute, f4_flute, c4_flute, eb4_flute, d4_flute, f4_flute};
  backingDurations = new int[]{21, 28, 20, 30, 28};
}

// Handles growing, drawing, and removing blips from array
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
    fill(255, 255, 255, (alpha-(alpha/4)));
    ellipse(x, y, rad, rad);
    fill(colVal, alpha + 100);
    ellipse(x, y, (rad / 1.5), (rad / 1.5));
  }

  void grow() {
    rad += 9;
    alpha -= 5;
  }

  boolean isAlive() {
    return alpha > 0;
  }
}

// Handles sampling a random points and drawing
color sampleRandomPoint() {
    int xRand = Math.round(random(frameWidthOffset + 40, frameWidthOffset + myMovie.width - 40));
    int yRand = Math.round(random(frameHeightOffset + 40, frameHeightOffset + myMovie.height - 40));
    // int xRand = Math.round(random(width + 40));
    // int yRand = Math.round(random(height + 40));

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
    return indexToPlay;
}

// Function to play chords if wanted
void chordVariation(int indexToPlay) {
    if(lastChordCount == 1) {
      int rand = Math.round(random(2));
      if(rand == 1) {
         chords[indexToPlay].play();
         lastChordCount++;
         return;
      }
    }
    else {
      int rand = Math.round(random(3));
      if(rand == 1) {
         chords[indexToPlay].play();
         lastChordCount++;
         return;
      }
    }
    // 1/5 chance to play as chord (with note as root note)
    int guess = Math.round(random(5));
    if (guess <= 1) {
        chords[indexToPlay].play();
         lastChordCount++;
    } else {
        notes[indexToPlay].play();
        lastChordCount = 0;
    }
}

// Attempts to smooth jumping of notes
// Will try to make sure that the next note played is either adjacent to last note
// or in the same scale as the last note
int smoothJumps(int indexToPlay) {
    int ran = Math.round(random(2));
    // 1/4 chance to play the jumping note
    if (ran == 1) {
        return indexToPlay;
    }
    // 3/4 chance to smooth out jump
    else {
        if (indexToPlay > lastNote) {
            if (indexToPlay != lastNote + 2 || indexToPlay != lastNote + 4) {
                int smooth = indexToPlay + 2;
                if (smooth < notes.length - 1) {
                    return smooth;
                }
            }
        } else {
            if (indexToPlay != lastNote - 2 || indexToPlay != lastNote - 4) {
                int smooth = indexToPlay - 2;
                if (smooth >= 0) {
                    return smooth;
                }
            }
        }
    }

    return indexToPlay;
}

// Handle finding the length of the next note
int getNextNoteLength() {
    // interval --> BPM = 60
    // quarter note = 100;
    // half note = 200;
    // whole note = 400;
    // eigth note = 50;

    // For native
    //int guess = Math.round(random(7));
    //if (guess <= 4) {
    //    return 100;
    //} else if (guess == 5) {
    //    return 200;
    //} else {
    //    return 50;
    //}
    // For projector
    int guess = Math.round(random(7));
    if (guess <= 4) {
        return 150;
    } else if (guess == 5) {
        return 300;
    } else {
        return 75;
    }
}

void controlBackingMusic() {
  // If not playing
  // println("BACKING #" + currentBackingTrack + " IS PLAYING? -- " + backing[currentBackingTrack].isPlaying());
  // if (backing[currentBackingTrack].isPlaying() == 0) {
  //   println("It's NOT PLAYING");
  //   currentBackingTrack = currentBackingTrack == backing.length - 1 ? 0 : currentBackingTrack++;
  //   backing[currentBackingTrack].play();
  // }
  // else {
  // }

  // if(backingTimer < (backingDurations[currentBackingTrack] * 30)) {
  //   backingTimer++;
  // }
  // else {
  //   println("NEW ONE!!!!!");
  //   backing[currentBackingTrack].stop();
  //   currentBackingTrack++;
  //   backing[currentBackingTrack].cue(0);
  //   backing[currentBackingTrack].play();
  //   backingTimer = 0;
  // }
  if(!backing[currentBackingTrack].isPlaying()) {
    println("COUNT: " + (backing.length));
      currentBackingTrack = currentBackingTrack < backing.length - 1 ? currentBackingTrack + 1 : 0;
      backing[currentBackingTrack].cue(0);
      backing[currentBackingTrack].shiftGain(-50, -15, 2000);
      backing[currentBackingTrack].play();
  }
}
