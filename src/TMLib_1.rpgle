**Free

Ctl-Opt Nomain;

/include TMApi_Inc.rpgle
/include TMLib_Inc.rpgle

Dcl-Proc CenterText Export;
  Dcl-Pi CenterText Char(2000);
    Text Char(2000) Const Options(*Varsize);
    Length Int(10) Const;
  End-Pi; 
  Dcl-S e Int(10);
  Dcl-S s Int(10);
  Dcl-S o Int(10);
  Dcl-S Temp Char(2000); 

  s = 1;
  DoW s <= Length And %Subst(Text: s: 1) = ' ';
    s = s + 1;
  EndDo;
  e = Length;
  DoW e > 0 And %Subst(Text: e: 1) = ' ';
    e = e - 1;
  EndDo;

  Temp = *Blanks;
  o = %Int((Length-(e-s+1))/2);
  Dow s <= e;
    %Subst(Temp: o: 1) = %Subst(Text: s: 1);
    o = o + 1;
    s = s + 1;
  EndDo;

  Return Temp;
End-Proc;

Dcl-Proc ChangeDataArea Export;
  Dcl-Pi ChangeDataArea;
    QualifiedDataAreaName Char(20) Const;
    Start Int(10) Const;
    Length Int(10) Const;
    Data Char(2000) Const Options(*Varsize);    
    Error LikeDs(ERRC0100);
  End-Pi;

  Clear Error;  

  Monitor;
    qxxchgda(QualifiedDataAreaName: Start: Length: Data);
  On-Error;
    Error.ExceptionId = 'CPF9898';
    Error.BytesAvailable = 16 + %Len(%Trim(ProgramStatus.ExceptionText));
    Error.ExceptionData = ProgramStatus.ExceptionText;
  EndMon;
End-Proc;

Dcl-Proc ConvertByteToHex Export;
  Dcl-Pi ConvertByteToHex Char(2);
    Byte Uns(3) Const;
  End-Pi;
  Dcl-S HexDigits Char(16) Inz('0123456789ABCDEF');
  Dcl-S Ret Char(2);
  Dcl-S h Uns(3);
  Dcl-S l Uns(3);

  h = %Div(Byte: 16);
  l = %Rem(Byte: 16);

  Ret = %Subst(HexDigits: h+1: 1) + %Subst(HexDigits: l+1: 1);

  Return Ret;
End-Proc;

Dcl-Proc ConvertHexToByte Export;
  Dcl-Pi ConvertHexToByte Uns(3);
    Hex Char(2) Const;
  End-Pi;
  Dcl-S HexDigits Char(16) Inz('0123456789ABCDEF');
  Dcl-S Ret Uns(3);

  Ret = 16 * (%Scan(%Subst(Hex: 1: 1): HexDigits) - 1);
  Ret += %Scan(%Subst(Hex: 2: 1): HexDigits) - 1;

  Return Ret;
End-Proc;

Dcl-Proc CreateError Export;
  Dcl-Pi CreateError LikeDs(ERRC0100);
    ExceptionId Char(7) Const;
    ExceptionData Char(240) Options(*Varsize:*Nopass) Const;
    ExceptionDataLength Int(10) Options(*Nopass) Const;    
  End-Pi;
  Dcl-Ds Error LikeDs(ERRC0100);

  Error.ExceptionId = ExceptionId;

  If (%parms > 1);
    If (%parms > 2);
      Error.BytesAvailable = 16 + ExceptionDataLength;
    Else;
      Error.BytesAvailable = 16 + %Len(%Trim(ExceptionData));
    EndIf;
    Error.ExceptionData = ExceptionData;
  Else;
    Error.BytesAvailable = 16;
    Error.ExceptionData = *Blanks;
  Endif;

  Return Error;
End-Proc;

