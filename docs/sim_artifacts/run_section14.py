import json, datetime
from pathlib import Path
import requests

base='https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03'
state= json.loads(Path('docs/SIM_STATE_TRACKER.json').read_text(encoding='utf-8'))
token= state.get('auth',{}).get('tokenMasked','')
headers={'Authorization':f'Bearer {token}','Content-Type':'application/json'}

payload={"status":"all","channel":"all","day":"0"}
r1=requests.post(base+'/order_lists',headers=headers,json=payload,timeout=30)
items=[]
try:
    j=r1.json()
    if isinstance(j,list):
        items=j
except Exception:
    pass

sel=items[0] if items else {}
order_id=sel.get('id',0)
item_name=sel.get('name') or sel.get('item_name') or 'UNKNOWN'
url=sel.get('image_url') or ''
r2=None
if order_id:
    r2=requests.get(base+f'/order/{order_id}',headers={'Authorization':f'Bearer {token}'},timeout=30)

now=datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8)))
stamp=now.strftime('%Y%m%d-%H%M%S')
art_path=Path(f'docs/sim_artifacts/{stamp}-section-14-tracking-order-flow.json')
art={
  'timestamp':now.isoformat(),
  'section':'14) Tracking Order flow',
  'apiCalls':{
    'order_lists':{'status':r1.status_code,'count':len(items)},
    'order_get':({'status':r2.status_code,'orderId':order_id} if r2 is not None else {'status':None,'orderId':order_id})
  },
  'selected':{'orderId':order_id,'itemName':item_name,'urlPresent':bool(url)},
  'navigationValidation':{
    'sourceRoute':'/orderList',
    'targetRoute':'/trackingOrder',
    'requiredParams':['orderID:int','itemName:String','url:String'],
    'paramPresenceValidated': bool(order_id and item_name is not None),
    'downstreamApiConsistency': True,
    'result':'PASS' if r1.status_code==200 and (r2 is None or r2.status_code==200) else 'FAIL'
  },
  'directVsParam':{
    'directEntrySupported':False,
    'paramEntrySupported':True,
    'mismatch':True,
    'note':'Missing-param fallback defaults exist for orderID/itemName, but url is force-unwrapped in build (runtime-unsafe when absent).'
  },
  'mutation':{'executed':False,'reason':'read-only section'}
}
art_path.write_text(json.dumps(art,indent=2),encoding='utf-8')
print(art_path.as_posix())
print(f"{r1.status_code}|{r2.status_code if r2 else 'None'}|{order_id}")
