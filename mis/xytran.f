      SUBROUTINE XYTRAN        
C        
      IMPLICIT INTEGER (A-Z)        
      LOGICAL         VGP,RANDOM,OUTOPN,PRINT,PLOT,PAPLOT,OOMPP,OOMCP,  
     1                PUNCH        
      INTEGER         WORD(58),NAMEV(11),FILES(11),SUBCAS(200),        
     1                NAME(2),MAJID(11),ROUTIN(2),HEADSV(96),        
     2                XYCARD(20),OPENF(5),INDB(5)        
      REAL            TEMP,TEMP1,RBUF(100),RZ(1),VALUE(60)        
      CHARACTER       UFM*23,UWM*25        
      COMMON /XMSSG / UFM,UWM        
      COMMON /BLANK / BLKCOM,IDUM1,IPSET,IPSET2,NFRAME,NCARD        
      COMMON /SYSTEM/ SYSBUF,L,NOGO,NIN,KSYSTM(81),INTR        
      COMMON /OUTPUT/ IHEAD(96)        
CZZ   COMMON /ZZXYTR/ Z(1)        
      COMMON /ZZZZZZ/ Z(1)        
      COMMON /XYWORK/ FILE,TCURVE(32),NTOPS,PRINT,IFILE,XAXIS(32),      
     1                NBOTS,PLOT,VECTOR,YAXIS(32),VECID(5),PUNCH,       
     2                MAJOR,YTAXIS(32),SUBC(5),CENTER,RANDOM,YBAXIS(32),
     3                IDIN(153),BUF(100),IVALUE(60),IAT,IDOUT(300),     
     4                OUTOPN,STEPS,NAT,PAPLOT,KNT        
      EQUIVALENCE     (Z(1),RZ(1)),(BUF(1),RBUF(1)),(IVALUE(1),VALUE(1))
C        
      DATA    STOP  / 4HSTOP /, GO    / 4HGO   /, VDUM  / 4HVDUM /,     
     1        XY    / 4HXY   /, FRAM  / 4HFRAM /, CLEA  / 4HCLEA /,     
     2        TCUR  / 4HTCUR /, XAXI  / 4HXTIT /, YAXI  / 4HYTIT /,     
     3        YTAX  / 4HYTTI /, YBAX  / 4HYBTI /, BLANK / 4H     /,     
     4        PSET  / 4HPSET /        
C        
      DATA    EOR   / 1  /, NOEOR /0  /, OUTRWD/1/, INPRWD/0/, REWD/1/  
      DATA    XYCDB / 101/, OUTFIL/201/, INDB  / 102,103,104,105,106 /  
      DATA    NWORDS/ 58 /, ROUTIN/4HXYTR, 4HAN  /, RAND  / 4HRAND   /  
      DATA    VG    / 4HVG  /, I3 / 3 /        
C        
      DATA    WORD  /        
     1        4HXMIN, 4HXMAX, 4HYMIN, 4HYMAX, 4HYTMI, 4HYTMA, 4HYBMI,   
     8        4HYBMA, 4HXINT, 4HYINT, 4HYTIN, 4HYBIN, 4HXAXI, 4HYAXI,   
     5        4HXTAX, 4HXBAX, 4HXDIV, 4HYDIV, 4HYTDI, 4HYBDI, 4HXVAL,   
     2        4HYVAL, 4HYTVA, 4HYBVA, 4HUPPE, 4HLOWE, 4HLEFT, 4HRIGH,   
     9        4HTLEF, 4HTRIG, 4HBLEF, 4HBRIG, 4HALLE, 4HTALL, 4HBALL,   
     6        4HXLOG, 4HYLOG, 4HYTLO, 4HYBLO, 4HCURV, 4HDENS, 4H....,   
     3        4H...., 4H...., 4HSKIP, 4HCAME, 4HPLOT, 4HXPAP, 4HYPAP,   
     O        4HPENS, 4HXGRI, 4HYGRI, 4HXTGR, 4HYTGR, 4HXBGR, 4HYBGR,   
     7        4HCSCA, 4HCOLO/        
