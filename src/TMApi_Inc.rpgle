**Free

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

// Retrieve Operational Descriptor Information (CEEDOD) API
Dcl-Pr ceedod ExtProc('CEEDOD');
  posn Int(10) Const;
  desctype Int(10);
  datatype Int(10);
  descinf1 Int(10);
  descinf2 Int(10);
  daalen Int(10);
End-Pr;

// Prototype to C "memcpy" function
Dcl-Pr memcpy Pointer ExtProc('memcpy');
  Source Pointer Value;
  Destination Pointer Value;
  Count Uns(10) Value;
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

// Retrieve Job Description Information (QWDRJOBD) API
Dcl-Pr qwdrjobd ExtPgm('QWDRJOBD');
  Receiver Char(1) Options(*Varsize);
  ReceiverLength Int(10) Const;
  FormatName Char(8) Const;
  QualifiedJobDescriptionName Char(20) Const;
  Error LikeDs(ERRC0100) Options(*Nopass);
End-Pr;

// Prototype to C "tolower" function
Dcl-Pr tolower Uns(3) ExtProc('tolower');
  Ch Uns(3) Value; 
End-Pr;

// Prototype to C "toupper" function
Dcl-Pr toupper Uns(3) ExtProc('toupper');
  Ch Uns(3) Value; 
End-Pr;
