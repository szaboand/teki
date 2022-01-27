Unit TOBJECT;
{*****************************************************************************
******************************************************************************
*                        TObject 4.3 (01) Verzi¢                             *
*                       1997.04.02. - 2000.07.05.                            *
*                        Szab¢ Andr†s 1984-2000                              *
*                      (C) TwinNet Kft. 1995-2000                            *
******************************************************************************
*****************************************************************************}

Interface

Uses TWSys{V2.0d};

{****************************************************************************}
{***                                                                      ***}
{***                          TObject alapt°pus                           ***}
{***                                                                      ***}
{***                    (C) Szab¢ Andr†s 1997.05.27.                      ***}
{***                                                                      ***}
{****************************************************************************}

Type
 TObjectPointer   = ^TObjectType;
 TObjectType      = object                         { äs objektum t°pus       }
  ID          : word;                              { Egyedi azonos°t¢        }
  OType       : word;                              { T°pusazonos°t¢          }
  X,Y         : word;                              { X,Y koordin†ta          }
  DX,DY       : word;                              { SzÇlessÇg/Magass†g      }
  Flag        : word;                              { Objektum flagek         }
  Command     : CommandType;                       { Aktu†lis command        }
  NextTObject : TObjectPointer;                    { Kîvetkezã TObject       }
  PrevTObject : TObjectPointer;                    { Elîzã TObject           }
  Mask        : word;                              { EngedÇlyezã/Tilt¢ bitek }
  Group       : word;                              { Csoportjelzã k¢d        }

  Constructor Init(IDD,OOT,XX,YY,DXX,DYY:word);    { Inicializ†l¢ elj†r†s    }
  Destructor  Done;                                { Lebont¢ elj†r†s         }
  Procedure   Bind;                                { ôsszef˚zã elj†r†s       }
  Procedure   SetInit;virtual;                     { Kezdeti adat be†ll°t†s  }

  Procedure   Draw;virtual;                        { Rajzol¢ elj†r†s         }
  Procedure   Move(XX,YY:word);virtual;            { Mozgat¢ elj†r†s         }

  Procedure   Show;virtual;                        { Megjelen°tã elj†r†s     }
  Procedure   Hide;virtual;                        { EltÅntetã elj†r†s       }
  Procedure   On;virtual;                          { Bekapcsol†s             }
  Procedure   Off;virtual;                         { Kikapcsol†s             }
  Procedure   Disable;                             { Letilt†s                }
  Procedure   Enable;                              { EngedÇlyezÇs            }
  Procedure   DisableDraw;                         { Megjelen°tÇs tilt†sa    }
  Procedure   EnableDraw;                          { Megjelen°tÇs engedÇlyez }

  Procedure   KeyFocusOn;virtual;                  { Billenty˚ f¢kusz be     }
  Procedure   KeyFocusOff;virtual;                 { Billenty˚ f¢kusz ki     }
  Procedure   MouseFocusOn;virtual;                { Mouse f¢kusz be         }
  Procedure   MouseFocusOff;virtual;               { Mouse f¢kusz ki         }
  Procedure   SetKeyFocus;virtual;                 { Billenty˚ f¢kusz be†ll°t}

  Procedure   KeyPush;virtual;                     { Billenty˚ lenyom†s      }
  Procedure   KeyPop;virtual;                      { Billenty˚ felengedÇs    }

  Procedure   MouseMove;virtual;                   { Mouse mozg†s            }
  Procedure   MouseLeftButtonPush;virtual;         { Mouse bal gomb le       }
  Procedure   MouseLeftButtonPop;virtual;          { Mouse bal gomb fel      }
  Procedure   MouseRightButtonPush;virtual;        { Mouse jobb gomb le      }
  Procedure   MouseRightButtonPop;virtual;         { Mouse jobb gomb fel     }
  Procedure   MouseMiddleButtonPush;virtual;       { Mouse kîzÇpsã le        }
  Procedure   MouseMiddleButtonPop;virtual;        { Mouse kîzÇpsã fel       }

  Procedure   Timer;virtual;                       { Idãz°tã h°v†s           }

  Procedure   Process(var C:CommandType);          { Parancsfeldologoz¢      }
  end;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}

Const