C        
C     DATA FOR THE 11 VECTOR TYPES POSSIBLE        
C        
C                                                         BASIC        
C              VECTOR-NAME         RESIDENT-FILE       MAJOR - ID       
C          ******************     ***************   ****************    
      DATA NAMEV( 1) / 4HDISP /,  FILES( 1) / 3 /,  MAJID( 1) /  1 /    
      DATA NAMEV( 2) / 4HVELO /,  FILES( 2) / 3 /,  MAJID( 2) / 10 /    
      DATA NAMEV( 3) / 4HACCE /,  FILES( 3) / 3 /,  MAJID( 3) / 11 /    
      DATA NAMEV( 4) / 4HSPCF /,  FILES( 4) / 2 /,  MAJID( 4) /  3 /    
      DATA NAMEV( 5) / 4HLOAD /,  FILES( 5) / 1 /,  MAJID( 5) /  2 /    
      DATA NAMEV( 6) / 4HSTRE /,  FILES( 6) / 4 /,  MAJID( 6) /  5 /    
      DATA NAMEV( 7) / 4HFORC /,  FILES( 7) / 5 /,  MAJID( 7) /  4 /    
      DATA NAMEV( 8) / 4HSDIS /,  FILES( 8) / 1 /,  MAJID( 8) / 15 /    
      DATA NAMEV( 9) / 4HSVEL /,  FILES( 9) / 1 /,  MAJID( 9) / 16 /    
      DATA NAMEV(10) / 4HSACC /,  FILES(10) / 1 /,  MAJID(10) / 17 /    
      DATA NAMEV(11) / 4HNONL /,  FILES(11) / 2 /,  MAJID(11) / 12 /    
      DATA NAMEVG    / 4H VG  /        
C        
C     - IDOUT DATA RECORD DISCRIPTION -        
C        
C     WORD    TYPE   DISCRIPTION        
C     ==================================================================
C       1     I/R    SUBCASE ID OR IF RANDOM THE MEAN RESPONSE        
C       2      I     FRAME NUMBER        
C       3      I     CURVE NUMBER        
C       4      I     POINT-ID OR ELEMENT-ID        
C       5      I     COMPONENT NUMBER        
C       6      I     VECTOR NUMBER  1 THRU 11        
C        
C       7      I     1 -- CURVE USES TOP HALF OF FRAME        
C                    0 -- CURVE USES FULL FRAME        
C                   -1 -- CURVE USES LOWER HALF OF FRAME        
C        
C       8      I     0 -- AXIS,TICS,LABELS,VALUES, ETC. HAVE BEEN DRAWN 
C                         AND THIS CURVE IS TO BE SCALED AND PLOTTED    
C                         IDENTICALLY AS LAST EXCEPT FOR CURVE SYMBOLS. 
C                    1 -- AXIS, TICS, LABELS, SCALEING, ETC. ARE TO BE  
C                         PERFORMED OR COMPUTED AND IF IDOUT(7)=0 OR 1  
C                         A SKIP TO NEW FRAME IS TO BE MADE.        
C        
C       9      I     NUMBER OF BLANK FRAMES BETWEEN FRAMES (FRAME-SKIP) 
C      10      R     MINIMUM X-INCREMENT        
C      11      R     XMIN  *        
C      12      R     XMAX   *   DEFINES ACTUAL LIMITS OF DATA OF THIS   
C      13      R     YMIN   *   UPPER, LOWER, OR FULL FRAME CURVE.      
C      14      R     YMAX  *        
C      15      R     ACTUAL VALUE OF FIRST TIC                 *        
C      16      R     ACTUAL INCREMENT TO SUCCESSIVE TICS        *       
C      17      I     ACTUAL MAXIMUM VALUE OF FRAME               *  X-  
C      18      I     MAXIMUM NUMBER OF DIGITS IN ANY PRINT-VALUE  * DIRE
C      19      I     + OR - POWER FOR PRINT VALUES                * TICS
C      20      I     TOTAL NUMBER OF TICS TO PRINT THIS EDGE     *      
C      21      I     VALUE PRINT SKIP  0,1,2,3---               *       
C      22      I     SPARE                                     *        
C      23      R     *        
C      24      R      *        
C      25      I       *        
C      26      I        *  SAME AS  15 THRU 22        
C      27      I        *  BUT FOR  Y-DIRECTION TICS        
C      28      I       *        
C      29      I      *        
C      30      I     *        
C      31      I     TOP EDGE TICS   **   EACH OF 31 THRU 34 MAY BE     
C      32      I     BOTTOM EDGE TICS **  LESS THAN 0 -- TICS W/O VALUES
C      33      I     LEFT EDGE TICS   **  EQUAL TO  0 -- NO TICS HERE   
C      34      I     RIGHT EDGE TICS **   GREATER   0 -- TICS W VALUES  
C        
C      35      I     0 -- X-DIRECTION IS LINEAR        
C                    GREATER THAN 0 - NUMBR OF CYCLES AND X-DIREC IS LOG
C      36      I     0 -- Y-DIRECTION IS LINEAR        
C                    GREATER THAN 0 - NUMBR OF CYCLES AND Y-DIREC IS LOG
C      37      I     0 -- NO X-AXIS        
C                    1 -- DRAW X-AXIS        
C        
C      38      R     X-AXIS  Y-INTERCEPT        
C        
C      39      I     0 -- NO Y-AXIS        
C                    1 -- DRAW Y-AXIS        
C        
C      40      R     Y-AXIS  X-INTERCEPT        
C        
C      41      I     LESS THAN 0 ----- PLOT SYMBOL FOR EACH CURVE POINT.
C                                      SELECT SYMBOL CORRESPONDING TO   
C                                      CURVE NUMBER IN IDOUT(3)        
C                    EQUAL TO  0 ----- CONNECT POINTS BY LINES WHERE    
C                                      POINTS ARE CONTINUOUS I.E.(NO    
C                                      INTEGER 1 PAIRS)        
C                    GREATER THAN 0 -- DO BOTH OF ABOVE        
C        
C      42        
C       .        
C       .        
C      50        
C      51     BCD    TITLE(32)        
C       .     BCD    SUBTITLE(32)        
C       .     BCD    LABEL(32)        
C       .     BCD    CURVE TITLE(32)        
C       .     BCD    X-AXIS TITLE(32)        
C     242     BCD    Y-AXIS TITLE(32)        
C     243      I     XGRID LINES   0=NO   1=YES        
C     244      I     YGRID LINES   0=NO   1=YES        
C     245      I     TYPE OF PLOT  1=RESPONSE, 2=PSDF, 3=AUTO        
C     246      I     STEPS        
C       .        
C       .        
C     281      I     PAPLOT FRAME NUMBER        
C     282      R     CSCALE (REAL NUMBER)        
C     283      I     PENSIZE OR DENSITY        
C     284      I     PLOTTER (LSHIFT 16) AND MODEL NUMBER.        
C     285      R     INCHES PAPER X-DIRECTION        
C     286      R     INCHES PAPER Y-DIRECTION        
C     287      I     CAMERA FOR SC4020 LESS THAN 0=35MM, 0=F80,        
C                                        GREATER 0=BOTH        
C     288      I     PRINT FLAG  **        
C     289      I     PLOT  FLAG  ** 0=NO, +=YES (PLOT- 2=BOTH, -1=PAPLT)
C     290      I     PUNCH FLAG  **        
C     291      R     X-MIN OF ALL DATA        
C     292      R     X-MAX OF ALL DATA        
C     293      R     Y-MIN WITHIN X-LIMITS OF FRAME        
C     294      R     X-VALUE AT THIS Y-MIN        
C     295      R     Y-MAX WITHIN X-LIMITS OF FRAME        
C     296      R     X-VALUE AT THIS Y-MAX        
C     297      R     Y-MIN FOR ALL DATA        
C     298      R     X-VALUE AT THIS Y-MIN        
C     299      R     Y-MAX FOR ALL DATA        
C     300      R     X-VALUE AT THIS Y-MAX        
C     ==================================================================
C        
C     SAVE OUTPUT HEADING        
C        
      DO 10 I = 1,96        
   10 HEADSV(I) = IHEAD(I)        
