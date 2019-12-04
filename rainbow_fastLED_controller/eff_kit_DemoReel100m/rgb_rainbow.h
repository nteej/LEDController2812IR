// ������ ���� �� �������� �� ������ ����� � �������
#define RGB_RB_FADE_STEP       3

// �������� ����� ������
CRGB RGB_RainbowColors[] =
{
  CRGB(0,   255, 0),    // �������
  CRGB(165, 255, 0),    // ���������
  CRGB(255, 255, 0),    // Ƹ����
  CRGB(255, 0,   0),    // ������
  CRGB(255, 0,   255),  // �������
  CRGB(0,   0,   255),  // �����
  CRGB(0,   255, 255)   // ����������
};
    

void rgb_rainbow_tick()
{
  
  EVERY_N_MILLISECONDS(11100)
  {
	  	blend_amount=0;
		if(random8()<128) //randomize palette
		{
			for(byte i=0;i<  ARRAY_SIZE(RGB_RainbowColors);i++)
			{
				RGB_RainbowColors[i]=
				CHSV(
				random8(15)*16,
				(random8()<50)? random8(2)*255:255,
				(random8()<50)? random8(2)*255:255
				); //CRGB(random8(2)*255,random8(2)*255,random8(2)*255);
			}
		}
  }
  
   blend_amount=qadd8(blend_amount,RGB_RB_FADE_STEP);   // ������ ������ ����  
  if (blend_amount==255)
  {
	  blend_amount=0;
    
    if (++var2 >= ARRAY_SIZE(RGB_RainbowColors)) // ������ ����
      var2 = 0;
	leds[0]=leds[1];
  }
  
  moveOutAllRemainFirst();// ����� ������� �������� ������



  if(millis()/1024%10<2)
  {
	leds[0]=CHSV(gHue2,255,255);
  }
  else
  {
	leds[1]=blend(leds[0], RGB_RainbowColors[var2], blend_amount);


	 if(millis()/1000%16<6)
	 {
		//leds[beatsin8(beatsin8(2,6,18),NUM_LEDS/4,NUM_LEDS-1)]=blend(RGB_RainbowColors[var2],leds[0], blend_amount);
		leds[beatsin8(8+millis()/1000%6,NUM_LEDS/4,NUM_LEDS-1)]=blend(RGB_RainbowColors[var2],leds[0], blend_amount);
	 }
  }


}