Dcl-Proc CreateQualifiedTempFileName Export;
  Dcl-Pi CreateQualifiedTempFileName Char(20);
  End-Pi;

  Dcl-S FileName Char(16);
  Dcl-S QualifiedFileName Char(20) Inz(*Blanks);
  tmpnam(%Addr(FileName));
  %Subst(QualifiedFileName: 1: 10) = %Subst(FileName: 7: 10);
  %Subst(QualifiedFileName: 11: 5) = %Subst(FileName: 1: 5);

  Return QualifiedFileName;
End-Proc;

Dcl-Proc CreateTempFileName Export;
  Dcl-Pi CreateTempFileName Char(16);
  End-Pi; 

  Dcl-S FileName Char(16);
  tmpnam(%Addr(FileName));

  Return FileName;
End-Proc;

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
  Dcl-Ds Error2 LikeDs(ERRC0100);

  qusdltus(UserSpaceName: Error2);
  If (%parms > 1);
    Error = Error2;
  EndIf;
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

Dcl-Proc ExecuteCommand Export;
  Dcl-Pi ExecuteCommand;
    Command Char(65535) Const Options(*Varsize);
    Error LikeDs(ERRC0100);
  End-Pi;
  Dcl-S UserSpaceName Char(20);
  Dcl-Ds ErrorLocal LikeDs(ERRC0100);
  Dcl-Ds JSLT0100;
    *N Int(10) Pos(1) Inz(10);
    *N Char(10) Pos(5) Inz('*PRV');
    *N Char(26) Pos(15) Inz('*');
    *N Char(16) Pos(41) Inz(*Blanks);
    *N Char(4) Pos(57) Inz(x'FFFFFFFF');
    *N Int(10) Pos(61) Inz(0);
    *N Int(10) Pos(65) Inz(0);
    *N Int(10) Pos(69) Inz(84);
    *N Int(10) Pos(73) Inz(1);
    *N Int(10) Pos(77) Inz(88);
    *N Int(10) Pos(81) Inz(1);
    *N Int(10) Pos(85) Inz(0201);
    *N Char(1) Pos(89) Inz('*');
  End-Ds;
  Dcl-S UserSpaceDataPointer Pointer;
  Dcl-Ds UserSpaceHeader LikeDs(UserSpaceHeader_Ds) Based(UserSpaceDataPointer);
  Dcl-S UserSpaceEntryPointer Pointer;
  Dcl-Ds LJOB0100 Len(2000) Based(UserSpaceEntryPointer) Qualified;
    OffsetNextExtry Int(10) Pos(1);
    OffsetFieldsReturned Int(10) Pos(5);
    MessageId Char(7) Pos(17);
  End-Ds;
  Dcl-S FieldsPointer Pointer;
  Dcl-Ds Fields Len(2032) Based(FieldsPointer) Qualified;
    DataLength Int(10) Pos(29);
    Data Char(2000) Pos(33);
  End-Ds; 
  Dcl-S i Int(10);

  // Default: no error
  Error.BytesAvailable = 0;

  // Try to execute the command
  Monitor;
    qcmdexc(%Trim(Command): %Len(%Trim(Command)));
  On-Error;
    // Create user space
    UserSpaceName = CreateQualifiedTempFileName();
    CreateUserSpace(UserSpaceName: ErrorLocal);

    // List the last 10 job log messages 
    qmhljobl(UserSpaceName: 'LJOB0100': JSLT0100: %Size(JSLT0100): 'JSLT0100': ErrorLocal);
    If (ErrorLocal.BytesAvailable > 0); // Check error
      EscapeMessage(ErrorLocal);
      Return;
    EndIf;

    // Retrieve the user space pointer
    qusptrus(UserSpaceName: UserSpaceDataPointer: ErrorLocal);
    If (ErrorLocal.BytesAvailable > 0); // Check error
      EscapeMessage(ErrorLocal);
      Return;
    EndIf;

    // Init the first entry pointer
    UserSpaceEntryPointer = UserSpaceDataPointer + UserSpaceHeader.OffsetListData;

    If UserSpaceHeader.NumberOfEntries > 0;
      i = 1;     
      Dow i <= UserSpaceHeader.NumberOfEntries;

        If LJOB0100.MessageId <> 'CPF0006' And LJOB0100.MessageId <> 'CPF0001';
          FieldsPointer = UserSpaceDataPointer + LJOB0100.OffsetFieldsReturned;
          Error.ExceptionId = LJOB0100.MessageId;
          Error.ExceptionData = %Subst(Fields.Data: 1: Fields.DataLength);
          Error.BytesAvailable = 16 + Fields.DataLength;
          Leave;
        EndIf;

        // Next entry pointer
        UserSpaceEntryPointer = UserSpaceDataPointer + LJOB0100.OffsetNextExtry;
      EndDo;
    EndIf;

    If Error.BytesAvailable = 0;
      Error.ExceptionId = 'CPF0006';
      Error.BytesAvailable = 16;
    EndIf;

    // Delete user space
    DeleteUserSpace(UserSpaceName: ErrorLocal);
  EndMon;
