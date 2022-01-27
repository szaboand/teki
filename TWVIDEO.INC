{****************************************************************************}
{***                                                                      ***}
{***                      Turbo Pascal TWVideo Unit                       ***}
{***                            1.0a Verzi¢                               ***}
{***                                                                      ***}
{***               (C) TwinNet 2000  (P) Szab¢ Andr†s 1997/2000           ***}
{***                                                                      ***}
{***                      1997.02.16.  - 2000.07.05.                      ***}
{***                                                                      ***}
{*** - TG_16.ASM    1.8 verzi¢ (C) TwinNet (P) Szab¢ Andr†s 1996 Budapest ***}
{*** - TG_256.ASM   1.8 verzi¢ (C) TwinNet (P) Szab¢ Andr†s 1996 Budapest ***}
{*** - TPROC.ASM    1.7 verzi¢ (C) TwinNet (P) Szab¢ Andr†s 1996 Budapest ***}
{***                                                                      ***}
{****************************************************************************}

Const
    C_MaxVideoMode         = 21;
    C_VideoMode            : array [1..C_MaxVideoMode] of T_VideoMode = (
{ 320x200_16  } (ModeNum:$000D;ModeType:0;MemType:1;MaxX:320;MaxY:200;MaxC:16;LSize:40;BitPixel:4),
{ 320x240_16  } (ModeNum:$000E;ModeType:2;MemType:1;MaxX:320;MaxY:240;MaxC:16;LSize:40;BitPixel:4),
{ 320x350_16  } (ModeNum:$000D;ModeType:2;MemType:1;MaxX:320;MaxY:350;MaxC:16;LSize:40;BitPixel:4),
{ 320x400_16  } (ModeNum:$000D;ModeType:2;MemType:1;MaxX:320;MaxY:400;MaxC:16;LSize:40;BitPixel:4),
{ 320x480_16  } (ModeNum:$000E;ModeType:2;MemType:1;MaxX:320;MaxY:480;MaxC:16;LSize:40;BitPixel:4),
{ 640x200_16  } (ModeNum:$000E;ModeType:0;MemType:1;MaxX:640;MaxY:200;MaxC:16;LSize:80;BitPixel:4),
{ 640x240_16  } (ModeNum:$0012;ModeType:2;MemType:1;MaxX:640;MaxY:240;MaxC:16;LSize:80;BitPixel:4),
{ 640x350_16  } (ModeNum:$0010;ModeType:0;MemType:1;MaxX:640;MaxY:350;MaxC:16;LSize:80;BitPixel:4),
{ 640x400_16  } (ModeNum:$000E;ModeType:2;MemType:1;MaxX:640;MaxY:400;MaxC:16;LSize:80;BitPixel:4),
{ 640x480_16  } (ModeNum:$0012;ModeType:0;MemType:1;MaxX:640;MaxY:480;MaxC:16;LSize:80;BitPixel:4),
{ 720x400_16  } (ModeNum:$000E;ModeType:2;MemType:1;MaxX:720;MaxY:400;MaxC:16;LSize:90;BitPixel:4),
{ 720x480_16  } (ModeNum:$0012;ModeType:2;MemType:1;MaxX:720;MaxY:480;MaxC:16;LSize:90;BitPixel:4),
{ 800x600_16  } (ModeNum:$0102;ModeType:1;MemType:1;MaxX:800;MaxY:600;MaxC:16;LSize:100;BitPixel:4),
{1024x768_16  } (ModeNum:$0104;ModeType:1;MemType:1;MaxX:1024;MaxY:768;MaxC:16;LSize:128;BitPixel:4),
{1280x1024_16 } (ModeNum:$0106;ModeType:1;MemType:1;MaxX:1280;MaxY:1024;MaxC:16;LSize:160;BitPixel:4),
{ 320x200_256 } (ModeNum:$0013;ModeType:0;MemType:2;MaxX:320;MaxY:200;MaxC:256;LSize:320;BitPixel:8),
{ 640x400_256 } (ModeNum:$0100;ModeType:1;MemType:2;MaxX:640;MaxY:400;MaxC:256;LSize:640;BitPixel:8),
{ 640x480_256 } (ModeNum:$0101;ModeType:1;MemType:2;MaxX:640;MaxY:480;MaxC:256;LSize:640;BitPixel:8),
{ 800x600_256 } (ModeNum:$0103;ModeType:1;MemType:2;MaxX:800;MaxY:600;MaxC:256;LSize:800;BitPixel:8),
{1024x768_256 } (ModeNum:$0105;ModeType:1;MemType:2;MaxX:1024;MaxY:768;MaxC:256;LSize:1024;BitPixel:8),
{1280x1024_256} (ModeNum:$0107;ModeType:1;MemType:2;MaxX:1280;MaxY:1024;MaxC:256;LSize:1280;BitPixel:8)
                );

    C_VBP           : word   = $0000; { SegÇdv†ltoz¢ -egy pixel bitsz†ma act. m¢dban  }
    C_ActMode       : word   = $0000; { Aktu†lis vide¢m¢d                    }

    C_InkColor      : byte   = $0F; { Aktu†lis sz°n                          }
    C_CopyXOR       : byte   = $00; { CopyBlock segÇdv†ltoz¢                 }

    C_TextBackColor : byte   = $01; { Szîveg h†ttÇrsz°n                      }
    C_TextOver      : byte   = $01; { FelÅl°r†s jelzã                        }

    C_CharX         : word   = $08; { Karakter szÇlessÇge pixelben           }
    C_CharY         : word   = $10; { Karakter magass†ga pixelben            }

    RelX            : word  = 0;    { Relativ X koordin†ta                   }
    RelY            : word  = 0;    { Relativ Y koordin†ta                   }

    XMSHandle       : word  = 0;    { SavePic,RestorePic XMS handle          }

