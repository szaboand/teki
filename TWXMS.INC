{****************************************************************************}
{***                                                                      ***}
{***                       Turbo Pascal TWXMS Unit                        ***}
{***                            1.0a Verzi¢                               ***}
{***                                                                      ***}
{***               (C) TwinNet 1998  (P) Szab¢ Andr s 1997/98             ***}
{***                                                                      ***}
{***                      1997.02.16.  - 1998.11.25.                      ***}
{***                                                                      ***}
{****************************************************************************}

{****************************************************************************}
{****************************************************************************}
{***                        XMS kezel‹ elj r sok                          ***}
{****************************************************************************}
{****************************************************************************}

Type
    XMSType = record
              ByteNum    : longint;
              SourceType : word;
              SourceSeg  : word;
              SourceOff  : word;
              DestType   : word;
              DestSeg    : word;
              DestOff    : word;
              end;

Var
        XMSProc    : longint; { XMS rutin c¡me                               }
        XMS        : XMSType; { XMS t¡pus a mozgat shoz                      }


{****************************************************************************}
{************************ XMS vez‚rl‹ inicializ l sa ************************}
{****************************************************************************}

Function InitXMS:boolean;assembler;
Asm
        MOV     AX,$4300
        INT     $2F
        CMP     AL,$80
        JE      @Ok
        XOR     AL,AL
        JMP     @Exit
@Ok:
        MOV     AX,$4310
        INT     $2f
        MOV     word ptr DS:[XMSProc],BX
        MOV     word ptr DS:[XMSProc+2],ES
        MOV     AL,1
@Exit:
end;


{****************************************************************************}
{************************ XMS mem¢ria lefoglal sa ***************************}
{****************************************************************************}

Function GetXMS(Meret:word;var Handle:word):byte;assembler;
Asm
        MOV     AH,$09
        MOV     DX,Meret
        CALL    dword ptr ds:[XMSProc] { Mem¢ria allok l sa }
        CMP     AX,1
        JE      @Ok
        MOV     AL,BL
        JMP     @Exit
@Ok:
        LES     SI,Handle
        MOV     ES:[SI],DX
        MOV     AH,$0C
        CALL    dword ptr DS:[XMSProc] { Mem¢ria z rol sa }
        MOV     AL,BL
@Exit:
end;

{****************************************************************************}
{************************ XMS mem¢ria felszabad¡t sa ************************}
{****************************************************************************}

Function FreeXMS(Handle:word):byte;assembler;
Asm
        MOV     AH,$0D
        MOV     DX,Handle
        CALL    dword ptr DS:[XMSProc] { Mem¢ria z rol s felold sa }
        CMP     AX,1
        JE      @Ok
        MOV     AL,BL
        JMP     @Exit
@Ok:
        MOV     AH,$0A
        MOV     DX,Handle
        CALL    dword ptr DS:[XMSProc] { Mem¢ria felszabad¡t s     }
        MOV     AL,BL
@Exit:
end;

{****************************************************************************}
{************************** Mem¢ria mozgat sa *******************************}
{****************************************************************************}

Function MoveXMS(meret:longint;st,soff,sg,dt,doff,dg:word):byte;
var b:byte;
Begin
XMS.ByteNum:=Meret;
XMS.SourceType:=ST;XMS.SourceOff:=soff;XMS.SourceSeg:=Sg;
XMS.DestType:=DT;XMS.DestOff:=Doff;XMS.DestSeg:=dg;
 Asm
        MOV     SI,offset XMS
        MOV     AH,$0B
        CALL    dword ptr ds:[XMSProc]
        CMP     AX,1
        JE      @OK
        MOV     b,BL
        JMP     @Exit

@Ok:    MOV     AL,0
        MOV     b,AL
@Exit:
 End;
MoveXMS:=B;
End;

{****************************************************************************}
{************************** Max XMS mem¢ria lek‚rdez‚se *********************}
{****************************************************************************}

Function MaxXMSMem:word;assembler;
Asm
        MOV     AH,$08;
        MOV     BL,00
        CALL    dword ptr ds:[XMSProc]
        OR      BL,BL
        JZ      @Ok
        MOV     AX,0
        JMP     @Exit
@Ok:    MOV     AX,DX
@Exit:
End;

Function MaxXMSMemBlock:word;assembler;
Asm
        MOV     AH,$08;
        MOV     BL,00
        CALL    dword ptr ds:[XMSProc]
        OR      BL,BL
        JZ      @Exit
        MOV     AX,0
@Exit:
End;

{****************************************************************************}
{***************************** LoadFileXMS **********************************}
{****************************************************************************}

Function LoadFileToXMS(Filenev:string;Handle,PufferMeret:word):word;
var F:word;NumRead:word;Meret:longint;Puffer:pointer;i,j:word;
begin
If MaxAvail<PufferMeret then begin LoadFileToXMS:=0;Exit;end;
F:=OpenFile(FileNev,0);If IOError<>0 then begin LoadFileToXMS:=0;Exit;end;
GetMem(Puffer,PufferMeret);i:=0;j:=0;
repeat
      NumRead:=ReadFile(F,Puffer^,PufferMeret);
      if MoveXMS(PufferMeret,0,Ofs(Puffer^),Seg(Puffer^),Handle,j,i)<>0
         then begin
              CloseFile(F);FreeMem(Puffer,Puffermeret);
              FreeXMS(Handle);LoadFileToXMS:=0;Exit;
              end;
      if j=0 then j:=PufferMeret else begin inc(i);j:=0;end;
      until NumRead<>PufferMeret;
CloseFile(F);Freemem(Puffer,PufferMeret);
LoadFileToXMS:=Handle;
end;

{****************************************************************************}
{****************************************************************************}
{***                                                                      ***}
{***                              TWXMS End                               ***}
{***                                                                      ***}
{****************************************************************************}
{****************************************************************************}