{****************************************************************************}
{***                         TObject jelzãbitek                           ***}
{****************************************************************************}

     C_TObjectShowFlag          =   $0001; { 1:Ha megjelen°tett a TObject    }
     C_TObjectOnFlag            =   $0002; { 1:Ha bekapcsolt a TObject       }
     C_TObjectMouseFocusFlag    =   $0004; { 1:Ha MouseFocus a TObjecten van }
     C_TObjectKeyFocusFlag      =   $0008; { 1:Ha KeyFocus a TObjecten van   }
     C_TObjectReDrawFlag        =   $0010; { 1:Ha TObject £jrarajzol†s       }
     C_TObjectDisFlag           =   $0020; { Enable/Disable (ON/OFF) flag    }
     C_TObjectNoDrawFlag        =   $0040; { 0:Enable/1:Disable megjelen°tÇs }

{****************************************************************************}
{***                  TObject engedÇlyezã/tilt¢ bitek                     ***}
{****************************************************************************}

     C_TObjectMouseFocusMask    =   $0001;     { 1: A MouseFocus tiltott     }
     C_TObjectKeyFocusMask      =   $0002;     { 1: A KeyFocus tiltott       }

{****************************************************************************}
{***                           Billenty˚ k¢dok                            ***}
{****************************************************************************}

     _TabKey                    =   15;        { [Tab]   billenty˚ port k¢dja}
     _NextFocusKey       : word =   _TabKey;   { V†lt¢ billenty˚ port k¢dja  }

{****************************************************************************}
     SystemExitFlag      : boolean = FALSE;    { RendszerkilÇpÇs jelzã       }
     ESCFlag             : boolean = FALSE;    { ESC jelzã                   }

     Right               : boolean = FALSE;
     Left                : boolean = FALSE;
     Down                : boolean = FALSE;
     Up                  : boolean = FALSE;

     CommandString       : string  = '';
     TextP               : pointer = nil;


{****************************************************************************}
{************************* Unit elj†r†sok ***********************************}
{****************************************************************************}

{****************************************************************************}
{***                            TObjects vezÇrlÇs                         ***}
{****************************************************************************}

Procedure CommandProcess(C:CommandType);
Procedure TObjectProcess;
Procedure SetMouseFocus;
Procedure NextKeyFocus;
Procedure PrevKeyFocus;

Procedure SetFilter(FW:integer);
Procedure AllObjectsDisable;
Procedure AllObjectsEnable;
Procedure AllObjectsOff;
Procedure AllObjectsOn;

{****************************************************************************}
{***                         TObjects lekÇrdezÇsek                        ***}
{****************************************************************************}

Function GetRootTObjectPointer:pointer;
Function GetMouseTObjectPointer:pointer;
Function GetKeyTObjectPointer:pointer;

{****************************************************************************}
{************************* Implement†ci¢s rÇsz ******************************}
{****************************************************************************}

Implementation

Const
     RootTObjectPointer         : TObjectPointer        = nil;
     MouseFocusTObjectPointer   : TObjectPointer        = nil;
     KeyFocusTObjectPointer     : TObjectPointer        = nil;

     Filter                     : integer               = $0000;

{****************************************************************************}
{************************** TObjectType met¢dusai ***************************}
{****************************************************************************}

Constructor TObjectType.Init(IDD,OOT,XX,YY,DXX,DYY:word);
Begin
ID:=IDD;X:=XX;Y:=YY;DX:=DXX;DY:=DYY;NextTObject:=nil;PrevTObject:=nil;
Flag:=C_TObjectReDrawFlag;Mask:=0;Group:=0;OType:=OOT;
SetInit;On;Bind;
End;

Destructor TObjectType.Done;
Begin
If @Self=KeyFocusTObjectPointer
   then begin KeyFocusOff;KeyFocusTObjectPointer:=nil;end;
If @Self=MouseFocusTObjectPointer
   then begin MouseFocusOff;MouseFocusTObjectPointer:=nil;end;
If PrevTObject<>nil
   then PrevTObject^.NextTObject:=NextTObject
   else RootTObjectPointer:=NextTObject;
If NextTObject<>nil then NextTObject^.PrevTObject:=PrevTObject;
NextTObject:=nil;PrevTObject:=nil;Flag:=0;
Hide;
End;

Procedure TObjectType.Bind;
var RTO:TObjectPointer;
Begin
If RootTObjectPointer=nil
   then RootTObjectPointer:=@Self
   else begin
        RTO:=RootTObjectPointer;
        while RTO^.NextTObject<>nil do RTO:=RTO^.NextTObject;
        RTO^.NextTObject:=@Self;PrevTObject:=RTO;
        end;
If (KeyFocusTObjectPointer=nil) and (Mask and C_TObjectKeyFocusMask=0)
   then begin KeyFocusTObjectPointer:=@Self;KeyFocusOn;end;
End;

Procedure TObjectType.SetInit;
Begin
End;

Procedure TObjectType.Draw;
Begin
End;

