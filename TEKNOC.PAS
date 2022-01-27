Unit Teknoc;
{****************************************************************************}
{***                                                                      ***}
{***                            Tekn‹c Unit V1.0a                         ***}
{***                           2000.06.28.-2000.07.17.                    ***}
{***               (C) TwinNet Ltd 1997,2000 (P) Szab¢ Andr s 2000        ***}
{***                  E-mail: szaboand@mail.petrikl.sulinet.hu            ***}
{***                       WWW: www.twinnet.hu/szaboand                   ***}
{***                            All Rights Reserved                       ***}
{***                                                                      ***}
{****************************************************************************}
{***                            DOS VERZIà                                ***}
{***                     TURBO PASCAL 7.0 UNIT FILE                       ***}
{****************************************************************************}

Interface

Uses Sprite{V1.0b};

Const
  MaxTeki                         = 8;          { Maxim lis tekik sz ma     }
  MaxReplayM                      = 8000;
  FEX                   : integer = -1;

Type
 TimeType       = array [1..4] of longint;

 TeknocType  = object(SpriteType)
  Helyezes            : word;
  CheatV              : word;
  Procedure SetInit;virtual;
 end;

 FutamType   = object
  Teki                  : array [1..MaxTeki] of TeknocType; { Tekn‹c”k }
  Error                 : word;  { Hibak¢d        }
  CelX                  : word;  { C‚lszalag X koordin ta }
  K                     : word;  { Helyez‚s sz ml l¢      }
  StartT                : TimeType;
  Replay                : array [1..MaxReplayM] of byte;
  ReplayRun             : boolean;
  ReplayM               : word;
  Name                  : string[10];
  Constructor Init;
  Destructor  Done;

  Procedure NewRun;
  Procedure EndRun;
  Function  Run:boolean;virtual;

  Procedure SetShape(II,KK:word);
  Procedure Anim;
  Procedure Move;

  Procedure ShowStopper;
  Procedure SetStartTime;
 end;

{****************************************************************************}

Function LoadSpritesShapes:word;
Function DoneSpriteShapeMem:word;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}

Implementation

Uses TWSys{V2.0c};

Const
 SPDX                             = 47;          { Teki sz‚less‚ge           }
 SPDY                             = 47;          { Teki magass ga            }
 TekiShapeNum                     = 15;          { Teki alakzatok sz ma      }
 TekiFileName  : string          = 'SPRITE.BIN'; { Teki bitmap file          }
 E_NoEnoughMem                    = 1;           { Hibak¢d                   }

 WR                   : longint   = MaxLongInt;  { Word Record               }
 WRX                  : word      = 576;
 WRY                  : word      = 0;
 WRString                         = 'New World Record!!!';
 TSString             : array [1..2] of string[30] =
                        ( 'Id‹eredm‚ny:','Helyez‚s:');

Type
 TeknocShapeType       = array [1..SPDX,1..SPDY] of byte;

Var
  TekiShape           : array [1..MaxTeki,0..TekiShapeNum] of ^TeknocShapeType;

{****************************************************************************}
{***                                Id‹kezel‚s                            ***}
{****************************************************************************}

Procedure GetTimeDifferent(T1,T2:TimeType;var DT:TimeType);
var W1,W2,DW:longint;
Begin
W1:=((T1[1]*60+T1[2])*60+T1[3])*100+T1[4];
W2:=((T2[1]*60+T2[2])*60+T2[3])*100+T2[4];
DW:=W2-W1;
DT[1]:=DW div 360000;DW:=DW-(DT[1]*360000);
DT[2]:=DW div 6000;DW:=DW-(DT[2]*6000);
DT[3]:=DW div 100;
DT[4]:=DW-(DT[3]*100);
End;

Function ConvertToTimeString(T:TimeType):string;
var TS,TSS:string;
Begin
TS:='';
Str(T[1],TSS);while length(TSS)<2 do TSS:='0'+TSS;If T[1]>0 then TS:=TS+TSS+':';
Str(T[2],TSS);while length(TSS)<2 do TSS:='0'+TSS;If (TS='') and (T[2]>0) then TS:=TS+TSS+':';
Str(T[3],TSS);while length(TSS)<2 do TSS:='0'+TSS;TS:=TS+TSS+':';
Str(T[4],TSS);while length(TSS)<2 do TSS:='0'+TSS;TS:=TS+TSS;
ConvertToTimeString:=TS;
End;

