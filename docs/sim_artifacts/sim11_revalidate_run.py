import json, datetime, pathlib
import requests

base_car='https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03'
# Reuse validated token from successful section-1 run artifact (masked in reports).
token='eyJhbGciOiJBMjU2S1ciLCJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiemlwIjoiREVGIn0.QEMgfn4bOceEQ34ec-ljVfYGsovGtCDEQnL2TiUNNjzdChk0rEzgogxCMjVO1FDnFpjP9ztA7O5kRCst_3CKl0nEaqKOxjbd.BCIsbjhqTNj-_ZosXGEYAg.2ARMb-zLiZd4ncAO-w2s2SagF-aSpTGAATShm4gFI90IiXFXowZeKdC_9LH-sJROelSd_nODMdnQapEzX3cytXQMWgIZLOJV_RaSaySFjltK86EeNvXdZwCAhbdfEgmI0sv3D4bgwKM0axZFGWkFWw.5OjnOUoMOG-WCe8ov2gj4rjbnF7KoEDBjA0NYSWQako'
headers={'Authorization':f'Bearer {token}'}
s=requests.Session()

def g(q):
    r=s.get(base_car+'/inventory_carousell', params=q, headers=headers, timeout=30)
    code=r.status_code
    r.raise_for_status()
    data=r.json()
    return code,data

code_d, default=g({'inventory_ids':'[]','name':'','category':''})
code_f, filtered=g({'inventory_ids':'[]','name':'DICLO','category':'BUR'})
code_p, probe=g({'inventory_ids':'[1357]','name':'','category':''})
code_c, category=g({'inventory_ids':'[]','name':'','category':'BUR'})

ts=datetime.datetime.now().strftime('%Y%m%d-%H%M%S')
artifact_rel=f'docs/sim_artifacts/{ts}-section-11-upload-carousell-flow.json'
artifact={
  'timestamp':datetime.datetime.now(datetime.timezone.utc).astimezone().isoformat(),
  'section':'11) Upload Carousell flow',
  'mode':'read-only revalidation',
  'apis':{
    'carousell_default':{'method':'GET','endpoint':'/inventory_carousell','query':'inventory_ids=[]&name=&category=','status':code_d,'count':len(default)},
    'carousell_filtered':{'method':'GET','endpoint':'/inventory_carousell','query':'inventory_ids=[]&name=DICLO&category=BUR','status':code_f,'count':len(filtered)},
    'carousell_inventory_probe':{'method':'GET','endpoint':'/inventory_carousell','query':'inventory_ids=[1357]&name=&category=','status':code_p,'count':len(probe),'topIds':[i.get('id') for i in probe[:8]]},
    'carousell_category_only':{'method':'GET','endpoint':'/inventory_carousell','query':'inventory_ids=[]&name=&category=BUR','status':code_c,'count':len(category)}
  },
  'navigationValidation':{
    'sourceRoute':'/carousell','targetRoute':'/uploadCarousell','sourcePushNamedWithoutParams':True,
    'targetRequiredParams':['inventoryId:int','category:String','search:String','searchCategory:String'],
    'targetRuntimeForceUnwrapInventoryId':True,
    'downstreamPayloadConsistencyParamMode':True,
    'result':'BLOCKED'
  },
  'directVsParam':{'directEntrySupported':False,'paramEntrySupported':True,'mismatch':True,'note':'Direct route omits required runtime param inventoryId; param mode maps inventoryId to upload payload.'},
  'mutation':{'executed':False,'reason':'Skipped due unrevertable inventory_carousell create contract (no app-exposed delete/update endpoint).'}
}
path=pathlib.Path(artifact_rel)
path.write_text(json.dumps(artifact,indent=2),encoding='utf-8')
print('ARTIFACT='+artifact_rel)
print('DEFAULT_COUNT='+str(len(default)))
print('FILTERED_COUNT='+str(len(filtered)))
print('PROBE_COUNT='+str(len(probe)))
print('CATEGORY_COUNT='+str(len(category)))
print('TOP_IDS='+','.join(str(i.get('id')) for i in probe[:8]))
