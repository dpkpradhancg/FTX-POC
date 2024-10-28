
       //-----------------------------------------------------------------------
       //  Notes from Alvina - 12/12/2016
       //   This version was copied from Sourcelib on 12/9/2016
       //  Must check for any changes dated after this in Sourcelib

       // This runs on RDG box but most of the files are on GH and are
       //   accessed through DDMF - we cannot change code to SQL except
       //   for files that are on RDG box  - I have listed them seperately
       //  You will need to create new Logicals for the DTS files for the
       //   new key and we will need to create new DDMF for those logicals
       //  Replace ' F' spec with 'DS' where needed if code is changed
       //   to SQL / or eliminate 'F' spec completely where possible


       // DTS Files must be written/Updated in the following order
       //   FDTSHDR then FDTSMILE then FDTSFUEL
       // FDTSHDR TMEDAT is calculated form the FDTSMILE last record
       //   written, this can be back updated to FDTSHDR after writing
       //   all MILE records - same with 'Total Fuel' on FDTSHDR


       // DTS Files must be deleted in the reverse order
       //   FDTSFUEL then FDTSMILE then FDTSHDR

       //  Must load field TMKADM from VFADMN in FVEHFIL

       //  Change multi nested 'If/Else' to 'Select'

       // Change Indicators(*IN) on 'Chain/Read/SetLL'
       //     to %Found/Not %Found / %Equal

       //  Remove fields  from Display file DDS
         //   HKYU, DSKYU, DSLIC, DSASRTXT

       // Increase DDS field DSLINE from 2 to 3 - this is to match the
       //   Line/Sequence in new MILE/FUEL files

       // Rename all Subroutines

       //  IF 'GOTO/TAG' is easy to change to Subroutine, please
       //    make the change


       //-----------------------------------------------------------------------
       //TITLE DRIVER TRIP SYSTEM (DTS) TRIP REPORT MAINT. APP:DTS.05.
       //-----------------------------------------------------------------------

       //  Function:  Maintain Driver Trip Report Mileage & Fuel.

       // This must be compiled using the following compile options (use F9 during Prompting)

       //  1) Relational Database (RDB). . . . . . : GHDBC3

       //  2) Package (SQLPKG) . . . . . . . . . . : *OBJ
       //                             Library  . . : QGPL

       //  For the compilation and sql package creation, get the
       //  login credentials from ECNTMSTF file for contact 'DTR ENTRY'.
       //  RDB user...........................USER : **********
       //  RDB user password..............PASSWORD : **********

       // After successfully compiling DTSTENTR program, manually create
       // the SQL package in the remote system using CRTSQLPKG.
       // CRTSQLPKG PGM(OBJECTLIB/DTSTENTR) RDB(GHDBC3)
       // USER(**********) PASSWORD(**********)

       //-----------------------------------------------------------------------

       //  Indicators Used:
       //    *INKA - F1=Exit
       //    *INKB - F2=Previous or F2=Cancel
       //    *INKD - F4=Window
       //    *INKE - F5=Override
       //    *INKG - F7=Suspend
       //    *INKH - F8=Display
       //    *INKI - F9=Add
       //    *INKJ - F10=Change
       //    *INKK - F11=Delete
       //    *INKM - F13=Suprv (Override Access)
       //    *INKN - F14=Route (mileage panel)
       //          - F14=Qty Measure (fuel panel)
       //    *INKP - F15=Miles/Odom (Toggle to maintain either actual
       //                            miles or odometer readings)
       //    *INKQ - F16=Option (mileage panel)
       //    HELP  - On-line help

       //    Security Indicators (01-24)
       //    01 - ADD
       //    02 - CHANGE
       //    03 - DELETE
       //    04 - ALLOW KEYING OF DTRS FOR ON-BOARD COMPUTERS.
       //    05 - ALLOW OVERRIDE OF UNIT FROM A DIFFERENT ADMIN
       //    06 - 24  NOT USED

       //    25 - ND/PR Unit,Corp,Beg.Date on Prompt panel
       //    26 - PR ALL fields on CUST panel (DISPLAY Mode)
       //    27 - PR ALL fields on ALL panels (DISPLAY Mode)
       //    28 - UL Route on mileage panel
       //       - UL QM on fuel panel
       //    29 - PR Trip Date and State on First Mileage Line
       //    30 - UL Option on Mileage screen
       //       - PR Option on Billing Fuel screen
       //    31 - PR ALL Fields on Fuel Purchased screen
       //    32 - F5=Override is made active
       //    33 - F7=Override is made active
       //    34 - Program accessed from Batch Logging Program

       // Additional State Mileage Requirements panel indicators

       //    35 - OFF = ODOM MODE ON MILEAGE SCREEN
       //    35 - ON  = MILE MODE ON MILEAGE SCREEN

       //    36 - PC/UL - Allow input of Loaded/Empty Y/N (mileage)
       //       - PC/UL - Allow input of Tax Paid Y/N (fuel)
       //    37 - PC/UL - Allow input of Toll Miles (mileage)
       //       - PC/UL - Allow input of Original Ticket Y/N (fuel)
       //    38 - PC/UL - Allow input of Weight (mileage)
       //       - PC/UL - Allow input of Green Invoice # (fuel)
       //    39 - PC/UL - Allow input of Number of Axles (mileage)
       //    84 - PC/UL - Allow input of KYU number (KENTUCKY)

       // Prompt panel error indicators

       //    40 - PC/RI - ERROR on Batch number
       //    41 - PC/RI - ERROR on Trip number
       //    42 - PC/RI - ERROR on Unit number
       //    43 - PC/RI - ERROR on Beginning Trip Date

       // Customer panel error indicators
       //    44 - not used
       //    45 - PC/RI - ERROR on Customer number (6)
       //    45 - RI ONLY - ERROR on Customer Bill Group & District
       //    46 - PC/RI - ERROR on Departing city
       //    47 - PC/RI - ERROR on Departing state
       //    48 - PC/RI - ERROR on Destination city
       //    49 - PC/RI - ERROR on Destination state

       //    50 - RECORD LOCK ON LDTSBLG4

       // Mileage panel error indicators

       //    51 - RI - ERROR on Ending Speedo
       //    52 - PC/RI - ERROR on State
       //    53 - PC - 1st mileage record. Cursor placed on Odometer
       //              field or Route field if underlining is on(via F14)
       //       - PC - Cursor placed on 1ST ASR Field.
       //       - PC - Cursor placed on 1ST Blank line Date field.
       //    54 - not used
       //    55 - PC - ERROR on Ending Speedo and NO OTHER ERRORS on SFL
       //    56 - RI - ERROR on option field
       //    57 - METRIC UNIT (NON US UNIT)
       //    58 - RI - ERROR on odometer
       //    59 - RI - ERROR on code

       //    60 - SFLCLR
       //    61 - ROLLUP (If N68)
       //    62 - SFLDSPCTL
       //    63 - SFLDSP
       //    64 - NOT USED
       //    65 - SFLNXTCHG
       //    66 - SFLMSGID (Rollup/down past limits - CPF5203 QCPFMSG)
       //    67 - NOT USED
       //    68 - SFLEND
       //    69 - SFLDLT
       // Message Subfile
       //    70 - SFLDSP,SFLDSPCTL,SFLEND
       //   N70 - SFLCLR

       // Additional State Requirements panel error indicators

       //    71 - RI - ERROR on loaded/empty
       //    72 - RI - ERROR on toll miles
       //    73 - RI - ERROR on axles for state of Oregon
       //*   74 - RI - ERROR on weight over 105,500 for state of Oregon

       // Fuel panel error indicators

       //    74 - RI - ERROR on fuel ticket number
       //    75 - RI - ERROR on gallons
       //    76 - RI - ERROR on fuel code
       //    77 - RI - ERROR on vendor number
       //    78 - RI - ERROR on vendor name and city
       //    79 - RI - ERROR on Source Y/N on Fuel Purchase screen

       // Additional Fuel Requirements panel error indicators

       //    71 - RI - ERROR on tax paid
       //    72 - RI - ERROR on original fuel ticket
       //    73 - RI - ERROR on green ticket number

       //    80 - PC on Trip number (since batch no. already filled in)
       //    81 - PC on Dep. city (valid cust found & 1st Add record)
       //    82 - PC on Dest.city (valid cust found & prev. cities loaded)
       //    83 - RI on option field of list panel
       //    84 - PC/UL - Allow input of KYU number (KENTUCKY)
       //    85 - used for chains, reads, etc...
       //    86 - used for chains, reads, etc...
       //    87 - used for chains, reads, etc...
       //    88 - used for chains, reads, etc...
       //    89 - used for chains, reads, etc...

       //    90 - Help Pressed

       //    91 - READC EOF
       //    92 - First READE on file for loading SFL
       //    93 - Used for Second and additional READE on file
       //         for loading SFL if First READE (91=off) is located.
       //    94 - used for chains, reads, etc...
       //    95 - used for chains, reads, etc...
       //    96 - used for chains, reads, etc...
       //    97 - used for chains, reads, etc...
       //    98 - used for chains, reads, etc...
       //    99 - used for chains, reads, etc...
      * -----------------------------------------------------------------
      *Changed by :Jinu Paulose            Date:06/25/2020
      *Project    :                        Tag :JP01
      *Description:If a active RQLE flag with 'Y' found for the State with
      *              Blank Customer then User should be allowed to enter L/E
      *              Code in State Requirement Screen. If not default L/E to 'L'
      * -----------------------------------------------------------------
      *Changed by :Jinu Paulose            Date:10/06/2021
      *Project    :RC226_PPM466719         Tag :JP02
      *Description:Consider acquisition units from parallel corps alone.
      * -----------------------------------------------------------------

       //-----------------------------------------------------------------------
       Ctl-Opt Option(*SrcStmt : *NoDebugIO);

       Dcl-F DTSTENTD WORKSTN(*Ext) Usage(*Input:*Output) INFDS(DSINFO)
             MAXDEV(*FILE) INFSR(*PSSR) SFILE(MILSFL:Mile_RRN)
             SFILE(ASRSFL:Ad_Mile_RRN) SFILE(BILSFL:Bill_RRN)
             SFILE(FULSFL:Fuel_RRN) SFILE(AFRSFL:Ad_Fuel_RRN)
             SFILE(LSTSFL:List_RRN) SFILE(DELSFL:DEL_RRN) SFILE(MSGSFL:MSG#);

       //-----------------------------------------------------------------------
       Dcl-Ds FDtsBat    ExtName('FDTSBAT') Inz End-Ds;
       Dcl-Ds FvehFil   ExtName('FVEHFIL') Inz End-Ds;
       Dcl-Ds FdtsMile  ExtName('FDTSMILE')Inz End-Ds;
       Dcl-Ds FfuelTkt  ExtName('FFUELTKT')Inz End-Ds;
       Dcl-Ds FDtsFuel  ExtName('FDTSFUEL')Inz End-Ds;
       Dcl-Ds FdtsErr   ExtName('FDTSERR') Inz End-Ds;
       //-----------------------------------------------------------------------

       Dcl-Ds Wk_Hdr EXTNAME('FDTSHDR') Inz;
              TMRCWTHD EXTFLD('TMRCWT') ;
       END-DS;

       Dcl-Ds Fuel_Ds Qualified Dim(9999);
           Fuel_tkt Char(9);
           Fuel_src Char(1);
       END-DS;

       // FCUSMST RECORD LAYOUT
       Dcl-Ds Wk_CustMst EXTNAME('FCUSMST') Inz End-Ds;

       Dcl-Ds DTSSRQds EXTNAME('FDTSSRQ') Inz End-Ds;

       Dcl-Ds DTSSRQq EXTNAME('FDTSSRQ') Qualified Inz End-Ds;

       Dcl-Ds FDTSCSTSF EXTNAME('FDTSCSTSF') Inz;
              TMHTRPHD EXTFLD('TMHTRP') ;
       END-DS;

        // Program Status Data Structure.
       Dcl-Ds PSSA  ExtName('FPSDS') PsDs End-Ds;

       Dcl-Ds LDA EXTNAME('FLDADS') DTAARA(*LDA);
          //* Storing DSCORP to WKCORP LDA Field
         LdInds Char(24) Pos(465);
         WkCorp Char(4) Pos(601);
       End-Ds;

       Dcl-Ds Hld_LDA Qualified Inz;
         LDA_Data LikeDs(LDA) ;
       End-Ds;

       Dcl-Ds JobRun Dtaara('DTSBCHUPD') Inz;
        BchRun Char(1) ;
       End-Ds;


      // DEFINE WORK FIELD SIZES
      //---------------------------------------------------------------------
      // Arrays
      //---------------------------------------------------------------------

       Dcl-S FUNA    Char(10) DIM(1) CTDATA PERRCD(1);
       Dcl-S FUNB    Char(8) DIM(1) CTDATA PERRCD(1);
       Dcl-S FUNC    Char(7) DIM(1) CTDATA PERRCD(1);
       Dcl-S FUND    Char(11) DIM(1) CTDATA PERRCD(1);
       Dcl-S FUNE    Char(10) DIM(1) CTDATA PERRCD(1);
       Dcl-S FUNF    Char(16) DIM(1) CTDATA PERRCD(1);
       Dcl-S FUNFR   Char(16) DIM(1) CTDATA PERRCD(1);
       Dcl-S FUNG    Char(12) DIM(1) CTDATA PERRCD(1);
       Dcl-S FUNH    Char(9) DIM(1) CTDATA PERRCD(1);

       Dcl-S @ST Char(2) DIM(99) Inz;                                         // MILEAGE STATES
       Dcl-S @STWGT Packed(7) DIM(99) Inz;                                    // MILEAGE STATES
       Dcl-S @STAXL Packed(2) DIM(99) Inz;                                    // MILEAGE STATES
       Dcl-S @STM Char(2) DIM(99) Inz;                                        // MILEAGE STATES
       Dcl-S @SMC Char(1) DIM(99) Inz;                                        // STATE MIL CODE
       Dcl-S @BRN Packed(4) DIM(99) Inz;                                      // BILRRN select
       Dcl-S TRP Char(1) DIM(8) Inz;                                          // TRIP NO.
       Dcl-S DFL Char(18) DIM(99) Inz;
       Dcl-S QTY Packed(5:1) DIM(99) Inz;
       Dcl-S CSS Char(8) DIM(99) Inz;                                         // Trip No in sus
       Dcl-S TRDAY Packed(7) DIM(99) Inz;
       Dcl-S TRMIL Packed(7) DIM(99) Inz;

       // Prompt Override/Suspend Errors
       Dcl-Ds PRMMSG OCCURS(20) Inz;
         PRMLIN Char(2);
         PRMMID Char(7) Pos(5);
         PRMSEV Zoned(2);
       End-Ds;

       // Customer Override/Suspend Errors
       Dcl-Ds CUSMSG OCCURS(20) Inz;
         CUSLIN Char(2);
         CUSMID Char(7) Pos(5);
         CUSSEV Zoned(2);
       End-Ds;

       // Mileage Override/Suspend Errors
       Dcl-Ds MILMSG OCCURS(20) Inz;
         MILLIN Char(2);
         MILMID Char(7) Pos(5);
         MILSEV Zoned(2);
       End-Ds;

       // ASR Override/Suspend Errors
       Dcl-Ds ASRMSG OCCURS(99) Inz;
         ASRLIN Char(2);
         ASRMID Char(7) Pos(5);
         ASRSEV Zoned(2);
       End-Ds;

       // Fuel Override/Suspend Errors
       Dcl-Ds FULMSG OCCURS(20) Inz;
         FULLIN Char(2);
         FULMID Char(7) Pos(5);
         FULSEV Zoned(2);
       End-Ds;

       // AFR Override/Suspend Errors
       Dcl-Ds AFRMSG OCCURS(20) Inz;
         AFRLIN Char(2);
         AFRMID Char(7) Pos(5);
         AFRSEV Zoned(2);
       End-Ds;

       //*******************************************************************

       Dcl-Ds AsOfDt DtaAra('DTSPAPERDT');
         AsOfYr Char(3) Pos(1);
         AsOfMo Char(2) Pos(4);
         Pr_CYY Zoned(3) Overlay(AsOfYr);
         Pr_MM Zoned(2) Overlay(AsOfMo);
       End-Ds;

       // End of Month for Current Processing Period from DTSPAPERDT
       Dcl-S Pr_EOM Packed(7) Inz;
       Dcl-S WRKDESC Char(10) Inz;
       Dcl-S Bl_Date Date Inz(d'2001-01-01');
       Dcl-S Valid_set Char(11) Inz('0123456789.');

       Dcl-Ds DSINFO;
         #IROW Char(1) Pos(370);
         #ICOL Char(1) Pos(371);
         INFRRN Bindec(4) Pos(378);
       End-Ds;

       // Convert Cursor Position
       Dcl-Ds *N;
         #CROW Bindec(4) Inz;
         #CROWA Char(2) Overlay(#CROW);
         #CCOL Bindec(4) Inz;
         #CCOLA Char(2) Overlay(#CCOL);
       End-Ds;

       Dcl-Ds *N;
         TRL3     Char(10) Inz;
         TRL3AB   Char(4) Overlay(TRL3);
         TRL3A    Char(3) Overlay(TRL3AB);
         TRL3B    Char(1) Overlay(TRL3AB:4);
         TRL3C    Zoned(6) Overlay(TRL3:5);
       End-Ds;

       Dcl-Ds *N;
         DSDPUR Zoned(6) inz;
         DSDPMM Zoned(2) Overlay(DSDPUR);
         DSDPDD Zoned(2) Overlay(DSDPUR:3);
         DSDPYY Zoned(2) Overlay(DSDPUR:5);
       End-Ds;

       Dcl-Ds *N;
         Line_Date Zoned(7) Inz;
         LinDatYY Zoned(3) Overlay(Line_Date);
         LinDatMM Zoned(2) Overlay(Line_Date:4);
         LinDatDD Zoned(2) Overlay(Line_Date:6);
       End-Ds;

       Dcl-Ds *N;
         DSCUS Char(12) Inz;
         DSACCN Char(8) Overlay(DSCUS);
         DSCUST Char(6) Overlay(DSCUS);
         DSCBG Char(2) Overlay(DSCUS:7);
         DSCDST Char(4) Overlay(DSCUS:9);
       End-Ds;

       Dcl-Ds *N;
         DSFPG Zoned(5:1) Inz;
         DSFPG0 Zoned(5) Overlay(DSFPG);
       End-Ds;

       Dcl-Ds *N;
         MILE Char(73) Inz;
         MILOPT Char(1) Overlay(MILE);
         DSLINE Char(2) Overlay(MILE:2);
         DSMDY Zoned(6) Overlay(MILE:4);
         DSSE Char(2) Overlay(MILE:10);
         DSSTNM Char(14) Overlay(MILE:12);
         DSRTES Char(6) Overlay(MILE:26);
         DSBODM Zoned(7) Overlay(MILE:32);
         DSCODE Char(1) Overlay(MILE:39);
         DSLE Char(1) Overlay(MILE:40);
         DSTOLL Zoned(5) Overlay(MILE:41);
         DSRCWT Zoned(7) Overlay(MILE:46);
         DSAXLE Zoned(1) Overlay(MILE:53);
         DSKYU Zoned(6) Overlay(MILE:54);
         HODOM Zoned(7) Overlay(MILE:60);
         HMILE Zoned(7) Overlay(MILE:67);
       End-Ds;

       Dcl-Ds D1MILE OCCURS(99) Inz;
         D1SOPT Char(1);
         D1LINE Char(2);
         D1TMDY Zoned(6);
         D1SE Char(2);
         D1STNM Char(14);
         D1RTES Char(6);
         D1BODM Zoned(7);
         D1CODE Char(1);
         D1LE Char(1);
         D1TOLL Zoned(5);
         D1RCWT Zoned(7);
         D1AXLE Zoned(1);
         D1KYU Zoned(6);
         D1HODM Zoned(7);
         D1HMIL Zoned(7);
       End-Ds;

       Dcl-Ds DEMILE OCCURS(99) Inz;
         DESOPT Char(1);
         DETMDY Char(1);
         DESE Char(1);
         DEBODM Char(1);
         DECODE Char(1);
       End-Ds;

       Dcl-Ds *N;
         FUEL      Char(83) Inz;
         FULOPT    Char(1) Overlay(FUEL);
         DSFLIN    Char(2) Overlay(FUEL:2);
         DSSRC     Char(1) Overlay(FUEL:4);
         DSFMDY    Zoned(6) Overlay(FUEL:5);
         DSSPUR    Char(2) Overlay(FUEL:11);
         DSTKNO    Char(9) Overlay(FUEL:13);
         DSFPGX    Zoned(5) Overlay(FUEL:22);
         DSQTM     Char(1) Overlay(FUEL:27);
         DSVEND    Char(6) Overlay(FUEL:28);
         Ds_FDIST  Char(4) Overlay(DSVEND);
         DS_FLoc   Char(2) Overlay(DSVEND:5);
         DSVNDN    Char(16) Overlay(FUEL:34);
         DSVNDC    Char(10) Overlay(FUEL:50);
         HSRC      Char(1) Overlay(FUEL:60);
         DSTAXP    Char(1) Overlay(FUEL:61);
         DSORIG    Char(1) Overlay(FUEL:62);
         DSGRIN    Char(8) Overlay(FUEL:63);
         DSFX      Char(1) Overlay(FUEL:71);
         DSTKTRCVD Char(1) Overlay(FUEL:72);
         DSINVC    Char(10) Overlay(FUEL:73);
         DSSRCF    Char(1) Overlay(FUEL:83);
       End-Ds;

       Dcl-Ds D2FUEL OCCURS(99) Inz;
         D2FOPT Char(1);
         D2FLIN Char(2);
         D2SRC Char(1);
         D2DPUR Zoned(6);
         D2SPUR Char(2);
         D2TKNO Char(9);
         D2FPG Zoned(5);
         D2QTM Char(1);
         D2VEND Char(6);
         D2VNDN Char(16);
         D2VNDC Char(10);
         D2HSRC Char(1);
         D2TAXP Char(1);
         D2ORIG Char(1);
         D2GRIN Char(8);
         D2FX Char(1);
         D2TKTRCVD Char(1);
         D2INVC Char(10);
         D2SRCF Char(1);
       End-Ds;


       // DS SUBFIELDS TO DUPLICATE ODOMETER READINGS
       Dcl-Ds *N;
         Check_Odom Char(14) Inz;
         A_OdomC Char(7) Overlay(Check_Odom);
         B_OdomC Char(7) Overlay(Check_Odom:8);
         A_OdomZ Zoned(7) Overlay(Check_Odom);
         B_odomZ Zoned(7) Overlay(Check_Odom:8);
       End-Ds;

       //  Message parms - Number of Months (DTS0458)
       Dcl-Ds *N;
         DS0458 Char(256) Inz;
         MN0458 Char(2) Overlay(DS0458);
       End-Ds;

       Dcl-DS *N;
         $MID Char(7);
         $Msgcd Char(3) Overlay($MID) Inz('DTS');
         $Msgid Char(4) Overlay($MID:4);
       End-Ds;

       Dcl-DS *N;
         $MFILE Char(10) Inz;
         $MFile6 Char(6) Overlay($MFILE);
         $MFile8 Char(8) Overlay($MFILE);
       End-Ds;

       Dcl-DS *N;
         FUNCLN Char(80);
         Funmsg Char(15) Overlay(FUNCLN);
       End-Ds;
       //*******************************************************************
       Dcl-Ds FUNDSP Inz;
         DSP04 Char(10);
         DSP06 Char(16);
         BLNK08 Char(11);
         DSP09 Char(7);
         DSP10 Char(11);
         DSP11 Char(10);
       End-Ds;

       Dcl-Ds FUNADD;
         ADD01 Char(15) Inz('F1=Exit');        //Functional Key in Footer Section of ADD Screen
         ADD04 Char(10) Inz;
         ADD07 Char(16) Inz;
         ADD08 Char(8) Inz;
         ADD05 Char(12) Inz;
         ADD10 Char(9) Inz;
         ADD11 Char(10) Inz;
       End-Ds;

       Dcl-Ds FUNCHG;
         CHG01 Char(15) Inz('F1=Exit');        //Functional Key in Footer Section of CHG Screen
         CHG04 Char(10) Inz;
         CHG07 Char(16) Inz;
         CHG08 Char(8) Inz;
         CHG09 Char(7) Inz;
         CHG05 Char(14) Inz;
         CHG0512 Char(12) Overlay(CHG05);
         CHG11 Char(10) Inz;
       End-Ds;

       Dcl-Ds FUNDLT ;
         DLT01 Char(15) Inz('F1=Exit');        //Functional Key in Footer Section of DLT Screen
         DLT04 Char(10) Inz;
         DLT06 Char(16) Inz;
         DLT08 Char(8) Inz;
         FILL Char(3) Inz;
         DLT09 Char(7) Inz;
         DLT10 Char(11) Inz;
         BLNK11 Char(10) Inz;
       End-Ds;

       Dcl-Ds *N ;
         Today_7   Zoned(7) Inz;
         Cur_CYY7  Zoned(3) Overlay(Today_7);
         Cur_MM7   Zoned(2) Overlay(Today_7:4);
         Cur_DD7   Zoned(2) Overlay(Today_7:6);
       End-Ds;

       Dcl-Ds *N Inz;
         Wk_Date7 Zoned(7);
         Wk_CYY7  Zoned(3) Overlay(Wk_Date7);
         Wk_MM7   Zoned(2) Overlay(Wk_Date7:4);
         Wk_DD7   Zoned(2) Overlay(Wk_Date7:6);
       End-Ds;

       Dcl-Ds DUPFL Inz;
         DUPFLY Zoned(3);
         DUPFLM Zoned(2);
         DUPFLD Zoned(2);
         DUPFLS Char(2);
         DUPFLT Char(9);
       End-Ds;

       // - - - - -
       // Results from RentalNet LookUp
       Dcl-Ds ResultSet;
         $ContractKey Bindec(9);
         $TransNumber Char(10);
         $PONumber Char(20);
         $Customer Char(30);
         $AddressLine1 Char(35);
         $AddressLine2 Char(35);
         $City Char(28);
         $State Char(2);
         $PostCd Char(10);
         $Country Char(3);
         $Account Char(8);
         $Custnum Char(6) Overlay($Account);
         $Custgrp Char(2) Overlay($Account:7);
         $Attn Char(20);
         $DateOut Date;
         $TimeOut Time;
         $DateIn Date;
         $TimeIn Time;
         $RentLocCd Char(6);
         $SourceType Char(1);
         $Dist Char(4);
         $BegOdo Int(10);
         $EndOdo Int(10);
         $Resultst Char(10) Pos(211);
       End-Ds;

       Dcl-S ResultSet1 LIKE(ResultSet);
       Dcl-S ResultSet2 LIKE(ResultSet);
       Dcl-S ResultSet3 LIKE(ResultSet);
       Dcl-S ResultSet4 LIKE(ResultSet);
       Dcl-S ResultSet5 LIKE(ResultSet);

       Dcl-Ds PResultSet;
         $PContractKey Bindec(9);
         $PTransNumber Char(10);
         $PPONumber Char(20);
         $PCustomer Char(30);
         $PAddressLin1 Char(35);
         $PAddressLin2 Char(35);
         $PCity Char(28);
         $PState Char(2);
         $PPostCd Char(10);
         $PCountry Char(3);
         $PAccount Char(8);
         $PAttn Char(20);
         $PDateOut Date;
         $PTimeOut Time;
         $PDateIn Date;
         $PTimeIn Time;
         $PRentLocCd Char(6);
         $PSourceType Char(1);
         $PDist Char(4);
         $PBegOdo Int(10);
         $PEndOdo Int(10);
       End-Ds;

       // - - - - -  Prototypes / Procedures

       //  Prototype / and Parameters for SPYESNOR
       Dcl-Pr Snd_Msg ExtPgm('SPYESNOR');
         Text Char(300);
         Rply Char(1);
       End-Pr;
       Dcl-S Text Char(300) Inz;
       Dcl-S Rply Char(1) Inz;
       Dcl-S RecFnd Char(1) Inz;
       Dcl-S EFlag Char(1) Inz;
       Dcl-S WTAXL_Flg Char(1) Inz('0');
       Dcl-S Susp_Flg Char(1) Inz('0');
       Dcl-S LstFlg Char(1) Inz('N');
       Dcl-S DspFlg Char(1) Inz('Y');
       Dcl-S Lwieght_Susp Char(1) Inz;
       Dcl-S PBegDate Date;
       Dcl-S PLicWgt  Char(7);
       Dcl-S PAxles   Char(2);
       Dcl-S PState   Char(2) Inz('OR');
       Dcl-S PError   Char(10);

       // Prototype for 'SECURITY'
       Dcl-Pr SECURITY ExtPgm('SECURITY');
       End-Pr;

       Dcl-Pr FMTAXLVLDR ExtPgm('FMTAXLVLDR');
        PCorp     Like(DsCorp);
        PFinCust  Like(DsCust);
        PFinUnit  Like(DsUnit);
        PBegDate_ Like(PBegDate);
        PState_   Like(PState);
        PLicWgt_  Like(PLicWgt);
        PAxles_   Like(PAxles);
        PError_   Like(PError);
       End-Pr;

       // Procedure Interface for GETDTSRQ
       Dcl-Pr getDTSSRQ ExtPgm('GETDTSSRQ');
         PIState Char(2) const;
         PICUST Char(6) const;
         PIDIST Char(4) const;
         PIDATE Packed(7) const;
         POFOUND Ind;                                                           // *on if found
         POIMAGE likeds(DTSSRQq);
       End-Pr;

       // Prototype for 'SPVEXIT'
       Dcl-Pr SPVEXIT ExtPgm('SPVEXIT');
         CONFRM_ Like(CONFRM);
       End-Pr;

       // Prototype for 'DTSTSSRR'
       Dcl-Pr DTSTSSRR ExtPgm('DTSTSSRR');
         SUSREJ_ Like(SUSREJ);
         REJ_ Like(REJ);
       End-Pr;

       // Prototype for 'SPV1CORP'
       Dcl-Pr SPV1CORP ExtPgm('SPV1CORP');
         @@CORP_ Like(VFCORP);
         WKNME_ Like(WKNME);
         WKAFLG_ Like(WKAFLG);
         WKFLG1_ Like(WKFLG1);
         WKFLG2_ Like(WKFLG2);
         WKPRSC_ Like(WKPRSC);
         WKACSC_ Like(WKACSC);
         WKPRLC_ Like(WKPRLC);
         WKEFLG_ Like(WKEFLG);
         WKUOMC_ Like(WKUOMC);
         WKCTRC_ Like(WKCTRC);
       End-Pr;

       // Prototype for 'SPV1UNIT'
       Dcl-Pr SPV1UNIT ExtPgm('SPV1UNIT');
         DSCORP_ Like(DSCORP);
         DSUNIT_ Like(DSUNIT);
         UPIND1_ Like(UPIND1);
         UPDIST_ Like(UPDIST);
         UPLOCN_ Like(UPLOCN);
         UPCUST_ Like(UPCUST);
         UPBGRP_ Like(UPBGRP);
         UPUSE_ Like(UPUSE);
         UPCAT_ Like(UPCAT);
         UPTYPE_ Like(UPTYPE);
         UPVCST_ Like(UPVCST);
         UPACTG_ Like(UPACTG);
         UPSLDT_ Like(Wk_Date7P);
         UPOWNR_ Like(UPOWNR);
         UPADMN_ Like(UPADMN);
         UPALTN_ Like(UPALTN);
         UPAREA_ Like(UPAREA);
         UPREGN_ Like(UPREGN);
         Wk_Date7P_ Like(Beg_Date7);
       End-Pr;

       // Prototype for 'SPCUSRTVR'
       Dcl-Pr SPCUSRTVR ExtPgm('SPCUSRTVR');
         DSUNIT_ Like(DSUNIT);
         $USE_ Like($USE);
         CusAdr_Date_ Like(Wk_Date7P);
         $Time_ Like($Time);
         ResultSet1_ Like(ResultSet1);
         ResultSet2_ Like(ResultSet2);
         ResultSet3_ Like(ResultSet3);
         ResultSet4_ Like(ResultSet4);
         ResultSet5_ Like(ResultSet5);
         $Error_ Like(WK_CustErr);
         BatchFlag_ Like(BatchFlag);
         BillFlag_ Like(BillFlag);
         GMTFlag_ Like(GMTFlag);
         CTFLAG_ Like(CTFLAG);
         AccFlag_ Like(AccFlag);
       End-Pr;

       Dcl-S $Use Char(10) Inz;
       Dcl-S $Time Packed(6) Inz;
       Dcl-S OPDis Packed(6) Inz;
       Dcl-S HKYU Packed(6) Inz;
       Dcl-S Tflin Char(2) Inz;
       Dcl-S Vfadm Char(4) Inz;
       Dcl-S Exit_Match_Fl Char(1) Inz;
       Dcl-S SAVCUS Char(12) Inz;
       Dcl-S EmFlag Char(1) Inz;
       Dcl-S Bch_Flg Char(1) Inz;
       Dcl-S Bch_Flg1 Char(1) Inz;
       Dcl-S Wk_DSRCWT Packed(7);
       Dcl-S Wk_DSAXLE Packed(1);

       // Prototype for 'SPV1CSVR'
       Dcl-Pr SPV1CSVR ExtPgm('SPV1CSVR');
         WKCACT_ Like(WKCACT);
         WKCCUS_ Like(WKCCUS);
         DSCDST_ Like(DSCDST);
         Wk_Date7P_ Like(Beg_Date7);
         WKCERR_ Like(WK_CustErr);
         Wk_CustMst_ Like(Wk_CustMst);
       End-Pr;

       // Prototype for 'DTSTCTNR'
       Dcl-Pr DTSTCTNR ExtPgm('DTSTCTNR');
         DSHTRP_ Like(DSHTRP);
         DSBOX_ Like(DSBOX);
         DSBCNO_ Like(DSBCNO);
       End-Pr;

       // Prototype for 'DTSTTRFR'
       Dcl-Pr DTSTTRFR ExtPgm('DTSTTRFR');
         CSSBOX_ Like(CSSBOX);
         CSSBAT_ Like(CSSBAT);
         TRFCNT_ Like(TRFCNT);
         DSBOX_ Like(DSBOX);
         DSBCNO_ Like(DSBCNO);
       End-Pr;

       // Prototype for 'DTSTWVNR'
       Dcl-Pr DTSTWVNR ExtPgm('DTSTWVNR');
         $RTNCD_ Like($RTNCD);
         $$VEND_ Like($$VEND);
         $$STAT_ Like($$STAT);
         $$VNAM_ Like($$VNAM);
         $$VCTY_ Like($$VCTY);
       End-Pr;

       // Prototype for 'DTSTWINR'
       Dcl-Pr DTSTWINR ExtPgm('DTSTWINR');
       End-Pr;

       // Prototype for 'SPHELP'
       Dcl-Pr SPHELP ExtPgm('SPHELP');
         HELPDS_ Like(HELPDS);
       End-Pr;

       // Prototype for 'SPRTVMSV'
       Dcl-Pr SPRTVMSV ExtPgm('SPRTVMSV');
         $MID_ Like($MID);
         $MFILE_ Like($MFILE);
         $MLIB_ Like($MLIB);
         $MKEY_ Like($MKEY);
         $MDATA_ Like($MDATA);
         $MSEV_ Like($MSEV);
       End-Pr;

       // Prototype for 'SPCNLRPG'
       Dcl-Pr SPCNLRPG ExtPgm('SPCNLRPG');
         PSSA_ Like(PSSA);
       End-Pr;

       //Parameters required to connect to READING

       Dcl-S wkPgmNam Char(25) Inz('DTSTENTR_G5');
       Dcl-S wkOption Char(1) Inz;
       Dcl-S wkFlag Char(1) Inz;

       Dcl-Pr Rmt_Conn ExtPgm('REMXCONR');
        wkOption_ like(wkOption);
        wkPgmNam_ like(wkPgmNam);
        wkFlag_ like(wkFlag);
        $sqlcod BinDec(9) Options (*NoPass);
        $sqlstate Char(5) Options (*NoPass);
        $sqlmsg  Char(70) Options (*NoPass);
       End-Pr;

       // Prototype for 'DTSTENTR'
       //------------------------------------
       Dcl-Pr DTSTENTR ExtPgm('DTSTENTR');
        PmBoxN Char(7) Options (*NoPass);        // Parameters are Optional
        PmBcno Char(7) Options (*NoPass);
        PmExit Char(1) Options (*NoPass);
        PmRtrn Char(1) Options (*NoPass);
        PmFull Char(1) Options (*NoPass);
        PmTrip Char(8) Options (*NoPass);
       End-Pr;

       Dcl-Pi DTSTENTR;
        PmBoxN Char(7) Options (*NoPass);        // Parameters are Optional
        PmBcno Char(7) Options (*NoPass);
        PmExit Char(1) Options (*NoPass);
        PmRtrn Char(1) Options (*NoPass);
        PmFull Char(1) Options (*NoPass);
        PmTrip Char(8) Options (*NoPass);
       End-Pi;

       // - - - - - Constants
       Dcl-C NUMRC CONST('0123456789');
       Dcl-C YES CONST('Y');
       Dcl-C NO CONST('N');
       Dcl-C FUN01 CONST('F1=Exit        ');
       Dcl-C FUN02 CONST('F1=Exit F2=Log ');
       Dcl-C FUN03 CONST('F1=Exit F2=List F4=Window');

       Dcl-C FUN04 CONST('F1=Exit F2=List F-
       4=Window F7=Suspend');

       Dcl-C FUN04R CONST('F1=Exit F2=List F-
       4=Window F7=Sus/Rej');

       Dcl-C FUN05 CONST('F1=Exit F2=List F-
       4=Window F5=Override');

       Dcl-C RENT CONST('Daily Service or Rental.');

       Dcl-C XXXXXX CONST('XXXXXXX');

       Dcl-C WKCHAR CONST(X'D0');
       Dcl-C WKCHAR1 CONST(X'E0');

       //---------------------------------------------------------------------
       // Stand Alone Fields - TOP
       //---------------------------------------------------------------------
       Dcl-S REMCNT Packed(3) Inz;

       Dcl-S True        Ind Inz(*On);
       Dcl-S Pmt_Loop    Ind Inz(*On);
       Dcl-S Cus_Loop    Ind Inz(*On);
       Dcl-S Mil_Loop    Ind Inz(*On);
       Dcl-S Asr_Loop    Ind Inz(*On);
       Dcl-S Bil_Loop    Ind Inz(*On);
       Dcl-S Ful_Loop    Ind Inz(*On);
       Dcl-S Batch_lst   Ind Inz(*Off);
       Dcl-S Today_10    Date;
       Dcl-S Today_2Yr   Packed(7) Inz;
       Dcl-S Wk_Date7P   Packed(7) Inz;
       Dcl-S Wk_Date10   Date;
       Dcl-S Wk_DATE6    Packed(6) Inz;
       Dcl-S Wk_MDY      Packed(6) Inz;
       Dcl-S Wk_CYMD     Packed(7) Inz;

       Dcl-S Sfl_End Char(1) Inz('N');

       Dcl-S Beg_Date7 Packed(7) Inz;
       Dcl-S Wk_BegDat7P Packed(7) Inz;
       Dcl-S Wk_EndDat7P Packed(7) Inz;
       Dcl-S Wk_BegDat7 Packed(7) Inz;
       Dcl-S Wk_EndDat7 Packed(7)Inz;
       Dcl-S Wk_BegDt10 Date;

       Dcl-S GoAhead Char(1) Inz;
       Dcl-S RecExist Char(1) Inz;
       Dcl-S VTimestamp Timestamp;

       Dcl-S Hld10 Char(1) Inz('0');
       Dcl-S Wk_Mile_Err Packed(1) Inz;
       Dcl-S Wk_Fuel_Err Packed(1) Inz;
       Dcl-S Acq_Unit_Key Char(20) Inz;
       Dcl-S Wk_Cust8 Char(8) Inz;
       Dcl-S WkRemote  Char(8) Inz;
       Dcl-S WkMachine Char(8) Inz;
       Dcl-S VTDSC Packed(25) Inz;
       Dcl-S DSBODM1 Packed(7) Inz;
       Dcl-S Pos Packed(3) Inz;
       Dcl-S Pos1 Packed(3) Inz;
       Dcl-S TRPMIL Packed(7) Inz;
       Dcl-S Wk25E Char(25) Inz;

       Dcl-S $Once     Char(1)Inz('N');
       Dcl-S FrmLis    Char(1)Inz('N');
       Dcl-S RntUnt    Char(1)Inz('N');

       Dcl-S DSBOX8 Char(8) Inz;
       Dcl-S CONFRM Char(1) Inz;
       Dcl-S REJ Char(1) Inz;
       Dcl-S SUSREJ Char(1) Inz;

       Dcl-S srqFound Ind Inz(*Off);                                            // *on if found
       Dcl-S Lwieght Char(7) Inz;
       Dcl-S #DSRCWT Packed(7) Inz;
       Dcl-S #VF9N72 Packed(7:2) Inz;
       Dcl-S #DSAXLE Packed(2) Inz;

       Dcl-S Valid Char(1);
       Dcl-S OneCust Char(1) Inz('N');
       Dcl-S MltCust Char(1) Inz('N');

       Dcl-S $$STAT Char(2) Inz;
       Dcl-S $$VCTY Char(15) Inz;
       Dcl-S $$VEND Char(6) Inz;
       Dcl-S $$VNAM Char(24) Inz;

       Dcl-S $HSEQ Packed(5) Inz;
       Dcl-S $MDATA Char(256) Inz;
       Dcl-S $MKEY Char(4) Inz;
       Dcl-S $MLIB Char(10) Inz;
       Dcl-S $MSEV Packed(2) Inz;
       Dcl-S $OLEAS Char(1) Inz;
       Dcl-S $RTNCD Char(1) Inz;
       Dcl-S ##COL Like(#CCOL) Inz;
       Dcl-S ##PSSR Char(1) Inz;
       Dcl-S ##ROW Like(#CROW) Inz;
       Dcl-S #TIME Packed(12) Inz;
       Dcl-S @CBAT Packed(3) Inz;
       Dcl-S @RETRN Char(6) Inz;
       Dcl-S AFuel_Err_Cnt Packed(3) Inz;
       Dcl-S AFuel_Req_Fnd Char(1) Inz;
       Dcl-S Ad_Fuel_RRN Packed(4) Inz;
       Dcl-S AState_Err_Cnt Packed(3) Inz;
       Dcl-S AState_Req_Fnd Char(1) Inz;
       Dcl-S Ad_Mile_RRN Packed(4) inz;
       Dcl-S AXLFND Char(1) Inz;
       Dcl-S BEGODM Packed(7) Inz;
       Dcl-S Bill_RRN Packed(4) Inz;
       Dcl-S BLNKAL Char(1) Inz;

       Dcl-S WK_COUNT1 Packed(3) Inz;
       Dcl-S Rls_Cnt Packed(2) Inz;
       Dcl-S Rls_Flg Char(1) Inz;
       Dcl-S CSKEYD Char(1) Inz;
       Dcl-S CSSBAT Char(7) Inz;
       Dcl-S CSSBOX Char(7) Inz;
       Dcl-S CSSTRP Char(8) Inz;
       Dcl-S Cust_Err_Cnt Packed(3) Inz;
       Dcl-S Code2_Fnd Char(1) Inz;
       Dcl-S Days_Diff Packed(7) Inz;
       Dcl-S DEFRN Packed(4) Inz;
       Dcl-S DEMRN Packed(4) Inz;
       Dcl-S DMADMN Char(4) Inz;
       Dcl-S DMAREA Char(4) Inz;
       Dcl-S DMCNTR Char(4) Inz;
       Dcl-S DMLOCN Char(8) Inz;
       Dcl-S DMNAME Char(24) Inz;
       Dcl-S DMREGN Char(4) Inz;
       Dcl-S DORRN Packed(4) Inz;
       Dcl-S DSACTV Char(1) Inz;
       Dcl-S DSAJAR Char(4) Inz;
       Dcl-S DSBOX Char(7) Inz;

       Dcl-S DSDIVS Char(4) Inz;
       Dcl-S DSSFND Char(1) Inz;
       Dcl-S No_Trp# Char(1) Inz;
       Dcl-S ENDODM Packed(7) Inz;
       Dcl-S FATAL Packed(3) Inz;
       Dcl-S FIRST Char(1) Inz;
       Dcl-S Fuel_Err_Cnt Packed(3) Inz;
       Dcl-S FULL Char(1) Inz;
       Dcl-S Fuel_RRN Packed(4) Inz;
       Dcl-S Grn_Tickt_Fnd Char(1) Inz;
       Dcl-S HBDAT Like(DSBDAT) Inz;
       Dcl-S HBDAT1 Like(DSBDAT) Inz;
       Dcl-S HBSPD Packed(7) Inz;
       Dcl-S HDPC Like(DSDPC) Inz;
       Dcl-S HDPS Like(DSDPS) Inz;
       Dcl-S HDSS Like(DSDSS) Inz;
       Dcl-S HELPDS Char(12) Inz;
       Dcl-S HLD22 Char(1) Inz;
       Dcl-S HTRIP Like(DSHTRP) Inz;
       Dcl-S Tot_Miles Packed(7) Inz;
       Dcl-S HUNIT Like(DSUNIT) Inz;
       Dcl-S LSUNIT Like(DSUNIT) Inz;
       Dcl-S INFRN Packed(4) Inz;
       Dcl-S INMRN Packed(4) Inz;
       Dcl-S LstOdo Packed(7) Inz;
       Dcl-S LASTDT Packed(6) Inz;
       Dcl-S LEFND Char(1) Inz;
       Dcl-S LINFND Char(1) Inz;
       Dcl-S LOOP Char(1) Inz;
       Dcl-S LOOP1 Char(1) Inz;
       Dcl-S LOOP2 Char(1) Inz;
       Dcl-S LOOP3 Char(1) Inz;
       Dcl-S LOOP4 Char(1) Inz;
       Dcl-S LSEL Char(1) Inz;
       Dcl-S List_RRN Packed(4) Inz;
       Dcl-S MCUS Char(1) Inz;
       Dcl-S MIERR Char(1) Inz;
       Dcl-S Mile_Err_Cnt Packed(3) Inz;
       Dcl-S Mile_RRN Packed(4) Inz;
       Dcl-S MRRN Packed(4) Inz;
       Dcl-S MSG# Packed(3) Inz;
       Dcl-S Org_Tickt_Fnd Char(1) Inz;
       Dcl-S OVER Packed(3) Inz;
       Dcl-S PANEL Char(4) Inz;
       Dcl-S PERR Char(1) Inz;

       Dcl-S PODOM Packed(7) Inz;
       Dcl-S PRCFG Char(1) Inz;
       Dcl-S Prompt_Err_cnt Packed(3) Inz;
       Dcl-S PRVDAT Packed(7) Inz;
       Dcl-S PTMDY Packed(6) Inz;
       Dcl-S PTYMD Packed(7) Inz;
       Dcl-S REDISP Char(1) Inz;
       Dcl-S WK_COUNT2 Packed(2) Inz;
       Dcl-S SAVBRN Packed(4) Inz;
       Dcl-S SAVFRN Packed(4) Inz;
       Dcl-S SAVRRN Packed(4) Inz;
       Dcl-S SAV28 Char(1) Inz;
       Dcl-S SAV30 Char(1) Inz;
       Dcl-S SAV68 Char(1) Inz;
       Dcl-S SCRCHG Char(1) Inz;
       Dcl-S SEL# Packed(4) Inz;
       Dcl-S SQSEQ# Like(TMSEQ#) Inz;
       Dcl-S SUSP Packed(3) Inz;

       Dcl-S Tax_Fnd Char(1) Inz;
       Dcl-S TMPBCH Char(7) Inz;
       Dcl-S TMPBOX Char(7) Inz;
       Dcl-S TOLFND Char(1) Inz;
       Dcl-S TOTCAP Packed(4) Inz;
       Dcl-S TRFCNT Packed(2) Inz;

       Dcl-S TSTWT Packed(7) Inz;
       Dcl-S UPACTG Packed(3) Inz;
       Dcl-S UPADMN Char(4) Inz;
       Dcl-S UPALTN Char(4) Inz;
       Dcl-S UPAREA Char(4) Inz;
       Dcl-S UPBGRP Char(2) Inz;
       Dcl-S UPCAT Char(8) Inz;
       Dcl-S UPCUST Char(6) Inz;
       Dcl-S UPDIST Char(4) Inz;
       Dcl-S UPIND1 Char(1) Inz;
       Dcl-S UPLOCN Char(2) Inz;
       Dcl-S UPOWNR Char(4) Inz;
       Dcl-S UPREGN Char(4) Inz;
       Dcl-S UPTYPE Char(8) Inz;
       Dcl-S UPUSE Char(6) Inz;
       Dcl-S UPVCST Char(8) Inz;
       Dcl-S WARN Packed(3) Inz;
       Dcl-S WGTFND Char(1) Inz;
       Dcl-S WKACSC Char(2) Inz;
       Dcl-S WKAFLG Char(1) Inz;
       Dcl-S WKBOXT Char(7) Inz;
       Dcl-S WKCACT Char(8) Inz;
       Dcl-S WKCCUS Char(6) Inz;
       Dcl-S WK_CustErr Char(1) Inz;
       Dcl-S BatchFlag Char(1) Inz;
       Dcl-S BillFlag Char(1) Inz;
       Dcl-S GMTFlag Char(1) Inz(' ');
       Dcl-S CTFLAG Char(1) Inz(' ');
       Dcl-S AccFlag Char(1) Inz;
       Dcl-S WKCTRC Char(3) Inz;
       Dcl-S Wk_Cust6 Char(6) Inz;
       Dcl-S Wk_Cust1 Char(1) Inz;
       Dcl-S Wk_STNUM Packed(2) Inz;

       Dcl-S WKEFLG Char(1) Inz;
       Dcl-S WKFLG Char(1) Inz;
       Dcl-S WKFLG1 Char(1) Inz;
       Dcl-S WKFLG2 Char(1) Inz;
       Dcl-S WKFPG1 Packed(5:1) Inz;
       Dcl-S WKFPG2 Packed(5:1) Inz;
       Dcl-S WKIND Char(1) Inz;
       Dcl-S WKLDF Like(TMLDF) Inz;
       Dcl-S WKLICW Packed(7) Inz;
       Dcl-S WKNME Char(24) Inz;
       Dcl-S WKPRLC Char(1) Inz;
       Dcl-S WKPRSC Char(2) Inz;
       Dcl-S WKSPER Char(1) Inz;
       Dcl-S WKSTNO Packed(2) Inz;
       Dcl-S WKTARE Like(VFTARE) Inz;
       Dcl-S WKFCtr Packed(3) Inz;
       Dcl-S WKTLTR Packed(5:1) Inz;
       Dcl-S WKUOMC Char(1) Inz;
       Dcl-S WRKQTY Packed(5:1) Inz;
       Dcl-S Ctr Packed(4) Inz;
       Dcl-S Fnd_Flg Packed(2) Inz;
       Dcl-S DATA_FND Packed(6) Inz;

       //Copy book for Validate 1 District Number
      /Copy QRPGLECPY,SPV1DSTCB

      ********************************************************************

      //-----------------------------------------------------------------------
      // Main Process
      //-----------------------------------------------------------------------

        // Retrieve the Batch and Acquisition flags
        Exsr Getbatchflg ;
        ExSr GetAccFlag;

        ExSr Dts_Begin;
        ExSr End_Pgm;

       // -----------------------------------------------------------------
       // Routine  :    Getbatchflg                                        *
       // Function : get batch and bill flag from vehtabf                 *
       // -----------------------------------------------------------------
       Begsr  Getbatchflg;

         Clear WRKDESC ;

         Exec Sql Select SHORT_DESC
                    Into :WRKDESC
                    from VEHTABF
                   Where SYSTEM_CODE = 'DTS' and PROGRAM_NAME  = 'DTSTENTR' and
                         FIELD_NAME  = 'BATBILL' and RECORD_STATUS = 'A'
                   Fetch First Row only;

         Select;
         When SQLCODE = 100;
            BATCHFLAG = ' ';
            BILLFLAG = ' ';
         When %Subst((WRKDESC):1:1) =' ';
            BATCHFLAG = ' ';
         When %Subst((WRKDESC):1:1) ='Y';
            BATCHFLAG = 'Y';
         Other;
            BATCHFLAG = 'N';
         EndSl;

         Select;
         When %Subst((WRKDESC):2:1) =' ';
            Billflag  = ' ';
         When %Subst((WRKDESC):2:1) ='Y';
            Billflag  = 'Y';
         Other;
            Billflag  = 'N';
         EndSl;

       Endsr;
SM01   //-----------------------------------------------------------------
SM01   // Routine  :    GetAccFlag;                                       *
SM01   // Function :Get AccFlag from VEHTABF.                            *
SM01   //-----------------------------------------------------------------
SM01   BegSr GetAccFlag;

         Clear WRKDESC;

SM01     Exec Sql Select SHORT_DESC
                    Into :WRKDESC
                    from VEHTABF
SM01               Where  SYSTEM_CODE = 'DTS' and PROGRAM_NAME  = 'DTSTENTR' and
SM01                      FIELD_NAME  = 'ACCFLG' and RECORD_STATUS = 'A'
                   Fetch First Row only ;

SM01     If SqlCode = 0;
SM01        Select;
SM01        When %Subst((WRKDESC):1:1) =' ';
SM01             ACCFLAG = ' ';
SM01        When %Subst((WRKDESC):1:1) ='Y';
SM01             ACCFLAG = 'Y';
            When %Subst((WRKDESC):1:1) ='N';
SM01             ACCFLAG = 'N';
SM01        EndSl;
SM01     EndIf;
SM01     Clear SqlCode;

SM01   EndSr;

      //-----------------------------------------------------------------------
      // Dts_Begin : Process DTS screen
      //-----------------------------------------------------------------------
        BegSr Dts_Begin;

          // Main prompt screen
          Reset FrmLis;    // FrmLis will be set as 'N'
          DSTKTRCVD = 'N';

          // Connect To Remote system
          Exsr @ConnectSr;
          WkRemote = SqlErm;

          // Connect to Local
          Exec Sql Connect Reset;
          WkMachine = SqlErm;

           // Process the DTR record and validate
          Exsr Process_Prompt;
           // Function key F1 or F2
          If *InKa = *On Or *InKb = *On;
             LeaveSr;
          EndIf;
          *In18 = *Off;

           // Batch list of all driver trip reports
          Exsr Batch_List;
           // Function key F1

          Select;
             // Function key F1, Leave the Process
          When *InKa = *On;
             LeaveSr;
             // Trip number is blank, Iter the process
          When DshTrp = ' ';
             Batch_lst = *Off;
             No_Trp# = '1';
             Exsr Dts_Process;
             LeaveSr;
          EndSl;
          Exsr Dts_Process;

        EndSr;
      //-----------------------------------------------------------------------
      // Dts_Process : Process DTS screen
      //-----------------------------------------------------------------------
        BegSr Dts_Process;

          // Main prompt screen
         Dow Pmt_Loop;

          Reset FrmLis;    // FrmLis will be set as 'N'
          If Batch_lst = *On;
            FrmLis  = 'Y';
          EndIf;
          DSTKTRCVD = 'N';

          If No_Trp# = '1';
            // Process the DTR record and validate
            Exsr Process_Prompt;
            If LstFlg = 'Y';
               DspFlg = 'Y';
            Endif;
            // Function key F1 or F2
            If *InKa = *On Or *InKb = *On;
               Leave;
            EndIf;

            If Batch_lst = *Off;
               *In18 = *Off;
            // Batch list of all driver trip reports
               Exsr Batch_List;
               if CONFRM = 'Y';
                 Exsr End_Pgm;
                 Return;
               Endif;
            EndIf;
            // Function key F1

            Select;
               // Function key F1, Leave the Process
            When *InKa = *On;
               Leave;
               // Trip number is blank, Iter the process
            When DshTrp = ' ';
               Batch_lst = *Off ;
               Iter;
            EndSl;
          EndIf;
          No_Trp# = '1';

           // Trip Header with Customer loop
          RntUnt = 'N';
          Reset Cus_loop;            //Cus_loop will be set as '1'
          Dow Cus_Loop;
             // Process customer section of header
            Susp_Flg = '0';
            Exsr Process_Cust_Header;

            Select;
               // Function Key F1, Leave the Process
            When *InKa = *On;
              LeaveSr;
               // Function Key F2, Process the prompt screen
            When *InKb = *On;
              Leave;
            EndSl;

             // State Mileage loop
            Reset Mil_Loop;          //Mil_loop will be set as '1'
            Dow Mil_Loop;

              // Process state mileage
              Exsr Process_State_Mileage;

              Select;
               // Function Key F1, Leave the Process
              When *InKa = *On;
                LeaveSr;
               // Function Key F2, process the Customer Selection screen
              When *InKb = *On;
                Leave;
              EndSl;

              // Additional State Mileage Requirements
              Reset Asr_Loop;       //Asr_Loop will be set as '1'
              Dow Asr_Loop;

                Select;
                When SavRrn > 0;
                  Exsr Prc_Add_State_Mil_Req;  // Process Additional State Mileage Requirements

                  Select;
                  When *InKa = *On;  // Function key F1, Leave the Process
                    LeaveSr;

                  When *InKb = *On;   // Function key F2, process the state mileage screen
                    ASSRN = 1;
                    Leave;
                  Endsl;

                Other;
                  AState_Req_Fnd = No;
                EndSl;

                If Susp_Flg = '0' and WTAXL_Flg = '1' and
                  AState_Req_Fnd = 'N';
                 // Customer,Unit,axle and Weight combination validation using program FMTAXLVLDR
                  Exsr WgtAxl_Vldr;

                  If Susp > 0;
                     *IN33 = *ON;
                     *IN43 = *ON;
                     *IN44 = *ON;
                     Susp_Flg = '1';

                     Select;
                     When *INKG = *ON And *IN07 = *ON;
                       // Do Nothing
                     When *INKB = '1';
                       Mil_Loop = '0';
                       Leave;
                     Other;
                       Leave;
                     EndSl;
                  Endif;
                Endif;

                // Billing Fuel
                Reset Bil_Loop;        //Bil_Loop will be set as '1'
                Dow Bil_Loop;
                  Susp_Flg = '0';
                  // Process fuel billing
                  Exsr Proc_Bill_Fuel;

              // Function Key F1 is pressed, then Leave the Subroutine
              // Function Key F2 is pressed and ASR data Found, then Leave the Biling Process
              // Function Key F2 is pressed and ASR data not Found, then Leave the ASR Process

                  Select;
                  When *InKa = *On;  // Function key F1, Leave the Process
                    LeaveSr;
                  // Function key F2
                  // AState_Req_Fnd = Y --> Additional State Mileage
                  //                        Requirements screen
                  When *InKb = *On and AState_Req_Fnd = 'Y';
                    Leave;
                  // Function key F2
                  // AState_Req_Fnd = N --> State mileage screen
                  When *InKb = *On;
                    Asr_Loop = *Off;
                    Leave;
                  EndSl;

                  // Fuel Purchased
                  Reset Ful_Loop;        //Ful_Loop will be set as '1'
                  Dow Ful_Loop;
                    // Process fuel purchase screen
                    ExSr Proc_Fuel_Purchase;

                    Select;
                    When *InKa = *On;    // Function key F1, Leave the Process
                      LeaveSr;
                    When *InKb = *On;   // Function key F2 - Process Billing Fuel screen
                      Leave;
                    EndSl;

                    // Additional Fuel Purchase Requirements
                    Select;
                    When SavFrn > 0;   // Function key F1, Leave the Process
                      Exsr Proc_Add_Fuel_Req;

                      Select;
                      When *InKa = *On;   // Function key F1, Leave the Process
                         LeaveSr;
                      When *InKb = *On;
                         Iter;
                      Endsl;

                    Other;
                      AFuel_Req_Fnd = No;
                    EndSl;

                    // Write or Update to files.
                    Select;
                    When Mode = 'ADD    ';
                      Exsr Write_Dts_File;
                    When Mode = 'CHANGE ' and Batch_lst = *Off;
                      Exsr Update_Dts_File;
                    When Mode = 'CHANGE ';
                      Exsr Update_Dts_File;
                      WCUST = DSCUST;
                      WCBG = DSCBG;
                      WCDST = DSCDST;
                      WCORP = DSCORP;
                      WUNIT = DSUNIT;
                      WDPC = DSDPC;
                      WDPS = DSDPS;
                      WDSC = DSDSC;
                      WDSS = DSDSS;
                      WKEYDT = DKEYDT;
                      WSEQ = DSSEQ;

                      Select;
                      When SUSP = 0;
                        WERR = 'VALID';
                      When *IN07 = *On And SUSREJ = 'R';
                        WERR = 'REJEC';
                      Other;
                        WERR = 'SUSPE';
                      EndSl;
                    EndSl;

                    // Redisplay prompt.
                    Ful_Loop = *Off;
                    Bil_Loop = *Off;
                    Asr_Loop = *Off;
                    Mil_Loop = *Off;
                    Cus_Loop = *Off;

                  EndDo;
                EndDo;
              EndDo;
            EndDo;
          EndDo;

          DspFlg = 'Y';
          If LstFlg = 'Y' and LSTOPT <> ' ';
            *INKB = '1';
            LOOP1 = *OFF;
            DspFlg = 'N';
          Endif;

         EndDo;

        EndSr;

       //----------------------------------------------------------------------
       // End_Pgm : Exit of the program
       //----------------------------------------------------------------------
        BegSr End_Pgm;
          If %Parms() <> 0;
            PmExit = *Inka;
            PmrTrn = *Inkb;
          EndIf;
          Exsr @DisconnectSr;
          *InLr = *On;
        EndSr;
       //----------------------------------------------------------------------
       // Process_Prompt :-- Process prompt subroutine
       //----------------------------------------------------------------------
       BegSr Process_Prompt;

         In JobRun;

         If BchRun = 'Y' and Bch_Flg <> 'Y';
           ExSr ChkDtaRef;
         EndIf;
         Bch_Flg = 'N';

         // Move Blanks to Customer details before showing Prompt
         DsCusn = *Blanks;                                                    // cust name
         DsCust = *Blanks;                                                    // cust number
         DsCbg = *Blanks;                                                     // bill group
         DsCdst = *Blanks;                                                    // cust distric
         Panel = 'PRMT';

         // DETERMINE IF PROGRAM IS ACCESSED FROM BATCH LOGGING SYSTEM.

         Select;
         When %Parms() = 0 and FRMLIS = 'N';
             *IN20 = *OFF;
             Funmsg = FUN01;
         When %Parms() = 0;
             *IN20 = *ON;
             FUNCLN = *BLANKS;
             FunCln = Fun03;

             // District (Branch), Batch Number, Exit (0 is passed in),
             // Return (0 is passed in).
             // On RETRN to calling program, If PMEXIT=1 (F1 pressed) then
             //    Exit calling program also.
             // On RETRN to calling program, If PMRTRN=0 (Enter pressed from
             //    Fuel Purchased (or Addtn'l Fuel Rqmt) screen) then
             //    return to calling program and get next record if any.
             // On RETRN to calling program, If PMRTRN=1 (Enter pressed from
             //    Fuel Purchased (or Addtn'l Fuel Rqmt) screen) then
             //    return to calling program and Redisplay screen with any
             //    additional records selected still displayed.

               // Program called with 5 parameter
               // If Add allowed (via security), and the batch being accessed
               // from the batch logging system is not full, then set to ADD
               // mode initially, else, set to DISPLAY mode initially.

         When %Parms() = 5 And FrmLis = 'N' And
             *In01 = *ON And Full <> 'Y';
             Exsr Additnl_Fuel_Req;
             *In20 = *Off;
             Funmsg = Fun02;                // Function Key
             FunCln = FunDsp;
             If Mode <> 'ADD    ';
               *Inki = *On;
               ExSr Chg_Mode;
             EndIf;

         When %Parms() = 5 And FrmLis = 'N' And Mode <> 'DISPLAY';
             Exsr Additnl_Fuel_Req;
             *In20 = *Off;
             Funmsg = Fun02;                // Function Key
             FunCln = FunDsp;
             *Inkh = *ON;
             Exsr Chg_Mode;

         When %Parms() = 5 And FrmLis = 'N';
             Exsr Additnl_Fuel_Req;
             *In20 = *Off;
             Funmsg = Fun02;                // Function Key
             FunCln = FunDsp;

         When %Parms() = 5;
             Exsr Additnl_Fuel_Req;
             *In20 = *On;
             FunCln = *Blanks;
             FunCln = Fun03;

             // Program called with 6 parameter
             // Set Change mode initially
         When %Parms() = 6 and *In02 = *On;
             Exsr Additnl_Fuel_Req;

             If $Once <> 'Y';
               DsHtrp = PmTrip;
             EndIf;
             *In20 = *On;

             Mode = 'CHANGE ';
             Clear Chg05;
             Clear Chg07;
             Clear Chg08;
             Clear Chg09;
             Clear Chg11;
             Funmsg = Fun02;
             FunCln = FunChg;

         When %Parms() = 6;
             Exsr Additnl_Fuel_Req;

             If $Once <> 'Y';
               DsHtrp = PmTrip;
             EndIf;

             *In20 = *On;
             Clear DSP06;
             Clear DSP09;
             Clear DSP10;
             Clear DSP11;
             Funmsg = FUN02;
             FunCln = FunDsp;
             *INKH = *On;
             MODE = '       ';
             EXSR Chg_Mode;
         EndSl;

         // Clear Trip, Unit, & Beg.Trip Date (unless F2 pressed from Cust)

         If *INKB = *OFF
           And FRMLIS = 'N';
           Exsr Clear_Prompt;
         EndIf;

         If %Parms() >= 5;
           *INKB = '1';
         Endif;

         *IN32 = *OFF;

         // If Batch no. already filled in, PC on trip number prompt.
         //    BOX NO.
         *In80 = (DSBOX <> *BLANKS);

         // Begin processing loop

         If DspFlg = 'Y';
           LOOP1 = *ON;
         Endif;

         Dow LOOP1 = *ON;
           If TMPBCH <> *BLANK;
             DSBCNO = TMPBCH;
           ENDIF;

           Reset FDtsBat;
           Exec Sql Select BtSts,  BTODTR, BTKDTR, BTVDTR, BTSDTR, BTDDTR
                      into :BTSTS,:BTODTR,:BTKDTR,:BTVDTR,:BTSDTR,:BTDDTR
                      from FdtsBat
                    Where  BtBox = :DsBox and BtBat = :DsBcno
                    Fetch first row only;
           If SqlCode = 0;
              Exsr Batch_Sts_Desc;
           EndIf;
           Clear SqlCode;

           LSUNIT = DSUNIT;

           // Clear message line and write any error messages.

           WRITE MSGCLR;
           WRITE MSGCTL;

           // Write/Read Prompt screen.

           WRITE TITLE;

           *In64 = *On;
           Write PROMPT;
           Read DTSTENTD;
           *In67 = %Eof;

           // Clear Message Subfile (MSGSFL).

           *IN70 = *OFF;

           // Set Off Subfile Field's Reverse Image Indicators.

           *IN40 = *OFF;
           *IN41 = *OFF;
           *IN42 = *OFF;
           *IN43 = *OFF;

           // Set Off Positioning (PC) Indicator.

           *IN80 = *OFF;

           *IN32 = *OFF;
           *IN33 = *OFF;

           #DSRCWT = 0;
           #DSAXLE = 0;
           SUSREJ = *BLANKS;

           Select;
           When Mode = 'ADD' and FRMLIS = 'N';
               Clear ADD05;
               Clear ADD07;
               FunCln = FunAdd;
           When Mode = 'CHANGE' and FRMLIS = 'N';
               Clear CHG05;
               Clear CHG07;
               FunCln = FunChg;
           EndSl;

           // Reset Error Accumulators.
           Exsr Reset_Err_Acc;

           // Process Function Keys

           // F1=Exit
           Select;
           When *Inka = *On;
             SPVEXIT ( CONFRM );
             If ConFrm = 'Y';
               LeaveSr;
             EndIf;

            // F2=Return to Batch Logging Program
           When *Inkb = *On;
             LeaveSr;

            // F4=Window
           When *Inkd = *On;
             ExSr Inquiry_Window;

            // F6=Create New Batch Log
            // F8=Display, F9=Add, F10=Change, or F11=Delete
            // Execute Change Mode ($CMODE) subroutine.
           When *Inkh = *On Or *Inki = *On
             Or *Inkj = *On Or *Inkk = *On;
             Exsr Chg_Mode;

           When *In90 = *On;
            // HELP key pressed.
             ExSr Process_Help;

           When *inKa <> *On;
             // Clear Prompt Error Message Mult. Occur.
             //  Data Structure.
             ExSr Clear_DS;
             // Validate Prompt Screen Input
             ExSr Validate_Prompt;

              // If no errors
                Select;
                When Over = 0 And Susp = 0 And Fatal = 0;
               // If in DELETE mode, leave 25 on and redisplay screen.
               // ELSE
               // Remove ND/PR attributes on Unit,Corp,& Beg. Trip Date fields.

                  // If the Prompt screen must be redisplayed (for Change Mode to
                  // allow change to retrieve unit and beg. trip date data), then
                  // redisplay screen, else exit loop and continue with customer
                  // screen processing.
                  Select;
                  When Mode <> 'DELETE' and ReDisp = 'Y';
                      Clear ReDisp;
                  When Mode <> 'DELETE';        //indicates ReDisp <> 'Y'
                      Loop1 = *Off;
                  EndSl;

                // Add F5=Override to function line if errors exist
                When Fatal = 0 and Susp > 0;
                   *In33 = *On;

                   Select;
                   When FRMLIS = 'N' and Mode = 'ADD';

                     ADD07 = FUNFR(1);
                     If *IN07 = *Off;
                       ADD07 = FUNF(1);
                     EndIf;
                     FunCln = FunAdd;

                   When FRMLIS = 'N' and Mode = 'CHANGE';
                     CHG07 = FUNFR(1);
                     If *IN07 = *Off;
                       CHG07 = FUNF(1);
                     EndIf;
                     FunCln = FunChg;

                   When FRMLIS <> 'N';
                      FunCln = *Blanks;
                      FunCln = Fun04R;
                      If *IN07 = *Off;
                         FunCln = Fun04;
                      EndIf;

                   EndSl;

                When Over > 0 And Susp = 0  And Fatal = 0;
                   *In32 = *ON;

                   Select;
                   When FRMLIS = 'N' and MODE = 'ADD';
                     ADD05 = FUNG(1);
                     FunCln = FunAdd;

                   When FRMLIS = 'N' and MODE = 'CHANGE';
                     CHG0512 = FUNG(1);
                     FunCln = FunChg;

                   When FRMLIS <> 'N';
                     FUNCLN = *BLANKS;
                     Funcln = Fun05;
                   ENDSl;
                EndSl;

                If (Over <> 0 or Susp <> 0 or Fatal <> 0)
                  and (*INKE = *ON Or *INKG = *ON);

                    If *INKG = *ON And *IN07 = *ON;

                      // MOVE SUSPENDED DTR TO SUSPENDED BOX
                      Exsr DTS_Sus_Rej;

                    ENDIF;
                    LeaveSr;
                EndIf;

           Other;

             // Clear Prompt Error Message Mult. Occur.
             //  Data Structure.
             ExSr Clear_DS;
             // Validate Prompt Screen Input
             ExSr Validate_Prompt;
             LeaveSr;
           EndSl;

         EndDo;

       EndSr;
       //************************************************************
       // Additnl_Fuel_Req - Additional Fuel Requirement               *
       //************************************************************
       BegSr Additnl_Fuel_Req;

          *In34 = *On;
          If $Once <> 'Y';
            DsBox = PmBoxn;
            %Subst(DsBox8:1:7) = PmBoxn;
            DsBcno = PmBcno;
            Full = PmFull;
            $Once = 'Y';
          EndIf;

          Clear Hdpc;
          Clear Hdps;
          *Inkb = *Off;

       EndSr;
       //************************************************************
       // Reset_Err_Acc - Reset Error Accumulators                  *
       //************************************************************
       BegSr Reset_Err_Acc;

           Clear OVER;
           Clear SUSP;
           Clear FATAL;
           Clear WARN;

       EndSr;
       //************************************************************
       // Clear_Prompt - CLEAR PROMPT SUBROUTINE                    *
       //************************************************************
       BegSr Clear_Prompt;

         // Clear screen and hidden Trip, Unit, & Beg.Trip Date fields.

         If %Parms() <> 6;
           CLEAR DSHTRP;
         ENDIF;
         CLEAR DSUNIT;
         CLEAR DSCORP;
         CLEAR DSBDAT;
         CLEAR HTRIP;
         CLEAR HUNIT;
         CLEAR HBDAT;

         // Non-Display & Protect Unit,Corp, & Beg.Trip Date (*IN25) when
         // in Display, Change, or Delete modes.

         If MODE <> 'ADD    '
           And MODE <> 'CHANGE ';
           *IN25 = *ON;
         EndIf;

       EndSr;
       //-----------------------------------------------------------------------
       // Clear_DS- Clear prompt message mult. occur DS
       //-----------------------------------------------------------------------
       BegSr Clear_DS;

         For Ctr = 1 To 20;
           %Occur(PRMMSG) = Ctr;
           Clear PrmMsg;
         EndFor;

         // Prompt_Err_cnt = Total number of Prompt screen errors
         Clear Prompt_Err_cnt;

       EndSr;
       //-----------------------------------------------------------------------
       // Batch_Sts_Desc - Assigning Batch Status Description
       //-----------------------------------------------------------------------
       BegSr Batch_Sts_Desc;

         Select;
         When BtSts = 'S';
           WkSts = 'SHIPPED';
         When BtSts = 'O';
           WkSts = 'OPENED ';
         Other;
           WkSts = 'CLOSED ';
         EndSl;

       EndSr;
       //-----------------------------------------------------------------------
       // Validate_Prompt - Validate prompt
       //-----------------------------------------------------------------------
       BegSr Validate_Prompt;

         // BOX / Batch Number cannot be blank.

         If DsBox = *Blanks Or DsbCno = *Blanks;
           *In40 = *On;
           $Msgid = '0019';

           // If Batch Number is blank, but the trip number was keyed in
           // a mode other than ADD, then retrieve the Batch Number and
           // show a different error message to the user.  Redisplay prompt.

           If DshTrp <> *Blanks And Mode <> 'ADD';

               // Right-justify Trip number keyed by the user.
             EvalR DsHTrp = %Trim(DsHTrp);

             Exec Sql Select TmbCno,TmbCno,Tm7a08
                       Into :DsbCno,:TmpBch,:DsBox8
                       From  HdrCsr_A
                       Where TmhTrp = :DshTrp
                       Fetch first row only;
             If SqlCode = 0;
               DsBox = %trim(DsBox8);
               TmpBox = DsBox;
               $Msgid = '0049';
             EndIf;
             Clear SqlCode;
           EndIf;

           ExSr Err_Message;
           // Right-justify and zero fill the BOX number keyed by the user.
           If DsBox <> *Blanks;
              Eval TmpBox = *Zero;
              EvalR TmpBox = %Trim(DsBox);
              EvalR TmpBox = %xlate(' ':'0':TmpBox);
              Eval  DsBox = TmpBox;
              EvalR DsBox8 = %Trim(TmpBox);
           Endif;

           // Right-justify and zero fill the Batch number keyed by the user.
           If DsbCno <> *Blanks;
              Eval TmpBch = *Zero;
              EvalR TmpBch = %Trim(DsBcNo);
              EvalR TmpBch = %xlate(' ':'0':TmpBch);
              EvalR DsBcNo = %Trim(TmpBch);
           Endif;

           LeaveSr;
         Endif;

           // Right-justify and zero fill the BOX number keyed by the user.
         Eval TmpBox = *Zero;
         EvalR TmpBox = %Trim(DsBox);
         EvalR TmpBox = %xlate(' ':'0':TmpBox);
         Eval  DsBox = TmpBox;
         EvalR DsBox8 = %Trim(TmpBox);

           // Right-justify and zero fill the Batch number keyed by the user.
         Eval TmpBch = *Zero;
         EvalR TmpBch = %Trim(DsBcNo);
         EvalR TmpBch = %xlate(' ':'0':TmpBch);
         EvalR DsBcNo = %Trim(TmpBch);

           // BOX/Batch Number must have already been logged in the Batch
           // Logging System.

         Exec Sql Select BtBox, BtBox, BtBat, BtBat, BtSts, BtvDtr,
                         BtsDtr, BtmDtr, BtoDtr, BtkDtr, BtForm, BtdDtr
                    Into :BtBox,:TmpBox,:BtBat,:TmpBch,:BtSts,:BtvDtr,
                         :BtsDtr,:BtmDtr,:BtoDtr,:BtkDtr,:BtForm,:BtdDtr
                    From FDtsBat
                   Where BtBox = :DsBox and BtBat = :DsBcno
                   Fetch first row only;

         Select;
         When SqlCode = 100;
             *IN40 = *ON;
             $Msgid = '0051';
             Exsr Err_Message;

             // Check batch status with mode
         When BtSts = 'S' And Mode <> 'DISPLAY';
             *IN40 = *ON;
             $Msgid = '0193';
             Exsr Err_Message;
         Other;

                 // Retrieve the last sequence number used for this batch/date.
                 //   The sequence number will be reset daily.
             $HSeq = 0;
             Exsr Fetch_Seq_Num;
             If SqlCode = 0;
               $HSeq = TmSeq#;
             Endif;
             Clear SqlCode;

                 // Accumulate # of DTR's already entered for this batch and
                 // compare to the number of DTR's allowed to be entered for
                 // this batch to determine if already Full (when ADDing).
                 //   THE MODIFIED DTR COUNT IS THE MAX DTR'S ALLOWED FOR THE BATCH

             DSTCNT = BTVDTR + BTSDTR;
             DSLNTR = BTMDTR;

               //Assigning the Batch Status Description
             Exsr Batch_Sts_Desc;

               //Verify the Max# of Trips Entered
             Exsr Verify_Trip_cnt;

                 // If no trip number has been keyed, or
                 // if in "ADD" mode and either the unit and/or beginning trip
                 // date was not keyed, then display the list panel showing all
                 // trips listed for this batch. (Info)

             If DshTrp <> *Blanks;

              // Right-justify and blank fill the Trip number keyed by the user.
                 EvalR DsHTrp = %Trim(DsHTrp);

               WKEFLG = 'N';

               Clear Wk_Hdr;
               Exec Sql Select  TmUnit, TmaFm,TmaFy
                          Into :TmUnit,:TmaFm,:TmaFy
                          From  HdrCsr_A
                          Where TmhTrp = :DshTrp
                          Fetch first row only;
               If SqlCode = 0
                 And (Mode = 'CHANGE ' Or Mode = 'DELETE ');

                   If   (BTSTS = 'S')
                     Or (TMAFM < Pr_MM And TMAFM <> 0
                        And TMAFY <= Pr_CYY)
                     Or (TMAFY < Pr_CYY And TMAFY <> 0);
                     *IN40 = *ON;
                     WKEFLG = 'Y';
                    $Msgid = '0193';
                     Exsr Err_Message;
                   EndIf;

               EndIf;

               Clear SqlCode;

               //  Right Justify Unit Field.

               Select;
               When DsUnit <> *Blanks;
                 EvalR DsUnit = %Trim(DsUnit);
               When Mode <> 'ADD' And Mode <> 'CHANGE';
                 DsUnit = TmUnit;
               EndSl;

               // Clear Status indicator on screen (Suspended or Valid).
               CLEAR STATUS;

               // ADD Mode Validation.

               If Mode = 'ADD';
                  ExSr Add_Validation;
                  LeaveSr;
               EndIF;
               ExSr Other_Mode_Validation;       //Mode <> 'ADD'
             EndIf;
         EndSl;
         Clear SqlCode;

       EndSr;
       //----------------------------------------------------------------------------
       // Fetch_Seq_Num - Get Sequence Number for FDTSHDR file
       //----------------------------------------------------------------------------
       BegSr Fetch_Seq_Num;

          Exec Sql Select TmSeq# Into :TMSEQ# from HdrCsr_A
                   Where Tm7a08 = trim(:DsBox8) and TmBcno = :DsBcno
                     and TmpYy  = :Cur_Cyy7 and TmpMm  = :Cur_Mm7
                     and TmpDd  = :Cur_Dd7
                   Order By Tm7a08,TmBcno,TmpYy,TmpMm,TmpDd,TmSeq# Desc
                   Fetch first row only;

       EndSr;
       //----------------------------------------------------------------------------
       // DTS_Sus_Rej - Moving Suspended DTR to Suspended Box
       //             - Assuming Batch Status as Open if DTR is not in Rejected State
       //----------------------------------------------------------------------------
       BegSr DTS_Sus_Rej;

         REJ = ' ';
         If Wk_BegDat7 < Today_2Yr;
           REJ = 'R';
         ENDIF;

         DTSTSSRR ( SUSREJ : REJ );

         // MOVE SUSPENDED DTR TO SUSPENDED BOX
         If SUSREJ <> 'R';
           DSBOX = TMPBOX;
           WkSts = 'OPENED ';
           DSBCNO = TMPBCH;
         ENDIF;

       EndSr;
       //-----------------------------------------------------------------------
       // Verify_Trip_cnt - Verify whether Max # of Trips entered for this batch
       //                   or to Verify whether the Batch is Full or not
       //-----------------------------------------------------------------------
       BegSr Verify_Trip_cnt;

         FULL = NO;
         If BTODTR = BTKDTR;
            FULL = 'Y';
         EndIf;

       EndSr;
       //---------------------------------------------------------------------
       // Other_Mode_Validation : Display, Change, or Delete mode selection
       //---------------------------------------------------------------------
        BegSr Other_Mode_Validation;
           // Retrieve Header data by Branch(from Batch Log),
           // Batch number keyed, and Trip number keyed.

           Reset Wk_Hdr;

           Exec Sql Select TMCUST, TMCORP, TMUNIT, TMCDST, TM4A01,
                           TMBDAT, TMSEQ#, TMCBG, TMDPC, TMDPS, TMDSC,
                           TMDSS, TMERR, TMPMM, TMPDD, TMPYY, TMKYU
                      into :TMCUST, :DSCORP, :HUNIT, :TMCDST, :EFlag,
                           :TMBDAT, :DSSEQ, :TMCBG, :TMDPC, :TMDPS,
                           :TMDSC, :TMDSS, :TMERR, :Wk_MM7, :Wk_DD7,
                           :Wk_CYY7, :TMKYU
                      from HdrCsr_A
                     Where TM7A08 = :DSBOX And TMBCNO = :DSBCNO And
                           TMHTRP = :DSHTRP
                     Fetch first row only;

           // Trip must already exist in Display, Change, or Delete modes.

           Select;
           When SqlCode = 0 and DSUNIT = LSUNIT;
              DSUNIT = HUNIT;
           When SqlCode <> 0;
              *IN41 = *ON;
              $Msgid = '0053';
              Exsr Err_Message;
              LeaveSr;
           EndSl;

           // Retrieve Date Keyed and Sequence #.
           If Wk_Date7 > 0;
             Wk_Date10 = %Date(Wk_Date7:*CYMD);
             DKeyDt = %Dec(Wk_Date10:*MDY);
           Else;
             Wk_Date10 = %Date('0001-01-01');
             DKeyDt = 0;
           Endif;

           // Retrieve status of trip
           Clear Status;
           Select;
           When TMERR = 'Y';
              STATUS = 'SUSPENDED';
           When TMERR = 'R';
              STATUS = 'REJECTED';
           Other;
              STATUS = 'VALID';
           EndSl;

            // If Delete mode, clear Delete Confirmation screen and write
            // Trip record to be deleted.

           Select;
           When Mode = 'DELETE';
              Exsr Clear_Dlt_Sf;
              CLEAR DEL_RRN;

              DSCUST = TMCUST;
              DSCBG  = TMCBG;
              DSCDST = TMCDST;
              Beg_Date7 = TMBDAT;

              If TMBDAT > 0;
                Wk_Date10 = %Date(TMBDAT:*CYMD);
                DsBDat = %Dec(Wk_Date10:*MDY);
              Else;
                Wk_Date10 = %Date('0001-01-01');
                DsBDat = 0;
              Endif;

              DSDPC = TMDPC;
              DSDPS = TMDPS;
              DSDSC = TMDSC;
              DSDSS = TMDSS;
              DSERR = STATUS;
              DEL_RRN = DEL_RRN + 1;
              WRITE DELSFL;
              If *In11 = *ON
               And WKEFLG = 'N';
                   Exsr Delete_Prompt;
              EndIf;

                   // Load panel with unit from file since this field
                   // is not initially keyed in Display, Change, or Delete modes.

                   // Load panel with beginning trip date from file since this field
                   // is not initially keyed in Display, Change, or Delete modes.

                   // Also needs to be reformatted from CYYMMDD to MMDDYY.

           When DSHTRP <> HTRIP And FRMLIS <> 'Y';

                HTRIP = DSHTRP;
                Beg_Date7 = TMBDAT;

                If TMBDAT > 0;
                  Wk_Date10 = %Date(TMBDAT:*CYMD);
                  DsBDat = %Dec(Wk_Date10:*MDY);
                Else;
                  Wk_Date10 = %Date('0001-01-01');
                  DsBDat = 0;
                Endif;

                HBDAT = DSBDAT;

                // If new trip input, force screen to redisplay when in change mode.

                If MODE = 'CHANGE' And FRMLIS = 'N';
                   REDISP = 'Y';
                EndIf;
                Eval HKYU = TMKYU;
           EndSl;

              // CHANGE MODE VALIDATION
              // VALIDATE ON 2ND TIME THROUGH ONLY.

           If MODE = 'CHANGE' and REDISP <> 'Y';

                 // Validate Unit Number.
              EXSR Valid_Unit;

                 // Validate Beginning Trip date.
              If DSBDAT <> HBDAT or DSBDAT <> HBDAT1;
                 HBDAT1 = DSBDAT;
                 Wk_DATE6 = DSBDAT;
                 EXSR Validate_Date;
                 Beg_Date7 = Wk_BegDat7;
              EndIf;
           EndIf;
        EndSr;
       //---------------------------------------------------------------------
       // Add_Validation :
       //---------------------------------------------------------------------
        BegSr Add_Validation;
          Clear DkeYdt;
          Clear DsSeq;

          // A new trip cannot be added to a batch that is already full.
          If Full = 'Y';
            *In40 = *On;
            $Msgid = '0054';
            Exsr Err_Message;
            LeaveSr;
          EndIf;

          Exsr Edit_Trip;
          If *In41 = *Off;

              // A new trip must have a unique trip number.
              // unless it is not a rejected trip

             Exec Sql Select (1) into :Data_Fnd from HdrCsr_A
                       Where TmhTrp = :DshTrp
                       Fetch First row only;

             If SqlCode <> 0;
                Exec Sql Select (1) into :Data_Fnd from MileCsr_A
                         Where TmsTrp = :DshTrp
                               Fetch First row only;
                If SqlCode <> 0;
                   Exec Sql Select (1) into :Data_Fnd from FuelCsr_A
                            Where TfTrip = :DshTrp
                                  Fetch First row only;
                EndIf;
             EndIf;

             If SqlCode = 0;
               *In41 = *ON;
               $Msgid = '0052';
               Exsr Err_Message;
               LeaveSr;
             EndIf;

             Clear SqlCode;

             Exec Sql Select TM7A08,TMBCNO,TMERR
                        into :TM7A08,:TMBCNO,:TMERR
                        from HdrCsr_A
                       Where TmhTrp = :DshTrp
                       Fetch First row only;

             Select;
             When SqlCode = 0 And (TMERR <> 'R' Or DSBOX = WKBOXT);
                WKBOXT = TM7A08;
                *IN41 = *ON;
                $Msgid = '0052';
                EXSR Err_Message;
             When SqlCode = 0;
                *IN41 = *ON;
                $Msgid = '0030';
                REDISP = 'Y';
                EXSR Err_Message;
             Other;
                // Validate Unit Number and Beginning Trip date.
                Exsr Valid_Unit;
                Wk_DATE6 = DSBDAT;
                Exsr Validate_Date;
                Beg_Date7 = Wk_BegDat7;
                Clear SqlCode;
             EndSl;
          EndIf;

        EndSr;
       //---------------------------------------------------------------------
       // Clear_Dlt_Sf : Clear delete subfile subroutine
       //---------------------------------------------------------------------
        BegSr Clear_Dlt_Sf;
          *In(60) = *On;
          *In(61) = *Off;
          *In(62) = *Off;
          *In(63) = *Off;
          *In(64) = *Off;
          *In(65) = *Off;
          *In(66) = *Off;
          *In(67) = *Off;
          *In(68) = *Off;
          *In(69) = *Off;
          Write DelCtl;
          *In(60) = *Off;
          *In(61) = *Off;
          *In(62) = *On;
          *In(63) = *On;
          *In(64) = *Off;
          *In(65) = *Off;
          *In(66) = *Off;
          *In(67) = *Off;
          *In(68) = *On;
          *In(69) = *Off;
        EndSr;
       //---------------------------------------------------------------------
       // Edit_Trip - EDIT TRIP NUMBER                                 *
       //---------------------------------------------------------------------
       BegSr Edit_Trip;

         // EDIT TRIP NO. FOR SPECIAL CHARACTERS

         CLEAR TRP;
         WK_COUNT1 = 1;
         Dou WK_COUNT1 > 8;
         TRP(WK_COUNT1) = %subst(DSHTRP:WK_COUNT1:1);
         WK_COUNT1 = WK_COUNT1 + 1;
         EndDo;
         WK_COUNT1 = 1;
         Exit_Match_Fl = 'N';
         BLNKAL = 'Y';
         Dou Exit_Match_Fl = 'Y'
           Or WK_COUNT1 > 8;

           // FIRST POSITION YOU HIT IS NOT A BLANK THEN SET THE BLANK
           // ALLOWED FLAG TO A NO --- BECAUSE YOU CANNOT HAVE EMBEDDED ' 'S

           If TRP(WK_COUNT1) <> ' ';
             BLNKAL = 'N';
           ENDIF;

           Select;
           When TRP(WK_COUNT1) >= 'A'
             And TRP(WK_COUNT1) <= 'Z'
             And TRP(WK_COUNT1) <> WKCHAR
             And TRP(WK_COUNT1) <> WKCHAR1
             Or TRP(WK_COUNT1) >= '0'
             And TRP(WK_COUNT1) <= '9';
                           //Do Nothing

           When TRP(WK_COUNT1) = ' '
               And BLNKAL = 'N'
               Or TRP(WK_COUNT1) <> ' ';
               *IN41 = *ON;
               $Msgid = '0029';
               EXSR Err_Message;
               Exit_Match_Fl = 'Y';
           ENDSl;

           WK_COUNT1 = WK_COUNT1 + 1;
         ENDDO;

       EndSr;
       //-----------------------------------------------------------------------
       // Delete_Prompt - Delete prompt subroutine
       //-----------------------------------------------------------------------

       BegSr Delete_Prompt;

         // Begin processing loop

         LOOP3 = *ON;
         Dow LOOP3 = *ON;

           // Clear message line and write any error messages.

           WRITE MSGCLR;
           WRITE MSGCTL;

           // Write/Read Prompt screen.

           DEL_RRN = 1;
           WRITE DELFUN;

           *In64 = *On;
           WRITE DELCTL;
           READ DTSTENTD;
           *In67 = %Eof;

           // Clear Message Subfile (MSGSFL).

           *IN70 = *OFF;

           // Process Function Keys

           // F1,F4 are invalid from delete confirmation.

           Select;
           When *INKA = *ON Or *INKD = *ON;
             $Msgid = '0097';
             EXSR Err_Message;

             // F2 - Send message that deletion was cancelled and return.
           When *INKB = *ON;
             $Msgid = '0017';
             EXSR Err_Message;
             LeaveSr;

               // HELP key pressed.
           When *IN90 = *ON;
             EXSR Process_Help;

           Other;
                 // Process every record on the Delete Confirmation screen.
                 LOOP3 = *OFF;
                 WKFLG = 'N';
                 CHAIN DEL_RRN DELSFL;

                 Dow %Found();
                   *IN67 = *OFF;

                   If  #PSFSI = '01218';
                     LOOP3 = *ON;
                     *IN67 = *ON;
                     If WKFLG <> 'Y';
                       $Msgid = '0014';
                       EXSR Err_Message;
                       WKFLG = 'Y';
                     EndIf;

                   EndIf;

                   UPDATE DELSFL;
                   DEL_RRN = DEL_RRN + 1;
                   CHAIN DEL_RRN DELSFL;
                 EndDo;
                 *IN67 = *OFF;

                 DEL_RRN = 1;
                 If LOOP3 = *OFF;
                   CHAIN DEL_RRN DELSFL;
                   Dow %Found();

                     // If batch logging record in use by another job, send message.

                     //  Retrieve Details from file FDTSBAT
                     BtBox = Dsbox;
                     BtBat = Dsbcno;

                     Exec Sql Declare Batch_Csr Cursor for
                              Select BTVDTR,BTSDTR,BTDDTR,BTODTR,
                                     BTKDTR,BTMDTR,BTSTS, BTDCLO,
                                     BTDCOM, BTTCLO, BTCCOM
                                From FDTSBAT
                               Where BtBox = :BtBox and BtBat = :BtBat
                               Fetch first row only FOR UPDATE;

                     Exec Sql Open Batch_Csr;

                     If SqlCode = -913;
                       LOOP3 = *OFF;
                       $Msgid = '0002';
                       EXSR Err_Message;
                       Leave;
                     Endif;

                     If SqlCode = 0;
                        Exec Sql Fetch Batch_Csr
                                  into :BTVDTR,:BTSDTR,:BTDDTR,:BTODTR,
                                       :BTKDTR,:BTMDTR,:BTSTS, :BTDCLO,
                                       :BTDCOM,:BTTCLO,:BTCCOM;
                        If SqlCode <> 0;
                          Exec Sql Close Batch_Csr;
                          Leave;
                        Endif;

                       // Show successful delete message on return to prompt screen.
                       $Msgid = '0018';
                       EXSR Err_Message;

                       // Update the Batch Logging records fields that keep track of
                       // how many trips have been entered.
                       Select;
                       When DSERR = 'VALID';
                           BTVDTR = BTVDTR - 1;
                       When DSERR = 'SUSPE';
                           BTSDTR = BTSDTR - 1;
                       Other;
                           BTDDTR = BTDDTR - 1;
                       EndSl;

                       BTKDTR = BTKDTR - 1;

                       // IF BATCH LOG ALREADY SENT -
                       // SET COMMUNICATION FIELDS TO UPDATE TO CORP.


                       // Recheck if Batch is now full after adding a record.
                       // This is done to determine if Prompt screen will be redisplayed
                       // in ADD mode again.  If FULL, it will be changed to display mode.


                     //Verify the Max# of Trips Entered
                       Exsr Verify_Trip_cnt;

                       #Time = %Dec(%Time());

                    //Populate FDTSBAT columns before updation
                       Exsr Populate_Batch_Cols;

                    //Assigning the Batch Status Description
                       Exsr Batch_Sts_Desc;

                       // Update Batch Logging file.
                    Exec Sql Update FDTSBAT
                             set BTVDTR=:BTVDTR, BTSDTR=:BTSDTR, BTDDTR=:BTDDTR,
                                 BTKDTR = :BTKDTR, BTDFIN = :Today_7,
                                 BTTFIN = :#TIME, BTLCIN = :LDINIT,
                                 BTLCDT = :Today_7, BTLCTM = :#TIME,
                                 BTSTS = :BTSTS, BTDCLO = :BTDCLO,
                                 BTTCLO = :BTTCLO, BTDCOM = 0, BTCCOM = ' '
                              Where Current of Batch_Csr;

                       // Re-Lock Batch Logging file.

                       Exsr Update_Box_File;

                       // If Source Field indicates a 'Y', fuel was either selected from
                       // the Fuel ticket file or indicates that a fuel ticket was
                       // included with the Driver Trip Report. If fuel is found in the
                       // fuel ticket file, the record must be updated by removing the
                       // Used (U) indicator in the TF2A01 field so that this record
                       // is able to be used again with other trips.

                       // Connect To Remote system
                       Exec Sql Set Connection :WkRemote;
                       Exec Sql Update FfuelTkt a
                                   Set FtuDtr = ' ',
                                       FtTrpA = ' ',
                                       FtTrpD = '0001-01-01-00.00.00.000000'
                                 Where FtTrpA = :DSHTRP and FtuDtr in ('C','U');
                       Clear SqlCode;

                       // Connect To Local
                       Exec Sql Set Connection :WkMachine;

                       Exec Sql Update FMTTKTF
                                   set FTUDTR = ' ', FTTRPA = ' ',
                                       FTTRPD = '0001-01-01-00.00.00.000000'
                                 Where FTTRPA = :DSHTRP and FtuDtr in ('C','U');

                       Exec Sql Delete From FuelCsr_A
                                      Where TFTRIP = :DshTrp;
                       Clear SqlCode;

                       // Delete all Mileage records associated with this trip number.

                       Exec Sql Delete From MileCsr_A
                                Where TMSTRP = :DshTrp;

                       // After all the Mileage and Fuel have been deleted, then
                       // delete the Header record associated with this trip number.
                     Exec Sql Select TmErr, TmaFy, TmaFm, (1)
                                into :TmErr, :TmaFy, :TmaFm, :Data_Fnd
                                from HdrCsr_A
                               Where TmhTrp = :DSHTRP
                               Fetch first row only;

                       If SqlCode = 0;
                         If TmErr = 'R';
                           PRCFG = 'D';
                           ExSr Rejected_Trips;
                         EndIf;
                         Exec Sql Delete from HdrCsr_A
                               Where TmhTrp = :DSHTRP;

                         Exec Sql Delete from FDTSCSTSF
                               Where TmhTrp = :DSHTRP;

                         Exec Sql Update FDTSBAT
                                     set BTMDTR = BTMDTR + 1
                                   Where Current of Batch_Csr;
                       EndIf;
                       // Override Error file
                       // Remove any previous override errors
                       Exec Sql Delete from FdtsErr
                                 Where OVBOX = :DsBox  and OVBCH = :DsBcno
                                       and OVTRIP = :DshTrp;
                       Clear SqlCode;

                       DEL_RRN = DEL_RRN + 1;
                       CHAIN DEL_RRN DELSFL;
                     EndIf;
                     Exec Sql Close Batch_Csr;
                   EndDo;
                 EndIf;
           EndSl;
         EndDo;

       EndSr;
       //-----------------------------------------------------------------------
       // Fetch_Batch_Details - Get details from file FDTSBAT
       //-----------------------------------------------------------------------
       BegSr Fetch_Batch_Details;

          Exec Sql Select BTVDTR, BTSDTR, BTDDTR, BTODTR, BTKDTR, BTMDTR,
                          BTSTS, BTDCLO, BTDCOM, BTTCLO, BTCCOM
                     into :BTVDTR,:BTSDTR,:BTDDTR,:BTODTR,:BTKDTR,:BTMDTR,
                          :BTSTS, :BTDCLO,:BTDCOM,:BTTCLO,:BTCCOM
                     FROM FDTSBAT
                    Where BtBox = :BtBox and BtBat = :BtBat
                    Fetch first row only;

       EndSr;
       //-----------------------------------------------------------------------
       // Populate_Batch_Cols - Populate FDTSBAT columns before updation
       //-----------------------------------------------------------------------
       BegSr Populate_Batch_Cols;

          @CBAT = 0;

          Select;
          When BTODTR = BTKDTR And BTSDTR = 0 And BTSTS = 'O';
                @CBAT = 1;
                BTSTS = 'C';
                BTDCLO = Today_7;
                BTTCLO = #Time;
          When BTODTR = BTKDTR And BTSDTR = 0;
             //Skip
          When BTSTS = 'C';
             @CBAT = -1;
             BTSTS = 'O';
             BTDCLO = 0;
             BTTCLO = 0;
          ENDSl;

       EndSr;
       //-----------------------------------------------------------------------
       // Transfer_Batch - Transfer DTR to a different Batch or Box
       //-----------------------------------------------------------------------
       BegSr Transfer_Batch;

         //  Retrieve Details from file FDTSBAT
         BtBox = DSBOX;
         BtBat = DSBCNO;
         Exsr Fetch_Batch_Details;

         WK_COUNT2 = 1;

         // Process every record on the TRANSFER
         Dow WK_COUNT2 <= TRFCNT;
           CSSTRP = CSS(WK_COUNT2);
           Exec Sql Select TMPYY,TMPMM,TMPDD,TMEDAT
                      Into :TMPYY ,:TMPMM ,:TMPDD, :TMEDAT
                      From HdrCsr_A
                    Where Tmhtrp = :CSSTRP
                    Fetch first row only;

           If SqlCode = 0;
             SQSEQ# = 0;
             Exec Sql Select Max(TMSEQ#) into :SQSEQ# from HdrCsr_A
                        where TM7A08 = :CSSBOX  and TMBCNO = :CSSBAT and
                              TMPYY  = :TMPYY   and TMPMM  = :TMPMM  and
                              TMPDD  = :TMPDD
                        Fetch first row only;
             Clear SqlCode;

                 // Get the last Seq# for the Batch within the Box

             %Subst(TM7A08:1:7) = CSSBOX;

             Exec Sql Update HdrCsr_A
                         set TMSEQ# = :SQSEQ#+1,TMBCNO = :CSSBAT,
                             TM7A08 = :TM7A08
                       Where TMHTRP = :CSSTRP;
             Clear SqlCode;
             // Modify the VEHMTRT file
             ExSr Mod_VEHMT;
           ENDIF;
           Clear SqlCode;

           // Update the Batch Logging records fields that keep track of
           // how many trips have been entered.
           BTSDTR = BTSDTR - 1;
           BTKDTR = BTKDTR - 1;

           If DSBOX <> CSSBOX or DSBCNO <> CSSBAT;
             BTMDTR = BTMDTR - 1;
           ENDIF;

           WK_COUNT2 = WK_COUNT2 + 1;
         ENDDO;

         // IF BATCH LOG ALREADY SENT -
         // SET COMMUNICATION FIELDS TO UPDATE TO CORP.

         // Recheck if Batch is now full after adding a record.
         // This is done to determine if Prompt screen will be redisplayed
         // in ADD mode again.  If FULL, it will be changed to display mode.

       //Verify the Max# of Trips Entered
         Exsr Verify_Trip_cnt;

         // Month,Day,Year Finished.
         #Time = %Dec(%Time());

         //Populate FDTSBAT columns before updation
         Exsr Populate_Batch_Cols;

         //Assigning the Batch Status Description
         Exsr Batch_Sts_Desc;

         Exec Sql Update FDTSBAT
                  set BTSDTR=:BTSDTR, BTKDTR=:BTKDTR, BTMDTR=:BTMDTR,
                      BTDFIN = :Today_7, BTTFIN = :#TIME,BTLCIN = :LDINIT,
                      BTLCDT = :Today_7, BTLCTM = :#TIME,BTSTS = :BTSTS,
                      BTDCLO = :BTDCLO, BTTCLO = :BTTCLO,
                      BTDCOM = 0, BTCCOM = ' '
                Where BtBox = :Dsbox and BTBAT = :DSBCNO;

         Exsr Update_Box_File;

         Exec Sql Update FDTSBAT
                     set BTSDTR = BTSDTR + :TRFCNT,
                         BTKDTR = BTKDTR + :TRFCNT
                   Where BtBox = :CSSBOX and BTBAT = :CSSBAT;
         Clear SqlCode;
       EndSr;
       //-----------------------------------------------------------------------
       // Chg_Mode -  Change Operating Mode
       //-----------------------------------------------------------------------

       BegSr Chg_Mode;
         // Fuction key F8
         Select;
         When *InKh = *On and Mode = 'DISPLAY';
             $Msgid = '0098';
             ExSr Err_Message;
         When *InKh = *On;
             Mode = 'DISPLAY';
             FunCln  = FunDsp;
             *In24 = *Off;
             *In25 = *On;
             *In27 = *On;
             Clear Htrip;
             Clear DsUnit;
             Clear DsCorp;
             Clear DsbDat;
          // Fuction key F9
         When *InKi = *On and Mode = 'ADD    ';
             $Msgid = '0098';
             Exsr Err_Message;
         When *InKi = *On and BtSts = 'S';
             $Msgid = '0193';
             Exsr Err_Message;
         When *InKi = *On and Full = 'Y';
             *In25 = *On;
             $Msgid = '0054';
             Exsr Err_Message;
         When *InKi = *On;
             Mode = 'ADD    ';
             FunCln = FunAdd;
             *In24 = *On;
             *In25 = *Off;
             *In27 = *Off;
             Clear Htrip;
             Clear DsUnit;
             Clear DsCorp;
             Clear DsbDat;
             Clear DsDpc;
             Clear DsDps;
             Clear DsDsc;
             Clear DsDss;
             Clear HdPc;
             Clear HdPs;
             Clear Hdss;
           // Function key F10
         When *InKj = *On and Mode = 'CHANGE ';
             $Msgid = '0098';
             ExSr Err_Message;
         When *InKj = *On and BtsTs = 'S';
             $Msgid = '0193';
             ExSr Err_Message;
         When *InKj = *On;
             Mode = 'CHANGE ';
             FunCln = FunChg;
             *In24 = *Off;
             *In25 = *Off;
             *In27 = *Off;
             Clear Htrip;
             Clear DsUnit;
             Clear DsCorp;
             Clear DsBdat;
           // Function key F11
         When *Inkk = *On and Mode = 'DELETE ';
             $Msgid = '0098';
             ExSr Err_Message;
         When *Inkk = *On and BtsTs = 'S';
             $Msgid = '0193';
             ExSr Err_Message;
         When *Inkk = *On;
             Mode = 'DELETE ';
             FunCln = FunDlt;
             *In24 = *Off;
             *In25 = *On;
             *In27 = *Off;
             Clear Htrip;
             Clear DsUnit;
             Clear DsCorp;
             Clear DsbDat;
         EndSl;
         // If this program called from batch logging program (34=ON),
         // then show (allow) F2 function on Prompt panel.

         Funmsg = FUN02;
         If *IN34 = *OFF;
           Funmsg = FUN01;
         EndIf;
       EndSr;
       //-----------------------------------------------------------------------
       // VALIDATE VEHICLE SUBROUTINE
       //-----------------------------------------------------------------------
       BegSr Valid_Unit;
         $Oleas = 'N';

           // Unit cannot be blank.
         If DsUnit = ' ';
           *IN42 = *ON;
           $Msgid = '0056';
           ExSr Err_Message;
           LeaveSr;
         EndIf;

           //  Right Justify Unit Field.
         EvalR DsUnit = %Trim(DsUnit);

           // The unit number keyed must exist in the Vehicle Master file.
         RecExist = 'Y';

         Reset FvehFil;
         Exec Sql Select VfUnit, VfUse,  VfCat,  VfCusn,  VfCust,  VfCorp,
                         VfFuel, VfAxls, VfDist, VfTank, VfnTnk,  Vf9n72,
                         VfTare, VfVcst, Vfsldt, Vfadmn, Vfclis
                  Into  :VfUnit, :VfUse, :VfCat, :VfCusn, :VfCust, :VfCorp,
                        :VfFuel, :VfAxls,:VfDist,:VfTank, :VfnTnk, :Vf9n72,
                        :VfTare, :VfVcst, :Vfsldt, :Vfadm, :Vfclis
                  From  FvehFil a, FTCXREFDF b
                 Where  VfUnit = :DsUnit and VfCorp not in(Select DXXCOR
                        From FTCXREFDF)
                 Fetch first row only;

         If SqlCode <> 0;
            Clear SqlCode;
            *In42 = *ON;
            $Msgid = '0056';
            ExSr Err_Message;
            RecExist = 'N';
         EndIf;

         If RecExist = 'Y';
            // Check to see if this was a unit from an Acquisition
            Exsr Acq_Unit;

            ExSr Vecap_Data;
            If RecExist = 'E';
               *In42 = *ON;
               $Msgid = '0056';
               ExSr Err_Message;
               Clear SqlCode;
               RecExist = 'N';
            EndIf;
         EndIf;

         Select;
            // Validate vehicle use.
         When VFUSE <> 'LEASE' And VFUSE <> 'RENTAL' And
              VFUSE <> 'CMAINT' And VFUSE <> 'SERV' And
              VFUSE <> 'FINLS' And VFUSE <> 'POOL' And RecExist = 'Y';
               *IN42 = *ON;
               $Msgid = '0057';
               EXSR Err_Message;
               RecExist = 'N';
               DSCORP = VFCORP;
         When RecExist = 'Y';
               DSCORP = VFCORP;
         EndSl;

         // The vehicle must be a truck or tractor.
         // Other vehicle categories (CAR, TRAILER, OTHER) are invalid.

         If VFCAT <> 'TRUCK' And VFCAT <> 'TRACTOR' And
            RecExist = 'Y';
            *IN42 = *ON;
            $Msgid = '0058';
            EXSR Err_Message;
         EndIf;

         // Moving DSCORP to LDA Field to retrieve RA's based on DSCORP
         // in the RA's retrieval program.
         WKCORP = DSCORP;
         Out LDA;

       EndSr;
       //-----------------------------------------------------------------------
       // Validate_Date - Validate date subroutine
       //-----------------------------------------------------------------------
       BegSr Validate_Date;

         WkSPer = *Off;

           // Date cannot be a negative number.
         If Wk_DATE6 < 0;
           *IN43 = *ON;
           $Msgid = '0109';
           EXSR Err_Message;
           LeaveSr;
         EndIf;

         // Validate Date format.
         Monitor;
           Wk_Date10 = %Date(Wk_DATE6:*MDY);
         On-Error;
           WkSPer = *On;

           *IN43 = *ON;
           $Msgid = '0110';
           EXSR Err_Message;
           LeaveSr;
         EndMon;

         Wk_Date7P = %Dec(Wk_DATE10:*CYMD);
         Wk_BegDat7 = %Dec(Wk_Date10:*CYMD);

         // Date cannot be a future date.
         If Wk_Date10 > Today_10;
           WKSPER = *ON;
           *IN43 = *ON;
           $Msgid = '0111';
           Exsr Err_Message;
         EndIf;

         // Date cannot be before the first date allowed.
         If Wk_BegDat7 < Today_2Yr;
           WKSPER = *ON;
           *IN43 = *ON;
           $Msgid = '0458';
           MN0458 = LDAUT1;
           $MDATA = DS0458;
           Exsr Err_Message;
         EndIf;

         // If SOLD, retrieve sold date.
         // Beginning Trip date cannot be after vehicle was sold.

         If VFVCST = 'SOLD' Or VFVCST = 'TERMED';

           If VFSLDT <> 0 And Wk_BegDat7 >= VFSLDT;
             WKSPER = *ON;
             *IN43 = *ON;
             $Msgid = '0113';
             EXSR Err_Message;
           EndIf;
         EndIf;
       EndSr;
       //-----------------------------------------------------------------------
       // Process_Cust_Header - Process custoner section of header subroutine
       //-----------------------------------------------------------------------
       BegSr Process_Cust_Header;

         PANEL = 'CUST';

         // If Display Mode, PROTECT from input.

         *IN26 = *OFF;
         If MODE = 'DISPLAY';
           *IN26 = *ON;
         EndIf;

         AtUnit = DsUnit;
         AtCorp = DsCorp;
         Exsr Fetch_Vehicle_Detail;

         If SqlCode = 0;

           // Get unit of measure
           WKEFLG = *BLANKS;
           WKAFLG = *BLANKS;
           WKPRLC = *BLANKS;
           WKFLG1 = *BLANKS;
           WKFLG2 = *BLANKS;

           SPV1CORP ( VFCORP : WKNME : WKAFLG :
           WKFLG1 : WKFLG2 : WKPRSC : WKACSC :
           WKPRLC : WKEFLG : WKUOMC : WKCTRC );

           If WKEFLG <> '1' And WKAFLG = 'Y' And WKPRLC = 'Y';

             $CNTRY = WKCTRC;
             *IN57 = *Off;
             If WKUOMC = 'M';
               *IN57 = *On;
             ENDIF;
           ENDIF;

         EndIf;

         Clear SqlCode;

         Exsr Clear_Cust_ind;

         // If not returning with a subsequent screen, then fill screen.

         If *INKB = *OFF;
           Exsr Fill_Cust_Header;
         EndIf;

         // Begin processing loop

         Loop2 = *On;
         Dow Loop2 = *ON;

           // Clear message line and write any error messages.

           WRITE MSGCLR;
           WRITE MSGCTL;

           // Write/Read Customer screen.
           If UPUSE = 'POOL'
             And *IN17 = *ON;
             *IN32 = *ON;
           ENDIF;

           If MCUS = 'Y';
             *IN33 = *ON;
           ENDIF;

           WRITE TITLE;
           WRITE CUSTDAT;

           *In64 = *On;
           WRITE CUST;
           READ DTSTENTD;
           *In67 = %Eof;

           Exsr Clear_Cust_ind;

           // Reset Error Accumulators.

           Exsr Reset_Err_Acc;

           // Process Function Keys
           // F1=Exit

           Select;
           When *INKA = *ON;
             SPVEXIT ( CONFRM );
             If CONFRM = 'Y';
               Leave;
             EndIf;

             // F2=Return to Batch Logging Program
           When *InKb = *On;
             Leave;

             // F4=Window
           When *Inkd = *On;
             Exsr Inquiry_Window;

             // HELP key pressed.
           When *In90 = *On;
             Exsr Process_Help;
           Other;

                   // F13 - Supervisor override.

                   // If F13 pressed (Not available in DISPLAY mode), allow supervisor
                   // to enter access code so that her authority (based on security)
                   // will be in place for this screen only.  Once Enter is pressed
                   // from this screen, authority will return to original user.

                   // Clear Customer Error Message Mult. Occur. Data Structure.

             EXSR Clear_Cust_Msg;

                   // Validate Customer.

             CSKEYD = 'Y';
             If DSCUS = *BLANKS;
                CSKEYD = 'N';
             ENDIF;

             If mode <> 'DISPLAY';
                Exsr Validate_Cust;
                ExSr Validate_City;
             EndIf;
                   // If NO ERRORS, continue with next screen.
             Select;
             When Over = 0 and Susp = 0 and Fatal = 0;
                 Leave;

                     // If no FATAL severity errors, then
                     // allow F7 if SUSPEND errors and F5 if only OVERRIDE errors.
                     // ** 5/3/94-DSD-Since the only override errors are controlled
                     //    by LDA indicators, remove the F5 override key.

                   // If ERRORS...
             Other;
               If FATAL = 0 and SUSP > 0;
                  *IN33 = *ON;
               EndIf;

                     // If F5 or F7 pressed, accept errors and continue with next screen.

               Select;
               When *INKE <> *ON And *INKG <> *ON;
                   //Skip

               When *INKG = *ON And *IN07 = *ON;

                   // MOVE SUSPENDED DTR TO SUSPENDED BOX
                   Exsr DTS_Sus_Rej;
                   Leave;
               Other;
                   Leave;

               EndSl;
             EndSl;
           EndSl;
         EndDo;

         // Save cust,bg,dist when adding to compare on next add for
         // determination of positioning the cursor.

         If MODE = 'ADD';
           SAVCUS = DSCUS;
         EndIf;

       EndSr;
       //-----------------------------------------------------------------------
       // Clear_Cust_ind - Clear Subfile Indicators for Customer Screen
       //-----------------------------------------------------------------------
       BegSr Clear_Cust_ind;

         // Initially set off the ability to perform F5 or F7 since
         // validation must be performed before we know if these keys
         // will be required.

         *IN32 = *OFF;
         *IN33 = *OFF;

         // Set Off Subfile Field's Reverse Image Indicators.

         *IN45 = *OFF;
         *IN46 = *OFF;
         *IN47 = *OFF;
         *IN48 = *OFF;
         *IN49 = *OFF;

         // Set Off Positioning (PC) Indicators.

         *IN81 = *OFF;
         *IN82 = *OFF;

         // Clear Message Subfile (MSGSFL).

         *IN70 = *OFF;

       EndSr;
       //-----------------------------------------------------------------------
       // Clear_Cust_Msg - Clear customer message mult. occur DS
       //-----------------------------------------------------------------------

       BegSr Clear_Cust_Msg;

         For Ctr = 1 To 20;
           %Occur(CUSMSG) = Ctr;
           CLEAR CUSMSG;
         EndFor;

         // Cust_Err_Cnt = Total number of Customer screen errors

         Reset Cust_Err_Cnt;

       EndSr;
       //-----------------------------------------------------------------------
       // Fill_Cust_Header - Fill customer section of header subroutine
       //-----------------------------------------------------------------------
       BegSr Fill_Cust_Header;

         SPV1UNIT ( DSCORP : DSUNIT : UPIND1 :
         UPDIST : UPLOCN : UPCUST : UPBGRP :
         UPUSE : UPCAT : UPTYPE : UPVCST : UPACTG
         : Wk_Date7P : UPOWNR : UPADMN : UPALTN :
         UPAREA : UPREGN : Beg_Date7);

         Wk_Date7P = Beg_Date7;
         ExSr Get_CusAdr;

         // Check if trip Begin date matches with Date out

         If Beg_Date7 > 0;
           Wk_BegDt10 = %DATE(Beg_Date7:*CYMD);
         Else;
           Wk_BegDt10 = %Date('0001-01-01');
         Endif;

         Valid = 'N';
         RESULTSET = RESULTSET1;

         Exsr Compare_Begin_Date;

         If $Resultst <>' ' AND
            ($DateOut = Wk_BegDt10 );
           MCUS = 'N';
         Endif;

         IF (UPIND1 = *OFF AND VALID='Y'
           AND UPUSE ='RENTAL') OR
           (UPIND1 = *OFF AND UPUSE <> 'RENTAL');
           Wk_Cust6 = $ACCOUNT;
           Wk_Cust1 = Wk_Cust6;

           Data_fnd = 0;
           Exec Sql Select Count(1) into :Data_fnd from Vehtabf
                     Where PTPGM ='RENCUST' and PTFID ='OFFLEASE' and
                           PTSDS = :UPCUST;
           Select;
           When MODE = 'ADD'
             Or DSUNIT <> HUNIT
             Or DSBDAT <> HBDAT;

             // If found, load customer,bill group, and district to panel.
             // Also, obtain the vehicle USE for validation later.
             DSCUST = $ACCOUNT;
             DSCBG = $Custgrp;
             DSCDST = $DIST;
             DSOBR = $DIST;

             // Validate vehicle use.

             Select;
             When  UPUSE <> 'LEASE'
               And UPUSE <> 'RENTAL'
               And UPUSE <> 'CMAINT'
               And UPUSE <> 'SERV'
               And UPUSE <> 'FINLS'
               And UPUSE <> 'POOL';
               *IN42 = *ON;
               $Msgid = '0057';
               EXSR Err_Message;

               // If vehicle is LEASE AND CUST IS 699999 -- OFF LEASE
             When UPUSE = 'LEASE ' and Data_fnd > 0;
                 RNTUNT = 'Y';
             EndSl;

             If MODE = 'CHANGE';
               If DSUNIT <> HUNIT
                 Or DSBDAT <> HBDAT;
                 *IN45 = *ON;
                 $Msgid = '0008';
                 EXSR Err_Message;
               EndIf;
             EndIf;

           When (UPUSE = 'RENTAL' Or UPUSE = 'SERV' Or (UPUSE = 'LEASE '
                and Data_fnd > 0));

               DSCUST = TMCUST;
               DSCBG = TMCBG;
               DSCDST = TMCDST;
               RNTUNT = 'Y';
           Other;

               DSCUST = TMCUST;
               DSCBG = TMCBG;
               DSCDST = TMCDST;

           EndSl;

           If RNTUNT <> 'Y';
             If WK_CustErr = 'M'
               Or WK_CustErr = 'X';
               CLEAR DSCUST;
               CLEAR DSCBG;
               CLEAR DSCDST;
               MCUS = 'Y';
               $Msgid = '0230';
               EXSR Err_Message;
             ENDIF;
           ENDIF;
         EndIf;

         Select;
         When MODE = 'ADD' and HDPC = *BLANKS;

             // If valid customer was found, and Dep. city is blank
             // (1st entry), then remove PC from Dest. city and PC on Dep. city

             If *IN45 = *OFF
               And *IN46 = *OFF
               And *IN47 = *OFF
               And *IN48 = *OFF
               And *IN49 = *OFF;
               *IN81 = *ON;
             EndIf;

             CLEAR DSDSC;
             CLEAR DSDSS;

         When MODE = 'ADD' And DSCUS = SAVCUS;

             // If the customer from the previously added trip has not
             // changed, then position cursor on destination city, else
             // position cursor on departing city.

             *IN82 = *ON;
             DSDPC = HDPC;
             DSDPS = HDPS;

             CLEAR DSDSC;
             CLEAR DSDSS;

         When MODE = 'ADD';

             *IN81 = *ON;
             DSDPC = HDPC;
             DSDPS = HDPS;

             CLEAR DSDSC;
             CLEAR DSDSS;

         Other;

             DSDPC = TMDPC;
             DSDPS = TMDPS;
             DSDSC = TMDSC;
             DSDSS = TMDSS;
             HDPC = TMDPC;
             HDPS = TMDPS;
             HDSS = TMDSS;

         EndSl;

         // Validate Customer Number.

         ExSr Validate_Cust;

         // If a valid USE, then load L/D/F.

         Wk_Cust1 = DSCUST;

         Select;
         When UPUSE = 'RENTAL'
             Or UPUSE = 'SERV'
             Or DSCUST = '699999'
             Or Wk_Cust1 = '3'
             Or DSCUST = '999999'
             Or Wk_Cust6 = '699999'
             Or Wk_Cust6 = '999999'
             Or UPUSE = 'POOL'
             Or UPCUST = '699999'
             Or UPCUST =  '699998';
             WKLDF = '2';
         When UPUSE = 'CMAINT';
             WKLDF = '3';
         Other;
             WKLDF = '1';
         EndSl;

       EndSr;
       //----------------------------------------------------------------------
       // Compare_Begin_Date - Compare Begin Date with Datein and DateOut
       //----------------------------------------------------------------------
       BegSr Compare_Begin_Date;

         Select;
         // Check if trip Begin date matches with Date out
         When $Resultst <>' ' AND
              ($DateOut = Wk_BegDt10 );
           Valid  = 'Y';

         //If there is no exact match found for Begin date
         //Check if trip Begin date matches between Date in and Date out
         When $Resultst <>' ' AND
             ($DateOut < Wk_BegDt10 ) AND
             (($DateIn  >= Wk_BegDt10  ) OR
             ($DateIn = *Loval));
           Valid = 'Y';
         EndSl;

       EndSr;
       //----------------------------------------------------------------------
       // Acq_Unit - Check VEHACQF file
       //----------------------------------------------------------------------
       BegSr Acq_Unit;

         vtcust = *blanks;
         vtcusn = *blanks;
         XXXXXX_sel = *blanks;
         Acq_Sel = *blanks;
         Hld10 = *off;

         Wk_Date10 = %Date() - %Months(6);
         Wk_Date7P  = %Dec(Wk_Date10:*cymd);

         EvalR Acq_Unit_Key = %trim(dsunit);

         Exec Sql Select AtUnit, AtCorp
                  Into  :AtUnit, :AtCorp
                  From VEHACQF
                  Where  AfUnit = :Acq_Unit_Key
                         and AtcvDt >= :Wk_Date7P and AtUnit <> :DsUnit
JP02                     and Atcorp in
JP02                         (SELECT DMCORP FROM FDSTMST a WHERE
JP02                         SUBSTRING(DMMA02,1,1) = 'Y' and DMBA01 = 'Y' )
                  Fetch first row only;
         If SqlCode <> 0;
           Clear SqlCode;
           LeaveSr;
         EndIf;

         Exsr Fetch_Vehicle_Detail;

         If SqlCode = 0;

            If VfUse <> 'LEASE ' And VfUse <> 'RENTAL' And
               VfUse <> 'CMAINT' And VfUse <> 'SERV'   And
               VfUse <> 'FINLS';
               LeaveSr;
            EndIf;

            If VfCat <> 'TRUCK'  And VfCat <> 'TRACTOR';
               LeaveSr;
            EndIf;

            VtCust = VfCust;
            VtCusn = VfCusn;

            Exec Sql Select BrCust Into :BrCust
                     From   BRTXCUSTF
                     Where  CmCust = :VtCust
                     Fetch First Row only;
            If SqlCode <> 0;
               BrCust = *Zeros;
               Clear SqlCode;
            EndIf;

              // Clear message line and write any error messages.
            Dow True;
              Write MSGCLR;
              Write MSGCTL;
              Hld10 = *In10;
              *In10 = *off;
              If LDAUT2 = 'SP';
                 *In10 = *on;
              EndIf;
              *In64 = *on;
              Write Acq_Screen;
              Read DTSTENTD;
              *In10 = Hld10;
              Select;
              When (XXXXXX_sel <> 'S' And Acq_Sel <> 'S') Or
                   (XXXXXX_sel =  'S' And Acq_Sel =  'S');
                   XXXXXX_sel = *blanks;
                   Acq_Sel = *blanks;
                   $Msgid = '0900';
                   Exsr Err_Message;
                   Iter;
              When Acq_Sel = 'S';
                   DsUnit = VfUnit;          //note1 Chain dsunit Fvehfil removed
                   LeaveSr;
              When XXXXXX_sel = 'S';
                   LeaveSr;
              EndSl;
            EndDo;
         EndIf;

         Clear SqlCode;

       EndSr;
       //-----------------------------------------------------------------------
       // Fetch_Vehicle_Detail - Get Vehicle File details for given Corp and Unit
       //-----------------------------------------------------------------------
       BegSr Fetch_Vehicle_Detail;

          Exec Sql Select VfUnit, VfUse,  VfCat,  VfCusn,  VfCust,  VfCorp,
                          VfFuel, VfAxls, VfDist, VfTank, VfnTnk,  Vf9n72,
                          VfTare, Vfclis
                   Into  :VfUnit, :VfUse, :VfCat, :VfCusn, :VfCust, :VfCorp,
                         :VfFuel, :VfAxls,:VfDist,:VfTank, :VfnTnk, :Vf9n72,
                         :VfTare, :Vfclis
                   From  FvehFil
                   Where  VfUnit = :AtUnit and VfCorp = :AtCorp
                   Fetch first row only;

              // Do not Clear SQLCode, as it is used after Execute of this Subroutine
       EndSr;
       //-----------------------------------------------------------------------
       // Validate_Cust - Validate customer & retrieve name
       //-----------------------------------------------------------------------
       BegSr Validate_Cust;

         If RNTUNT = 'Y' And DSCUS = *BLANKS;
           //******* DO NOT VALIDATE - CUST NO.BILL GROUP/DIST IS RETRIEVED
           LeaveSr;
         ENDIF;

         Clear DsCusn;

         // Validate that customer number is not suspended by Fleet Services
         Exec Sql Select (1) into :Data_Fnd From DTSCNAF
                  Where CnCust = :DsCust and
                        (CnUse = :UpUse or CnUse = ' ')
                  Fetch First Row Only;
         If SqlCode = 0;
            DsCusn = *All'*';
            *In45 = *On;
            $Msgid = '0300';
            ExSr Err_Message;
         EndIf;
         Clear SqlCode;

         WKAFLG = ' ';
         If (UPUse = 'CMAINT' Or UPUse = 'LEASE') and
            DSCust <> ' ' and DSUnit <> ' ' and RNTUNT <> 'Y';

           // Check for the record existance in FFSQUNT file for
           // the Unit and Cust
           Exec Sql Select Count(1) Into :Data_Fnd
                    From FFSQUNT
                    Where (FVCorp = :DSCorp) And
                          (FVCust = :DSCust) And
                          (FVUnit = :DSUnit)
                    Fetch First 1 rows only;

           Select;
           When Sqlcode = 0 and Data_Fnd > 0;
             WKAFLG = 'Y';
           When (Sqlcode <> 0 or Data_Fnd = 0) and Mode <> 'DISPLAY';
             $Msgid = '0502';
             Exsr Err_Message;
           EndSl;
           Clear SqlCode;

         EndIf;


         // 999999 - is used to identify a Daily Service or Rental
         //          customer where no customer number needs to be set up.
         //        - (not on customer master file)
         // Load "DAILY SERVICE OR RENTAL" as the customer name.

         Wk_Cust1 = DSCUST;

         Select;
         When DSCUST = '999999';
            Eval DsCusn = Rent;

           // 699999 - is used to identify an OFF-LEASE customer
           // Load "***********************" as the customer name and give
           // error message that DTR's cannot be entered for OFF-LEASE.
           // A valid customer number is required.

         When DSCUST = '699999' Or DSCUST = '699998';
             DSCUST = *BLANK;
             DSCBG = *BLANK;
             DSCDST = *BLANK;

             // When customer number begins with '6' - identifies a LEASE cust.
             // Validate entire 12 digit customer number

         When Wk_Cust1 = '6';
             Wk_Cust1 = DSCUST;
             Exsr Validate_CustNum;

         Other;
             //Validate Customer Number

             Wk_Cust1 = DSCUST;
             Exsr Validate_CustNum;

             If WK_CustErr <> '1' Or MODE = 'DISPLAY';
                 Wk_Date7P = *ZERO;
                 Callp SPV1DST ( DSCORP : DSCDST : WKIND :
                 DMNAME : DMADMN : DMREGN : DMAREA :
                 DMCNTR : DMLOCN : DSACTV : DSAJAR :
                 DSDIVS : Wk_Date7P );

                 If (WKIND = *ON or Wk_Date7P <> *ZERO);
                   *IN45 = *ON;
                   $Msgid = '0069';
                   EXSR Err_Message;
                 EndIf;

             EndIf;

         EndSl;

         If MODE <> 'DISPLAY';

           SPV1UNIT ( DSCORP : DSUNIT : UPIND1 :
           UPDIST : UPLOCN : UPCUST : UPBGRP :
           UPUSE : UPCAT : UPTYPE : UPVCST : UPACTG
           : Wk_Date7P : UPOWNR : UPADMN : UPALTN :
           UPAREA : UPREGN : Beg_Date7);

           Wk_Date7P = Beg_Date7;
           ExSr Get_CusAdr;

           If Beg_Date7 > 0;
             Wk_BegDt10 = %DATE(Beg_Date7:*CYMD);
           Else;
             Wk_BegDt10 = %Date('0001-01-01');
           Endif;

           Valid = 'N';
           RESULTSET = RESULTSET1;

           Exsr Compare_Begin_Date;

           If UpIND1 = *OFF And Valid = 'Y';
             //      ('UU'fields are returned by SPV1UNIT from FVEHFIL/FVEHTRF.)

             // If VFCUST = '699999' - but DSCUST does not - they keyed a diffe
             // customer - sometimes all edit checks were not performed
             // allowing canadian districts to HPTL units.  This will make sure
             // that does not happen going forward.  The else was performed
             // below assuming cust/bg/dist came back from SPV1Unit and not
             // doing the SPV1DST code at all. Remove the ELSE line and perform
             // check all the time for SPV1DST.

             If VFCUST = '699999';
               $OLEAS = 'Y';
             ENDIF;

             // RENTAL
             If DSCDST <> *BLANKS;
               Callp SPV1DST ( DSCORP : DSCDST : WKIND :
               DMNAME : DMADMN : DMREGN : DMAREA :
               DMCNTR : DMLOCN );

               If WKIND = *ON;
                 *IN45 = *ON;
                 $Msgid = '0069';
                 EXSR Err_Message;
               EndIf;

             ENDIF;
           ENDIF;

           If DSCDST = *BLANKS
             Or DMLOCN <> 'DISTRICT'
             And DMLOCN <> 'BRANCH  '
             And DMLOCN <> 'STATION '
             And UPUSE = 'RENTAL';
             *IN45 = *ON;
             $Msgid = '0069';
             EXSR Err_Message;
           ENDIF;

         ENDIF;
       EndSr;
       //-----------------------------------------------------------------------
       // Validate_CustNum - Validate 12 Digit Customer Number
       //-----------------------------------------------------------------------
       BegSr Validate_CustNum;

         WkCAct = DsCust + DsCBg;
         Wk_Cust6 = WkCAct;
         WKCCUS = *BLANKS;
         SPV1CSVR ( WKCACT : WKCCUS : DSCDST :
            Beg_Date7 : WK_CustErr : Wk_CustMst );

         // When Beginning Trip Date was prior to Inactive Date,
         // customer is still considered valid.

         If WK_CustErr = '1' And MODE <> 'DISPLAY';
            DsCusn = *All'*';
            *IN45 = *ON;
            $Msgid = '0062';
            If Wk_Cust1 = '6';
              $Msgid = '0061';
            EndIf;

            EXSR Err_Message;
            LeaveSr;
         EndIf;

         DSCUSN = CMBNAM;

       EndSr;
       //-----------------------------------------------------------------------
       // Validate_City - Validate destination & Departing city & state
       //-----------------------------------------------------------------------

       BegSr Validate_City;

         If DSDPC = *BLANKS;
           *IN46 = *ON;
           $Msgid = '0065';
           EXSR Err_Message;
         ELSE;
           HDPC = DSDPC;
         EndIf;

         If DSDPS <> *BLANKS;
           Exec Sql Select (1) into :Data_Fnd from FdtSst
                     Where SstCd = :DsdPs
                     Fetch first row only;
         EndIf;

         Select;
         When DSDPS = *BLANKS;
           *IN47 = *ON;
           $Msgid = '0120';
           EXSR Err_Message;
         When DsdPs <> HdPs and SqlCode <> 0;    //DSDPS <> *BLANKS
           *In47 = *On;
           $Msgid = '0120';
           ExSr Err_Message;
         When DsdPs <> HdPs;
           HDPS = DSDPS;
         EndSl;

         Clear SqlCode;

         If DSDSC = *BLANKS;
           *IN48 = *ON;
           $Msgid = '0065';
           EXSR Err_Message;
         EndIf;

         Select;
         When DSDSS = *BLANKS;
           *IN49 = *ON;
           $Msgid = '0120';
           EXSR Err_Message;
         When Dsdss <> Hdss;               //DSDSS <> *BLANKS
           Exec Sql Select (1) into :Data_Fnd from FdtSst
                     Where SstCd = :Dsdss
                     Fetch first row only;
           If SqlCode <> 0;
              *In49 = *On;
              $Msgid = '0120';
              ExSr Err_Message;
              Clear SqlCode;
              LeaveSr;
           EndIf;
           HDsS = DSDsS;
         EndSl;

       EndSr;

       //-----------------------------------------------------------------------
       // Process_State_Mileage - Process state mileage
       //-----------------------------------------------------------------------
       BegSr Process_State_Mileage;

         If Susp_Flg = '0';

           PANEL = 'MILE';

           Exsr Clear_Mile_ind;

           // If F2 pressed from subsequent screen and If there are were no
           // mileage records, turn off SFLDSP
           Select;
           When *INKB = *ON and Mile_RRN = 0;

              *IN63 = *OFF;
              MISRN = 1;

           When *INKB = *ON;

              *IN63 = *ON;
             // NEED TO SETON SFLNXTCHG WHEN F2 SO THAT VALIDATION CAN BE
             // PERFORMED AGAIN ON ***ALL*** FIELDS FOR PURPOSE OF LOADING
             // THE MESSAGE DATA STRUCTURE FOR WRITING ERRORS TO FILE.
              *IN65 = *ON;

             // When reloading mileage subfile, Protect the Trip Date field on
             // the first mileage line from input since this is always the same
             // as the beginning trip date entered on the Prompt screen and
             // should only be modified from the Prompt screen.

              For Ctr = 1 To SAVRRN;
                CHAIN Ctr MILSFL;

               // If 1st mileage record, protect trip date and state.

                Exsr Protect_TrpDt_St;
                Update MILSFL;

              EndFor;

              MISRN = 1;

             // If this screen is NOT accessed via F2...

           Other;

             // Set Odometer/Mileage column to Odometer mode.
             *IN35 = *OFF;

             // If the clerk is authorized to enter On-Board Computer DTRs,
             //  and the trip number includes 'OBC', go directly to mileage
             //  mode.

             If *IN04 = *On and %Scan('OBC' : DSHTRP) > 0;
                *In35 = *ON;
             ENDIF;

             // Clear Mileage screen.

             Exsr Clear_Mileage_Panel;
             CLEAR DSENDS;

              // Load Subfile with records from file if DISPLAY or CHANGE mode.
             If Mode <> 'ADD    ';
               Exsr Fill_Mileage_Panel;
              // If ADD mode, Fill mileage screen with blank lines.
             Else;
               Exsr Fill_Mileage_Panel_Add;
             EndIf;
           EndSl;

           // SETOFF TO SCREEN CHANGE
           SCRCHG = 'N';
         Endif;

         Wk_DSRCWT = 0;
         Reset WTAXL_Flg;
         LOOP4 = *ON;
         DoW LOOP4 = *ON;

           Susp_Flg = '0';

           // Clear message line and write any error messages.
           WRITE MSGCLR;
           WRITE MSGCTL;

           // Write/Read Mileage screen.

           WRITE TITLE;
           WRITE CUST;

           // If there are no mileage records, write "no records exist" screen.

           If Mile_RRN = 0;
             WRITE MILEOF;
           EndIf;

           // If Ending Speedo = zero (51 is on), and an error was found
           // in the mileage subfile portion of the display, then write
           // the control record prior to writing the ending speedo format.
           // Otherwise, write the ending speedo followed by the control rcd.

           If *IN51 = *ON
             And MIERR <> 'Y';
              WRITE MILCTL;
              WRITE ENDSPD;
           ELSE;
              WRITE ENDSPD;
              WRITE MILCTL;
           EndIf;

           READ MILCTL;
           *InLr = %Eof;

           // If there are no mileage records, read "no records exist" screen.

           If Mile_RRN = 0;
             READ MILEOF;
           ELSE;
             READ ENDSPD;
           EndIf;
           *InLR = %Eof;

           //  IF ENDSPD REC WAS CHANGED SET ON SCREEN CHANGE
           If *IN23 = *On;
             SCRCHG = 'Y';
           ENDIF;

           // Clear Message Subfile (MSGSFL).

           *IN70 = *OFF;

           Exsr Clear_Mile_ind;

           // Set Off SFLNXTCHG and SFLRCDNBR(CURSOR)
           *IN65 = *OFF;
           *IN66 = *OFF;

           // Process Function Keys

           // F1=Exit

           Select;
           When *Inka = *On;
             SPVEXIT ( CONFRM );
             If CONFRM = 'Y';
                LeaveSr;
             Endif;
             Iter;

           // F2=Return to Batch Logging Program
           When *InKb = *On;
             LeaveSr;

           // F4=Window
           When *Inkd = *On;
             ExSr Inquiry_Window;
             Iter;

           // HELP key pressed.
           When *In90 = *On;
             Exsr Process_Help;
             Iter;

           // F13=Suprv
           // If F13 pressed (Not available in DISPLAY mode), allow supervisor
           // to enter access code so that her authority (based on security)
           // will be in place for this screen only.  Once Enter is pressed
           // from this screen, authority will return to original user.

           // F14=Route
           // If F14 pressed (Not available in DISPLAY mode), redisplay
           // screen after removing PROTECT from that column.

           When *Inkn = *On
             And *In27 = *Off;
             *IN28 = *ON;
             Exsr Underline_Route_Field;
             Iter;

           // F16=Option
           // If F16 pressed (Not available in DISPLAY mode), redisplay
           // screen after removing PROTECT from that column.

           When *Inkq = *On
             And *IN27 = *Off;
             *IN30 = *ON;
             Exsr Underline_Route_Field;
             Iter;
           EndSl;

           // Reset Error Accumulators.

           Exsr Reset_Err_Acc;

           // Reset work fields.
           MIERR = NO;
           CLEAR SEL#;
           CLEAR INMRN;
           CLEAR DEMRN;
           DSSFND = NO;
           ENDODM = DSENDS;
           PTYMD = 9999999;
           CLEAR $$STAT;
           CLEAR LINFND;

           // Clear Mileage Error Message Mult. Occur. Data Structure.
           Exsr Clear_Mil_Msg;

           // If mileage records found...
           Select;
           When Mile_RRN > 0;

             // If not in Display mode, Validate Mileage input and
             // load data structure to subfile.

             Select;
             When MODE <> 'DISPLAY';
               Exsr Validate_Mileage;

             // If in Odometer mode, change to Mileage mode.
               If *INKP = *ON;
                 *IN35 = not *IN35;
               EndIf;

               Exsr Load_Ds_Sfl;

               // If in Display mode, check if F15 was pressed.
               // F15 is used as a toggle to display either mileage or
               // odometer readings.
             When *INKP = *ON;

               // If in Odometer mode, change to Mileage mode.
               *IN35 = not *IN35;

               For Ctr = 1 To SAVRRN;
                 CHAIN Ctr MILSFL;

                 Select;
                 When *IN57 = *OFF and *IN35 = *OFF;
                     DSBODM = HMILE;
                     KILOS = 0;
                     If (HMILE * 1.609) <= 9999999 and HMILE > 0;
                       Eval(H) KILOS = HMILE * 1.609;
                     Endif;
                     DSBODM = HODOM;
                 When *IN57 = *OFF;                //*IN35 = *ON
                     DSBODM = HMILE;
                 When *IN35 = *OFF;
                     Eval(H) KILOS = HMILE / 1.609;
                     DSBODM = HODOM;
                 Other;
                     DSBODM = HMILE;
                 EndSl;

                 // If 1st mileage record, protect trip date and state.

                 Exsr Protect_TrpDt_St;

                 UPDATE MILSFL;
               EndFor;

             EndSl;

           // F15=Mile/Odom toggle

               // If trying to change from Odometer mode to Mileage mode,
               // and the ending speedo is zero, show error since there is
               // no way for the computer to calculate the miles.


               // If in Mileage mode, change to Odometer mode.

               // If trying to change from Mileage mode to Odometer mode,
               // and the ending speedo is zero, show error since there is
               // no way for the computer to calculate the odometers.

             Select;
             When *INKP = *ON and *IN35 = *ON and DSENDS = 0;

               // If trying to change from Odometer mode to Mileage mode,
               // and the ending speedo is zero, show error since there is
               // no way for the computer to calculate the miles.

               $Msgid = '0145';
               EXSR Err_Message;

             When *INKP = *ON and DSENDS = 0;

               // If in Mileage mode, change to Odometer mode.

               // If trying to change from Mileage mode to Odometer mode,
               // and the ending speedo is zero, show error since there is
               // no way for the computer to calculate the odometers.

               $Msgid = '0146';
               EXSR Err_Message;
             EndSl;

           // If Insert option was taken, insert line.

             Select;
             When INMRN <> 0;
               *IN43 = *OFF;
               *IN(52) = *Off;
               *IN(53) = *Off;
               *IN56 = *OFF;
               *IN(58) = *Off;
               *IN(59) = *Off;
               Exsr Insert_Mil_Record;

             // If Delete option was taken, delete line.

             When DEMRN <> 0;
               *IN43 = *OFF;
               *IN(52) = *Off;
               *IN(53) = *Off;
               *IN56 = *OFF;
               *IN(58) = *Off;
               *IN(59) = *Off;
               Exsr Delete_Mil_Record;

             // Validate mileage input if not in DISPLAY mode.

             When MODE <> 'DISPLAY';

             // Destination State must be found as one of the mileage lines.

               If DSSFND = NO;
                 MiErr = 'Y';
                 MISRN = 1;
                 $Msgid = '0122';
                 EXSR Err_Message;
                 // Populate line number as blanks for this paricular error.
                 CLEAR MILLIN;
               EndIf;

               // If beginning odometer is negative (possible when keying in
               // miles rather then odometers and the ending odom is too low.
               Select;
               When BEGODM < 0;
                 $Msgid = '0157';
                 EXSR Err_Message;

                 // Only validate ENDING SPEEDO if Insert & Delete WERE NOT TAKEN.
               When DSENDS = 0;
                 *IN51 = *ON;
                 $Msgid = '0158';
                 EXSR Err_Message;
               EndSl;
             EndSl;

             If DCUSYN = 'Y';
                Exsr Validate_Cust;
                If $Msgid = '0502';
                   Iter;
                Endif;
             Endif;

           // IF ERRORS, Insert, Delete, or F15 taken, then REDISPLAY PANEL.
             Select;
             When OVER > 0
               Or SUSP > 0
               Or FATAL > 0
               Or INMRN > 0
               Or DEMRN > 0
               Or *INKP = *ON;

               // If Ending Speedo has an error without any mileage subfile
               // errors, then PC on ENDSPD formats DSENDS field.

               If *IN51 = *ON
                 And MIERR <> 'Y';
                 *IN55 = *ON;
               EndIf;

               // If no FATAL severity errors, then
               // allow F7 if SUSPEND errors and F5 if only OVERRIDE errors.
               Select;
               When FATAL = 0 and SUSP > 0;
                 *IN33 = *ON;
               When FATAL = 0 and OVER > 0;
                 *IN32 = *ON;
               EndSl;

               Select;
               // If F15 (Odom/Mile toggle) taken, redisplay screen.
               When *INKP = *ON;
                  Iter;

               // If F5 (Override) and F7 (Suspend) not taken, redisplay screen.
               When *INKE = *OFF And *INKG = *OFF;
                 // IF OVERRIDE IS GOING TO BE ENABLED CHECK IF WINDOW HAS TO BE
                 // DISPLAYED
                 Iter;

               When *INKG = *ON And *IN07 = *ON;

                 // MOVE SUSPENDED DTR TO SUSPENDED BOX
                 Exsr DTS_Sus_Rej;
               EndSl;

             // CALL RENTAL LOOKUP
             When *INKG = *OFF;

               //Do Nothing

             When *IN07 = *ON;
               EXSR Err_Message;
               Exsr DTS_Sus_Rej;

             Other;
               EXSR Err_Message;
             EndSl;

           // If no records on mileage screen (End of file message showing)
           Other;

             Select;
             When INSEOF = 'I';
               *IN63 = *ON;
               CLEAR INMRN;
               Exsr Insert_Mil_Record;

             When INSEOF <> ' ';
               $Msgid = '0100';
               EXSR Err_Message;

             // No Mileage LInes Entered ERROR.

             When MODE <> 'DISPLAY';
               $Msgid = '0150';
               EXSR Err_Message;
               // IF ENTER IS PRESSED ON EOF, THEN
               // If no FATAL severity errors, then
               // allow F7 if SUSPEND errors and F5 if only OVERRIDE errors.
               Exsr SUSP_OVER_Err;
             EndSl;

             Select;
             When *INKE = *OFF
               And *INKG = *OFF
               And MODE <> 'DISPLAY';
                Iter;

             When *INKG = *ON
               And *IN07 = *ON;

               // MOVE SUSPENDED DTR TO SUSPENDED BOX
               Exsr DTS_Sus_Rej;

             EndSl;

           EndSl;

         // Reload to original security of user in case F13 was pressed.

           LDA   = Hld_LDA;
           HLD22 = *IN22;
           *IN(01) = LDINDS;
           *IN22 = HLD22;
           Leave;
         EndDo;

       EndSr;
       //-----------------------------------------------------------------------
       // Clear_Mile_ind -
       //-----------------------------------------------------------------------
       BegSr Clear_Mile_ind;

         // Initially set off the ability to perform F5 or F7 since
         // validation must be performed before we know if these keys
         // will be required.

         *IN32 = *OFF;
         *IN33 = *OFF;

         // Set Off Subfile Field's Reverse Image Indicators.

         *IN43 = *OFF;
         *IN51 = *OFF;
         *IN52 = *OFF;
         *IN56 = *OFF;
         *IN58 = *OFF;
         *IN59 = *OFF;

         // Set Off Positioning (PC) Indicator.

         *IN53 = *OFF;
         *IN55 = *OFF;
         *IN44 = *OFF;

       EndSr;
       //-----------------------------------------------------------------------
       // PROTECT_TRPDT_ST - If writing the First Mileage record, then set the
       //                    indicator to make Trip Date and State as Protected
       //                    field in Display File
       //-----------------------------------------------------------------------
       BegSr PROTECT_TRPDT_ST;

         *In29 = *Off;
         If DsLine = '01';
           *In29 = *On;
         EndIf;

       EndSr;
       //-----------------------------------------------------------------------
       // SUSP_OVER_Err - Suspend/Override Errors
       //  Set Indicator for 'Fatal = 0 and Susp >0' anything else
       //   sets the Indicator *On
       //-----------------------------------------------------------------------
       BegSr SUSP_OVER_Err;

         Select;
         When FATAL = 0 and SUSP > 0;
             *IN33 = *ON;
         When FATAL = 0;               // SUSP <= 0
             *IN32 = *ON;
         EndSl;

       EndSr;

       //-----------------------------------------------------------------------
       // Clear_Mileage_Panel- Clear mileage panel
       //-----------------------------------------------------------------------

       BegSr Clear_Mileage_Panel;

         // Protect Customer fields on mileage panels
         // Protect Route fields on mileage panels
         // Protect Option fields on mileage panels

         *IN26 = *ON;
         *IN28 = *OFF;
         *IN30 = *OFF;

         // Clear Mileage States array.
         // Clear Mileage Codes array.

         CLEAR @STM;
         CLEAR @SMC;

         *IN(60) = *On;
         *IN(61) = *Off;
         *IN(62) = *Off;
         *IN(63) = *Off;
         *IN(64) = *Off;
         *IN(65) = *Off;
         *IN(66) = *Off;
         *IN(67) = *Off;
         *IN(68) = *Off;
         *IN(69) = *Off;
         WRITE MILCTL;
         *IN(60) = *Off;
         *IN(61) = *Off;
         *IN(62) = *On;
         *IN(63) = *On;
         *IN(64) = *Off;
         *IN(65) = *Off;
         *IN(66) = *Off;
         *IN(67) = *Off;
         *IN(68) = *Off;
         *IN(69) = *Off;
         *IN(70) = *Off;

         RESET Mile_RRN;

       EndSr;

       //-----------------------------------------------------------------------
       // Clear_Mil_Msg - Clear mileage message mult. occur DS subroutine
       //-----------------------------------------------------------------------

       BegSr Clear_Mil_Msg;

         For Ctr = 1 To 20;
           %Occur(MILMSG) = Ctr;
           CLEAR MILMSG;
         EndFor;

         // Mile_Err_Cnt = Total number of Mileage screen errors

         CLEAR Mile_Err_Cnt;

       EndSr;

       //----------------------------------------------------------------------
       // Fill_Mileage_Panel - Fill mileage panel
       //----------------------------------------------------------------------
       BegSr Fill_Mileage_Panel;

         Clear WK_COUNT1;
         First = 'N';

         // Set on SFLNXTCHG when in CHANGE mode.
         If MODE = 'CHANGE ';
           *IN65 = *ON;
         EndIf;

         // Load entire subfile (maximum=99).

         Exec Sql Open Entr_Mile_Cursor;
         Dow SqlCode = 0;

           Reset FdtsMile;
           Exec Sql Fetch Entr_Mile_Cursor
                     into :TMLINE,:TMRTES,:TMCODE,:TMBODM,:TMTMIS,:TMTOLL,
                          :TMRCWT,:TMSE,:TMLE,:TMAXLE,:TMEODM,:Wk_MM7,
                          :Wk_DD7,:Wk_CYY7;
           If SqlCode <> 0;
              Leave;
           EndIf;

              // If initial READ is successful, fill subfile.
           MILOPT = *BLANK;
           DSLINE = TMLINE;

           DsTMDY = 0;
           If Wk_Date7 > 0;
             Wk_Date10 = %Date(Wk_Date7:*CYMD);
             DsTMDY = %Dec(Wk_Date10:*MDY);
           Endif;

           DSSE = TMSE;

             // Retrieve State Name and number from state adjacency file.

           Clear DssTnm;
           Exec Sql Select SsTnam into :DssTnm from FdtsSt
                    Where  SstCd = :Dsse
                    Fetch first row only;
           Clear SqlCode;

           DSRTES = TMRTES;
           DSCODE = TMCODE;
             // Load  Mileage/Odom fields.
           DSBODM = TMTMIS;
           If *IN35 = *Off;
             DSBODM = TMBODM;
           ENDIF;
           DSTOLL = TMTOLL;
           DSRCWT = TMRCWT;

             // Load hidden Mileage/Odom fields.
           HODOM = TMBODM;
           HMILE = TMTMIS;

             // Load hidden Addtn'l State Reqmnts (ASR) fields.
           DSLE = TMLE;
           KILOS = 0;
           Select;
           When *IN57 = *On;
               Eval(H) KILOS = TMTMIS / 1.609;
           When (TMTMIS * 1.609) <= 9999999 and TMTMIS > 0;
               Eval(H) KILOS = TMTMIS * 1.609;
           EndSl;
           DSAXLE = TMAXLE;

          //
          // If State Entered is Kentucky, Load the subfile field with
          // the information previously obtained from the Header information.
          //
           DSKYU = 0;
           If DSSE = 'KY';
             DSKYU = HKYU;
           EndIf;

             // Load array with initial states.
             // Will update the position of the state array if anything
             // changed via READC Loop in $PRMIL.

           Mile_RRN = Mile_RRN + 1;
           Ctr = Mile_RRN;
           @STM(Ctr) = DSSE;
           @SMC(Ctr) = DSCODE;
           WK_COUNT1 = WK_COUNT1 + 1;

             // If 1st mileage record, protect beginning trip date,
             // and auto load beg. trip date from prompt screen in case of chg,
             // and load Ending Speedo.
             // Also auto load departing state on 1st mileage line.

           *IN29 = *OFF;
           If Mile_RRN = 1;
             DSTMDY = DSBDAT;
             DSENDS = TMEODM;
             DSSE = DSDPS;
             *IN29 = *ON;
           EndIf;

           WRITE MILSFL;

             // Set on Subfile Display and Subfile Control.

           *IN62 = *ON;
           *IN63 = *ON;

             // Position panel at FIRST recird wrutten.

           If FIRST = 'N';
             MISRN = Mile_RRN;
             FIRST = 'Y';
           EndIf;

         EndDo;
         Exec Sql Close Entr_Mile_Cursor;
         Clear SqlCode;

         // Save Last Relative Record Number and seton Subfile End.

         SAVRRN = Mile_RRN;
         *IN68 = *ON;

         // If no mileage records were written, turn off SFLDSP.

         If Mile_RRN = 0;
           *IN63 = *OFF;
         EndIf;

       EndSr;

       //-----------------------------------------------------------------------
       // Fill_Mileage_Panel_Add -- Fill mileage panel add subroutine
       //-----------------------------------------------------------------------

       BegSr Fill_Mileage_Panel_Add;

         CLEAR WK_COUNT1;
         FIRST = 'N';

         // Set on SFLNXTCHG when in ADD mode.

         *IN65 = *ON;

         // Load entire subfile (maximum=99 since Line field in file = 2).

         Dow WK_COUNT1 < 99;
           MILOPT = *BLANK;
           CLEAR DSTMDY;
           CLEAR DSSE;
           CLEAR DSSTNM;
           CLEAR DSRTES;
           CLEAR KILOS;
           CLEAR DSBODM;
           CLEAR DSCODE;
           // Load hidden Mileage/Odom fields.
           CLEAR HODOM;
           CLEAR HMILE;
           // Hidden fields for use with Addtn'l State Reqmnts (ASR)
           CLEAR DSLE;
           CLEAR DSTOLL;
           CLEAR DSRCWT;
           CLEAR DSAXLE;
           CLEAR DSKYU;
           Mile_RRN = Mile_RRN + 1;
           EvalR DSLINE = %Editc(Mile_RRN:'X');
           WK_COUNT1 = WK_COUNT1 + 1;

           // If 1st mileage record, load 1st beg. trip date and protect.
           // Also zero out ending speedo.  PC on 1st State field.

           *IN29 = *OFF;
           If Mile_RRN = 1;
             DSTMDY = DSBDAT;
             DSSE = DSDPS;
             CLEAR DSENDS;
             *IN29 = *ON;
             *IN53 = *ON;
           EndIf;

           WRITE MILSFL;

           // Set on Subfile Display and Subfile Control.

           *IN62 = *ON;
           *IN63 = *ON;

           // Position panel at FIRST recird wrutten.

           If FIRST = 'N';
             MISRN = Mile_RRN;
             FIRST = 'Y';
           EndIf;

         EndDo;

         // Save Last Relative Record Number and seton Subfile End.

         SAVRRN = Mile_RRN;

         // Turn off SFLNXTCHG.
         // Turn on  SFLEND.

         *IN65 = *OFF;
         *IN68 = *ON;

       EndSr;
       //-----------------------------------------------------------------------
       // Validate_Mileage - Validate mileage subroutine
       //-----------------------------------------------------------------------
       BegSr Validate_Mileage;

         // Clear Mileage Error Message Mult. Occur. Data Structure.
         Exsr Clr_Multi_Ds;
         Exsr Clr_Multi_Err_Ds;

         Code2_Fnd = ' ';
         If DSENDS < 0;
           DSENDS = 0;
         Endif;

         For Ctr = 1 To SAVRRN;
           CHAIN Ctr MILSFL;

           If DSBODM < 0;
             DSBODM = 0;
           Endif;

           Select;
           When Ctr = 1 and *IN35 = '0';    //Odometer Mode
              Wk_BegDat7P = Wk_BegDat7;
              HBSPD  = DSBODM;
           When Ctr = 1;                    //Mile mode
              Wk_BegDat7P = Wk_BegDat7;
              If (DSENDS - DSBODM) < 0;
                HBSPD = 0;
              Else;
                HBSPD  = DSENDS - DSBODM;
              Endif;
           When *IN35 = '1';
              If (HBSPD - DSBODM) < 0;
                HBSPD = 0;
              Else;
                HBSPD = HBSPD - DSBODM;
              Endif;
           EndSl;

           //  IF MILE SUBFILE WAS CHANGED SET ON SCREEN CHANGE
           If *IN23 = *On;
             SCRCHG = 'Y';
           ENDIF;

           Ctr = Mile_RRN;
           @STM(Ctr) = DSSE;
           @SMC(Ctr) = DSCODE;

           // If a Code=2, mark the Code 2 Found (Code2_Fnd) field with 'Y'.
           // Then when codes are validated below, we will be able to
           // determine if all mileage lines have a code 2 when one is found.
           If DSCODE = '2';
             Code2_Fnd = 'Y';
           EndIf;

           @ST(Ctr) = '  ';
           @STWGT(Ctr) = 0;
           @STAXL(Ctr) = 0;

           getdtssrq(DSSE: DSCUST: DSCDST: Today_7: srqFound: DTSSRQds);

           Data_fnd = 0;
           If RQWGHT <> 'Y';
              Exec Sql Select RQWGHT, RQAXLE, (1)
                         into :RQWGHT, :RQAXLE, :Data_fnd
                         from FDTSSRQ
                        Where RQST = :DSSE AND RQWGHT = 'Y' AND
                              RQEFDT <= :Today_7 and RQEXDT >= :Today_7
                        Fetch First rows only;
           Endif;

           If (srqFound = '1' and RQWGHT = 'Y') or Data_fnd > 0;
              @ST(Ctr) = DSSE;
              WTAXL_Flg = '1';
           Endif;

           If DSSE <> *BLANK;

             // If Trip Dates are zero, automatically load with previous date.
             If DSTMDY = 0;
               DSTMDY = PTMDY;
             EndIf;
             PTMDY  = DSTMDY;

             // Only if Odometer column is displayed...
             // If Odometer readings are less than previous reading,  check
             // for a shorter length.  If shorter, load the left portion of
             // the number automatically.

             Select;
             When DSLINE = '01' and *IN35 = *OFF;
                 PODOM = DSBODM;
             When DSBODM <> *ZEROS and *IN35 = *OFF;
                 A_OdomZ = DSBODM;
                 B_OdomZ = PODOM;
                 pos = %Check('0' : A_OdomC);
                 pos = pos - 1;
                 if pos > 0;
                   Eval %Subst(A_OdomC:1:pos) = %Subst(B_OdomC:1:pos);
                 endif;
                 DSBODM = A_OdomZ;
                 PODOM = A_OdomZ;
             EndSl;

             // Save last date on mileage screen.
             LASTDT = DSTMDY;
           EndIf;

           %Occur(D1MILE) = Ctr;
           DSMDY = DSTMDY;
           D1MILE = MILE;
           Update MILSFL;
         EndFor;
         Exsr MXMLVL;

         // Set Off Subfile Field's Reverse Image Indicators.
         *IN43 = *OFF;
         *IN52 = *OFF;
         *IN56 = *OFF;
         *IN58 = *OFF;
         *IN59 = *OFF;

         // Set Off Positioning (PC) Indicator.
         *IN53 = *OFF;

         // Validate every record in data structure.
         Ctr = SAVRRN;
         PODOM = DSENDS;

         Dow Ctr <> 0;
           %Occur(D1MILE) = Ctr;

           // If in Odometer mode.
           If *IN35 = *OFF;
              D1HODM = D1BODM;
           else;
           // If in Mileage mode.
              D1HMIL = D1BODM;
           Endif;

           Select;
           When D1HODM <> 0
            And DSENDS <> 0
            And *IN35 = *OFF;
                D1HMIL = ENDODM - D1HODM;
                If *INKP = *ON;
                  D1BODM = D1HMIL;
                Endif;
                ENDODM = D1HODM;

           When *IN35 = *OFF AND *INKP = *ON;
                CLEAR D1BODM;
             // If in Mileage mode.

           When D1HMIL <> 0
            And DSENDS <> 0
            And *IN35 = *ON;
                D1HODM = ENDODM - D1HMIL;
                If D1HODM < 0;
                  D1HODM = 0;
                Endif;
                If *INKP = *ON;
                  D1BODM = D1HODM;
                Endif;
                ENDODM = D1HODM;

           When *INKP = *ON
            And *IN35 = *ON;
                CLEAR D1BODM;

           EndSl;

           // Validate Ascending Dates.
           If D1TMDY <> 0;

             Wk_MDY = D1TMDY;
             Exsr Validate_MDY;
             If %Error();
               Wk_Date7 = 0;
             Else;
               Wk_Date10 = %Date(D1TMDY:*MDY);
               Wk_Date7 = %Dec(Wk_Date10:*CYMD);
             Endif;

             If Wk_Date7 > PTYMD;
               %Occur(DEMILE) = Ctr + 1;
               MiErr = 'Y';
               MISRN = Ctr + 1;
               DETMDY = 'Y';
               $Msgid = '0114';
               EXSR Err_Message;
             EndIf;
             PTYMD = Wk_Date7;
           EndIf;

           // Validate Ascending Odometer readings.
           If D1HODM <> 0;
             Select;
             When D1HODM >= PODOM and PODOM = DSENDS;

               // If Ending Speedo is not Ascending show error message.
                 *IN51 = *ON;
                 $Msgid = '0147';
                 EXSR Err_Message;
             When D1HODM >= PODOM;        //indicates that PODOM <> DSENDS
                 %Occur(DEMILE) = Ctr + 1;
                 MiErr = 'Y';
                 MISRN = Ctr + 1;
                 DEBODM = 'Y';
                 $Msgid = '0147';
                 EXSR Err_Message;
             When D1LINE = '01';
                 BEGODM = D1HODM;
                 WK_BEGDAT7 = Wk_Date7;
             EndSl;
             PODOM = D1HODM;
           EndIf;

           // Process mileage errors
           %Occur(DEMILE) = Ctr;

           // Validate option.
           Select;
           When D1SOPT = 'I' and Ctr = 99;
             // If Insert taken on last record (99), give error that no
             // additional records can be added.
               DESOPT = 'Y';
               MiErr = 'Y';
               $Msgid = '0103';
               EXSR Err_Message;
           When D1SOPT = 'I';           //indicates that X <> 99
               If SEL# = 0;
                 INMRN = Ctr;
               EndIf;
               SEL# = SEL# + 1;

           When D1SOPT = 'D';
               If SEL# = 0;
                 DEMRN = Ctr;
               EndIf;
               SEL# = SEL# + 1;
           When D1SOPT <> ' ';
               DESOPT = 'Y';
               MISRN = Ctr;
               $Msgid = '0100';
               EXSR Err_Message;

             // Do not validate blank lines when in ADD mode.
           When MODE = 'ADD    '
               And D1SOPT = *BLANK
               And D1TMDY = 0
               And D1SE = *BLANKS
               And D1RTES = *BLANKS
               And D1BODM = 0
               And D1CODE = *BLANKS
               And LINFND = *BLANKS;

               // Skip validation.
           Other;

               // Indicate that a non-blank line was found so that any inserted
               // lines that are left blank are given an error.
               LINFND = 'Y';

               // Validate date.
               Wk_DATE6 = D1TMDY;
               EXSR Validate_Date;
               If WKSPER = *ON;
                 MiErr = 'Y';
                 MISRN = Ctr;
                 DETMDY = 'Y';
               EndIf;

               // If date is valid, then determine if it is less than beg. date.
               If WKSPER = *OFF;

                 Wk_Date10 = %Date(DsbDat:*mdy);
                 Beg_Date7 = %Dec(Wk_Date10:*cymd);

                 If Wk_BegDat7 < Beg_Date7;
                   MiErr = 'Y';
                   MISRN = Ctr;
                   DETMDY = 'Y';
                   $Msgid = '0112';
                   EXSR Err_Message;
                 EndIf;

                 // If date is valid and this is line 01, then date must be same
                 // as the beginning trip date. (Normally this is always the case
                 // since it is preloaded.  However, if line 01 is ever deleted by
                 // the user, and the date changes, then give error and allow
                 // update.
                 If D1LINE = '01'
                   And Wk_BegDat7 <> Beg_Date7;
                   *IN29 = *OFF;
                   MiErr = 'Y';
                   MISRN = Ctr;
                   DETMDY = 'Y';
                   $Msgid = '0116';
                   EXSR Err_Message;
                 EndIf;
               EndIf;

               // Validate State With FFSQUST file.
               If WKAFLG = 'Y' and D1SE <> *Blanks;

                 If VFCUST <> '699999' AND VFCUST <> '699998' AND
                   VFCUST <> 'RENTAL' AND VFCUST <> 'T1W'    AND
                   VFCUST <> 'POOL'   AND VFCUST <> 'SERV';

                   //   Note:  We are intentionally not checking FQSACT.
                   //     No inactive date for comparison.
                   //  FFSQUST only has data on GH box
                   Exec Sql Select(1) Into :Data_Fnd
                            From FFSQUST
                            Where (FQCorp = :DSCorp) And
                                  (FQCust = :DSCust) And
                                  (FQUnit = :DSUnit) And
                                  (FQStvl = :D1Se)
                            Fetch First rows only;

                   // Fleet services information is not available
                   //   for the fleet unit.
                   If SQLCode <> 0;
                     MiErr = 'Y';
                     MISRN = Ctr;
                     DESE = 'Y';
                     $Msgid = '0503';
                     EXSR Err_Message;
                   Endif;

                   If MiErr <> 'Y' and Susp = 0 and TMERR = 'Y';
                     TmErr = ' ';
                   Endif;

                   Clear SqlCode;
                 EndIf;
               Endif;

               // State entered cannot be blank.

               If D1SE <> *BLANK;
                 Exec Sql Select SSTNAM into :D1STNM  from FDTSST
                          Where  SSTCD = :D1SE
                          Fetch first row only;
               EndIf;

               Select;
               When D1SE = *BLANK;
                   MiErr = 'Y';
                   MISRN = Ctr;
                   DESE = 'Y';
                   $Msgid = '0120';
                   EXSR Err_Message;
               When SqlCode <> 0 ;
                   MiErr = 'Y';
                   MISRN = Ctr;
                   DESE = 'Y';
                   $Msgid = '0120';
                   EXSR Err_Message;
                   $$STAT = D1SE;
               Other;

                   // 1st mileage line must be same as departing state

                   If D1LINE = '01'
                     And D1SE <> DSDPS;
                     *IN29 = *OFF;
                     MiErr = 'Y';
                     MISRN = Ctr;
                     DESE = 'Y';
                     $Msgid = '0121';
                     EXSR Err_Message;
                   EndIf;

                   // If mileage line state equals destination state, then
                   // turn on the dest. found flag.

                   If D1SE = DSDSS;
                      DSSFND = YES;
                   EndIf;

                   // Check that state is adjacent.

                   Exec Sql Select (1) into :Data_Fnd
                            from FDTSST
                           Where SSTCD = :D1SE  and SAJSC1 <> :$$STAT and
                                 SAJSC2 <> :$$STAT and SAJSC3 <> :$$STAT and
                                 SAJSC4 <> :$$STAT and SAJSC5 <> :$$STAT and
                                 SAJSC6 <> :$$STAT and SAJSC7 <> :$$STAT and
                                 SAJSC8 <> :$$STAT
                           Fetch first row only;
                   If SqlCode = 0 ;

                     // If state is same as previous, or if this DTR contains the
                     // summary data from an on-board computer, then there is no
                     // need to check for state adjacency.

                     If D1SE <> $$STAT
                      and *IN04 = *Off
                      and *IN35 = *Off
                      and $$STAT <> *BLANKS;
                          %Occur(DEMILE) = Ctr + 1;
                          MiErr = 'Y';
                          MISRN = Ctr + 1;
                          DESE = 'Y';
                          $Msgid = '0123';
                          EXSR Err_Message;
                     EndIf;
                   ENDIF;
                   $$STAT = D1SE;
               EndSl;
               Clear SqlCode;

               // RESET OCCURENCE OF ERRORS
               %Occur(DEMILE) = Ctr;

                 // Odometer/Miles cannot be zero.
                 If D1BODM = 0;
                   MiErr = 'Y';
                   MISRN = Ctr;
                   DEBODM = 'Y';
                   $Msgid = '0152';
                   If *IN35 = *OFF;
                     $Msgid = '0151';
                   Endif;

                   EXSR Err_Message;
                 EndIf;

                 // Miles cannot exceed the specified limit in VEHTABF for each day
                 if D1TMDY <> 0;
                    Wk_MDY = D1TMDY;
                    Exsr Validate_MDY;
                    If %Error();
                      Wk_Date7 = 0;
                    Else;
                      Wk_Date10 = %Date(D1TMDY:*MDY);
                      Wk_Date7 = %Dec(Wk_Date10:*CYMD);
                    Endif;
                 EndIf;
                 POS1 = %LOOKUP(Wk_Date7:TRDAY);
                 IF POS1 <> 0 and Wk_Date7 <> 0;
                   Clear TRPMIL;
                   // Convert miles driven to respective UOM.
                   TRPMIL =  TRMIL(POS1);
                   If WKUOMC = 'M';
                     TRPMIL = %DecH((TRMIL(POS1)  / 1.609):7:0);
                   EndIf;

                   If VTDSC >= 0 and VTDSC < TRPMIL;
                       MiErr = 'Y';
                       MISRN = Ctr;
                       DEBODM = 'Y';
                       $Msgid = '0504';
                       EXSR Err_Message;
                   ENDIF;
                 ENDIF;

                 // Validate code.
                 Select;
                 When D1CODE <> ' '
                   And D1CODE <> '1'
                   And D1CODE <> '2'
                   And D1CODE <> '3';
                     MiErr = 'Y';
                     MISRN = Ctr;
                     DECODE = 'Y';
                     $Msgid = '0160';
                     EXSR Err_Message;

                   // If a Code=2 was found, all lines must contain a Code=2.
                   // We will automatically fill those mileage lines that are left
                   // blank with a '2'. However, if entry of codes other than a
                   // blank or 2 were input when at least one line was found with a
                   // code 2, then we will give an error.  They then must be blanked
                   // or manually changed to a code 2.

                 When Code2_Fnd = 'Y' and D1CODE = ' ';
                     D1CODE = '2';
                     @SMC(Ctr) = D1CODE;
                 When Code2_Fnd = 'Y' and D1CODE <> '2';
                     MiErr = 'Y';
                     MISRN = Ctr;
                     DECODE = 'Y';
                     $Msgid = '0167';
                     EXSR Err_Message;
                 When Code2_Fnd <> 'Y';

                     // If the same state is travelled more than once in a trip,
                     // the mileage code (1,2, or 3) must be consistent for that
                     // state on every mileage record it is found.  This is necessary
                     // since we automatically forward this code to the fuel file(TFFX).
                     // When we retrieve the code to attach to the fuel file, we look
                     // for the code from the mileage screen that has the same state.
                     // Therefore, we cannot have different codes.
                     // When validating, search the @STM (States travelled).
                     // Then look up the code associated with that line (@SMC St.Mil.Code)
                     // If the record found does not match this code, then error.

                     Fnd_Flg = 1;
                     Fnd_Flg = %Lookup(D1SE:@STM:Fnd_Flg);
                     Select;
                     When Fnd_Flg > 0 and D1CODE <> @SMC(Fnd_Flg);
                        MiErr = 'Y';
                        MISRN = Ctr;
                        DECODE = 'Y';
                        $Msgid = '0159';
                        EXSR Err_Message;
                     Other;
                        Fnd_Flg = 1;
                     EndSl;

                     // A Code '3' is only valid for a RENTAL unit for state of KY.
                     // 1/94 - Also allow a Code '3' for OFFLEASE units. (Can't key
                     //        an offlease customer, so identify with a flag - $OLEAS)

                     If D1CODE = '3'
                       And UPUSE <> 'RENTAL'
                       And $OLEAS = 'N'
                       Or D1CODE = '3'
                       And D1SE <> 'KY';
                       MiErr = 'Y';
                       MISRN = Ctr;
                       DECODE = 'Y';
                       $Msgid = '0160';
                       EXSR Err_Message;
                     EndIf;
                 EndSl;
           EndSl;

           Ctr = Ctr - 1;
         EndDo;

         // Calculate days from beginning to ending of trip.
         // Show override error if total days exceed 92 days (3 months).
         // If year is prior to 46, make century portion of date = 1.
         // Convert MMDDYY to CYYMMDD.

         Days_Diff = 1;
         Wk_MDY = LastDt;
         Exsr Validate_MDY;
         If not %Error();
           Wk_Date10 = %Date(LastDt:*MDY);
           WK_ENDDAT7 = %Dec(Wk_Date10:*CYMD);
           Days_Diff = %DIFF(Wk_Date10:%date(Beg_Date7:*CYMD):*DAYS);  //note date calc
         Endif;

         If Days_Diff > 92;
           MiErr = 'Y';
           $Msgid = '0115';
           EXSR Err_Message;
           // Populate line number as blanks for this paricular error.
           CLEAR MILLIN;
         EndIf;

         If UPUSE ='RENTAL';
           If MiErr <> 'Y';

             ExSr Getdates;

             Wk_Date7P = Wk_EndDat7P;
             ExSr Get_CusAdr;

             Select;
             When WK_CustErr = 'N';
               Valid = 'N';
               Wk_BegDt10 = %DATE(Beg_Date7:*CYMD);

               ResultSet    = ResultSet1;

               Exsr Compare_Begin_Date;

             When WK_CustErr = 'M' OR WK_CustErr = 'X';
               ExSr Mlti_Cust;

             EndSl;

             // If no valid record available for the ending date also
             If Valid = 'N';
               // Check the records between Beg.Date and EndDate
               Wk_Date7P = Wk_BegDat7P;
               Wk_EndDat7 = Wk_EndDat7P;
               ExSr GetNxtTrpdt;
             EndIf;

             // Check the records from 10 days prior to the Beg.Date
             If Valid = 'N';

               If Wk_BegDat7P <> 0;
                  Wk_Date10 = %Date(Wk_BegDat7P:*Cymd) - %Days(10);
                  Wk_Date7P = %Dec(Wk_Date10:*cymd);
               Endif;
               Wk_EndDat7 = Wk_BegDat7P;
               ExSr GetNxtTrpdt;
             EndIf;

             // Check the records from End Date to 10 days after end date
             If Valid = 'N';
               Wk_Date7P = Wk_EndDat7P;
               If Wk_EndDat7P <> 0;
                  Wk_Date10 = %Date(Wk_EndDat7P:*Cymd) + %Days(10);
                  Wk_EndDat7 = %Dec(Wk_Date10:*cymd);
               Endif;
               ExSr GetNxtTrpdt;
             EndIf;

             //  End for the MIERR
           EndIf;
           //  End for the $use
         EndIf;

         If Valid = 'Y';
           // Dont display confirmation during the toggle
           If *INKP = *OFF;
             //  If we find more appropriate customer
             If DSCUST <> $Custnum;
               //  Ask for user confirmation  (*IN64 = Invite)
               *IN64 = *ON;
               WCUST = $ACCOUNT;
               WBGRP = $Custgrp;
               WDIST = $DIST;
               WCSNM = $Customer;
               Write CNFWND;
               Read DTSTENTD;

               If DCUSYN = 'Y';
                 *IN45 = *OFF;
                 DSCUST = $ACCOUNT;
                 DSCBG = $Custgrp;
                 DSCDST = $DIST;
                 DSCUSN = $Customer;
                 CSKEYD = 'Y';
                 GoAhead = 'Y';
                 ExSr ChkErrs;
                 // Clear the trip error in case no errors other than customer
                 If GoAhead = 'Y';
                   TMERR = ' ';
                 EndIf;

               EndIf;
             EndIf;
             // End for the F15 indicator
           EndIf;
           // End of Valid
         EndIf;

       EndSr;

       //-----------------------------------------------------------------------
       // Load_Ds_Sfl - Load DS to Sfl
       //-----------------------------------------------------------------------

       BegSr Load_Ds_Sfl;

         // Load DS back to SFL & Update records showing any errors.
         // CLEAR MILEAGE SCREEN

         *IN(60) = *On;
         *IN(61) = *Off;
         *IN(62) = *Off;
         *IN(63) = *Off;
         *IN(64) = *Off;
         *IN(65) = *Off;
         *IN(66) = *Off;
         *IN(67) = *Off;
         *IN(68) = *Off;
         *IN(69) = *Off;
         WRITE MILCTL;
         *IN(60) = *Off;
         *IN(61) = *Off;
         *IN(62) = *On;
         *IN(63) = *On;
         *IN(64) = *Off;
         *IN(65) = *Off;
         *IN(66) = *Off;
         *IN(67) = *Off;
         *IN(68) = *Off;
         *IN(69) = *Off;

         // Set positioning indicator if errors exist

         If MIERR = 'Y';
           *IN44 = *ON;
         ENDIF;

         // Set on Subfile Next Change.

         *IN65 = *ON;

         CLEAR MRRN;
         DORRN = SAVRRN;
         CLEAR SAVRRN;
         For Ctr = 1 To DORRN;
           %Occur(D1MILE) = Ctr;
           MRRN = MRRN + 1;
           MILE   = D1MILE;
           DSTMDY = D1TMDY;
           Mile_RRN = MRRN;
           EvalR DSLINE = %Editc(MRRN:'X');
           SAVRRN = SAVRRN + 1;

           Select;
           When *IN57 = *OFF and *IN35 = *ON;
             KILOS = 0;
             If (HMILE * 1.609) <= 9999999 and HMILE > 0;
               Eval(H) KILOS = HMILE * 1.609;
             Endif;
           When *IN35 = *ON;
             KILOS = 0;
             Eval(H) KILOS = HMILE / 1.609;
           EndSl;

           // If 1st mileage record, protect trip date and state.

           EXSR Protect_TrpDt_St;

           %Occur(DEMILE) = Ctr;
           *In56 = (DESOPT = 'Y');
           *In43 = (DETMDY = 'Y');
           *In52 = (DESE = 'Y');
           *In58 = (DEBODM = 'Y');
           *In59 = (DECODE = 'Y');
           WRITE MILSFL;
         EndFor;

         *IN68 = *ON;

       EndSr;

       //-----------------------------------------------------------------------
       // Underline_Route_Field - Underline route field subroutine
       //-----------------------------------------------------------------------
       BegSr Underline_Route_Field;

         // Underline Route columns for input.
         // Set on Subfile Next Change.

         *IN65 = *ON;

         For Ctr = 1 To SAVRRN;
           CHAIN Ctr MILSFL;

           // If 1st record, protect beginning trip date field.

           *IN29 = *OFF;
           If Ctr = 1;
             *IN29 = *ON;
           EndIf;

           UPDATE MILSFL;
         EndFor;

       EndSr;
       //-----------------------------------------------------------------------
       // Insert_Mil_Record - Insert blank mileage record subroutine
       //-----------------------------------------------------------------------

       BegSr Insert_Mil_Record;

         Exsr Clr_Multi_Ds;
         Exsr Load_Multi_Ds;

         // If the maximum number of records allowed to be written has
         // has already been written, and the last one has DTR data
         // (not a blank line in ADD mode), then send error that no
         // additional lines can be inserted.
         // NOTE: A maximum of 99 is implemented since the line field
         //       is limited to 2 characters on the file and the need
         //       for more than 99 will never occur.  (I know, famous
         //       last words!!!)

         If SAVRRN = 99
           And DSTMDY <> 0;
           *IN56 = *ON;
           $Msgid = '0103';
           EXSR Err_Message;
           LeaveSr;
         EndIf;

           SAV28 = *IN28;
           SAV30 = *IN30;
           Exsr Clear_Mileage_Panel;
           *IN28 = SAV28;
           *IN30 = SAV30;
           *IN65 = *ON;
           CLEAR Ctr;
           CLEAR MRRN;

           Select;
           When INSEOF = 'I';
             DORRN = 1;
             MISRN = 1;

             // If 99 lines written and 99th is blank(already determined above)
             // then subtract one from the total number of times the DO loop
             // is executed below, so that the inserted blank line will not
             // cause an array index error when writing the extra record.

           When SAVRRN = 99;
               DORRN = 98;
           Other;
               DORRN = SAVRRN;
           EndSl;

           CLEAR SAVRRN;
           For Ctr = 1 To DORRN;
             %Occur(D1MILE) = Ctr;
             MRRN = MRRN + 1;
             MILE  = D1MILE;
             CLEAR MILOPT;
             DSTMDY = D1TMDY;
             Mile_RRN = MRRN;
             EvalR DSLINE = %Editc(MRRN:'X');
             SAVRRN = SAVRRN + 1;

             // If this is the first line being written then protect the
             // beginning trip date and state display fields.

             Exsr Protect_TrpDt_St;

             // If first line being written is a blank Insert line accessed via
             // the EOF prompt message, then automatically load with the
             // beginning trip date and departing state.

             Select;
             When INSEOF = 'I';
               DSTMDY = DSBDAT;
               DSSE = DSDPS;
               WRITE MILSFL;

               // Otherwise, if other mileage line, then re-write.

             When D1SOPT = 'I';                //indicates  INSEOF <> 'I'
               WRITE MILSFL;

               // Otherwise, if insert from mileage line,write blank insert line.

                 *IN29 = *OFF;
                 CLEAR MILOPT;
                 CLEAR DSTMDY;
                 CLEAR DSSE;
                 CLEAR DSSTNM;
                 CLEAR DSRTES;
                 CLEAR DSBODM;
                 CLEAR DSCODE;
                 CLEAR DSLE;
                 CLEAR DSTOLL;
                 CLEAR KILOS;
                 CLEAR DSRCWT;
                 CLEAR DSAXLE;
                 CLEAR DSKYU;
                 CLEAR HODOM;
                 CLEAR HMILE;
                 MRRN = MRRN + 1;
                 Mile_RRN = MRRN;
                 EvalR DSLINE = %Editc(MRRN:'X');
                 SAVRRN = SAVRRN + 1;
                 MISRN = Mile_RRN;
                 WRITE MILSFL;

             When INSEOF <> 'I';
                 WRITE MILSFL;

             EndSl;
           EndFor;

           *IN68 = *ON;
           INSEOF = ' ';

       EndSr;

       //-----------------------------------------------------------------------
       // Delete_Mil_Record - Delete mileage record subroutine
       //-----------------------------------------------------------------------

       BegSr Delete_Mil_Record;

         MISRN = 1;
         EXSR Clr_Multi_Ds;
         Exsr Load_Multi_Ds;

         SAV28 = *IN28;
         SAV30 = *IN30;
         Exsr Clear_Mileage_Panel;
         *IN28 = SAV28;
         *IN30 = SAV30;
         *IN65 = *ON;
         CLEAR Ctr;
         CLEAR MRRN;
         DORRN = SAVRRN;
         CLEAR SAVRRN;
         For Ctr = 1 To DORRN;
           %Occur(D1MILE) = Ctr;
           If D1SOPT <> 'D';
             MRRN = MRRN + 1;
             MILE = D1MILE;
             DSTMDY = D1TMDY;
             Mile_RRN = MRRN;
             EvalR DSLINE = %Editc(MRRN:'X');
             SAVRRN = SAVRRN + 1;

           // If 1st mileage record, protect trip date and state.
             Exsr Protect_TrpDt_St;

             WRITE MILSFL;
           EndIf;
         EndFor;

         If Mile_RRN = 0;
           *IN63 = *OFF;
         EndIf;

         *IN68 = *ON;

       EndSr;

       //-----------------------------------------------------------------------
       // Clr_Multi_Ds - Clear multiple occur data structure subroutine
       //-----------------------------------------------------------------------

       BegSr Clr_Multi_Ds;

         If SAVRRN = 0;
           CLEAR D1MILE;
         ENDIF;
         For Ctr = 1 To SAVRRN;
           %Occur(D1MILE) = Ctr;
           CLEAR D1MILE;
         EndFor;

       EndSr;

       //-----------------------------------------------------------------------
       // Clr_Multi_Err_Ds - Clear multiple occur error data structure
       //-----------------------------------------------------------------------

       BegSr Clr_Multi_Err_Ds;

         For Ctr = 1 To 99;
           %Occur(DEMILE) = Ctr;
           CLEAR DEMILE;
         EndFor;

       EndSr;

       //-----------------------------------------------------------------------
       // Load_Multi_Ds - Load multiple occur error data structure
       //-----------------------------------------------------------------------

       BegSr Load_Multi_Ds;

         For Ctr = 1 To SAVRRN;
           CHAIN Ctr MILSFL;
           If %Found();
             %Occur(D1MILE) = Ctr;
             DSMDY = DSTMDY;
             D1MILE = MILE;
           EndIf;
         EndFor;

       EndSr;

       //-----------------------------------------------------------------------
       // Prc_Add_State_Mil_Req - Process additional state mileage requirements
       //-----------------------------------------------------------------------

       BegSr Prc_Add_State_Mil_Req;
         PANEL = 'ASR ';

         // Initially set off the ability to perform F5 or F7 since
         // validation must be performed before we know if these keys
         // will be required.

         *IN32 = *OFF;
         *IN33 = *OFF;

         // If F2 pressed from subsequent screen, turn on SFLDSP & SFLEND.

         *IN63 = *INKB;      //Turn On SFLDSP & SFLEND if *INKB is *ON (F2 pressed)
         *IN68 = *INKB;

         If *INKB = *OFF;

           // If not returning from subsequent screen, continue processing.
           // Clear Additional State Requirements panel.

           EXSR Clr_Add_St_Mil_Req;

           CHAIN 1 MILSFL;

           // Fill ASR Panel.

           EXSR Fill_Add_St_Mil_Req;
         EndIf;

         Loop4 = *ON;
         DoW Loop4 = *ON;

       // Clear message line and write any error messages.

         WRITE MSGCLR;
         WRITE MSGCTL;

         If AState_Req_Fnd = 'Y';

           // AFTER subfile records have been written/updated, determine if
           // additional state mileage requirements are needed.  If they are,
           // then determine which ones were found and turn on control record
           // heading.

           *In36 = (LEFND = 'Y');
           *In37 = (TOLFND = 'Y');
           *In38 = (WGTFND = 'Y');
           *In39 = (AXLFND = 'Y');

           // Write/Read Prompt screen.

           WRITE TITLE;
           WRITE CUST;
           WRITE ASRFUN;

           *In64 = *On;
           WRITE ASRCTL;
           READ DTSTENTD;
           *In67 = %Eof;

           // Clear Message Subfile (MSGSFL).

           *IN70 = *OFF;

           // Initially set off the ability to perform F5 or F7 since
           // validation must be performed before we know if these keys
           // will be required.

           *IN32 = *OFF;
           *IN33 = *OFF;

           // Set Off SFLNXTCHG and SFLRCDNBR(CURSOR)

           *IN65 = *OFF;
           *IN66 = *OFF;

           // Set Off Subfile Field's Reverse Image Indicators.

           *IN71 = *OFF;
           *IN72 = *OFF;
           *IN73 = *OFF;
           *IN74 = *OFF;

           // Process Function Keys

           // F1=Exit

           Select;
           When *INKA = *ON;
             SPVEXIT ( CONFRM );
             If CONFRM = 'Y';
                LeaveSr;
             Endif;
             Iter;

           // F2=Return to Batch Logging Program
           When *INKB = *ON;
             LeaveSr;

           // F4=Window
           When *INKD = *ON;
              EXSR Inquiry_Window;
              Iter;

           // HELP key pressed.
           When *IN90 = *ON;
              EXSR Process_Help;
              Iter;

           Endsl;

           // Reset Error Accumulators.

           Exsr Reset_Err_Acc;

           // Clear ASR Error Message Mult. Occur. Data Structure.

           Exsr Clear_Asr_Mult_Ds;

           Wk_DSRCWT = 0;
           Ad_Mile_RRN = 1;

           READC ASRSFL;
           // LOOP TO READ SUBFILE
           Dow Not %Eof();
             *IN(71) = *Off;
             *IN(72) = *Off;
             *IN(73) = *Off;
             *IN(74) = *Off;

             If Wk_DSRCWT = 0;
               Wk_DSRCWT = DSRCWT;
               Wk_DSAXLE = DSAXLE;
             Endif;

             If Wk_DSRCWT = 0 and #DSRCWT > 0;
               Wk_DSRCWT = #DSRCWT;
               Wk_DSAXLE = #DSAXLE;
             Endif;

             // Validate Additional State Requirements screen input.

             EXSR Vali_Addi_st_Mil_req;
             UPDATE ASRSFL;
             READC ASRSFL;
           EndDo;

           // If ERRORS, Redisplay panel.

           If OVER > 0
             Or SUSP > 0
             Or FATAL > 0;

             // If no FATAL severity errors, then
             // allow F7 if SUSPEND errors and F5 if only OVERRIDE errors.

             Exsr SUSP_OVER_Err;

             // If errors, and F5 and F7 not taken, redisplay screen.

             Select;
             When *INKE = *OFF
               And *INKG = *OFF;
               Iter;

             When *INKG = *ON
                 And *IN07 = *ON;

                 // MOVE SUSPENDED DTR TO SUSPENDED BOX
                 Exsr DTS_Sus_Rej;

             EndSl;
           EndIf;
         EndIf;
         Loop4 = *OFF;
         Enddo;

        EndSr;

       //-----------------------------------------------------------------------
       // Clr_Add_St_Mil_Req - Clear additional state mileage requirements scrn
       //-----------------------------------------------------------------------

       BegSr Clr_Add_St_Mil_Req;

         *IN(60) = *On;
         *IN(61) = *Off;
         *IN(62) = *Off;
         *IN(63) = *Off;
         *IN(64) = *Off;
         *IN(65) = *Off;
         *IN(66) = *Off;
         *IN(67) = *Off;
         *IN(68) = *Off;
         *IN(69) = *Off;
         WRITE ASRCTL;
         *IN(60) = *Off;
         *IN(61) = *Off;
         *IN(62) = *On;
         *IN(63) = *On;
         *IN(64) = *Off;
         *IN(65) = *Off;
         *IN(66) = *Off;
         *IN(67) = *Off;
         *IN(68) = *Off;
         *IN(69) = *Off;
         *IN(70) = *Off;

         CLEAR Ad_Mile_RRN;

       EndSr;

       //-----------------------------------------------------------------------
       // Clear_Asr_Mult_Ds - Clear ASR message mult. occur DS subroutine
       //-----------------------------------------------------------------------
       BegSr Clear_Asr_Mult_Ds;

         For Ctr = 1 To 20;
           %Occur(ASRMSG) = Ctr;
           CLEAR ASRMSG;
         EndFor;

         // AState_Err_Cnt = Total number of ASR screen errors

         CLEAR AState_Err_Cnt;

       EndSr;
       //-----------------------------------------------------------------------
       // Fill_Add_St_Mil_Req - Fill additional state mileage requirements panel
       //-----------------------------------------------------------------------
       BegSr Fill_Add_St_Mil_Req;

         // Clear work fields.

         AState_Req_Fnd = NO;
         TOLFND = NO;
         LEFND  = NO;
         WGTFND = NO;
         AXLFND = NO;
         FIRST =  NO;

         // Loop to load subfile with all records from the mileage screen.

         Dow True;
           Wk_MDY = DstMDY;
           Exsr Validate_MDY;
           If %Error();
             Wk_EndDat7 = 0;
           Else;
             Wk_Date10 = %Date(DstMDY:*MDY);
             Wk_EndDat7 = %Dec(Wk_Date10:*CYMD);
           Endif;

           // If chain is successful, Fill subfile
           If %Found();

             // Retrieve State Requirements Information.
             getdtssrq(DSSE: DSCUST: DSCDST: Today_7 :
             srqFound: DTSSRQds);

             // Non-Display Additional State Requirements fields.
             *IN36 = *OFF;
             *IN37 = *OFF;
             *IN38 = *OFF;
             *IN39 = *OFF;
             *IN84 = *OFF;
             *IN85 = *OFF;
             *IN86 = *OFF;

             // Weight will display for all states
             If MODE = 'DISPLAY';
               AState_Req_Fnd = YES;
               WGTFND = YES;
               *IN38 = *ON;
             EndIf;

             If RQWGHT <> 'Y';
                Exec Sql Select RQWGHT, RQAXLE
                           into :RQWGHT, :RQAXLE
                           from FDTSSRQ
                          Where RQST = :DSSE AND RQWGHT = 'Y' AND
                                RQEFDT <= :Today_7 and RQEXDT >= :Today_7
                          Fetch First rows only;
             Endif;

             If srqFound = *ON or SqlCode = 0;
               If MODE <> 'DISPLAY';
                 *IN65 = *ON;
               EndIf;

               // Loaded/Empty required?
JP01           Exec Sql Select (1)
JP01                      into :Data_Fnd
JP01                      from FDTSSRQ
JP01                     Where RQST = :DSSE AND RCUST = ' ' AND RQLE = 'Y' AND
JP01                           RQEFDT <= :Today_7 and RQEXDT >= :Today_7
JP01                     Fetch First rows only;
JP01
JP01           //If RQLE = 'Y';
JP01           If RQLE = 'Y' or SqlCode = 0;
                  AState_Req_Fnd = YES;
                  LEFND  = YES;
                 *IN36 = *ON;
               Else;
JP01              //DSLE = ' ';
JP01              DSLE = 'L';
               EndIf;

               // Toll Miles required?
               If RQTOLL = 'Y';
                  AState_Req_Fnd = YES;
                  TOLFND = YES;
                 *IN37 = *ON;
               Else;
                  DSTOLL = 0;
               EndIf;

               // Weight required? or Axles required?
               Exsr Weight_Axle_Req;

             EndIf;

             Ad_Mile_RRN = Ad_Mile_RRN + 1;
             WRITE ASRSFL;
JP01         UPDATE MILSFL;
             *IN(62) = *On;
             *IN(63) = *On;
           EndIf;

           // Position panel at first record written.

           If FIRST = 'N';
             ASSRN = Ad_Mile_RRN;
             FIRST = 'Y';
           EndIf;

           MRRN = Ad_Mile_RRN + 1;
           CHAIN MRRN MILSFL;
           If Not %Found();
             Leave;
           EndIf;

           // If mileage subfile record is blank, then exit loop
           If DSTMDY = 0;
             Leave;
           EndIf;
         EndDo;
         *IN68 = *ON;
       EndSr;
       //-----------------------------------------------------------------------
       // Weight_Axle_Req - Check whether the Weight or Axle is required
       //-----------------------------------------------------------------------

       BegSr Weight_Axle_Req;

          // Weight required?
          If RQWGHT = 'Y' or RQKYU = 'Y';
            AState_Req_Fnd = YES;
            WGTFND = YES;
            *IN38 = *ON;
          EndIf;

          // Axles required?
          If RQAXLE = 'Y' or RQKYU = 'Y';
            AState_Req_Fnd = YES;
            AXLFND = YES;
            *IN39 = *ON;
          EndIf;

          IF RQKYU = YES AND AState_Req_Fnd = YES;
            DSASRTXT ='Taxable';
            *IN85 = *ON;
          EndIf;

          IF *IN84 = *ON AND *IN85 = *ON;
            DSASRTXT ='Tax/KYU#';
          ENDIF;

       EndSr;
       //-----------------------------------------------------------------------
       // Vali_Addi_st_Mil_Req - Validate add state mileage req panel
       //-----------------------------------------------------------------------

       BegSr Vali_Addi_st_Mil_req;

         // Non-Display Additional State Requirements fields.

         *IN36 = *OFF;
         *IN37 = *OFF;
         *IN38 = *OFF;
         *IN39 = *OFF;
         *IN84 = *OFF;
         *IN85 = *OFF;
         *IN86 = *OFF;
         WKFLG = ' ';

         #DSRCWT = 0;
         #DSAXLE = 0;

         // The following section of code was commented out, then put back
         //  to preserve the XFLG logic.
         // Additional research is needed to determine the effects in
         //   bustr/lustr/nustr.
         Reset DTSSRQds;

         getdtssrq(DSSE: DSCUST: DSCDST: Today_7 :
         srqFound: DTSSRQds);

         If RQLE = 'Y';
            WKFLG = 'Y';
         Endif;

         If RQWGHT <> 'Y';
            Exec Sql Select RQWGHT, RQAXLE
                       into :RQWGHT, :RQAXLE
                       from FDTSSRQ
                      Where RQST = :DSSE AND RQWGHT = 'Y' AND
                            RQEFDT <= :Today_7 and RQEXDT >= :Today_7
                      Fetch First rows only;
         Endif;

         // Customer,unit,wieght and axle validation using the program FMTAXLVLDR
         IF (RQWGHT ='Y' AND RQAXLE ='Y');
           Exsr Addtnl_WgtAxl_Vldr;
         ENDIF;

         // Weight required? or Axles required?
         Exsr Weight_Axle_Req;

         Select;
         When RQWGHT ='Y' AND RQAXLE ='Y' AND PError <> *Blanks;
             *IN73 = *ON;
             *IN74 = *ON;

             $Msgid = '0916';
             EXSR Err_Message;
             *IN38 = *ON;
             *IN39 = *ON;
             LEAVESR;
         When RQWGHT ='Y' AND RQAXLE ='Y';
             *IN73 = *OFF;
             *IN74 = *OFF;

             If PLicWgt <> *Blanks;
               #DSRCWT = %Dec(PLicWgt:7:0);
             EndIf;

             If PAxles <> *Blanks;
               #DSAXLE = %Dec(PAxles:2:0);
             EndIf;

             TMERR   = '  ';
         ENDSL;


         IF DSTAX <> '1' AND DSTAX <>'2' AND
           DSTAX <> ' ';
           *IN86 = *ON;
           AState_Err_Cnt = AState_Err_Cnt + 1;
           $Msgid = '0919';
           $MDATA = DSTAX;
           EXSR Err_Message;
           LEAVESR;
         ENDIF;
         *IN86 = *OFF;
         DSCODE = DSTAX;

         If srqFound = *ON;

           // Validate Loaded/Empty if active.
           // Must be an 'L' , 'E' , or blank (defaults to 'L'oaded).

           If WKFLG = 'Y'
             And DSLE = ' ';
             DSLE = 'L';
           ENDIF;
           If RQLE = 'Y';
             *IN36 = *ON;
             Select;
             When DSLE = ' ';
               DSLE = 'L';
             When DSLE <> 'L'
                 And DSLE <> 'E';
                 *IN71 = *ON;
                 ASSRN = Ad_Mile_RRN;
                 $Msgid = '0161';
                 EXSR Err_Message;
             EndSl;
           EndIf;

           // Validate Toll Miles if active.
           // Cannot be greater than the miles driven in the state.

           If RQTOLL = 'Y';
             *IN37 = *ON;

             If DSTOLL > HMILE;
               *IN72 = *ON;
               ASSRN = Ad_Mile_RRN;
               $Msgid = '0162';
               EXSR Err_Message;
             EndIf;
           EndIf;

           //*========================================================= *

           // IF WEIGHT IS NOT INPUT, THEN THE LICENSE WEIGHT WILL BE USED
           // UNLESS EMPTY IS SPECIFIED ON THOSE STATES WHERE L/E IS ALLOWED.
           // IN THE CASE WHERE EMPTY IS SPECIFIED, THE TARE WEIGHT WILL BE
           // USED IF NO WEIGHT IS INPUT.
           //   2/4/94 - Always use the license weight for Oregon when not
           //            keyed by user - do NOT use the tare weight.
           //          ---------------------------------------

           If *IN71 = *OFF
            and DSRCWT = 0;

              DSRCWT = 0;
              If PLicWgt <> *Blanks;
               DSRCWT = %Dec(PLicWgt:7:0);
              Endif;

              DSAXLE = 0;
              If PAxles <> *Blanks;
               DSAXLE = %Dec(PAxles:2:0);
              Endif;

               If DSLE = 'E'
                 And RQWGHT <> 'Y';
                 DSRCWT = WKTARE;
               EndIf;

           EndIf;
         EndIf;
         //*========================================================= *
         //* OLD OREGON DEFAULTS   - changed 2/4/94                   *
         //*========================================================= *
         //*
         // ========================================================= *
         //  NEW OREGON DEFAULTS   -   2/4/94                         *
         // ========================================================= *
         // For Oregon, validate or fill blank axles as follows:

         // 1. Accept all axles keyed when weight is UNDER 80,000.
         // 2. For weights  80,001 -  92,000 accept > or = 6 axles, default=6.
         //    For weights  92,001 - 102,000 accept > or = 7 axles, default=7.
         //    For weights 102,001 - 105,500 accept > or = 8 axles, default=8.
         // ----------------------------------------------------------

         If RQAXLE = 'Y';
           *IN39 = *ON;

           // If the state is Oregon.
           If RQWGHT = 'Y';

             TSTWT = DSRCWT;
             If *IN57 = *On;
               Eval(H) TSTWT = DSRCWT * 2.2;
             EndIf;
             //      AMD !!!!  WHENGT excludes the weight - s/b GTE ???
             //   If zero axles were keyed, enter the default.
             If DSAXLE = 0;
               SELECT;

                 //     If between 102,001 and 105,000.
               When TSTWT > 102001;
                 DSAXLE = 8;

                 //     If between 92,001 and 102,000.
               When TSTWT > 92001;
                 DSAXLE = 7;

                 //     If between 80,001 and 92,000.
               When TSTWT > 80001;
                 DSAXLE = 6;

                 //     If under the minimum weight (80,000).
                 //          Do NOT enter a default.

               ENDSL;

             ENDIF;

           ENDIF;

         EndIf;
       EndSr;
       //**************************************************************************************
       //  Addtnl_WgtAxl_Vldr- Addition state requirments Customer,Unit,axle and
       //  Weight combination validation using program FMTAXLVLDR
       //**************************************************************************************
       BegSr Addtnl_WgtAxl_Vldr;

         PState  = DSSE;
         PLicWgt = %Char(DSRCWT);
         PAxles  = %Char(DSAXLE);
         PError  = *Blanks;
         #DSRCWT = *Zeros;
         #DSAXLE = *Zeros;
         PBegDate = %Date(DSTMDY:*MDY);

         FMTAXLVLDR(DsCorp:DsCust:DsUnit:PBegDate:
                    PState:PLicWgt:PAxles:PError);
       EndSr;
      ***************************************************************************************
      * WgtAxl_Vldr - Customer,Unit,axle and Weight combination validation using program FMTAXLVLDR
      ***************************************************************************************
       BegSr WgtAxl_Vldr;

        WKFCtr = 1;
        DoW WKFCtr <= SAVRRN;
         If @ST(WKFCtr) <> ' ';
         // Reset Work variable value
         PState  = @ST(WKFCtr);
         PLicWgt = *Blanks;
         PAxles  = *Blanks;
         PError  = *Blanks;
         #DSRCWT = *Zeros;
         #DSAXLE = *Zeros;
         PBegDate = %Date(Beg_Date7:*CYMD);
         FMTAXLVLDR(DsCorp:DsCust:DsUnit:PBegDate:
                    PState:PLicWgt:PAxles:PError);

         Lwieght_Susp = '0';

         If PError = *Blanks;

           If PLicWgt <> *Blanks;
             #DSRCWT = %Dec(PLicWgt:7:0);
           EndIf;

           If PAxles <> *Blanks;
             #DSAXLE = %Dec(PAxles:2:0);
           EndIf;

         Else;
           TMERR = 'Y';
           $Msgid = '0916';
           EXSR Err_Message;
           Lwieght_Susp = '1';
           #DSRCWT = *ZEROS;
           #DSAXLE = *ZEROS;
         Endif;

         @STWGT(WKFCtr) = #DSRCWT;
         @STAXL(WKFCtr) = #DSAXLE;

         If Wk_DSRCWT = 0;
           Wk_DSRCWT = #DSRCWT;
           Wk_DSAXLE = #DSAXLE;
         Endif;
         Endif;
         WKFCtr = WKFCtr + 1;
        EndDo;

       EndSr;
       //-----------------------------------------------------------------------
       // Proc_Bill_Fuel - Process billing fuel subroutine
       //-----------------------------------------------------------------------
       BegSr Proc_Bill_Fuel;

         PANEL = 'BILL';
         *IN33 = *OFF;

         Select;
         When *INKB = *ON and Bill_RRN > 0;
         // If F2 pressed from subsequent screen and
         // If there were billing records, turn on SFLDSP

           If Bill_RRN > 0;
             *IN63 = *ON;
           EndIf;
           BISRN = 1;

         When *INKB = *ON;

           // If there are were no billing records, turn off SFLDSP
           *IN63 = *OFF;
           BISRN = 1;
         Other;

           // If F2 not pressed from subsequent screen, clear billing screen.
           Exsr Clr_Bill_Fuel_Panel;
           CLEAR DSSTDT;

           // calculate the date 2 days after the ending trip date
           // Search for records starting 3 days prior to beg. trip date.
           // Changed for 3 days to 2 days prior to beg trip date.

           If Beg_Date7 > 0;
             Wk_Date10 = %Date(Beg_Date7:*CYMD) - %Days(3);
             Wk_Date7  = %Dec(Wk_Date10:*CYMD);
             Wk_Date7P = Wk_Date7;
           Else;
             Wk_Date10 = %Date('0001-01-01');
             Wk_Date7 = 0;
             Wk_Date7P = 0;
           Endif;

         EndSl;

       // If not at the end of the subfile, continue to fill with records.
       // If at the end of the subfile, and ROLL pressed, notify user w/ err

        If *in68 = *On;
           Exsr Clr_Bill_Fuel_Panel;
           CLEAR DSSTDT;
        Endif;

        // Connect To Remote system
        Exec Sql Set Connection :WkRemote;
        Exec Sql Open Entr_Tkt_Cursor;

        Exsr @FLBIL;

        Loop4 = *ON;
        DoW Loop4 = *ON;

       // Clear message line and write any error messages.

         WRITE MSGCLR;
         WRITE MSGCTL;

         // Write/Read Billing screen.

         WRITE TITLE;
         WRITE CUST;
         If Bill_RRN = 0;
           WRITE BILEOF;
         EndIf;
         WRITE BILFUN;

         *In64 = *On;
         WRITE BILCTL;
         READ DTSTENTD;
         *In67 = %Eof;

         // Clear Message Subfile (MSGSFL).
         *IN70 = *OFF;
         *IN33 = *OFF;

         // Set Off Subfile Field's Reverse Image Indicators.
         *IN43 = *OFF;
         *IN56 = *OFF;

         // Set Off SFLNXTCHG and SFLRCDNBR(CURSOR)
         *IN65 = *OFF;
         *IN66 = *OFF;

         // Process ROLLUP key
         If *IN61 = *ON;
           Bill_RRN = SAVBRN;
           Exsr @FLBIL;
           Iter;
         Endif;

         // Process Function Keys
         // F1=Exit

         Select;
         When *INKA = *ON;
           SPVEXIT ( CONFRM );
           If ConFrm = 'Y';
              Leave;
           EndIf;
           Iter;

         // F2=Return to Batch Logging Program
         When *InKb = *On;
            Leave;

         // F4=Window
         When *INKD = *ON;
            EXSR Inquiry_Window;
            Iter;

         // HELP key pressed.
         When *IN90 = *ON;
            EXSR Process_Help;
            Iter;

         EndSl;

         // Determine if Start date was keyed.

         If DSSTDT <> 0;
           Wk_DATE6 = DSSTDT;
           EXSR Validate_Date;

           If WKSPER = *OFF;
             EXSR Clr_Bill_Fuel_Panel;
             Exec Sql Close Entr_Tkt_Cursor;

             Exec Sql Open Entr_Tkt_Cursor;

             Exsr @FLBIL;
             CLEAR DSSTDT;
           EndIf;
           Iter;
         EndIf;

         // Reset Error Accumulators.

         Exsr Reset_Err_Acc;

         CLEAR @BRN;
         CLEAR Ctr;

         // If fuel ticket records exist on the billing screen, then
         // process selections.
         If Bill_RRN > 0;
           Bill_RRN = 1;
           READC BILSFL;

           // Loop to READ subfile.

           Dow Not %Eof();

             // Set Off Subfile Field's Reverse Image Indicators.

             *IN43 = *OFF;
             *IN56 = *OFF;

             // If not Display mode, validate billing screen input.

             If MODE <> 'DISPLAY';
               EXSR Validate_Bill_Panel;
             EndIf;

             UPDATE BILSFL;

             READC BILSFL;
           EndDo;

           // If ERRORS, Redisplay screen.
           If OVER > 0
             Or SUSP > 0
             Or FATAL > 0;
             // If no FATAL severity errors, then allow F7 .
             If FATAL = 0  and SUSP > 0;
                 *IN33 = *ON;
             EndIf;

             Select;
             When *INKG = *OFF;
                Iter;
             When *INKG = *ON
                 And *IN07 = *ON;

                 // MOVE SUSPENDED DTR TO SUSPENDED BOX
                 Exsr DTS_Sus_Rej;
             EndSl;
           EndIf;
         EndIf;
         Leave;
        EndDo;
        Exec Sql Close Entr_Tkt_Cursor;

        // Connect To Local
          Exec Sql Set Connection :WkMachine;

       EndSr;
       //-----------------------------------------------------------------------
       // @FLBIL - If not at the end of the subfile, continue to fill with records.
       //        - If at the end of the subfile, and ROLL pressed, notify user w/ err
       //-----------------------------------------------------------------------
       BegSr @FLBIL;

         Select;
         When *IN68 = *OFF;
           Exsr Fill_Bill_Fuel_Panel;
         When *IN61 = *ON;
             *IN66 = *ON;
         EndSl;

       EndSr;
       //-----------------------------------------------------------------------
       // Clr_Bill_Fuel_Panel - Clear billing fuel panel subroutine
       //-----------------------------------------------------------------------

       BegSr Clr_Bill_Fuel_Panel;

         *IN(60) = *On;
         *IN(61) = *Off;
         *IN(62) = *Off;
         *IN(63) = *Off;
         *IN(64) = *Off;
         *IN(65) = *Off;
         *IN(66) = *Off;
         *IN(67) = *Off;
         *IN(68) = *Off;
         *IN(69) = *Off;
         WRITE BILCTL;
         *IN(60) = *Off;
         *IN(61) = *Off;
         *IN(62) = *On;
         *IN(63) = *On;
         *IN(64) = *Off;
         *IN(65) = *Off;
         *IN(66) = *Off;
         *IN(67) = *Off;
         *IN(68) = *Off;
         *IN(69) = *Off;
         *IN(70) = *Off;

         CLEAR Bill_RRN;

         Wk_Cust8 = DSCUST + DSCBG;

       EndSr;

       //-----------------------------------------------------------------------
       // Fill_Bill_Fuel_Panel - Fill bill fuel panel subroutine
       //-----------------------------------------------------------------------
       BegSr Fill_Bill_Fuel_Panel;

         CLEAR WK_COUNT1;
         FIRST = 'N';

         Exec Sql Select (1) into :Data_fnd
                             from FFUELTKTV4 a Join FLTFUETL1 b
                          on a.FtFTyp = b.FlFTyp and b.FlFSrF = 'Y'
                         and FTIUNI = :DSUNIT and FTCORP = :DSCORP
                         and FTPSTS = 'V' and FTICUS = :Wk_Cust8
                         and FTUDTR <> 'U' and FTGALN <> 0  and FTFUSE <> 'R'
                         and FTPDAT between :Wk_Date7P and :Wk_EndDat7
                         and a.FTFTYP = b.FLFTYP
                       Fetch first row only;
         If SqlCode <> 0;
            Exec Sql Select FTCORP,FTSRC into :HSCORP,:HSFSRC
                       from FFUELTKTV4 a, FLTFUETL1 b
                      Where FTIUNI = :DSUNIT and FTCORP = :DSCORP
                        and FTPSTS = 'V' and FTICUS = :Wk_Cust8
                        and FTGALN <> 0  and FTFUSE <> 'R'
                        and FTPDAT between :Wk_Date7P and :Wk_EndDat7
                        and a.FTFTYP = b.FLFTYP
                      Fetch first row only;
         Endif;

         // Loop to load subfile with up to 10 records (1 PAGE).
         Dow WK_COUNT1 < 10 and SqlCode = 0;

            Clear Ffueltkt;
            Exec Sql Fetch from Entr_Tkt_Cursor
                           into :FTUDTR,:FTGALN,:FTFUSE,:FTSTST,:FTTKNO,
                                :FTICUS,:FTODIS,:FTVEND,:FTSTNA,:FTSTCT,
                                :FTPDAT,:FTSRC,:FTCORP;

            Select;
            When SqlCode <> 0;
               Leave;
            When DSSTDT > 0 AND WKSPER <> '1';          //Entered Start Date
               if %Dec(%Date(DSSTDT:*MDY):*CYMD) > FTPDAT;
                 iter;
               Endif;
            EndSl;

           // If READ is successful, fill subfile.

             // Only write billing fuel records if not Used (U) and
             // not Aged (A) and not Sister City(C) and the
             // state is one of the states travelled (on mileage panel).

            If %LOOKUP(FTSTST:@STM) <> 0;                     //condition added in -
                                                           //Cursor Entr_Tkt_Cursor
               BILOPT = *BLANK;

               Wk_Date10 = %Date(FTPDAT:*CYMD);
               DsPDat = %Dec(Wk_Date10:*MDY);

               DSSTST = FTSTST;
               DSTKNO = FTTKNO;
               DSGALN = FTGALN;
               DSSCUS = FTICUS;
               DSSDST = FTODIS;

               HSFSRC = FTSRC;              //Move Corp and Source to Hidden Fields
               HSCORP = FTCORP;             //to update FFUELTKT file

               DSVEND = FTVEND;
               DSSTNA = FTSTNA;
               If FTVEND = *BLANKS And FTSRC <> 'F';
                  Ds_FDIST = FTPDIS;
                  DS_FLoc = FTPLOC;
                  Eval DSSTNA = XXXXXX;
               EndIf;

               DSSTCT = FTSTCT;
               Bill_RRN = Bill_RRN + 1;
               WK_COUNT1 = WK_COUNT1 + 1;

                 // If fuel was purchased between Beg & End trip dates, PROTECT
                 // option field since it will automatically be put on Purch Fuel.
                 // when in ADD mode.  DO NOT PROTECT option field in CHANGE mode.

               *IN30 = *OFF;
               If FTPDAT >= Beg_Date7 And FTPDAT <= Wk_EndDat7
                  And MODE = 'ADD    ';
                    *IN30 = *ON;
               EndIf;

               WRITE BILSFL;
               *IN(62) = *On;
               *IN(63) = *On;

                 // Position panel at first record written.
               If FIRST = 'N';
                  BISRN = Bill_RRN;
                  FIRST = 'Y';
               EndIf;
            EndIf;

           // If 99 records written (maximum), end loop and turn on SFLEND.

            If Bill_RRN = 99;
               WK_COUNT1 = 10;
               *IN68 = *ON;
            EndIf;
         EndDo;

              // If End of File reached with records written, then turn on SFLEND.
         Select;
         When SqlCode <> 0
           And Bill_RRN > 0;
             *IN68 = *ON;

              // If no records written, turn off SFLDSP.
         When Bill_RRN = 0;
           *IN63 = *OFF;
         EndSl;

         SAVBRN = Bill_RRN;
         //                                                    RCD WRITTEN
       EndSr;

       //-----------------------------------------------------------------------
       // Validate_Bill_Panel - Validate billing panel subroutine
       //-----------------------------------------------------------------------

       BegSr Validate_Bill_Panel;

         // Validate option.

           Select;
           When BILOPT <> 'X' And BILOPT <> ' ';
             *IN56 = *ON;
             BISRN = Bill_RRN;
             $Msgid = '0100';
             EXSR Err_Message;
           When BILOPT = 'X';
             Ctr = Ctr + 1;
             @BRN(Ctr) = Bill_RRN;
             CLEAR BILOPT;
           EndSl;

       EndSr;
       //-----------------------------------------------------------------------
       // Proc_Fuel_Purchase - Process fuel purchased subroutine
       //-----------------------------------------------------------------------

       BegSr Proc_Fuel_Purchase;

         PANEL = 'FUEL';

         Exsr Clear_Fuel_ind;

         // If returning from subsequent screen, reposition to 1st record.

         Select;
         When *INKB = *ON;
             FUSRN = 1;
                        // Load Subfile with records from file if DISPLAY or CHANGE mode
         When MODE <> 'ADD    ';
             Exsr Clr_Fuel_Pur_Panel;        // Clear Purchase Fuel screen.
             Exsr Fill_Fuel_Pur_Panel;
         Other;
             Exsr Clr_Fuel_Pur_Panel;        // Clear Purchase Fuel screen.
             Exsr Fill_Fuel_Pur_Panel_Add;
         EndSl;

         WK_COUNT1 = 0;
         Loop4 = *ON;
         DoW Loop4 = *ON;

       // Clear message line and write any error messages.

         WRITE MSGCLR;
         WRITE MSGCTL;

         // Write/Read Fuel Purchase screen.

         WRITE TITLE;
         WRITE CUST;

         If Fuel_RRN = 0;
           WRITE FULEOF;
         EndIf;

         WRITE FULFUN;

         *In64 = *On;
         WRITE FULCTL;
         READ DTSTENTD;
         *In67 = %Eof;

         If Fuel_RRN = 0;
           READ FULEOF;
           *InLR = %Eof;
         EndIf;

         // Clear Message Subfile (MSGSFL).

         *IN70 = *OFF;

         Exsr Clear_Fuel_ind;

         // Set Off SFLNXTCHG and SFLMSGID

         *IN66 = *OFF;

         // Process Function Keys

         // F1=Exit
         Select;
         When *INKA = *ON;
           SPVEXIT ( CONFRM );
           If Confrm = 'Y';
              LeaveSr;
           EndIf;
           Iter;

         // F2=Return to Batch Logging Program
         When *InKb = *On;
            LeaveSr;

         // F4=Window
         When *INKD = *ON;
           EXSR Inquiry_Window;
           Iter;

         // HELP key pressed.
         When *IN90 = *ON;
           EXSR Process_Help;
           Iter;

         // F14=Qty Measure
         // If F14 pressed (Not available in DISPLAY mode), redisplay
         // screen after removing PROTECT from that column.

         When *INKN = *ON And *IN27 = *OFF;
           Exsr Qty_Mer_Field;
           Iter;
         EndSl;

         // Reset Error Accumulators.

         Exsr Reset_Err_Acc;

         CLEAR SEL#;
         CLEAR INFRN;
         CLEAR DEFRN;

         // Clear Fuel Error Message Mult. Occur. Data Structure.

         EXSR Clr_Fuel_Msg_Ds;

         // If subfile records written, continue with normal processing

         Select;
         When Fuel_RRN > 0;
           Fuel_RRN = 1;
           DFL = *BLANKS;
           WK_COUNT2 = 1;
           If MODE <> 'DISPLAY';
             CHAIN Fuel_RRN FULSFL;

             // Loop to read subfile.
             // If changed record, move new state to array index.

             Wk_Fuel_Err = 0;
             WKFCtr = 0;
             EmFlag = 'N';
             If Fuel_Ds(1).Fuel_tkt = '         ';
               EmFlag = 'Y';
             Endif;

             Dow %Found();
               *IN43 = *OFF;
               *IN(52) = *Off;
               *IN(53) = *Off;
               *IN56 = *OFF;
               *IN(74) = *Off;
               *IN(75) = *Off;
               *IN(76) = *Off;
               *IN(77) = *Off;
               *IN(78) = *Off;
               *IN(79) = *Off;

               // No need to check mode since SFLNXTCHG not seton in display
               // mode.

               ExSr Validate_Fuel_Pur;

               If EmFlag = 'Y';
                 WKFCtr += 1;
                 Fuel_Ds(WKFCtr).Fuel_tkt = DSTKNO;
                 Fuel_Ds(WKFCtr).Fuel_src = HSFSRC;
               Endif;

               // CHECK DUPLICATE RECORDS IN FUEL SUBFILE

               If MODE <> 'DISPLAY' And DSDPUR <> 0;
                 Wk_MDY = DSDPUR;
                 Exsr Validate_MDY;
                 If %Error();
                   Wk_Date7 = 0;
                 Else;
                   Wk_Date10 = %Date(DSDPUR:*MDY);
                   Wk_Date7 = %Dec(Wk_Date10:*CYMD);
                 Endif;
                 DUPFLY = Wk_CYY7;
                 DUPFLM = DSDPMM;
                 DUPFLD = DSDPDD;
                 DUPFLS = DSSPUR;
                 DUPFLT = DSTKNO;
                 Fnd_Flg = 1;
                 Fnd_Flg = %Lookup(DUPFL:DFL:Fnd_Flg);

                 If Fnd_Flg > 0;
                    WRKQTY = QTY(Fnd_Flg);
                    WKFPG1 = WRKQTY - 1;
                    WKFPG2 = WRKQTY + 1;
                    Select;
                    When DSFPG >= WKFPG1 and DSFPG <= WKFPG2;
                       FUSRN = Fuel_RRN;
                       *IN56 = *ON;
                       *IN43 = *ON;
                       *IN52 = *ON;
                       *IN74 = *ON;
                       $Msgid = '0177';
                       EXSR Err_Message;
                       *IN54 = *ON;
                    Other;
                       Fnd_Flg= 1;
                       DFL(WK_COUNT2) = DUPFL;
                       QTY(WK_COUNT2) = DSFPG;
                       WK_COUNT2 = WK_COUNT2 + 1;
                    EndSl;
                 Else;
                    Fnd_Flg= 1;
                    DFL(WK_COUNT2) = DUPFL;
                    QTY(WK_COUNT2) = DSFPG;
                    WK_COUNT2 = WK_COUNT2 + 1;
                 EndIf;
               EndIf;

               // Set Off SFLNXTCHG and SFLRCDNBR(CURSOR)

               // If TFSRC='Y'(indicates record in billing fuel ticket file used)
               // then protect line from changes.  If change is required, user
               // must delete and reenter since the bill fuel file needs to have
               // the 'U'sed indicator removed.

               *IN31 = *OFF;
               If DSSRC = 'Y';
                 *IN31 = *ON;
               EndIf;

               UPDATE FULSFL;

               Fuel_RRN = Fuel_RRN + 1;
               Chain Fuel_RRN FULSFL;
             EndDo;
           ENDIF;

           // If insert, redisplay panel.

           Select;
           When INFRN <> 0;
             *IN43 = *OFF;
             *IN(52) = *Off;
             *IN(53) = *Off;
             *IN56 = *OFF;
             *IN(74) = *Off;
             *IN(75) = *Off;
             *IN(76) = *Off;
             *IN(77) = *Off;
             *IN(78) = *Off;
             *IN(79) = *Off;
             Exsr Insert_Fuel_Rec;

             // If delete, redisplay panel.
           When DEFRN <> 0;
               *IN43 = *OFF;
               *IN(52) = *Off;
               *IN(53) = *Off;
               *IN56 = *OFF;
               *IN(74) = *Off;
               *IN(75) = *Off;
               *IN(76) = *Off;
               *IN(77) = *Off;
               *IN(78) = *Off;
               *IN(79) = *Off;
               Exsr Delete_Fuel_Rec;
           EndSl;

           // If errors, redisplay panel.

           If OVER > 0
             Or SUSP > 0
             Or FATAL > 0
             Or INFRN > 0
             Or DEFRN > 0;

             // If no FATAL severity errors, then
             // allow F7 if SUSPEND errors and F5 if only OVERRIDE errors.

             Exsr SUSP_OVER_Err;

             // If errors, and F5 and F7 not pressed, redisplay screen.

             Select;
             When *INKE = *OFF
               And *INKG = *OFF;
               Iter;

             When *INKG = *ON
                 And *IN07 = *ON;

                 // MOVE SUSPENDED DTR TO SUSPENDED BOX
                 Exsr DTS_Sus_Rej;

             EndSl;
           EndIf;

         When INSEOF = 'I';
             *IN63 = *ON;
             CLEAR INFRN;
             Exsr Insert_Fuel_Rec;
             Iter;
         When INSEOF <> ' ';
             $Msgid = '0100';
             EXSR Err_Message;
             Iter;
         EndSl;

         // Display the Screen once again if any warning present
         Select;
         When WK_COUNT1 = 0 And WARN > 0;
           WK_COUNT1 = 1;
           Iter;

         //Display the Screen once again if any warning present
         When WARN > 0;
           // Clear message line and write any error messages.
           RecExist = 'N';
           //IF any changes occur
           READC FULSFL;
           DOW NOT %EOF(DTSTENTD);
             *IN65 = *ON;                                                       // SFLNXTCHG IS ON
             UPDATE FULSFL;
             RecExist = 'Y';
             WK_COUNT1 = 0;
             LEAVE;
           ENDDO;
           // Go back to validation
           If RecExist = 'Y';
              Iter;
           ENDIF;
         EndSl;
         LeaveSr;
         EndDo;

       EndSr;

       //-----------------------------------------------------------------------
       // Clear_Fuel_ind - Clear fuel purchased panel subroutine
       //-----------------------------------------------------------------------

       BegSr Clear_Fuel_ind;

         // Initially set off the ability to perform F5 or F7 since
         // validation must be performed before we know if these keys
         // will be required.

         *IN32 = *OFF;
         *IN33 = *OFF;
         *IN35 = *OFF;

         // Set Off Subfile Field's Reverse Image Indicators.

         *IN43 = *OFF;
         *IN52 = *OFF;
         *IN56 = *OFF;
         *IN74 = *OFF;
         *IN75 = *OFF;
         *IN76 = *OFF;
         *IN77 = *OFF;
         *IN78 = *OFF;
         *IN79 = *OFF;

         // Set Off Positioning (PC) Indicator.

         *IN53 = *OFF;

       EndSr;
       //-----------------------------------------------------------------------
       // Clr_Fuel_Pur_Panel - Clear fuel purchased panel subroutine
       //-----------------------------------------------------------------------

       BegSr Clr_Fuel_Pur_Panel;

         *IN28 = *OFF;

         *IN(60) = *On;
         *IN(61) = *Off;
         *IN(62) = *Off;
         *IN(63) = *Off;
         *IN(64) = *Off;
         *IN(65) = *Off;
         *IN(66) = *Off;
         *IN(67) = *Off;
         *IN(68) = *Off;
         *IN(69) = *Off;
         WRITE FULCTL;
         *IN(60) = *Off;
         *IN(61) = *Off;
         *IN(62) = *On;
         *IN(63) = *On;
         *IN(64) = *Off;
         *IN(65) = *Off;
         *IN(66) = *Off;
         *IN(67) = *Off;
         *IN(68) = *Off;
         *IN(69) = *Off;
         *IN(70) = *Off;

         CLEAR Fuel_RRN;

       EndSr;

       //-----------------------------------------------------------------------
       // Clr_Fuel_Msg_Ds - Clear fuel message mult  occur DS subroutine
       //-----------------------------------------------------------------------

       BegSr Clr_Fuel_Msg_Ds;

         For Ctr = 1 To 20;
           %Occur(FULMSG) = Ctr;
           CLEAR FULMSG;
         EndFor;

         // Fuel_Err_Cnt = Total number of Fuel screen errors

         CLEAR Fuel_Err_Cnt;

       EndSr;

       //-----------------------------------------------------------------------
       // Fill_Fuel_Pur_Panel - Fill fuel purchased panel subroutine
       //-----------------------------------------------------------------------

       BegSr Fill_Fuel_Pur_Panel;

         CLEAR WK_COUNT1;
         FIRST = 'N';
         If MODE = 'CHANGE ';
           *IN65 = *ON;
         EndIf;

         Exec Sql Open Entr_Fuel_Cursor;
         // LOOP TO LOAD SUBFILE WITH UP TO 9 RECORDS (1 PAGE)
         Dow WK_COUNT1 < 99 and SqlCode = 0;
           Reset FdtsFuel;
           Exec Sql Fetch Entr_Fuel_Cursor
                     Into :TFLINE,:TFSRC,:LinDatMM,:LinDatDD,
                          :LinDatYY,:TFSPUR,:TFTKNO,:TFFKEY,
                          :TFQTM,:TFVEND,:TFVNDN,:TFVNDC,
                          :TFTAXP,:TFORIG,:TFFX,:TF2A01,:TFINV,:TFFSRC;
           If SqlCode <> 0;
              RemCnt = 99 - WK_COUNT1;
              Leave;
           EndIf;
           // IF READ IS SUCCESSFUL, FILL SUBFILE
           FULOPT = *BLANK;
           DSLINE = TFLINE;  //Note line no
           DSSRC = TFSRC;
           HSRC = TFSRC;
           HSINVC = TFINV;
           HSSRCF = TFFSRC;

           if Line_Date > 0;
             Wk_Date10 = %Date(Line_Date:*CYMD);
             DSDPUR = %Dec(Wk_Date10:*MDY);
           else;
             DSDPUR = 0;
           endif;

           DSSPUR = TFSPUR;
           DSTKNO = TFTKNO;

           // GET FUEL STORED IN TFGRIN FIELD TO DISPLAY ON SCREEN
           // THIS FIELD IS EXACTLY WHAT THEY HAD KEYED ON THE SCREEN &
           // COULD BE GALLONS OR LITERS

           DSFPG = TFFKEY;

           // Convert Gallons (from file 5.1) to Liters (on screen 5.0)

           DSQTM = TFQTM;
           DSVEND = TFVEND;
           DSVNDN = TFVNDN;
           DSVNDC = TFVNDC;
           // Load hidden Addtn'l Fuel Reqmnts (AFR) fields.
           DSTAXP = TFTAXP;
           DSORIG = TFORIG;
           DSFX = TFFX;
           DSTKTRCVD = TF2A01;
           Fuel_RRN = Fuel_RRN + 1;
           WK_COUNT1 = WK_COUNT1 + 1;

           // If TFSRC='Y'(indicates record in billing fuel ticket file used)
           // then protect line from changes.  If change is required, user
           // must delete and reenter since the bill fuel file needs to have
           // the 'U'sed indicator removed.

           *IN31 = *OFF;
           If DSSRC = 'Y';
             *IN31 = *ON;
           EndIf;

           WRITE FULSFL;
           *IN(62) = *On;
           *IN(63) = *On;
           // POSITION PANEL AT FIRST RECORD WRITTEN
           If FIRST = 'N';
             FUSRN = Fuel_RRN;
             FIRST = 'Y';
           EndIf;

         EndDo;
         Exec Sql Close Entr_Fuel_Cursor;
         Clear SqlCode;

         // IF EOF REACHED WITH RECORDS WRITTEN, THEN SETON SUBFILE END.
         CLEAR Ctr;
         CLEAR WK_COUNT1;
         If MODE = 'CHANGE '
           And Fuel_RRN < 99;
           Dow WK_COUNT1 < REMCNT;
             Ctr = Ctr + 1;
             If @BRN(Ctr) <> 0;
               CHAIN @BRN(Ctr) BILSFL;
               If %Found();
                 DSTKTRCVD = 'Y';
                 Exsr Load_Fuel_screen;

                 Fuel_RRN = Fuel_RRN + 1;
                 EvalR DSLINE = %Editc(Fuel_RRN:'X');
                 WK_COUNT1 = WK_COUNT1 + 1;

                 // Protect line from changes.

                 *IN31 = *ON;

                 WRITE FULSFL;
                 *IN(62) = *On;
                 *IN(63) = *On;
                 // POSITION PANEL AT FIRST RECORD WRITTEN
                 If FIRST = 'N';
                   FUSRN = Fuel_RRN;
                   FIRST = 'Y';
                 EndIf;
               EndIf;
             EndIf;

             If @BRN(Ctr) = 0
               Or Not %Found();
               WK_COUNT1 = REMCNT;
             EndIf;

           EndDo;
         EndIf;

         SAVFRN = Fuel_RRN;
         *IN68 = *ON;
         //                                                    RCD WRITTEN
         If Fuel_RRN = 0;
           *IN63 = *OFF;
         EndIf;
         //                                                    RCD WRITTEN
       EndSr;

       //-----------------------------------------------------------------------
       // Fill_Fuel_Pur_Panel_Add - Fill fuel purchased panel add subroutine
       //-----------------------------------------------------------------------
       BegSr Fill_Fuel_Pur_Panel_Add;

         CLEAR DSLINE;
         CLEAR WK_COUNT1;
         FIRST = 'N';
         *IN65 = *ON;

         CLEAR SqlCode;

         // Connect To Remote system
         Exec Sql Set Connection :WkRemote;
         Exec Sql Open Entr_Tkt_Cursor;

         Dow SqlCode = 0 and WK_COUNT1 < 99 ;

           Clear FfuelTkt;
           Exec Sql Fetch from Entr_Tkt_Cursor
                          into :FTUDTR,:FTGALN,:FTFUSE,:FTSTST,:FTTKNO,
                               :FTICUS,:FTODIS,:FTVEND,:FTSTNA,:FTSTCT,
                               :FTPDAT,:FTSRC,:FTCORP;
           If SqlCode <> 0;
              Leave;
           EndIf;

           DSTKTRCVD = ' ';
                                         //added the remaining condition in Entr_Tkt_Cursor
           If FTPDAT < Beg_Date7 Or FTPDAT > Wk_EndDat7;
              Iter;
           EndIf;

           Fnd_Flg = 1;
           Fnd_Flg = %Lookup(FTSTST:@STM:Fnd_Flg);

           If Fnd_Flg > 0;
              DSFX = @SMC(Fnd_Flg);
              CLEAR FULOPT;
                // DSSRC = Y indicates fuel from billing
                // HSRC  = X indicates fuel from billing newly selected
              DSSRC = 'Y';
              HSRC = 'X';

              Wk_Date10 = %Date(FTPDAT:*CYMD);
              DSDPUR = %Dec(Wk_Date10:*MDY);

              DSSPUR = FTSTST;
              DSTKNO = FTTKNO;
              DSTKTRCVD = 'Y';
              DSFPG = FTGALN;
              HSFSRC = FTSRC;
              CLEAR DSQTM;

              DSVEND = FTVEND;
              DSVNDN = FTSTNA;
              If FTVEND = *BLANKS And FTSRC <> 'F';
                 Ds_FDIST = FTPDIS;
                 DS_FLoc = FTPLOC;
                 DSVNDN = XXXXXX;
              EndIf;
              DSVNDC = FTSTCT;
              CLEAR DSTAXP;
              CLEAR DSORIG;
              Fuel_RRN = Fuel_RRN + 1;
              WK_COUNT1 = WK_COUNT1 + 1;
              EvalR DSLINE = %Editc(Fuel_RRN:'X');

              // Protect line from changes.

              *IN31 = *ON;

              WRITE FULSFL;
              *IN(62) = *On;
              *IN(63) = *On;
              If FIRST = 'N';
                 FUSRN = Fuel_RRN;
                 FIRST = 'Y';
              EndIf;
              Iter;
           Endif;
             Fnd_Flg = 1;
         EndDo;

         Exec Sql Close Entr_Tkt_Cursor;
         // Connect To Local
         Exec Sql Set Connection :WkMachine;
         Clear SqlCode;

         // LOOP TO LOAD SUBFILE WITH UP TO 10 RECORDS (1 PAGE)
         // WITH A MAXIMUM OF 99 ALLOWED (LINE field in file is only 2).
         CLEAR Ctr;
         Dow WK_COUNT1 < 99;
           Ctr = Ctr + 1;
           If @BRN(Ctr) <> 0;
             CHAIN @BRN(Ctr) BILSFL;
             If %Found();
               Exsr Load_Fuel_screen;
             EndIf;
           EndIf;
           If @BRN(Ctr) = 0
             Or Not %Found();
             Exsr Clear_Fuel_Req_Columns;
             CLEAR HSRC;
             // Remove Protect and allow changes.
             *IN31 = *OFF;
             // Cursor on 1st blank line Date field.
             *IN53 = *ON;
           EndIf;

           Fuel_RRN = Fuel_RRN + 1;
           EvalR DSLINE = %Editc(Fuel_RRN:'X');
           WK_COUNT1 = WK_COUNT1 + 1;
           DSTKTRCVD = 'N';
           If DSTKNO <> *Blanks and
             DSVNDN <> *Blanks;
             DSTKTRCVD = 'Y';
           EndIf;
           WRITE FULSFL;
           *IN(62) = *On;
           *IN(63) = *On;
           // POSITION PANEL AT FIRST RECORD WRITTEN
           If FIRST = 'N';
             FUSRN = Fuel_RRN;
             FIRST = 'Y';
           EndIf;

         EndDo;

         SAVFRN = Fuel_RRN;
         *IN65 = *OFF;
         *IN68 = *ON;
         //                                                    RCD WRITTEN
       EndSr;

       //-----------------------------------------------------------------------
       // Load_Fuel_screen - Initialise Fuel Screen fields
       //-----------------------------------------------------------------------
       BegSr Load_Fuel_screen;

             FULOPT = *BLANK;
               // DSSRC = Y indicates fuel from billing
               // HSRC  = X indicates fuel from billing newly selected
             DSSRC = 'Y';
             HSRC = 'X';
             DSDPUR = DSPDAT;
             DSSPUR = DSSTST;
             DSFPG = DSGALN;
             CLEAR DSQTM;
             DSVEND = DSVEND;
             DSVNDN = DSSTNA;
             DSVNDC = DSSTCT;
             CLEAR DSTAXP;
             CLEAR DSORIG;
             Clear HSINVC;
             Clear HSSRCF;
             Fnd_Flg = 1;
             Fnd_Flg = %Lookup(DSSTST:@STM:Fnd_Flg);
             If Fnd_Flg > 0;
               DSFX = @SMC(Fnd_Flg);
               LeaveSr;
             EndIf;
             Fnd_Flg = 1;
       EndSr;
       //-----------------------------------------------------------------------
       // Clear_Fuel_Req_Columns - Initialise Fuel Requirement fields
       //-----------------------------------------------------------------------
       BegSr Clear_Fuel_Req_Columns;

             CLEAR FULOPT;
             CLEAR DSSRC;
             CLEAR HSRC;
             CLEAR DSDPUR;
             CLEAR DSSPUR;
             CLEAR DSTKNO;
             CLEAR DSFPG;
             CLEAR DSQTM;
             CLEAR DSVEND;
             CLEAR DSVNDN;
             CLEAR DSVNDC;
             // Hidden fields for use with Addtn'l Fuel Reqmnts (AFR)
             CLEAR DSTAXP;
             CLEAR DSORIG;
             CLEAR DSFX;

       EndSr;
       //-----------------------------------------------------------------------
       // Validate_Fuel_Pur - Validate fuel purchased subroutine
       //-----------------------------------------------------------------------
       BegSr Validate_Fuel_Pur;

         // If Fuel Dates are zero, automatically load with previous date.

         If DSSPUR <> *BLANK;

           If DSLINE <> '01' And DSDPUR = 0;
              DSDPUR = PTMDY;
           Endif;

           PTMDY = DSDPUR;
           Wk_MDY = DSDPUR;
           Exsr Validate_MDY;
           If %Error();
             Wk_Fuel_Err = 1;
           Else;
             Wk_Date10 = %Date(DSDPUR:*MDY);
           Endif;
         EndIf;

         *IN35 = *OFF;

         // Validate Fuel ticket recieved or not.

         IF DSTKTRCVD <> 'Y' And DSTKTRCVD <> 'N';
           *IN35 = *ON;
           $Msgid = '0100';
           EXSR Err_Message;
         ENDIF;

           // INSERT
        Select;
        When FULOPT = 'I' and Fuel_RRN = 99;
             // If Insert taken on last record (99), give error that no
             // additional records can be added.
               *IN56 = *ON;
               $Msgid = '0103';
               EXSR Err_Message;

        When FULOPT = 'I';
               If SEL# = 0;
                 INFRN = Fuel_RRN;
               EndIf;
               SEL# = SEL# + 1;

        When FULOPT = 'D';
               If SEL# = 0;
                 DEFRN = Fuel_RRN;
               EndIf;
               SEL# = SEL# + 1;

        When FULOPT <> ' ';
               *IN56 = *ON;
               FUSRN = Fuel_RRN;
               $Msgid = '0100';
               EXSR Err_Message;

           // Do not validate blank lines when in ADD mode.
        When MODE = 'ADD    '
             And FULOPT = *BLANK And DSDPUR = 0 And DSSPUR = *BLANKS
             And DSTKNO = *BLANKS And DSFPG = 0 And DSQTM = *BLANKS
             And DSVEND = *BLANKS And DSVNDN = *BLANKS And DSVNDC = *BLANKS;
             // SKIP VALIDATION
        When FULOPT = ' ';

             // Check for DUPLICATE fuel.
             EvalR DsTkNo = %Trim(DsTkNo);
             Eval DsTkNo = %xlate(' ':'0':DsTkNo);
             Wk_MDY = DSDPUR;
             Exsr Validate_MDY;
             If %Error();
               Wk_Date7 = 0;
             Else;
               Wk_Date10 = %date(DsDPur:*MDY);
               Wk_Date7 =  %DEC(Wk_Date10:*CYMD);
             Endif;

             If MODE <> 'DISPLAY';
               Exec Sql Declare Entr_Fuel_Dis Cursor for
                        Select TfTrip, TfFpg from FuelCsr_A
                        Where TFINVY = :Wk_CYY7 and TFINVM = :DSDPMM
                          and TFINVD = :DSDPDD  and TFSPUR = :DSSPUR
                          and TFTKNO = :DSTKNO
                        Order By TFINVY,TFINVM,TFINVD,TFSPUR,TFTKNO,TFFPG;

               Exec Sql Open Entr_Fuel_Dis;
               Dow SqlCode = 0;
                 Clear TfTrip;
                 Clear TfFpg;
                 Exec Sql Fetch from Entr_Fuel_Dis into :TfTrip, :TfFpg;
                 If SqlCode <> 0 or DSTKNO = '000000000' or
                    DSTKNO = '         ';
                    Leave;
                 EndIf;
                 WkFpg1 = TfFpg - 1;
                 WkFpg2 = TfFpg + 1;
                 // If the same fuel record is out there for another trip, error.
                 If DshTrp <> TfTrip and DsFpg >= WkFpg1 And DsFpg <= WkFpg2;
                   FuSrn = Fuel_RRN;
                   *IN56 = *ON;
                   *IN43 = *ON;
                   *IN52 = *ON;
                   *IN74 = *ON;
                   $Msgid = '0177';
                   Exsr Err_Message;
                 EndIf;
               EndDo;
               Exec Sql Close Entr_Fuel_Dis;
               Clear SqlCode;
             EndIf;

             // If DSSRC = 'Y', still need to update fuel code in case
             // the mileage code was changed to be different than what
             // was on the fuel file record.

             If DSSRC = 'Y';
                Ctr = 1;
                Ctr = %Lookup(DSSPUR:@STM:Ctr);
             EndIf;

             Select;
             When DSSRC = 'Y' and Ctr > 0;
                 DSFX = @SMC(Ctr);

             When DSSRC = 'Y';
                 Ctr = 1;
                 *IN52 = *ON;
                 $Msgid = '0125';
                 EXSR Err_Message;
                 // Load Hidden field on FULSFL with code (DSCODE) from mileage
                 // record that has the state the fuel was purchased from.

             Other;

             // If record autom. pulled from bilsfl, do not validate
             // fields that would cause errors and prevent you from
             // continuing since billing fuel records can never be changed.

               // Validate date.
               Wk_DATE6 = DSDPUR;
               EXSR Validate_Date;

               // State entered cannot be blank.

               If DSSPUR <> *BLANK;
                  Exsr Fetch_State_Num;

                 // State must be found on mileage screen.
                  Ctr = 1;
                  Ctr = %Lookup(DSSPUR:@STM:Ctr);
               Endif;

               Select;
               When DSSPUR <> *BLANK and SqlCode <> 0;        //Fetch State Number
                 Clear WkStno;
                 *IN52 = *ON;
                 $Msgid = '0120';
                 EXSR Err_Message;
                 Clear SqlCode;

               When DSSPUR <> *BLANK and Ctr > 0;
                 WKSTNO = Wk_STNUM;
                 DSFX = @SMC(Ctr);

               When DSSPUR <> *BLANK;
                 WKSTNO = Wk_STNUM;
                 Ctr = 1;
                 *IN52 = *ON;
                 $Msgid = '0125';
                 EXSR Err_Message;
                    // Load Hidden field on FULSFL with code (DSCODE) from mileage
                    // record that has the state the fuel was purchased from.

               Other;
                 FUSRN = Fuel_RRN;
                 *IN52 = *ON;
                 $Msgid = '0120';
                 EXSR Err_Message;
               EndSl;

               // Fuel Ticket no. cannot be blank.

               If DSTKNO = *BLANKS;
                 *IN74 = *ON;
                 $Msgid = '0171';
                 EXSR Err_Message;
               EndIf;

               IF DSFPG < 0;
                 *IN75 = *ON;
                 $Msgid = '0917';
                 EXSR Err_Message;
               ENDIF;

               // Gallons cannot be zero.

               Select;
               When DSFPG = 0;
                 *IN75 = *ON;
                 $Msgid = '0172';
                 EXSR Err_Message;

                 // Gallons cannot be greater than the tank capacity of
                 //  the vehicle. If vehicle file shows zero as the tank
                 //  capacity then 350 gal. used.
               When *IN57 = *Off
                  And DSQTM = ' '
                   Or DSQTM = 'G';
                   TOTCAP = DSTANK * DSNTNK;
                   If DSFPG > TOTCAP;
                     *IN75 = *ON;
                     $Msgid = '0173';
                     EXSR Err_Message;
                   EndIf;

                   // Liters cannot be greater than the tank capacity of
                   //  the vehicle. If vehicle file shows zero as the tank
                   //  capacity then use 350 gal.
                   // 1 U.S. Gallon = 3.785 Liters

               When *IN57 = *On
                  And DSQTM = ' '
                   Or DSQTM = 'L';
                     TOTCAP = DSTANK * DSNTNK;
                     Eval(H) WKTLTR = TOTCAP * 3.785;
                     If DSFPG > WKTLTR;
                       *IN75 = *ON;
                       $Msgid = '0173';
                       EXSR Err_Message;
                     ENDIF;
               EndSl;

               // Validate fuel code.
               // Valid values are blank
               //        G=Gallons, and L=Liters

               If DSQTM <> ' '
                 And DSQTM <> 'G'
                 And DSQTM <> 'L';
                 *IN76 = *ON;
                 $Msgid = '0174';
                 EXSR Err_Message;
               EndIf;

               // Validate if METRIC  unit and state of purchase - G should be
               // if American unit, province purchase - L should be entered

               Exsr Fetch_State_Num;
               Clear SqlCode;

               // Validate QTM as per Corp
               Select;
               When DSCORP = 'HPTL';
                 //  If the Corp = HPTL , below conditions should not exist
                 //  This is not allowed
                 Select;
                 When DSQTM = 'L';
                   *IN76 = *ON;
                   $Msgid = '0902';
                   EXSR Err_Message;

                 // WARNING MESSAGE :US State:  Are you entering Liter
                 //  value to be converted to Gallons?"
                 When Wk_STNUM <= 51
                   And DSQTM = 'G';
                   *IN76 = *OFF;
                   $Msgid = '0903';
                   EXSR Err_Message;

                 // WARNING MESSAGE :Canadian State: Fuel would be accepted
                 //  as it is in Gallons
                 When Wk_STNUM > 51
                   And DSQTM = ' ';
                   *IN76 = *OFF;
                   $Msgid = '0904';
                   EXSR Err_Message;

                 Other;
                   *IN76 = *OFF;
                 ENDSl;

               //  If the Corp = 2000 , below conditions should not exist
               When DSCORP = '2000';
                 //  This is not allowed
                 Select;
                 When DSQTM = 'G';
                   *IN76 = *ON;
                   $Msgid = '0902';
                   EXSR Err_Message;

                 //  WARNING MESSAGE :Canadian State:  Are you entering Gallon
                 //   value to be converted to Liter
                 When Wk_STNUM > 51
                   And DSQTM = 'L';
                   $Msgid = '0905';
                   EXSR Err_Message;

                 //  WARNING MESSAGE :US State: Fuel would be accepted
                 //   as it is in Liters
                 When Wk_STNUM <= 51
                   And DSQTM = ' ';
                   $Msgid = '0906';
                   EXSR Err_Message;
                 EndSl;

               ENDSl;

               // Validate Vendor number, name, and city.
               //   All 3 cannot be blank.  If vendor number is NOT keyed,
               //   then both vendor name and vendor city are required.
               Select;
               When DSVEND = *BLANKS
                 And DSVNDN = *BLANKS
                 And DSVNDC = *BLANKS;
                 *IN77 = *ON;
                 *IN78 = *ON;
                 $Msgid = '0175';
                 EXSR Err_Message;

               When DSVEND = *BLANKS;
                 If DSVNDN = *BLANKS
                   Or DSVNDC = *BLANKS;
                   *IN78 = *ON;
                   $Msgid = '0179';
                   EXSR Err_Message;
                 EndIf;

               Other;

                 Exec Sql Select MCFVNA, MCFVCT
                          into :DSVNDN,:DSVNDC
                          From FDTSVEND
                          Where MCFVST = :WKSTNO and MCFVNO = :DSVEND
                                and MCDEL <> 'Y'
                          Fetch first row only;

                 If SqlCode <> 0;
                   *IN77 = *ON;
                   $Msgid = '0176';
                   EXSR Err_Message;
                   Clear SqlCode;
                 EndIf;
               EndSl;

               // If new entry, then check if fuel ticket found, if not prompt
               // user to input Y/N as to whether or not the ticket was included
               // with the DTR.  Otherwise, if found on the fuel ticket file, we
               // automatically load the file with 'Y' since we are always able
               // to obtain the fuel tickets.

               If DSSRC = ' ';

                 Wk_MDY = DSDPUR;
                 Exsr Validate_MDY;
                 If %Error();
                   Wk_Date7 = 0;
                 Else;
                   Wk_Date10 = %Date(DsDPur:*MDY);
                   Wk_Date7 = %Dec(Wk_Date10:*CYMD);
                 Endif;

                 // Connect To Remote system
                 Exec Sql Set Connection :WkRemote;

                 Exec Sql Select (1) into :Data_Fnd from FFUELTKTV4
                          Where FTIUNI = :DSUNIT and FTCORP = :DSCORP
                            and FTPDAT between :Wk_BegDat7 and :Wk_EndDat7
                            and FTVEND = :DSVEND
                            and FTUDTR <> 'U' and FTFUSE <> 'R'
                            and FTGALN = :DSFPG
                            Fetch first row only;
                 // If matching fuel ticket found, update FULSFL HIDDEN with 'X'.
                 // This indicates that the file will be marked with a 'Y' once the
                 // $WRITE subroutine is executed and the fuel ticket file updated
                 // with a 'U'.  We do not want to update the fuel ticket file with
                 // a 'U' here in case the user Exits (F1) without wanting to complete
                 // In the $WRITE SR we only check the fuel ticket file for those
                 // records with an 'X' in the HSRC field of the FULSFL.
                 // Check the Customer number of billing fuel record and the
                 // DTR customer number if the customer number is same then add
                 // the record otherwise show the error message.
                 If SqlCode = 0;
                    DSSRC = 'Y';
                    HSRC = 'X';
                 EndIf;
                 Clear SqlCode;

                 // Connect To Local
                 Exec Sql Set Connection :WkMachine;
               EndIf;

             EndSl;

         EndSl;

         If DSSRC = 'Y';

           Wk_MDY = DSDPUR;
           Exsr Validate_MDY;
           If %Error();
             WK_Date7P = 0;
           Else;
             Wk_Date10 = %Date(DSDPUR:*MDY);
             WK_Date7P = %Dec(Wk_Date10:*CYMD);
           Endif;

           // Connect To Remote system
           Exec Sql Set Connection :WkRemote;

           Exec Sql
            Select(1) Into :Data_Fnd From FFUELTKT
                         Where FTCORP = :DSCorp And
                               FTTKNO = :DSTkno And
                               FTSTST = :DSSPUR And
                               FTPDAT = :WK_Date7P And
                               FTICUS = :DSACCN And
                               FTIUNI = :DSUNIT
                         Fetch first row only;

           If Sqlcode <> 0;
             *IN35 = *ON;
             $Msgid = '0478';
             EXSR Err_Message;
             Clear SqlCode;
           ENDIF;

           // Connect To Local
           Exec Sql Set Connection :WkMachine;
         ENDIF;

       EndSr;
       //-----------------------------------------------------------------------
       // Fetch_State_Num - Get the State Number details
       //-----------------------------------------------------------------------
       BegSr Fetch_State_Num;

            Reset Wk_StNum;
            Exec Sql Select SstNum Into :Wk_StNum from FdtSst
                     Where SstCd = :DssPur
                     Fetch first row only;
       EndSr;
       //-----------------------------------------------------------------------
       // Qty_Mer_Field - Underline QTY measure field subroutine
       //-----------------------------------------------------------------------
       BegSr Qty_Mer_Field;

         *IN28 = *ON;
         *IN65 = *ON;

         For Ctr = 1 To SAVFRN;
           CHAIN Ctr FULSFL;

           // If from bill fuel tkt file, protect line from changes.

           *IN31 = *OFF;
           If DSSRC = 'Y';
             *IN31 = *ON;
           EndIf;
           UPDATE FULSFL;
         EndFor;

       EndSr;
       //-----------------------------------------------------------------------
       // Insert_Fuel_Rec - Insert blank fuel record subroutine
       //-----------------------------------------------------------------------
       BegSr Insert_Fuel_Rec;

         Exsr Clear_Multi_Occ_Ds;
         For Ctr = 1 To SAVFRN;
           CHAIN Ctr FULSFL;
           If %Found();
             %Occur(D2FUEL) = Ctr;
             DSFMDY = DSDPUR;
             DSFPGX = DSFPG0;
             DSINVC = HSINVC;
             DSSRCF = HSSRCF;
             DSFLIN = DSLINE;
             D2Fuel = Fuel;
           EndIf;
         EndFor;

         // If the maximum number of records allowed to be written has
         // has already been written, and the last one has DTR data
         // (not a blank line in ADD mode), then send error that no
         // additional lines can be inserted.
         // NOTE: A maximum of 99 is implemented since the line field
         //       is limited to 2 characters on the file and the need
         //       for more than 99 will never occur.  (I know, famous
         //       last words!!!)

         If SAVFRN = 99
           And DSDPUR <> 0;
           *IN56 = *ON;
           $Msgid = '0103';
           EXSR Err_Message;
           LeaveSr;
         EndIf;

           SAV28 = *IN28;
           ExSr Clr_Fuel_Pur_Panel;
           *IN28 = SAV28;
           *IN65 = *ON;
           CLEAR Ctr;
           CLEAR MRRN;

           Select;
           When INSEOF = 'I';
             DORRN = 1;
             FUSRN = 1;
             %Occur(D2FUEL) = 1;
             CLEAR D2FUEL;
             INSEOF = ' ';

             // If 99 lines written and 99th is blank(already determined above)
             // then subtract one from the total number of times the DO loop
             // is executed below, so that the inserted blank line will not
             // cause an array index error when writing the extra record.

           When SAVFRN = 99;
               DORRN = 98;
           Other;
               DORRN = SAVFRN;
           EndSl;

           CLEAR SAVFRN;
           For Ctr = 1 To DORRN;
             %Occur(D2FUEL) = Ctr;
             MRRN = MRRN + 1;
             If DORRN = 1
               And D2FUEL = *BLANKS;
               CLEAR D2DPUR;
               CLEAR D2FPG;
             ENDIF;
             Fuel = D2Fuel;
             If DSTKTRCVD = *Blanks;
               DSTKTRCVD = 'N';
             EndIf;
             CLEAR FULOPT;
             DSDPUR = D2DPUR;
             DSFPG0 = D2FPG;
             HSINVC = D2INVC;
             HSSRCF = D2SRCF;
             Fuel_RRN = MRRN;
             EvalR DSLINE = %Editc(MRRN:'X');
             SAVFRN = SAVFRN + 1;
             // If from bill fuel tkt file, protect line from changes.
             *IN31 = *OFF;
             If DSSRC = 'Y';
               *IN31 = *ON;
             EndIf;
             WRITE FULSFL;
             If D2FOPT = 'I';

               Clear HSINVC;
               Clear HSSRCF;
               Exsr Clear_Fuel_Req_Columns;
               DSTKTRCVD = 'N';
               MRRN = MRRN + 1;
               Fuel_RRN = MRRN;
               EvalR DSLINE = %Editc(MRRN:'X');
               SAVFRN = SAVFRN + 1;
               FUSRN = Fuel_RRN;
               // Allow changes
               *IN31 = *OFF;
               WRITE FULSFL;
             EndIf;
           EndFor;

           *IN68 = *ON;

       EndSr;

       //-----------------------------------------------------------------------
       // Delete_Fuel_Rec - Delete fuel record subroutine
       //-----------------------------------------------------------------------

       BegSr Delete_Fuel_Rec;

         FUSRN = 1;
         EXSR Clear_Multi_Occ_Ds;
         For Ctr = 1 To SAVFRN;
           CHAIN Ctr FULSFL;
           If %Found();
             %Occur(D2FUEL) = Ctr;
             DSFMDY = DSDPUR;
             DSFPGX = DSFPG0;
             DSINVC = HSINVC;
             DSSRCF = HSSRCF;
             D2Fuel = Fuel;
           EndIf;
         EndFor;

         EXSR Clr_Fuel_Pur_Panel;
         *IN65 = *ON;
         CLEAR Ctr;
         CLEAR MRRN;
         DORRN = SAVFRN;
         CLEAR SAVFRN;
         For Ctr = 1 To DORRN;
           %Occur(D2FUEL) = Ctr;
           If D2FOPT <> 'D';
             MRRN = MRRN + 1;
             Fuel   = D2FUEL;
             HSINVC = D2INVC;
             HSSRCF = D2SRCF;
             DSDPUR = D2DPUR;
             DSFPG0 = D2FPG;
             Fuel_RRN = MRRN;
             EvalR DSLINE = %Editc(MRRN:'X');
             SAVFRN = SAVFRN + 1;
             // If from bill fuel tkt file, protect line from changes.

         *IN31 = *OFF;
             If DSSRC = 'Y';
               *IN31 = *ON;
             EndIf;
             WRITE FULSFL;
           EndIf;
         EndFor;

         If Fuel_RRN = 0;
           *IN63 = *OFF;
         EndIf;

         *IN68 = *ON;

       EndSr;

       //-----------------------------------------------------------------------
       // Clear_Multi_Occ_Ds - Clear multiple occur data structure
       //-----------------------------------------------------------------------
       BegSr Clear_Multi_Occ_Ds;

         For Ctr = 1 To SAVFRN;
           %Occur(D2FUEL) = Ctr;
           CLEAR D2FUEL;
         EndFor;

         D2TKTRCVD = ' ';
         *IN35 = *OFF;

       EndSr;
       //-----------------------------------------------------------------------
       // Proc_Add_Fuel_Req - Process additional fuel requirements
       //-----------------------------------------------------------------------

       BegSr Proc_Add_Fuel_Req;
         PANEL = 'AFR ';

         *IN(32) = *Off;
         *IN(33) = *Off;

         Exsr Clear_Add_Fuel_Req;

         CHAIN 1 FULSFL;

         Exsr Fill_Add_Fuel_Mil_req;

         Loop4 = *ON;
         DoW Loop4 = *ON;

         WRITE MSGCLR;
         WRITE MSGCTL;

         // If not EOF on 1st READ, continue with normal processing

         If AFuel_Req_Fnd = 'Y';

           // AFTER subfile records have been written, determine if any
           // additional fuel purchase requirements are needed.  If they are,
           // then determine which ones were found and turn on control record
           // heading.

           *In36 = (Tax_Fnd = 'Y');
           *In37 = (Org_Tickt_Fnd = 'Y');
           *In38 = (Grn_Tickt_Fnd = 'Y');

           WRITE TITLE;
           WRITE CUST;
           WRITE AFRFUN;

           *In64 = *On;

           WRITE AFRCTL;
           READ DTSTENTD;
           *InLR = %Eof;

           *IN70 = *OFF;
           *IN(32) = *Off;
           *IN(33) = *Off;
           *IN(65) = *Off;
           *IN(66) = *Off;
           *IN(71) = *Off;
           *IN(72) = *Off;
           *IN(73) = *Off;

           // Process Function Keys

           // F1=Exit

           Select;
           When *INKA = *ON;
             SPVEXIT ( CONFRM );
             If ConFrm = 'Y';
                LeaveSr;
             EndIf;
             Iter;

           When *InKb = *On;
             LeaveSr;

           // F4=Window
           When *INKD = *ON;
             EXSR Inquiry_Window;
             Iter;

           When *IN90 = *ON;
             EXSR Process_Help;
             Iter;

           EndSl;

           // Reset Error Accumulators.
           Exsr Reset_Err_Acc;

           Exsr Clear_Afr_Msg;

           Ad_Fuel_RRN = 1;

           READC AFRSFL;

           // LOOP TO READ SUBFILE
           Dow Not %Eof();
             *IN(71) = *Off;
             *IN(72) = *Off;
             *IN(73) = *Off;

             EXSR Validate_add_fuel_req;

             UPDATE AFRSFL;

             READC AFRSFL;
           EndDo;

           // IF ERRORS, REDISPLAY PANEL
           If OVER > 0
             Or SUSP > 0
             Or FATAL > 0;
             // If no FATAL severity errors, then
             // allow F7 if SUSPEND errors and F5 if only OVERRIDE errors.

             Exsr SUSP_OVER_Err;

             Select;
             When *INKE = *OFF
               And *INKG = *OFF;
               Iter;

             When *INKG = *ON
                 And *IN07 = *ON;

                 // MOVE SUSPENDED DTR TO SUSPENDED BOX
                 Exsr DTS_Sus_Rej;
             EndSl;
           EndIf;

         EndIf;
         Loop4 = *OFF;
         Enddo;
       EndSr;

       //-----------------------------------------------------------------------
       // Clear_Add_Fuel_Req - Clear additional fuel requirement panel
       //-----------------------------------------------------------------------
       BegSr Clear_Add_Fuel_Req;

         *IN(60) = *On;
         *IN(61) = *Off;
         *IN(62) = *Off;
         *IN(63) = *Off;
         *IN(64) = *Off;
         *IN(65) = *Off;
         *IN(66) = *Off;
         *IN(67) = *Off;
         *IN(68) = *Off;
         *IN(69) = *Off;
         WRITE AFRCTL;
         *IN(60) = *Off;
         *IN(61) = *Off;
         *IN(62) = *On;
         *IN(63) = *On;
         *IN(64) = *Off;
         *IN(65) = *Off;
         *IN(66) = *Off;
         *IN(67) = *Off;
         *IN(68) = *Off;
         *IN(69) = *Off;
         *IN(70) = *Off;

         CLEAR Ad_Fuel_RRN;
       EndSr;
       //-----------------------------------------------------------------------
       // Clear_Afr_Msg - CLEAR AFR MESSAGE MULT. OCCUR DS SUBROUTINE      *
       //-----------------------------------------------------------------------
       BegSr Clear_Afr_Msg;
         For Ctr = 1 To 20;
           %Occur(AFRMSG) = Ctr;
           CLEAR AFRMSG;
         EndFor;

         // AFuel_Err_Cnt = Total number of AFR screen errors
         CLEAR AFuel_Err_Cnt;
       EndSr;
       //-----------------------------------------------------------------------
       // Fill_Add_Fuel_Mil_req - Fill additional fuel mileage req panel
       //-----------------------------------------------------------------------
       BegSr Fill_Add_Fuel_Mil_req;

         AFuel_Req_Fnd = NO;
         Tax_Fnd = NO;
         Org_Tickt_Fnd = NO;
         Grn_Tickt_Fnd = NO;
         FIRST = 'N';

         // LOOP TO LOAD SUBFILE WITH ALL RECORDS FROM FUEL PURCHASED PANEL
         Dow True;
           // IF CHAIN IS SUCCESSFUL, FILL SUBFILE
           If %Found();

             getdtssrq(DSSPUR: DSCUST: DSCDST: Today_7:
             srqFound: DTSSRQds);

             *IN(36) = *Off;
             *IN(37) = *Off;
             *IN(38) = *Off;
             If SrqFound = *On;
               If MODE <> 'DISPLAY';
                 *IN65 = *ON;
               EndIf;
               // Tax Paid required?
               If RQTAXP = 'Y';
                 AFuel_Req_Fnd = 'Y';
                 Tax_Fnd = 'Y';
                 *IN36 = *ON;
               EndIf;
               // Original Ticket required?
               If RQORIG = 'Y';
                 AFuel_Req_Fnd = 'Y';
                 Org_Tickt_Fnd = 'Y';
                 *IN37 = *ON;
               EndIf;
               // Green Ticket required?
               If RQGRNT = 'Y';
                 AFuel_Req_Fnd = 'Y';
                 Grn_Tickt_Fnd = 'Y';
                 *IN38 = *ON;
               EndIf;
             EndIf;

             Ad_Fuel_RRN = Ad_Fuel_RRN + 1;
             WRITE AFRSFL;
             *IN(62) = *On;
             *IN(63) = *On;
           EndIf;
           // POSITION PANEL AT FIRST RECORD WRITTEN
           If FIRST = 'N';
             AFSRN = Ad_Fuel_RRN;
             FIRST = 'Y';
           EndIf;

           MRRN = Ad_Fuel_RRN + 1;
           CHAIN MRRN FULSFL;
           If Not %found();
              Leave;
           EndIf;

           // If fuel subfile record is blank, then exit loop

           If DSDPUR = 0;
             Leave;
           EndIf;

         EndDo;

         *IN68 = *ON;

       EndSr;
       //----------------------------------------------------------------------
       // Validate_add_fuel_req - Validate addional fuel req panel
       //----------------------------------------------------------------------
       BegSr Validate_add_fuel_req;

         *IN(36) = *Off;
         *IN(37) = *Off;
         *IN(38) = *Off;

         getdtssrq(DSSPUR: DSCUST: DSCDST: Today_7:
         srqFound: DTSSRQds);

         If SrqFound = *On;

           // Validate Tax Paid if active.
           // Must be an 'Y' or 'N'. A blank is INVALID!

           If RQTAXP = 'Y';
             *IN36 = *ON;
             If DSTAXP <> 'Y'
               And DSTAXP <> 'N';
               *IN71 = *ON;
               AFSRN = Ad_Fuel_RRN;
               $Msgid = '0164';
               EXSR Err_Message;
             EndIf;
           EndIf;

           // Validate Original Ticket if active.
           // Must be an 'Y' or 'N'. A blank is INVALID!

           If RQORIG = 'Y';
             *IN37 = *ON;
             If DSORIG <> 'Y'
               And DSORIG <> 'N';
               *IN72 = *ON;
               AFSRN = Ad_Fuel_RRN;
               $Msgid = '0165';
               EXSR Err_Message;
             EndIf;
           EndIf;

           // Validate Green Ticket if active.
           // An entry must be made. A blank is INVALID!

           If RQGRNT = 'Y';
             *IN38 = *ON;
             If DSORIG = *BLANKS;
               *IN73 = *ON;
               AFSRN = Ad_Fuel_RRN;
               $Msgid = '0166';
               EXSR Err_Message;
             EndIf;
           EndIf;

         EndIf;

       EndSr;
       //-----------------------------------------------------------------------
       // Insert_Err_Rec - Write error records to error/history file.
       //-----------------------------------------------------------------------
        BegSr Insert_Err_Rec;
            // Insert the error records to error/history file.
           Exec Sql Insert Into FdtsErr
                           (OvsCrn, OvLine, OvMid,  OvSev, OvBox, OvBrn,
                            OvBch,  OvTrip, OvOdat, OvOtim)
                    Values (:OvsCrn, :OvLine, :OvMid, :OvSev, :OvBox,
                            ' ', :OvBch, :DshTrp, :Today_7, :OvOtim);

           // History file
           Exec Sql Select (1) into :Data_Fnd from FDTSERHST
                    Where EhBox = :OvBox  and EhBch = :OvBch
                      and EhTrip= :DshTrp and Ehscrn= :OvsCrn
                      and EhLine= :OvLine and EhMid = :OvMid
                    Fetch first row only;
           If SqlCode <> 0;
              Exec Sql Insert into FDTSERHST
                              (EhScrn, EhLine, EhMid, EhSev, EhBox, EhBrn,
                               EhBch,  EhTrip, EhOdat,EhOtim,EhUnit,
                               EhInit, EhCust, EhBgRp,EhDist)
                       Values (:OvsCrn, :OvLine, :OvMid, :OvSev, :OvBox,
                               ' ', :OvBch, :DshTrp, :Today_7,
                               :OvOtim, :Dsunit, :Ldinit, :Dscust, :Dscbg,
                               :Dscdst);
              Clear SqlCode;
           EndIf;
        EndSr;

       //-----------------------------------------------------------------------
       // Write_Err_Rec - Write error records to file subroutine
       //-----------------------------------------------------------------------
       BegSr Write_Err_Rec;
         // Override Error file and
         // Write Override/Suspend Prompt errors to error file.
         Clear Susp;
         Clear FdtsErr;
         OvOtim = %Dec(%Time);
         OvBox = DsBox;
         OvBch = DsBcno;
         For WK_COUNT1 = 1 To Prompt_Err_cnt;
           // Clear Error files
           %Occur(PrmMsg) = WK_COUNT1;
           OvScrn = 'PRMT';
           OvLine = PrmLin;
           OvMid = PrmMid;
           OvSev = PrmSev;

           // Write Override/Suspend Mileage errors to error file.
           ExSr Write_OvrSus_Err;
         EndFor;

         // Write Override/Suspend Customer errors to error file.
         For WK_COUNT1 = 1 To Cust_Err_Cnt;
           %Occur(CUSMSG) = WK_COUNT1;
           If CusMid <> ' ';
              OvScrn = 'CUST';
              OvLine = CusLin;
              OvMid  = CusMid;
              OvSev  = CusSev;
              ExSr Insert_Err_Rec;
              If OvSev = 20;
                 Susp = 1;
              EndIf;
           EndIf;
         EndFor;

         // Write Override/Suspend Mileage errors to error file.
         For WK_COUNT1 = 1 To Mile_Err_Cnt;
           %Occur(MilMsg) = WK_COUNT1;
           OvsCrn = 'MILE';
           OvLine = MilLin;
           OvMid = MilMid;
           OvSev = MilSev;

           // Write Override/Suspend Mileage errors to error file.
           ExSr Write_OvrSus_Err;
         EndFor;

         // Write Override/Suspend ASR errors to error file.
         For WK_COUNT1 = 1 To AState_Err_Cnt;
           %Occur(AsrMsg) = WK_COUNT1;
           OvsCrn = 'ASR ';
           OvLine = AsrLin;
           OvMid = AsrMid;
           OvSev = AsrSev;

           // Write Override/Suspend Mileage errors to error file.
           ExSr Write_OvrSus_Err;
         EndFor;

         // Write Override/Suspend Fuel errors to error file.
         For WK_COUNT1 = 1 To Fuel_Err_Cnt;
           %Occur(FULMSG) = WK_COUNT1;
           OvScrn = 'FUEL';
           OvLine = FulLin;
           OvMid = FulMid;
           OvSev = FUlSev;

           // Write Override/Suspend Mileage errors to error file.
           ExSr Write_OvrSus_Err;
         EndFor;
         // Write Override/Suspend AFR errors to error file.
         For WK_COUNT1 = 1 To AFuel_Err_Cnt;
           %Occur(AFRMSG) = WK_COUNT1;
           OvScrn = 'AFR ';
           OvLine = AfRlin;
           OvMid = AfRmid;
           OvSev = AfrSev;

           // Write Override/Suspend Mileage errors to error file.
           ExSr Write_OvrSus_Err;
         EndFor;

         // Override Error file

         OVBCH = TMPBCH;

         Exsr Clear_DS;
         EXSR Clear_Cust_Msg;
         EXSR Clear_Mil_Msg;
         EXSR Clear_Asr_Mult_Ds;
         EXSR Clr_Fuel_Msg_Ds;

         // Do not allow DTR with blank customer to be valid
         IF DSCUST  = *blanks;
           SUSP += 1;
         EndIf;

       EndSr;
       //-----------------------------------------------------------------------
       // Write_OvrSus_Err - Write Override/Suspend Mileage errors to Error file
       //-----------------------------------------------------------------------
       BegSr Write_OvrSus_Err;

          If OvSev = 20;
            If *In07 = *Off or SusRej <> 'R';
              OvBox = TmpBox;
              OvBch = TmpBch;
            EndIf;
            Susp = 1;
          EndIf;
          ExSr Insert_Err_Rec;

       EndSr;
       //-----------------------------------------------------------------------
       // Write_Dts_File - Write records to DTS files
       //-----------------------------------------------------------------------
       BegSr Write_Dts_File;

         If *In06 = *On and Mode = 'ADD    ';
            DTSTCTNR ( DsHtrp : DsBox : DsBcno );
         EndIf;

         // Write override/suspend errors to error file.
         Exsr Write_Err_Rec;

         // - - - - - - Header
         ExSr Load_HDr;
         ExSr Wrt_HDR;

           // - - - - - - Mileage
         Reset Wk_EndDat7;
         Reset Ctr;
         Reset HKYU;

         Dow True;
           Ctr = Ctr + 1;
           ExSr Load_Mile;

           If Sfl_End = 'Y';   //  Eof
             Leave;
           EndIf;

           // Insert the records to FdtsMile file
           Exsr Insert_Mile_File;

         EndDo;

         Select;
         When SUSP > 0 or TMERR <> ' ';
              OPDis = 0;
         When TMMOM = 'U';
              OPDis = Tot_Miles * 1.609;
         Other;
              OPDis = Tot_Miles / 1.609;
         Endsl;

         If WTAXL_Flg = '0';
           Wk_DSRCWT = 0;
           Wk_DSAXLE = 0;
         Endif;

         Exec Sql Update HdrCsr_A
                     set TMBSPD=:HBSPD, TMTPML=:Tot_Miles, TMODIS = :OPDis,
                         TMRCWT=:Wk_DSRCWT, TMAXLS = :Wk_DSAXLE
                   Where TMHTRP = :DSHTRP;

         // - - - - - - - Fuel
         Reset Ctr;

         Dow True;
           Ctr = Ctr + 1;
           ExSr Load_Fuel;
            // Unit,Date
           If Hsrc = 'X';
             ExSr Mov_Hidden_col;
             ExSr Update_FFUELTKT;
           EndIf;

           If Sfl_End = 'Y';   //  Eof
             Leave;
           EndIf;

           // Insert the records to FdtsFuel file
           If SUSREJ <> 'R' or (DSSRC <> 'Y' and DSTKNO <> '000000000');
             Exsr Insert_Fuel_File;
           Endif;
         EndDo;

         // - - - - - - - Update Header file
         ExSr Upd_Dts_Hdr;

         // SEC.IND. 6 IF ON THEN CONFIRM TRIP NUMBER

         //Modify the VEHMTRT file
         ExSr Mod_VEHMT;

         // Update counters in batch logging file.
         Select;
         When Susp = 0;
             BTVDTR = BTVDTR + 1;
             BTKDTR = BTKDTR + 1;
             BTMDTR = BTMDTR - 1;
         When SusRej = 'R' And *IN07 = *On ;
             BTDDTR = BTDDTR + 1;
             BTKDTR = BTKDTR + 1;
             BTMDTR = BTMDTR - 1;
         Other;
             BTMDTR = BTMDTR - 1;
             BTSDTR = BTSDTR + 1;
             BTKDTR = BTKDTR + 1;
         EndSl;

         DSTCNT = BTVDTR + BTSDTR;
         DSLNTR = BTMDTR;

         // IF BATCH LOG ALREADY SENT -
         // SET COMMUNICATION FIELDS TO UPDATE TO CORP.

         If BTDCOM <> *ZEROS
           Or BTDCOM = 0
           And BTCCOM <> 'ADD';
           BTDCOM = *ZEROS;
           BTCCOM = ' ';
         EndIf;

         // Recheck if Batch is now full after adding a record.
         // This is done to determine if Prompt screen will be redisplayed
         // in ADD mode again.  If FULL, it will be changed to display mode.

         //Verify the Max# of Trips Entered
         Exsr Verify_Trip_cnt;

         // If first record, write start date.
         #Time = %Dec(%Time());

         If BTDSTR = 0;
           BTDSTR = Today_7;
           BTTSTR = #TIME;
           BTCLKK = LDINIT;
         EndIf;

         // UPDATE DATE/TIME FINISHED
         BTDFIN = Today_7;
         BTTFIN = #TIME;

       //Populate FDTSBAT columns before updation
         Exsr Populate_Batch_Cols;

         BTLCIN = LDINIT;
         BTLCDT = Today_7;
         BTLCTM = #TIME;

         Exec Sql Update FDTSBAT
                  set BTVDTR=:BTVDTR, BTKDTR=:BTKDTR, BTMDTR=:BTMDTR,
                      BTDDTR=:BTDDTR, BTSDTR=:BTSDTR, BTDCOM=:BTDCOM,
                      BTCCOM=:BTCCOM, BTDSTR=:BTDSTR, BTTSTR=:BTTSTR,
                      BTCLKK=:BTCLKK, BTDFIN=:BTDFIN, BTTFIN=:BTTFIN,
                      BTSTS =:BTSTS,  BTDCLO=:BTDCLO, BTTCLO=:BTTCLO,
                      BTLCIN=:BTLCIN, BTLCDT=:BTLCDT, BTLCTM=:BTLCTM
                Where BtBox = :DsBox and BtBat = :DsBcno;

         //Assigning the Batch Status Description
         Exsr Batch_Sts_Desc;

         DSBOX = BTBOX;

         EXSR Update_Box_File;

       EndSr;
       //-----------------------------------------------------------------------
       // Insert_Mile_File - Insert Record into FDTSMILE File
       //-----------------------------------------------------------------------
       BegSr Insert_Mile_File;

           Wk_MDY = DSTMDY;
           Exsr Validate_MDY;
           If %Error();
             Line_Date = 0;
           else;
             Wk_Date10 = %Date(DSTMDY:*MDY);
             Line_Date = %Dec(Wk_Date10:*CYMD);
           Endif;

           WKFCtr = %LOOKUP(TMSE:@ST);
           Select;
           When WKFCtr = 0;
             TMRCWT = 0;
             TMAXLE = 0;
           When AState_Req_Fnd = 'N';
             TMRCWT = @STWGT(WKFCtr);
             TMAXLE = @STAXL(WKFCtr);
           Other;
             TMRCWT = DSRCWT;
             TMAXLE = DSAXLE;
           EndSl;

           Exec Sql Insert Into MileCsr_A
                (TMSTRP, TMLINE, TMMAFY, TMMAFM,
                 TMTPMM, TMTPDD, TMTPYY, TMBODM, TMEODM,
                 TMCODE, TMSE, TMTMIS, TMTOLL, TMRTES, TMTTM,
                 TMLE, TMMERR, TMMEX, TM1A01, TMAXLE, TMRCWT,
                 TMNHML, TMFUSE, TMRDTY, TM2A01,
                 TM3A01, TM4N70)
                Values
                (:TMSTRP, :TMLINE, :TMMAFY, :TMMAFM,
                 :LinDatMM,:LinDatDD,:LinDatYY,:TMBODM, :TMEODM,
                 :TMCODE, :TMSE, :TMTMIS, :TMTOLL, :TMRTES, :TMTTM,
                 :TMLE, :TMMERR, :TMMEX, :TM1A01, :TMAXLE, :TMRCWT,
                 :TMNHML, :TMFUSE, :TMRDTY, :TM2A01,
                 :TM3A01, :TM4N70);
           Clear Line_Date;
       EndSr;
       //-----------------------------------------------------------------------
       // Insert_Fuel_File - Insert Record into FDTSFUEL File
       //-----------------------------------------------------------------------
       BegSr Insert_Fuel_File;
           Exec Sql Insert Into FuelCsr_A
                  (TFTRIP, TFLINE, TFAFY, TFAFM,  TFSPUR, TFINV,
                   TFINVM, TFINVD, TFINVY, TFFPG, TFVEND, TFVNDN, TFVNDC,
                   TFFX,   TFORIG, TFTKNO, TFFKEY, TFSRC, TFFSRC, TF2A01,
                   TF4N70)
           Values (:TmHTrp, :TfLine, :TfafY, :TfafM, :TfsPur,
                 :TfInv,  :LinDatMM, :LinDatDD, :LinDatYY, :TFFPG, :TFVEND,
                 :TFVNDN, :TFVNDC,:TFFX, :TFORIG, :TFTKNO, :TffKey, :TFSRC,
                 :TFFSRC, :TF2A01,:TF4N70);
       EndSr;
       //-----------------------------------------------------------------------
       // Update_Box_File - Update box file if all batches are closed
       //-----------------------------------------------------------------------
       BegSr Update_Box_File;
         Exec Sql Update FDTSBOX
                     set BXCBAT = BXCBAT + :@CBAT,BXLCIN = :LDINIT,
                         BXLCDT = :Today_7, BXLCTM = :#TIME,
                         (BXSTS,BXDCLO,BXTCLO,BXCLKC)=
                   (Case When BXMBAT = BXCBAT+:@CBAT Then 'C' Else 'O' End,
                    Case When BXMBAT = BXCBAT+:@CBAT Then :Today_7 Else 0 End,
                    Case When BXMBAT = BXCBAT+:@CBAT Then :#TIME Else 0 End,
                    Case When BXMBAT = BXCBAT+:@CBAT Then :LDINIT Else ' ' End),
                         BXDCOM = 0, BXCCOM = ' '
                   Where BxBox = :Dsbox;
         Clear SqlCode;

       EndSr;

       //-----------------------------------------------------------------------
       // Rmv_Prv_FuelTkt : Remove previous used indicators from any FfuelTkt
       //                   records marked
       //-----------------------------------------------------------------------
        BegSr Rmv_Prv_FuelTkt;

            // If Source Field indicates a 'Y', fuel was either selected from
            // the Fuel ticket file or indicates that a fuel ticket was
            // included with the Driver Trip Report. If fuel is found in the
            // fuel ticket file, the record must be updated by removing the
            // Used (U) indicator in the TF2A01 field so that this record
            // is able to be used again with other trips.

            // Connect To Remote system
            Exec Sql Set Connection :WkRemote;

            Exec Sql Close Entr_Fueltkt_Cursor;

            Exec Sql Open Entr_Fueltkt_Cursor;

            WKFCtr = 1;
            Dou SqlCode <> 0;
              Exec Sql Fetch Entr_Fueltkt_Cursor into :FTTKNO,:FTSRC;
              If SqlCode = 0;
                Fuel_Ds(WKFCtr).Fuel_tkt = FTTKNO;
                Fuel_Ds(WKFCtr).Fuel_src = FTSRC;
                WKFCtr = WKFCtr + 1;
              Endif;
            Enddo;

            Exec Sql Update FfuelTkt a
                        Set FtuDtr = ' ',
                            FtTrpA = ' ',
                            FtTrpD = '0001-01-01-00.00.00.000000'
                      Where FtTrpA = :DSHTRP and FtuDtr in ('C','U');
            Clear SqlCode;

            // Connect To Local
            Exec Sql Set Connection :WkMachine;

            Exec Sql Update FMTTKTF
                        set FTUDTR = ' ', FTTRPA = ' ',
                            FTTRPD = '0001-01-01-00.00.00.000000'
                      Where FTTRPA = :DSHTRP and FtuDtr in ('C','U');

        EndSr;
       //-----------------------------------------------------------------------
       //  Udate_Mile_File : Update changed records to mile file
       //-----------------------------------------------------------------------
        BegSr Update_Mile_File;

          Exec Sql Declare Entr_Mile1_Cursor Cursor for
                   Select TMLINE
                     From MileCsr_A
                     Where TMSTRP = :DshTrp
                  Order by TMLINE;
          Exec Sql Open Entr_Mile1_Cursor;

          RecFnd = 'N';
          If SqlCode = 0;
            RecFnd = 'Y';
          Endif;

          DoW RecFnd = 'Y';
            Clear TFLIN;
            Exec Sql Fetch Entr_Mile1_Cursor
                      into :TFLIN;
            Select;
            When SqlCode = 0;
              Ctr = Ctr + 1;
              ExSr Load_Mile;

              If Sfl_End = 'N';

               WKFCtr = %LOOKUP(TMSE:@ST);
               Select;
               When WKFCtr = 0;
                 TMRCWT = 0;
                 TMAXLE = 0;
               When AState_Req_Fnd = 'Y';
                 TMRCWT = DSRCWT;
                 TMAXLE = DSAXLE;
               When WKFCtr > 0;
                 TMRCWT = @STWGT(WKFCtr);
                 TMAXLE = @STAXL(WKFCtr);
               Other;
                 TMRCWT = 0;
                 TMAXLE = 0;
               EndSl;

              // Update FdtsMile file
                 Exec Sql Update MileCsr_A
                             Set TMLINE = :TMLINE, TmmAfm = :TmmAfm,
                                 TmmAfY = :TmmAfY, TMBODM = :TMBODM,
                                 TMEODM = :TMEODM, TMCODE = :TMCODE,
                                 TMSE   = :TMSE,   TMTMIS = :TMTMIS,
                                 TMTOLL = :TMTOLL, TMRTES = :TMRTES,
                                 TMTTM  = :TMTTM,  TMLE   = :TMLE,
                                 TMMERR = :TMMERR, TM1A01 = :TM1A01,
                                 TMAXLE = :TMAXLE, TMRCWT = :TMRCWT,
                                 TMTPMM = :LinDatMM, TMTPDD = :LinDatDD,
                                 TMTPYY = :LinDatYY
                           Where TMSTRP = :DshTrp and TMLINE = :TFLIN;
                 Iter;
              Endif;
              // Delete the records from FdtsMile file
              Exec Sql Delete From MileCsr_A
                       Where TMSTRP = :DshTrp and TMLINE = :TFLIN;

            When SqlCode <> 0;
              RecFnd = 'N';
              Dow True And Mile_RRN > 0;
                Ctr = Ctr + 1;
                ExSr Load_Mile;
                If Sfl_End = 'Y';
                  Leave;
                EndIf;
                // Insert the records to FdtsMile file
                Exsr Insert_Mile_File;

              EndDo;

            EndSl;
          EndDo;

          Exec Sql Close Entr_Mile1_Cursor;
          Clear SqlCode;
        EndSr;
       //-----------------------------------------------------------------------
       // Update_Fuel_File : Update changed records to fule file
       //-----------------------------------------------------------------------
        BegSr Update_Fuel_File;

          Exec Sql Declare Entr_Fuel1_Cursor Cursor for
                   Select TFLINE
                     From FuelCsr_A
                     Where TFTRIP = :DSHTRP
                     Order by TFAFY,TFAFM,TFLINE;

          Exec Sql Open Entr_Fuel1_Cursor;

          RecFnd = 'N';
          If SqlCode = 0;
            RecFnd = 'Y';
          Endif;

          Rls_Cnt = 0;
          DoW RecFnd = 'Y';
            Clear TFLIN;
            Clear TFINV;
            Exec Sql Fetch Entr_Fuel1_Cursor
                      into :TFLIN;
            Select;
            When SqlCode = 0;
              Ctr = Ctr + 1;
              ExSr Load_Fuel;

              If Sfl_End = 'N';

                 Exsr Mov_Hidden_col;
                 If Rls_Cnt > 0;
                    EvalR TfLine = %Editc((%Dec(TfLine:2:0) - Rls_Cnt):'X');
                 Endif;
                   // Remove previous used indicators from any ffueltkt records marked
                 ExSr Update_FFUELTKT;
                 If Rls_Flg = 'Y';
                   Exsr Rel_Fuel;
                 Endif;

               If Sfl_End = 'N';
                 Exec Sql Update FuelCsr_A
                        Set TfLine = :TfLine, TfAfM = :TfAfM, TfAfY = :TfAfY,
                            TfsPur = :TfsPur, TfFx = :TfFx, TFORIG = :TFORIG,
                            TfQtm  = :TfQtm,  TffPg =:TffPg,  TffKey = :TffKey,
                            TfVend = :TfVend, TfvNdn=:TfvNdn, TfvNdc = :TfvNdc,
                            Tf2A01 = :TF2A01, TfErr = :TfErr, Tf1A01 = :Tf1A01,
                            TfTaxp = :TfTaxp, TftKno= :TftKno,TfSrc  = :TfSrc,
                            TFINVM = :LinDatMM, TFINVD = :LinDatDD,
                            TFINVY = :LinDatYY, TFINV = :TFINV,TFFSRC = :TFFSRC
                        Where TFTRIP = :DSHTRP and TFLINE = :TFLIN;

                 If TFFSRC = 'M' and SusRej <> 'R';
                    Exec Sql Update FMTTKTF
                                set FtuDtr = 'U', FtTrpA = :DSHTRP,
                                    FtTrpD = Current TIMESTAMP
                              Where Char(FTSEQ) = :TFINV;
                 Endif;
                 Iter;
               Endif;
              Endif;
                  Exec Sql Delete From FuelCsr_A
                       Where TFTRIP = :DSHTRP and TFLINE = :TFLIN;

             // Record not found
            When SqlCode = 100;
              RecFnd = 'N';
              Dow True And Fuel_RRN > 0;
                Ctr = Ctr + 1;
                ExSr Load_Fuel;
                If Sfl_End = 'Y';
                  Leave;
                EndIf;

                Exsr Mov_Hidden_col;
                If Rls_Cnt > 0;
                   EvalR TfLine = %Editc((%Dec(TfLine:2:0) - Rls_Cnt):'X');
                Endif;
                ExSr Update_FFUELTKT;
                // Insert the records to FdtsFuel file
                If SUSREJ <> 'R' or DSSRC <> 'Y';
                  Exsr Insert_Fuel_File;
                Endif;

              EndDo;

            EndSl;
          EndDo;
          Exec Sql Close Entr_Fuel1_Cursor;
          Clear SqlCode;
        EndSr;
       //-----------------------------------------------------------------------------
       // Mov_Hidden_col - Move Corp, Ticket Number and Vendor Number to Hidden fields
       //                  to update FFUELTKT File
       //-----------------------------------------------------------------------------
       BegSr Rel_Fuel;

          DoU Rls_Flg = 'N' or Sfl_End <> 'N';

            Ctr = Ctr + 1;
            ExSr Load_Fuel;

            If Sfl_End = 'N';

              Exsr Mov_Hidden_col;
              If Rls_Cnt > 0;
                 EvalR TfLine = %Editc((%Dec(TfLine:2:0) - Rls_Cnt):'X');
              Endif;
               // Remove previous used indicators from any ffueltkt records marked
              ExSr Update_FFUELTKT;

            Endif;

          EndDo;

       Endsr;
       //-----------------------------------------------------------------------------
       // Mov_Hidden_col - Move Corp, Ticket Number and Vendor Number to Hidden fields
       //                  to update FFUELTKT File
       //-----------------------------------------------------------------------------
       BegSr Mov_Hidden_col;

         HsCorp = DsCorp;
         HsTkNo = DsTkNo;
         HsVend = DsVend;

       Endsr;
       //-----------------------------------------------------------------------
       // Update_Dts_File - Update changed records to file
       //-----------------------------------------------------------------------
       BegSr Update_Dts_File;

         // Override Error file
         // See if previous override errors exist.
         // Always remove all previous errors and write new ones (if any)
         Exec Sql Delete from FdtsErr
                   Where OVBOX = :TMPBOX and OVBCH = :TMPBCH
                     and OVTRIP = :DSHTRP;

         // - - - - - Header
         // Previous Error flag on trip being updated
         Exec sql Select Tmerr,Tmerr,TmeDat,TM1N70,TM2N70,TM3N70
                    Into :Tmerr,:Perr,:Tmedat,:TM1N70,:TM2N70,:TM3N70
                    from HdrCsr_A
                   Where TmhTrp = :DshTrp
                   Fetch first row only;

         If SqlCode = 0;
            // Write override/suspend errors to error file.
            ExSr Write_Err_Rec;
            ExSr Load_HDR;

            If Lwieght_Susp = '1';
               Susp += 1;
            Endif;

           // Update Trip with current Error flag IF flag
           //  has changed
            Select;
            When Susp = 0 and PErr <> ' ';
              TMERR = ' ';
            When SusRej = 'R' and *In07 = *On  and PErr <> 'R';
              TMERR = 'R';
              TM3N70 = Today_7;
            When Susp <> 0 and *In07 = *On and PErr <> 'Y' and SusRej <> 'R';
              TMERR = 'Y';
              TM1N70 = Today_7;
              Eval Tm7A08 = %Trim(TmpBox);
              TMBCNO = TMPBCH;
            EndSl;

            TMLCIN = LDINIT;
            TMLCDT = Today_7;
            TMSEQ# = DSSEQ;
            TMRCWT = Wk_DSRCWT;
            TMAXLS = Wk_DSAXLE;

            If WTAXL_Flg = '0';
              TMRCWT = 0;
              TMAXLS = 0;
            Endif;

            TMTPML = DSENDS - TMBSPD;
            If TMTPML < 0;
              TMTPML = 0;
            Endif;

            Select;
            When SUSP > 0 or TMERR <> ' ';
                 TMODIS = 0;
            When TMMOM = 'U';
                 TMODIS = TMTPML * 1.609;
            Other;
                 TMODIS = TMTPML / 1.609;
            Endsl;

            Select;
            When TMERR = 'Y' and (PERR = ' ' or PERR = 'R');
                 TM1N70 = Today_7;
            When TMERR = ' ' and (PERR = 'Y' or PERR = 'R');
                 TM2N70 = Today_7;
            When TMERR = 'R' and (PERR = ' ' or PERR = 'Y');
                 TM3N70 = Today_7;
            Endsl;

            Exec Sql Update HdrCsr_A
                     Set TmaFy  = :TmaFy, TmaFm = :TmaFm, TmbCno = :TmbCno,
                         Tm7A08 = :Tm7A08,TmCust= :TmCust,TmCbg = :TmCbg,
                         TmcDst = :TmcDst,TmObr = :TmObr, TmtKtr = :TmtKtr,
                         TmbDat = :TmbDat, TMDPC = :TMDPC, TMDPS = :TMDPS,
                         TMDSC  = :TmDSC,TMDSS = :TmDSS, TMBSPD = :TMBSPD,
                         TMESPD = :TMESPD, TMTPML = :TMTPML, TMCTRC = :TMCTRC,
                         TMMOM  = :TMMOM, TMODIS = :TMODIS, TMLDF = :TMLDF,
                         TMGD   = :TMGD, TMKADM = :TMKADM, TMLCDT = :TMLCDT,
                         TMLCIN = :TMLCIN, TMEDAT = :Wk_EndDat7, TMERR = :Tmerr,
                         TMUNIT = :TMUNIT, TMCORP = :TMCORP, TMRCWT=:TMRCWT,
                         TMAXLS = :TMAXLS, TM1N70 = :TM1N70, TM2N70 = :TM2N70,
                         TM3N70 = :TM3N70
                   Where TmhTrp = :DshTrp;
         EndIf;

         Exsr Get_RANumber;
         Exsr Val_DatTime;
         Exsr Get_UntClas;

         If TMCUST = ' ';
           $BegOdo = 0;
           $EndOdo = 0;
         Endif;

         Exec Sql Update FDTSCSTSF
                     set TMRCNO = :TMRCNO, TMINVN = :TMINVN,
                         TMUNCL = :TMUNCL, TMVUSE = :VFUSE,
                         TMRANUM = :TMRANUM, TMBGOD = :$BegOdo,
                         TMENOD = :$EndOdo, TMDTOT = :TMDTOT,
                         TMTMOT = :TMTMOT, TMDTIN = :TMDTIN,
                         TMTMIN = :TMTMIN, TMUPBY = :LDNAME,
                         TMUPDT = CURRENT TIMESTAMP
                   Where TMHTRP = :DSHTRP;

         Clear SqlCode;

             // If Source Field indicates a 'Y', fuel was either selected from
             // the Fuel ticket file or indicates that a fuel ticket was
             // included with the Driver Trip Report. If fuel is found in the
             // fuel ticket file, the record must be updated by removing the
             // Used (U) indicator in the TF2A01 field so that this record
             // is able to be used again with other trips.

           // Remove previous used indicators from any ffueltkt records marked
         Exsr Mov_Hidden_col;
         ExSr Rmv_Prv_FuelTkt;

         // - - - - - - - Fuel
         Reset Ctr;
         ExSr Update_Fuel_File;

         // - - - - - Mileage
         Reset Wk_EndDat7;
         Reset Ctr;
         ExSr Update_Mile_File;

         //  Batch/Box update
         Reset FDtsBat;
         Exec Sql Select BTSDTR,BTVDTR,BTDDTR,BTDCOM,BTCCOM,BTODTR,BTKDTR,
                         BTDSTR,BTTSTR,BTCLKK,BTDFIN,BTTFIN,BTSTS ,BTDCLO,
                         BTTCLO
                  Into  :BTSDTR,:BTVDTR,:BTDDTR,:BTDCOM,:BTCCOM,:BTODTR,:BTKDTR,
                        :BTDSTR,:BTTSTR,:BTCLKK,:BTDFIN,:BTTFIN,:BTSTS ,:BTDCLO,
                        :BTTCLO
                  From   Fdtsbat
                  Where  BtBox = :TmpBox and BtBat = :TmpBch
                  Order By BtBox,BtBat
                  Fetch first row only;
         If SqlCode = 0;
            // If Previous Error Status of trip shows errors, and now (after
            // changing) it does not, remove 1 from suspended and add 1 to valid.

             Select;
             When PERR = 'Y' and TMERR = ' ';
               BTSDTR = BTSDTR - 1;
               BTVDTR = BTVDTR + 1;
               TM2N70 = Today_7;

             When PERR = 'R' and TMERR = ' ';
               BTDDTR = BTDDTR - 1;
               BTVDTR = BTVDTR + 1;
               TM2N70 = Today_7;

             // If Previous Error Status of trip shows no errors, and now (after
             // changing) it does, remove 1 from valid and add 1 to suspended.
             // IF ERROR IS SUSP ELSE IF REJECT REMOVE 1 FROM VALID AND ADD REJ
             When PERR = ' ' and TMERR = 'Y';
               BTVDTR = BTVDTR - 1;
               BTSDTR = BTSDTR + 1;
               TM1N70 = Today_7;

             When PERR = ' ' and TMERR = 'R';
               BTVDTR = BTVDTR - 1;
               BTDDTR = BTDDTR + 1;
               TM3N70 = Today_7;

             // IF PREVIOUS WAS REJECTED & NOW IT IS SUSP
             When PERR = 'R' And TMERR = 'Y';
               BTSDTR = BTSDTR + 1;
               BTDDTR = BTDDTR - 1;
               TM1N70 = Today_7;

             // IF PREVIOUS WAS SUSP & NOW IT IS REJECTED
             When PERR = 'Y' And TMERR = 'R';
               BTSDTR = BTSDTR - 1;
               BTDDTR = BTDDTR + 1;
               TM3N70 = Today_7;
             EndSl;

           // IF BATCH LOG ALREADY SENT -
           // SET COMMUNICATION FIELDS TO UPDATE TO CORP.
           If BTDCOM <> *ZEROS Or BTDCOM = 0 And BTCCOM <> 'ADD';
             BTDCOM = *ZEROS;
             BTCCOM = ' ';
           EndIf;

           // Recheck if Batch is now full after adding a record.
           // This is done to determine if Prompt screen will be redisplayed
           // in ADD mode again.  If FULL, it will be changed to display mode.

           //Verify the Max# of Trips Entered
           Exsr Verify_Trip_cnt;

           // If first record, write start date.
           #Time = %Dec(%Time());

           If BTDSTR = 0;
             BTDSTR = Today_7;
             BTTSTR = #Time;
             BTCLKK = LDINIT;
           EndIf;

           // UPDATE DATE/TIME FINISHED
           BTDFIN = Today_7;
           BTTFIN = #Time;
       // UPDATE CLOSED DATE/TIME BASED ON STATUS
       //

         //Populate FDTSBAT columns before updation
           Exsr Populate_Batch_Cols;

           Exec Sql Update FdtsBat Set BTSDTR=:BTSDTR, BTVDTR=:BTVDTR,
                                       BTDDTR=:BTDDTR,
                                       BTDCOM=:BTDCOM, BTCCOM=:BTCCOM,
                                       BTDSTR=:BTDSTR, BTTSTR=:BTTSTR,
                                       BTCLKK=:BTCLKK, BTDFIN=:BTDFIN,
                                       BTTFIN=:BTTFIN, BTSTS =:BTSTS ,
                                       BTDCLO=:BTDCLO, BTTCLO=:BTTCLO,
                                       BTLCIN=:LDINIT, BTLCDT=:Today_7,
                                       BTLCTM=:#Time
                                 Where BtBox = :TmpBox and BtBat = :TmpBch;

           //Assigning the Batch Status Description
           Exsr Batch_Sts_Desc;

           DSBOX = TMPBOX;
           EXSR Update_Box_File;
         EndIf;
         Clear SqlCode;

         Select;
         When PERR = 'R' And TMERR = 'Y';
           PRCFG = 'D';
           ExSr Rejected_Trips;
         When TMERR = 'R';
           PRCFG = 'U';
           ExSr Rejected_Trips;
         EndSl;

         // Modify the VEHMTRT file
         ExSr Mod_VEHMT;
         Clear SqlCode;
       EndSr;
       //----------------------------------------------------------------
       // Rejected_Trips -  Write/Update/Delete Rejected Trips
       //----------------------------------------------------------------
       BegSr Rejected_Trips;

         Select;
         When PrcFg = 'A' Or PrcFg = 'U';
           // Update FDTSREJ file
           Exec Sql Update FDTSREJ
                       Set RJBOX=:TM7A08,RJBAT=:TMBCNO, RJTRIP=:TMHTRP,
                           RJTSEQ=0, RJPYY=:TMPYY, RJPMM=:TMPMM,
                           RJPDD=:TMPDD, RJMESG=' ' , RJMSID=:$MID,
                           RJSUSD=:TM1N70,RJCORD=:TM2N70,RJREJD=:TM3N70,
                           RJLCDT = :Today_7, RJLCIN=:TMLCIN,
                           (RJCYMD,RJCUPD) =
                           (Case When (RJCYMD >= 0 And
                                       RJCUPD <> 'ADD') Then 0 End,
                            Case When (RJCYMD > 0 Or RJCYMD = 0 And
                                       RJCUPD <> 'ADD') Then 'UPD' End)
                    Where  RjBox = :DsBox and RjBat = :DsBcno and
                           RjTrip =:DshTrp;
            If SqlCode = 100;
              Exec Sql Insert Into FDTSREJ
                              (RjBox, RjBat, RjTrip, RjtSeq, RjpYY, RjpMM,
                               RjpDD, RjResn, RjMesg, RjMsid, RjSusd,
                               RjCord, RjRejd, RjLcin, RjLcdt, RjCymd,
                               RjCtim, RjCupd, Rj1n70, Rj2a01, Rj3a08)
                       Values (:TM7A08, :TMBCNO, :TMHTRP, 0, :TMPYY,
                               :TMPMM,  :TMPDD,  0, ' ', :$MID,
                               :TM1N70, :TM2N70, :TM3N70, :TMCLK, :Today_7,
                               0, 0, 'ADD', 0,' ',0);
             EndIf;
         Other;
           Exec Sql Delete from FDTSREJ
                    Where  RjBox = :DsBox and RjBat = :DsBcno and
                           RjTrip = :DshTrp;
         EndSl;
         Clear SqlCode;
       EndSr;

       //-----------------------------------------------------------------------
       // Batch_List  : Batch list of all driver trip reports
       //-----------------------------------------------------------------------
       BegSr Batch_List;

         If DshTrp = *Blanks;

          Exsr Clear_Sf_List;

       // If not at the end of the subfile, continue to fill with records
       // If at the end of subfile, and roll pressed, notify user W/ ERR
          Exsr Load_Sf_Batch_List;

          Loop4 = *ON;
          DoW Loop4 = *ON;

           *IN01 = '1';
           If Bch_Flg1 = 'Y';
             *IN01 = '0';
           Endif;

           WRITE MsgClr;
           WRITE MsgCtl;

           If List_RRN = 0;
             Write LstEof;
           EndIf;
           Write LstFun;

           *In64 = *On;
           Write LstCtl;
           Read DTSTENTD;
           *In67 = %Eof;

           // Reset error indicators
           *In70 = *Off;
           *In(65) = *Off;
           *In(66) = *Off;
           *In83 = *Off;

           // Process Function keys
           Select;
           When *Inka = *On;
             SPVEXIT ( CONFRM );
             Select;
             When CONFRM = 'Y' and *INKA = *OFF;
                EXSR Clear_Prompt;
                LeaveSr;
             When CONFRM = 'Y';
                LeaveSr;
             EndSl;
                Iter;
           // F4=Window
           When *Inkd = *On;
             Exsr Inquiry_Window;
             Iter;
           // F9=Add
           When *Inki = *On and Mode <> 'ADD    ' and Bch_Flg1 = 'Y';
               Exsr Chg_Mode;
               If Mode = 'ADD    ';
                 EXSR Clear_Prompt;
                 LeaveSr;
               Endif;
               Iter;
           When *Inki = *On and *INKA = *OFF and Bch_Flg1 = 'Y';
               EXSR Clear_Prompt;
               LeaveSr;
           When *Inki = *On and Bch_Flg1 = 'Y';
               LeaveSr;

           // F18=TOGGLE(ALL/SUSP TRIPS)
           When *Inks = *On;
             *In18 = not *In18;
             Exsr Clear_Sf_List;
             Exsr Load_Sf_Batch_List;
             Iter;

           // HELP
           When *In90 = *On;
             Exsr Process_Help;
             Iter;
           EndSl;

           //-------------------------------------------------------------------
           // Process selections
           If List_RRN > 0;

             // Clear flag that determines if any records were selected.
             // Save SFLEND indicator and reset after clearing deletion subfile.

             LSEL = ' ';
             SAV68 = *IN68;

             // Clear Delete subfile
             Exsr Clear_Dlt_Sf;
             *In(68) = *Off;
             Clear DEL_RRN;

             READC LSTSFL;
             // LOOP TO READ SUBFILE
             WKFLG = 'N';
             LstFlg = 'N';
             DspFlg = 'Y';
             Dow Not %Eof();
               *IN83 = *OFF;

              Select;
              When LstOpt <> ' ' And LstOpt <> '5';
                 If #PsFsi = '01218';
                   *IN83 = *ON;

                   If WkFlg <> 'Y';
                     LssRn = List_RRN;
                     $Msgid = '0014';
                     Exsr Err_Message;
                     WkFlg = 'Y';
                   EndIf;
                 EndIf;
                 *In65 = *On;
                 LstFlg = 'Y';

              When LstOpt <> ' ';
                 *In65 = *On;
                 LstFlg = 'Y';

              EndSl;

               Update LSTSFL;
               Readc LSTSFL;
             EndDo;

             *In83 = *Off;
             If WKFLG = 'Y';
                Iter;
             EndIf;

             List_RRN = 1;
             Readc LSTSFL;

             // LOOP TO READ SUBFILE
             Dow Not %Eof();
               *IN83 = *OFF;
               Exit_Match_Fl = '0';
               Batch_lst = *On;

               If LstOpt <> ' ';

                 // Indicate that an option was taken so that the batch list screen
                 // will redisplay after processing options.
                 LSEL = 'Y';

                 Select;
                 When LSTOPT = '5' Or
                     (LSTOPT = '2' And *IN02 = *ON And BTSTS <> 'S' And
                     (WPRMO = 0 Or (WPRMO >= Pr_MM And WPRYR >= Pr_CYY) Or
                     (WPRMO < Pr_MM And WPRYR > Pr_CYY)));

                   Select;
                   When LSTOPT = '2' And MODE <> 'CHANGE ';
                     *INKJ = *ON;

                   When LSTOPT = '5' And MODE <> 'DISPLAY';
                     *INKH = *ON;
                   EndSl;

                   EXSR Chg_Mode;

                   DSCORP = WCORP;
                   DSHTRP = WHTRP;
                   DSUNIT = WUNIT;
                   HUNIT = WUNIT;
                   DSBDAT = WBDAT;

                   //  Convert MMDDYY to CYYMMDD.
                   Wk_MDY = DsbDat;
                   Exsr Validate_MDY;
                   If %Error();
                     Wk_Date10 = %Date('0001-01-01');
                     Beg_Date7 = 0;
                   Else;
                     Wk_Date10 = %Date(DsbDat:*mdy);
                     Beg_Date7 = %Dec(Wk_Date10:*cymd);
                   Endif;

                   HBDAT = WBDAT;

                   // Retrieve Header data by Branch(from Batch Log),
                   //      Batch number keyed, and Trip number keyed.

                   Reset Wk_Hdr;
                   Exec Sql Select TMCUST, TMCDST, TMCBG, TMSEQ#, TMDPC,
                                   TMDPS, TMDSC, TMDSS, TMERR, TMPMM, TMPDD,
                                   TMPYY
                              into :TMCUST, :TMCDST, :TMCBG, :DSSEQ, :TMDPC,
                                   :TMDPS, :TMDSC, :TMDSS, :TMERR, :Wk_MM7,
                                   :Wk_DD7, :Wk_CYY7
                              from HdrCsr_A
                             Where TM7A08 = :DSBOX8 And TMBCNO = :DSBCNO
                               and TMHTRP = :DSHTRP
                             Fetch first row only;

                   If Wk_Date7 > 0;
                     Wk_Date10 = %Date(Wk_Date7:*CYMD);
                     DKeyDt = %Dec(Wk_Date10:*MDY);
                   Else;
                     Wk_Date10 = %Date('0001-01-01');
                     DKeyDt = 0;
                   Endif;

                   Select;
                   When TMERR = 'Y';
                       STATUS = 'SUSPENDED';
                   When TMERR = 'R';
                       CLEAR STATUS;
                       STATUS = 'REJECTED';
                   Other;
                       STATUS = 'VALID   ';
                   EndSl;

                   // Retrieve vehicle info for unit selected. No need to validate
                   // unit or beg. trip date since they should always be valid if
                   // already entered.

                   AtUnit = DsUnit;
                   AtCorp = DsCorp;
                   Exsr Fetch_Vehicle_Detail;

                   If SqlCode = 0;
                      ExSr Vecap_Data;
                   EndIf;
                   Clear SqlCode;

                   No_Trp# = '1';
                   Exsr Dts_Process;
                   Select;
                   When Batch_lst = *On;
                     Batch_lst = *Off;
                   When Batch_lst = *Off;
                     LeaveSr;
                   Endsl;
                   Exit_Match_Fl = *INKA;
                   Exit_Match_Fl = *INKB;

                   // Need to seton SFLDSP in case last screen (FULSFL) was empty
                   // and had 63 turned off.

                   *IN63 = *ON;

                 When (WPRMO < Pr_MM And WPRMO <> 0
                       And WPRYR <= Pr_CYY)
                     Or (WPRYR < Pr_CYY And WPRYR <> 0)
                     Or (BTSTS = 'S');
                     *IN83 = *ON;
                     $Msgid = '0193';
                     EXSR Err_Message;

                 When *IN03 = *ON And LSTOPT = '4';
                     DSCORP = WCORP;
                     DSHTRP = WHTRP;
                     DSCUST = WCUST;
                     DSCBG = WCBG;
                     DSCDST = WCDST;
                     DSUNIT = WUNIT;
                     DSBDAT = WBDAT;

                     //  Convert MMDDYY to CYYMMDD.
                     Wk_MDY = DsbDat;
                     Exsr Validate_MDY;
                     If %Error();
                       Wk_Date10 = %Date('0001-01-01');
                       Beg_Date7 = 0;
                     Else;
                       Wk_Date10 = %Date(DsbDat:*mdy);
                       Beg_Date7 = %Dec(Wk_Date10:*cymd);
                     Endif;

                     DSDPC = WDPC;
                     DSDPS = WDPS;
                     DSDSC = WDSC;
                     DSDSS = WDSS;
                     DSERR = WERR;
                     DEL_RRN = DEL_RRN + 1;
                     WRITE DELSFL;

                 When WERR = 'SUSPE' And WCUST = *BLANKS
                      And LSTOPT = '3' and Bch_Flg1 <> 'Y';
                     TRFCNT = TRFCNT + 1;
                     WK_COUNT2 = WK_COUNT2 + 1;
                     CSS(WK_COUNT2) = WHTRP;

                 When LSTOPT = '3' and Bch_Flg1 <> 'Y';
                     *IN83 = *ON;
                     $Msgid = '0461';
                     EXSR Err_Message;
                 EndSl;

                 If *IN83 <> *ON;
                   CLEAR LSTOPT;
                 ENDIF;
               EndIf;

               UPDATE LSTSFL;

               If Exit_Match_Fl = '0' or Not %Eof();
                 READC LSTSFL;
               EndIf;

             EndDo;

             // If not F1 and records were selected for deletion.
             If *INKA = *OFF And DEL_RRN > 0;
               EXSR Delete_Prompt;

               If *INKB = *OFF;
                 // Relock Batch Logging Record since it was released during
                 // the $UPDAT subroutine.

                 Exsr Clear_Sf_List;

                 If $Msgid <> '0002';
                 // Show successful delete message on return to prompt screen.
                   $Msgid = '0018';
                 Endif;

                 EXSR Err_Message;
                 Exsr Load_Sf_Batch_List;
                 Iter;
               EndIf;
             EndIf;

             // If not F1 and records were selected for transfer.
             If *INKA = *OFF And TRFCNT > 0;
               CSSBOX = *BLANKS;
               CSSBAT = *BLANKS;
               DTSTTRFR ( CSSBOX : CSSBAT : TRFCNT :
               DSBOX : DSBCNO );

               If CSSBOX <> *BLANKS And CSSBAT <> *BLANKS;
                 EXSR Transfer_Batch;
                 // Relock Batch Logging Record since it was released during
                 // the $UPDAT subroutine.

                 Exsr Clear_Sf_List;
                 // RELOAD BATCH LIST SCREEN

                 // Show successful transfer message on return to prompt screen.

                 $Msgid = '0462';
                 EXSR Err_Message;
                 Exsr Load_Sf_Batch_List;
                 Iter;
               EndIf;
             EndIf;

             TRFCNT = 0;
             CSS = *BLANKS;
             WK_COUNT2 = 0;

             // Reset SFLEND indicator back to correct value.
             *IN68 = SAV68;

             If *INKA <> *ON
              And (*INKB = *ON or LSEL  = 'Y');
                   Loop4 = *ON;
                   Iter;
             Endif;

           EndIf;
           Loop4 = *OFF;
          EndDo;

         If *INKA = *OFF;
           EXSR Clear_Prompt;
         EndIf;

         ENDIF;

       EndSr;

       //-----------------------------------------------------------------------
       // Clear_Sf_List - Clear subfile screen format list
       //-----------------------------------------------------------------------
       BegSr Clear_Sf_List;

         *IN(60) = *On;
         *IN(61) = *Off;
         *IN(62) = *Off;
         *IN(63) = *Off;
         *IN(64) = *Off;
         *IN(65) = *Off;
         *IN(66) = *Off;
         *IN(67) = *Off;
         *IN(68) = *Off;
         *IN(69) = *Off;
         WRITE LSTCTL;
         *IN(60) = *Off;
         *IN(61) = *Off;
         *IN(62) = *On;
         *IN(63) = *On;
         *IN(64) = *Off;
         *IN(65) = *Off;
         *IN(66) = *Off;
         *IN(67) = *Off;
         *IN(68) = *Off;
         *IN(69) = *Off;
         *IN(70) = *Off;

         Clear List_RRN;
         Clear Wk_Hdr;
       EndSr;
       //-----------------------------------------------------------------------
       // Load_Sf_Batch_List - Load control date for batch list
       //-----------------------------------------------------------------------
       BegSr Load_Sf_Batch_List;

         WK_COUNT2 = 0;
         TrfCnt = 0;
         Css = *Blanks;

         // Load Control Data

         Exec Sql Select Bx01a1 Into :BcssBx from FdtsBox
                   Where BxBox = :DsBox
                   Fetch first row only;
         Clear SqlCode;

         WkBox = DsBox;
         WKBCNO = DsBcno;
         WkLntr = DslNtr;

         Clear WK_COUNT1;
         First = 'N';
         TmpBox = %trim(Dsbox8);
         Exec Sql Open Entr_Batch_Header;
            // Loop to load subfile with up to 11 records (1 Page)
         Dow SqlCode = 0 And List_RRN < 9999;

            Reset Wk_Hdr;
            Exec Sql Fetch Next from Entr_Batch_Header
                           Into :TMCORP,:TMHTRP,:TMCUST,:TMCDST,:TMUNIT,
                                :TMBDAT,:TMSEQ#,:TMAFY,:TMAFM,:TMCBG,
                                :TMDPC,:TMDPS,:TMDSC,:TMDSS,:TMPMM,
                                :TMPDD,:TMPYY,:TMERR;
            If SqlCode <> 0;
               Leave;
            EndIf;

             // IF READ IS SUCCESSFUL, FILL SUBFILE
               // IF 18 IS OFF IE., ALL TRIPS OR IF 18 IS ON THEN ONLY SUSP TRIPS
             If *In18 = *Off Or (*In18 = *On And TmErr = 'Y')
               Or (*In18 = *On And TmErr = 'R');

               CLEAR LSTOPT;
               WPRYR = TMAFY;
               WPRMO = TMAFM;
               WCORP = TMCORP;
               WHTRP = TMHTRP;
               WCUST = TMCUST;
               WCBG = TMCBG;
               WCDST = TMCDST;
               WUNIT = TMUNIT;

               If TMBDAT > 0;
                 Wk_Date10 = %Date(TMBDAT:*CYMD);
                 WBDat = %Dec(Wk_Date10:*MDY);
               Else;
                 Wk_Date10 = %Date('0001-01-01');
                 WBDat = 0;
               Endif;

               WDPC = TMDPC;
               WDPS = TMDPS;
               WDSC = TMDSC;
               WDSS = TMDSS;

               Wk_MM7 = TMPMM;
               Wk_DD7 = TMPDD;
               Wk_CYY7 = TMPYY;

               Wk_Date10 = %Date(Wk_Date7:*CYMD);
               WKeyDt = %Dec(Wk_Date10:*MDY);

               WSEQ = TMSEQ#;

               Select;
               When TMERR = 'Y';
                 WERR = 'SUSPE';
               When TMERR = 'R';
                 WERR = 'REJEC';
               Other;
                 WERR = 'VALID';
               EndSl;

               List_RRN = List_RRN + 1;
               WK_COUNT1 = WK_COUNT1 + 1;
               WRITE LSTSFL;

               // Set on Subfile Display and Subfile Control.

               *IN62 = *ON;
               *IN63 = *ON;

               // POSITION PANEL AT FIRST RECORD WRITTEN
               If FIRST = 'N';
                 LSSRN = List_RRN;
                 FIRST = 'Y';
               EndIf;

             ENDIF;

           // IF End of File, exit loop.

         EndDo;

         Exec Sql Close Entr_Batch_Header;
         Clear SqlCode;

         // Save Last Relative Record Number and seton Subfile End.

         *IN68 = *ON;

         // If no Batch records were written, turn off SFLDSP.

         If List_RRN = 0;
           *IN63 = *OFF;
         EndIf;

       EndSr;

       //-----------------------------------------------------------------------
       // Inquiry_Window - WINDOW INQUIRY SUBROUTINE
       //-----------------------------------------------------------------------

       BegSr Inquiry_Window;

         Select;
         When PANEL = 'FUEL' And
              ##COL >= 33 And ##COL <= 77 And
              ##ROW >= 12 And ##ROW <= 21;

             EXSR Dtm_Cur_Pos;
             DTSTWVNR ( $RTNCD : $$VEND : $$STAT :
             $$VNAM : $$VCTY );

             //     * If not returned by CMD-1, and if not in Display mode,
             //     * Chain out by relative record number and update the subfile
             //     * with the information from the window. Postion the cursor
             //     *

             If $RTNCD <> '1'
               And MODE <> 'DISPLAY';
                 CHAIN FUSRN FULSFL;
                 If %Found();
                   DSVEND = $$VEND;
                   DSVNDN = $$VNAM;
                   DSVNDC = $$VCTY;
                   *IN53 = *On;
                   *IN65 = *ON;
                   UPDATE FULSFL;
                 ENDIF;
             ENDIF;

         When PANEL = 'FUEL';
             EXSR Dtm_Cur_Pos;
             DTSTWINR();

         Other;
             DTSTWINR();
         ENDSl;

         //* Clearing WKCORP after processing RA's
         WKCORP = ' ';
         OUT LDA;
       EndSr;

       //-----------------------------------------------------------------------
       // Determine Cursor Row/Column Position                * $WIND1*
       //-----------------------------------------------------------------------

       BegSr Dtm_Cur_Pos;

         // Determine Row

         CLEAR #CROW;
         %Subst(#CROWA:2:1) = #IROW;
         ##ROW = #CROW;

         // Determine Column

         CLEAR #CCOL;
         %Subst(#CCOLA:2:1) = #ICOL;
         ##COL = #CCOL;

         //       * Calculate the current (CURSOR) location and correct RRN.

         //           * Relative Record Number of first subfile record
         //           * on screen

         FUSRN = INFRRN;

         If ##ROW > 11
           And ##ROW < 22;
           FUSRN = ##ROW - 12;
           FUSRN = FUSRN + INFRRN;
         ENDIF;


         //     * Clear the parms before calling the windows program.

         $RTNCD = '0';
         CLEAR $$VEND;
         CLEAR $$STAT;
         CLEAR $$VNAM;
         CLEAR $$VCTY;

       EndSr;

       //-----------------------------------------------------------------------
       // Process_Help- HELP INFORMATION SUBROUTINE
       //-----------------------------------------------------------------------

       BegSr Process_Help;

         SPHELP ( HELPDS );

       EndSr;

       //************************************************************
       // @ConnectSr - Connect to Remote System                     *
       //************************************************************
       BegSr @ConnectSr;

         //Connect to READING

         wkFlag = *Blanks;
         wkOption = 'C';
         Rmt_Conn(wkOption: wkPgmNam: wkFlag: SqlCod: SqlState: SqlErm);

         If wkFlag = 'Y'
           And Mode <> 'DISPLAY';
           MiErr = 'Y';
           $Msgid = '0913';
           Exsr Err_Message;
         Endif;

       EndSr;
       //************************************************************
       // @DisconnectSr - Disconnect to remote system
       //************************************************************
       BegSr @DisconnectSr;

         //DisConnect from READING

         wkOption = 'D';
         Rmt_Conn(wkOption: wkPgmNam: wkFlag);

         If wkFlag = 'Y'
           And Mode <> 'DISPLAY';
           MiErr = 'Y';
           $Msgid = '0914';
           Exsr Err_Message;
         Endif;

       EndSr;
       //----------------------------------------------------------------------
       // *InzSr : Initialization Subroutine
       //----------------------------------------------------------------------
       BegSr *InzSr;

        // Security
        If LdPgm <> #PsPgm;
           IN Lda;

           If LdPgm <> 'DTSTBCHR';
             Clear LdPgm;
             %Subst(LDPGM:1:8) = 'DTSTBCHR';
             Out Lda;

             Security();
             In Lda;
           EndIf;

             // Load the security indicators
           For WK_COUNT1 = 1 to %Len(LdInds);
             *In(WK_COUNT1) = %SubSt(LdInds:WK_COUNT1:1);
           EndFor;
         EndIf;

         In *Dtaara;

         // Set the user authority for re-entering the unit numbers

         //  HOLD ORIGINAL LDA VALUES
         Eval-Corr Hld_Lda.LDA_Data = LdA;

         // TIME & DATE STAMPS
         Today_7 = %Dec(%Date():*CYMD);
         Today_10 = %Date();

         // Determine earliest Trip date allowed.(Get the value of AACDE1
         //   from the file FSECAUT which will be loaded into the column LDAUT1 in *LDA)

         // Calculate Earliest Trip Date as X Months prior to the Current Date
         //   Where X is the value of LDAUT1 and find beginning of the Month

         Wk_Date10 = Today_10;
         If %check(NUMRC:%trim(LDAUT1)) = 0 and
            %check(' ':LDAUT1) <> 0;        // Check LDAUT1 is Numeric
           Wk_Date10 = Today_10 - %Months(%dec(LDAUT1:2:0));
         Endif;
         Wk_Date10 = Wk_Date10 - %days(%subdt(Wk_Date10:*D)) + %Days(1);
         Today_2Yr = %Dec(Wk_Date10:*CYMD);

      // Determine latest Trip date allowed. The last day of the
      //  month being processed is the last date we allow.
         Wk_CYY7 = Pr_CYY;
         Wk_MM7 = Pr_MM;
         Wk_DD7 = 01;
         Wk_Date10 = %Date(Wk_Date7:*CYMD) + %Months(1) - %Days(1);
         Pr_EOM = %Dec(Wk_Date10:*CYMD);

       // ERROR MESSAGE INFO

         Clear $MData;
         CLEAR $Msev;
       // DEFINE WORK FIELD SIZES

       // SET FIRST TIME CONTROLS

         Loop = *On;
         Loop1 = *OfF;
         Loop2 = *Off;
         Loop3 = *Off;
         SUSREJ = ' ';
         *IN88 = '1';

         Clear DEL_RRN;

         In JobRun;

         If BchRun = 'Y';
           ExSr ChkDtaRef;

           If Rply = 'Y';
             *IN01 = '0';
             *IN02 = '0';
             *IN03 = '0';
             *IN22 = '0';
             *IN88 = '0';
           EndIf;
           Bch_Flg = 'Y';
           Bch_Flg1 = 'Y';
         EndIf;

         // INITIALIZE HELP TEXT FILE NAME
         // Load Help Text Member Name and blank option (10 + 2)

         %Subst(HELPDS:1:8) = 'DTSTHLPR';
         %Subst(HELPDS:9:4) = '    ';

         // Load Function Line names with appropriate data based on
         // security indicators.

         // Load F4=Window
         If *IN22 = *ON;
           DSP04 = FUNA(1);
           ADD04 = FUNA(1);
           CHG04 = FUNA(1);
           DLT04 = FUNA(1);
         ENDIF;

         // Load F8=Display
         ADD08 = FUNB(1);
         CHG08 = FUNB(1);
         DLT08 = FUNB(1);


         // Load F9=Add (if security permits)
         If *IN01 = *ON;
           DSP09 = FUNC(1);
           CHG09 = FUNC(1);
           DLT09 = FUNC(1);
         EndIf;

         // Load F10=Change (if security permits)
         If *IN02 = *ON;
           DSP10 = FUND(1);
           ADD10 = FUNH(1);
           DLT10 = FUND(1);
         EndIf;

         // Load F11=Delete (if security permits)
         If *IN03 = *ON;
           DSP11 = FUNE(1);
           ADD11 = FUNE(1);
           CHG11 = FUNE(1);
         EndIf;

         //Acq_Date_Iso = Acq_Date_Iso - %Months(6);
         //Acq_Date  = %Dec(Acq_Date_Iso:*cymd);

       // If Add allowed (via security), set to ADD mode initially.
       // else, set to DISPLAY mode initially.

         *Inki = *In01;
         *Inkh = not *In01;
         Exsr Chg_Mode;

         Clear Wk25E;
         Exec Sql Select PTDES into :Wk25E from VEHTABF
                   Where  PtCorp = '*ALL' and PTSYS = 'DTS'
                     and  PtPgm = 'DTSOBC' and PtFid = 'TPDMI'
                   Fetch first row only;
         If SqlCode = 0;
            VTDSC = %DEC(Wk25E:25:0);
         Endif;

         Exec sql select PTSDS into :Lwieght from VEHTABF
                   where PTPGM ='DTSTENTR' and PTFID ='LICWGHT'
                   Fetch first row only;

         If SqlCode <> 0 and SqlCode <> 100;
            ExSr *Pssr;
         ENDIF;
         Clear SqlCode;

       EndSr;
       //-----------------------------------------------------------------------
       // GetDates   Get the dates required for the rental net check
       //-----------------------------------------------------------------------
       BegSr GetDates;

         WK_COUNT1 = 1;
         DOU WK_COUNT1 = 99;
           Chain WK_COUNT1 milsfl;
           If Not %found(DTSTENTD) or DSTMDY = *Zeros;
             Leave;
           EndIf;

           Wk_Date10 = %Date(DstMDY:*MDY);
           Wk_Date7 = %Dec(Wk_Date10:*CYMD);

           If Wk_Date7 < Wk_BegDat7P Or Wk_BegDat7P = 0;
             Wk_BegDat7P = Wk_Date7;
           EndIf;

           // Get Trip End. Date
           Wk_EndDat7P = Wk_Date7;
           WK_COUNT1 = WK_COUNT1 + 1;
         EndDo;

         Chain Ctr Milsfl;
       EndSr;
       //************************************************************
       // Err_Message - RETRIEVE ERROR MESSAGE FROM MESSAGE FILE         *
       //************************************************************
       BegSr Err_Message;

         // CLEAR MESSAGE SUBFILE

         If *IN70 = *OFF;
           WRITE MSGCTL;
           CLEAR MSG#;
           %Subst(PGMQ:1:1) = '*';
         EndIf;

         // RETRIEVE MESSAGE TO PROGRAM MESSAGE QUEUE

         $MFile6 = 'DTSMSG';
         If LDAUT2 = 'SP';
           $MFILE8 = 'DTSMSGSP';
         ENDIF;

         $MLIB = '*LIBL';
         SPRTVMSV ( $MID : $MFILE : $MLIB : $MKEY
         : $MDATA : $MSEV );

         // ACCUMULATE NUMBER OF ERRORS BY TYPE

         Select;
         When $MSEV = 10;
           OVER = OVER + 1;
         When $MSEV = 20;
           SUSP = SUSP + 1;
         When $MSEV = 30;
           FATAL = FATAL + 1;
         When $MSEV = 5;
           WARN = WARN + 1;
         EndSl;

         If OVER <> 0 Or SUSP <> 0 Or FATAL <> 0;
           WK_COUNT1 = 0;
         EndIf;

         If *INKE = *ON And MSG# < 20
           Or *INKG = *ON  And MSG# < 20;

           // Save Override/Suspend Errors from the Prompt screen.
           Select;
           When PANEL = 'PRMT';
             //%Occur(PRMMSG) = MSG##;
             %Occur(PRMMSG) = MSG# + 1;
             Prompt_Err_cnt = Prompt_Err_cnt + 1;
             CLEAR PRMLIN;
             PRMMID = $MID;
             PRMSEV = $MSEV;

           // Save Override/Suspend Errors from the Customer screen.
           When PANEL = 'CUST';
             %Occur(CUSMSG) = MSG# + 1;
             Cust_Err_Cnt = Cust_Err_Cnt + 1;
             CLEAR CUSLIN;
             CUSMID = $MID;
             CUSSEV = $MSEV;

           // Save Override/Suspend Errors from the Mile screen.
           When PANEL = 'MILE';
             %Occur(MILMSG) = MSG# + 1;
             Mile_Err_Cnt = Mile_Err_Cnt + 1;
             EvalR MILLIN = %Editc(MISRN:'X');
             MILMID = $MID;
             MILSEV = $MSEV;

           // Save Override/Suspend Errors from the ASR screen.
           When PANEL = 'ASR ';
             %Occur(ASRMSG) = MSG# + 1;
             AState_Err_Cnt = AState_Err_Cnt + 1;
             ASRLIN = DSLINE;
             ASRMID = $MID;
             ASRSEV = $MSEV;

           // Save Override/Suspend Errors from the Fuel screen.
           When PANEL = 'FUEL';
             %Occur(FULMSG) = MSG# + 1;
             Fuel_Err_Cnt = Fuel_Err_Cnt + 1;
             FULLIN = DSLINE;
             FULMID = $MID;
             FULSEV = $MSEV;

           // Save Override/Suspend Errors from the AFR screen.
           When PANEL = 'AFR ';
             %Occur(AFRMSG) = MSG# + 1;
             AFuel_Err_Cnt = AFuel_Err_Cnt + 1;
             AFRLIN = DSLINE;
             AFRMID = $MID;
             AFRSEV = $MSEV;
           EndSl;
         EndIf;


         // WRITE MESSAGE TO MESSAGE SUBFILE (MAXIMUM 20 MESSAGES)
         If MSG# < 20;
           MSGKEY = $MKEY;
           MSG# = MSG# + 1;
           WRITE MSGSFL;
           *IN65 = *ON;
           *IN70 = *ON;
         EndIf;

       EndSr;
       //----------------------------------------------------------------------
       // Upd_Dts_Hdr - Update trip end date and total fuel
       //----------------------------------------------------------------------
        BegSr Upd_Dts_Hdr;
          Exec Sql Update HdrCsr_A Set TmeDat = :Wk_EndDat7
                                 Where TMHTRP = :TMHTRP;
          TMEDAT = Wk_EndDat7;

          Clear SqlCode;
        EndSr;
       //----------------------------------------------------------------------
       //  Load FDTSHDR data
       //----------------------------------------------------------------------
       BegSr Load_Hdr;
         // Clear Pprocssing MM,YY / Determined below

         TMHTRP = DSHTRP;
         TMAFY = 0;
         TMAFM = 0;
         TMBCNO = DSBCNO;
         Eval Tm7A08 = %Trim(DsBox);

         TMUNIT = DSUNIT;
         TMCORP = DSCORP;
         TMCUST = DSCUST;
         TMCBG  = DSCBG;
         TMCDST = DSCDST;
         TMOBR  = DSOBR;

         TMTKTR = DSTKTR;

         TMAXLS = #DSAXLE;
         TMBDAT = Beg_Date7;
         TMDPC  = DSDPC;
         TMDPS  = DSDPS;
         TMDSC  = DSDSC;
         TMDSS  = DSDSS;

         CLEAR TMCTRC;
         CLEAR TMMOM;
         CLEAR TMODIS;
         CLEAR TMKADM;
         CLEAR TMDLOC;
         CLEAR TMOCLC;

         CLEAR TRL3AB;
         CLEAR TRL3C;
         // Get Trip Beginning Speedo for Header.
         TMBSPD = HBSPD;
         TMESPD = DSENDS;

         TMTPML = 0;
         If TMESPD > TMBSPD;
           TMTPML = TMESPD - TMBSPD;
         Endif;

         TRL3A  = $CNTRY;
         If *IN57 = *On;
           TRL3B  = 'M';
           If SUSP > 0 or TMERR <> ' ';
             TRL3C = 0;
           Else;
             Eval(H) TRL3C = TMTPML / 1.609;
           Endif;
         Else;
           TRL3B  = 'U';
           If SUSP > 0 or TMERR <> ' ';
             TRL3C = 0;
           Else;
             Eval(H) TRL3C = TMTPML * 1.609;
           Endif;
         EndIf;

         TMCTRC = TRL3A;
         TMMOM  = TRL3B;
         TMODIS = TRL3C;
         TMLDF  = WKLDF;
         TMGD   = DSFUEL;
         TMKADM = VfAdm;

         Wk_Cust1 = TMCUST;
         If Wk_Cust1 = '3';
           TMLDF = '2';
         EndIf;

         Select;
         When SUSP <> 0 or FATAL <> 0;
           TMAFM = *ZEROS;
           TMAFY = *ZEROS;
         When TMBDAT > Pr_EOM;
           Wk_Date7 = TmBDat;
           TmAfM = Wk_MM7;
           TmAfY = Wk_CYY7;
         Other;
           TMAFM = Pr_Mm;
           TMAFY = Pr_Cyy;
         EndSl;

       EndSr;
       //***************************************************************
       //  Write FDTSHDR data
       //***************************************************************
       BegSr Wrt_HDR;

         TMPMM = Cur_MM7;
         TMPDD = Cur_DD7;
         TMPYY = Cur_CYY7;

         // Flag error code if suspended.
         //CLEAR SUSP.DATE, CORRECTED DATE, REJECTED DATE
         TMSRC = BTFORM;
         CLEAR TM1N70;
         CLEAR TM2N70;
         CLEAR TM3N70;

         If Lwieght_Susp = '1';
            Susp += 1;
         Endif;

         Select;
         When Susp = 0;
           TMERR = ' ';
         When SusRej = 'R' And *IN07 = *On ;
           TMERR = 'R';
           TM3N70 = Today_7;
         Other;
           TMERR = 'Y';
           TM1N70 = Today_7;
           EvalR Tm7A08 = %Trim(TmpBox);
           TMBCNO = TMPBCH;
         EndSl;

         Eval TM7A08 = TMPBOX;
         TMCYMD = *ZEROS;
         TMCUPD = 'ADD';

         TMCLK = LDINIT;
         CLEAR TMLCIN;
         CLEAR TMLCDT;

         // Put the sequence number into the extra field - TF1N70.
         //  The sequence number will be reset at the beginning of
         //  batch and at the start of each day.
         If $HSEQ = 0;
           $HSEQ = 1;
           TMSEQ# = $HSEQ;
         ELSE;
           Exsr Fetch_Seq_Num;
           Clear SqlCode;
         ENDIF;

         If TMERR = 'R';
           PRCFG = 'A';
           ExSr Rejected_Trips;
         ENDIF;

         TMRCWT = Wk_DSRCWT;
         TMAXLS = Wk_DSAXLE;

         If WTAXL_Flg = '0';
           TMRCWT = 0;
           TMAXLS = 0;
         Endif;

         Exec Sql insert into HdrCsr_A
           (TMHTRP, TMAFY, TMAFM, TMBCNO, TMBCBR, TMPMM, TMPDD,
            TMPYY, TMUNIT, TMCORP, TMCUST, TMCBG, TMCDST, TMOBR,
            TMRCWT,TMTKTR,TMAXLS, TMLIC, TMBDAT, TMEDAT,
            TMDPC, TMDPS, TMDSC, TMDSS, TMCTRC,
            TMMOM, TMODIS, TMKADM, TMDLOC, TMOCLC, TMBSPD, TMESPD,
            TMTPML, TMLDF, TMGD, TMERR, TMCUPD, TMCLK,
            TMMMFL, TMSEQ#, TMLCIN, TMLCDT, TMSRC,
            TM1N70, TM2N70, TM3N70,
            TM4A01, TM5A01, TM6A08,  TM7A08)
           Values(:TMHTRP, :TMAFY, :TMAFM, :TMBCNO, :TMBCBR, :TMPMM,
             :TMPDD, :TMPYY, :TMUNIT, :TMCORP, :TMCUST, :TMCBG, :TMCDST,
             :TMOBR, :TMRCWT, :TMTKTR, :TMAXLS,:DSLIC, :TMBDAT,
             :TMEDAT, :TMDPC, :TMDPS, :TMDSC, :TMDSS,
             :TMCTRC, :TMMOM, :TMODIS, :TMKADM, :TMDLOC, :TMOCLC, :TMBSPD,
             :TMESPD, :TMTPML, :TMLDF, :TMGD, :TMERR, :TMCUPD,
             :TMCLK, :TMMMFL, :TMSEQ#, :TMLCIN, :TMLCDT, :TMSRC,
             :TM1N70,:TM2N70, :TM3N70, :TM4A01, :TM5A01, :TM6A08, :TM7A08);

         Clear SqlCode;

         Exsr Get_RANumber;
         Exsr Val_DatTime;
         Exsr Get_UntClas;

         If TMCUST = ' ';
           $BegOdo = 0;
           $EndOdo = 0;
         Endif;

         Exec Sql insert into FDTSCSTSF
           (TMHTRP, TMRCNO, TMINVN, TMUNCL, TMVUSE, TMRANUM, TMBGOD,
            TMENOD, TMDTOT, TMTMOT, TMDTIN, TMTMIN, TMENBY)
           Values (:DSHTRP, :TMRCNO, :TMINVN, :TMUNCL, :VFUSE, :TMRANUM,
           :$BegOdo, :$EndOdo, :TMDTOT, :TMTMOT, :TMDTIN, :TMTMIN, :LDNAME);

       EndSr;
       //***************************************************************
       //  Get RA# and Transaction Number
       //***************************************************************
       BegSr Get_RANumber;

         TMRCNO = 0;
         TMRANUM = $TransNumber;
         If $TransNumber <> *Blanks;
           If %Trim(%Char($ContractKey)) <> '';
             TMRCNO = %Dec($ContractKey);
           Else;
             TMRCNO = 0;
           Endif;
         Endif;

         If TMRCNO = 0;
           TMINVN = $TransNumber;
           TMRANUM = ' ';
         Else;
           TMINVN = ' ';
         Endif;

       EndSr;
       //***************************************************************
       //  Validate Date and Time
       //***************************************************************
       BegSr Val_DatTime;

         If %Char($TimeOut) = '     .00';
            $TimeOut = %Time('00.00.00');
         Endif;

         If %Char($TimeIn)  = '     .00';
            $TimeIn  = %Time('00.00.00');
         Endif;

         TMTMOT = 0;
         if %Trim(%Char($TimeOut)) <> '' and
            %Check(valid_set:%Trim(%Char($TimeOut))) = 0;
           TMTMOT = %Dec($TimeOut);
         endif;

         TMTMIN = 0;
         if %Trim(%Char($TimeIn)) <> '' and
            %Check(valid_set:%Trim(%Char($TimeIn))) = 0;
           TMTMIN = %Dec($TimeIn);
         endif;

         if %Char($DATEOUT) = '0001-     ';
            $DATEOUT = %Date('0001-01-01');
         endif;

         if %Char($DATEIN)  = '0001-     ';
            $DATEIN  = %Date('0001-01-01');
         endif;

         if %Trim(%Char($DATEOUT)) = '' or $DATEOUT = *Loval;
           TMDTOT = Bl_Date;
         else;
           TMDTOT = $DATEOUT;
         Endif;

         if %Trim(%Char($DATEIN)) = '' or $DATEIN = *Loval;
           TMDTIN = Bl_Date;
         else;
           TMDTIN = $DATEIN;
         Endif;

       EndSr;
       //***************************************************************
       //  Retrive Unit Class
       //***************************************************************
       BegSr Get_UntClas;

         Exec Sql SELECT MLCLAS
                    into :TMUNCL
                    from FTCLBILLF
                   Where MLUNIT = :DSUNIT
                   Fetch First Rows Only;

         If SqlCode <> 0;
           TMUNCL = ' ';
         Endif;

       EndSr;
       //***************************************************************
       //  Load FDTSMILE data
       //***************************************************************
       BegSr Load_MILE;
         Reset Sfl_End;

         // If Additional State Mileage Requirements were input(AState_Req_Fnd=YES)
         // then retrieve records from ASRSFL.  Otherwise, retrieve from
         // MILSFL.
         Select;
         When AState_Req_Fnd = 'Y';
           CHAIN Ctr ASRSFL;
           If Not %Found;
             Sfl_End = 'Y';    //  Eof
             LeaveSr;
           EndIf;
           If Wk_DSRCWT = 0;
             Wk_DSRCWT = DSRCWT;
             Wk_DSAXLE = DSAXLE;
           Endif;
         Other;
           CHAIN Ctr MILSFL;
           If Not %Found;
             Sfl_End = 'Y';   //  Eof
             LeaveSr;
           EndIf;
         EndSl;

         // When blank record found, then EOF has been reached
         If DSSE = *BLANKS And DSTMDY = *ZEROS And DSBODM = *ZEROS;
           Sfl_End = 'Y';   //  Eof
           LeaveSR;
         EndIf;

         TMSTRP = DSHTRP;
         TMLINE = DSLINE;

         TMMAFM = TMAFM;
         TMMAFY = TMAFY;

         Wk_MDY = DSTMDY;
         Exsr Validate_MDY;
         If %Error();
           Line_Date = 0;
         else;
           Wk_Date10 = %Date(DSTMDY:*MDY);
           Line_Date = %Dec(Wk_Date10:*CYMD);
         Endif;

         TMBODM = HODOM;
         TMEODM = DSENDS;
         TMCODE = DSCODE;
         TMSE   = DSSE;
         TMTMIS = HMILE;

         If TMTMIS < 0;
           TMTMIS = 0;
         Endif;

         // Don't add toll miles for NY
         TMTOLL = *zeros;
         If not (TMSE = 'NY' and WKLDF = '2');
           TMTOLL = DSTOLL;
         Endif;

         TMRTES = DSRTES;
         // Get Trip Beginning Speedo for Header.
         If DSLINE = '01';
           HBSPD = HODOM;
           Tot_Miles = DSENDS - HODOM;
           If Tot_Miles < 0;
              Tot_Miles = 0;
           Endif;
         EndIf;

         TMTTM = Tot_Miles;
         TMLE = DSLE;

         Exsr Trip_Error_Cd;
         TMMERR = WK_CustErr;

         CLEAR TM1A01;

         TMAXLE = #DSAXLE;
         TMRCWT = #DSRCWT;

         IF (SUSP <> 0 or FATAL <> 0);
           TMMAFM = *Zeros;
           TMMAFY = *Zeros;
         EndIf;

         // Last mileage record written will place ending trip date in
         // WKEDAT to be used when writing to header file below.

         Wk_MDY = DstMdy;
         Exsr Validate_MDY;
         If %Error();
           Wk_EndDat7 = 0;
         else;
           Wk_Date10  = %Date(DstMdy:*MDY);
           Wk_EndDat7 = %Dec(Wk_Date10:*CYMD);
         Endif;

       EndSr;
       //***************************************************************
       //  Trip_Error_Cd - If Trip is in Suspended State then populate
       //                  Trip error code with either 'R' or 'Y'
       //                  else leave it as Blank
       //***************************************************************
       BegSr Trip_Error_Cd;

         Select;
         When SUSP = 0;
           WK_CustErr = ' ';
         When *IN07 = *On And SUSREJ = 'R';
           WK_CustErr = 'R';
         Other;
           WK_CustErr = 'Y';
         EndSl;

       EndSr;
       //***************************************************************
       //  Load FDTSFUEL data
       //***************************************************************
       BegSr Load_Fuel;
         Reset Sfl_End;

           // If Additional Fuel Requirements were input (AFRFND=YES)
           // then retrieve records from AFRSFL.  Otherwise, retrieve from
           // FULSFL.
         Select;
         When AFuel_Req_Fnd = 'Y';
           Chain Ctr AFRSFL;
           If Not %Found();
             Sfl_End = 'Y';    //  Eof
             LeaveSr;
           EndIf;
         Other;
           Chain Ctr FULSFL;
           If Not %Found();
             Sfl_End = 'Y';   //  Eof
             LeaveSr;
           EndIf;
         EndSl;

           // If blank record found, end write processing.
           If    DssPur = *Blanks And DsdPur = 0
             And DstKno = *Blanks And DsFpg  = 0
             And DsqTm  = *Blanks And DsvEnd = *Blanks
             And DsvNdn = *Blanks And DsvNdc = *Blanks;
             Sfl_End = 'Y';
             LeaveSr;
           EndIf;

           TfTrip = DshTrp;
           TfLine = DsLine;    //note line no

           TFAFM  = TMAFM;
           TFAFY  = TMAFY;

           TFSPUR = DSSPUR;
            // Convert MMDDYY to CYYMMDD
           Wk_MDY = DSDPUR;
           Exsr Validate_MDY;
           If %Error();
             Line_Date = 0;
           Else;
             Wk_Date10 = %Date(DsDPur:*MDY);
             Line_Date = %Dec(Wk_Date10:*cymd);
           Endif;

           TFFX = DSFX;
           TFQTM = DSQTM;

             // Convert TO LTRS OR GAL DEPENDING ON THE QTY OF MEASURE

           Select;
           When DSQTM = 'L';
               Eval(H) TFFPG = DSFPG * 3.785;
           When DSQTM = 'G';
               Eval(H) TFFPG = DSFPG / 3.785;
           Other;
               TFFPG = DSFPG;
           EndSl;

           Eval TFFKEY = DSFPG0 * 0.1;
           TFVEND = DSVEND;
           TFVNDN = DSVNDN;
           TFVNDC = DSVNDC;
           TF2A01 = DSTKTRCVD;

           // Flag error code if suspended.
           Exsr Trip_Error_Cd;

           TFERR = WK_CustErr;

           Clear TF1A01;
           TFTAXP = DSTAXP;
           TFORIG = DSORIG;
           TFTKNO = DSTKNO;
           TFSRC  = DSSRC;
           TFINV  = HSINVC;
           TFFSRC = HSSRCF;

       EndSr;
       //-----------------------------------------------------------------------
       // Update_FFUELTKT : Update Fuel ticket file
       //-----------------------------------------------------------------------
        BegSr Update_FFUELTKT;

           WKFCtr = %Lookup(HsTkNo:Fuel_Ds(*).Fuel_tkt);
           If WKFCtr > 0;
             HSFSRC = Fuel_Ds(WKFCtr).Fuel_src;
           Endif;

            // Update fuel ticket file
           Select;
           When SusRej = ' ' or SusRej = 'S';
             FtuDtr = 'U';
             FtTrpA = TmHTrp;
             FtTrpD = %TIMESTAMP();
           Other;
             FtuDtr = ' ';
             FtTrpA = ' ';
             FtTrpD = %Timestamp('0001-01-01-00.00.00.000000');
           EndSl;

           // Connect To Remote system
           Exec Sql Set Connection :WkRemote;

           Exec Sql Update FfuelTkt
                       Set FtuDtr = :FtuDtr,
                           FtTrpA = :FtTrpA,
                           FtTrpD = :FtTrpD
                     Where FtCorp = :HsCorp and FtTkNo = :HsTkNo and
                           FtVend = :HsVend and FtSrc = :HsfSrc;
           Clear SqlCode;

           // Connect To Local
           Exec Sql Set Connection :WkMachine;

           Rls_Flg = 'N';
           If SusRej = 'R';
              Exec Sql Update FMTTKTF
                          set FTUDTR = :FtuDtr, FTTRPA = :FtTrpA,
                              FTTRPD = :FtTrpD
                        Where FTTRPA = :DSHTRP and FtuDtr in ('C','U');

              If HsTkNo = '000000000' or DSSRC <> ' ';
                Rls_Cnt += 1;
                Rls_Flg = 'Y';
              Endif;
           Endif;

           IF (SUSP <> 0 or FATAL <> 0);
             TFAFM = *Zeros;
             TFAFY = *Zeros;
           EndIf;
        EndSr;
       //----------------------------------------------------------------------
       // MXMLVL - To Calculate the Number of Miles it travelled in one day
       //          based on the Trip Day gaps
       //----------------------------------------------------------------------
       BegSr MXMLVL;
         // Clear work fields
         PRVDAT = 0;

         Pos = 0;
         Pos1  = 0;
         TRPMIL = 0;
         DSBODM1 = 0;
         WK_COUNT2 = 99;
         Dow WK_COUNT2 <> 0;
           TRDAY(WK_COUNT2) = 0;
           TRMIL(WK_COUNT2) = 0;
           WK_COUNT2 = WK_COUNT2 - 1;
         EndDo;

         WK_COUNT2 = 99;
         LstOdo = DSENDS;
         Wk_Mile_Err = 0;
         Dow WK_COUNT2 <> 0;
           CHAIN WK_COUNT2 MILSFL;
           If %found(DTSTENTD);
             // In Mileage Mode, Changed to Odomoter Mode

             If *In35 = *On;
               TRPMIL = DSBODM;
             Else;
               DSBODM1 = DSBODM;
             EndIf;

             If DSBODM1 <> 0;
               TRPMIL = LstOdo - DSBODM1;
               LstOdo = DSBODM1;
             EndIf;

             If DSTMDY <> 0;

               Wk_MDY = DstMDY;
               Exsr Validate_MDY;
               If %Error();
                 Wk_Date7 = 0;
                 Wk_Mile_Err = 1;
               ELSE;
                 Wk_Date10 = %Date(DstMDY:*MDY);
                 Wk_Date7 = %Dec(Wk_Date10:*CYMD);
               Endif;

               IF Wk_Date7 <> 0;
                 POS1 = 0;
                 POS1 = %LOOKUP(Wk_Date7:TRDAY);
                 Reset Days_Diff;

               Select;
               When POS1 <> 0;
                   TRDAY(Pos1) = Wk_Date7;

                   // Calculate the gap between trip days.
                   IF PRVDAT <> 0;
                     Days_Diff = %DIFF(%Date(PRVDAT:*CYMD):Wk_Date10:*DAYS);
                   ENDIF;
                   If Days_Diff = 0;
                      Days_Diff = 1;
                   Endif;

                   // Calculate the trip day mileage based on the trip day gaps.
                   If (TRMIL(POS1) + (TRPMIL/Days_Diff)) <= 9999999;
                      TRMIL(POS1) = TRMIL(POS1) + (TRPMIL/Days_Diff);
                   Else;
                      TRMIL(POS1) = 9999999;
                   Endif;

               When PRVDAT <> 0;
                   Days_Diff = %DIFF(%Date(PRVDAT:*CYMD):Wk_Date10:*DAYS);
                   If Days_Diff = 0;
                      Days_Diff = 1;
                   Endif;
                   POS = POS + 1;
                   TRDAY(Pos) = Wk_Date7;
                   TRMIL(POS) =  TRPMIL/Days_Diff;

               Other;                   //PRVDAT = 0
                   If Days_Diff = 0;
                      Days_Diff = 1;
                   Endif;
                   POS = POS + 1;
                   TRDAY(Pos) = Wk_Date7;
                   TRMIL(POS) =  TRPMIL/Days_Diff;
               ENDSl;

            // Store previous date to find out the gap between trip days.
                 PRVDAT = Wk_Date7;
               ENDIF;

             ENDIF;

           ENDIF;
           WK_COUNT2 = WK_COUNT2 - 1;
         ENDDO;
       EndSr;
       //***************************************************************
       // Program Error Handler                               * *PSSR *
       //**************************************************************
       //   Calls:SPCNLRPG (send ESCAPE message to caller of this Pgm)*
       //  Writes:Trxlog Messages  -  Excpt Lines ABORT or TIMOUT     *
       //**************************************************************
       BegSr *PSSR;

         Select;
         When #PSFSI = '01331';
           ##PSSR = *ON;
           #Time = %Dec(%Time());
           CLOSE DTSTENTD;
           @RETRN = '*CANCL';
           Callp(E) SPCNLRPG ( PSSA );
         Other;
           ##PSSR = *ON;
           #Time = %Dec(%Time());
           CLOSE DTSTENTD;
           @RETRN = '*TERM ';
         EndSl;

        ENDSR    @RETRN;
       //-----------------------------------------------------------------------
       // Mlti_Cust - Multiple customers found
       //-----------------------------------------------------------------------
       BegSr Mlti_Cust;

         Valid = 'N';

         // Check if trip Begin date matches with Date out

         Exit_Match_Fl = 'Y';
         Exsr Cmp_Trp_Date;

         // If there is no exact match found for Begin date
         // Check if trip Begin date matches between Date in and Date out

         Exit_Match_Fl = 'N';
         Exsr Cmp_Trp_Date;

       EndSr;

       //*****************************************************************
       // Cmp_Trp_Date - Compare Trip Begin Date with Date-in and Date-out
       //*****************************************************************
       BegSr Cmp_Trp_Date;

         If Valid = 'N';
           OneCust = 'N';
           MltCust = 'N';
           For WK_COUNT1 = 1 To 5;
             Select;
             When WK_COUNT1 = 1 and Exit_Match_Fl = 'Y';
               ResultSet    = ResultSet1;
               If $Resultst <>' ' AND
                 ($DateOut = Wk_BegDt10 );
                 Valid = 'Y';
                 OneCust = 'Y';
                 PResultSet    = ResultSet;
               EndIf;

             When WK_COUNT1 = 1;             //Exit_Match_Fl = 'N'
               ResultSet    = ResultSet1;
               If $Resultst <>' ' AND
                 ($DateOut < Wk_BegDt10 ) AND
                 (($DateIn  >= Wk_BegDt10  ) OR
                 ($DateIn = *Loval));
                 Valid = 'Y';
                 OneCust = 'Y';
                 PResultSet    = ResultSet;
               EndIf;

             When WK_COUNT1 = 2;
               ResultSet    = ResultSet2;

             When WK_COUNT1 = 3;
               ResultSet    = ResultSet3;

             When WK_COUNT1 = 4;
               ResultSet    = ResultSet4;

             When WK_COUNT1 = 5;
               ResultSet    = ResultSet5;

             EndSl;

             Select;
             When WK_COUNT1 > 1 and Exit_Match_Fl = 'Y';

               Select;

               When $Resultst <>' ' AND
                    $DateOut = Wk_BegDt10 And OneCust = 'Y';
                 Valid = 'Y';
                 OneCust = 'N';
                 MltCust = 'Y';

               When $Resultst <>' ' AND
                    $DateOut = Wk_BegDt10;
                 Valid = 'Y';
                 $DateOut = Wk_BegDt10;
                 OneCust ='Y';
                 PResultSet = ResultSet;

               EndSl;

             When WK_COUNT1 > 1;                    //Exit_Match_Fl = 'N'

               Select;

               When ($Resultst <>' ' AND
                    ($DateOut < Wk_BegDt10 ) And
                    (($DateIn  >= Wk_BegDt10  ) OR
                    ($DateIn = *Loval))) AND OneCust = 'Y';
                 Valid = 'Y';
                 OneCust = 'N';
                 MltCust = 'Y';

               When $Resultst <>' ' AND
                    ($DateOut < Wk_BegDt10 ) And
                    (($DateIn  >= Wk_BegDt10  ) OR
                    ($DateIn = *Loval));
                 Valid = 'Y';
                 OneCust ='Y';
                 PResultSet = ResultSet;

               EndSl;
             EndSl;

           EndFor;

           If Valid = 'Y' AND OneCust='Y' AND
             MltCust='N';
             ResultSet =  PResultSet;
             LeaveSr;
           EndIf;

           ResultSet = *blanks;
           Valid = 'N';
         EndIf;

       EndSr;
       //***************************************************************
       // GetNxtTrpdt - Call SPCUSRTVR based on Intermediate dates
       //***************************************************************
       BegSr GetNxtTrpdt;

         Dow Wk_Date7P <= Wk_EndDat7 and Valid  = 'N';
           Wk_Date10 = %Date(Wk_Date7P:*Cymd) + %Days(1);
           Wk_Date7P = %Dec(Wk_Date10:*cymd);

           ExSr Get_CusAdr;

           Select;
           When WK_CustErr = 'M' Or  WK_CustErr = 'X';
              ExSr Mlti_Cust;

           When WK_CustErr = 'N';
              Valid = 'N';
              Wk_BegDt10 = %DATE(Beg_Date7:*CYMD);
              ResultSet    = ResultSet1;

              Exsr Compare_Begin_Date;

              If Valid = 'N';
                ResultSet = *blanks;
              EndIf;

           EndSl;
         EndDo;

       EndSr;
       //-----------------------------------------------------------------------
       // ChkErrs  - Check for non customer related errors
       //-----------------------------------------------------------------------
       BegSr ChkErrs;
         //  Check the Initial Prompt screen Errors
         WK_COUNT1 = 1;
         Dow WK_COUNT1 <= Prompt_Err_cnt;
           %Occur(PRMMSG) = WK_COUNT1;
           If PRMMID <> 'DTS0075'
             and PRMMID <>'DTS0061'
             and PRMMID <>'DTS0062'
             and PRMMID <>'DTS0063'
             and PRMMID <>'DTS0069';
             GoAhead = 'N';
           EndIf;
           WK_COUNT1 = WK_COUNT1 + 1;
         EndDo;
         //  Check the Customer Screen error
         WK_COUNT1 = 1;
         Dow WK_COUNT1 <= Cust_Err_Cnt;
           %Occur(CUSMSG) = WK_COUNT1;
           If CUSMID <> 'DTS0075'
             and CUSMID <>'DTS0061'
             and CUSMID <>'DTS0062'
             and CUSMID <>'DTS0063'
             and CUSMID <>'DTS0069';
             GoAhead = 'N';
             WK_COUNT1 = WK_COUNT1 + 1;
             Iter;
           EndIf;
           Clear CUSMSG;
           WK_COUNT1 = WK_COUNT1 + 1;
         EndDo;
         //  Check the Mileage Screen error
         WK_COUNT1 = 1;
         Dow WK_COUNT1 <= Mile_Err_Cnt;
           %Occur(MILMSG) = WK_COUNT1;
           If MILMID <> 'DTS0075'
             and MILMID <>'DTS0061'
             and MILMID <>'DTS0062'
             and MILMID <>'DTS0063'
             and MILMID <>'DTS0069';
             GoAhead = 'N';
           EndIf;
           WK_COUNT1 = WK_COUNT1 + 1;
         EndDo;
         //  Check the Add. State Req. Screen error
         WK_COUNT1 = 1;
         Dow WK_COUNT1 <= AState_Err_Cnt;
           %Occur(ASRMSG) = WK_COUNT1;
           If ASRMID <> 'DTS0075'
             and ASRMID <>'DTS0061'
             and ASRMID <>'DTS0062'
             and ASRMID <>'DTS0063'
             and ASRMID <>'DTS0069';
             GoAhead = 'N';
           EndIf;
           WK_COUNT1 = WK_COUNT1 + 1;
         EndDo;
         //  Check the FUel Screen error
         WK_COUNT1 = 1;
         Dow WK_COUNT1 <= Fuel_Err_Cnt;
           %Occur(FULMSG) = WK_COUNT1;
           If FULMID <> 'DTS0075'
             and FULMID <>'DTS0061'
             and FULMID <>'DTS0062'
             and FULMID <>'DTS0063'
             and FULMID <>'DTS0069';
             GoAhead = 'N';
           EndIf;
           WK_COUNT1 = WK_COUNT1 + 1;
         EndDo;
         //  Check the Add. Fuel Req. Screen error
         WK_COUNT1 = 1;
         Dow WK_COUNT1 <= AFuel_Err_Cnt;
           %Occur(AFRMSG) = WK_COUNT1;
           If AFRMID <> 'DTS0075'
             and AFRMID <>'DTS0061'
             and AFRMID <>'DTS0062'
             and AFRMID <>'DTS0063'
             and AFRMID <>'DTS0069';
             GoAhead = 'N';
           EndIf;
           WK_COUNT1 = WK_COUNT1 + 1;
         EndDo;

         // Check the error file for any other errors
         Exec Sql Select 'N' Into :GoAhead
                    From FDTSERR
                   Where OvTrip = :DshTrp and Ovmid not in ('DTS0075',
                         'DTS0061','DTS0062','DTS0063','DTS0069')
                   Fetch First 1 rows only;

         //  Clear the customer errors in case no other errors found

         If GoAhead = 'Y';
           Exec Sql Delete from FDTSERR Where OvTrip = :DshTrp;
           Reset Cust_Err_Cnt;
         EndIf;

         Clear SqlCode;

         // Clear the customer errors from data structure
         WK_COUNT1 = 1;
         Dow WK_COUNT1 <= Cust_Err_Cnt;
           %Occur(CUSMSG) = WK_COUNT1;
           If CUSMID = 'DTS0075' Or  CUSMID = 'DTS0061'
             Or  CUSMID = 'DTS0062' Or  CUSMID = 'DTS0063'
             Or  CUSMID = 'DTS0069';
             Clear CUSMSG;
           EndIf;
           WK_COUNT1 = WK_COUNT1 + 1;
         EndDo;

       EndSr;
       //--------------------------------------------------------------------------
       // Get_CusAdr - Get Customer Address details by calling the Program SPCUSRTVR
       //--------------------------------------------------------------------------
       BegSr Get_CusAdr;
         CLEAR $TIME;
         CLEAR ResultSet;
         CLEAR ResultSet1;
         CLEAR ResultSet2;
         CLEAR ResultSet3;
         CLEAR ResultSet4;
         CLEAR ResultSet5;
         %Subst($USE:1:6) = UPUSE;

         Valid = 'N';

         SPCUSRTVR ( DSUNIT : $USE : Wk_Date7P : $Time
         : ResultSet1 : ResultSet2 : ResultSet3 :
         ResultSet4 : ResultSet5 : WK_CustErr : batchflag :
         billflag : GMTFlag : CTFLAG : AccFlag);

       EndSr;
       //---------------------------------------------------------------
       // Mod_VEHMT : Subroutine to modify the fileVEHMTRT
       //---------------------------------------------------------------
       BegSr Mod_VEHMT;

         If TMERR = ' ';
           Wk_CYMD = TMEDAT;

           If TMEDAT > 0;
             Wk_Date10 = %Date(TMEDAT:*CYMD);
             vTimestamp = %timestamp(%Char(Wk_Date10) +
                          '-00.00.00.000000');
           Endif;

           //  Check for the Foreign Unit/Records exists or not
           ExSr Validate_Foreign_Unit;
           //  Update/Insert the values in the file.
           Select;
           When WKAFLG ='Y' And RecExist = 'N';

              Exec Sql Insert Into VEHMTRT
                (MTUNIT, MTCORP, MTTRDT, MTCTYP, MTMTYP, MTMTR, MTSCRP,
               MTSDST, MTSLCN, MTORIG, MTTRID, MTSEQ, MTCFLG, MTESAC, MTATYP,
               MTENDT, MTENBY, MTCHDT, MTCHBY, MTSTAT)
              Values
                (:TMUNIT,:TMCORP,:vTimeStamp,'EN','MI',:TMESPD,' ',' ',
                 ' ','DTR',:TMHTRP,1,'ON ','A',' ', Current_timestamp,
                 '*SYSTEM', Current_timestamp,'*SYSTEM',' ');

           When WKAFLG ='Y';                               //RecExist  = 'Y'

             Exec Sql Update VEHMTRT  Set MTESAC ='A',  MTATYP = ' ',
                   MTCHDT = Current_timestamp, MTCHBY = '*SYSTEM', MTSTAT = ' '
             Where MTUNIT = :TMUNIT and MTCORP = :TMCORP
               and MTTRDT = :vTimeStamp and MTCTYP = 'EN'
               and MTMTYP = 'MI' and MTMTR  = :TMESPD
               and MTSCRP = ' ' and MTSDST = ' '
               and MTSLCN = ' ' and MTORIG = 'DTR'
               and MTTRID = :TMHTRP and MTSEQ  = 1
               and MTCFLG = 'ON ';
           endsl;

         Endif;
         Clear SqlCode;
       EndSr;
       //-----------------------------------------------------------------------
       // Subroutine to find the forigen Unit in the FVEHFIL file
       //-----------------------------------------------------------------------
       BegSr Validate_Foreign_Unit;
         RecExist = *Blanks;
         WKAFLG = 'N';
         WK_COUNT1 = *ZEROS;

         //   Check foreign Unit
         Exec Sql Select 'Y'
                    Into :WKAFLG
                    From FvehFil
                   Where VfUnit = :TmUnit
                   Fetch First 1 rows only;

         If WKAFLG='Y';

           //   populate the key fields & other fields of VEHMTRT file
           RecExist = 'N';
           Exec Sql Select 'Y'
                      Into :RecExist
                      From VEHMTRT
                     Where MTUNIT = :TMUNIT and MTCORP = :TMCORP
                       and MTTRDT = :vTimeStamp and MTCTYP = 'EN'
                       and MTMTYP = 'MI' and MTMTR  = :TMESPD
                       and MTSCRP = ' ' and MTSDST = ' '
                       and MTSLCN = ' ' and MTORIG = 'DTR'
                       and MTTRID = :TMHTRP and MTSEQ  = 1
                       and MTCFLG = 'ON '
                     Fetch First 1 rows only;
         Endif;                                                                 // Unitflg='Y'
       EndSr;
       //-----------------------------------------------------------------------
       //  Get Unit data from VECAP
       //    and Corp Unit of Measure
       //-----------------------------------------------------------------------
       BegSr Vecap_Data;

         WKEFLG = *Blanks;
         WKAFLG = *Blanks;
         WKPRLC = *Blanks;
         WKFLG1 = *Blanks;
         WKFLG2 = *Blanks;
         SPV1CORP ( VFCORP : WKNME : WKAFLG :
         WKFLG1 : WKFLG2 : WKPRSC : WKACSC :
         WKPRLC : WKEFLG : WKUOMC : WKCTRC );

         If WKEFLG = '1' Or WKAFLG <> 'Y' Or WKPRLC <> 'Y';
           RecExist = 'E';
           LeaveSr;
         EndIf;

         $CNTRY = WKCTRC;
         *IN57 = *Off;
         If WKUOMC = 'M';
            *IN57 = *On;
         ENDIF;

         // Get Unit Type to load to TMTKTR (Header) - Tractor/Trailer ID.
         DSTKTR = '2';
         If VFCAT = 'TRUCK';
           DSTKTR = '1';
         EndIf;

         // State License
         DSLIC = VFCLIS;

         // Type of Fuel
         DSFUEL = VFFUEL;

         // Number of Axles
         DSAXLS = VFAXLS;

         // Owning Branch (District)
         DSOBR = VFDIST;

         // Chassis Fuel Tank Capacity
         DSTANK = 350;
         If VFTANK <> 0;
           DSTANK = VFTANK;
         EndIf;

         // Number of Fuel Tanks
         DSNTNK = 1;
         If VFNTNK <> 0;
           DSNTNK = VFNTNK;
         ENDIF;

           // OBTAIN LICENSE AND TARE WEIGHT FROM VEHICLE MASTER FILE

           // Note: VF9N72 is the field from the vehicle file for license
           //       weight.  A license weight is carried on the file as
           //       800.00 and therefore must be mult. by 100 for display
           //       value of 80,000 pounds.
         WKLICW = VF9N72 * 100;
         WKTARE = VFTARE;
       EndSr;
       //-----------------------------------------------------------------------
       // Routine  : ChkDtaRef
       // Function : Check If data is being refreshed
       //-----------------------------------------------------------------------
       BegSr ChkDtaRef;

         //   // If data is being refreshed, send a message to QSysOpr
         Clear Rply;

         Text='Data is being refreshed.Do you want +
              to Continue.';
         Snd_Msg(Text: Rply);

         If Rply = 'N';
           *Inlr = *On;
           Return;
         EndIf;

       EndSr;

       //-----------------------------------------------------------------------
       // Routine  : Validate_MDY
       // Function : Check If the Date is in valid Format
       //-----------------------------------------------------------------------
       BegSr Validate_MDY;

         Test(DE) *mdy Wk_MDY;
         Reset Wk_MDY;

       EndSr;

       //-----------------------------------------------------------------------
       // Dcl_Cursor : Declare Cursor
       //-----------------------------------------------------------------------
        BegSr Dcl_Cursor;
           // Cursor for batch list
          Exec Sql Declare Entr_Batch_Header Cursor for
                   Select TMCORP, TMHTRP, TMCUST, TMCDST, TMUNIT,
                          TMBDAT, TMSEQ#, TMAFY, TMAFM, TMCBG,
                          TMDPC, TMDPS, TMDSC, TMDSS, TMPMM,
                          TMPDD, TMPYY, TMERR
                     from HdrCsr_A
                   Where TM7A08 = :Tmpbox and TMBCNO = :DsBcno
                   Order By TM7A08,TMBCNO,TMPYY,TMPMM,TMPDD,TMSEQ#;

          Exec Sql Declare Entr_Mile_Cursor  Cursor for
                   Select TMLINE, TMRTES, TMCODE, TMBODM, TMTMIS, TMTOLL,
                          TMRCWT, TMSE, TMLE, TMAXLE, TMEODM, TMTPMM,
                          TMTPDD, TMTPYY
                     from MileCsr_A
                   Where TMSTRP = :DshTrp
                order by TMLINE;

           // Fuel ticket
          Exec Sql Declare Entr_Tkt_Cursor Cursor for
                   Select FTUDTR, FTGALN, FTFUSE, FTSTST, FTTKNO,
                          FTICUS, FTODIS, FTVEND, FTSTNA, FTSTCT,
                          FTPDAT, FTSRC, FTCORP
                     from FFUELTKTV4 a Join FLTFUETL1 b
                      on a.FTFTYP = b.FLFTYP and b.FlFSrF = 'Y'
                     and FTIUNI = :DSUNIT and FTCORP = :DSCORP
                     and FTPSTS = 'V' and FTICUS = :Wk_Cust8
                     and FTUDTR <> 'U' and FTGALN <> 0  and FTFUSE <> 'R'
                     and FTPDAT between :Wk_Date7P and :Wk_EndDat7
                   Order By FTIUNI,FTPDAT;

           // Fuel File
          Exec Sql Declare Entr_Fuel_Cursor Cursor for
                   Select TFLINE, TFSRC, TFINVM, TFINVD, TFINVY,
                          TFSPUR, TFTKNO, TFFKEY, TFQTM, TFVEND,
                          TFVNDN, TFVNDC, TFTAXP, TFORIG, TFFX,
                          TF2A01, TFINV, TFFSRC
                     from FuelCsr_A
                   Where TFTRIP = :DSHTRP
                   Order by TFAFY,TFAFM,TFLINE;

         //FFueltkt Cursor
         Exec Sql Declare Entr_Fueltkt_Cursor Cursor for
                  Select FTTKNO, FTSRC
                    from Ffueltkt
                  Where FtTrpA = :DSHTRP;

        EndSr;
       //***************************************************************
     O**RFUELTK3  E            UNLCK2
** FUNA
F4=Window
** FUNB
F8=Disp
** FUNC
F9=Add
** FUND
F10=Change
** FUNE
F11=Delete
** FUNF
F7=Suspend
** FUNFR
F7=Sus/Rej
** FUNG
F5=Override
** FUNH
F10=Chg