{Type
    TableType                = array[0..45,0..300] of integer;}

Var
    {SinRadiusTable  : TableType;
    CosRadiusTable  : TableType;}
    SavePalette     : array [0..255,1..3] of byte; { SavePic palette         }

{****************************************************************************}
{***                                                                      ***}
{***                     16 szin˚ assembly rutinok                        ***}
{***                                                                      ***}
{****************************************************************************}

{$L TG_16.OBJ}
Procedure  _Select_Page_16;external;
Procedure  _SetMode_16;external;
Procedure  _GetMode_16;external;
Procedure  _ClearScreen_16;external;
Procedure  _WritePixel_16;external;
Procedure  _GetPixel_16;external;
Procedure  _Line_16;external;
Procedure  _SolidRect_16;external;
Procedure  _CopyBlock_16;external;
Procedure  _CopyFromMem_16;external;
Procedure  _CopyToMem_16;external;
Procedure  _OutTextXY_16;external;
Procedure  _SetChars_16;external;
Procedure  _GetActPage_16;external;


{****************************************************************************}
{***                                                                      ***}
{***                     256 szin˚ assembly rutinok                       ***}
{***                                                                      ***}
{****************************************************************************}

{$L TG_256.OBJ}
Procedure  _Select_Page_256;external;
Procedure  _SetMode_256;external;
Procedure  _GetMode_256;external;
Procedure  _ClearScreen_256;external;
Procedure  _WritePixel_256;external;
Procedure  _GetPixel_256;external;
Procedure  _Line_256;external;
Procedure  _SolidRect_256;external;
Procedure  _CopyBlock_256;external;
Procedure  _CopyFromMem_256;external;
Procedure  _CopyToMem_256;external;
Procedure  _OutTextXY_256;external;
Procedure  _SetChars_256;external;
Procedure  _GetActPage_256;external;

{****************************************************************************}
{***                          VGA/VESA elj†r†sok                          ***}
{****************************************************************************}

Function _GetSVGAInfo:word;assembler;
{ SVGA info lekÇrdezÇse a V_SVGAInfo v†ltoz¢ba }
Asm
        MOV     AX,SEG V_SVGAInfo
        MOV     ES,AX
        MOV     DI,OFFSET V_SVGAInfo
        MOV     AX,$4F00
        INT     $10
END;

Function _GetVESAInfo(K:WORD):word;assembler;
{ <K> m¢dhoz tartoz¢ VESA info lekÇrdezÇse a V_VESAInfo v†ltoz¢ba }
asm
        MOV     AX,SEG V_VESAInfo
        MOV     ES,AX
        MOV     DI,OFFSET V_VESAInfo
        MOV     AX,$4F01
        MOV     CX,K
        INT     $10
END;

Procedure _SelectPage_VESA;far;assembler;{belsã assembly elj†r†s}
{ Lapoz†s a VESA megszak°t†son keresztÅl - DL: PageNum }
Asm



        PUSH    DS
        PUSH    ES
        PUSH    AX
        PUSH    BX
        PUSH    DX
        MOV     AX,Seg V_VESAGran
        MOV     DS,AX
        XOR     BX,BX
        MOV     BL,DL
	MOV	AX,64
	XOR	DX,DX
	DIV	V_VESAGran
	MUL	BX
	MOV	DX,AX
	MOV	AX,4F05h
	MOV	BX,0000h
	INT	10h
	POP	DX
	POP	BX
	POP	AX
        POP     ES
        POP     DS
End;

Procedure _No_SelectPage;far;assembler;
{ Nincs lapoz†s }
Asm
End;

Function _SetMode_VESA(Mode:word):word;Assembler;
{ <Mode> VESA m¢d be†ll°t†sa }
Asm
        PUSH    DS
        CALL    _GetSVGAInfo
        CMP     AX,$004F
        JNZ     @NoVESA         { Nincs VESA driver                          }
        PUSH    Mode
        CALL    _GetVESAInfo
        CMP     AX,$004F
        JNZ     @NoVESAMode     { Nem ba†ll°that¢ VESA m¢d                   }
        MOV     BX,Mode
        MOV     AX,$4F02
        INT     $10             { OK, VESA m¢d be†ll°t†sa                    }
        CMP     AX,$004F
        JNZ     @NoVESAModeSet  { Nem sikerÅlt a VESA m¢d be†ll°t†sa         }
        XOR     AX,AX           { AX=0 OK                                    }
        JMP     @End
@NoVesa:
        MOV     AX,1            { Nincs VESA driver                          }
        JMP     @End
@NoVesaMode:
        MOV     AX,2            { VESA info lekÇrdezÇse nem sikerÅlt         }
        JMP     @End
