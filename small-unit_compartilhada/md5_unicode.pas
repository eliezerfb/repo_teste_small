unit md5_unicode;

{$WARNINGS OFF}

// -----------------------------------------------------------------------------------------------
INTERFACE
// -----------------------------------------------------------------------------------------------

uses
 Windows,Dialogs;

type
 MD5Count = array[0..1] of DWORD;
 MD5State = array[0..3] of DWORD;
 MD5Block = array[0..15] of DWORD;
 MD5CBits = array[0..7] of byte;
 MD5Digest = array[0..15] of byte;
 MD5Buffer = array[0..63] of byte;
 MD5Context = record
  State: MD5State;
  Count: MD5Count;
  Buffer: MD5Buffer;
 end;

 Char = AnsiChar;//clq

procedure MD5Init(var Context: MD5Context);
procedure MD5Update(var Context: MD5Context; Input: pChar; Length: longword);
procedure MD5Final(var Context: MD5Context; var Digest: MD5Digest);

//function MD5String(M: string): MD5Digest;
function MD5String(M: AnsiString): MD5Digest;
function MD5File(N: string): MD5Digest;
function MD5Print(D: MD5Digest): string;

function MD5Match(D1, D2: MD5Digest): boolean;

//added by Crazy Worm 2005.6.7
function MD5DigestToString(D:MD5Digest):string;
function MD5StringToDigest(M:string):MD5Digest;
//function StringToMD5String(M:string):string;
function StringToMD5String(M:AnsiString):string;


// -----------------------------------------------------------------------------------------------
IMPLEMENTATION
// -----------------------------------------------------------------------------------------------

var
 PADDING: MD5Buffer = (
  $80, $00, $00, $00, $00, $00, $00, $00,
  $00, $00, $00, $00, $00, $00, $00, $00,
  $00, $00, $00, $00, $00, $00, $00, $00,
  $00, $00, $00, $00, $00, $00, $00, $00,
  $00, $00, $00, $00, $00, $00, $00, $00,
  $00, $00, $00, $00, $00, $00, $00, $00,
  $00, $00, $00, $00, $00, $00, $00, $00,
  $00, $00, $00, $00, $00, $00, $00, $00
 );

function F(x, y, z: DWORD): DWORD;
begin
 Result := (x and y) or ((not x) and z);
end;

function G(x, y, z: DWORD): DWORD;
begin
 Result := (x and z) or (y and (not z));
end;

function H(x, y, z: DWORD): DWORD;
begin
 Result := x xor y xor z;
end;

function I(x, y, z: DWORD): DWORD;
begin
 Result := y xor (x or (not z));
end;

procedure rot(var x: DWORD; n: BYTE);
begin
 x := (x shl n) or (x shr (32 - n));
end;

procedure FF(var a: DWORD; b, c, d, x: DWORD; s: BYTE; ac: DWORD);
begin
 inc(a, F(b, c, d) + x + ac);
 rot(a, s);
 inc(a, b);
end;

procedure GG(var a: DWORD; b, c, d, x: DWORD; s: BYTE; ac: DWORD);
begin
 inc(a, G(b, c, d) + x + ac);
 rot(a, s);
 inc(a, b);
end;

procedure HH(var a: DWORD; b, c, d, x: DWORD; s: BYTE; ac: DWORD);
begin
 inc(a, H(b, c, d) + x + ac);
 rot(a, s);
 inc(a, b);
end;

procedure II(var a: DWORD; b, c, d, x: DWORD; s: BYTE; ac: DWORD);
begin
 inc(a, I(b, c, d) + x + ac);
 rot(a, s);
 inc(a, b);
end;

// -----------------------------------------------------------------------------------------------

// Encode Count bytes at Source into (Count / 4) DWORDs at Target
procedure Encode(Source, Target: pointer; Count: longword);
var
 S: PByte;
 T: PDWORD;
 I: longword;
begin
 S := Source;
 T := Target;
 for I := 1 to Count div 4 do begin
  T^ := S^;
  inc(S);
  T^ := T^ or (S^ shl 8);
  inc(S);
  T^ := T^ or (S^ shl 16);
  inc(S);
  T^ := T^ or (S^ shl 24);
  inc(S);
  inc(T);
 end;
end;

// Decode Count DWORDs at Source into (Count * 4) Bytes at Target
procedure Decode(Source, Target: pointer; Count: longword);
var
 S: PDWORD;
 T: PByte;
 I: longword;
