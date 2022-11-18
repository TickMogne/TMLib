**Free

Dcl-C CHAR_CR x'0D'; // carriage return
Dcl-C CHAR_LF x'25'; // line feed
Dcl-C CHAR_NL x'15'; // new line

// Flags for the function open
Dcl-C O_RDONLY  1;
Dcl-C O_WRONLY  2;
Dcl-C O_RDWR    4;
Dcl-C O_CREAT   8;
Dcl-C O_CCSID   32;
Dcl-C O_TRUNC   64;

// Modes for the function open
Dcl-C S_IRUSR   256;
Dcl-C S_IWUSR   128;
Dcl-C S_IXUSR   64;
Dcl-C S_IRGRP   32;
Dcl-C S_IWGRP   16;
Dcl-C S_IXGRP   8;
Dcl-C S_IROTH   4;
Dcl-C S_IWOTH   2;
Dcl-C S_IXOTH   1;

// Whence values for the function lseek
Dcl-C SEEK_SET  0;
Dcl-C SEEK_CUR  1;
Dcl-C SEEK_END  2;

// Program status data structure
Dcl-Ds ProgramStatus Psds Qualified;
  Proc Char(10) Pos(1);
  ExceptionId Char(7) Pos(40);
  ProgramLibrary Char(10) Pos(81);
  ExceptionText Char(80) Pos(91);
  Job Char(26) Pos(244);
  JobName Char(10) Pos(244);
  JobUser Char(10) Pos(254);
  JobNumber Char(6) Pos(264);
  CurrentUser Char(10) Pos(358);
  SystemName Char(8) Pos(396); // started with 7.3
End-Ds;

// Format ERRC0100 for the error code parameter
Dcl-Ds ERRC0100 Qualified Template;
  BytesProvided Int(10) Inz(%Size(ERRC0100));
  BytesAvailable Int(10);
  ExceptionId Char(7);
  *N Char(1);
  ExceptionData Char(240);
End-Ds;

// Open list information format
Dcl-Ds ListInformation_Ds Len(80) Qualified Template;
  TotalRecords Int(10) Pos(1);
  RecordsReturned Int(10) Pos(5);
  Handle Char(4) Pos(9);
  RecordLength Int(10) Pos(13);
End-Ds;

// Trigger buffer sections
Dcl-Ds TriggerBufferHeader_Ds Len(96) Qualified Template;
  PhysicalFileName Char(10) Pos(1);
  PhysicalFileLibrarName Char(10) Pos(11);
  PhysicalFileMemberName Char(10) Pos(21);
  TriggerEvent Char(1) Pos(31);
  TriggerTime Char(1) Pos(32);
  // ...
  RelativeRecordNumber Int(10) Pos(41);
  OriginalRecordOffset Int(10) Pos(49);
  OriginalRecordLength Int(10) Pos(53);
  OriginalRecordNullByteMapOffset Int(10) Pos(57);
  OriginalRecordNullByteMapLength Int(10) Pos(61);
  NewRecordOffset Int(10) Pos(65);
  NewRecordLength Int(10) Pos(69);
  NewRecordNullByteMapOffset Int(10) Pos(73);
  NewRecordNullByteMapLength Int(10) Pos(77);
End-Ds;

// Generic user space header format 0100
Dcl-Ds UserSpaceHeader_Ds Len(192) Qualified Template;
  OffsetListData Int(10) Pos(125);
  NumberOfEntries Int(10) Pos(133);
  SizeOfEntry Int(10) Pos(137);
End-Ds;

// Prototype to C "dirent" struct
Dcl-Ds Dirent_Ds Qualified Template;
  *N Char(16);
  FileNumberGenerationId Int(10);
  FileNumber Int(10);
  DirentLength Int(10);
  *N Int(10);
  *N Char(8);
  NlsInformation Char(12);
  NameLength Int(10);
  Name Char(256);
End-Ds;

// Prototype to C "stat" struct
Dcl-Ds Stat_Ds Qualified Template;
  *N Int(10);
  *N Int(10);
  *N Int(5);
  *N Char(2);
  UserId Int(10);
  GroupId Int(10);
  Size Int(10);
  AccessedTime Int(10);
  ModifiedTime Int(10);
  ChangedTime Int(10);
  *N Int(10);
  *N Int(10);
  *N Int(10);
  ObjectType Char(12);
  CodePage Int(5);
  *N Char(62);
  *N Int(10);