Procedure TObjectType.Move(XX,YY:word);
Begin
Hide;
X:=XX;Y:=YY;
Show;
End;

Procedure TObjectType.Show;
Begin
If Flag and C_TObjectOnFlag=0 then Exit; { Ha OFF †llapotban  }
Flag:=Flag or C_TObjectShowFlag;
Flag:=Flag or C_TObjectReDrawFlag;
If Flag and C_TObjectNoDrawFlag=0 then Draw;
Flag:=Flag and (65535-C_TObjectReDrawFlag);
End;

Procedure  TObjectType.Hide;
Begin
Flag:=Flag and (65535-C_TObjectShowFlag);
End;

Procedure  TObjectType.On;
Begin
Flag:=Flag or C_TObjectOnFlag;
Flag:=Flag or C_TObjectReDrawFlag;
If Flag and C_TObjectNoDrawFlag=0 then Draw;
Flag:=Flag and (65535-C_TObjectReDrawFlag);
End;

Procedure  TObjectType.Off;
Begin
If @Self=KeyFocusTObjectPointer
   then begin KeyFocusOff;KeyFocusTObjectPointer:=nil;end;
If @Self=MouseFocusTObjectPointer
   then begin MouseFocusOff;MouseFocusTObjectPointer:=nil;end;
Flag:=Flag and (65535-C_TObjectOnFlag);
Flag:=Flag or C_TObjectReDrawFlag;
If Flag and C_TObjectNoDrawFlag=0 then Draw;
Flag:=Flag and (65535-C_TObjectReDrawFlag);
End;

Procedure  TObjectType.Disable;
Begin
If Flag and C_TObjectOnFlag<>0
   then Flag:=Flag or C_TObjectDisFlag
   else Flag:=Flag and (65535-C_TObjectDisFlag);
Off;
End;

Procedure  TObjectType.Enable;
Begin
If Flag and C_TObjectDisFlag<>0 then On;
End;

Procedure  TObjectType.EnableDraw;
Begin
Flag:=Flag and (65535-C_TObjectNoDrawFlag);
End;

Procedure  TObjectType.DisableDraw;
Begin
Flag:=Flag or C_TObjectNoDrawFlag;
End;

Procedure  TObjectType.KeyFocusOn;
Begin
Flag:=Flag or C_TObjectKeyFocusFlag;
If Flag and C_TObjectNoDrawFlag=0 then Draw;
End;

Procedure  TObjectType.KeyFocusOff;
Begin
Flag:=Flag and (65535-C_TObjectKeyFocusFlag);
If Flag and C_TObjectNoDrawFlag=0 then Draw;
End;

Procedure  TObjectType.MouseFocusOn;
Begin
Flag:=Flag or C_TObjectMouseFocusFlag;
If Flag and C_TObjectNoDrawFlag=0 then Draw;
End;


Procedure  TObjectType.MouseFocusOff;
Begin
Flag:=Flag and (65535-C_TObjectMouseFocusFlag);
If Flag and C_TObjectNoDrawFlag=0 then Draw;;
End;

Procedure  TObjectType.KeyPush;
Begin
End;

Procedure  TObjectType.KeyPop;
Begin
End;

Procedure  TObjectType.MouseMove;
Begin
End;

Procedure  TObjectType.MouseRightButtonPush;
Begin
End;

Procedure  TObjectType.MouseRightButtonPop;
Begin
End;

Procedure  TObjectType.MouseLeftButtonPush;
Begin
End;

Procedure  TObjectType.MouseLeftButtonPop;
Begin
End;

Procedure  TObjectType.MouseMiddleButtonPush;
Begin
End;

Procedure  TObjectType.MouseMiddleButtonPop;
Begin
End;

Procedure  TObjectType.Timer;
Begin
End;

Procedure TObjectType.SetKeyFocus;
Begin
If (Mask and C_TObjectKeyFocusMask<>0) or (Flag and C_TObjectOnFlag=0)
   then Exit;
If KeyFocusTObjectPointer=@Self then exit;
If KeyFocusTObjectPointer<>nil then KeyFocusTObjectPointer^.KeyFocusOff;
KeyFocusTObjectPointer:=@Self;
KeyFocusOn;
End;

