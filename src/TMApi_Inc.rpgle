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
  ExceptionId Char(7) Pos(40);
  ExceptionText Char(80) Pos(91);
End-Ds;

// Format ERRC0100 for the error code parameter
Dcl-Ds ERRC0100 Qualified Template;
  BytesProvided Int(10) Inz(%Size(ERRC0100));
  BytesAvailable Int(10);
  ExceptionId Char(7);
  *N Char(1);
  ExceptionData Char(240);
End-Ds;

// Generic user space header format 0100
Dcl-Ds UserSpaceHeader_Ds Len(192) Qualified Template;
  OffsetListData Int(10) Pos(125);
  NumberOfEntries Int(10) Pos(133);
  SizeOfEntry Int(10) Pos(137);
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
Dcl-Pr getenv Pointer Extproc('getenv');
  Name Pointer Value Options(*String);
End-Pr;

// Prototype to C "lseek" function
Dcl-Pr lseek Int(10) ExtProc('lseek');
  FileDescriptor Int(10) Value;
  Offset Int(10) Value;
  Whence Int(10) Value;
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
Dcl-Pr open Int(10) Extproc('open');
  FileName Pointer Value Options(*String);
  Flags Int(10) Value;
  Mode Uns(10) Value Options(*Nopass);
  CodePage Uns(10) Value Options(*Nopass);
End-Pr;  

// Execute Command (QCMDEXC) API
Dcl-Pr qcmdexc ExtPgm('QCMDEXC');
  Command Char(1) Const Options(*Varsize);
  CommandLength Packed(15:5) Const;
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

Dcl-Pr qtmhrdstin ExtProc('QtmhRdStin');
  Buffer Char(1) Const Options(*Varsize);
  BufferLen Uns(10) Const;
  BytesReaded Uns(10) Value;
  Error LikeDs(ERRC0100) Const;
End-Pr;

Dcl-Pr qtmhwrstdout ExtProc('QtmhWrStout');
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

Dcl-Pr qusrjobi ExtPgm('QUSRJOBI');
  Receiver Char(1) Const Options(*Varsize);
  ReceiverLen Int(10) Const;
  FormatName Char(8) Const;
  QualifiedJobName Char(26) Const;
  InternalJobId Char(16) Const;
  Error LikeDs(ERRC0100) Options(*Nopass);
End-Pr;

// Retrieve Job Description Information (QWDRJOBD) API
Dcl-Pr qwdrjobd ExtPgm('QWDRJOBD');
  Receiver Char(1) Options(*Varsize);
  ReceiverLength Int(10) Const;
  FormatName Char(8) Const;
  QualifiedJobDescriptionName Char(20) Const;
  Error LikeDs(ERRC0100) Options(*Nopass);
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

// Prototype to C "strcmp" function
Dcl-Pr strcmp Int(10) ExtProc('strcmp');
  Text1 Pointer Value;
  Text2 Pointer Value;
End-Pr;

// Prototype to C "strlen" function
Dcl-Pr strlen Uns(10) ExtProc('strlen');
  Text Pointer Value;
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

