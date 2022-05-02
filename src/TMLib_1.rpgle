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
  Dcl-S MessageText Char(240);
  
  // Check if only one parameter is passed 
  If (%parms < 2);
    // Use the Error parameter
    qmhsndpm(Error.ExceptionId: QCPFMSG: Error.ExceptionData: Error.BytesAvailable-16: '*ESCAPE': '*PGMBDY': 1: '': LocalError);
  Else; // Use the Text parameter, the Error parameter should be omitted
    // Check if the Text ends with a dot (.)
    If (%Subst(Text: %Len(%Trim(Text)): 1) = '.');
      // Remove the trailing dot from the Text
      MessageText = %Subst(Text: 1: %Len(%Trim(Text))-1);
    Else;
      // Use the Text without changes
      MessageText = Text;
    EndIf;
    // Send the escape message
    qmhsndpm('CPF9898': QCPFMSG: MessageText: %Len(%Trim(MessageText)): '*ESCAPE': '*PGMBDY': 1: '': LocalError);
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

  // Get the information of the 1st parameter
  ceedod(1: p2: p3: p4: p5: l1);

  // If the length of the text is less than 1, return *blank
  If (l1 < 1);
    Return '';
  EndIf;

  // Go through the text
  For i = 1 To l1;
    // Get the character
    ch = MemVal(%Addr(Text) + i - 1);
    // Convert to lower case
    ch = tolower(ch);
    // Save the lower cased character into the returned text
    memcpy(%Addr(Ret) + i - 1: %Addr(ch): 1);
    // Exit if the character is x'00'
    If (ch = 0);
      Leave;
    EndIf;
  EndFor;

  // Return the lower cased text
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

  // Get the information of the 1st parameter
  ceedod(1: p2: p3: p4: p5: l1);

  // If the length of the text is less than 1, return *blank
  If (l1 < 1);
    Return '';
  EndIf;

  // Go through the text
  For i = 1 To l1;
    // Get the character
    ch = MemVal(%Addr(Text) + i - 1);
    // Convert to upper case
    ch = toupper(ch);
    // Save the upper cased character into the returned text
    memcpy(%Addr(Ret) + i - 1: %Addr(ch): 1);
    // Exit if the character is x'00'
    If (ch = 0);
      Leave;
    EndIf;
  EndFor;

  // Return the upper cased text
  Return Ret;
End-Proc;
