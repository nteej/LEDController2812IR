gDelay=15;

void besin() {                                                             // Add a Perlin noise soundbar. This looks really cool.

// Local definitions


// Persistent local variables


  
  leds[NUM_LEDS/2] = ColorFromPalette(currentPalette, millis(), sampleavg, NOBLEND);
  leds[NUM_LEDS/2-1] = ColorFromPalette(currentPalette, millis(), sampleavg, NOBLEND);


//  leds[NUM_LEDS/2] = ColorFromPalette(currentPalette, sampleavg, beatsin8(sampleavg,0,255), NOBLEND);
//  leds[NUM_LEDS/2-1] = ColorFromPalette(currentPalette, sampleavg, beatsin8(sampleavg,0,255), NOBLEND);


  waveit();                                                                     // Move the pixels to the left/right, but not too fast.

//  fadeToBlackBy(leds+NUM_LEDS/2-1, 2, 128);                                     // Fade the center, while waveit moves everything out to the edges.
  fadeToBlackBy(leds, NUM_LEDS, 2);                                                                                 

} // besin()

#endif