Function ShowTime(StartT:TimeType;X,Y:word;C,BC:byte;sh:byte;CH:byte;var DiffT:TimeType):string;
var TT:array[1..4] of word;J:word;StopT:TimeType;TS:string;
Begin
GetTime(TT[1],TT[2],TT[3],TT[4]);For J:=1 to 4 do StopT[J]:=TT[J];
GetTimeDifferent(StartT,StopT,DiffT);TS:=ConvertToTimeString(DiffT);
SetColor(C);SetTextBackColor(BC);SetTextOver(1);
Case ch of
     1 : ROM_8x8;
     2 : ROM_8x14;
     3 : ROM_8x16;
     end;
Case SH of
     1 : OutStringXY(X,Y,TS);
     2 : OutStringXY(X,Y+GetDrawPic*GetMaxY,TS);
     3 : begin OutStringXY(X,Y+GetMaxY,TS);OutStringXY(X,Y,TS);end;
     end;
ShowTime:=TS;
End;

Procedure ShowWordRec(X,Y:word;C,BC:byte);
var DT:TimeType;TS:string;
Begin
DT[1]:=WR div 360000;WR:=WR-(DT[1]*360000);
DT[2]:=WR div 6000;WR:=WR-(DT[2]*6000);
DT[3]:=WR div 100;DT[4]:=WR-(DT[3]*100);
TS:=ConvertToTimeString(DT);
SetColor(C);SetTextBackColor(BC);SetTextOver(1);ROM_8x8;
OutStringXY(X,Y+GetDrawPic*GetMaxY,'WR:'+TS);
End;

Function WordRec(T1:TimeType):boolean;
var W1:longint;
Begin
W1:=((T1[1]*60+T1[2])*60+T1[3])*100+T1[4];
If W1<WR then begin WR:=W1;WordRec:=True;end else WordRec:=False;
End;


{****************************************************************************}
{***                    MySpriteType objektum met¢dusai                   ***}
{****************************************************************************}

Procedure TeknocType.SetInit;
Begin
Helyezes:=0;
End;

{****************************************************************************}
{***                       FutamType objektum met¢dusai                   ***}
{****************************************************************************}

Constructor FutamType.Init;
var I:word;
Begin
CelX:=588;Error:=0;K:=0;StartT[1]:=-1;ReplayRun:=False;
For I:=1 to MaxTeki do with Teki[I] do
 begin
 Init(10,(I-1)*(SPDY+10)+8,SPDX,SPDY,TekiShape[I,0]);
 If GetSpriteError<>0 then begin Error:=E_NoEnoughMem;Exit;end;
 end;
For I:=2 to MaxTeki do
 begin
 SetColor(144);Line(0,(I-1)*(SPDY+10),GetMaxX-1,(I-1)*(SPDY+10));
 SetColor(145);Line(0,(I-1)*(SPDY+10)+1,GetMaxX-1,(I-1)*(SPDY+10)+1);
 SetColor(146);Line(0,(I-1)*(SPDY+10)+2,GetMaxX-1,(I-1)*(SPDY+10)+2);
 SetColor(147);Line(0,(I-1)*(SPDY+10)+3,GetMaxX-1,(I-1)*(SPDY+10)+3);
 SetColor(148);Line(0,(I-1)*(SPDY+10)+4,GetMaxX-1,(I-1)*(SPDY+10)+4);
 end;
End;

Destructor FutamType.Done;
var I:word;
Begin
For I:=1 to MaxTeki do with Teki[I] do Done;
End;

Procedure FutamType.NewRun;
var I:word;
Begin
For I:=1 to MaxTeki do with Teki[I] do
 begin
 SetXY(2,(I-1)*(SPDY+10)+8);Speed(0,0);CheatV:=0;EC:=I;
 AnimD:=1;StartAnimF:=1;StopAnimF:=7;AnimD:=1;AnimF:=0;
 AnimTime:=1;AnimT:=0;AnimV:=0.25;
 Helyezes:=0;SpriteBitMap:=TekiShape[EC,AnimF];StartT[1]:=-1;
 end;