@NoVesaModeSet:
        MOV     AX,3            { VESA m¢d be†ll°t†sa nem sikerÅlt           }
@End:   POP     DS
End;

Function _SetMode_VGA(Mode:byte):word;assembler;
{ <Mode> VGA m¢d be†ll°t†sa }
Asm
        XOR     AX,AX
        MOV     AL,Mode
        INT     $10
        XOR     AX,AX
End;

{****************************************************************************}
{***                       Video mem¢ria †ll°t†s                          ***}
{****************************************************************************}

Procedure SetVideoMem(XX,YY:word);assembler;
Asm
        MOV     AX,$4F07
        XOR     BX,BX
        MOV     DX,YY
        MOV     CX,XX
        INT     $10
End;

{****************************************************************************}
{***                   Relat°v koordin†t†k be†ll°t†sa                     ***}
{****************************************************************************}

Procedure SetRelCord(XX,YY:word);
Begin
RelX:=XX;RelY:=YY;
End;

{****************************************************************************}
{***                  Relat°v koordin†t†k lekÇrdezÇse                     ***}
{****************************************************************************}

Function GetRelX:word;
Begin
GetRelX:=RelX;
End;

Function GetRelY:word;
Begin
GetRelY:=RelY;
End;

{****************************************************************************}
{***                 V†rakoz†s az elektronsug†r visszafut†sra             ***}
{****************************************************************************}

Procedure WaitPic;Assembler;
Asm
        MOV   DX,$03da
@Wait:  IN    AL,DX
        AND   AL,8
        JZ    @Wait
End;



{****************************************************************************}
{***             SegÇdelj†r†sok a grafikus video m¢d be†ll°t†shoz         ***}
{****************************************************************************}

Const
     C_data_350 : ARRAY[0..7]  OF byte=($83,$85,$5D,$28,$0F,$63,$BA,$e3);
     C_data_480 : ARRAY[0..23] OF byte=($2D,$27,$28,$90,$2B,$80,$0b,$3e,
                                      $00,$40,$00,$00,$00,$00,$00,$00,
                                      $ea,$8c,$df,$14,$00,$e7,$04,$e3);
     C_data_720 : Array[0..5]  of byte=($6B,$59,$5A,$8E,$5E,$8A);




Procedure _To720(clock:byte);
var k,i:Word;
Begin
portw[$3c2]:=clock;portw[$3d4]:=$0e11;
for i:=0 to 5 do begin k:=256*word(C_data_720[i])+i;portw[$3d4]:=k;end;
portw[$3d4]:=$2d13;portw[$3d4]:=$8e11;
End;

Procedure _S320x350_16; Assembler;
Asm
   mov   dx,$3C2
   mov   al,$A3
   out   dx,al
   lea   si,C_DATA_350;
   mov   cx,8
   mov   dx,$3D4
   mov   ax,$4009
   out   dx,ax
   mov   al,$10
@Set_regs:
   mov   ah,[si]
   out   dx,ax
   inc   al
   inc   si
   loop  @Set_regs
   mov   ax,$1413
   out   dx,ax
End;

Procedure _S320x480_16; Assembler;
Asm
   mov   dx,$3C4
{$IFDEF SeqRESET}
   mov   ax,$0100
   out   dx,ax
{$ENDIF}
   mov   ax,$0901
   out   dx,ax
{$IFDEF SeqRESET}
   mov   ax,$0300
   out   dx,ax
{$ENDIF}
   lea   si,C_DATA_480
   mov   cx,$18
   mov   dx,$3D4
   mov   ax,$0011
   out   dx,ax
   xor   al,al
@Set_regs:
   mov   ah,[si]
   out   dx,ax
   inc   al
   inc   si
   loop  @Set_regs
End;

Procedure _InitVideoMode(VBP,LS,PgS,PgO:word);assembler;
Asm
        MOV     ES,PgS
        MOV     DI,PgO
        MOV     DX,LS
        MOV     CX,16
        CMP     VBP,4
        JNZ     @No16Col
        CALL    _SetMode_16
        JMP     @Exit
@No16Col:
        CMP     VBP,8
        JNZ     @No256Col
        CALL    _SetMode_256
        JMP     @Exit
@No256Col:
@Exit:
End;

{****************************************************************************}
{***                   Grafikus video m¢d be†ll°t†s                       ***}
{****************************************************************************}

Function SetGraphMode(Mode:word):word;
{ <Mode> vide¢ m¢d be†ll°t†sa      Fv:0=OK 1..=Hibak¢dok                     }
const Constant:real=3.1415926/180;
var I,J:word;
Begin
If (Mode>C_MaxVideoMode) or (Mode=0) then begin SetGraphMode:=4;Exit;end;
{for I:=0 to 300 do
    for J:=0 to 45 do
        begin
        SinRadiusTable[J,I]:=trunc(sin(J*Constant)*I);
        CosRadiusTable[J,I]:=trunc(cos(J*Constant)*I);
	end;}