begin
 S := Source;
 T := Target;
 for I := 1 to Count do begin
  T^ := S^ and $ff;
  inc(T);
  T^ := (S^ shr 8) and $ff;
  inc(T);
  T^ := (S^ shr 16) and $ff;
  inc(T);
  T^ := (S^ shr 24) and $ff;
  inc(T);
  inc(S);
 end;
end;

// Transform State according to first 64 bytes at Buffer
procedure Transform(Buffer: pointer; var State: MD5State);
var
 a, b, c, d: DWORD;
 Block: MD5Block;
begin
 Encode(Buffer, @Block, 64);
 a := State[0];
 b := State[1];
 c := State[2];
 d := State[3];
 FF (a, b, c, d, Block[ 0],  7, $d76aa478);
 FF (d, a, b, c, Block[ 1], 12, $e8c7b756);
 FF (c, d, a, b, Block[ 2], 17, $242070db);
 FF (b, c, d, a, Block[ 3], 22, $c1bdceee);
 FF (a, b, c, d, Block[ 4],  7, $f57c0faf);
 FF (d, a, b, c, Block[ 5], 12, $4787c62a);
 FF (c, d, a, b, Block[ 6], 17, $a8304613);
 FF (b, c, d, a, Block[ 7], 22, $fd469501);
 FF (a, b, c, d, Block[ 8],  7, $698098d8);
 FF (d, a, b, c, Block[ 9], 12, $8b44f7af);
 FF (c, d, a, b, Block[10], 17, $ffff5bb1);
 FF (b, c, d, a, Block[11], 22, $895cd7be);
 FF (a, b, c, d, Block[12],  7, $6b901122);
 FF (d, a, b, c, Block[13], 12, $fd987193);
 FF (c, d, a, b, Block[14], 17, $a679438e);
 FF (b, c, d, a, Block[15], 22, $49b40821);
 GG (a, b, c, d, Block[ 1],  5, $f61e2562);
 GG (d, a, b, c, Block[ 6],  9, $c040b340);
 GG (c, d, a, b, Block[11], 14, $265e5a51);
 GG (b, c, d, a, Block[ 0], 20, $e9b6c7aa);
 GG (a, b, c, d, Block[ 5],  5, $d62f105d);
 GG (d, a, b, c, Block[10],  9,  $2441453);
 GG (c, d, a, b, Block[15], 14, $d8a1e681);
 GG (b, c, d, a, Block[ 4], 20, $e7d3fbc8);
 GG (a, b, c, d, Block[ 9],  5, $21e1cde6);
 GG (d, a, b, c, Block[14],  9, $c33707d6);
 GG (c, d, a, b, Block[ 3], 14, $f4d50d87);
 GG (b, c, d, a, Block[ 8], 20, $455a14ed);
 GG (a, b, c, d, Block[13],  5, $a9e3e905);
 GG (d, a, b, c, Block[ 2],  9, $fcefa3f8);
 GG (c, d, a, b, Block[ 7], 14, $676f02d9);
 GG (b, c, d, a, Block[12], 20, $8d2a4c8a);
 HH (a, b, c, d, Block[ 5],  4, $fffa3942);
 HH (d, a, b, c, Block[ 8], 11, $8771f681);
 HH (c, d, a, b, Block[11], 16, $6d9d6122);
 HH (b, c, d, a, Block[14], 23, $fde5380c);
 HH (a, b, c, d, Block[ 1],  4, $a4beea44);
 HH (d, a, b, c, Block[ 4], 11, $4bdecfa9);
 HH (c, d, a, b, Block[ 7], 16, $f6bb4b60);
 HH (b, c, d, a, Block[10], 23, $bebfbc70);
 HH (a, b, c, d, Block[13],  4, $289b7ec6);
 HH (d, a, b, c, Block[ 0], 11, $eaa127fa);
 HH (c, d, a, b, Block[ 3], 16, $d4ef3085);
 HH (b, c, d, a, Block[ 6], 23,  $4881d05);
 HH (a, b, c, d, Block[ 9],  4, $d9d4d039);
 HH (d, a, b, c, Block[12], 11, $e6db99e5);
 HH (c, d, a, b, Block[15], 16, $1fa27cf8);
 HH (b, c, d, a, Block[ 2], 23, $c4ac5665);
 II (a, b, c, d, Block[ 0],  6, $f4292244);
 II (d, a, b, c, Block[ 7], 10, $432aff97);
 II (c, d, a, b, Block[14], 15, $ab9423a7);
 II (b, c, d, a, Block[ 5], 21, $fc93a039);
 II (a, b, c, d, Block[12],  6, $655b59c3);
 II (d, a, b, c, Block[ 3], 10, $8f0ccc92);
 II (c, d, a, b, Block[10], 15, $ffeff47d);
 II (b, c, d, a, Block[ 1], 21, $85845dd1);
 II (a, b, c, d, Block[ 8],  6, $6fa87e4f);
 II (d, a, b, c, Block[15], 10, $fe2ce6e0);
 II (c, d, a, b, Block[ 6], 15, $a3014314);
 II (b, c, d, a, Block[13], 21, $4e0811a1);
 II (a, b, c, d, Block[ 4],  6, $f7537e82);
 II (d, a, b, c, Block[11], 10, $bd3af235);
 II (c, d, a, b, Block[ 2], 15, $2ad7d2bb);
 II (b, c, d, a, Block[ 9], 21, $eb86d391);
 inc(State[0], a);
 inc(State[1], b);
 inc(State[2], c);
 inc(State[3], d);