For I:=1 to MaxTeki do with Teki[I] do Show;
If WR<MaxLongint then ShowWordRec(WRX,WRY,1,7);
Change;
For I:=1 to MaxTeki do with Teki[I] do Show;
If WR<MaxLongint then ShowWordRec(WRX,WRY,1,7);
Change;
K:=0;SetVideoMem(0,0);ReplayM:=0;
End;

Procedure FutamType.EndRun;
var J,I:word;TS:string;Difft:TimeType;
Begin
TS:='                                                             ';
ShowWordRec(WRX,WRY,1,1);ShowTime(StartT,0,0,1,1,2,1,Difft);
SetTextBackColor(1);ROM_8x14;
For J:=1 to 2 do
 begin
 For I:=1 to MaxTeki do with Teki[I]
 do begin
    Hide;
    If not ReplayRun
     then begin
          OutStringXY(5,(I-1)*(SPDY+10)+3+SPDY div 2-5+GetDrawPic*GetMaxY,TS);
          OutStringXY(5,(I-1)*(SPDY+10)+3+SPDY div 2-5+GetDrawPic*GetMaxY+16,WRString);
          end;
    end;
 Change;
 end;
End;

Procedure FutamType.ShowStopper;
var Difft:TimeType;
Begin
ShowTime(StartT,0,0,1,7,2,1,Difft);
End;

Procedure FutamType.SetStartTime;
var I:word;TT:array[1..4] of word;
Begin
GetTime(TT[1],TT[2],TT[3],TT[4]);For I:=1 to 4 do StartT[I]:=TT[I];
End;

Function FutamType.Run:boolean;
var W,I:word;
Begin
If StartT[1]=-1 then SetStartTime;
Anim;Move;ShowStopper;Change;W:=0;
For I:=1 to MaxTeki do If Teki[i].Activ then Inc(W);
Run:=(K=W);
End;

Procedure FutamType.SetShape(II,KK:word);
Begin
with Teki[II] do begin SpriteBitMap:=TekiShape[EC,KK];Draw(X,Y);end;
End;

Procedure FutamType.Anim;
var I:word;
Begin
For I:=1 to MaxTeki do with Teki[I] do
 begin
 AnimT:=AnimT+AnimV;if VX>=0.6 then AnimV:=VX-0.6;
 If AnimT>AnimTime
  then begin Animation;SpriteBitMap:=TekiShape[EC,AnimF];AnimT:=0;end;
 end;
End;

Procedure FutamType.Move;
var I:word;KS,TS:string;Z:byte;Difft:TimeType;
Begin
For I:=1 to MaxTeki do with Teki[I]
 do begin
    If Helyezes=0
     then begin
          If ReplayRun
             then begin INC(ReplayM);Z:=Replay[ReplayM];end
             else begin
                  If CheatV=1 then Z:=10 else Z:=random(10);
                  If ReplayM<MaxReplayM
                   then begin INC(ReplayM);Replay[ReplayM]:=Z;end;
                  end;
          If (Z>5) and (VX<4) then VX:=VX+0.1;
          If (Z<2) and (VX>1) then VX:=VX-0.1;
          If (X>CelX)
           then begin
                Stop;Inc(K);Helyezes:=K;AnimD:=0;AnimF:=7+K;
                SpriteBitMap:=TekiShape[EC,AnimF];
                Str(K,KS);TS:=ShowTime(StartT,0,0,15,1,0,2,Difft);
                TS:=TSString[1]+' '+TS+'  -  '+TSString[2]+' '+KS+'.';
                SetColor(7);SetTextBackColor(1);SetTextOver(1);
                If not ReplayRun
                 then begin
                      If K=1 then If WordRec(Difft)
                         then begin
                              ROM_8x8;SetColor(15);
                              OutStringXY(5,(I-1)*(SPDY+10)+3+SPDY div 2-5+16,WRString);
                              OutStringXY(5,(I-1)*(SPDY+10)+3+SPDY div 2-5+GetMaxY+16,WRString);
                              end;
                      ROM_8x14;
                      OutStringXY(5,(I-1)*(SPDY+10)+3+SPDY div 2-5,TS);
                      OutStringXY(5,(I-1)*(SPDY+10)+3+SPDY div 2-5+GetMaxY,TS);
                      end;
                end;
          end;
    Move;
    end;
