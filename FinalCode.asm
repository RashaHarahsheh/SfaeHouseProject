
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;FinalCode.c,14 :: 		void interrupt(void){
;FinalCode.c,15 :: 		if(INTCON&0X02){
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt0
;FinalCode.c,16 :: 		angle=900;
	MOVLW      132
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;FinalCode.c,18 :: 		INTCON=INTCON&0xFD;
	MOVLW      253
	ANDWF      INTCON+0, 1
;FinalCode.c,20 :: 		INTCON=INTCON|0x01;
	BSF        INTCON+0, 0
;FinalCode.c,22 :: 		}
L_interrupt0:
;FinalCode.c,23 :: 		if(INTCON&0x04){// will get here every 1ms
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt1
;FinalCode.c,24 :: 		TMR0=248;
	MOVLW      248
	MOVWF      TMR0+0
;FinalCode.c,25 :: 		Mcntr++;
	INCF       _Mcntr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _Mcntr+1, 1
;FinalCode.c,26 :: 		Dcntr++;
	INCF       _Dcntr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _Dcntr+1, 1
;FinalCode.c,27 :: 		if(Dcntr==500){//after 500 ms
	MOVF       _Dcntr+1, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt25
	MOVLW      244
	XORWF      _Dcntr+0, 0
L__interrupt25:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt2
;FinalCode.c,28 :: 		Dcntr=0;
	CLRF       _Dcntr+0
	CLRF       _Dcntr+1
;FinalCode.c,30 :: 		}
L_interrupt2:
;FinalCode.c,31 :: 		INTCON = INTCON & 0xFB; //clear T0IF
	MOVLW      251
	ANDWF      INTCON+0, 1
;FinalCode.c,32 :: 		}
L_interrupt1:
;FinalCode.c,36 :: 		if(PIR1&0x04){//CCP1 interrupt
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt3
;FinalCode.c,37 :: 		if(HL){ //high
	MOVF       _HL+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt4
;FinalCode.c,38 :: 		CCPR1H= angle >>8;
	MOVF       _angle+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;FinalCode.c,40 :: 		CCPR1L= angle;
	MOVF       _angle+0, 0
	MOVWF      CCPR1L+0
;FinalCode.c,42 :: 		HL=0;//next time low
	CLRF       _HL+0
;FinalCode.c,43 :: 		CCP1CON=0x09;//next time Falling edge
	MOVLW      9
	MOVWF      CCP1CON+0
;FinalCode.c,44 :: 		TMR1H=0;
	CLRF       TMR1H+0
;FinalCode.c,45 :: 		TMR1L=0;
	CLRF       TMR1L+0
;FinalCode.c,46 :: 		}
	GOTO       L_interrupt5
L_interrupt4:
;FinalCode.c,48 :: 		CCPR1H= (40000 - angle) >>8;
	MOVF       _angle+0, 0
	SUBLW      64
	MOVWF      R3+0
	MOVF       _angle+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      156
	MOVWF      R3+1
	MOVF       R3+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      CCPR1H+0
;FinalCode.c,50 :: 		CCPR1L= (40000 - angle);
	MOVF       R3+0, 0
	MOVWF      CCPR1L+0
;FinalCode.c,51 :: 		CCP1CON=0x08; //next time rising edge
	MOVLW      8
	MOVWF      CCP1CON+0
;FinalCode.c,52 :: 		HL=1; //next time High
	MOVLW      1
	MOVWF      _HL+0
;FinalCode.c,53 :: 		TMR1H=0;
	CLRF       TMR1H+0
;FinalCode.c,54 :: 		TMR1L=0;
	CLRF       TMR1L+0
;FinalCode.c,56 :: 		}
L_interrupt5:
;FinalCode.c,57 :: 		PIR1=PIR1&0xFB;
	MOVLW      251
	ANDWF      PIR1+0, 1
;FinalCode.c,58 :: 		}
L_interrupt3:
;FinalCode.c,59 :: 		if(PIR1&0x01){//TMR1 ovwerflow
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt6
;FinalCode.c,62 :: 		PIR1=PIR1&0xFE;
	MOVLW      254
	ANDWF      PIR1+0, 1
;FinalCode.c,63 :: 		}
L_interrupt6:
;FinalCode.c,65 :: 		if (INTCON&0x01){
	BTFSS      INTCON+0, 0
	GOTO       L_interrupt7
;FinalCode.c,68 :: 		if (PORTB==0xE0){
	MOVF       PORTB+0, 0
	XORLW      224
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt8
;FinalCode.c,69 :: 		PORTC = PORTC & 0xEE;
	MOVLW      238
	ANDWF      PORTC+0, 1
;FinalCode.c,70 :: 		if(xs==0){
	MOVLW      0
	XORWF      _xs+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt26
	MOVLW      0
	XORWF      _xs+0, 0
L__interrupt26:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt9
;FinalCode.c,72 :: 		xs++;
	INCF       _xs+0, 1
	BTFSC      STATUS+0, 2
	INCF       _xs+1, 1
;FinalCode.c,73 :: 		angle=4800;
	MOVLW      192
	MOVWF      _angle+0
	MOVLW      18
	MOVWF      _angle+1
;FinalCode.c,76 :: 		}
L_interrupt9:
;FinalCode.c,77 :: 		}
L_interrupt8:
;FinalCode.c,79 :: 		if(PORTB==0xD0){//buzzer alone
	MOVF       PORTB+0, 0
	XORLW      208
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt10
;FinalCode.c,80 :: 		PORTC=PORTC|0x10;
	BSF        PORTC+0, 4
;FinalCode.c,81 :: 		if(xs1==0){
	MOVLW      0
	XORWF      _xs1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt27
	MOVLW      0
	XORWF      _xs1+0, 0
L__interrupt27:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt11
;FinalCode.c,82 :: 		angle=4800;
	MOVLW      192
	MOVWF      _angle+0
	MOVLW      18
	MOVWF      _angle+1
;FinalCode.c,84 :: 		xs1++;
	INCF       _xs1+0, 1
	BTFSC      STATUS+0, 2
	INCF       _xs1+1, 1
;FinalCode.c,85 :: 		}
L_interrupt11:
;FinalCode.c,86 :: 		}
L_interrupt10:
;FinalCode.c,89 :: 		if(PORTB==0xC0){
	MOVF       PORTB+0, 0
	XORLW      192
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt12
;FinalCode.c,90 :: 		PORTC=0x10; //buzzer while flame
	MOVLW      16
	MOVWF      PORTC+0
;FinalCode.c,91 :: 		}
L_interrupt12:
;FinalCode.c,94 :: 		if(PORTB==0xF0){
	MOVF       PORTB+0, 0
	XORLW      240
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt13
;FinalCode.c,95 :: 		angle=4800;
	MOVLW      192
	MOVWF      _angle+0
	MOVLW      18
	MOVWF      _angle+1
;FinalCode.c,97 :: 		PORTC=PORTC|0x11;
	MOVLW      17
	IORWF      PORTC+0, 1
;FinalCode.c,99 :: 		INTCON=INTCON&0xFE;
	MOVLW      254
	ANDWF      INTCON+0, 1
;FinalCode.c,100 :: 		}
L_interrupt13:
;FinalCode.c,101 :: 		}
L_interrupt7:
;FinalCode.c,104 :: 		}
L_end_interrupt:
L__interrupt24:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_ATD_init:

