**Free

Dcl-Pr CenterText Char(2000);
  Text Char(2000) Const Options(*Varsize);
  Length Int(10) Const;
End-Pr; 

Dcl-Pr ChangeDataArea;
  QualifiedDataAreaName Char(20) Const;
  Start Int(10) Const;
  Length Int(10) Const;
  Data Char(2000) Const Options(*Varsize);    
  Error LikeDs(ERRC0100);
End-Pr;

Dcl-Pr ConvertByteToHex Char(2);
  Byte Uns(3) Const;
End-Pr;

Dcl-Pr ConvertHexToByte Uns(3);
  Hex Char(2) Const;
End-Pr;

Dcl-Pr CreateError LikeDs(ERRC0100);
  ExceptionId Char(7) Const;
  ExceptionData Char(240) Options(*Varsize:*Nopass) Const;
  ExceptionDataLength Int(10) Options(*Nopass) Const;
End-Pr;

Dcl-Pr CreateQualifiedTempFileName Char(20);
End-Pr;

Dcl-Pr CreateTempFileName Char(16);
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

Dcl-Pr ExecuteCommand;
  Command Char(65535) Const Options(*Varsize);
  Error LikeDs(ERRC0100);
End-Pr;

Dcl-Pr GetErrno Int(10);
End-Pr;

Dcl-Pr GetMessageText Char(2000);
  MessageId Char(7) Const;
  Data Char(1) Const Options(*Varsize:*Nopass);
  DataLen Int(10) Const Options(*Nopass);
  MessageFile Char(20) Const Options(*Nopass);
End-Pr;

Dcl-Pr HttpGetEnv Char(8192);
  VariableName Char(128) Const Options(*Varsize);
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

Dcl-Pr InfoMessage;
  Error LikeDs(ERRC0100) Const Options(*Omit);
  Text Char(240) Const Options(*Nopass:*Varsize);
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

Dcl-Pr RetrieveDataArea Char(2000);
  QualifiedDataAreaName Char(20) Const;
  Start Int(10) Const;
  Length Int(10) Const;  
  Error LikeDs(ERRC0100);
End-Pr;

Dcl-Pr Upper Char(65535) OpDesc;
  Text Char(65535) Const Options(*Varsize);
End-Pr;