End-Proc;

Dcl-Proc GetErrno Export;
  Dcl-Pi GetErrno Int(10);
  End-Pi;

  Dcl-Pr GetErrnoPtr Pointer ExtProc('__errno');
  End-Pr;
  Dcl-S ErrnoPtr Pointer;
  Dcl-S Errno Int(10) Based(ErrnoPtr);

  ErrnoPtr = GetErrnoPtr();

  return Errno;
End-Proc;

Dcl-Proc GetMessageText Export;
  Dcl-Pi GetMessageText Char(2000);
    MessageId Char(7) Const;
    Data Char(1) Const Options(*Varsize:*Nopass);
    DataLen Int(10) Const Options(*Nopass);
    MessageFile Char(20) Const Options(*Nopass);
  End-Pi;
  Dcl-Ds RTVM0100 Len(2024) Qualified;
    MessageLenRet Int(10) Pos(9);
    Message Char(2000) Pos(25);
  End-Ds;
  Dcl-Ds Error LikeDs(ERRC0100);
  Dcl-S Ret Char(2000) Inz(*Blanks);
  Dcl-S UsedData Char(65535) Inz('');
  Dcl-S UsedDataLen Int(10) Inz(0);
  Dcl-S UsedMessageFile Char(20) Inz('QCPFMSG   *LIBL');

  If (%Parms() >= 2);
    UsedData = Data;
    UsedDataLen = %Len(%Trim(UsedData));
  EndIf;
  If (%Parms() >= 3);
    UsedDataLen = DataLen;
  EndIf;
  If (%Parms() >= 4);
    UsedMessageFile = MessageFile;
  EndIf;

  qmhrtvm(RTVM0100: %Size(RTVM0100): 'RTVM0100': MessageId: UsedMessageFile: UsedData: UsedDataLen: '*YES': '*NO': Error);

  If (Error.BytesAvailable = 0);
    memcpy(%Addr(Ret): %Addr(RTVM0100.Message): RTVM0100.MessageLenRet);
  Else;
    Ret = '????';
  EndIf;

  Return Ret;

End-Proc;

Dcl-Proc HttpGetEnv Export;
  Dcl-Pi HttpGetEnv Char(8192);
    VariableName Char(128) Const Options(*Varsize);
  End-Pi;
  Dcl-Ds Error LikeDs(ERRC0100);
  Dcl-S Value Char(8192);
  Dcl-S ValueLen Int(10);

  qtmhgetenv(Value: 8192: ValueLen: VariableName: %Len(%Trim(VariableName)): Error);
  Value = %Subst(Value: 1: ValueLen);

  Return Value;
End-Proc;

Dcl-Proc HttpResponse Export;
  Dcl-Pi HttpResponse OpDesc;
    Buffer Char(2000) Const Options(*Varsize);
  End-Pi;

  Dcl-S p2 Int(10);
  Dcl-S p3 Int(10);
  Dcl-S p4 Int(10);
  Dcl-S p5 Int(10);
  Dcl-S l1 Int(10);
  Dcl-Ds Error LikeDs(ERRC0100);

  ceedod(1: p2: p3: p4: p5: l1);

  qtmhwrstout(Buffer: l1: Error);