Procedure TObjectType.Process(var C:CommandType);
Begin
Command:=C;
Case C.CommandType of
     _KeyType    : Case C.CommandCode of
                         _Key_Push               : KeyPush;
                         _Key_Pop                : KeyPop;
                         end;
     _MouseType  : begin
                    If C.CommandCode and _Mouse_Move<>0
                       then MouseMove;
                    If C.CommandCode and _MouseLeftButton_Push<>0
                       then MouseLeftButtonPush;
                    If C.CommandCode and _MouseLeftButton_Pop<>0
                       then MouseLeftButtonPop;
                    If C.CommandCode and  _MouseMiddleButton_Push<>0
                       then MouseMiddleButtonPush;
                    If C.CommandCode and _MouseMiddleButton_Pop<>0
                       then MouseMiddleButtonPop;
                    If C.CommandCode and _MouseRightButton_Push<>0
                       then MouseRightButtonPush;
                    If C.CommandCode and _MouseRightButton_Pop<>0
                       then MouseRightButtonPop;
                    end;
     _TimerType  : Timer;
     end;
End;

{****************************************************************************}
{***************************** TObject met¢dusok vÇge ***********************}
{****************************************************************************}


{****************************************************************************}
{***                        SetMouseFocusObject                           ***}
{****************************************************************************}

Function GetMouseFocus(MX,MY:word;TOP:TObjectType):boolean;
Begin
If (TOP.Mask and C_TObjectMouseFocusMask<>0) or (TOP.Flag and C_TObjectOnFlag=0) or
   (MX<TOP.X) or (MX>TOP.X+TOP.DX) or (MY<TOP.Y) or (MY>TOP.Y+TOP.DY)
      then GetMouseFocus:=False else GetMouseFocus:=True;
End;

Function GetMouseFocusTObjectPointer(MX,MY:word):pointer;
var Ki:boolean;RTO:TObjectPointer;
Begin
Ki:=false;RTO:=RootTObjectPointer;
while (RTO<>nil) and (not GetMouseFocus(MX,MY,RTO^))
      do RTO:=RTO^.NextTObject;
GetMouseFocusTObjectPointer:=RTO;
End;

Procedure SetMouseFocus;
var RTO:TObjectPointer;
Begin
RTO:=GetMouseFocusTObjectPointer(GetMouseX,GetMouseY);
If (RTO<>MouseFocusTObjectPointer) and (MouseFocusTObjectPointer<>nil)
   then MouseFocusTObjectPointer^.MouseFocusOff;
MouseFocusTObjectPointer:=RTO;
If MouseFocusTObjectPointer<>nil then MouseFocusTObjectPointer^.MouseFocusOn;
End;

{****************************************************************************}
{***                        NextKeyFocus/PrevKeyFocus                     ***}
{****************************************************************************}

Procedure NextKeyFocus;
var Ki:boolean;ORTO,RTO:TObjectPointer;
Begin
If RootTObjectPointer=nil then Exit;
Ki:=false;RTO:=KeyFocusTObjectPointer;ORTO:=RTO;
If RTO=Nil then RTO:=RootTObjectPointer else RTO:=RTO^.NextTObject;
while (RTO<>ORTO) and (not Ki) do
      begin
      if RTO=nil then RTO:=RootTObjectPointer;
      If (RTO^.Mask and C_TObjectKeyFocusMask=0) and (RTO^.Flag and C_TObjectOnFlag<>0)
         then Ki:=true else RTO:=RTO^.NextTObject;
      end;
If RTO<>ORTO then RTO^.SetKeyFocus;
End;

Procedure PrevKeyFocus;
var Ki:boolean;LTO,ORTO,RTO:TObjectPointer;
Begin
If RootTObjectPointer=nil then Exit;
LTO:=RootTObjectPointer;while LTO^.NextTObject<>nil do LTO:=LTO^.NextTObject;
Ki:=false;RTO:=KeyFocusTObjectPointer;ORTO:=RTO;
If RTO=Nil then RTO:=LTO else RTO:=RTO^.PrevTObject;
while (RTO<>ORTO) and (not Ki) do
      begin
      if RTO=nil then RTO:=LTO;
      If (RTO^.Mask and C_TObjectKeyFocusMask=0) and (RTO^.Flag and C_TObjectOnFlag<>0)
         then Ki:=true else RTO:=RTO^.PrevTObject;
      end;
If RTO<>ORTO then RTO^.SetKeyFocus;
End;

{****************************************************************************}
{***                            TObjects vezÇrlÇs                         ***}
{***    - Be: C   = Command (ElkÅldendã parancs)                          ***}
{****************************************************************************}

