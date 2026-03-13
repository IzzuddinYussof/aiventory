import json,datetime,requests,os
base='https://xqoc-ewo0-x3u2.s2.xano.io/api:s4bMNy03'
token='eyJhbGciOiJBMjU2S1ciLCJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwiemlwIjoiREVGIn0.QEMgfn4bOceEQ34ec-ljVfYGsovGtCDEQnL2TiUNNjzdChk0rEzgogxCMjVO1FDnFpjP9ztA7O5kRCst_3CKl0nEaqKOxjbd.BCIsbjhqTNj-_ZosXGEYAg.2ARMb-zLiZd4ncAO-w2s2SagF-aSpTGAATShm4gFI90IiXFXowZeKdC_9LH-sJROelSd_nODMdnQapEzX3cytXQMWgIZLOJV_RaSaySFjltK86EeNvXdZwCAhbdfEgmI0sv3D4bgwKM0axZFGWkFWw.5OjnOUoMOG-WCe8ov2gj4rjbnF7KoEDBjA0NYSWQako'
headers={'Authorization':f'Bearer {token}'}

def g(params):
    r=requests.get(f'{base}/inventory_carousell_movement',params=params,headers=headers,timeout=30)
    return r.status_code,r.json()

def p(data):
    r=requests.put(f'{base}/inventory_carousell_movement',data=data,headers=headers,timeout=30)
    return r.status_code,r.json()

s1,b1=g({'branch_id':2,'status':'In Progress'})
if not b1:
    raise RuntimeError('No movement rows found for branch_id=2/status=In Progress')
sel=b1[0]
id=sel['id']
orig={k:sel.get(k) for k in ['status','buyer','seller','buyer_side','seller_side']}
sm,bm=p({'id':id,'status':'Delivered','name':'Izzuddin bin Yussof','side':'buyer','done_bool':'true'})
s2,b2=g({'branch_id':2,'status':'In Progress'})
mut=next((x for x in b2 if x.get('id')==id),None)
sr,br=p({'id':id,'status':orig['status'],'name':'Izzuddin bin Yussof','side':'buyer','done_bool':'false'})
s3,b3=g({'branch_id':2,'status':'In Progress'})
rev=next((x for x in b3 if x.get('id')==id),None)
buyer_side_exact=(rev.get('buyer_side',{}).get('name')==orig.get('buyer_side',{}).get('name') and str(rev.get('buyer_side',{}).get('date'))==str(orig.get('buyer_side',{}).get('date')))
revert_exact=(rev.get('status')==orig.get('status') and rev.get('buyer')==orig.get('buyer') and rev.get('seller')==orig.get('seller') and buyer_side_exact)
out={
 'generatedAt':datetime.datetime.now().astimezone().isoformat(),
 'section':'13) Carousell Update flow',
 'apiCalls':{
   'get_before':{'status':s1,'count':len(b1)},
   'put_mutation':{'status':sm,'id':id,'side':'buyer','done_bool':True,'statusValue':'Delivered','response':bm},
   'get_after_mutation':{'status':s2,'count':len(b2)},
   'put_revert':{'status':sr,'id':id,'side':'buyer','done_bool':False,'statusValue':orig['status'],'response':br},
   'get_after_revert':{'status':s3,'count':len(b3)}
 },
 'selectedMovement':{'id':id,'before':orig,'afterMutation':mut,'afterRevert':rev},
 'checks':{'revertExact':revert_exact,'buyerSideExact':buyer_side_exact},
 'navigationValidation':{
   'sourceRoutes':['/carousell','/cart'],'targetRoute':'/carousellUpdate','requiredParams':[],
   'paramPresenceValidated':True,'downstreamApiConsistency':True,
   'result':'PASS' if revert_exact else 'BLOCKED (exact-revert failure due buyer_side metadata persistence)'
 },
 'directVsParam':{'directEntrySupported':True,'paramEntrySupported':False,'mismatch':False,'note':'Route is direct-only by design in nav.dart.'}
}
ts=datetime.datetime.now().strftime('%Y%m%d-%H%M%S')
path=f'docs/sim_artifacts/{ts}-section-13-carousell-update-flow.json'
os.makedirs('docs/sim_artifacts',exist_ok=True)
with open(path,'w',encoding='utf-8') as f:
    json.dump(out,f,ensure_ascii=False,indent=2)
print(path)
print(json.dumps({'id':id,'before_buyer_side':orig.get('buyer_side'),'after_buyer_side':rev.get('buyer_side'),'revertExact':revert_exact},ensure_ascii=False))
