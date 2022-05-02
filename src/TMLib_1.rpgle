**Free

Ctl-Opt Nomain;

/include TMApi_Inc.rpgle

Dcl-Proc CreateUserSpace Export;
  Dcl-Pi CreateUserSpace;
    UserSpaceName Char(20) Const;
    Error LikeDs(ERRC0100) Options(*nopass);
  End-Pi;

  quscrtus(UserSpaceName: '': 1: x'00': '*ALL': '': '*YES': Error);
End-Proc;

Dcl-Proc DeleteUserSpace Export;
  Dcl-Pi DeleteUserSpace;
    UserSpaceName Char(20) Const;
    Error LikeDs(ERRC0100) Options(*nopass);
  End-Pi;

  qusdltus(UserSpaceName: Error);
End-Proc;

Dcl-Proc EscapeMessage Export;
  Dcl-Pi EscapeMessage;
    Error LikeDs(ERRC0100) Const Options(*Omit);
    Text Char(240) Const Options(*Nopass:*Varsize);
  End-Pi;
  Dcl-C QCPFMSG 'QCPFMSG   *LIBL';
  Dcl-Ds LocalError LikeDs(ERRC0100);
  
  If (%parms < 2); 
    qmhsndpm(Error.ExceptionId: QCPFMSG: Error.ExceptionData: Error.BytesAvailable-16: '*ESCAPE': '*PGMBDY': 1: '': LocalError);
  Else;
    qmhsndpm('CPF9898': QCPFMSG: Text: %Len(%Trim(Text)): '*ESCAPE': '*PGMBDY': 1: '': LocalError);
  EndIf;
End-Proc;

Dcl-Proc Lower Export;
  Dcl-Pi Lower Char(65535) OpDesc;
    Text Char(1) Options(*Varsize);
  End-Pi;

  Dcl-S p2 Int(10);
  Dcl-S p3 Int(10);
  Dcl-S p4 Int(10);
  Dcl-S p5 Int(10);
  Dcl-S l1 Int(10);
  Dcl-S i Int(10);
  Dcl-S ch Uns(3);
  Dcl-S Ret Char(65535) Inz(*Blanks);

  ceedod(1: p2: p3: p4: p5: l1);

  If (l1 < 1);
    Return '';
  EndIf;

  For i = 1 To l1;
    ch = MemVal(%Addr(Text) + i - 1);
    ch = tolower(ch);
    memcpy(%Addr(Ret) + i - 1: %Addr(ch): 1);
    If (ch = 0);
      Leave;
    EndIf;
  EndFor;

  Return Ret;
End-Proc;

Dcl-Proc MemVal Export;
  Dcl-Pi MemVal Uns(3);
    Address Pointer Const;
    ZeroIndex Int(10) Const Options(*Nopass);
  End-Pi;

  Dcl-S Ptr Pointer;
  Dcl-S Ret Uns(3) Based(Ptr);
  Dcl-S Index Int(10);

  If (%parms < 2);
    Index = 0;
  Else;
    Index = ZeroIndex;
  EndIf;

  Ptr = Address + Index;

  Return Ret;
End-Proc;

Dcl-Proc MemValChar Export;
  Dcl-Pi MemValChar Char(1);
    Address Pointer Const;
    ZeroIndex Int(10) Const Options(*Nopass);
  End-Pi;

  Dcl-S Ptr Pointer;
  Dcl-S Ret Char(1) Based(Ptr);
  Dcl-S Index Int(10);

  If (%parms < 2);
    Index = 0;
  Else;
    Index = ZeroIndex;
  EndIf;

  Ptr = Address + Index;

  Return Ret;
End-Proc;

Dcl-Proc Upper Export;
  Dcl-Pi Upper Char(65535) OpDesc;
    Text Char(1) Options(*Varsize);
  End-Pi;

  Dcl-S p2 Int(10);
  Dcl-S p3 Int(10);
  Dcl-S p4 Int(10);
  Dcl-S p5 Int(10);
  Dcl-S l1 Int(10);
  Dcl-S i Int(10);
  Dcl-S ch Uns(3);
  Dcl-S Ret Char(65535) Inz(*Blanks);

  ceedod(1: p2: p3: p4: p5: l1);

  If (l1 < 1);
    Return '';
  EndIf;

  For i = 1 To l1;
    ch = MemVal(%Addr(Text) + i - 1);
    ch = toupper(ch);
    memcpy(%Addr(Ret) + i - 1: %Addr(ch): 1);
    If (ch = 0);
      Leave;
    EndIf;
  EndFor;

  Return Ret;
End-Proc;