end;

// -----------------------------------------------------------------------------------------------

// Initialize given Context
procedure MD5Init(var Context: MD5Context);
begin
 with Context do begin
  State[0] := $67452301;
  State[1] := $efcdab89;
  State[2] := $98badcfe;
  State[3] := $10325476;
  Count[0] := 0;
  Count[1] := 0;
  ZeroMemory(@Buffer, SizeOf(MD5Buffer));
 end;
end;

// Update given Context to include Length bytes of Input
procedure MD5Update(var Context: MD5Context; Input: pChar; Length: longword);
var
 Index: longword;
 PartLen: longword;
 I: longword;
begin
 with Context do begin
  Index := (Count[0] shr 3) and $3f;
  inc(Count[0], Length shl 3);
  if Count[0] < (Length shl 3) then inc(Count[1]);
  inc(Count[1], Length shr 29);
 end;
 PartLen := 64 - Index;
 if Length >= PartLen then begin
  CopyMemory(@Context.Buffer[Index], Input, PartLen);
  Transform(@Context.Buffer, Context.State);
  I := PartLen;
  while I + 63 < Length do begin
   Transform(@Input[I], Context.State);
   inc(I, 64);
  end;
  Index := 0;
 end else I := 0;
 CopyMemory(@Context.Buffer[Index], @Input[I], Length - I);
end;

// Finalize given Context, create Digest and zeroize Context
procedure MD5Final(var Context: MD5Context; var Digest: MD5Digest);
var
 Bits: MD5CBits;
 Index: longword;
 PadLen: longword;
begin
 Decode(@Context.Count, @Bits, 2);
 Index := (Context.Count[0] shr 3) and $3f;
 if Index < 56 then PadLen := 56 - Index else PadLen := 120 - Index;
 MD5Update(Context, @PADDING, PadLen);
 MD5Update(Context, @Bits, 8);
 Decode(@Context.State, @Digest, 4);
 ZeroMemory(@Context, SizeOf(MD5Context));
end;

// -----------------------------------------------------------------------------------------------

// Create digest of given Message
//function MD5String(M: string): MD5Digest;
function MD5String(M: AnsiString): MD5Digest;
var
 Context: MD5Context;
begin
 MD5Init(Context);
 MD5Update(Context, pChar(M), length(M));
 MD5Final(Context, Result);
end;

// Create digest of file with given Name
function MD5File(N: string): MD5Digest;
var
 FileHandle: THandle;
 MapHandle: THandle;
 ViewPointer: pointer;
 Context: MD5Context;
