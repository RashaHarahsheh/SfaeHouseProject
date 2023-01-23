#line 1 "C:/Users/user1/Desktop/SafeHouseCode/FinalCode.c"
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
 if(INTCON&0x04){
 TMR0=248;
 Mcntr++;
 Dcntr++;
 if(Dcntr==500){
 Dcntr=0;

 }
 INTCON = INTCON & 0xFB;
 }



if(PIR1&0x04){
 if(HL){
 CCPR1H= angle >>8;

 CCPR1L= angle;

 HL=0;
 CCP1CON=0x09;
 TMR1H=0;
 TMR1L=0;
 }
 else{
 CCPR1H= (40000 - angle) >>8;

 CCPR1L= (40000 - angle);
 CCP1CON=0x08;
 HL=1;
 TMR1H=0;
 TMR1L=0;

 }
 PIR1=PIR1&0xFB;
 }
 if(PIR1&0x01){


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

 if(PORTB==0xD0){
 PORTC=PORTC|0x10;
 if(xs1==0){
 angle=4800;

 xs1++;
 }
 }


if(PORTB==0xC0){
 PORTC=0x10;
 }


if(PORTB==0xF0){
 angle=4800;

 PORTC=PORTC|0x11;

 INTCON=INTCON&0xFE;
 }
 }


 }







 void ATD_init(void){
 ADCON0 = 0x41;
 ADCON1 = 0xC4;
 TRISA = 0xFF; }






unsigned int ATD_read(void){
 ADCON0 = ADCON0 | 0x04;
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
 OPTION_REG = 0x87;
 TRISB = 0xFF;
 PORTB = 0xF0;
 TRISC = 0x00;
 PORTC = 0x00;
 HL=1;
 TMR1H=0;
 TMR1L=0;
 CCP1CON=0x08;
 T1CON=0x01;
 INTCON=0xF8;
 PIE1=PIE1|0x04;
 CCPR1H=2000>>8;
 CCPR1L=2000;
 angle=900;
 ATD_init();



 while (1){



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
