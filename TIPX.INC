{****************************************************************************}
{***                                                                      ***}
{***                        Turbo Pascal IPX Unit                         ***}
{***                            2.0a Verzi¢                               ***}
{***                                                                      ***}
{***               (C) TwinNet 1999  (P) Szab¢ Andr s 1999                ***}
{***                      1999.01.07.  - 1999.01.30.                      ***}
{***                                                                      ***}
{*** - IPX.ASM      1.1 verzi¢ (C) TwinNet (P) Szab¢ Andr s 1999 Budapest ***}
{***                                                                      ***}
{****************************************************************************}

{$L IPX.OBJ}

Procedure _IPXInit;external;
Procedure _IPXGetAddress;external;
Procedure _IPXGetMaxPacketSize;external;
Procedure _IPXOpenSocket;external;
Procedure _IPXCloseSocket;external;
Procedure _IPXListenForPacket;external;
Procedure _IPXSendPacket;external;
Procedure _IPXRelenquishControl;external;

{****************************************************************************}
{***                   IPX driver inicializ l sa                          ***}
{****************************************************************************}

Function InitIPX:word;assembler;
Asm
   CALL _IPXInit
End;

{****************************************************************************}
{***                      IPX c¡m lek‚rdez‚se                             ***}
{****************************************************************************}

Procedure GetIPXAddress(var IPXAddr:IPXAddressType);assembler;
Asm
   PUSH  BP
   LES   SI,IPXAddr
   CALL _IPXGetAddress
   POP   BP
End;

{****************************************************************************}
{***                  IPX packet size lek‚rdez‚se                         ***}
{****************************************************************************}

Function GetIPXMaxPacketSize:word;assembler;
Asm
   PUSH BP
   CALL _IPXGetMaxPacketSize
   POP BP
End;

{****************************************************************************}
{***                      IPX socket nyit sa                              ***}
{****************************************************************************}

Function OpenIPXSocket(var SocketNumber:word;Mode:byte):word;assembler;
Asm
   PUSH BP
   LES  SI,SocketNumber
   MOV  DX,ES:[SI]
   MOV  AL,Mode
   CALL _IPXOpenSocket
   LES  SI,SocketNumber
   MOV  ES:[SI],DX
   POP  BP
End;

{****************************************************************************}
{***                      IPX socket z r sa                               ***}
{****************************************************************************}

Procedure CloseIPXSocket(SocketNumber:word);assembler;
Asm
   PUSH BP
   MOV  DX,SocketNumber
   CALL _IPXCloseSocket
   POP  BP
End;

{****************************************************************************}
{***                      IPX packet lek‚rdez‚se                          ***}
{****************************************************************************}

Function ListenForIPXPacket(var ECB):word;assembler;
Asm
   PUSH BP
   LES  SI,ECB
   CALL _IPXListenForPacket
   POP  BP
End;

{****************************************************************************}
{***                      IPX packet kld‚se                              ***}
{****************************************************************************}

Procedure SendIPXPacket(var ECB);assembler;
Asm
   PUSH BP
   LES  SI,ECB
   CALL _IPXSendPacket
   POP  BP
End;

{****************************************************************************}
{***                      RelenquishControl                               ***}
{****************************************************************************}

Procedure IPXRelenquishControl;assembler;
Asm
   PUSH BP
   CALL _IPXRelenquishControl
   POP BP
End;

{****************************************************************************}
{***                         ReverseWord                                  ***}
{****************************************************************************}


Function ReverseWord(W:word):word;assembler;
Asm
   MOV  AX,W
   XCHG AH,AL
End;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}

Const
     HexDigits : array[0..15] of char='0123456789ABCDEF';

Function HexByte(B:byte):string;assembler;
Asm
   cld
   les   di,@result
   mov   al,2
   stosb
   lea   bx,HexDigits
   mov   al,b
   shr   al,4
   xlat
   stosb
   mov   al,b
   and   al,00001111b
   xlat
   stosb
End;

Function  HexWord(w:word):string;assembler;
Asm
   cld
   les   di,@result
   mov   al,4
   stosb
   lea   bx,HexDigits
   mov   cx,w
   mov   al,ch
   shr   al,4
   xlat
   stosb
   mov   al,ch
   and   al,00001111b
   xlat
   stosb
   mov   al,cl
   shr   al,4
   xlat
   stosb
   mov   al,cl
   and   al,00001111b
   xlat
   stosb
End;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}

Function GetIPXAddressString(K:IPXAddressType):string;
var I:byte;S:string;
Begin
S:='';
For I:=0 to 3 do with K do S:=S+HexByte(NetworkNumber[I]);S:=S+':';
For I:=0 to 5 do with K do S:=S+HexByte(NodeNumber[I]);
GetIPXAddressString:=S;
End;

Function CompareIPXAddress(IPX1,IPX2:IPXAddressType):boolean;
var I:integer;
Begin
I:=5;CompareIPXAddress:=False;
while (I>=0) and (IPX1.NodeNumber[I]=IPX2.NodeNumber[I]) do Dec(I);
If I<0
   then begin
        I:=3;while (I>=0) and (IPX1.NetworkNumber[I]=IPX2.NetworkNumber[I]) do Dec(I);
        CompareIPXAddress:=(I<0) ;
        end;
End;

{****************************************************************************}
{***                            V1.2 rutinok                              ***}
{****************************************************************************}


Function LocalConnectionNumber:byte;assembler;
Asm
   MOV  AH,$DC
   MOV  AL,$00
   INT  $21
end;

Procedure UserInfo;
Const
          GET_CONNECTION_INFORMATION    = $16;
          NETWARE_SERVICE_E3  = $E3;
Var
     ReqBlk    :  record
      Len      :  word;
      ReqType  :  byte;
      ConnNbr  :  byte;
     end;
regs:registers;
Begin
With ReqBlk
     do begin
        Len :=sizeof(ReqBlk) - sizeof(Len);
        ReqType:=GET_CONNECTION_INFORMATION;
        ConnNbr:=ConnectionNumber;
        end;
with ConnInfoRec do Len:=sizeof(ConnInfoRec) - sizeof(Len);
regs.ah:=NETWARE_SERVICE_E3;
regs.ds:=seg(ReqBlk);
regs.si:=ofs(ReqBlk);
regs.es:=seg(ConnInfoRec);
regs.di:=ofs(ConnInfoRec);
msdos(regs);
End;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}