End-Proc;

Dcl-Proc HttpRequestKey Export;
  Dcl-Pi HttpRequestKey Ind;
    RequestData Pointer Const;
    Key Char(128) Const Options(*Varsize);
  End-Pi;
  Dcl-S Ret Ind;
  Dcl-S n Char(128);
  Dcl-S Cnt Uns(10);
  Dcl-S Ptr Pointer;
  Dcl-S Val Pointer Inz(*Null);
  Dcl-S i Int(10);
  Dcl-S l Int(10);

  // Key to uppercase
  n = %Trim(Key) + x'00';
  n = Upper(n);
  memcpy(%Addr(Cnt): RequestData: 4);

  // Check all keys
  Ptr = RequestData + 4;
  For i = 1 To Cnt;
    // If the key was found
    If (strcmp(Ptr + 4: %Addr(n)) = 0);
      Return *On;
    EndIf;

    // Skip the value if exists
    Ptr = Ptr + 4 + strlen(Ptr + 4) + 1;
    memcpy(%Addr(l): Ptr: 4);
    If (l <> 0);
      Ptr = Ptr + 4 + l;
    EndIf;
  EndFor;

  // Not found
  Return *Off;
End-Proc;

Dcl-Proc HttpRequestLoad Export;
  Dcl-Pi HttpRequestLoad Pointer;
    AcceptedMethod Char(5) Const Options(*Nopass);
  End-Pi;
  Dcl-Pr HttpRequestParse Pointer ExtProc('HttpRequestParse');
    Buffer Pointer Value;
    BufferLen Int(10) Value;
  End-Pr;
  Dcl-S Ret Pointer Inz(*Null);
  Dcl-S Req Pointer;
  Dcl-S Ptr Pointer;
  Dcl-S Method Char(5);
  Dcl-S Len Int(10);
  Dcl-S ReqData Char(1) Based(Req);
  Dcl-S p Int(10);
  Dcl-S l Int(10);
  Dcl-Ds Error LikeDS(ERRC0100);

  // Get the request method
  Ptr = getenv('REQUEST_METHOD');
  If (Ptr <> *Null);
    Method = %Str(Ptr);
  Else;
    Return *Null;
  EndIf;

  // Check the accepted method
  If ((%Parms > 0) And (Method <> AcceptedMethod));
    Return *Null;
  Endif;

  // Get the request
  Select;
    When (Method = 'GET');
      Req = getenv('REQUEST_URI');
      Len = strlen(Req);
    When (Method = 'POST');
      Ptr = getenv('CONTENT_LENGTH');
      If (Ptr = *Null);
        Return *Null;
      Else;
        Len = atoi(Ptr);
        Req = %Alloc(Len + 1);
        qtmhrdstin(ReqData: Len + 1: l: Error);
        memset(Req + Len: 0: 1);
      EndIf;
  EndSl;

  Ret = HttpRequestParse(Req: Len);

  Return Ret;
End-Proc;

Dcl-Proc HttpRequestValue Export;
  Dcl-Pi HttpRequestValue Char(8192);
    RequestData Pointer Const;
    Key Char(128) Const Options(*Varsize);
  End-Pi;
  Dcl-S Ret Char(8192) Inz(*Blanks);
  Dcl-S n Char(128);
  Dcl-S Cnt Uns(10);
  Dcl-S Ptr Pointer;
  Dcl-S Val Pointer Inz(*Null);
  Dcl-S i Int(10);
  Dcl-S l Int(10);

  // Key to uppercase
  n = %Trim(Key) + x'00';
  n = Upper(n);
  memcpy(%Addr(Cnt): RequestData: 4);

  // Check all keys
  Ptr = RequestData + 4;
  For i = 1 To Cnt;
    // If the key was found
    If (strcmp(Ptr + 4: %Addr(n)) = 0);
      Val = Ptr + 4 + strlen(Ptr + 4) + 1 + 4;
      Leave;
    EndIf;

    // Skip the value if exists
    Ptr = Ptr + 4 + strlen(Ptr + 4) + 1;
    memcpy(%Addr(l): Ptr: 4);
    If (l <> 0);
      Ptr = Ptr + 4 + l;
    EndIf;
  EndFor;

  // If the key was found 
  If (Val <> *Null);
    memcpy(%Addr(Ret): Val: strlen(Val));
  EndIf;
  
  Return Ret;
