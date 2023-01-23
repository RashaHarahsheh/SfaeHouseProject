void ATD_init(void);
unsigned int ATD_read();
void Delay(unsigned int x);
unsigned int myreading;
unsigned int Myvoltage;
unsigned int temp;
unsigned char HL;
unsigned int cntr;
unsigned int angle;
unsigned int Dcntr;
unsigned int Mcntr;
unsigned int xs;
unsigned int xs1;
void interrupt(void){
if(INTCON&0X02){
    angle=900;

    INTCON=INTCON&0xFD;

    INTCON=INTCON|0x01;

  }
  if(INTCON&0x04){// will get here every 1ms
    TMR0=248;
    Mcntr++;
    Dcntr++;
    if(Dcntr==500){//after 500 ms
      Dcntr=0;

    }
  INTCON = INTCON & 0xFB; //clear T0IF
  }



if(PIR1&0x04){//CCP1 interrupt
   if(HL){ //high
     CCPR1H= angle >>8;

     CCPR1L= angle;

     HL=0;//next time low
     CCP1CON=0x09;//next time Falling edge
     TMR1H=0;
     TMR1L=0;
   }
   else{  //low
     CCPR1H= (40000 - angle) >>8;

     CCPR1L= (40000 - angle);
     CCP1CON=0x08; //next time rising edge
     HL=1; //next time High
     TMR1H=0;
     TMR1L=0;

   }
   PIR1=PIR1&0xFB;
 }
 if(PIR1&0x01){//TMR1 ovwerflow


   PIR1=PIR1&0xFE;
 }

if (INTCON&0x01){


if (PORTB==0xE0){
PORTC = PORTC & 0xEE;
    if(xs==0){

    xs++;
    angle=4800;


    }
     }

    if(PORTB==0xD0){//buzzer alone
    PORTC=PORTC|0x10;
        if(xs1==0){
        angle=4800;

        xs1++;
     }
     }


if(PORTB==0xC0){
     PORTC=0x10; //buzzer while flame
    }


if(PORTB==0xF0){
     angle=4800;

     PORTC=PORTC|0x11;

      INTCON=INTCON&0xFE;
     }
    }


 }







  void ATD_init(void){
 ADCON0 = 0x41;// ATD ON, Don't GO, CHannel 0, Fosc/16
 ADCON1 = 0xC4;// RA0 analogue , 500 KHz, right justified
 TRISA =  0xFF; }






unsigned int ATD_read(void){
  ADCON0 = ADCON0 | 0x04; // GO
  while(ADCON0 & 0x04);
  return(ADRESH<<8) | ADRESL;
  }
  void Delay(unsigned int x){
     Mcntr=0;
     while(Mcntr<x);
}





void main() {


    xs=0;
    xs1=0;
    TMR0=248;
    OPTION_REG = 0x87;//Fosc/4 with 256 prescaler => incremetn every 0.5us*256=128us ==> overflow 8count*128us=1ms to overflow
    TRISB = 0xFF; //first 4 bits in port B inputs
    PORTB = 0xF0; //All bits initialy 0 - however input pins will not be effected                    //bit-0 -> switch button, bit-1 -> flame sensor, bit-2 ->tempreture sensor, bit-3 ->smoke detector
    TRISC = 0x00; // all port c are outputs , bit-0 -> srvomotor , bit-1 ->DC motor for the fan, bit-2 ->LED
    PORTC = 0x00; // All output initialy is 0
    HL=1; //start high
    TMR1H=0;
    TMR1L=0;
    CCP1CON=0x08;
    T1CON=0x01;//TMR1 On Fosc/4 (inc 0.5uS) with 0 prescaler (TMR1 overflow after 0xFFFF counts ==65535)==> 32.767ms
    INTCON=0xF8;//enable TMR0 overflow, TMR1 overflow, External interrupts and peripheral interrupts;
    PIE1=PIE1|0x04;// Enable CCP1 interrupts
    CCPR1H=2000>>8;
    CCPR1L=2000;
    angle=900; //600us initially == 1200*0.5=60
    ATD_init();



    while (1){
    //to read


    myreading = ATD_read();
     Delay(100);
    temp = (myreading*4.88)/10;
      Delay(100);


    if(temp >20.0)
    {
    Delay(10);
    PORTC =0x01;
    myreading = ATD_read();
    delay_ms(100);
    temp = (myreading*4.88)/10;

      Delay(100);
    }
    else
    {
    PORTC =0x00;
    }






}
}