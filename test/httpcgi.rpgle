**Free

//
// Login:
//   GET <url>/httpcgi?cmd=001&user=TEST&password=TEST
// Logout:
//   GET <url>/httpcgi?cmd=002&token=<token>
// Other functions:
//   GET <url>/httpcgi?cmd=003&token=<token>...
// 

Ctl-Opt DftActGrp(*No) Main(MainProc) BndDir('TMLIB_M');

/include ../src/TMApi_Inc.rpgle
/include ../src/TMLib_Inc.rpgle

Dcl-S RequestData Pointer;

Dcl-Proc MainProc;
  Dcl-S Cmd Char(3);

  // Load the request data
  RequestData = HttpRequestLoad();
  If (RequestData = *Null);
    // Header with Status Error
    Header('500');
    Return;
  Else;
    // Header with Status Ok
    Header('200');  
    
    // Check the command
    Cmd = HttpRequestValue(RequestData: 'cmd');

    // Process the command
    Select;
      When (Cmd = '001'); // Login
        Cmd001();
      When (Cmd = '002'); // Logout
        Cmd002();
      When (Cmd = '003'); // Function 1
        Cmd003();
      // Other functions
      Other;
        HttpResponse('<text>Bad command</text>');
    EndSl;
  EndIf;

  HttpResponse('</Response>' + CHAR_CR + CHAR_LF);

End-Proc;

Dcl-Proc Header;
  Dcl-Pi Header;
    Status Char(3) Const;
  End-Pi;

  HttpResponse('Status: ' + Status + CHAR_CR + CHAR_LF);
  HttpResponse('X-Powered-By: IBMi' + CHAR_CR + CHAR_LF);
  HttpResponse('Content-Type: text/xml' + CHAR_CR + CHAR_LF);
  HttpResponse('Content-Disposition: attachment; filename=httpcgi.xml' + CHAR_CR + CHAR_LF + CHAR_CR + CHAR_LF);

  HttpResponse('<?xml version="1.0" encoding="UTF-8"?>' + CHAR_CR + CHAR_LF);
  HttpResponse('<Response>' + CHAR_CR + CHAR_LF);

End-Proc;

Dcl-Proc Cmd001;
  Dcl-S User Char(16);
  Dcl-S Password Char(16);
  Dcl-S Token Char(32);
  Dcl-S Ok Ind Inz(*Off);
  Dcl-S Text Char(10);

  // Get the request keys
  User = HttpRequestValue(RequestData: 'user');
  Password = HttpRequestValue(RequestData: 'password');

  Text = HttpRequestValue(RequestData: 'text');
  HttpResponse('Text = :' + Text + ':');

  // Check user + password - simple example
  If ((%Trim(User) = 'TEST') And (%Trim(Password) = 'TEST'));
    Ok = *On;
  EndIf;

  If (Ok = *On);
    // Login was successfull
    HttpResponse('<text>Login was successfull</text>');
    // Create a token for the next command
    Token = HttpTokenCreate();
    HttpResponse('<token>' + Token + '</token>');
    // Save the logged in user name as token data to be useable for the next commands
    Ok = HttpTokenSetData(Token: 'user': User);
    If (Ok = *Off);
      HttpResponse('<tokendata>Token data was not saved</tokendata>');
    EndIf;
  Else;
    // Login was not successfull
    HttpResponse('<text>Login was not successfull</text>');
  EndIf;

End-Proc;

Dcl-Proc Cmd002;
  Dcl-S Token Char(32);

  // Get the request keys
  Token = HttpRequestValue(RequestData: 'token');

  // Delete the token
  HttpTokenDelete(Token);

  HttpResponse('<text>Logout was successfull</text>');

End-Proc;

Dcl-Proc Cmd003;
  Dcl-S Token Char(32);
  Dcl-S User Char(16);

  // Get the request keys
  Token = HttpRequestValue(RequestData: 'token');
  // Check the token
  If (HttpTokenCheck(Token) = *On);
    // Token is ok, create a new token for the next command
    Token = HttpTokenCreate(Token);
    HttpResponse('<token>' + Token + '</token>');
    
    // Example: get token data
    User = HttpTokenGetData(Token: 'user');
    HttpResponse('<tokendata>Token data (user) = ' + %Trim(User) + '</tokendata>');

    // Any other function

  Else;
    // Wrong or missing token
    HttpResponse('<text>Wrong token</text>');
  EndIf;

End-Proc;
