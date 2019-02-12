/* TODO
fix load btn must not call effSet msg.   Avoid double event

 eff names list
*/
/*
12 70 70 0
18 35 108 0
33 8 12 3
23 130 1 1
19 13 229 10
21 23 2 8
22 11 209 9
25 4 5 17
31 10 28 13
21 2 3 8
*/

import java.util.Map;
import java.util.LinkedHashMap;

import java.awt.*;
import java.awt.event.*;
import java.awt.datatransfer.*;
import javax.swing.*;
import java.io.*;
void copyToClipboard(String selection) //https://forum.processing.org/one/topic/what-is-the-simplest-way-to-copy-to-the-clipboard-from-processing.html
{
	println(selection);
 StringSelection data = new StringSelection(selection);
 Clipboard clipboard = 
 Toolkit.getDefaultToolkit().getSystemClipboard();
 clipboard.setContents(data, data);
}


boolean bDebugPrint=false;
static int serialSpeed=115200;//57600
boolean bSetBrightnessAtConnect=true;


int bConnected=1; //0 off, 1 try connect, 2 connected
boolean bSkipEvent=false;

void setupValues()  //set and display
{
	//settingsVals.get("effN").setValue(0);
	bSkipEvent=true;
	settingsVals.get("action").setValue(0);
	bSkipEvent=false;
}

import g4p_controls.*;
import processing.serial.*;
Serial myPort;


static int effN_PAUSE=0;

private LinkedHashMap<String, settingsVal> settingsVals = new LinkedHashMap<String, settingsVal>();
String actionNm[]={"flashLEDs","invertLEDs","addGlitter","flashAndBackLEDs","fadeOut_continued","moveOut_continued","offPixel_continued","","","","","",""}; //upd arr size at put("action",

boolean rCh=true,gCh=true,bCh=true;
void drawRGB(int chen)
{
		rCh=true;gCh=true;bCh=true;	
	if(chen==1 ||chen==4||chen==5)
		rCh=false; 
	if(chen==2 ||chen==5||chen==6)
		gCh=false;
	if(chen==3 ||chen==6||chen==4)
		bCh=false; 
}
long bSkipEvent_off_t=0;
class settingsVal
{
	public String nm;
	public int value;
	public void setValue(int v)
	{
		//if(value==v && value<239) return; // send again only № that toggle some settings at controller
		value=v;

		if(value>value_M) value=0;
		else
		if(value<value_m) value=value_M;

		if(valueSlider!=null)
		{
			//bSkipEvent=true;
			//bSkipEvent_off_t=millis()+10;
			valueSlider.setValue(value);
		}
		if(nm=="effN") label_effN_val.setText(Integer.toString(value));
		else
		if(nm=="RGB") drawRGB(value);

		SendMsg(message_code, value);
	}

	void add()
	{
	  setValue(value+1);
	}

	void sub()
	{
	  setValue(value-1);
	}
  
	public int value_m;
	public int value_M;
	public int message_code;
	GLabel valueLabel;
	GSlider valueSlider;
	public settingsVal(String n, int v, int vm, int vM, int code, GLabel label, GSlider slider)
	{
		nm=n;
		value=v;
		value_m=vm;
		value_M=vM;
		message_code=code;
		valueLabel=label;
		valueSlider=slider;
	}
}

settingsVal getsettingsVal_by_mode_N(int mode_N)
{
	return settingsVals.get((new ArrayList(settingsVals.keySet())).get(mode_N));
}

int mode;
static int mode_M=7; //sliders arr

GButton[] slots_s=new GButton[10];
GButton[] slots=new GButton[10];

boolean bModeSent=false;
int mode_last;
void modeChanged()
{
	if(mode>mode_M) mode=0;
	else
	if(mode<0) mode=mode_M;
  
	 settingsVal sett=getsettingsVal_by_mode_N(mode);

	btn3_M.setText("Mode:"+sett.nm);
	btn5_select.setText("Mode:"+sett.nm);

	if(sett.valueLabel!=null)	sett.valueLabel.setTextBold();
	if(mode_last!=mode) 
	{
		GLabel lab=getsettingsVal_by_mode_N(mode_last).valueLabel;
		if(lab!=null)lab.setTextPlain();
		
		mode_last=mode;
	}

	bModeSent=false;
}

	void add(int mode_N)
	{
	  getsettingsVal_by_mode_N(mode_N).add();
	}

	void sub(int mode_N)
	{
	  getsettingsVal_by_mode_N(mode_N).sub();
	}