With C_VideoMode[Mode] do
     Case ModeType of
          0 : begin
              SetGraphMode:=_SetMode_VGA(lo(ModeNum));C_VBP:=BitPixel;
              _InitVideoMode(BitPixel,LSize,Seg(_No_SelectPage),Ofs(_No_SelectPage));
              end;
          1 : begin
              SetGraphMode:=_SetMode_VESA(ModeNum);C_VBP:=BitPixel;V_VESAGran:=V_VESAInfo.Window_MoveMem;
              _InitVideoMode(BitPixel,LSize,Seg(_SelectPage_VESA),Ofs(_SelectPage_VESA));
              end;
          2 : begin
              SetGraphMode:=_SetMode_VGA(lo(ModeNum));C_VBP:=BitPixel;
              _InitVideoMode(BitPixel,LSize,Seg(_No_SelectPage),Ofs(_No_SelectPage));
              Case Mode of
                   _320x240_16 : begin portw[$3d4]:=$4009;;_S320x480_16;portw[$3d4]:=$c009;end;
                   _320x350_16 : _S320x350_16;
                   _320x400_16 : PortW[$3d4]:=$4009;
                   _320x480_16 : begin portw[$3d4]:=$4009;;_S320x480_16;end;
                   _640x240_16 : PortW[$3d4]:=$c009;
                   _640x400_16 : PortW[$3d4]:=$4009;
                   _720x400_16 : begin portw[$3d4]:=$4009;_To720($67);end;
                   _720x480_16 : _To720($e7);
                   end;
              end;
          end;
C_ActMode:=Mode;ROM_8x14;
End;

{****************************************************************************}
{***                   Grafikus video m¢d lekÇrdezÇs                      ***}
{****************************************************************************}

Function GetMode:word;
Begin
{GetMode:=C_VideoMode[C_ActMode].ModeNum;}
GetMode:=C_ActMode;
End;

Function GetMaxX:word;
Begin
GetMaxX:=C_VideoMode[C_ActMode].MaxX;
End;

Function GetMaxY:word;
Begin
GetMaxY:=C_VideoMode[C_ActMode].MaxY;
End;

Function GetMaxColor:longint;
Begin
GetMaxColor:=Longint(1) SHL C_VBP;
End;

{****************************************************************************}
{***                      Grafikus elj†r†sok                              ***}
{****************************************************************************}

Procedure ClearScreen(Color:byte);assembler;
Asm
        MOV      BL,Color
        CMP      C_VBP,4
        JNZ      @No16Col
        CALL     _ClearScreen_16
        JMP      @Exit
@No16Col:
        CMP     C_VBP,8
        JNZ     @No256Col
        CALL    _ClearScreen_256
        JMP     @Exit
@No256Col:
@Exit:
End;

Procedure PutPixel(X,Y:word;C:byte);assembler;
Asm
        MOV     DX,Y
        ADD     DX,RelY
        MOV     CX,X
        ADD     CX,RelX
        MOV     BL,C
        CMP     C_VBP,4
        JNZ     @No16Col
        CALL    _WritePixel_16
        JMP     @Exit
@No16Col:
        CMP     C_VBP,8
        JNZ     @No256Col
        CALL    _WritePixel_256
        JMP     @Exit
@No256Col:
@Exit:
End;

Function GetPixel(X,Y:word):byte;assembler;
Asm
        MOV     DX,Y
        ADD     DX,RelY
        MOV     CX,X
        ADD     CX,RelX
        CMP     C_VBP,4
        JNZ     @No16Col
        CALL    _GetPixel_16
        JMP     @Exit
@No16Col:
        CMP     C_VBP,8
        JNZ     @No256Col
        CALL    _GetPixel_256
        JMP     @Exit
@No256Col:
@Exit:
End;

Procedure Line(X1,Y1,X2,Y2:word); assembler;
Asm
        MOV     CX,X1
        ADD     CX,RelX
        MOV     DX,Y1
        ADD     DX,RelY
        MOV     SI,X2
        ADD     SI,RelX
        MOV     DI,Y2
        ADD     DI,RelY
        MOV     BL,C_InkColor
        CMP     C_VBP,4
        JNZ     @No16Col
        CALL    _Line_16
        JMP     @Exit
@No16Col:
        CMP     C_VBP,8
        JNZ     @No256Col
        CALL    _Line_256
        JMP     @Exit
@No256Col:
@Exit:
End;

Procedure Rectangle(X1,Y1,X2,Y2:word);assembler;
Asm
        MOV     AX,X1
        ADD     DX,RelX
        PUSH    AX
        MOV     AX,Y1
        ADD     DX,RelY
        PUSH    AX
        MOV     AX,X1
        ADD     DX,RelX
        PUSH    AX
        MOV     AX,Y2
        ADD     DX,RelY
        PUSH    AX
        CALL    Line

        MOV     AX,X2
        ADD     DX,RelX
        PUSH    AX
        MOV     AX,Y1
        ADD     DX,RelY
        PUSH    AX
        MOV     AX,X2
        ADD     DX,RelX
        PUSH    AX
        MOV     AX,Y2
        ADD     DX,RelY
        PUSH    AX
        CALL    Line

        MOV     AX,X1
        ADD     DX,RelX
        PUSH    AX
        MOV     AX,Y1
        ADD     DX,RelY
        PUSH    AX
        MOV     AX,X2
        ADD     DX,RelX
        PUSH    AX
        MOV     AX,Y1
        ADD     DX,RelY
        PUSH    AX
        CALL    Line

        MOV     AX,X1
        ADD     DX,RelX
        PUSH    AX
        MOV     AX,Y2
        ADD     DX,RelY
        PUSH    AX
        MOV     AX,X2
        ADD     DX,RelX
        PUSH    AX
        MOV     AX,Y2
        ADD     DX,RelY
        PUSH    AX
        CALL    Line
