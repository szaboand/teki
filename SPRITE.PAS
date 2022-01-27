Unit Sprite;
{****************************************************************************}
{***                                                                      ***}
{***                              Sprite Unit V1.0b                       ***}
{***                           2000.06.18.-2000.06.28.                    ***}
{***               (C) TwinNet Ltd 1997,2000 (P) Szabo Andras 2000        ***}
{***                  E-mail: szaboand@mail.petrikl.sulinet.hu            ***}
{***                       WWW: www.twinnet.hu/szaboand                   ***}
{***                            All Rights Reserved                       ***}
{***                                                                      ***}
{****************************************************************************}
{***                            DOS VERZIà                                ***}
{***                     TURBO PASCAL 7.0 UNIT FILE                       ***}
{****************************************************************************}


Interface

Type
    SpriteType  = object
     RealX,RealY  : real;       { Sprite X,Y val¢s koordin ta           }
     X,Y          : word;       { Sprite X,Y koordin ta                 }
     DX,DY        : word;       { Sprite sz‚less‚ge/magass ga           }
     VX,VY        : real;       { Sprite X,Y ir ny£ sebess‚ge           }
     SpriteBitmap : pointer;    { Sprite bitmap mutat¢                  }
     EC           : integer;    { Sprite szin eltolas                   }

     SpriteBackP  : array [0..1] of pointer; { Sprite A/B k‚p h tter‚nek ment‚se}
     OX,OY        : array [0..1] of word;    { Sprite el”z‹ koordin ta   }
     Pic          : array [0..1] of word;    { A/B k‚p kezd‹c¡me         }

     Activ        : boolean;                 { Akt¡v-e a sprite          }

     AnimT        : real;                    { Anim ci¢s id‹sz ml l¢     }
     AnimTime     : real;                    { Anim ci¢s id‹             }
     AnimV        : real;                    { Anim ci¢s sebess‚g        }
     AnimF        : word;                    { Aktu lis anim ci¢s f zis  }
     StartAnimF   : word;                    { Kezd‹ anim ci¢s f zis     }
     StopAnimF    : word;                    { V‚gs‹ anim ci¢s f zis     }
     AnimD        : byte;                    { Anim ci¢s ir ny           }

     Constructor Init(_X,_Y,_DX,_DY:word;_SpriteBitMap:pointer);
     Destructor  Done;
     Procedure   SetInit;virtual;
     Procedure   SetXY(_X,_Y:word);
     Procedure   Speed(_VX,_VY:real);

     Procedure   Draw(XX,YY:word);
     Procedure   Show;
     Procedure   Hide;
     Procedure   Move;
     Procedure   Animation;
     Procedure   Stop;
     end;
{****************************************************************************}

 Procedure Change;
 Function  GetSpriteError:word;
 Function  GetDrawPic:word;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}

Implementation

Uses TWSys{V2.0c};

Const
 DrawPic        : word          = 1; { 0/1: A k‚p/B k‚p rajzol sa }
 VRelX          : word          = 0; { Relat¡v X eltol s }
 VRelY          : word          = 0; { Relat¡v Y eltol s }

 SpriteError    : word          = 0; { Hibak¢d           }
 E_NoEnoughMemory               = 1;

{****************************************************************************}
{***                                Change                                ***}
{****************************************************************************}

Procedure Change;
Begin
SetVideoMem(VRelX,DrawPic*GetMaxY+VRelY);WaitPic;
If DrawPic=0 then DrawPic:=1 else DrawPic:=0;
End;

Function  GetSpriteError:word;
Begin
GetSpriteError:=SpriteError;
End;

Function  GetDrawPic:word;
Begin
GetDrawPic:=DrawPic;
End;

{****************************************************************************}
{***                           Seg‚delj r sok                             ***}
{****************************************************************************}

Procedure VideoDone(Msg:string);
Begin
Asm mov  ax,0003h;int 10h End;WriteLn(Msg);
End;

Procedure ShowShapeFromMem(X,Y,DX,DY:word;P:pointer);
Begin
CopyFromMem(X+VRelX,Y+VRelY,DX,DY,DX,P^);
End;

Procedure GetShapeFromMem(X,Y,DX,DY:word;P:pointer);
Begin
CopyToMem(X+VRelX,Y+VRelY,DX,DY,DX,P^);
End;

{****************************************************************************}
{***                         SpriteType met¢dusok                         ***}
{****************************************************************************}

Constructor SpriteType.Init;
Begin
SpriteError:=0;
X:=_X;Y:=_Y;DX:=_DX;DY:=_DY;RealX:=X;RealY:=Y;VX:=0;VY:=0;
SpriteBitMap:=_SpriteBitMap;Pic[0]:=0;Pic[1]:=GetMaxY;
AnimF:=0;AnimD:=0;Activ:=True;AnimTime:=0;AnimT:=1;AnimV:=1;EC:=1;
If MaxAvail<2*((DX+1)*(DY+1)) then begin SpriteError:=E_NoEnoughMemory;Exit;end;
GetMem(SpriteBackP[0],(DX+1)*(DY+1));GetMem(SpriteBackP[1],(DX+1)*(DY+1));
SetInit;
End;

Procedure SpriteType.SetInit;
Begin
End;

Destructor SpriteType.Done;
Begin
FreeMem(SpriteBackP[0],DX*DY);FreeMem(SpriteBackP[1],DX*DY);
End;

Procedure SpriteType.SetXY(_X,_Y:word);
Begin
X:=_X;Y:=_Y;RealX:=X;RealY:=Y;
End;

Procedure SpriteType.Speed(_VX,_VY:real);
Begin
VX:=_VX;VY:=_VY;
End;

Procedure SpriteType.Draw(XX,YY:word);
var J:word;PP:^byte;
Begin
If not Activ then Exit;
{PP:=SpriteBitMap;For J:=1 to DX*DY do begin If PP^>31 then PP^:=PP^+EC*16;INC(PP);end;}
ShowShapeFromMem(XX,YY,DX,DY,SpriteBitMap);
{PP:=SpriteBitMap;For J:=1 to DX*DY do begin If PP^>31 then PP^:=PP^-EC*16;INC(PP);end;}
End;

Procedure SpriteType.Show;
Begin
If not Activ then Exit;
GetShapeFromMem(X,Y+Pic[DrawPic],DX,DY,SpriteBackP[DrawPic]);
Draw(X,Y+Pic[DrawPic]);
OX[DrawPic]:=X;OY[DrawPic]:=Y;
End;

Procedure SpriteType.Hide;
Begin
If not Activ then Exit;
ShowShapeFromMem(OX[DrawPic],OY[DrawPic]+Pic[DrawPic],DX,DY,SpriteBackP[DrawPic]);
End;

Procedure SpriteType.Move;
var TMP:byte;
Begin
If not Activ then Exit;
Hide;
RealX:=RealX+VX;RealY:=RealY+VY;X:=trunc(RealX);Y:=trunc(RealY);
Show;
End;

Procedure SpriteType.Animation;
begin
If not Activ then Exit;
If AnimD=0 then Exit;
If AnimD=1
 then If AnimF>=StopAnimF  then AnimD:=2 else Inc(AnimF)
 else If AnimF<=StartAnimF then AnimD:=1 else Dec(AnimF);
end;

Procedure SpriteType.Stop;
Begin
If not Activ then Exit;
Speed(0,0);
End;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}

BEGIN
END.