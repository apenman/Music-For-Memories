# Music For Memories
Music For Memories is an initial exploration into generative audio for video. The goal is to create a warm and nostalgic soundtrack that can accompany any piece of film. The program analyzes the color values of randomly sampled points along with recently played notes to determine which note from a scale to play next. Due to the nature of using random samples, each viewing of the same video will generate a different soundtrack, allowing for a unique experience every time.

This project was created for the final showcase of Gray Area's 10 week long Creative Code Immersive during Winter 2017. It was displayed in Gray Area's Grand Theater alongside the final project of my peers in the winter cohort. Music For Memories, in its current form, accompanied a compilation of found footage of old family hiking trips captured on 16mm film from the Internet Archive courtesy of David Ross Brower. The video looped for over three hours with the program generating sounds the entire time.

## Song Composition
The soundtrack is algorithmically generated following a set of four steps:
* Take sample form image frame
* Find nearest color value from average RGB
* Check for repeats
* Randomly play a chord

## Code
Music For Memories is a processing sketch which requires a video file to create a soundtrack for.

## Showcase

## Further Exploration
From Matt:
1. Random sets of notes (triplets, rests) rather than individual notes
2. Lerp between points on image to move the square -- how does that affect sound
3. Use some sort of histogram algorithm (or something else) in order to get the overall tone of image (or other data).
  a. Explore the image of the data more -- find out how this could influence the sound
4. Maybe another part of image can generate bass line or backing track

1. Find a few images that fit the mood I want. Cycle through them and explore

## Issues
1. IsPlaying() not working on the backing tracks -- probably caused by media event tracking video