End-Proc;

Dcl-Proc HttpTokenCheck Export;
  Dcl-Pi HttpTokenCheck Ind;
    Token Char(32) Const;
  End-Pi;

  Dcl-S FileName Char(128);

  FileName = '/tmp/token_' + %Trim(Token) + x'00';

  If (access(Filename: 4) = 0);
    Return *On;
  Else;
    Return *Off;
  EndIf;

End-Proc;

Dcl-Proc HttpTokenCreate Export;
  Dcl-Pi HttpTokenCreate Char(32);
    OldToken Char(32) Const Options(*Nopass);
  End-Pi;
  Dcl-S Old Char(32);
  Dcl-S New Char(32);
  Dcl-S FileName Char(128);
  Dcl-S File_io_new Int(10);
  Dcl-S File_io_old Int(10);
  Dcl-S Buffer Char(4000);
  Dcl-S l Int(10);

  // Check if there is old token to delete
  If (%Parms = 0);
    Old = *Blanks;
  Else;
    Old = OldToken;
  Endif;

  // Generate a token until a non existing token will be generated
  Dow (1 = 1);
    // Generate a new token
    New = HttpTokenGenerate();
    // When the generated token is not existing
    If (HttpTokenCheck(New) = *Off);
      Leave;
    EndIf;
  EndDo;

  // Create the new token file and open it
  FileName = '/tmp/token_' + New + x'00';
  File_io_new = open(FileName: O_CREAT + O_RDWR: S_IRUSR+S_IWUSR);

  // Check if create was successfull
  If (File_io_new < 0);
    Return *Blanks;
  EndIf;
  // If there is an old token
  If (Old <> *Blanks);
    // Open the old token file
    FileName = '/tmp/token_' + Old + x'00';
    File_io_old = open(FileName: O_RDONLY);
    // If open was successfull
    If (File_io_old >= 0);
      // Copy the content of the old token file into the new token file
      DoW (1 = 1);
        l = read(File_io_old: %Addr(Buffer): 4000);
        If (l > 0);
          l = write(File_io_new: %Addr(Buffer): l);
        EndIf;
        If (l <> 4000);
          Leave;
        EndIf;
      EndDo;
      // Close the old token file
      callp close(File_io_old);
    EndIf;
    // Delete the old token file
    unlink(FileName);
  EndIf;

  // Close the new token file
  callp close(File_io_new);

  Return New;
End-Proc;

Dcl-Proc HttpTokenDelete Export;
  Dcl-Pi HttpTokenDelete;
    Token Char(32);
  End-Pi;

  Dcl-S FileName Char(128);

  FileName = '/tmp/token_' + Token + x'00';
  unlink(FileName);
End-Proc;