;FinalCode.c,112 :: 		void ATD_init(void){
;FinalCode.c,113 :: 		ADCON0 = 0x41;// ATD ON, Don't GO, CHannel 0, Fosc/16
	MOVLW      65
	MOVWF      ADCON0+0
;FinalCode.c,114 :: 		ADCON1 = 0xC4;// RA0 analogue , 500 KHz, right justified
	MOVLW      196
	MOVWF      ADCON1+0
;FinalCode.c,115 :: 		TRISA =  0xFF; }
	MOVLW      255
	MOVWF      TRISA+0
L_end_ATD_init:
	RETURN
; end of _ATD_init

_ATD_read:

;FinalCode.c,122 :: 		unsigned int ATD_read(void){
;FinalCode.c,123 :: 		ADCON0 = ADCON0 | 0x04; // GO
	BSF        ADCON0+0, 2
;FinalCode.c,124 :: 		while(ADCON0 & 0x04);
L_ATD_read14:
	BTFSS      ADCON0+0, 2
	GOTO       L_ATD_read15
	GOTO       L_ATD_read14
L_ATD_read15:
;FinalCode.c,125 :: 		return(ADRESH<<8) | ADRESL;
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;FinalCode.c,126 :: 		}
L_end_ATD_read:
	RETURN
; end of _ATD_read

