Program Teki;
{****************************************************************************}
{***                                                                      ***}
{***                               Teki V1.0d                             ***}
{***                           2000.06.18.-2000.07.17.                    ***}
{***               (C) TwinNet Ltd 1997,2000 (P) Szab¢ Andr†s 2000        ***}
{***                       E-mail: szaboand@twinnet.hu                    ***}
{***                     WWW: http://szaboand.twinnet.hu                  ***}
{***                            All Rights Reserved                       ***}
{***                                                                      ***}
{****************************************************************************}
{***                            DOS VERZIO                                ***}
{***                        TURBO PASCAL 7.0 FILE                         ***}
{****************************************************************************}

{$A+,B-,D+,E+,F+,G+,I+,L+,N-,O-,P-,Q+,R+,S+,T-,V+,X+}
{$M 32768,0,655360}
Uses TWSys{2.0c},TObject{4.3},TObjects{4.1e},Teknoc{V1.0a};

{****************************************************************************}
{***                              Konstansok                              ***}
{****************************************************************************}

Const
 VMode                 :  word    = _640x480_256;   { Vide¢m¢d k¢dja         }
 ProgramName           :  string  = 'Teki V1.0a (C) Szab¢ Andr†s 2000';
 Info1                 :  string  = 'e-mail:szaboand@twinnet.hu';
 MDVX                  :  word    = $0003;  { Mouse X oszt†sar†ny (SHR)      }
 MDVY                  :  word    = $0003;  { Mouse X oszt†sar†ny (SHR)      }
 PixRat                :  word    = $0001;  { Mouse Pixel/Ratio              }
 MouseAct              :  boolean = TRUE;   { Saj†t mouse megjelen°tÇs       }
 BackgroundColor       :  byte    = $07;    { H†ttÇrszin                     }
 DBackgroundColor      :  byte    = $08;    { SîtÇt h†ttÇrszin               }
 DDBackgroundColor     :  byte    = $00;    { SîtÇt h†ttÇrszin               }
 LBackgroundColor      :  byte    = $0F;    { Vil†gos h†ttÇrszin             }
 InfoTextColor         :  byte    = $0F;    { Info textszin                  }
 DInfoTextColor        :  byte    = $08;    { SîtÇt info textszin            }
 TimeTextColor         :  byte    = $08;    { Idã textsz°n                   }

 _ExitButtonCode                  = $0001;       { Command k¢dok             }
 _StartButtonCode                 = $0002;
 _BetButtonCode                   = $0003;
 _OKButtonCode                    = $0004;
 _CancelButtonCode                = $0005;


 _ExitButtonString                = ' KilÇp ';   { Button feliratok       }
 _StartButtonString               = '  Start  ';
 _NewRunButtonString              = 'Èj futam';
 _BetButtonString                 = ' Fogad†s ';
 _OKButtonString                  = '    OK    ';
 _CancelButtonString              = '   MÇgse   ';
 _ReplayButtonString              = ' Visszaj ';

 KInfoTextColor                   = 253;
 KInfReg               : shortint = 63;
 KPlus                 : shortint = -1;
 maxSInfo                         = 4;
 ActSInfo              : byte     = 1;
 SInfo                 : array [1..MaxSInfo] of string[37]
                         = ('      TEKI V1.0 - Szab¢ Andr†s     ',
                            '         szaboand@twinnet.hu       ',
                            '     http://szaboand.twinnet.hu    ',
                            '     (C) Szab¢ Andr†s 1997,2000    ');
  _WTime                : integer  = 0;

  DemoMode              : boolean  = False;
  DemoWTime             : integer  = 4*18;
  _DemoWTime            : integer  = 0;

  CheatMode             : boolean  = True;

  MaxPlayerNum                     = 4;
  STPlayerName          : array [1..MaxPlayerNum] of string[10] =
                          ('GÇza','Laci','Peti','BÇla');

  STTekiName            : array [1..MaxTeki] of string[10] =
                          ('T1','T2','T3','T4','T5','T6','T7','T8');

  FX1                              =386;
  FY1                              =300;
  FDX                              =250;
  FDY                              =150;

  FOX                              = 310;
  FOY                              = 130;
  FODX                             = 270;
  FODY                             = 200;

  Penznem                          = 'Ft';
  FEXHC                 : integer  = 0;

{****************************************************************************}
{***                               T°pusok                                ***}
{****************************************************************************}
Type

 MyButtonType   = object(ButtonType)
  Procedure DoButton;virtual;
  Procedure SetInit;virtual;
 end;

 TimeType       = object(TextType)
  TF           : boolean;
  Time         : word;
  Constructor  Init(IDd,XX,YY:word);
  Procedure    SetInit;virtual;
  Procedure    Draw;virtual;
  Procedure    Timer;virtual;
 end;

 MyRButtonType = object(RButtonType)
  Text         : string[22];
  Procedure    SetInit;virtual;
  Procedure    Draw;virtual;
 end;

 MyIconType   = object(IconType)
  Procedure   MouseLeftButtonPush;virtual;
  Procedure   KeyPush;virtual;
  Procedure   KeyFocusOn;virtual;
  Procedure   KeyFocusOff;virtual;
  Procedure   MouseFocusOn;virtual;
  Procedure   MouseFocusOff;virtual;
 end;

 PlayerType    = record
  Name         : string[20];
  Activ        : boolean;
  VFogadTeki   : byte;
  OFogadTeki   : byte;
  Penz         : longint;
  Tet          : word;
  RB           : MyRButtonType;
 end;


{****************************************************************************}
{***                               V†ltoz¢k                               ***}
{****************************************************************************}

Var
 ExitButton           : MyButtonType;
 StartButton          : MyButtonType;
 BetButton            : MyButtonType;
 OKButton             : MyButtonType;
 CancelButton         : MyButtonType;
 TimeText             : TimeType;
 SpriteIcon           : array [1..MaxTeki] of MyIconType;

 P                    : array [1..MaxPlayerNum] of PlayerType;


 CommandCode          : word;

 Futam                : FutamType;
 Go                   : boolean;

{****************************************************************************}
{***                               HELP                                   ***}
{****************************************************************************}

Procedure TextHelp;
Begin
WriteLn;
WriteLn(ProgramName);
WriteLn('Start the demo mode:           TEKI.EXE /demo !');
WriteLn('Start the one color mode:      TEKI.EXE /F *, where * is 0..7!');
WriteLn('Want to win? Try this: Push [Alt]+[Esc] while running the race and type Teki*,');
WriteLn('where * is 1,2,..8! ;-) Have fun!');
WriteLn;
End;

Procedure HaltError(MSG:string);
Begin
Asm mov  ax,0003h;int 10h End;
WriteLn('Fatal Error! '+MSG);Halt;
End;

{****************************************************************************}
{***                    MyButtonType objektum met¢dusai                   ***}
{****************************************************************************}

Procedure MyButtonType.DoButton;
Begin
CommandCode:=ID;
End;

Procedure MyButtonType.SetInit;
Begin
End;

{****************************************************************************}
{***                   MyRButtonType objektum met¢dusai                   ***}
{****************************************************************************}

Procedure MyRButtonType.SetInit;
var I:byte;
Begin
Text:=BText;
For I:=1 to 22 do BText:=BText+' ';DX:=length(BText)*8+BX+6;
End;

Procedure MyRButtonType.Draw;
Begin
BText:=Text;
If P[ID].VFogadTeki>0
 then BText:=BText+' fogad a '+STTekiName[P[ID].VFogadTeki]+'. teknãcre!'
 else if Value<>0
       then BText:=BText+' fogad a ...'
       else BText:=BText+' nem fogad!';
while length(BText)<22 do BTExt:=BText+' ';
Inherited Draw;
End;

{****************************************************************************}
{***                      MyIconType objektum met¢dusai                   ***}
{****************************************************************************}

Procedure MyIconType.MouseLeftButtonPush;
var I:word;
Begin
For I:=1 to MaxPlayerNum do
 If P[I].RB.Value<>0 then begin P[I].VFogadTeki:=ID;P[I].RB.Draw;end;
MouseHide;Futam.SetShape(ID,2);MouseShow;
End;

Procedure MyIconType.KeyPush;
var I:word;
Begin
If Command.KeyCode<>28 then Exit;
For I:=1 to MaxPlayerNum do
 If P[I].RB.Value<>0 then begin P[I].VFogadTeki:=ID;P[I].RB.Draw;end;
MouseHide;Futam.SetShape(ID,2);MouseShow;
End;

Procedure MyIconType.KeyFocusOn;
Begin
MouseHide;Futam.SetShape(ID,10);MouseShow;
Inherited KeyFocusOn;
End;

Procedure MyIconType.KeyFocusOff;
Begin
MouseHide;Futam.SetShape(ID,Futam.Teki[ID].AnimF);MouseShow;
Inherited KeyFocusOff;
End;

Procedure MyIconType.MouseFocusOn;
Begin
MouseHide;Futam.SetShape(ID,10);MouseShow;
Inherited MouseFocusOn;
End;

Procedure MyIconType.MouseFocusOff;
Begin
MouseHide;Futam.SetShape(ID,Futam.Teki[ID].AnimF);MouseShow;
Inherited MouseFocusOff;
End;

{****************************************************************************}
{***                         TimeType objektum met¢dusai                  ***}
{****************************************************************************}

Constructor TimeType.Init(IDd,XX,YY:word);
Begin
Inherited Init(IDd,XX,YY,11,2,nil);
End;

Procedure TimeType.SetInit;
Begin
Chars:=1;LineSpace:=1;DY:=CDY*(8+LineSpace);
TextColor:=TimeTextColor;TextBackColor:=BackgroundColor;
End;

Procedure TimeType.Timer;
Begin
Draw;
End;

Procedure TimeType.Draw;
var t:string;tt:^byte;mh:boolean;
Begin
If _WTime>0 then Dec(_WTime);
If (DemoMode) and (_DemoWTime>0) then Dec(_DemoWTime);
KInfReg:=KInfReg+KPlus;If (KInfReg>62) or (KInfReg<1) then KPlus:=-KPlus;
If (KInfReg>0) and (KInfReg<64) then SetRGBReg(KInfotextColor,KInfReg,KInfReg,KInfReg);
If KinfReg<1
 then begin
      Inc(ActSInfo);If ActSInfo>MaxSInfo then ActSInfo:=1;
      SetColor(KInfoTextColor);SetTextBackColor(0);ROM_8x14;
      MouseHide;OutStringXY(110,GetMaxY-20,SInfo[ActSInfo]);MouseShow;
      If Go then OutStringXY(110,GetMaxY-20+GetMaxY,SInfo[ActSInfo]);
      end;
If Time<18 then begin Inc(Time);Exit;end;
T:='TEKI '+GetTimeStr(0);
If TF then T:=T+' ' else T:=T+'.';TF:=Not(TF);
T:=T+chr(10)+GetDateStr(false)+chr(0);
TT:=@T;Inc(TT);TextPointer:=TT;mh:=false;
If (GetMouseX<X+DX+16) and (GetMouseY+16>Y) then begin mh:=true;MouseHide;end;
Inherited Draw;
If Go then begin Y:=Y+GetMaxY;Inherited Draw;Y:=Y-GetMaxY;end;
If MH then MouseShow;
Time:=0;
End;

{****************************************************************************}
{***                         Inicializ†l†sok                              ***}
{****************************************************************************}

Function Init_Video:word;
var I:word;
Begin
If SetGraphMode(VMode)<>0 then begin Init_Video:=1;Exit;end;
SetColor(1);Bar(0,0,GetMaxX-1,3*GetMaxY-1);SetBorder(BackGroundColor);
SetColor(BackGroundColor);Bar(0,GetMaxY-26,GetMaxX-1,GetMaxY-1);
BorderDraw_2b(2,GetMaxY-25,90,18,BackGroundColor,DBackGroundColor,LBackGroundColor);
BorderDraw_2b(100,GetMaxY-25,GetMaxX-340,18,0,DBackGroundColor,LBackGroundColor);
Init_Video:=0;
End;

Function Init_Mouse:byte;
Begin
If MouseInit(MouseAct,PixRat,MDVX,MDVY)=0
   then Init_Mouse:=1
   else begin Init_Mouse:=0;MouseShow;end;
End;

Procedure VideoDone;
Begin
Asm mov  ax,0003h;int 10h End;
WriteLn(ProgramName);
End;

{****************************************************************************}
{***                  Objektumok inicializ†l†sa/lez†r†sa                  ***}
{****************************************************************************}

Procedure ObjectInit;
Begin
StartButton.Init(_StartButtonCode,GetMaxX-230,GetMaxY-24,_StartButtonString);
BetButton.Init(_BetButtonCode,GetMaxX-148,GetMaxY-24,_BetButtonString);
ExitButton.Init(_ExitButtonCode,GetMaxX-66,GetMaxY-24,_ExitButtonString);
TimeText.Init(0,6,GetMaxY-21);TimeText.Time:=20;
SetTimer(1,1,0,0,Seg(TimeText),Ofs(TimeText));
End;

Procedure ObjectDone;
Begin
SetTimer(1,0,0,0,0,0);
TimeText.Done;
ExitButton.Done;
BetButton.Done;
StartButton.Done;
End;

{****************************************************************************}
{***                               Players                                ***}
{****************************************************************************}

Procedure InitPlayers;
var I:word;
Begin
For I:=1 to MaxPlayerNum do with P[I] do
 begin
  Name:=STPlayerName[i];Penz:=1000;Tet:=1;VFogadTeki:=0;Activ:=True;
 end;
End;

{****************************************************************************}
{***                                Bet                                   ***}
{****************************************************************************}

Procedure FogadasInit;
var I:byte;S:string[5];
Begin
MouseHide;
CopyBlock(FX1,FY1,FX1,FY1+2*GetMaxX,FDX+5,FDY+5);ESCFlag:=False;
BorderDraw_1b(FX1,FY1,FDX,FDY,BackGroundColor,DBackGroundColor,LBackGroundColor);
MouseShow;
OKButton.Init(_OKButtonCode,FX1+30,FY1+FDY-40,_OKButtonString);
CancelButton.Init(_CancelButtonCode,FX1+130,FY1+FDY-40,_CancelButtonString);
For I:=1 to MaxPlayerNum do with P[I] do
 begin OFogadTeki:=VFogadTeki;RB.Init(I,FX1+10,FY1+I*20,Name,1,0);end;
For I:=1 to MaxTeki
 do SpriteIcon[I].Init(I,Futam.Teki[i].X,Futam.Teki[i].Y,Futam.Teki[i].DX,Futam.Teki[i].DY,nil);
P[1].RB.SetValue;P[1].RB.Draw;
End;

Procedure FogadasDone;
var I:word;
Begin
For I:=1 to MaxTeki do SpriteIcon[I].Done;
For I:=MaxPlayerNum downto 1 do P[I].RB.Done;
CancelButton.Done;
OKButton.Done;
MouseHide;CopyBlock(FX1,FY1+2*GetMaxX,FX1,FY1,FDX+5,FDY+5);MouseShow;
End;

Procedure Fogadas;
var I:byte;
Begin
FogadasInit;CommandCode:=0;
repeat
      TObjectProcess
until (SystemExitFlag) or (ESCFlag) or (CommandCode<>0);
If CommandCode<>_OKButtonCode
 then For I:=1 to MaxPlayerNum do with P[I] do VFogadTeki:=OFogadTeki;
FogadasDone;
End;

Procedure FogadasElszamol;
var I:word;
Begin
For I:=1 to MaxPlayerNum do with P[I] do If VFogadTeki>0 then
 IF Futam.Teki[VFogadTeki].Helyezes=1
  then Penz:=Penz+Tet else Penz:=Penz-Tet;
End;

Procedure ShowBets;
var I:word;S:string;
const MVL=4;VL:array [0..MVL] of word = (0,70,100,160,200);
      SVL:array[0..MVL] of string[10]=('NÇv','Teki','TÇt','Nyer','PÇnz');
      SVLX:array[0..MVL] of word = (20,0,20,5,30);
Begin
BorderDraw_2b(FOX,FOY,FODX-4,FODY-4,0,8,9);
SetTextBackColor(0);ROM_8x14;SetColor(15);
OutStringXY(FOX+50,FOY+10,'Fogad†si eredmÇnyek');
For I:=1 to MVL do Line(FOX+VL[I],FOY+72,FOX+VL[I],FOY+FODY-6);
SetColor(7);
For I:=0 to MVL do OutStringXY(FOX+VL[I]+SVLX[I],FOY+72-20,SVL[I]);
SetColor(15);
For I:=1 to MaxPlayerNum+1 do Line(FOX+5,FOY+50+I*20-3,FOX+FODX-6,FOY+50+I*20-3);
For I:=1 to MaxPlayerNum do with P[I] do
 begin
 SetColor(15);
 If VFogadTeki>0
  then begin
       If Futam.Teki[VFogadTeki].Helyezes=1
        then begin S:='I';SetColor(12);end else S:='N';
       OutStringXY(FOX+VL[3]+16,FOY+50+I*20,S);
       Str(Tet,S);while length(S)<4 do S:=' '+S;S:=S+' '+Penznem;
       OutStringXY(FOX+VL[2]+3,FOY+50+I*20,S);Str(VFogadTeki,S);
       end
  else S:='-';
 while length(S)<2 do S:=' '+S;OutStringXY(FOX+VL[1]+3,FOY+50+I*20,S);
 OutStringXY(FOX+10,FOY+50+I*20,Name);
 Str(Penz,S);while length(S)<5 do S:=' '+S;S:=S+' '+Penznem;
 OutStringXY(FOX+VL[MVL]+3,FOY+50+I*20,S);VFogadTeki:=0;
 end;
End;

{****************************************************************************}
{***                     Inicializ†l†s/lez†r†s                            ***}
{****************************************************************************}

Procedure Init;
Begin
If Init_Video<>0
 then begin WriteLn('Nem sikerÅlt a videom¢d inicializ†l†sa!');Halt;end;
Init_Mouse;
If LoadSpritesShapes<>0 then HaltError('Sprite file not found!');
InitPlayers;
Futam.Init;
ObjectInit;
End;

Procedure Done;
Begin
ObjectDone;
Futam.Done;
DoneSpriteShapeMem;
VideoDone;
End;

{****************************************************************************
{***                               Cheat                                  ***}
{****************************************************************************}

Procedure Cheat;
var S:string;I,HC:integer;
Begin
If CommandString='' then Exit;
If Copy(CommandString,1,4)='Teki'
 then begin
      S:=Copy(CommandString,5,length(CommandString));Val(S,I,HC);
      If (HC=0) and (I<=MaxTeki) then Futam.Teki[I].CheatV:=1;
      end;
CommandString:=''
End;

{****************************************************************************
{***                                Run                                   ***}
{****************************************************************************}

Procedure InitRun;
Begin
CopyBlock(0,0,0,GetMaxY,GetMaxX,GetMaxY);
Futam.NewRun;
End;

Procedure DoneRun;
Begin
If Futam.ReplayRun=False then FogadasElszamol;
CopyBlock(FOX,FOY,FOX,FOY+2*GetMaxY,FODX,FODY);
ShowBets;SetVideoMem(0,0);
End;

Procedure Run;
Begin
ESCFlag:=False;Go:=True;
CopyBlock(0,GetMaxY-40-1,0,2*GetMaxY-40-1,GetMaxX-1,40);
repeat
 TObjectProcess;
 If CheatMode then Cheat;
until (SystemExitFlag) or (ESCFlag) or (Futam.Run);
Futam.Run;Go:=False;DoneRun;
End;

{****************************************************************************}
{***                             Fãprogram                                ***}
{****************************************************************************}

Procedure Main;
var I:byte;
Begin
ClearCommandPuffer;I:=0;
repeat
 Case I of
      0 : begin end;
      1 : begin
          with StartButton do begin TX:=5;BText:=_StartButtonString;Draw;end;
          with BetButton do begin BText:=_BetButtonString;Draw;end;
          BetButton.Enable;StartButton.SetKeyFocus;
          MouseHide;InitRun;MouseShow;
          end;
      2 : begin
          If DemoMode then _DemoWTime:=DemoWTime;CommandCode:=0;
          repeat TObjectProcess until (CommandCode<>0) or (SystemExitFlag) or ((DemoMode) and (_DemoWTime=0));
          If ((DemoMode) and (_DemoWTime=0)) then CommandCode:=_StartButtonCode;
          end;
      3 : Case CommandCode of
               _StartButtonCode : begin
                                  AllObjectsDisable;MouseHide;MouseTilt:=2;
                                  Run;
                                  MouseTilt:=0;MouseShow;AllObjectsEnable;
                                  end;
               _BetButtonCode   : begin
                                  AllObjectsDisable;
                                  Fogadas;I:=1;
                                  AllObjectsEnable;StartButton.SetKeyFocus;
                                  end;
               end;
      4: begin
          with StartButton do begin TX:=9;BText:=_NewRunButtonString;Draw;end;
          with BetButton do begin BText:=_ReplayButtonString;Draw;end;
          StartButton.SetKeyFocus;
          If (Futam.ReplayM=MaxReplayM) or (ESCFlag) then BetButton.Disable;
          end;
       5: begin
          If DemoMode then _DemoWTime:=DemoWTime;CommandCode:=0;
          repeat TObjectProcess until (CommandCode<>0) or (SystemExitFlag) or ((DemoMode) and (_DemoWTime=0));
          If ((DemoMode) and (_DemoWTime=0)) then CommandCode:=_StartButtonCode;
          MouseHide;CopyBlock(FOX,FOY+2*GetMaxY,FOX,FOY,FODX,FODY);MouseShow;
          end;
       6: Case CommandCode of
               _StartButtonCode : begin
                                  Futam.ReplayRun:=False;
                                  MouseHide;Futam.EndRun;MouseShow;
                                  end;
               _BetButtonCode   : begin
                                  Futam.ReplayRun:=True;
                                  MouseHide;Futam.EndRun;MouseShow;
                                  MouseHide;InitRun;MouseShow;
                                  CommandCode:=_StartButtonCode;I:=2;
                                  end;
               end;
       end;
 Inc(I);If I>6 then I:=1;
until (CommandCode=_ExitButtonCode) or (SystemExitFlag);
End;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}

BEGIN
{If MaxAvail div 1024<310
 then begin WriteLn('No enough memory! Minimum required: 320K! Now: ',MaxAvail div 1024,'K');Exit;end;}
If ParamStr(1)='/F'
 then begin Val(ParamStr(2),FEX,FEXHC);If (FEX<0) or (FEX>7) then FEX:=0;end;
If ParamStr(1)='/?' then begin TextHelp;Exit;end;
If ParamStr(1)='/demo' then DemoMode:=True;
Randomize;
Init;
TProcOn;
Main;
TProcOff;
Done;
END.