End;

Procedure Bar(X1,Y1,X2,Y2:word); assembler;
Asm
        MOV     CX,X1
        ADD     CX,RelX
        MOV     DX,Y1
        ADD     DX,RelY
        MOV     SI,X2
        ADD     SI,RelX
        MOV     DI,Y2
        ADD     DI,RelY
        MOV     BL,C_InkColor
        CMP     C_VBP,4
        JNZ     @No16Col
        CALL    _SolidRect_16
        JMP     @Exit
@No16Col:
        CMP     C_VBP,8
        JNZ     @No256Col
        CALL    _SolidRect_256
        JMP     @Exit
@No256Col:
@Exit:
End;

{****************************************************************************}
{***                  CopyBlock/CopyMem elj†r†sok                         ***}
{****************************************************************************}

Procedure CopyBlock(X1,Y1,X2,Y2,DXx,DYy:word);assembler;
Asm
        PUSH    BP
        MOV     CX,X1
        ADD     CX,RelX
        MOV     DX,Y1
        ADD     DX,RelY
        MOV     SI,X2
        ADD     SI,RelX
        MOV     DI,Y2
        ADD     DI,RelY
        MOV     AX,DXx
        MOV     BX,DYy
        CMP     C_VBP,4
        JNZ     @No16Col
        MOV     BP,BX
        MOV     BL,C_CopyXOR
        CALL    _CopyBlock_16
        JMP     @Exit
@No16Col:
        CMP     C_VBP,8
        JNZ     @No256Col
        CALL    _CopyBlock_256
        JMP     @Exit
@No256Col:
@Exit:
        POP     BP
End;

Procedure CopyFromMem(X1,Y1,DXx,DYy,MDx:word;var Dst);assembler;
Asm
        PUSH    DS
        MOV     CX,X1
        ADD     CX,RelX
        MOV     DX,Y1
        ADD     DX,RelY
        MOV     AX,DXx
        MOV     BX,DYy
        MOV     DI,MDx
        CMP     C_VBP,4
        JNZ     @No16Col
        LDS     SI,Dst
        CALL    _CopyFromMem_16
        JMP     @Exit
@No16Col:
        CMP     C_VBP,8
        JNZ     @No256Col
        LDS     SI,Dst
        CALL    _CopyFromMem_256
        JMP     @Exit
@No256Col:
@Exit:
        POP   DS
End;

Procedure CopyToMem(X1,Y1,DXx,DYy,MDx:word;var Src);assembler;
Asm
        PUSH    DS
        MOV     CX,X1
        ADD     CX,RelX
        MOV     DX,Y1
        ADD     DX,RelY
        MOV     AX,DXx
        MOV     BX,DYy
        MOV     DI,MDx
        CMP     C_VBP,4
        JNZ     @No16Col
        LDS     SI,Src
        CALL    _CopyToMem_16
        JMP     @Exit
@No16Col:
        CMP     C_VBP,8
        JNZ     @No256Col
        LDS     SI,Src
        CALL    _CopyToMem_256
        JMP     @Exit
@No256Col:
@Exit:
        POP     DS
End;

Function GetActPage:byte;assembler;
Asm
        CMP     C_VBP,4
        JNZ     @No16Col
        CALL    _GetActPage_16
        JMP     @Exit
@No16Col:
        CMP     C_VBP,8
        JNZ     @No256Col
        CALL    _GetActPage_256
        JMP     @Exit
@No256Col:
@Exit:
End;

Procedure SetActPage(PG:word);assembler;
Asm
        MOV     DX,PG
        CMP     C_VBP,4
        JNZ     @No16Col
        CALL    _Select_Page_16
        JMP     @Exit
@No16Col:
        CMP     C_VBP,8
        JNZ     @No256Col
        CALL    _Select_Page_256
        JMP     @Exit
@No256Col:
@Exit:
End;

{****************************************************************************}
{***                                                                      ***}
{***    TextColor/TextBackColor/TextOver/RGB/Palette/Border †ll°t†sok     ***}
{***                                                                      ***}
{****************************************************************************}


Procedure SetColor(Color:byte);assembler;
Asm
   MOV  AL,Color
   MOV  C_InkColor,AL
End;

Procedure SetTextBackColor(Color:byte);assembler;
Asm
   MOV  AL,Color
   MOV  C_TextBackColor,AL
End;

Procedure SetTextOver(Over:byte);assembler;
Asm
   MOV  AL,Over
   MOV  C_TextOver,AL
End;

Procedure SetBorder(C:byte);assembler;
Asm
        MOV     AX,$1001
        MOV     BH,C
        INT     $10
End;

Procedure SetRGBreg(RegNum,Red,Green,Blue:byte); Assembler;
Asm
        MOV     DX,03c8h
        MOV     AL,RegNum
        OUT     DX,AL
        INC     DX
        MOV     AL,Red
        OUT     DX,AL
        MOV     AL,Green
        OUT     DX,AL
        MOV     AL,Blue
        OUT     DX,AL
End;