C        
C     ALLOCATE CORE AND OPEN DATA BLOCKS        
C        
      OOMPP = .FALSE.        
      VGP   = .FALSE.        
      OOMCP = .FALSE.        
      RANDOM= .FALSE.        
      IFLE  = XYCDB        
      CORE  = KORSZ(Z) - 1        
      DO 20 I = 1,32        
      TCURVE(I) = BLANK        
      XAXIS(I)  = BLANK        
      YAXIS(I)  = BLANK        
      YTAXIS(I) = BLANK        
      YBAXIS(I) = BLANK        
   20 CONTINUE        
      DO 30 I = 1,5        
   30 SUBC(I) = 1        
      NSUBS  = 0        
      CORE   = CORE - SYSBUF        
      IF (CORE .LT. 0) GO TO 825        
      INTRWD = INPRWD        
      IF (INTR .LE. 0) GO TO 35        
      INTRWD = OUTRWD        
      XYCDB  = 301        
   35 CALL OPEN (*835,XYCDB,Z(CORE+1),INTRWD)        
      IF (INTR .LE. 0) GO TO 65        
      CARD = 1        
      WRITE (L,900)        
   40 DO 42 IJ = 1,20        
   42 XYCARD(IJ) = BLANK        
      CALL XREAD (*43,XYCARD)        
      IF (XYCARD(1) .EQ. STOP) GO TO 1500        
      IF (XYCARD(1) .EQ.   GO) CARD = -1        
      CALL IFP1XY (CARD,XYCARD)        
      IF (XYCARD(1) .EQ. GO) GO TO 50        
      CARD = 0        
      IF (NOGO .EQ. 0) GO TO 45        
      NOGO = 0        
   43 WRITE (L,902)        
   45 WRITE (L,910) XYCARD        
      GO TO 40        
   50 CALL CLOSE (XYCDB,REWD)        
      IF (INTR .GT. 10) L = 1        
      CALL OPEN (*835,XYCDB,Z(CORE+1),INPRWD)        
   65 IF (INTR .LE. 0) CALL FWDREC (*80,XYCDB)        
      OUTOPN = .FALSE.        
      IF (BLKCOM .EQ. RAND) RANDOM = .TRUE.        
      IF (BLKCOM .EQ.   VG) VGP = .TRUE.        
      IF (BLKCOM .EQ.   VG) NAMEV(5) = NAMEVG        