End;

{****************************************************************************}
{***                             LoadSprites                               ***}
{****************************************************************************}

Function InitSpriteShapeMem:word;
var J,I,K:word;
Begin
For K:=1 to MaxTeki do For I:=0 to TekiShapeNum do
 begin
 If MaxAvail<SizeOf(TeknocShapeType)
  then begin InitSpriteShapeMem:=E_NoEnoughMem;Exit;end;
 New(TekiShape[K,I]);
 end;
InitSpriteShapeMem:=0;
End;

Function DoneSpriteShapeMem:word;
var K,I:word;
Begin
For K:=1 to MaxTeki do For I:=0 to TekiShapeNum do Dispose(TekiShape[K,I]);
DoneSpriteShapeMem:=0;
End;

Procedure SetSpriteShape(K,X,Y:word);
var I,J:word;Z:word;
Begin
For I:=1 to 47 do For J:=1 to 47
 do TekiShape[1,K]^[J,I]:=GetPixel(I+(X-1)*SPDX-1,J+(Y-1)*SPDY+GetMaxY*2);
End;

Procedure SetAllSpriteShape;
var I,J,K,L:word;
Begin
For K:=2 to MaxTeki do For L:=0 to TekiShapeNum do
 For I:=1 to 47 do For J:=1 to 47
  do If (TekiShape[1,L]^[J,I]>31)
      then iF FEX<0
           then TekiShape[K,L]^[J,I]:=TekiShape[1,L]^[J,I]+(K-1)*16
           else TekiShape[K,L]^[J,I]:=TekiShape[1,L]^[J,I]+FEX*16
      else TekiShape[K,L]^[J,I]:=TekiShape[1,L]^[J,I];
If FEX>-1
 then For L:=0 to TekiShapeNum do For I:=1 to 47 do For J:=1 to 47
       do If (TekiShape[1,L]^[J,I]>31)
         then TekiShape[1,L]^[J,I]:=TekiShape[1,L]^[J,I]+FEX*16;
End;

Function LoadSpritesShapes:word;
var X,Y,I,FW:word;Line:array[0..329] of byte;P:array[1..768] of byte;
Begin
If InitSpriteShapeMem<>0 then begin LoadSpritesShapes:=E_NoEnoughMem;Exit;end;
FW:=OpenFile(TekiFileName,0);
LoadSpritesShapes:=IOError;If IOError<>0 then Exit;
ReadFile(FW,P,768);
LoadSpritesShapes:=IOError;If IOError<>0 then Exit;
SetPalette(0,255,P);
Y:=GetMaxY*2+1;
For I:=1 to 329 do
 begin
 ReadFile(FW,Line,329);
 LoadSpritesShapes:=IOError;If IOError<>0 then Exit;
 For X:=1 to 329 do If Line[x]>1 then PutPixel(X,Y,Line[x]);Y:=Y+1;
 end;
CloseFile(FW);
SetSpriteShape(8,4,5);
SetSpriteShape(9,3,1);
SetSpriteShape(10,6,2);
SetSpriteShape(11,1,1);
SetSpriteShape(12,5,7);
SetSpriteShape(13,2,4);
SetSpriteShape(14,5,3);
SetSpriteShape(15,4,7);

SetSpriteShape(0,4,1);
SetSpriteShape(1,1,5);
SetSpriteShape(2,2,5);
SetSpriteShape(3,3,5);
SetSpriteShape(4,4,5);
SetSpriteShape(5,5,5);
SetSpriteShape(6,6,5);
SetSpriteShape(7,7,5);
{SetVideoMem(0,GetMaxY*2);readln;SetVideoMem(0,0);}
SetAllSpriteShape;
End;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}

BEGIN
END.