Procedure GetRGBreg(RegNum:byte; var RGB ); Assembler;
Asm
        CLD
        LES     DI,RGB
        MOV     DX,03c7h
        MOV     AL,RegNum
        OUT     DX,AL
        ADD     DL,2
        IN      AL,DX
        STOSB
        IN      AL,DX
        STOSB
        IN      AL,DX
        STOSB
End;

Procedure SetPalette(e,f:word;var t);assembler;
Asm
        MOV     AX,$1012
        MOV     BX,E
        MOV     CX,f
        LES     DX,t
        INT     $10;
End;

Procedure GetPalette(e,f:word;var t);assembler;
Asm
        MOV     AX,$1017
        MOV     BX,e
        MOV     CX,f
        LES     DX,t
        INT     $10;
End;

{****************************************************************************}
{***                                                                      ***}
{***                    OutTextXY/OutStringXY elj†r†sok                   ***}
{***                                                                      ***}
{****************************************************************************}

Procedure OutTextXY(X,Y:word;var S);assembler;
Asm
        LES     DI,S
        MOV     CX,X
        ADD     CX,RelX
        MOV     DX,Y
        ADD     DX,RelY
        XOR     AX,AX
        MOV     AH,C_TextOver
        MOV     BL,C_InkColor
        MOV     BH,C_TextBackColor
        CMP     C_VBP,4
        JNZ     @No16Col
        CALL    _OuttextXY_16
        JMP     @Exit
@No16Col:
        CMP     C_VBP,8
        JNZ     @No256Col
        CALL    _OuttextXY_256
        JMP     @Exit
@No256Col:
@Exit:
End;


Procedure OutStringXY(X,Y:word;S:string);
Var SSs,SO:word;
Begin
If length(S)<255 then S:=S+chr(0) else S[255]:=chr(0);
SSs:=Seg(S);SO:=Ofs(S);
asm
        MOV     ES,SSs
        MOV     DI,SO
        INC     DI
        MOV     CX,X
        ADD     CX,RelX
        MOV     DX,Y
        ADD     DX,RelY
        MOV     AH,C_TextOver
        MOV     BL,C_InkColor
        MOV     BH,C_TextBackColor
        CMP     C_VBP,4
        JNZ     @No16Col
        CALL    _OuttextXY_16
        JMP     @Exit
@No16Col:
        CMP     C_VBP,8
        JNZ     @No256Col
        CALL    _OuttextXY_256
        JMP     @Exit
@No256Col:
@Exit:
end;
End;


{****************************************************************************}
{***                                                                      ***}
{***           Karakter gener†tor be†ll°t†sok/lekÇrdezÇsek                ***}
{***                                                                      ***}
{****************************************************************************}

Function GetCharX:word;
begin
GetCharX:=C_CharX;
end;

Function GetCharY:word;
begin
GetCharY:=C_CharY;
end;

Procedure GetChars(var TGCh:TGraph_CharsType);assembler;
Asm
        PUSH    DS
        CMP     C_VBP,4
        JNZ     @No16Col
        CALL    _GetMode_16
        JMP     @Exit
@No16Col:
        CMP     C_VBP,8
        JNZ     @No256Col
        CALL    _GetMode_256
        JMP     @Exit
@No256Col:
@Exit:
        LDS     SI,TgCh
        XCHG    SI,DI
        MOV     AX,DS
        MOV     DX,ES
        MOV     DS,DX
        MOV     ES,AX
        MOV     CX,12
        CLD
        REP     MOVSB
        POP     DS
End;

Procedure SetChars(var TGCh:TGraph_CharsType);assembler;
Asm
        PUSH    BP
        PUSH    DS
        LDS     DI,TgCh
        MOV     DX,DS:[DI]
        MOV     CX,DS:[DI+2]
        MOV     AX,DS:[DI+8]
        MOV     ES,AX
        MOV     AX,DS:[DI+4]
        MOV     SI,DS:[DI+6]
        MOV     BP,DS:[DI+10]
        MOV     BX,0
        POP     DS
        MOV     C_CharX,CX
        MOV     C_CharY,DX
        CMP     C_VBP,4
        JNZ     @No16Col
        CALL    _SetChars_16
        JMP     @Exit
@No16Col:
        CMP     C_VBP,8
        JNZ     @No256Col
        CALL    _SetChars_256
        JMP     @Exit
@No256Col:
@Exit:
        POP     BP
End;

Procedure ROM_8x8;assembler;
Asm
        PUSH    BP
        PUSH    ES
        PUSH    DS
        MOV     AX,1130h
        MOV     BH,03
        INT     $10
        MOV     AX,1
        MOV     CX,8
        MOV     DX,8
        MOV     SI,8
        MOV     BX,0
        MOV     C_CharX,CX
        MOV     C_CharY,DX
        CMP     C_VBP,4
        JNZ     @No16Col
        CALL    _SetChars_16
        JMP     @Exit
@No16Col:
        CMP     C_VBP,8
        JNZ     @No256Col
        CALL    _SetChars_256
        JMP     @Exit
@No256Col:
@Exit:
        POP     DS
        POP     ES
        POP     BP
End;

