// PROGRAM compiler
function compiler (input) {
 inbuf = input ;
 inp = 0 ;
 outbuf = "" ;
 margin = 0 ;
 gnlabel = 1 ;
 rulePROGRAM() ;
 return outbuf ;
 } ;

function rulePROGRAM () {
 var rname = "PROGRAM" ;
 var rlabel = 0 ;
 runTST('.SYNTAX');
 if (flag) {
  runID();
  if (!flag) runBEjsfn(rname);
  runLB();
  runCL('// ');
  runCI();
  runCL(' compiler');
  runextNL();
  runCL('function compiler (input) {');
  runextLMI();
  runextNL();
  runCL('inbuf = input ;');
  runextNL();
  runCL('inp = 0 ;');
  runextNL();
  runCL('outbuf = "" ;');
  runextNL();
  runCL('margin = 0 ;');
  runextNL();
  runCL('gnlabel = 1 ;');
  runextNL();
  runCL('rule');
  runCI();
  runCL('() ;');
  runextNL();
  runCL('return outbuf ;');
  runextNL();
  runextLMD();
  runCL('} ;');
  runextNL();
  runextNL();
  runSET();
  while (flag) {
   ruleST();
   };
  runSET();
  if (!flag) runBEjsfn(rname);
  runTST('.END');
  if (!flag) runBEjsfn(rname);
  } ;
 } ;

function ruleST () {
 var rname = "ST" ;
 var rlabel = 0 ;
 runID();
 if (flag) {
  runLB();
  runCL('function rule');
  runCI();
  runCL(' () {');
  runextLMI();
  runextNL();
  runCL('var rname = "');
  runCI();
  runCL('" ;');
  runextNL();
  runCL('var rlabel = 0 ;');
  runextNL();
  runTST('=');
  if (!flag) runBEjsfn(rname);
  ruleEX1();
  if (!flag) runBEjsfn(rname);
  runTST(';');
  if (!flag) runBEjsfn(rname);
  runextLMD();
  runCL('} ;');
  runextNL();
  runextNL();
  } ;
 } ;

function ruleEX1 () {
 var rname = "EX1" ;
 var rlabel = 0 ;
 ruleEX2();
 if (flag) {
  runSET();
  while (flag) {
   runTST('/');
   if (flag) {
    runCL('if (!flag) {');
    runextLMI();
    runextNL();
    ruleEX2();
    if (!flag) runBEjsfn(rname);
    runextLMD();
    runCL('} ;');
    runextNL();
    } ;
   };
  runSET();
  if (!flag) runBEjsfn(rname);
  } ;
 } ;

function ruleEX2 () {
 var rname = "EX2" ;
 var rlabel = 0 ;
 ruleEX3();
 if (flag) {
  runCL('if (flag) {');
  runextLMI();
  runextNL();
  } ;
 if (!flag) {
  ruleOUTPUT();
  if (flag) {
   runCL('if (true) {');
   runextLMI();
   runextNL();
   } ;
  } ;
 if (flag) {
  runSET();
  while (flag) {
   ruleEX3();
   if (flag) {
    runCL('if (!flag) runBEjsfn(rname);');
    runextNL();
    } ;
   if (!flag) {
    ruleOUTPUT();
    if (flag) {
     } ;
    } ;
   };
  runSET();
  if (!flag) runBEjsfn(rname);
  runextLMD();
  runCL('} ;');
  runextNL();
  } ;
 } ;

function ruleEX3 () {
 var rname = "EX3" ;
 var rlabel = 0 ;
 runID();
 if (flag) {
  runCL('rule');
  runCI();
  runCL('();');
  runextNL();
  } ;
 if (!flag) {
  runSR();
  if (flag) {
   runCL('runTST(');
   runCI();
   runCL(');');
   runextNL();
   } ;
  } ;
 if (!flag) {
  runTST('.ID');
  if (flag) {
   runCL('runID();');
   runextNL();
   } ;
  } ;
 if (!flag) {
  runTST('.NUMBER');
  if (flag) {
   runCL('runNUM();');
   runextNL();
   } ;
  } ;
 if (!flag) {
  runTST('.STRING');
  if (flag) {
   runCL('runSR();');
   runextNL();
   } ;
  } ;
 if (!flag) {
  runTST('(');
  if (flag) {
   ruleEX1();
   if (!flag) runBEjsfn(rname);
   runTST(')');
   if (!flag) runBEjsfn(rname);
   } ;
  } ;
 if (!flag) {
  runTST('.EMPTY');
  if (flag) {
   runCL('runSET();');
   runextNL();
   } ;
  } ;
 if (!flag) {
  runTST('$');
  if (flag) {
   runCL('runSET();');
   runextNL();
   runCL('while (flag) {');
   runextLMI();
   runextNL();
   ruleEX3();
   if (!flag) runBEjsfn(rname);
   runCL('};');
   runextLMD();
   runextNL();
   runCL('runSET();');
   runextNL();
   } ;
  } ;
 } ;

function ruleOUTPUT () {
 var rname = "OUTPUT" ;
 var rlabel = 0 ;
 runTST('.OUT');
 if (flag) {
  runTST('(');
  if (!flag) runBEjsfn(rname);
  runSET();
  while (flag) {
   ruleOUT1();
   };
  runSET();
  if (!flag) runBEjsfn(rname);
  runTST(')');
  if (!flag) runBEjsfn(rname);
  } ;
 } ;

function ruleOUT1 () {
 var rname = "OUT1" ;
 var rlabel = 0 ;
 runTST('*');
 if (flag) {
  runCL('runCI();');
  runextNL();
  } ;
 if (!flag) {
  runSR();
  if (flag) {
   runCL('runCL(');
   runCI();
   runCL(');');
   runextNL();
   } ;
  } ;
 if (!flag) {
  runTST('#');
  if (flag) {
   runCL('if (rlabel == 0) { rlabel = gnlabel; gnlabel++ ; } ;');
   runextNL();
   runCL('runCL(rlabel.toString());');
   runextNL();
   } ;
  } ;
 if (!flag) {
  runTST('.NL');
  if (flag) {
   runCL('runextNL();');
   runextNL();
   } ;
  } ;
 if (!flag) {
  runTST('.LB');
  if (flag) {
   runCL('runLB();');
   runextNL();
   } ;
  } ;
 if (!flag) {
  runTST('.TB');
  if (flag) {
   runCL('runextTB();');
   runextNL();
   } ;
  } ;
 if (!flag) {
  runTST('.LM+');
  if (flag) {
   runCL('runextLMI();');
   runextNL();
   } ;
  } ;
 if (!flag) {
  runTST('.LM-');
  if (flag) {
   runCL('runextLMD();');
   runextNL();
   } ;
  } ;
 } ;