End-Ds;

// Prototype to C "tm" struct
Dcl-Ds Tm_Ds Qualified Template;
  Sec Int(10);
  Min Int(10);
  Hour Int(10);
  MDay Int(10);
  Mon Int(10);
  Year Int(10);
  WDay Int(10);
  YDay Int(10);
  IsDst Int(10);
End-Ds;

// Prototype to C "access" function
Dcl-Pr access Int(10) ExtProc('access');
  FileName Pointer Value Options(*String);
  Mode Int(10) Value;
End-Pr;

// Prototype to C "atoi" function
Dcl-Pr atoi Int(10) Extproc('atoi');
  Text Pointer Value Options(*String);
End-Pr;

// Retrieve Operational Descriptor Information (CEEDOD) API
Dcl-Pr ceedod ExtProc('CEEDOD');
  posn Int(10) Const;
  desctype Int(10);
  datatype Int(10);
  descinf1 Int(10);
  descinf2 Int(10);
  daalen Int(10);
End-Pr;

// Prototype to C "close" function
Dcl-Pr close ExtProc('close');
  FileDescriptor Int(10) Value;
End-Pr;

// Prototype to C "closedir" function
Dcl-Pr closedir Int(10) ExtProc('closedir');
  Dir Pointer Value;
End-Pr;

// Prototype to C "fclose" function
Dcl-Pr fclose ExtProc('_C_IFS_fclose');
  File Pointer Value;
End-Pr;

// Prototype to C "feof" function
Dcl-Pr feof Int(10) Extproc('_C_IFS_feof');
  File Pointer Value;
End-Pr;

// Prototype to C "fgets" function
Dcl-Pr fgets Pointer ExtProc('_C_IFS_fgets');
  Buffer Pointer Value;
  BufferLen Uns(10) Value;
  File Pointer Value;
End-Pr;

// Prototype to C "fopen" function
Dcl-Pr fopen Pointer Extproc('_C_IFS_fopen');
  Filename Pointer Value Options(*String);
  Mode Pointer Value Options(*String);
End-Pr;

// Prototype to C "fputs" function
Dcl-Pr fputs Int(10) ExtProc('_C_IFS_fputs');
  Buffer Pointer Value Options(*String);
  File Pointer Value;
End-Pr;

// Prototype to C "fread" function
Dcl-Pr fread Int(10) ExtProc('_C_IFS_fread');
  Buffer Pointer Value;
  BufferLen Uns(10) Value;
  Count Uns(10) Value;
  File Pointer Value;
End-Pr;

// Prototype to C "fwrite" function
Dcl-Pr fwrite Int(10) ExtProc('_C_IFS_fwrite');
  Buffer Pointer Value;
  BufferLen Uns(10) Value;
  Count Uns(10) Value;
  File Pointer Value;
End-Pr;

// Prototype to C "getenv" function
Dcl-Pr getenv Pointer ExtProc('getenv');
  Name Pointer Value Options(*String);
End-Pr;

// Prototype to C "localtime" function
Dcl-Pr localtime Pointer ExtProc('localtime');
  TimeValue Pointer Value;
End-Pr;

// Prototype to C "lseek" function
Dcl-Pr lseek Int(10) ExtProc('lseek');
  FileDescriptor Int(10) Value;
  Offset Int(10) Value;
  Whence Int(10) Value;
End-Pr;

// Prototype to C "memcmp" function
Dcl-Pr memcmp Int(10) ExtProc('memcmp');
  Buffer1 Pointer Value;
  Buffer2 Pointer Value;
  Count Uns(10) Value;
End-Pr;

// Prototype to C "memcpy" function
Dcl-Pr memcpy Pointer ExtProc('memcpy');
  Source Pointer Value;
  Destination Pointer Value;
  Count Uns(10) Value;
End-Pr;

// Prototype to C "memset" function
Dcl-Pr memset Pointer ExtProc('memset');
  Destination Pointer Value;
  Dcl-Parm Value Uns(3) Value;
  Count Uns(10) Value;
End-Pr;