Procedure ROM_8x14;assembler;
Asm
        PUSH    BP
        PUSH    ES
        PUSH    DS
        MOV     AX,1130h
        MOV     BH,02
        INT     $10
        MOV     AX,1
        MOV     CX,8
        MOV     DX,14
        MOV     SI,14
        MOV     BX,0
        MOV     C_CharX,CX
        MOV     C_CharY,DX
        CMP     C_VBP,4
        JNZ     @No16Col
        CALL    _SetChars_16
        JMP     @Exit
@No16Col:
        CMP     C_VBP,8
        JNZ     @No256Col
        CALL    _SetChars_256
        JMP     @Exit
@No256Col:
@Exit:
        POP     DS
        POP     ES
        POP     BP
End;

Procedure ROM_8x16;assembler;
Asm
        PUSH    BP
        PUSH    ES
        PUSH    DS
        MOV     AX,1130h
        MOV     BH,06
        INT     $10
        MOV     AX,1
        MOV     CX,8
        MOV     DX,16
        MOV     SI,16
        MOV     BX,0
        MOV     C_CharX,CX
        MOV     C_CharY,DX
        CMP     C_VBP,4
        JNZ     @No16Col
        CALL    _SetChars_16
        JMP     @Exit
@No16Col:
        CMP     C_VBP,8
        JNZ     @No256Col
        CALL    _SetChars_256
        JMP     @Exit
@No256Col:
@Exit:
        POP     DS
        POP     ES
        POP     BP
End;

{****************************************************************************}
{***                                                                      ***}
{***                 Speci†lis keretrajzol¢ elj†r†sok                     ***}
{***                                                                      ***}
{****************************************************************************}

Procedure  BorderDraw_1a(x1,y1,dx,dy:word;col,sot,vil:byte);
var x2,y2:word;
begin
X1:=X1+RelX;Y1:=Y1++RelY;
x2:=x1+dx+4;y2:=y1+dy+4;
Setcolor(col);bar(x1,y1,x2,y2);
setcolor(sot);Line(x2,y1,x2,y2);Line(x2-1,y1+1,x2-1,y2);
Line(x1,y2,x2,y2);Line(x1+1,y2-1,x2,y2-1);
setcolor(vil);Line(x1,y1,x2-1,y1);Line(x1,y1,x1,y2-1);
Line(x1+1,y1,x1+1,y2-2);
end;

Procedure  BorderDraw_1b(x1,y1,dx,dy:word;col,sot,vil:byte);
var x2,y2:word;
begin
X1:=X1+RelX;Y1:=Y1++RelY;
x2:=x1+dx+3;y2:=y1+dy+3;
Setcolor(col);bar(x1,y1,x2,y2);
setcolor(sot);Line(x2,y1,x2,y2);Line(x1,y2,x2,y2);
setcolor(vil);Line(x1,y1,x2-1,y1);Line(x1,y1,x1,y2-1)
end;

Procedure BorderDraw_2a(x1,y1,dx,dy:word;col,sot,vil:byte);
var x2,y2:word;
begin
X1:=X1+RelX;Y1:=Y1++RelY;
x2:=x1+dx+5;y2:=y1+dy+5;setcolor(col);Bar(x1+2,y1+2,x2-2,y2-2);
setcolor(vil);Line(x2-1,y1+1,x2-1,y2-1);Line(x1+1,y2-1,x2-1,y2-1);
setcolor(sot);Line(x1+1,y1+1,x2-1,y1+1);Line(x1+1,y1+1,x1+1,y2-1);
Line(x1+2,y1+2,x2-2,y1+2);Line(x1+2,y1+2,x1+2,y2-2);
end;

Procedure BorderDraw_2b(x1,y1,dx,dy:word;col,sot,vil:byte);
var x2,y2:word;
begin
X1:=X1+RelX;Y1:=Y1++RelY;
x2:=x1+dx+4;y2:=y1+dy+4;setcolor(col);Bar(x1+1,y1+1,x2-1,y2-1);
setcolor(vil);Line(x2-1,y1+1,x2-1,y2-1);Line(x1+1,y2-1,x2-1,y2-1);
setcolor(sot);Line(x1+1,y1+1,x2-2,y1+1);Line(x1+1,y1+1,x1+1,y2-2);
end;

Procedure BorderDraw_3(x1,y1,dx,dy:word;col,sot,vil:byte);
var x2,y2:word;
begin
X1:=X1+RelX;Y1:=Y1++RelY;
x2:=x1+dx+4;y2:=y1+dy+4;
setcolor(col);Bar(x1+2,y1+2,x2-2,y2-2);
setcolor(SOT);Line(x2-1,y1+1,x2-1,y2-1);Line(x1+1,y2-1,x2-1,y2-1);
Line(x1+1,y1+1,x2-2,y1+1);Line(x1+1,y1+1,x1+1,y2-2);
setcolor(VIL);
Line(x2,y1+1,x2,y2);Line(x1+1,y2,x2,y2);
Line(x1+2,y1+2,x2-2,y1+2);Line(x1+2,y1+2,x1+2,y2-2);
end;


{****************************************************************************}
{***                          KÇp ki/bekapcsol†sa                         ***}
{****************************************************************************}

Procedure PictureOff;assembler;
Asm
        CLI
        MOV     AX,2001h
        MOV     DX,$03c4
        OUT     DX,AX
        STI
End;