C        
      CORE = CORE - SYSBUF        
      DO 70 I = 1,5        
      OPENF(I) = -1        
      IF (CORE .LT. 0) GO TO 235        
C        
      CALL OPEN (*70,INDB(I),Z(CORE),INPRWD)        
      OPENF(I) = 0        
      VECID(I) = 0        
      CORE = CORE - SYSBUF        
   70 CONTINUE        
C        
      CORE = CORE + SYSBUF - 1        
C        
C     NOTE - OUTPUT DATA BLOCKS WILL BE OPENED WHEN AND IF REQUIRED     
C        
C        
C        
C     READ FIRST BCD WORD FROM -XYCDB- THEN GO INITIALIZE DATA        
C        
      BCD = CLEA        
      GO TO 800        
   80 IER = 2        
      GO TO 237        
   90 IER = 3        
      GO TO 237        
C        
C     BRANCH ON BCD WORD        
C        
  100 IF (BCD .EQ. XY  ) GO TO 230        
      IF (BCD .EQ. TCUR) GO TO 180        
      IF (BCD .EQ. XAXI) GO TO 190        
      IF (BCD .EQ. YAXI) GO TO 200        
      IF (BCD .EQ. YTAX) GO TO 210        
      IF (BCD .EQ. YBAX) GO TO 220        
C        
C     SET SINGLE VALUE FLAGS. READ IN VALUE        
C        
      IF (BCD .EQ. CLEA) GO TO 150        
      IF (BCD .EQ. VDUM) GO TO 820        
      CALL READ (*80,*90,XYCDB,IVAL,1,NOEOR,FLAG)        
      DO 110 I = 1,NWORDS        
      IF (BCD .EQ. WORD(I)) GO TO 130        
  110 CONTINUE        
C        
C     WORD NOT RECOGNIZED        
C        
      CALL PAGE2 (2)        
      WRITE (L,120) UWM,BCD        
      GO TO 140        
C        
C     KEY WORD FOUND        
C        
  130 IF (BCD .NE. WORD(58)) GO TO 135        
      IVALUE(I) = IVAL        
      CALL READ (*80,*90,XYCDB,IVAL,1,NOEOR,FLAG)        
      IVALUE(I+1) = IVAL        
      GO TO 140        
  135 IVALUE(I) = IVAL        
C        
C     READ NEXT BCD WORD        
C        
  140 CALL READ (*80,*240,XYCDB,BCD,1,NOEOR,FLAG)        
      GO TO 100        
C        
C     CLEAR ALL VALUES SET AND RESTORE DEFAULTS        
C        
  150 DO 160 I = 1,12        
  160 IVALUE(I) = 1        
      DO 170 I = 13,NWORDS        
      IF (I .NE. 47) IVALUE(I) = 0        
  170 CONTINUE        
      DO 171 I = 25,32        
  171 IVALUE(I) = 1        
C        
C     DEFAULT CAMERA TO BOTH        
C        
      IVALUE(46) = 3        
      GO TO 140        
C        
C     SET TITLES        
C        
  180 CALL READ (*80,*90,XYCDB,TCURVE(1),32,NOEOR,FLAG)        
      GO TO 140        
  190 CALL READ (*80,*90,XYCDB,XAXIS(1),32,NOEOR,FLAG)        
      GO TO 140        
  200 CALL READ (*80,*90,XYCDB,YAXIS(1),32,NOEOR,FLAG)        
      GO TO 140        
  210 CALL READ (*80,*90,XYCDB,YTAXIS(1),32,NOEOR,FLAG)        
      GO TO 140        
  220 CALL READ (*80,*90,XYCDB,YBAXIS(1),32,NOEOR,FLAG)        
      GO TO 140        
C        
C     XY-COMMAND OPERATIONS HIT        
C        
  230 CALL READ (*80,*90,XYCDB,BUF(1),7,NOEOR,FLAG)        
      IF (BUF(6) .NE. 0) PAPLOT = .TRUE.        
      IF (BUF(6) .NE. 0) OOMPP  = .TRUE.        
      IF (BUF(2) .NE. 0) OOMCP  = .TRUE.        
      IF (BUF(1) .NE. 0) PRINT  = .TRUE.        
      IF (BUF(2) .NE. 0) PLOT   = .TRUE.        
      KASKNT = 0        
      IF (OUTOPN) GO TO 280        
      IF (.NOT.PLOT .AND. .NOT.PAPLOT) GO TO 280        