// Prototype to C "open" function
Dcl-Pr open Int(10) ExtProc('open');
  FileName Pointer Value Options(*String);
  Flags Int(10) Value;
  Mode Uns(10) Value Options(*Nopass);
  CodePage Uns(10) Value Options(*Nopass);
End-Pr;

// Prototype to C "opendir" function
Dcl-Pr opendir Pointer ExtProc('opendir');
  DirName Pointer Value Options(*String);
End-Pr;

// Execute Command (QCMDEXC) API
Dcl-Pr qcmdexc ExtPgm('QCMDEXC');
  Command Char(65535) Const Options(*Varsize);
  CommandLength Packed(15:5) Const;
End-Pr;

// List Database Relations (QDBLDBR) API
Dcl-Pr qdbldbr ExtPgm('QDBLDBR');
  QualifiedUserSpaceName Char(20) Const;
  FormatName Char(8) Const;
  QualifiedFileName Char(20) Const;
  Member Char(10) Const;
  RecordFormat Char(10) Const;
  Error LikeDs(ERRC0100);
End-Pr;

// Retrieve Database File Description (QDBRTVFD) API
Dcl-Pr qdbrtvfd ExtPgm('QDBRTVFD');
  Receiver Char(1) Const Options(*Varsize);
  ReceiverLength Int(10) Const;
  QualifiedRetFileName Char(20) Const;
  FormatName Char(8) Const;
  QualifiedFileName Char(20) Const;
  RecordFormat Char(10) Const;
  Override Char(1) Const;
  System Char(10) Const;
  FormatType Char(10) Const;
  Error LikeDs(ERRC0100);
End-Pr;

// Close List (QGYCLST) API
Dcl-Pr qgyclst ExtPgm('QGYCLST');
  Handle Char(4) Const;
  Error LikeDs(ERRC0100);  
End-Pr;

// Get List Entries (QGYGTLE) API
Dcl-Pr qgygtle ExtPgm('QGYGTLE');
  Receiver Char(1) Const Options(*Varsize);
  ReceiverLength Int(10) Const;
  RequestHandle Char(4) Const;
  ListInformation LikeDs(ListInformation_Ds);
  NumberOfRecordsToReturn Int(10) Const;
  StartingRecord Int(10) Const;
  Error LikeDs(ERRC0100);  
End-Pr;

// Open List of Messages (QGYOLMSG) API
Dcl-Pr qgyolmsg ExtPgm('QGYOLMSG');
  Receiver Char(1) Options(*Varsize);
  ReceiverLength Int(10) Const;
  ListInformation LikeDs(ListInformation_Ds);
  NumberOfRecordsToReturn Int(10) Const;
  SortInformation Char(1) Const;
  SelectionInformation Char(8000) Options(*Varsize) Const;
  SizeOfSelectionInformation Int(10) Const;
  QueueInformation Char(21) Const;
  MessageQueuesUsed Char(44);
  Error LikeDs(ERRC0100); 
End-Pr;

// Retrieve Journal Information (QjoRetrieveJournalInformation) API
Dcl-Pr QjoRetrieveJournalInformation ExtProc('QjoRetrieveJournalInformation');
  Receiver Char(1) Const Options(*Varsize);
  ReceiverLength Int(10) Const;
  QualifiedJournalName Char(20) Const;
  FormatName Char(8) Const;
  InformationToRetrieve Char(1) Const Options(*Varsize);
  Error LikeDs(ERRC0100);
End-Pr;

// Open List of History Log Messages (QMHOLHST) API
Dcl-Pr qmholhst ExtPgm('QMHOLHST');
  Receiver Char(1) Const Options(*Varsize);
  ReceiverLength Int(10) Const;
  FormatName Char(8) Const;
  ListInformation LikeDs(ListInformation_Ds);
  NumberOfRecordsToReturn Int(10) Const;
  SelectionInformation Char(65535) Const;
  CCSID Int(10) Const;
  TimeZone Char(10) Const;
  Error LikeDs(ERRC0100);
End-Pr;