Procedure CommandProcess(C:CommandType);
var P:TObjectPointer;S,O:word;
Begin
Case C.CommandType of
     _KeyType   : begin
                  If C.KeyCode=_NextFocuskey
                     then if (C.CommandCode=_Key_Push)
                          then if  (C.KeyTable[6] and 4=0) and (C.KeyTable[5] and 64=0)
                                   then NextKeyFocus
                                   else PrevKeyFocus
                          else
                     else
                  If (C.KeyTable[6] and 1=1) and (C.KeyTable[3] and 8=8) and
                      (C.KeyTable[5] and 64=64) and (C.KeyTable[10] and 32=32) and
                      { Ctrl+Alt+Del } (C.CommandCode=_Key_Push)
                     then begin
                          Asm mov  ax,0003h;int 10h End;
                          WriteLn('Reset by user! Mem: ',MaxAvail div 1024,' kB - XMS: ',MaxXMSMem,' kB');
                          TProcOff;halt(1);
                          end
                     else If (C.KeyTable[6] and 1=1) and (C.KeyTable[3] and 8=8) and
                             (C.KeyTable[0] and 128=128) and (C.CommandCode=_Key_Push)
                             { Ctrl+Alt+Esc } then SystemExitFlag:=True
                     else If (C.KeyTable[6] and 1=1) and (C.KeyTable[0] and 128=128) and (C.CommandCode=_Key_Push)
                             { Alt+Esc }
                             then begin
                                  TProcOff;S:=GetMode;MouseHide;
                                  If SavePicToXMS>0 then begin MouseShow;Exit;end;
                                  Asm mov  ax,0003h;int 10h End;
                                  If TextP=nil then WriteLn('Mem: ',MaxAvail div 1024,' kB - XMS: ',MaxXMSMem,' kB');
                                  ReadLn(CommandString);
                                  SetGraphMode(S);MouseInit(True,MousePR,MouseDivX,MouseDivY);
                                  RestorePicFromXMS;MouseShow;TProcOn;
                                  end
                     else If (C.KeyTable[0] and 128=128) and (C.CommandCode=_Key_Push)
                             { Esc } then ESCFlag:=True
                     else If KeyFocusTObjectPointer<>nil
                             then KeyFocusTObjectPointer^.Process(C);
                  end;
     _MouseType : begin
                  P:=GetMouseFocusTObjectPointer(C.Mouse_X,C.Mouse_Y);
                   If P<>MouseFocusTObjectPointer
                      then begin
                           If MouseFocusTObjectPointer<>nil
                              then MouseFocusTObjectPointer^.MouseFocusOff;
                           MouseFocusTObjectPointer:=P;
                           If MouseFocusTObjectPointer<>nil
                              then MouseFocusTObjectPointer^.MouseFocusOn;
                           end;
                  If MouseFocusTObjectPointer<>nil
                     then MouseFocusTObjectPointer^.Process(C);
                  end;
     _TimerType : begin
                  S:=C.Parameter1;O:=C.Parameter2;
                  Asm
                     LEA BX,P;
                     MOV AX,O;
                     MOV SS:[BX],AX;
                     MOV AX,S;
                     MOV SS:[BX+2],AX;
                  End;
                  P^.Timer;
                  end;
     end;
End;

Procedure TObjectProcess;
var C:CommandType;
Begin
If GetCommand(C)=0 then Exit;
CommandProcess(C);
End;

{****************************************************************************}
{***                    All TObjects procedures                           ***}
{****************************************************************************}

Procedure SetFilter(FW:integer);
Begin
Filter:=FW;
End;

Procedure _AllObjectProcedures(w:word);
var RTO:TObjectPointer;
Begin
RTO:=RootTObjectPointer;
While RTO<>nil
      do begin
         If (Filter=0) or (Filter=RTO^.Group) or
            ((Filter<0) and (Abs(Filter)<>RTO^.Group))
            then Case W of
                 1 : RTO^.Disable;
                 2 : RTO^.Enable;
                 3 : RTO^.Off;
                 4 : RTO^.On;
                 end;
         RTO:=RTO^.NextTObject;
         end;
End;

Procedure AllObjectsDisable;
Begin
_AllObjectProcedures(1);
End;

Procedure AllObjectsEnable;
Begin
_AllObjectProcedures(2);
End;

Procedure AllObjectsOff;
Begin
_AllObjectProcedures(3);
End;

Procedure AllObjectsOn;
Begin
_AllObjectProcedures(4);
End;

{****************************************************************************}
{***                       TObjects lekÇrdezÇsek                          ***}
{****************************************************************************}

Function GetRootTObjectPointer:pointer;
Begin
GetRootTObjectPointer:=RootTObjectPointer;
End;

Function GetMouseTObjectPointer:pointer;
Begin
GetMouseTObjectPointer:=MouseFocusTObjectPointer;
End;

Function GetKeyTObjectPointer:pointer;
Begin
GetKeyTObjectPointer:=KeyFocusTObjectPointer;
End;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}


BEGIN
END.