C        
C     OPEN OUTPUT PLOT DATA BLOCK        
C        
      CORE = CORE - SYSBUF        
      IF (CORE .GT. 0) GO TO 260        
  235 IER = 8        
      IFLE = -CORE        
  237 CALL MESAGE (IER,IFLE,ROUTIN)        
C        
C     CLOSE ANY OPEN FILES AND RETURN        
C        
  240 CALL CLOSE (XYCDB,REWD)        
      DO 250 I = 1,5        
      CALL CLOSE (INDB(I),REWD)        
  250 CONTINUE        
      IF (.NOT.OUTOPN) RETURN        
C        
C     NO CAMERA PLOTS SO DONT WRITE TRAILER        
C        
      IF (.NOT. OOMCP) GO TO 255        
      BUF(1) = OUTFIL        
      BUF(2) = 9999999        
      CALL WRTTRL (BUF(1))        
  255 CALL CLOSE  (OUTFIL,REWD)        
      GO TO 830        
C        
  260 CALL OPEN  (*270,OUTFIL,Z(CORE+1),OUTRWD)        
      CALL FNAME (OUTFIL,NAME(1))        
      CALL WRITE (OUTFIL,NAME(1),2,EOR)        
      OUTOPN = .TRUE.        
      GO TO 280        
C        
C     ERROR,  PLOTS REQUESTED AND OUTFIL PURGED.  DO ALL ELSE.        
C        
  270 CALL PAGE2 (2)        
      WRITE (L,290) UWM,OUTFIL        
      PLOT = .FALSE.        
C        
  280 IF (BUF(3) .NE. 0) PUNCH = .TRUE.        
      TYPE   = BUF(4)        
      VECTOR = BUF(5)        
      NSUBS  = BUF(7)        
      KNT    = 0        
      IF (NSUBS .GT. 0) CALL READ (*80,*90,XYCDB,SUBCAS(1),NSUBS,NOEOR, 
     1                             FLAG)        
      IF (NSUBS .GT. 0) CALL SORT (0,0,1,1,SUBCAS(1),NSUBS)        
      IF (RANDOM .AND. TYPE.NE.2 .AND. TYPE.NE.3) GO TO 380        
      IF ((.NOT.RANDOM) .AND. (TYPE.EQ.2    .OR.  TYPE.EQ.3) ) GO TO 380
      IF ((.NOT.RANDOM) .AND. IPSET.EQ.PSET .AND. VECTOR.GT.7) GO TO 380
      IF ((.NOT.RANDOM) .AND. IPSET.NE.PSET .AND. VECTOR.LE.7) GO TO 380
C        
C     INITIALIZE DATA BLOCK POINTERS FOR THIS VECTOR        
C        
      FILE = FILES(VECTOR)        
C        
C     CHECK FOR RANDOM        
C        
      IF (RANDOM .AND. TYPE.EQ.3) FILE = 2        
      IF (RANDOM .AND. TYPE.EQ.2) FILE = 1        
      IFILE = INDB(FILE)        
      IF (OPENF(FILE)) 360,400,400        
C        
C     EOR HIT ON IFILE.  SHOULD NOT HAVE HAPPENED        
C        
  330 IER = 3        
      GO TO 355        
C        
C     EOF HIT ON IFILE.  SHOULD NOT HAVE HAPPENED        
C        
  350 IER = 2        
  355 CALL MESAGE (IER,IFILE,ROUTIN)        
      OPENF(FILE) = -1        
C        
C     FILE IFILE IS NOT SATISFACTORY        
C        
  360 CALL FNAME (IFILE,BUF(1))        
      CALL PAGE2 (3)        
      WRITE (L,370) UWM,BUF(1),BUF(2),NAMEV(VECTOR)        
C        
C     SKIP OVER ANY AND ALL FRAME DATA FOR THIS CARD.        
C        
  380 CALL READ (*80,*240,XYCDB,BCD,1,NOEOR,FLAG)        
      IF (BCD .NE. FRAM) GO TO 800        
  390 CALL READ (*80,*90,XYCDB,BUF(1),3,NOEOR,FLAG)        
      IF (BUF(1) .NE.-1) GO TO 390        
      GO TO 380        