// Retrieve Message (QMHRTVM) API
Dcl-Pr qmhrtvm ExtPgm('QMHRTVM');
  Information Char(1) Const Options(*Varsize);
  InformationLen Int(10) Const;
  FormatName Char(8) Const;
  MessageId Char(7) Const;
  QualifiedMessageFileName Char(20) Const;
  Data Char(1) Const Options(*Varsize);
  DataLen Int(10) Const;
  Replace Char(10) Const;
  Control Char(10) Const;
  Error LikeDs(ERRC0100);
  RetrieveOption Char(10) Const Options(*Nopass);
  CCSIDToConvert Int(10) Const Options(*Nopass);
  CCSIDOfReplacementData Int(10) Const Options(*Nopass);
End-Pr;

// Send Program Message (QMHSNDPM) API
Dcl-Pr qmhsndpm ExtPgm('QMHSNDPM');
  MessageId Char(7) Const;
  QualifiedMessageFileName Char(20) Const;
  MessageData Char(240) Const;
  MessageDataLength Int(10) Const;
  MessageType Char(10) Const;
  CallStackEntry Char(10) Const;
  CallStackCounter Int(10) Const;
  MessageKey Char(4) Const;
  Error LikeDs(ERRC0100);
End-Pr;

// Prototype to C "Qp0lGetAttr" function
Dcl-Pr qp0lgetattr Int(10) ExtProc('Qp0lGetAttr');
  PathName Pointer Value;
  AttrArray Pointer Value;
  Buffer Pointer Value;
  BufferSizeProvided Uns(10) Value;
  BufferSizeNeeded Pointer Value;
  BufferBytesReturned Pointer Value;
  FollowSymlink Uns(10) Value;
End-Pr;

// Prototype to C "strcmp" function
Dcl-Pr qsort ExtProc('qsort');
  Base Pointer Value;
  ItemCount Int(10) Value;
  ItemSize Int(10) Value;
  CompareProc Pointer(*Proc) Value;
End-Pr;

// Retrieve Output Queue Information (QSPROUTQ) API
Dcl-Pr qsproutq ExtPgm('QSPROUTQ');
  Receiver Char(1) Const Options(*Varsize);
  ReceiverLen Int(10) Const;
  FormatName Char(8) Const;
  QualifiedOutputQueueName Char(20) Const;
  Error LikeDs(ERRC0100) Options(*Nopass);
End-Pr;

// Retrieve User Authority to Object (QSYRUSRA) API
Dcl-Pr qsyrusra ExtPgm('QSYRUSRA');
  Receiver Char(1) Const Options(*Varsize);
  ReceiverLen Int(10) Const;
  FormatName Char(8) Const;
  UserName Char(10) Const;
  QualifiedObjectName Char(20) Const;
  ObjectType Char(10) Const;
  Error LikeDs(ERRC0100) Options(*Nopass);
End-Pr;

// Get Environment Variable (QtmhGetEnv) API
Dcl-Pr qtmhgetenv ExtProc('QtmhGetEnv');
  Receiver Char(1) Const Options(*Varsize);
  ReceiverLen Int(10) Const;
  ReceiverLenRet Int(10) Const;
  VariableName Char(128) Const Options(*Varsize);
  VariableNameLen Int(10) Const;
  Error LikeDs(ERRC0100) Options(*Nopass);
End-Pr;

// Read from Stdin (QtmhRdStin) API
Dcl-Pr qtmhrdstin ExtProc('QtmhRdStin');
  Buffer Char(1) Const Options(*Varsize);
  BufferLen Uns(10) Const;
  BytesReaded Uns(10) Value;
  Error LikeDs(ERRC0100) Const;
End-Pr;

// Write to Stdout (QtmhWrStout) API
Dcl-Pr qtmhwrstout ExtProc('QtmhWrStout');
  Buffer Char(1) Const Options(*Varsize);
  BufferLen Uns(10) Const;
  Error LikeDs(ERRC0100) Const;
End-Pr;

// Create User Space (QUSCRTUS) API
Dcl-Pr quscrtus ExtPgm('QUSCRTUS');
  QualifiedUserSpaceName Char(20) Const;
  ExtendedAttribute Char(10) Const;
  InitialSize Int(10) Const;
  InitialValue Char(1) Const;
  PublicAuthority Char(10) Const;
  TextDescription Char(50) Const;
  Replace Char(10) Options(*Nopass) Const;
  Error LikeDs(ERRC0100) Options(*Nopass);