Dcl-Proc HttpTokenGenerate Export;
  Dcl-Pi HttpTokenGenerate Char(32);
  End-Pi;
  Dcl-Ds JOBI0100 Len(86) Qualified;
    InternalJobId Char(16) Pos(35);
  End-Ds;
  Dcl-Ds Error LikeDs(ERRC0100);
  Dcl-S Ret Char(32);
  Dcl-S Key Char(16);
  Dcl-S KeyTemp Char(16);
  Dcl-S b1 Uns(3);
  Dcl-S b2 Uns(3);
  Dcl-S b3 Uns(3);
  Dcl-S b4 Uns(5);
  Dcl-S a1 Char(2);
  Dcl-S i Int(10);
  Dcl-S j Int(10);
  Dcl-S r Uns(10);
  Dcl-S TimeText Char(25);

  // Get the internal job id
  qusrjobi(JOBI0100: %Size(JOBI0100): 'JOBI0100': '*': '': Error);
  Key = JOBI0100.InternalJobId;

  // Get the current timestamp
  TimeText = %Char(%Timestamp());
  KeyTemp = %Subst(TimeText: 3: 2) + %Subst(TimeText: 6: 2) + %Subst(TimeText: 9: 2) +
    %Subst(TimeText: 12: 2) + %Subst(TimeText: 15: 2) + %Subst(TimeText: 18: 2) +
    %Subst(TimeText: 21: 4);    

  // Mix the two keys with random number, trying to get an unique key
  For j = 1 To 8;
    r = rand();
    For i = 1 To 2;
      b1 = MemVal(%Addr(Key) + 2 * (j-1) + (i-1));
      b2 = MemVal(%Addr(KeyTemp) + 2 * (j-1) + (i-1));
      b3 = %BitOr(b1: b2);
      memcpy(%Addr(Key) + (j-1) * 2 + (i - 1): %Addr(b3): 1);
      b1 = MemVal(%Addr(Key) + 2 * (j-1) + (i-1));
      b2 = MemVal(%Addr(r) + 2 + (i-1));
      b4 = b1 + b2;
      memcpy(%Addr(Key) + (j-1) * 2 + (i - 1): %Addr(b4) + 1: 1);
    EndFor;
  EndFor;

  // Convert the key to the hexadecial format
  Ret = *Blanks;
  For i = 1 To 16;
    b1 = MemVal(%Addr(Key) + i - 1);
    a1 = ConvertByteToHex(b1);
    Ret = %Trim(Ret) + a1;
  EndFor;

  Return Ret;
End-Proc;

Dcl-Proc HttpTokenGetData Export;
  Dcl-Pi HttpTokenGetData Char(8192);
    Token Char(32) Const;
    DataName Char(128) Const Options(*Varsize);
  End-Pi;
  Dcl-S FileName Char(128);
  Dcl-S File_io Int(10);
  Dcl-S Name2 Char(128);
  Dcl-S Value2 Char(8192);
  Dcl-S Found Ind Inz(*Off);
  Dcl-S i Int(10);
  Dcl-S Ret Char(8192) Inz(*Blanks);

  FileName = '/tmp/token_' + %Trim(Token) + x'00';

  // Open the token file
  File_io = open(FileName: O_RDWR);

  // When the file was found and opened
  If (File_io >= 0);
    // Read the file
    Dow (Found = *Off);
      // Read the name
      i = read(File_io: %Addr(Name2): 128);
      If (i = 0);
        Leave;
      EndIf;
      // Check read error
      If (i <> 128);
        Leave;
      EndIf;
      // Read the value
      i = read(File_io: %Addr(Value2): 8192);
      // Check read error
      If (i <> 8192);
        // Read error
        Ret = *Blanks;
      EndIf;
      // If the name was found
      If (%Trim(Name2) = %Trim(DataName));
        Found = *On;
        Ret = Value2;
      EndIf;
    EndDo;

    // Close the token file
    callp close(File_io);
  EndIf;

  Return Ret;

End-Proc;