begin
 MD5Init(Context);
 FileHandle := CreateFile(pChar(N), GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE,
  nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
 if FileHandle <> INVALID_HANDLE_VALUE then try
  MapHandle := CreateFileMapping(FileHandle, nil, PAGE_READONLY, 0, 0, nil);
  if MapHandle <> 0 then try
   ViewPointer := MapViewOfFile(MapHandle, FILE_MAP_READ, 0, 0, 0);
   if ViewPointer <> nil then try
    MD5Update(Context, ViewPointer, GetFileSize(FileHandle, nil));
   finally
    UnmapViewOfFile(ViewPointer);
   end;
  finally
   CloseHandle(MapHandle);
  end;
 finally
  CloseHandle(FileHandle);
 end;
 MD5Final(Context, Result);
end;

// Create hex representation of given Digest
function MD5Print(D: MD5Digest): string;
var
 I: byte;
const
 Digits: array[0..15] of char =
  ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');
begin
 Result := '';
 for I := 0 to 15 do Result := Result + Digits[(D[I] shr 4) and $0f] + Digits[D[I] and $0f];
end;

// -----------------------------------------------------------------------------------------------

// Compare two Digests
function MD5Match(D1, D2: MD5Digest): boolean;
var
 I: byte;
begin
 I := 0;
 Result := TRUE;
 while Result and (I < 16) do begin
  Result := D1[I] = D2[I];
  inc(I);
 end;
end;

function MD5DigestToString(D:MD5Digest):string;
var
 I: byte;
const
 Digits: array[0..15] of char =
  ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');
begin
 Result := '';
 for I := 0 to 15 do Result := Result + Digits[(D[I] shr 4) and $0f] + Digits[D[I] and $0f];
end;

function MD5StringToDigest(M:string):MD5Digest;
var
 I,J,H1,H2:byte;
  MD5:MD5Digest;
begin
  if Length(M)<16 then
  begin
    Result:=MD5;
    Exit;
  end;
  for I:=0 to 15 do
  begin
    J:=(I shl 1)+1;
    H1:=Byte(M[J]);
    if H1>$60 then H1:=H1-$61+$A
    else H1:=H1-$30;
    H2:=Byte(M[J+1]);
    if H2>$60 then H2:=H2-$61+$A
    else H2:=H2-$30;
    MD5[I]:=(H1 shl 4)+H2;
  end;
  Result:=MD5;
end;

//function StringToMD5String(M:string):string;
function StringToMD5String(M:AnsiString):string;
var
  D:MD5Digest;
begin
  D:=MD5String(M);
  Result:=MD5DigestToString(D);
  //ShowMessage(Result);//这个是小写的,很多系统是用大写的
end;

end.



des.pas

unit Des;

interface

uses SysUtils;

type
  TKeyByte = array[0..5] of Byte;
  TDesMode = (dmEncry, dmDecry);

  Char = AnsiChar;//clq

  //function EncryStr(Str, Key: String): String;
  function EncryStr(Str, Key: AnsiString): AnsiString;
  function DecryStr(Str2, Key: AnsiString): AnsiString;
  function EncryStrHex(Str, Key: AnsiString): AnsiString;
  function DecryStrHex(StrHex, Key: AnsiString): AnsiString;

const
  BitIP: array[0..63] of Byte =
    (57, 49, 41, 33, 25, 17,  9,  1,
     59, 51, 43, 35, 27, 19, 11,  3,
     61, 53, 45, 37, 29, 21, 13,  5,
     63, 55, 47, 39, 31, 23, 15,  7,
     56, 48, 40, 32, 24, 16,  8,  0,
     58, 50, 42, 34, 26, 18, 10,  2,
     60, 52, 44, 36, 28, 20, 12,  4,
     62, 54, 46, 38, 30, 22, 14,  6 );

  BitCP: array[0..63] of Byte =
    ( 39,  7, 47, 15, 55, 23, 63, 31,
      38,  6, 46, 14, 54, 22, 62, 30,
      37,  5, 45, 13, 53, 21, 61, 29,
      36,  4, 44, 12, 52, 20, 60, 28,
      35,  3, 43, 11, 51, 19, 59, 27,
      34,  2, 42, 10, 50, 18, 58, 26,
      33,  1, 41,  9, 49, 17, 57, 25,
      32,  0, 40,  8, 48, 16, 56, 24 );

  BitExp: array[0..47] of Integer =
    ( 31, 0, 1, 2, 3, 4, 3, 4, 5, 6, 7, 8, 7, 8, 9,10,
      11,12,11,12,13,14,15,16,15,16,17,18,19,20,19,20,
      21,22,23,24,23,24,25,26,27,28,27,28,29,30,31,0  );

  BitPM: array[0..31] of Byte =
    ( 15, 6,19,20,28,11,27,16, 0,14,22,25, 4,17,30, 9,
       1, 7,23,13,31,26, 2, 8,18,12,29, 5,21,10, 3,24 );

  sBox: array[0..7] of array[0..63] of Byte =
    ( ( 14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7,
         0, 15,  7,  4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5,  3,  8,
         4,  1, 14,  8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10,  5,  0,
        15, 12,  8,  2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0,  6, 13 ),

      ( 15,  1,  8, 14,  6, 11,  3,  4,  9,  7,  2, 13, 12,  0,  5, 10,
         3, 13,  4,  7, 15,  2,  8, 14, 12,  0,  1, 10,  6,  9, 11,  5,
         0, 14,  7, 11, 10,  4, 13,  1,  5,  8, 12,  6,  9,  3,  2, 15,
        13,  8, 10,  1,  3, 15,  4,  2, 11,  6,  7, 12,  0,  5, 14,  9 ),

      ( 10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8,
        13,  7,  0,  9,  3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1,
        13,  6,  4,  9,  8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7,
         1, 10, 13,  0,  6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12 ),

      (  7, 13, 14,  3,  0,  6,  9, 10,  1,  2,  8,  5, 11, 12,  4, 15,
        13,  8, 11,  5,  6, 15,  0,  3,  4,  7,  2, 12,  1, 10, 14,  9,
        10,  6,  9,  0, 12, 11,  7, 13, 15,  1,  3, 14,  5,  2,  8,  4,
         3, 15,  0,  6, 10,  1, 13,  8,  9,  4,  5, 11, 12,  7,  2, 14 ),

      (  2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13,  0, 14,  9,
        14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3,  9,  8,  6,
         4,  2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6,  3,  0, 14,
        11,  8, 12,  7,  1, 14,  2, 13,  6, 15,  0,  9, 10,  4,  5,  3 ),

      ( 12,  1, 10, 15,  9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11,
        10, 15,  4,  2,  7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8,
         9, 14, 15,  5,  2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6,
         4,  3,  2, 12,  9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13 ),

      (  4, 11,  2, 14, 15,  0,  8, 13,  3, 12,  9,  7,  5, 10,  6,  1,
        13,  0, 11,  7,  4,  9,  1, 10, 14,  3,  5, 12,  2, 15,  8,  6,
         1,  4, 11, 13, 12,  3,  7, 14, 10, 15,  6,  8,  0,  5,  9,  2,
         6, 11, 13,  8,  1,  4, 10,  7,  9,  5,  0, 15, 14,  2,  3, 12 ),

      ( 13,  2,  8,  4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7,
         1, 15, 13,  8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2,
         7, 11,  4,  1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8,
         2,  1, 14,  7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6, 11 ) );

  BitPMC1: array[0..55] of Byte =
    ( 56, 48, 40, 32, 24, 16,  8,
       0, 57, 49, 41, 33, 25, 17,
       9,  1, 58, 50, 42, 34, 26,
      18, 10,  2, 59, 51, 43, 35,
      62, 54, 46, 38, 30, 22, 14,
       6, 61, 53, 45, 37, 29, 21,
      13,  5, 60, 52, 44, 36, 28,
      20, 12,  4, 27, 19, 11,  3 );

  BitPMC2: array[0..47] of Byte =
    ( 13, 16, 10, 23,  0,  4,
       2, 27, 14,  5, 20,  9,
      22, 18, 11,  3, 25,  7,
      15,  6, 26, 19, 12,  1,
      40, 51, 30, 36, 46, 54,
      29, 39, 50, 44, 32, 47,
      43, 48, 38, 55, 33, 52,
      45, 41, 49, 35, 28, 31 );

var
  subKey: array[0..15] of TKeyByte;

implementation

//--------------------------------------------------
//clq
function Chr(X: Byte): AnsiChar;
var
  c:AnsiChar;
begin
  Result := AnsiChar(X);
end;

function Ord(c:AnsiChar): Byte;
begin
  Result := Byte(c);
end;

//--------------------------------------------------

procedure initPermutation(var inData: array of Byte);
var
  newData: array[0..7] of Byte;
  i: Integer;
begin
  FillChar(newData, 8, 0);
  for i := 0 to 63 do
    if (inData[BitIP[i] shr 3] and (1 shl (7- (BitIP[i] and $07)))) <> 0 then
      newData[i shr 3] := newData[i shr 3] or (1 shl (7-(i and $07)));
  for i := 0 to 7 do inData[i] := newData[i];
end;

procedure conversePermutation(var inData: array of Byte);
var
  newData: array[0..7] of Byte;
  i: Integer;
begin
  FillChar(newData, 8, 0);
  for i := 0 to 63 do
    if (inData[BitCP[i] shr 3] and (1 shl (7-(BitCP[i] and $07)))) <> 0 then
      newData[i shr 3] := newData[i shr 3] or (1 shl (7-(i and $07)));
  for i := 0 to 7 do inData[i] := newData[i];
end;

procedure expand(inData: array of Byte; var outData: array of Byte);
var
  i: Integer;
begin
  FillChar(outData, 6, 0);
  for i := 0 to 47 do
    if (inData[BitExp[i] shr 3] and (1 shl (7-(BitExp[i] and $07)))) <> 0 then
      outData[i shr 3] := outData[i shr 3] or (1 shl (7-(i and $07)));
end;

procedure permutation(var inData: array of Byte);
var
  newData: array[0..3] of Byte;
  i: Integer;
begin
  FillChar(newData, 4, 0);
  for i := 0 to 31 do
    if (inData[BitPM[i] shr 3] and (1 shl (7-(BitPM[i] and $07)))) <> 0 then
      newData[i shr 3] := newData[i shr 3] or (1 shl (7-(i and $07)));
  for i := 0 to 3 do inData[i] := newData[i];
end;

function si(s,inByte: Byte): Byte;
var
  c: Byte;
begin
  c := (inByte and $20) or ((inByte and $1e) shr 1) or
    ((inByte and $01) shl 4);
  Result := (sBox[s][c] and $0f);
end;

procedure permutationChoose1(inData: array of Byte;
  var outData: array of Byte);
var
  i: Integer;
begin
  FillChar(outData, 7, 0);
  for i := 0 to 55 do
    if (inData[BitPMC1[i] shr 3] and (1 shl (7-(BitPMC1[i] and $07)))) <> 0 then
      outData[i shr 3] := outData[i shr 3] or (1 shl (7-(i and $07)));
end;

procedure permutationChoose2(inData: array of Byte;
  var outData: array of Byte);
var
  i: Integer;
begin
  FillChar(outData, 6, 0);
  for i := 0 to 47 do
    if (inData[BitPMC2[i] shr 3] and (1 shl (7-(BitPMC2[i] and $07)))) <> 0 then
      outData[i shr 3] := outData[i shr 3] or (1 shl (7-(i and $07)));
end;

procedure cycleMove(var inData: array of Byte; bitMove: Byte);
var
  i: Integer;
begin
  for i := 0 to bitMove - 1 do
  begin
    inData[0] := (inData[0] shl 1) or (inData[1] shr 7);
    inData[1] := (inData[1] shl 1) or (inData[2] shr 7);
    inData[2] := (inData[2] shl 1) or (inData[3] shr 7);
    inData[3] := (inData[3] shl 1) or ((inData[0] and $10) shr 4);
    inData[0] := (inData[0] and $0f);
  end;
end;

procedure makeKey(inKey: array of Byte; var outKey: array of TKeyByte);
const
  bitDisplace: array[0..15] of Byte =
    ( 1,1,2,2, 2,2,2,2, 1,2,2,2, 2,2,2,1 );
var
  outData56: array[0..6] of Byte;
  key28l: array[0..3] of Byte;
  key28r: array[0..3] of Byte;
  key56o: array[0..6] of Byte;
  i: Integer;
begin
  permutationChoose1(inKey, outData56);

  key28l[0] := outData56[0] shr 4;
  key28l[1] := (outData56[0] shl 4) or (outData56[1] shr 4);
  key28l[2] := (outData56[1] shl 4) or (outData56[2] shr 4);
  key28l[3] := (outData56[2] shl 4) or (outData56[3] shr 4);
  key28r[0] := outData56[3] and $0f;
  key28r[1] := outData56[4];
  key28r[2] := outData56[5];
  key28r[3] := outData56[6];

  for i := 0 to 15 do
  begin
    cycleMove(key28l, bitDisplace[i]);
    cycleMove(key28r, bitDisplace[i]);
    key56o[0] := (key28l[0] shl 4) or (key28l[1] shr 4);
    key56o[1] := (key28l[1] shl 4) or (key28l[2] shr 4);
    key56o[2] := (key28l[2] shl 4) or (key28l[3] shr 4);
    key56o[3] := (key28l[3] shl 4) or (key28r[0]);
    key56o[4] := key28r[1];
    key56o[5] := key28r[2];
    key56o[6] := key28r[3];
    permutationChoose2(key56o, outKey[i]);
  end;
end;

procedure encry(inData, subKey: array of Byte;
   var outData: array of Byte);
var
  outBuf: array[0..5] of Byte;
  buf: array[0..7] of Byte;
  i: Integer;
begin
  expand(inData, outBuf);
  for i := 0 to 5 do outBuf[i] := outBuf[i] xor subKey[i];
                                                // outBuf       xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx
  buf[0] := outBuf[0] shr 2;                                  //xxxxxx -> 2
  buf[1] := ((outBuf[0] and $03) shl 4) or (outBuf[1] shr 4); // 4 <- xx xxxx -> 4
  buf[2] := ((outBuf[1] and $0f) shl 2) or (outBuf[2] shr 6); //        2 <- xxxx xx -> 6
  buf[3] := outBuf[2] and $3f;                                //                    xxxxxx
  buf[4] := outBuf[3] shr 2;                                  //                           xxxxxx
  buf[5] := ((outBuf[3] and $03) shl 4) or (outBuf[4] shr 4); //                                 xx xxxx
  buf[6] := ((outBuf[4] and $0f) shl 2) or (outBuf[5] shr 6); //                                        xxxx xx
  buf[7] := outBuf[5] and $3f;                                //                                               xxxxxx
  for i := 0 to 7 do buf[i] := si(i, buf[i]);
  for i := 0 to 3 do outBuf[i] := (buf[i*2] shl 4) or buf[i*2+1];
  permutation(outBuf);
  for i := 0 to 3 do outData[i] := outBuf[i];
end;

procedure desData(desMode: TDesMode;
  inData: array of Byte; var outData: array of Byte);
// inData, outData 都为8Bytes，否则出错
var
  i, j: Integer;
  temp, buf: array[0..3] of Byte;
begin
  for i := 0 to 7 do outData[i] := inData[i];
  initPermutation(outData);
  if desMode = dmEncry then
  begin
    for i := 0 to 15 do
    begin
      for j := 0 to 3 do temp[j] := outData[j];                 //temp = Ln
      for j := 0 to 3 do outData[j] := outData[j + 4];         //Ln+1 = Rn
      encry(outData, subKey[i], buf);                           //Rn ==Kn==> buf
      for j := 0 to 3 do outData[j + 4] := temp[j] xor buf[j];  //Rn+1 = Ln^buf
    end;

    for j := 0 to 3 do temp[j] := outData[j + 4];
    for j := 0 to 3 do outData[j + 4] := outData[j];
    for j := 0 to 3 do outData[j] := temp[j];
  end
  else if desMode = dmDecry then
  begin
    for i := 15 downto 0 do
    begin
      for j := 0 to 3 do temp[j] := outData[j];
      for j := 0 to 3 do outData[j] := outData[j + 4];
      encry(outData, subKey[i], buf);
      for j := 0 to 3 do outData[j + 4] := temp[j] xor buf[j];
    end;
    for j := 0 to 3 do temp[j] := outData[j + 4];
    for j := 0 to 3 do outData[j + 4] := outData[j];
    for j := 0 to 3 do outData[j] := temp[j];
  end;
  conversePermutation(outData);
end;

//////////////////////////////////////////////////////////////

//function EncryStr(Str, Key: String): String;
function EncryStr(Str, Key: AnsiString): AnsiString;
var
  StrByte, OutByte, KeyByte: array[0..7] of Byte;
  //StrResult: String;
  StrResult: AnsiString;
  I, J: Integer;
begin
  if (Length(Str) > 0) and (Ord(Str[Length(Str)]) = 0) then
    raise Exception.Create('Error: the last char is NULL char.');
  if Length(Key) < 8 then
    while Length(Key) < 8 do Key := Key + Chr(0);
  while Length(Str) mod 8 <> 0 do Str := Str + Chr(0);

  for J := 0 to 7 do KeyByte[J] := Ord(Key[J + 1]);
  makeKey(keyByte, subKey);

  StrResult := '';

  for I := 0 to Length(Str) div 8 - 1 do
  begin
    for J := 0 to 7 do
      StrByte[J] := Ord(Str[I * 8 + J + 1]);
    desData(dmEncry, StrByte, OutByte);
    for J := 0 to 7 do
      StrResult := StrResult + Chr(OutByte[J]);
  end;

  Result := StrResult;
end;

function DecryStr(Str2, Key: AnsiString): AnsiString;
var
  StrByte, OutByte, KeyByte: array[0..7] of Byte;
  StrResult: AnsiString;
  I, J: Integer;
  str:AnsiString;
begin
  str := Str2;

  if Length(Key) < 8 then
    while Length(Key) < 8 do Key := Key + Chr(0);

  for J := 0 to 7 do KeyByte[J] := Ord(Key[J + 1]);
  makeKey(keyByte, subKey);

  StrResult := '';

  for I := 0 to Length(Str) div 8 - 1 do
  begin
    for J := 0 to 7 do StrByte[J] := Ord(Str[I * 8 + J + 1]);
    desData(dmDecry, StrByte, OutByte);
    for J := 0 to 7 do
      StrResult := StrResult + Chr(OutByte[J]);
  end;
  while (Length(StrResult) > 0) and
    (Ord(StrResult[Length(StrResult)]) = 0) do
    Delete(StrResult, Length(StrResult), 1);
  Result := StrResult;
end;

///////////////////////////////////////////////////////////

function EncryStrHex(Str, Key: AnsiString): AnsiString;
var
  StrResult, TempResult, Temp: AnsiString;
  I: Integer;
begin
  TempResult := EncryStr(Str, Key);
  StrResult := '';
  for I := 0 to Length(TempResult) - 1 do
  begin
    Temp := Format('%x', [Ord(TempResult[I + 1])]);
    if Length(Temp) = 1 then Temp := '0' + Temp;
    StrResult := StrResult + Temp;
  end;
  Result := StrResult;
end;

function DecryStrHex(StrHex, Key: AnsiString): AnsiString;
  function HexToInt(Hex: AnsiString): Integer;
  var
    I, Res: Integer;
    ch: AnsiChar;
  begin
    Res := 0;
    for I := 0 to Length(Hex) - 1 do
    begin
      ch := Hex[I + 1];
      if (ch >= '0') and (ch <= '9') then
        Res := Res * 16 + Ord(ch) - Ord('0')
      else if (ch >= 'A') and (ch <= 'F') then
        Res := Res * 16 + Ord(ch) - Ord('A') + 10
      else if (ch >= 'a') and (ch <= 'f') then
        Res := Res * 16 + Ord(ch) - Ord('a') + 10
      else raise Exception.Create('Error: not a Hex String');
    end;
    Result := Res;
  end;

var
  Str, Temp: AnsiString;
  I: Integer;
begin
  Str := '';
  for I := 0 to Length(StrHex) div 2 - 1 do
  begin
    Temp := Copy(StrHex, I * 2 + 1, 2);
    Str := Str + Chr(HexToInt(Temp));
  end;
  Result := DecryStr(Str, Key);
end;

end.



base64.pas

unit base64;

//delphi7中EncdDecd单元EncodeString函数好像也是base64编码函数

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  EncdDecd,
  IdGlobal,
  Dialogs, StdCtrls;


function StrToBase64(const str: string): string;
//function Base64ToStr(const Base64: string): string;
function Base64ToStr(const Base64: AnsiString): AnsiString;


implementation

function StrToBase64(const str: string): string;
var
  s:AnsiString;
begin
  //Result := EncdDecd.EncodeString(str);exit;
  //Result := EncdDecd.EncodeBase64(str);
  s := str;
  Result := EncdDecd.EncodeBase64(PAnsiChar(s), Length(s));
  Result := StringReplace(Result, #13#10, '', [rfReplaceAll]);//去掉回车换行,因为有些系统不支持
end;

function Base64ToStr(const Base64: AnsiString): AnsiString;
var
  buf:TBytes;
begin
  //Result := EncdDecd.DecodeString(Base64);Exit;//
  buf := EncdDecd.DecodeBase64(Base64);
  //ShowMessage(PAnsiChar(@buf[0]));


  //BytesToRaw(buf, head, SizeOf(TProtoHead));
  //Result := BytesToString(buf, TIdTextEncoding.ASCII);Exit;//不对,即使是用了 ASCII 仍然进行了转码,没法得到原始数据
  //Result := BytesToString(buf, TIdTextEncoding.UTF8);

  //Result := (PAnsiChar(@buf[0]));
  SetLength(Result, Length(buf));
  //SetAnsiString(@Result, @buf[0], Length(buf));
  //StrLCopy(PAnsiChar(result), @buf[0], Length(buf));//不行会在 #0 时出错
  CopyMemory(PAnsiChar(result), @buf[0], Length(buf));

end;


end.