C        
C     CHECK TO SEE IF THIS FILES SUBCASE IS TO BE OUTPUT        
C        
  400 CONTINUE        
      IF (OPENF(FILE)) 360,401,402        
  401 CONTINUE        
      CALL FWDREC (*350,IFILE)        
      CALL READ (*350,*330,IFILE,IDIN(1),20,EOR,FLAG)        
      CALL READ (*350,*403,IFILE,IDIN(1),-CORE,EOR,FLAG)        
      GO TO 235        
  403 CALL BCKREC (IFILE)        
      CALL BCKREC (IFILE)        
      SIZE  = FLAG/IDIN(10)        
      KTYPE = (IDIN(2)/1000)*1000        
      OPENF(FILE) = 1        
  402 CONTINUE        
      KASKNT = KASKNT + 1        
      IF (NSUBS .EQ. 0) GO TO 415        
      SUBC(FILE) = SUBCAS(KASKNT)        
      GO TO 420        
  415 SUBC(FILE) = 0        
C        
C     NOW READY TO PROCEED WITH DATA SELECTION        
C        
  420 CALL READ (*80,*240,XYCDB,BCD,1,NOEOR,FLAG)        
      IF (BCD .NE. FRAM) GO TO 800        
C        
C     READ IN THE ID-COMP-COMP SETS AND SORT ON ID-S.        
C        
      KNT  = 0        
      ITRY = 0        
      IAT  = 0        
  430 CALL READ (*80,*90,XYCDB,Z(IAT+1),3,NOEOR,FLAG)        
      IF (Z(IAT+1) .EQ. -1) GO TO 440        
      IAT  = IAT + 3        
      GO TO 430        
C        
C     SORT ON ID-S        
C        
  440 CALL SORT (0,0,3,1,Z(1),IAT)        
  450 ICORE = CORE - IAT        
C        
C     COMPUTE FINAL REGIONS        
C        
      NSLOTS= IAT/3        
      NAT   = IAT        
      IF (Z(I3).GT.0 .AND. .NOT.RANDOM) NSLOTS = NSLOTS + NSLOTS        
  554 STEPS = SIZE        
      IF (.NOT.VGP) GO TO 559        
      ITEMP = 0        
      NUQ   = 0        
      DO 555 I = 1,NAT,3        
      IF (Z(I) .EQ. ITEMP) GO TO 555        
      NUQ   = NUQ + 1        
      ITEMP = Z(I)        
  555 CONTINUE        
      STEPS = STEPS*NUQ        
C        
C     SET CORE TO 1        
C        
      J = IAT + 1        
      N = J + MIN0(ICORE,(NSLOTS+1)*STEPS)        
      DO 556 I = J,N        
  556 Z(I) = 1        
  559 CONTINUE        
      IF (STEPS*(NSLOTS+1) .LE. ICORE) GO TO 580        
      CALL PAGE2 (4)        
      WRITE (L,570) UWM,Z(IAT-2),Z(IAT-1),Z(IAT)        
      ICRQ = STEPS*(NSLOTS+1) - ICORE        
      WRITE (L,571) ICRQ        
      NSLOTS = NSLOTS - 1        
      IF (Z(I3).GT.0 .AND. .NOT.RANDOM) NSLOTS = NSLOTS - 1        
      NAT = NAT - 3        
      IF (NSLOTS .GT. 0) GO TO 554        
      GO TO 420        
  580 NTOPS = NSLOTS/2        
      NBOTS = NTOPS        
      IF (Z(I3).GT.0 .AND. .NOT.RANDOM) GO TO 590        
      NTOPS = NSLOTS        
      NBOTS = 0        
  590 CONTINUE        
      CENTER = IAT + NTOPS*STEPS        
C        
C     GET CURVE DATA        
C        
      MAJOR = KTYPE + MAJID(VECTOR)        
      I2    = 0        
      IFCRV =-1        
      ISTSV = 0        
      IDTOT = NAT/3        
C        
C     I1 = 1-ST ROW OF NEXT ID        
C     I2 = LAST ROW OF NEXT ID        
C        
  630 I1   = I2 + 1        
      NBEG = 3*I1 - 3        
      IF (NBEG .GE. NAT) GO TO 780        
      IDZ = NBEG + 1        
      ID  = Z(IDZ)        
      I2  = I1        
  640 IF (I2.GE.IDTOT .OR. RANDOM) GO TO 650        
      IF (Z(3*I2+1) .NE. ID) GO TO 650        
      I2  = I2 + 1        
      GO TO 640        
C        
C     FIND THIS ID ON IFILE        
C        
  650 CALL XYFIND (*350,*330,*660,MAJID(1),IDZ)        
      KNT = -1        
      IF (ITRY.EQ.0 .AND. SUBC(FILE).EQ.-1) GO TO 661        
C        
C     THIS IS THE WAY OUT FOR ALL SUBCASE REQUEST        
C        
      IF (ITRY.NE.0 .AND. SUBC(FILE).EQ.-1) GO TO 415        
      KTYPE = (IDIN(2)/1000)*1000        
      IF (KTYPE.EQ.2000 .OR. KTYPE.EQ.3000) GO TO 690        
      CALL PAGE2 (2)        
      WRITE (L,310) UWM        
      GO TO 360        
