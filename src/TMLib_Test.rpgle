**Free

Ctl-Opt DftActGrp(*No) Main(MainProc) BndDir('TMLIB_M');

/include TMApi_Inc.rpgle
/include TMLib_Inc.rpgle

Dcl-Proc MainProc;
  Dcl-Ds Error LikeDs(ERRC0100);
  Dcl-S USName Char(20) Inz('TEST      QTEMP');
  Dcl-S USHeaderPtr Pointer;
  Dcl-Ds USHeader LikeDS(UserSpaceHeader) Based(USHeaderPtr);
  Dcl-S Byte Uns(3);

  USName = Upper(USName);

  quscrtus(USName: '': 1: x'00': '*ALL': '': '*YES': Error);
  If (Error.BytesAvailable > 0);
    EscapeMessage(Error);
    Return;
  EndIf;
  Byte = MemVal(%addr(USName):2);
  Dsply Byte;

  quslobj(USName: 'OBJL0100': '*ALL      TPIRI1': '*ALL': Error);
  If (Error.BytesAvailable > 0);
    EscapeMessage(Error);
    Return;
  EndIf;

  qusptrus(USName: USHeaderPtr: Error);
  If (Error.BytesAvailable > 0);
    EscapeMessage(Error);
    Return;
  EndIf;

  qusdltus(USName: Error);

End-Proc;
