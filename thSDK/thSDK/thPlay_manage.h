#include "axdll.h"
#include "../include/libthSDK.h"

//-----------------------------------------------------------------------------
typedef struct TPlayManggeParam
{
  H_THREADLOCK Lock;
  int Isp2pInit;
#define MAX_MANAGE_PLAY_COUNT  256
  //int IsForeground;//Background=0 Foreground=1
  //int NetWorkType;//TYPE_NONE=-1 TYPE_MOBILE=0 TYPE_WIFI=1
  int iPlayCount;
  int iP2PCount;
  struct
  {
    HANDLE NetHandle;
    u64 SN;
    int Isp2pConn;
  } Lst[MAX_MANAGE_PLAY_COUNT];

} TPlayManggeParam;
TPlayManggeParam PlayLst;
//-----------------------------------------------------------------------------
bool PlayLstAdd(u64 SN, char* IPUID)
{
  int i, Isp2pConn, IsFind = false;
  int Result = false;

  if (PlayLst.iPlayCount == 0)
  {
    ThreadLockInit(&PlayLst.Lock);
  }

  ThreadLock(&PlayLst.Lock);

  Isp2pConn = (!(IsValidIP(IPUID) || IsValidHost(IPUID))) && (strlen(IPUID) == 20);

  PRINTF("%s(%d) SN:%s IPUID:%s Isp2pConn:%d\n", __FUNCTION__, __LINE__, SN, IPUID, Isp2pConn);

  for (i = 0; i < MAX_MANAGE_PLAY_COUNT; i++)
  {
    if (PlayLst.Lst[i].SN == SN)
    {
      //PlayLst.Lst[i].NetHandle = NetHandle;
      PlayLst.Lst[i].Isp2pConn = Isp2pConn;
      PlayLst.iPlayCount = PlayLst.iPlayCount;
      PlayLst.iP2PCount = PlayLst.iP2PCount;
      IsFind = true;
      break;
    }
  }

  if (IsFind == false)
  {
    for (i = 0; i < MAX_MANAGE_PLAY_COUNT; i++)
    {
      if (PlayLst.Lst[i].SN == 0x00)
      {
        PlayLst.Lst[i].SN = SN;
        //PlayLst.Lst[i].NetHandle = NetHandle;
        PlayLst.Lst[i].Isp2pConn = Isp2pConn;
        PlayLst.iPlayCount  = PlayLst.iPlayCount + 1;
        if (PlayLst.Lst[i].Isp2pConn)
        {
          if (PlayLst.iP2PCount == 0) P2P_Init();
          PlayLst.iP2PCount = PlayLst.iP2PCount + 1;
        }
        IsFind = true;
        break;
      }
    }
  }

  ThreadUnlock(&PlayLst.Lock);

  return IsFind;
}
//-----------------------------------------------------------------------------
bool PlayLstDel(u64 SN)
{
  int i, Result = false;

  ThreadLock(&PlayLst.Lock);
  PRINTF("%s(%d) SN:%s iPlayCount:%d iP2PCount:%d\n", __FUNCTION__, __LINE__, SN, PlayLst.iPlayCount, PlayLst.iP2PCount);
  for (i = 0; i < MAX_MANAGE_PLAY_COUNT; i++)
  {
    if (PlayLst.Lst[i].SN == 0x00) continue;
    if (PlayLst.Lst[i].SN == SN)
    {
      PlayLst.Lst[i].SN = 0x00;
      PlayLst.Lst[i].NetHandle = NULL;
      PlayLst.iPlayCount = PlayLst.iPlayCount - 1;
      if (PlayLst.Lst[i].Isp2pConn)
      {
        PlayLst.Lst[i].Isp2pConn = false;
        PlayLst.iP2PCount = PlayLst.iP2PCount - 1;
        if (PlayLst.iP2PCount == 0) P2P_Free();
      }
      Result = true;
    }
  }
  ThreadUnlock(&PlayLst.Lock);

  if (PlayLst.iPlayCount == 0)
  {
    ThreadLockFree(&PlayLst.Lock);
  }
  return Result;
}
//-----------------------------------------------------------------------------