C        
C     ID NOT FOUND. PRINT MESSAGE AND SHRINK LIST.        
C        
C        
C     SUBCASE REQUEST EITHER SUBCASE NOT FOUND OR POINT NOT FOUND       
C        
  660 IF (KNT .EQ. -1) IDZ = -1        
      IF (IDZ .NE. -1) GO TO 784        
      CALL PAGE2 (3)        
      WRITE (L,530) UWM,ID,NAMEV(VECTOR),IFILE        
      WRITE (L,635) SUBC(FILE)        
      KNT = 0        
      IF (NAT/3.LE.I2 .AND. I1.EQ.1) GO TO 784        
      GO TO 666        
C        
C     NSUBS = 0 AND POINT NOT FOUND START FRAME OVER        
C        
  661 CALL PAGE2 (3)        
      WRITE (L,530) UWM,ID,NAMEV(VECTOR),IFILE        
      CALL REWIND (IFILE)        
      SUBC(FILE) = 0        
      KNT = 0        
      IF (NAT/3 .GT. I2) GO TO 666        
      IF (I1    .EQ.  1) GO TO 415        
  666 CONTINUE        
      I13 = 3*I1 - 3        
      I23 = 3*I2 + 1        
      IF (I23 .GE. NAT) GO TO 680        
      DO 670 I = I23,NAT        
      I13 = I13 + 1        
  670 Z(I13) = Z(I)        
  680 IDTOT = IDTOT - (I2-I1) - 1        
      I2  = I1 - 1        
      NAT = I13        
      IF (IDZ.EQ.-1 .AND. I1.NE.1 .AND. .NOT.VGP) GO TO 630        
      IAT = NAT        
      GO TO 450        
C        
C     ID FOUND. READ DATA AND DISTRIBUTE INTO SLOTS.        
C        
  690 NWDS  = IDIN(10)        
      ISTEP = 0        
      IFCRV = IFCRV + 1        
      IF (VGP) ISTEP = ISTSV        
  700 CALL READ (*350,*630,IFILE,BUF(1),NWDS,NOEOR,FLAG)        
      ISTEP = ISTEP + 1        
      IF (ISTEP .GT. STEPS) GO TO 700        
      ITEMP = IAT + ISTEP        
      ISTSV = ISTEP        
      IF (.NOT.VGP) GO TO 709        
      IF (IFCRV .EQ. 0) GO TO 709        
C        
C     SORT X AND MOVE Y TO PROPER SLOTS        
C        
      IF (RBUF(1) .GE. RZ(ITEMP-1)) GO TO 709        
      N = ISTEP - 1        
      DO 706 I = 1,N        
      IF (RBUF(1) .LT. RZ(IAT+I)) GO TO 707        
  706 CONTINUE        
      GO TO 709        
  707 ISTEP = I        
      J  = ISTEP        
      ITEMP = IAT + ISTEP        
      N  = NSLOTS + 1        
      JJ = ISTSV  - 1        
      DO 708 I = 1,N        
      ITEM  = IAT + (I-1)*STEPS + J        
      TEMP1 = RZ(ITEM)        
      Z(ITEM) = 1        
      DO 708 IJ = J,JJ        
      ITEM = IAT + (I-1)*STEPS + IJ + 1        
      TEMP = RZ(ITEM)        
      RZ(ITEM) = TEMP1        
      TEMP1 = TEMP        
  708 CONTINUE        
  709 RZ(ITEMP) = RBUF(1)        
C        
C     DISTRIBUTE DATA        
C        
      DO 770 I = I1,I2        
      PLACE = I*STEPS + ISTEP        
C        
C     TOP CURVE        
C        
      COMP = Z(3*I-1)        
C        
C     SET MEAN RESPONSE IF RANDOM        
C        
      IF (RANDOM) Z(3*I) = IDIN(8)        
C        
C     SET NUMBER OF ZERO CROSSINGS IF RANDOM        
C        
      IF (RANDOM) BUF(I+20) = IDIN(9)        
      IF (COMP .EQ. 1000) GO TO 745        
      IF (COMP .EQ.    0) GO TO 770        
      IF (RANDOM) COMP = 2        
      IF (COMP .LE. NWDS) GO TO 740        
      Z(3*I-1) = 0        
      CALL PAGE2 (2)        
      WRITE (L,730) UWM,COMP,ID        
      GO TO 750        
C        
  740 ITEMP = IAT + PLACE        
      Z(ITEMP) = BUF(COMP)        
      GO TO 750        
  745 ITEMP = IAT + PLACE        
      Z(ITEMP) = 1        