Dcl-Proc HttpTokenSetData Export;
  Dcl-Pi HttpTokenSetData Ind;
    Token Char(32) Const;
    DataName Char(128) Const Options(*Varsize);
    DataValue Char(8192) Const Options(*Varsize);
  End-Pi;
  Dcl-S FileName Char(128);
  Dcl-S File_io Int(10);
  Dcl-S Name2 Char(128);
  Dcl-S Value2 Char(8192);
  Dcl-S Found Ind Inz(*Off);
  Dcl-S i Int(10);
  Dcl-S Ret Ind Inz(*On);

  FileName = '/tmp/token_' + %Trim(Token) + x'00';

  // Open the token file
  File_io = open(FileName: O_RDWR);

  // When the file was found and opened
  If (File_io >= 0);
    // Read the file
    Dow (Found = *Off);
      // Read the name
      i = read(File_io: %Addr(Name2): 128);
      If (i = 0);
        Leave;
      EndIf;
      // Check read error
      If (i <> 128);
        Ret = *Off;
        Leave;
      EndIf;
      // If the name was found
      If (%Trim(Name2) = %Trim(DataName));      
        Found = *On;
        // Write the value
        Value2 = DataValue;
        i = write(File_io: %Addr(Value2): 8192);
        // Check write error
        If (i <> 8192);
          // Write error
          Ret = *Off;
        EndIf;
      Else;
        // Read the value
        i = read(File_io: %Addr(Value2): 8192);
        // Check read error
        If (i <> 8192);
          Leave;
        EndIf;
      EndIf;
    EndDo;
    // If not found, append
    If ((Ret <> *Off) And (Found = *Off));
      // Write the name
      Name2 = DataName;
      i = write(File_io: %Addr(Name2): 128);
      // Check write error
      If (i = 128);
        // Write the value
        Value2 = DataValue;
        i = write(File_io: %Addr(Value2): 8192);
        // Check write error
        If (i <> 8192);
          // Write error
          Ret = *Off;
        EndIf;
      Else;
        // Write error
        Ret = *Off;
      EndIf;
    EndIf;
    // Close the token file
    callp close(File_io);
  Else;
    // File cannot be opened
    Ret = *Off;
  EndIf;

  Return Ret;

End-Proc;

Dcl-Proc InfoMessage Export;
  Dcl-Pi InfoMessage;
    Error LikeDs(ERRC0100) Const Options(*Omit);
    Text Char(240) Const Options(*Nopass:*Varsize);
  End-Pi;
  Dcl-C QCPFMSG 'QCPFMSG   *LIBL';
  Dcl-Ds LocalError LikeDs(ERRC0100);
  Dcl-S MessageText Char(240);
  
  // Check if only one parameter is passed 
  If (%parms < 2);
    // Use the Error parameter
    qmhsndpm(Error.ExceptionId: QCPFMSG: Error.ExceptionData: Error.BytesAvailable-16: '*INFO': '*PGMBDY': 1: '': LocalError);
  Else; // Use the Text parameter, the Error parameter should be omitted
    // Check if the Text ends with a dot (.)
    If (%Subst(Text: %Len(%Trim(Text)): 1) = '.');
      // Remove the trailing dot from the Text
      MessageText = %Subst(Text: 1: %Len(%Trim(Text))-1);
    Else;
      // Use the Text without changes
      MessageText = Text;
    EndIf;
    // Send the info message
    qmhsndpm('CPF9898': QCPFMSG: MessageText: %Len(%Trim(MessageText)): '*INFO': '*PGMBDY': 1: '': LocalError);
  EndIf;
End-Proc;


Dcl-Proc Lower Export;
  Dcl-Pi Lower Char(65535) OpDesc;
    Text Char(65535) Const Options(*Varsize);
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

  Ret = Text;

  // Go through the text
  For i = 1 To l1;
    // Get the character
    ch = MemVal(%Addr(Ret) + i - 1);
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

Dcl-Proc RetrieveDataArea Export;
  Dcl-Pi RetrieveDataArea Char(2000);
    QualifiedDataAreaName Char(20) Const;
    Start Int(10) Const;
    Length Int(10) Const;   
    Error LikeDs(ERRC0100);
  End-Pi;
  Dcl-Ds DataArea Len(2036) Qualified;
    Value Char(2000) Pos(37);
  End-Ds;

  qwcrdtaa(DataArea: %Size(DataArea): QualifiedDataAreaName: -1: 2000: Error);
  If (Error.BytesAvailable = 0); // Check error
    Return %Subst(DataArea.Value: Start: Length);
  Else;
    Return *Blanks;
  EndIf;
End-Proc;

Dcl-Proc Upper Export;
  Dcl-Pi Upper Char(65535) OpDesc;
    Text Char(65535) Const Options(*Varsize);
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

  Ret = Text;

  // Go through the text
  For i = 1 To l1;
    // Get the character
    ch = MemVal(%Addr(Ret) + i - 1);
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
