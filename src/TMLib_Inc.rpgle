**Free

Dcl-Pr CreateUserSpace;
  UserSpaceName Char(20) Const;
  Error LikeDs(ERRC0100) Options(*nopass);
End-Pr;

Dcl-Pr DeleteUserSpace;
  UserSpaceName Char(20) Const;
  Error LikeDs(ERRC0100) Options(*nopass);
End-Pr;

Dcl-Pr EscapeMessage;
  Error LikeDs(ERRC0100) Const Options(*Omit);
  Text Char(240) Const Options(*Nopass:*Varsize);
End-Pr;

Dcl-Pr Lower Char(65535) OpDesc;
  Text Char(1) Options(*Varsize);
End-Pr;

Dcl-Pr MemVal Uns(3);
  Address Pointer Const;
  ZeroIndex Int(10) Const Options(*Nopass);
End-Pr;

Dcl-Pr MemValChar Char(1);
  Address Pointer Const;
  ZeroIndex Int(10) Const Options(*Nopass);
End-Pr;

Dcl-Pr Upper Char(65535) OpDesc;
  Text Char(1) Options(*Varsize);
End-Pr;