C        
C     BOTTOM CURVE IF DOUBLE FRAME        
C        
  750 IF (RANDOM) GO TO 770        
      COMP = Z(3*I)        
      IF (COMP .EQ. 1000) GO TO 765        
      IF (COMP .EQ.    0) GO TO 770        
      IF (COMP .LE. NWDS) GO TO 760        
      Z(3*I) = 0        
      CALL PAGE2 (2)        
      WRITE (L,730) UWM,COMP,ID        
      GO TO 770        
C        
  760 ITEMP = CENTER + PLACE        
      Z(ITEMP) = BUF(COMP)        
      GO TO 770        
  765 ITEMP = CENTER + PLACE        
      Z(ITEMP) = 1        
  770 CONTINUE        
      ISTEP = ISTSV        
      GO TO 700        
C        
C     ALL DATA IS NOW IN SLOTS. INTEGER 1-S REMAIN IN VACANT SLOTS.     
C        
  780 IF (NSUBS .NE. 0) GO TO 783        
      SUBC(FILE) = IDIN(4)        
  783 CONTINUE        
      CALL XYDUMP (OUTFIL,TYPE)        
      KNT = 1        
      IF (NSUBS .NE. 0) GO TO 784        
      SUBC(FILE) = 0        
      ITRY = ITRY + 1        
      GO TO 450        
  784 CONTINUE        
      IF (KASKNT .LT. NSUBS) GO TO 785        
      KASKNT = 0        
      GO TO 402        
  785 KASKNT = KASKNT + 1        
      SUBC(FILE) = SUBCAS(KASKNT)        
      DO 786 I = 1,5        
  786 VECID(I) = 0        
      GO TO 450        
C        
C     INITIALIZE PARAMETERS        
C        
  800 PLOT  = .FALSE.        
      PUNCH = .FALSE.        
      PRINT = .FALSE.        
      PAPLOT= .FALSE.        
      DO 805 I = 1,5        
  805 VECID(I) = 0        
      GO TO 100        
C        
C     VALUE DUMP        
C        
  820 CONTINUE        
      GO TO 140        
C        
C     INTERACTIVE STOP INITIATED HERE.        
C        
 1500 NOGO = 1        
      RETURN        
C        
C     INSUFFICIENT CORE        
C        
  825 CALL MESAGE (8,-CORE,ROUTIN)        
C        
C     CALL THE PRINTER-PLOTTER IF ANY REQUESTS FOR PRINTER-PLOTTER      
C        
  830 IF (OOMPP) CALL XYPRPL        
C        
C     RESTORE OUTPUT HEADING AND RETURN        
C        
  835 DO 840 I = 1,96        
  840 IHEAD(I) = HEADSV(I)        
      RETURN        
C        
C        
  120 FORMAT (A25,' 975, XYTRAN DOES NOT RECOGNIZE ',A4,        
     1       ' AND IS IGNORING')        
  290 FORMAT (A25,' 976, OUTPUT DATA BLOCK',I4,' IS PURGED.',        
     1       '  XYTRAN WILL PROCESS ALL REQUESTS OTHER THAN PLOT')      
  310 FORMAT (A25,' 977, FOLLOWING NAMED DATA-BLOCK IS NOT IN SORT-II', 
     1       ' FORMAT')        
  370 FORMAT (A25,' 978', /5X,'XYTRAN MODULE FINDS DATA-BLOCK(',2A4,    
     1       ') PURGED, NULL, OR INADEQUATE, AND IS IGNORING XY-OUTPUT',
     2       ' REQUEST FOR -',A4,'- CURVES')        
  530 FORMAT (A25,' 979, AN XY-OUTPUT REQUEST FOR POINT OR ELEMENT ID', 
     1       I10, /5X,1H-,A4,'- CURVE IS BEING PASSED OVER.  THE ID ',  
     2       'COULD NOT BE FOUND IN DATA BLOCK',I10)        
  570 FORMAT (A25,' 980, INSUFFICIENT CORE TO HANDLE ALL DATA FOR ALL ',
     1       'CURVES OF THIS FRAME', /5X,' ID =',I10,2(' COMPONENT =',  
     2       I4,5X),' DELETED FROM OUTPUT')        
  571 FORMAT (5X,'ADDITIONAL CORE NEEDED =',I9,' WORDS.')        
  635 FORMAT (5X,'SUBCASE',I10 )        
  730 FORMAT (A25,' 981, COMPONENT =',I10,' FOR ID =',I10,        
     1       ' IS TOO LARGE. THIS COMPONENTS CURVE NOT OUTPUT')        
C        
  900 FORMAT ('  ENTER XYPLOT DEFINITION OR GO TO PLOT OR STOP TO EXIT')
  902 FORMAT ('  BAD CARD TRY AGAIN')        
  910 FORMAT (20A4)        
      END        