End-Pr;

// Delete User Space (QUSDLTUS) API
Dcl-Pr qusdltus ExtPgm('QUSDLTUS');
  QualifiedUserSpaceName Char(20) Const;
  Error LikeDs(ERRC0100);
End-Pr;

// List Database File Members (QUSLMBR) API
Dcl-Pr quslmbr ExtPgm('QUSLMBR');
  QualifiedUserSpaceName Char(20) Const;
  FormatName Char(8) Const;
  QualifiedFileName Char(20) Const;
  Member Char(10) Const;
  Override Char(1) Const;
  Error LikeDs(ERRC0100);  
End-Pr;

// List Job (QUSLJOB) API
Dcl-Pr qusljob ExtPgm('QUSLJOB');
  QualifiedUserSpaceName Char(20) Const;
  FormatName Char(8) Const;
  QualifiedJobName Char(26) Const;
  Status Char(10) Const;
  Error LikeDs(ERRC0100);  
  JobType Char(1) Const Options(*NoPass);
  NumberOfFields Int(10) Const Options(*NoPass);
  KeysOfFields Char(4) Const Options(*NoPass:*Varsize);
End-Pr;

// List Objects (QUSLOBJ) API
Dcl-Pr quslobj ExtPgm('QUSLOBJ');
  QualifiedUserSpaceName Char(20) Const;
  FormatName Char(8) Const;
  ObjectNameAndLibrary Char(20) Const;
  ObjectType Char(10) Const;
  Error LikeDs(ERRC0100) Options(*Nopass);  
End-Pr;

// Retrieve Pointer to User Space (QUSPTRUS) API
Dcl-Pr qusptrus ExtPgm('QUSPTRUS');
  QualifiedUserSpaceName Char(20) Const;
  DataPointer Pointer;
  Error LikeDs(ERRC0100) Options(*Nopass);  
End-Pr;

// Retrieve Job Information (QUSRJOBI) API
Dcl-Pr qusrjobi ExtPgm('QUSRJOBI');
  Receiver Char(1) Const Options(*Varsize);
  ReceiverLen Int(10) Const;
  FormatName Char(8) Const;
  QualifiedJobName Char(26) Const;
  InternalJobId Char(16) Const;
  Error LikeDs(ERRC0100) Options(*Nopass);
End-Pr;

// Retrieve Object Description (QUSROBJD) API
Dcl-Pr qusrobjd ExtPgm('QUSROBJD');
  Receiver Char(1) Const Options(*Varsize);
  ReceiverLen Int(10) Const;
  FormatName Char(8) Const;
  QualifiedObjectName Char(26) Const;
  ObjectType Char(10) Const;
  Error LikeDs(ERRC0100) Options(*Nopass);
End-Pr;

// List Active Subsystems (QWCLASBS) API
Dcl-Pr qwclasbs ExtPgm('QWCLASBS');
  QualifiedUserSpaceName Char(20) Const;
  FormatName Char(8) Const;
  Error LikeDs(ERRC0100) Options(*Nopass);
End-Pr;

// Retrieve Network Attributes (QWCRNETA) API
Dcl-Pr qwcrneta ExtPgm('QWCRNETA');
  Receiver Char(1) Options(*Varsize);
  ReceiverLength Int(10) Const;
  NumberOfAttributes Int(10) Const;
  ArrayOfAttributes Char(2000) Const Options(*Varsize);
  Error LikeDs(ERRC0100);
End-Pr;

// Retrieve System Status (QWCRSSTS) API
Dcl-Pr qwcrssts ExtPgm('QWCRSSTS');
  Receiver Char(1) Options(*Varsize);
  ReceiverLength Int(10) Const;
  FormatName Char(8) Const;
  ResetStatusStatistic Char(10) Const;
  Error LikeDs(ERRC0100) Options(*Nopass);
End-Pr;

// Retrieve System Values (QWCRSVAL) API
Dcl-Pr qwcrsval ExtPgm('QWCRSVAL');
  Receiver Char(1) Options(*Varsize);
  ReceiverLength Int(10) Const;
  NumberOfSystemValues Int(10) Const;
  ArrayOfSystemValues Char(2000) Const Options(*Varsize);
  Error LikeDs(ERRC0100);
