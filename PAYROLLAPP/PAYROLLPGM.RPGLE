000100160330     FSHIFTRATESIF   E             DISK    RENAME(SHIFTRATES:SHIFTRATER)
000101160330     FALLSHIFT  IF   E           K DISK    RENAME(ALLSHIFT:ALLSHIFTR)
000102160330     FCONFIRMPAYCF   E             WORKSTN
000103160330     FPAYRPT    O    E             PRINTER OFLIND(*IN01)
000104160330     DHOURSOVER        S              3  0
000105160330     F/FREE
000106160330                READ SHIFTRATES;
000107160330                WRITE TITLE;
000108160330                WRITE COLHDG;
000109160330                READ ALLSHIFT;
000110160330                DOW NOT %EOF;
000111160330                  EXSR PAYSR;
000112160330                  IF *IN01;
000113160330                          WRITE TITLE;
000114160330                          WRITE COLHDG;
000115160330                          *IN01 = *OFF;
000116160330                  ENDIF;
000117160330                  WRITE EMPDETAIL;
000118160330                 READ ALLSHIFT;
000119160330                ENDDO;
000120160330                 TOTEMPPAY = TOTREGPAY + TOTOVTPAY;
000121160330                 WRITE TOTALS;
000122160330
000123160330                 DAYR=DAYRATE;
000124160330                 AFTERR=AFTNRATE;
000125160330                 NIGHTR=NIGHTRATE;
000126160330                 REGPAY=TOTREGPAY;
000127160330                 OVTPAY=TOTOVTPAY;
000128160330                 COMPAY=TOTEMPPAY;
000129160330
000130160330              EXFMT RECORD1;
000131160330              *INLR = *ON;
000132160330              RETURN;
000133160330              BEGSR PAYSR;
000134160330                         SELECT;
000135160330                           WHEN WORKSHIFT = 'D';
000136160330                             HOURLYRATE = DAYRATE;
000137160330                           WHEN WORKSHIFT = 'N';
000138160330                             HOURLYRATE = NIGHTRATE;
000139160330                           WHEN WORKSHIFT = 'A';
000140160330                             HOURLYRATE = AFTNRATE;
000141160330                         ENDSL;
000142160330
000143160330                         SELECT;
000144160330                           WHEN PAYGRADE = '1';
000145160330                             EVAL(H) HOURLYRATE = HOURLYRATE*1.073;
000146160330                           WHEN PAYGRADE = '2';
000147160330                             EVAL(H) HOURLYRATE = HOURLYRATE*1.054;
000148160330                           WHEN PAYGRADE = '3';
000149160330                             EVAL(H) HOURLYRATE = HOURLYRATE-(HOURLYRATE*0.045);
000151160330                          ENDSL;
000152160330                         IF HRSWORKED >= 41;
000153160330                           EVAL(H) REGULARPAY=40*HOURLYRATE;
000154160330                           EVAL(H) OVERPAY=(HRSWORKED-40)*(HOURLYRATE*1.5);
000155160330                         ENDIF;
000156160330                         IF HRSWORKED <= 40;
000157160330                           EVAL(H) REGULARPAY=HRSWORKED*HOURLYRATE;
000158160330                           OVERPAY=0;
000159160330                         ENDIF;
000160160330                         TOTALPAY=REGULARPAY+OVERPAY;
000161160330                         TOTREGPAY=TOTREGPAY+REGULARPAY;
000162160330                         TOTOVTPAY=TOTOVTPAY+OVERPAY;
000163160330              ENDSR;
000164160330
