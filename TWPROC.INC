{****************************************************************************}
{***                                                                      ***}
{***                      Turbo Pascal TWProc Unit                        ***}
{***                            1.0a Verzi¢                               ***}
{***                                                                      ***}
{***               (C) TwinNet 1998  (P) Szab¢ Andr†s 1997/98             ***}
{***                                                                      ***}
{***                      1997.02.16.  - 2000.01.07.                      ***}
{***                                                                      ***}
{****************************************************************************}


Const
   C_TProcOn       : byte  = 0;    { TProc bekapcsol†s jelzã                }

{****************************************************************************}
{***                        Mouse mask Çs shape                           ***}
{****************************************************************************}

  _MouseMask                    : array [1..16,1..16] of byte =
                   ( (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
                     (1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
                     (1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0),
                     (1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0),
                     (1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0),
                     (1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0),
                     (1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0),
                     (1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0),
                     (1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0),
                     (1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0),
                     (1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0),
                     (1,1,1,0,1,1,1,1,0,0,0,0,0,0,0,0),
                     (1,1,0,0,1,1,1,1,0,0,0,0,0,0,0,0),
                     (0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0),
                     (0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0),
                     (0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0) );

   _MouseShape                  : array [1..16,1..16] of byte =
                   ( (00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00),
                     (00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00),
                     (00,15,00,00,00,00,00,00,00,00,00,00,00,00,00,00),
                     (00,15,15,00,00,00,00,00,00,00,00,00,00,00,00,00),
                     (00,15,15,15,00,00,00,00,00,00,00,00,00,00,00,00),
                     (00,15,15,15,15,00,00,00,00,00,00,00,00,00,00,00),
                     (00,15,15,15,15,15,00,00,00,00,00,00,00,00,00,00),
                     (00,15,15,15,15,15,15,00,00,00,00,00,00,00,00,00),
                     (00,15,15,15,15,15,15,15,00,00,00,00,00,00,00,00),
                     (00,15,15,15,15,15,00,00,00,00,00,00,00,00,00,00),
                     (00,15,15,00,15,15,00,00,00,00,00,00,00,00,00,00),
                     (00,15,00,00,00,15,15,00,00,00,00,00,00,00,00,00),
                     (00,00,00,00,00,15,15,00,00,00,00,00,00,00,00,00),
                     (00,00,00,00,00,00,15,15,00,00,00,00,00,00,00,00),
                     (00,00,00,00,00,00,15,15,00,00,00,00,00,00,00,00),
                     (00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00) );

    _MouseAct                   :  boolean = TRUE;  { Saj†t egÇr megjelen°tÇs}
    _MouseMinX                  :  word    = 0;     { Mouse terÅlet          }
    _MouseMinY                  :  word    = 0;     { Mouse terÅlet          }
    _MouseMaxX                  :  word    = 0;     { Mouse terÅlet          }
    _MouseMaxY                  :  word    = 0;     { Mouse terÅlet          }

Var
    _MouseBackGround            : array [1..16,1..16] of byte;

{****************************************************************************}
{***                                                                      ***}
{***                     TProc assembler rutinjai                         ***}
{***                                                                      ***}
{****************************************************************************}

{$L TPROC.OBJ }
Procedure _TProcOn;External;
Procedure _TProcOff;External;
Procedure _Get_Command_From_Puffer;External;
Procedure _Put_Command_To_Puffer;External;
Procedure _GetTProcInfo;External;
Procedure _SetTimer;External;
Procedure _ClearCommandPuffer;External;
Procedure _SetTProcFlag;External;
Procedure _SetMouseEvent;External;
Procedure _SetTimeCounter;External;
Procedure _GetTimeCounter;External;


{****************************************************************************}
{***                       Saj†t egÇr megjelen°tÇs                        ***}
{****************************************************************************}

Procedure SaveMouseBack(XX,YY:word);
Begin
CopyToMem(XX,YY,16,16,GetMaxX,_MouseBackGround);
End;

Procedure RestoreMouseBack(XX,YY:word);
Begin
CopyFromMem(XX,YY,16,16,GetMaxX,_MouseBackGround);
End;

Procedure ShowMouseShape(XX,YY:word);
var i,j:word;
Begin
For j:=1 to 16 do
    If (YY+J-1)<_MouseMaxY then
       for i:=1 to 16 do
           if _MouseMask[j,i]=1 then
              if (XX+I-1)<_MouseMaxX then PutPixel(XX+i-1,YY+j-1,_MouseShape[j,i]);
End;

Function GetMouseAct:boolean;
Begin
GetMouseAct:=_MouseAct;
End;

Procedure ShowMousePos(MX,MY:word);
Begin
If MouseTilt=2 then Exit;
If MouseTilt=0 then RestoreMouseBack(OldMouseX,OldMouseY);
SaveMouseBack(MX,MY);OldMouseX:=MX;OldMouseY:=MY;
If MouseTilt=0 then ShowMouseShape(MX,MY);
End;

Procedure MyMouseInt;assembler;
Asm
        PUSH    DS
        MOV     AX,Seg V_SVGAInfo
        MOV     DS,AX
        MOV     AX,NoMouse
        OR      AX,AX
        JNZ     @MMI_Exit
        CALL    GetActPage
        PUSH    AX
        PUSH    CX
        PUSH    DX
        CALL    ShowMousePos
        CALL    SetActPage
@MMI_Exit:
        POP     DS
End;

{****************************************************************************}
{***                       EgÇr kezelÇs VGA m¢dban                        ***}
{****************************************************************************}

Function MouseInit(Ma:boolean;PR:word;MDVX,MDVY:byte):word;
var BSZ:word;
Begin
Asm
   XOR AX,AX
   INT $33
   XOR CX,CX
   CMP AX,$FFFF
   JNZ @Exit
   MOV CX,BX
@Exit: MOV BSZ,CX
end;
If BSZ=0 then _MouseAct:=FALSE else _MouseAct:=Ma;
If _MouseAct=True
   then begin
        MouseDivX:=MDVX;MouseDivY:=MDVY;MousePR:=PR;
        SetMouseResolution(PR,PR);
        SetMouseArea(0,0,GetMaxX-2,GetMaxY-2);
        SaveMouseBack(GetMouseX,GetMouseY);
        SetMouseEvent(Seg(MyMouseInt),Ofs(MyMouseInt));
        end;
MouseInit:=BSZ;
End;

Procedure MouseShow;
var MX,MY:word;
Begin
If MouseTilt=2 then Exit;
If _MouseAct
   then If NoMouse=1
           then begin
                NoMouse:=2;
                MX:=GetMouseX;MY:=GetMouseY;SaveMouseBack(MX,MY);
                ShowMouseShape(MX,MY);OldMouseX:=MX;OldMouseY:=MY;
                NoMouse:=0;
                end
           else
   else Asm MOV AX,$0001;INT $33 end;
End;

Procedure MouseHide;
Begin
If MouseTilt=2 then Exit;
If _MouseAct
   then If NoMouse=0
           then begin
                NoMouse:=2;
                RestoreMouseBack(OldMouseX,OldMouseY);
                NoMouse:=1;
                end
           else
   else Asm MOV AX,$0002;INT $33 end;
End;

{****************************************************************************}
{***                          Mouse lekÇrdezÇsek                          ***}
{****************************************************************************}

Function GetMouseX:word;assembler;
Asm
        MOV     AX,$0003
        INT     $33
        MOV     AX,CX
        MOV     CL,MouseDivX
        SHR     AX,CL
end;

Function GetMouseY:word;assembler;
Asm
        MOV     AX,$0003
        INT     $33
        MOV     AX,DX
        MOV     CL,MouseDivX
        SHR     AX,CL
end;

Function GetMouseButton:byte;assembler;
Asm
        MOV     AX,$0003
        INT     $33
        MOV     AL,BL
end;

{****************************************************************************}
{***                     Mouse paramÇterek be†ll°t†sa                     ***}
{****************************************************************************}

Procedure SetMousePos(X,Y:word);assembler;
Asm
        MOV     AX,X
        MOV     CL,MouseDivX
        SHL     AX,CL
        MOV     DX,Y
        MOV     CL,MouseDivY
        SHL     DX,CL
        MOV     CX,AX
        MOV     AX,$0004
        INT     $033
End;

Procedure SetMouseArea(X1,Y1,X2,Y2:word);assembler;
Asm
        XOR     BX,BX
        MOV     AX,X1
        MOV     _MouseMinX,AX
        MOV     CL,MouseDivX
        SHL     AX,CL
        MOV     DX,X2
        MOV     _MouseMaxX,DX
        MOV     CL,MouseDivX
        SHL     DX,CL
        MOV     CX,AX
        MOV     AX,$0007
        INT     $33
        XOR     BX,BX
        MOV     AX,Y1
        MOV     _MouseMinY,AX
        MOV     CL,MouseDivX
        SHL     AX,CL
        MOV     DX,Y2
        MOV     _MouseMaxY,DX
        MOV     CL,MouseDivX
        SHL     DX,CL
        MOV     CX,AX
        MOV     AX,$0008
        INT     $33
End;

Procedure SetMousePointer(Ddx,Ddy:integer; var Src);assembler;
Asm
        MOV     BX,Ddx
        MOV     CX,Ddy
        LES     DX,Src
        MOV     AX,$0009
        INT     $33
End;


Procedure SetNoMouseArea(X1,Y1,X2,Y2:word);assembler;
Asm
        XOR     BX,BX
        MOV     CX,X1
        MOV     DX,Y1
        MOV     SI,X2
        MOV     DI,Y2
        MOV     AX,$0010
        INT     $33
End;

Procedure SetMouseResolution(Rx,Ry:word);assembler;
Asm
        XOR   BX,BX
        MOV   CX,Rx
        MOV   DX,Ry
        MOV   AX,$000F
        INT   $33
End;

Procedure SetMouseFunction(Mask:word;Proc:pointer);assembler;
Asm
        MOV     CX,Mask
        MOV     AX,$000C
        LES     DX,Proc
        INT     $33
End;

Procedure SetMouseShape(dDx,dDy:integer;var Src);assembler;
Asm
        MOV     BX,dDx
        MOV     CX,Ddy
        LES     DX,Src
        MOV     AX,$0009
        INT     $33
End;

{****************************************************************************}
{****************************************************************************}
{***                        TProc elj†r†sok                               ***}
{****************************************************************************}
{****************************************************************************}

{****************************************************************************}
{***                 TProc bekapcsol†sa/kikapcsol†sa                      ***}
{****************************************************************************}

Procedure TProcON;assembler;
Asm
        XOR     AL,AL
        CMP     AL,C_TProcOn
        JNZ     @Exit
        MOV     AL,MouseDivX
        MOV     AH,MouseDivY
        Call    _TProcOn
        INC     C_TProcOn
@Exit:
End;

Procedure TProcOff;assembler;
Asm
        XOR     AL,AL
        CMP     AL,C_TProcOn
        JZ      @Exit
        CALL    _TProcOff;
        DEC     C_TProcOn
@Exit:
End;

{****************************************************************************}
{***                                                                      ***}
{***                 Kîvetkezî Command lekÇrdezÇse                        ***}
{***                                                                      ***}
{***          Be: -                                                       ***}
{***          Ki: GetCommand: CommandPufferben lÇvî Command-ok sz†ma      ***}
{***                      _C: Command                                     ***}
{***                                                                      ***}
{****************************************************************************}

Function GetCommand(var _C:CommandType):word;assembler;
Asm
        LES     DI,_C
        XOR     AX,AX
        CALL    _Get_Command_From_Puffer
        MOV     AX,BX
End;

{****************************************************************************}
{***                                                                      ***}
{***               Command elhelyezÇse a CommandPufferban                 ***}
{***                                                                      ***}
{***          Be: CommandType, CommandCode, Prior (0/1)                   ***}
{***          Ki: PutCommand: Hibak¢d                                     ***}
{***                          0: OK                                       ***}
{***                          1: A CommandPuffer tele van                 ***}
{***                          2: A PutCommand tiltott                     ***}
{***                                                                      ***}
{****************************************************************************}

Function PutCommand(CommandType,CommandCode,Prior,P1,P2:word):word;assembler;
Asm
        CLI
        MOV     CX,CommandCode
        MOV     SI,CommandType
        MOV     DX,Prior
        MOV     AX,P1
        MOV     BX,P2
        Call    _Put_Command_To_Puffer
        STI
End;

{****************************************************************************}
{***                                                                      ***}
{***                       Idîz°tî be†l°t†sa                              ***}
{***                                                                      ***}
{***          Be: TimeNum, Time, Command, Prior (0/1)                     ***}
{***          Ki: -                                                       ***}
{***                                                                      ***}
{****************************************************************************}

Procedure SetTimer(TimeNum,Time,Command,Prior,P1,P2:word);assembler;
Asm
        MOV     BX,TimeNum
        MOV     CX,Time
        MOV     SI,Command
        MOV     DX,Prior
        MOV     AX,P1
        MOV     DI,P2
        CALL    _SetTimer
End;

{****************************************************************************}
{***                       CommandPuffer tîrlÇse                          ***}
{****************************************************************************}

Procedure ClearCommandPuffer;assembler;
Asm
        CALL    _ClearCommandPuffer
End;

{****************************************************************************}
{***                                                                      ***}
{***                       TProcInfo lekÇrdezÇse                          ***}
{***                                                                      ***}
{***          Be: -                                                       ***}
{***          Ki: ES:SI= CommandPuffer c°me                               ***}
{***              ES:DI= _MouseInt c°me                                   ***}
{***              ES:DX= Key_Table c°me                                   ***}
{***                 BX= Commandok sz†ma a pufferban                      ***}
{***                 CX= TProcFlag                                        ***}
{***                 AX= Utolj†ra lenyomott billentyÅ k¢dja               ***}
{***                                                                      ***}
{****************************************************************************}

Procedure TProcInfo;assembler;
Asm
        CALL    _GetTProcInfo
End;

{****************************************************************************}
{***                                                                      ***}
{***                       TProcFlag †ll°t†s                              ***}
{***                                                                      ***}
{***          Be: TProcFlag                                               ***}
{***              xxxxxxxxxxxxxxx1 : PutCommand tiltott                   ***}
{***              xxxxxxxxxxxxxx1x : MouseCommand tiltott                 ***}
{***              xxxxxxxxxxxxx1xx : KeyCommand tiltott                   ***}
{***              xxxxxxxxxxxx1xxx : TimerCommand tiltott                 ***}
{***              xxxxxxxxxxx1xxxx : GetComand tiltott                    ***}
{****************************************************************************}

Procedure SetTProcFlag(Flg:word);assembler;
Asm
        MOV     DX,Flg
        CALL    _SetTProcFlag
End;

Procedure SetTimerNum(cnt:word);assembler;
Asm
   cli
   mov   al,00110110b
   out   043h,al
   mov   ax,cnt
   out   040h,al
   mov   al,ah
   out   040h,al
   sti
End;

{****************************************************************************}
{***                                                                      ***}
{***                       Mouse esemÇnyvezÇrlã                           ***}
{***                                                                      ***}
{***          Be: SSeg,OOfs : Segmens:Offset c°m                          ***}
{***          Ki: -                                                       ***}
{***                                                                      ***}
{****************************************************************************}

Procedure SetMouseEvent(SSeg,OOfs:word);assembler;
Asm
        MOV     AX,SSeg
        MOV     ES,AX
        MOV     DI,OOfs
        CALL    _SetMouseEvent
End;

{****************************************************************************}
{****************************** V†rakoz†s ***********************************}
{****************************************************************************}

Procedure Wait(WTime:word);assembler;
Asm
        XOR     DX,DX
        CALL    _SetTimeCounter
@WLoop: CALL    _GetTimeCounter
        CMP     AX,WTime
        JB      @WLoop
End;

Procedure ResetTimeCounter;assembler;
Asm
        XOR     DX,DX
        CALL    _SetTimeCounter
End;

Function GetTimeCounter:word;assembler;
Asm
CALL    _GetTimeCounter
End;

Procedure SetTimerCount(cnt:word);assembler; { 2000.01.07.}
Asm { 23863 = 50.001 IRQ/sec }
   cli
   mov   al,00110110b
   out   043h,al
   mov   ax,cnt
   out   040h,al
   mov   al,ah
   out   040h,al
   sti
End;


{****************************************************************************}
{****************************************************************************}
{***                                                                      ***}
{***                            TWVideo End                               ***}
{***                                                                      ***}
{****************************************************************************}
{****************************************************************************}