/*********************************************************************   */
/* /TITLE  DTSTBATC-DTS BATCH CONTROL MAINTENANCE App Nbr: DTS.69.A  */
/*                                                                   */
/*  DTS BATCH CONTROL MAINTENANCE                                    */
/*                                                                   */
/*  Created by: VINAY RAMANAND  12/21/98                             */
/*                                                                   */
/* Y2 * YEAR 2000  COMPLIANCE     PROJECT #G752     PHASE I COMPLETE */
/*                                                                   */
/*                                                                 */
/* Changed By: KRISHNA TANGA            02/15/00                   */
/*    Use the Data area to see whether the Transmission job is     */
/*    running,if it is then send a message to sign-off immediately.*/
/*               (SCAN FOR KRI).                                   */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

             PGM

             DCL        VAR(&UPDFLG) TYPE(*CHAR) LEN(1)     /* KRI */
             RTVDTAARA  DTAARA(DTSBCHUPD (1 1)) RTNVAR(&UPDFLG) /* +
                          KRI*/
             IF         COND(&UPDFLG = 'Y') THEN(DO)         /* KRI */
             SNDPGMMSG  MSG('Please Sign-off immeditely. +
                          Transmission job needs to run now') /* KRI */
             ENDDO                                          /* KRI */
             ELSE       CMD(DO)                             /* KRI */
             CALL       PGM(DTSTBCHR) PARM('BAT')
             ENDDO                                          /* KRI */

 EXIT:       ENDPGM