public void slots_click(GButton source, GEvent event) { //_CODE_:slot1s:349728:
	if ( event != GEvent.CLICKED) return;
	int slot_N=-1;
	int msgCode=-1;									
	for (int i=0; i<10; i++)
	 {
		if (source == slots_s[i] )
		{
			slots_s[i].setText(Integer.toString(settingsVals.get("effN").value));

   			slot_N=i;
   			msgCode=settingsVals.get("save").message_code;

   			bModeSent=true;
   			SendMsg(msgCode, slot_N);
			 break;
		}

		if (source == slots[i] )
		{
			slot_N=i;
			//msgCode=settingsVals.get("load").message_code; //! not need, del load mesage. Because slots 0...9 loads
			settingsVals.get("effN").setValue(slot_N);
			break;
		}
	}
	
}

void SendMsg(int msgCode, int val)
{
	//if(!bModeSent  //!!
	if(myPort==null)
	{
			return;
	}
		if(bDebugPrint){ print(msgCode);print(": ");println(val);  println("-------------------------------");}
	myPort.write(msgCode);
	myPort.write(msgCode);

	myPort.write(val);

}

void  put(String n, int v, int vm, int vM, int code, GLabel label, GSlider slider)
{
	settingsVals.put(n, new settingsVal(n, v, vm, vM, code, label, slider));
}


public void setup(){
  size(690, 590);
  createGUI();
  customGUI();
  

  // Place your setup code here

  	put("effN",		0,0,255,241,label_effN,slider_effN);
	put("speed",	1,0,255,242,label_speed,slider_speed); //! uniform names
	put("length",	9,1,255,243,label_length,slider_length);
	put("RGB",		0,0, 18,244,label_RGB,slider_RGB);
	put("speedH",	4,0,255,245,label_speedH,slider_speedH);
	put("lengthH",	9,1,255,246,label_lengthH,slider_lengthH);
	put("bright",	0,1,255,247,label_brightness,slider_brightness);
	put("action",	0,0,  6,248,null,slider_action);

	put("save",		0,0,255,249,null,null);
	put("load",		0,0,255,250,null,null);

	put("clear",	0,0,255,251,null,null);
	put("pause",	0,0,255,252,null,null);
	put("reset",	0,0,255,253,null,null);

	int valM=	settingsVals.get("RGB").value_M;
	slider_RGB.setNbrTicks(valM+1);
	slider_RGB.setLimits(0, 0, valM);

	valM=		settingsVals.get("action").value_M;
	slider_action.setNbrTicks(valM+1);
	slider_action.setLimits(0, 0, valM);

	label_SerialSpeed.setText(Integer.toString(serialSpeed));


	
  modeChanged(); //draw initial val

setupValues();

 for (int i=0; i<10; i++) {
 	slots_s[i]= new GButton(this, 20+45*i, 510, 30, 30);
 	slots_s[i].setLocalColorScheme(GCScheme.PURPLE_SCHEME);
    slots_s[i].addEventHandler(this, "slots_click");

 	slots[i]= new GButton(this, 20+45*i, 550, 30, 30);
 	slots[i].setText(Integer.toString(i));
    slots[i].setLocalColorScheme(GCScheme.GREEN_SCHEME);
    slots[i].addEventHandler(this, "slots_click");
 }
}

void serialEvent(Serial cPort){
  String comPortString = cPort.readStringUntil('\n');
  if(comPortString != null) {
    comPortString=trim(comPortString);
    
    if(bDebugPrint)
    {
     println(comPortString);
 	}
     String[] parts = comPortString.split(" ");
	if(parts.length==4)
	{
		bSkipEvent=true;
		settingsVals.get("effN").valueSlider.setValue(Integer.parseInt(parts[0])); //! not upd if slider move over 0..9 slots or set some marker
		settingsVals.get("speed").valueSlider.setValue(Integer.parseInt(parts[1]));
		settingsVals.get("length").valueSlider.setValue(Integer.parseInt(parts[2]));
		settingsVals.get("RGB").valueSlider.setValue(Integer.parseInt(parts[3]));
		bSkipEvent_off_t=millis()+20; //! test lower or different approach
	}
  }
}



public void draw(){
	if(bSkipEvent && millis()>bSkipEvent_off_t) bSkipEvent=false;


  background(200);

	fill(rCh?255:0, gCh?255:0, bCh?255:0); 
	if(rCh)	ellipse(496, 405, 8, 8);
	if(gCh)	ellipse(526, 405, 8, 8);
	if(bCh)	ellipse(556, 405, 8, 8);

  
  if( Serial.list().length<1)
  {
    text("plug USB or update driver",10,10);
    myPort=null;
    button_disconnect.setText("Connect");
    delay(50); return; 
  }

  
  if(myPort==null && bConnected==1)
  {
  	try{
    myPort = new Serial(this, Serial.list()[0], serialSpeed); 
    }catch(Exception e){    	button_disconnect.setText("err");    }

	if(myPort!=null) 
	{
		if(bSetBrightnessAtConnect)		settingsVals.get("bright").setValue(25);
		bConnected=2;
		button_disconnect.setText("Disonnect");
	}
  }
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){

}