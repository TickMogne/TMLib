**Free

Dcl-Pr ConvertByteToHex Char(2);
  Byte Uns(3) Const;
End-Pr;

Dcl-Pr ConvertHexToByte Uns(3);
  Hex Char(2) Const;
End-Pr;

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

Dcl-Pr GetErrno Int(10);
End-Pr;

Dcl-Pr HttpResponse OpDesc;
  Buffer Char(2000) Const Options(*Varsize);
End-Pr;

Dcl-Pr HttpRequestLoad Pointer;
  AcceptedMethod Char(5) Const Options(*Nopass);
End-Pr;

Dcl-Pr HttpRequestKey Ind;
  RequestData Pointer Const;
  Key Char(128) Const Options(*Varsize);
End-Pr;

Dcl-Pr HttpRequestValue Char(8192);
  RequestData Pointer Const;
  Name Char(128) Const Options(*Varsize);
End-Pr;

Dcl-Pr HttpTokenCheck Ind;
  Token Char(32) Const;
End-Pr;

Dcl-Pr HttpTokenCreate Char(32);
  OldToken Char(32) Const Options(*Nopass);
End-Pr;

Dcl-Pr HttpTokenDelete;
  Token Char(32);
End-Pr;

Dcl-Pr HttpTokenGenerate Char(32);
End-Pr;

Dcl-Pr HttpTokenGetData Char(8192);
  Token Char(32) Const;
  DataName Char(128) Const Options(*Varsize);
End-Pr;

Dcl-Pr HttpTokenSetData Ind;
  Token Char(32) Const;
  DataName Char(128) Const Options(*Varsize);
  DataValue Char(8192) Const Options(*Varsize);
End-Pr;

Dcl-Pr Lower Char(65535) OpDesc;
  Text Char(65535) Const Options(*Varsize);
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
  Text Char(65535) Const Options(*Varsize);
End-Pr;