_Delay:

;FinalCode.c,127 :: 		void Delay(unsigned int x){
;FinalCode.c,128 :: 		Mcntr=0;
	CLRF       _Mcntr+0
	CLRF       _Mcntr+1
;FinalCode.c,129 :: 		while(Mcntr<x);
L_Delay16:
	MOVF       FARG_Delay_x+1, 0
	SUBWF      _Mcntr+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Delay31
	MOVF       FARG_Delay_x+0, 0
	SUBWF      _Mcntr+0, 0
L__Delay31:
	BTFSC      STATUS+0, 0
	GOTO       L_Delay17
	GOTO       L_Delay16
L_Delay17:
;FinalCode.c,130 :: 		}
L_end_Delay:
	RETURN
; end of _Delay

_main:

;FinalCode.c,136 :: 		void main() {
;FinalCode.c,139 :: 		xs=0;
	CLRF       _xs+0
	CLRF       _xs+1
;FinalCode.c,140 :: 		xs1=0;
	CLRF       _xs1+0
	CLRF       _xs1+1
;FinalCode.c,141 :: 		TMR0=248;
	MOVLW      248
	MOVWF      TMR0+0
;FinalCode.c,142 :: 		OPTION_REG = 0x87;//Fosc/4 with 256 prescaler => incremetn every 0.5us*256=128us ==> overflow 8count*128us=1ms to overflow
	MOVLW      135
	MOVWF      OPTION_REG+0
;FinalCode.c,143 :: 		TRISB = 0xFF; //first 4 bits in port B inputs
	MOVLW      255
	MOVWF      TRISB+0
;FinalCode.c,144 :: 		PORTB = 0xF0; //All bits initialy 0 - however input pins will not be effected                    //bit-0 -> switch button, bit-1 -> flame sensor, bit-2 ->tempreture sensor, bit-3 ->smoke detector
	MOVLW      240
	MOVWF      PORTB+0
;FinalCode.c,145 :: 		TRISC = 0x00; // all port c are outputs , bit-0 -> srvomotor , bit-1 ->DC motor for the fan, bit-2 ->LED
	CLRF       TRISC+0
;FinalCode.c,146 :: 		PORTC = 0x00; // All output initialy is 0
	CLRF       PORTC+0
;FinalCode.c,147 :: 		HL=1; //start high
	MOVLW      1
	MOVWF      _HL+0
;FinalCode.c,148 :: 		TMR1H=0;
	CLRF       TMR1H+0
;FinalCode.c,149 :: 		TMR1L=0;
	CLRF       TMR1L+0
;FinalCode.c,150 :: 		CCP1CON=0x08;
	MOVLW      8
	MOVWF      CCP1CON+0
;FinalCode.c,151 :: 		T1CON=0x01;//TMR1 On Fosc/4 (inc 0.5uS) with 0 prescaler (TMR1 overflow after 0xFFFF counts ==65535)==> 32.767ms
	MOVLW      1
	MOVWF      T1CON+0
;FinalCode.c,152 :: 		INTCON=0xF8;//enable TMR0 overflow, TMR1 overflow, External interrupts and peripheral interrupts;
	MOVLW      248
	MOVWF      INTCON+0
;FinalCode.c,153 :: 		PIE1=PIE1|0x04;// Enable CCP1 interrupts
	BSF        PIE1+0, 2
;FinalCode.c,154 :: 		CCPR1H=2000>>8;
	MOVLW      7
	MOVWF      CCPR1H+0
;FinalCode.c,155 :: 		CCPR1L=2000;
	MOVLW      208
	MOVWF      CCPR1L+0
;FinalCode.c,156 :: 		angle=900; //600us initially == 1200*0.5=60
	MOVLW      132
	MOVWF      _angle+0
	MOVLW      3
	MOVWF      _angle+1
;FinalCode.c,157 :: 		ATD_init();
	CALL       _ATD_init+0
;FinalCode.c,161 :: 		while (1){
L_main18:
;FinalCode.c,165 :: 		myreading = ATD_read();
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _myreading+0
	MOVF       R0+1, 0
	MOVWF      _myreading+1
;FinalCode.c,166 :: 		Delay(100);
	MOVLW      100
	MOVWF      FARG_Delay_x+0
	MOVLW      0
	MOVWF      FARG_Delay_x+1
	CALL       _Delay+0
;FinalCode.c,167 :: 		temp = (myreading*4.88)/10;
	MOVF       _myreading+0, 0
	MOVWF      R0+0
	MOVF       _myreading+1, 0
	MOVWF      R0+1
	CALL       _word2double+0
	MOVLW      246
	MOVWF      R4+0
	MOVLW      40
	MOVWF      R4+1
	MOVLW      28
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _double2word+0
	MOVF       R0+0, 0
	MOVWF      _temp+0
	MOVF       R0+1, 0
	MOVWF      _temp+1
;FinalCode.c,168 :: 		Delay(100);
	MOVLW      100
	MOVWF      FARG_Delay_x+0
	MOVLW      0
	MOVWF      FARG_Delay_x+1
	CALL       _Delay+0
;FinalCode.c,171 :: 		if(temp >20.0)
	MOVF       _temp+0, 0
	MOVWF      R0+0
	MOVF       _temp+1, 0
	MOVWF      R0+1
	CALL       _word2double+0
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      32
	MOVWF      R0+2
	MOVLW      131
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main20
;FinalCode.c,173 :: 		Delay(10);
	MOVLW      10
	MOVWF      FARG_Delay_x+0
	MOVLW      0
	MOVWF      FARG_Delay_x+1
	CALL       _Delay+0
;FinalCode.c,174 :: 		PORTC =0x01;
	MOVLW      1
	MOVWF      PORTC+0
;FinalCode.c,175 :: 		myreading = ATD_read();
	CALL       _ATD_read+0
	MOVF       R0+0, 0
	MOVWF      _myreading+0
	MOVF       R0+1, 0
	MOVWF      _myreading+1
;FinalCode.c,176 :: 		delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main21:
	DECFSZ     R13+0, 1
	GOTO       L_main21
	DECFSZ     R12+0, 1
	GOTO       L_main21
	DECFSZ     R11+0, 1
	GOTO       L_main21
	NOP
;FinalCode.c,177 :: 		temp = (myreading*4.88)/10;
	MOVF       _myreading+0, 0
	MOVWF      R0+0
	MOVF       _myreading+1, 0
	MOVWF      R0+1
	CALL       _word2double+0
	MOVLW      246
	MOVWF      R4+0
	MOVLW      40
	MOVWF      R4+1
	MOVLW      28
	MOVWF      R4+2
	MOVLW      129
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      130
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _double2word+0
	MOVF       R0+0, 0
	MOVWF      _temp+0
	MOVF       R0+1, 0
	MOVWF      _temp+1
;FinalCode.c,179 :: 		Delay(100);
	MOVLW      100
	MOVWF      FARG_Delay_x+0
	MOVLW      0
	MOVWF      FARG_Delay_x+1
	CALL       _Delay+0
;FinalCode.c,180 :: 		}
	GOTO       L_main22
L_main20:
;FinalCode.c,183 :: 		PORTC =0x00;
	CLRF       PORTC+0
;FinalCode.c,184 :: 		}
L_main22:
;FinalCode.c,191 :: 		}
	GOTO       L_main18
;FinalCode.c,192 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