Procedure PictureOn;assembler;
Asm
        CLI
        MOV     AX,0101h
        MOV     DX,$03c4
        OUT     DX,AX
        STI
End;

{****************************************************************************}
{***                        Èj elj†r†sok V1.1a -> V1.2a                   ***}
{****************************************************************************}
 {
Procedure Circle(X,Y,Radius:word);
var Angle,RealX,RealY, XPlusRealX,XMinusRealX,XPlusRealY,XMinusRealY,
YPlusRealY,YMinusRealY,YPlusRealX,YMinusRealX:word;
Begin
For Angle:=0 to 45 do
    begin
    RealX:=CosRadiusTable[Angle,Radius];
    RealY:=SinRadiusTable[Angle,Radius];
    XPlusRealX:=x+RealX; XPlusRealY:=x+RealY;
    XMinusRealX:=x-RealX; XMinusRealY:=x-RealY;
    YPlusRealY:=y+RealY; YPlusRealX:=y+RealX;
    YMinusRealY:=y-RealY; YMinusRealX:=y-RealX;
    PutPixel(XPlusRealX,YPlusRealY,C_InkColor);
    PutPixel(XPlusRealX,YMinusRealY,C_InkColor);
    PutPixel(XMinusRealX,YPlusRealY,C_InkColor);
    PutPixel(XMinusRealX,YMinusRealY,C_InkColor);
    PutPixel(XPlusRealY,YPlusRealX,C_InkColor);
    PutPixel(XPlusRealY,YMinusRealX,C_InkColor);
    PutPixel(XMinusRealY,YPlusRealX,C_InkColor);
    PutPixel(XMinusRealY,YMinusRealX,C_InkColor);
    end;
End;

Procedure _RecursiveFill(x,y:word;FillColor,Border:byte);
Var Direction:byte;
Begin
If (GetPixel(x,y)<>FillColor) and (GetPixel(x,y)<>Border)
   then begin
        Putpixel(X,Y,FillColor);
	For Direction:=1 to 4 do
            begin
	    If (Direction=1) and (y>0)
               then _RecursiveFill(x,y-1,FillColor,Border)
               else if (Direction=2) and (x<319)
                       then _RecursiveFill(x+1,y,FillColor,Border)
                       else if (Direction=3) and (y<199)
                               then _RecursiveFill(x,y+1,FillColor,Border)
                               else if (Direction=4) and (x>0)
                                       then _RecursiveFill(x-1,y,FillColor,Border);
	    end;
    	end;
End;

Procedure Fill(X,Y:word;FillColor,Border:byte);
Begin
Setcolor(FillColor);
_RecursiveFill(X,Y,FillColor,Border);
end;}

Function SavePicToXMS:word;
var fP:pointer;J:word;XMSK:longint;
Begin
If XMSHandle>0 then begin SavePicToXMS:=1;Exit;end;
If MaxAvail<(SavePic_YMeret+1)*GetMaxX then begin SavePicToXMS:=2;Exit;end;
If GetXMS(SavePic_XMSSize,XMSHandle)<>0 then begin SavePicToXMS:=3;Exit;end;
GetMem(fP,(SavePic_YMeret+1)*GetMaxX);XMSK:=0;
For J:=1 to SavePic_SavePageNum*(GetMaxY div SavePic_YMeret) do
 begin
 CopyToMem  (0,(J-1)*SavePic_YMeret,GetMaxX,SavePic_YMeret,GetMaxX,fP^);
 If MoveXMS(SavePic_YMeret*GetMaxX,0,Seg(fP^),Ofs(fP^),XMSHandle,XMSK div 65536,XMSK mod 65536)<>0
  then begin SavePicToXMS:=4;Exit;end;
 XMSK:=XMSK+SavePic_YMeret*GetMaxX;
 end;
GetPalette(0,255,SavePalette);
FreeMem(fP,(SavePic_YMeret+1)*GetMaxX);SavePicToXMS:=0;
End;

Function RestorePicFromXMS:word;
var fP:pointer;J:word;XMSK:longint;
Begin
If XMSHandle=0 then begin RestorePicFromXMS:=1;Exit;end;
If MaxAvail<(SavePic_YMeret+1)*GetMaxX then begin RestorePicFromXMS:=2;Exit;end;
GetMem(fP,(SavePic_YMeret+1)*GetMaxX);XMSK:=0;SetPalette(0,255,SavePalette);
For J:=1 to SavePic_SavePageNum*(GetMaxY div SavePic_YMeret) do
 begin
 If MoveXMS(SavePic_YMeret*GetMaxX,XMSHandle,XMSK div 65536,XMSK mod 65536,0,Seg(fP^),Ofs(fP^))<>0
  then begin RestorePicFromXMS:=4;Exit;end;
 CopyFromMem(0,(J-1)*SavePic_YMeret,GetMaxX,SavePic_YMeret,GetMaxX,fp^);
 XMSK:=XMSK+SavePic_YMeret*GetMaxX;
 end;
FreeMem(fP,(SavePic_YMeret+1)*GetMaxX);FreeXMS(XMSHandle);
XMSHandle:=0;RestorePicFromXMS:=0;
End;

{****************************************************************************}
{****************************************************************************}
{***                                                                      ***}
{***                            TWVideo End                               ***}
{***                                                                      ***}
{****************************************************************************}
{****************************************************************************}