End-Pr;

// Retrieve Job Description Information (QWDRJOBD) API
Dcl-Pr qwdrjobd ExtPgm('QWDRJOBD');
  Receiver Char(1) Options(*Varsize);
  ReceiverLength Int(10) Const;
  FormatName Char(8) Const;
  QualifiedJobDescriptionName Char(20) Const;
  Error LikeDs(ERRC0100) Options(*Nopass);
End-Pr;

// Retrieve Subsystem Information (QWDRSBSD) API
Dcl-Pr qwdrsbsd ExtPgm('QWDRSBSD');
  Receiver Char(1) Options(*Varsize);
  ReceiverLength Int(10) Const;
  FormatName Char(8) Const;
  QualifiedSubsystemName Char(2000) Options(*Varsize) Const;
  Error LikeDs(ERRC0100);
  NumberOfQualifiedSubsystemName Int(10) Options(*Nopass);
End-Pr;

// Retrieve Call Stack (QWVRCSTK) API
Dcl-Pr qwvrcstk ExtPgm('QWVRCSTK');
  Receiver Char(1) Options(*Varsize);
  ReceiverLength Int(10) Const;
  FormatName Char(8) Const;
  JobIdInfo Char(1) Options(*Varsize);
  JobIdInfoFormatName Char(8) Const;
  Error LikeDs(ERRC0100);
End-Pr;

// Change Server Information (QZLSCHSI) API
Dcl-Pr qzlschsi ExtPgm('QZLSCHSI');
  RequestVariable Char(1) Options(*Varsize) Const;
  RequestVariableLength Int(10) Const;
  FormatName Char(8) Const;
  Error LikeDs(ERRC0100);
End-Pr;

// List Server Information (QZLSLSTI) API
Dcl-Pr qzlslsti ExtPgm('QZLSLSTI');
  QualifiedUserSpaceName Char(20) Const;
  FormatName Char(8) Const;
  InformationQualifier Char(15) Const;
  Error LikeDs(ERRC0100);
End-Pr;

// Prototype to C "rand" function
Dcl-Pr rand Uns(10) Extproc('rand');
End-Pr;

// Prototype to C "read" function
Dcl-Pr read Int(10) Extproc('read');
  FileDescriptor Int(10) Value;
  Buffer Pointer Value;
  Lenght Uns(10) Value;
End-Pr;

// Prototype to C "readdir" function
Dcl-Pr readdir Pointer ExtProc('readdir');
  Dir Pointer Value;
End-Pr;

// Prototype to C "stat" function
Dcl-Pr stat Int(10) ExtProc('stat');
  Path Pointer Value Options(*String);
  Buffer Pointer Value;
End-Pr;

// Prototype to C "strcmp" function
Dcl-Pr strcmp Int(10) ExtProc('strcmp');
  Text1 Pointer Value;
  Text2 Pointer Value;
End-Pr;

// Prototype to C "strftime" function
Dcl-Pr strftime Int(10) ExtProc('strftime');
  Buffer Pointer Value Options(*String);
  BufferLength Int(10) Value;
  Format Pointer Value Options(*String);
  Tm Pointer Value;
End-Pr;

// Prototype to C "strlen" function
Dcl-Pr strlen Uns(10) ExtProc('strlen');
  Text Pointer Value;
End-Pr;

// Prototype to C "strstr" function
Dcl-Pr strstr Pointer ExtProc('strstr');
  Text1 Pointer Value;
  Text2 Pointer Value;
End-Pr;

// Prototype to C "tolower" function
Dcl-Pr tolower Uns(3) ExtProc('tolower');
  Ch Uns(3) Value; 
End-Pr;

// Prototype to C "toupper" function
Dcl-Pr toupper Uns(3) ExtProc('toupper');
  Ch Uns(3) Value; 
End-Pr;

// Prototype to C "unlink" function
Dcl-Pr unlink ExtProc('unlink');
  FileName Pointer Value Options(*String);
End-Pr;

// Prototype to C "write" function
Dcl-Pr write Int(10) Extproc('write');
  FileDescriptor Int(10) Value;
  Buffer Pointer Value;
  Lenght Uns(10) Value;
End-Pr;

