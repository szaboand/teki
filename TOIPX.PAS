Unit TOIPX;

{*****************************************************************************
******************************************************************************
*                        TOIPX 1.1b (02) Verzi¢                              *
*                       1999.04.28. - 200.01.21.                             *
*                        Szab¢ Andr s 1984-2000                              *
*                        (C) TwinNet  1995-2000                              *
******************************************************************************
*****************************************************************************}

Interface

Uses TWSys{V2.0b};

{****************************************************************************}
{***                            Konstansok                                ***}
{****************************************************************************}

Const
 MaxRPacketNum                   = 4;
 PacketPufferSize                = 250;
 IPXError       : word           = 0000;

{****************************************************************************}
{***                       T¡pusok, objektumok                            ***}
{****************************************************************************}

Type
 PufferType     = array [0..PacketPufferSize] of byte;

 O_IPXType      = object
   MyIPXAddress   : IPXAddressType;
   MySocket       : word;
   FragmentNum    : byte;
   SPacket        : ECBType;
   SHeader        : IPXHeaderType;
   RPacketNum     : byte;
   RPacket        : array [1..MaxRPacketNum] of ECBType;
   RHeader        : array [1..MaxRPacketNum] of IPXHeaderType;
   SPuffer        : PufferType;
   RPuffer        : array [1..MaxRPacketNum] of PufferType;
   CIR            : ConnInfo;
   UserName       : string;
   NickName       : string;
   PutSender      : boolean;

  private
   Function       _InitReceivePacket(K:word):word;
   Function       _InitAllReceivePacket:word;
  public
   Constructor    Init(SocketNum:word);
   Destructor     Done;
   Procedure      SendPacket(S:String;Address:IPXAddressType);
   Procedure      SendPacketToNetwork(S:String);
   Procedure      SendPacketToAll(S:String);
   Procedure      GetPacket;
   Procedure      ReceivePacketProcess(K:word);virtual;
 end;


{****************************************************************************}
{****************************************************************************}
{****************************************************************************}

Implementation

Constructor O_IPXType.Init(SocketNum:word);
var I:byte;
Begin
If InitIPX=0 then begin IPXError:=1;Exit;end;
GetIPXAddress(MyIPXAddress);MySocket:=ReverseWord(SocketNum);
FragmentNum:=2;RPacketNum:=MaxRPacketNum;
IPXError:=OpenIPXSocket(MySocket,OpenSocket_Close_Or_Terminate);
If IPXError<>0 then Exit;
_InitAllReceivePacket;
UserInfo(LocalConnectionNumber,CIR);i:=1;UserName:='';PutSender:=False;
While CIR.OBJECTNAME[I]<>0
      do begin UserName:=UserName+(Chr(ciR.OBJECTNAME[I]));Inc(I);end;
NickName:=UserName;
End;

Destructor O_IPXType.Done;
Begin
CloseIPXSocket(MySocket);
End;

Function O_IPXType._InitReceivePacket(K:word):word;
Begin
with RPacket[K] do
     begin
     SocketNumber:=MySocket;ESR:=0;FragmentCount:=FragmentNum;
     FragmentData[1].Address:=@RHeader[K];FragmentData[1].Size:=SizeOf(IPXHeaderType);
     FragmentData[2].Address:=@RPuffer[K];FragmentData[2].Size:=SizeOf(RPuffer);
     end;
_InitReceivePacket:=ListenForIPXPacket(RPacket[K]);
End;

Function O_IPXType._InitAllReceivePacket:word;
var I:word;
Begin
I:=1;
repeat
      IPXError:=_InitReceivePacket(I);I:=I+1;
until (I>RPacketNum) or (IPXError<>0);
_InitAllReceivePacket:=IPXError;
End;

Procedure O_IPXType.SendPacket(S:String;Address:IPXAddressType);
var I:word;
Begin
SHeader.DestAddress:=Address;
For i:=0 to 5 do SPacket.ImmediateNodeAddress[i]:=Address.NodeNumber[i];
SHeader.DestSocket:=MySocket;
SPAcket.SocketNumber:=MySocket;
SPacket.ESR:=0;Sheader.PacketType:=4;
SPacket.FragmentCount:=FragmentNum;
SPacket.FragmentData[1].Address:=@SHeader;
SPacket.FragmentData[1].Size:=SizeOf(IPXHeaderType);
SPacket.FragmentData[2].Address:=@SPuffer;
SPacket.FragmentData[2].Size:=SizeOf(SPuffer);
If PutSender then S:=NickName+':'+S;SPuffer[0]:=length(S);
For I:=1 to Length(S) do SPuffer[I]:=Ord(S[I]);
SendIPXPacket(SPacket);
End;

Procedure O_IPXType.SendPacketToNetwork(S:String);
Begin
SendPacket(S,BroadcastNetworkIPXAddress);
End;

Procedure O_IPXType.SendPacketToAll(S:String);
Begin
SendPacket(S,BroadcastIPXAddress);
End;

Procedure O_IPXType.GetPacket;
var j:word;
Begin
IPXRelenquishControl;
For j:=1 to RPacketNum do
    If RPacket[j].InUseFlag=0
       then begin ReceivePacketProcess(J);_InitReceivePacket(j);end;
End;

Procedure O_IPXType.ReceivePacketProcess(K:word);
Begin
End;

{****************************************************************************}
{****************************************************************************}
{****************************************************************************}

BEGIN
END.